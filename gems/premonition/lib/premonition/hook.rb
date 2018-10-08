module Jekyll
  module Premonition
    class Hook < Generator
      safe true
      priority :lowest

      def initialize(p)
        super(p)
      end

      def generate(site)
        @resources = Resources.new site.config
        Hooks.register [:documents, :pages], :pre_render do |doc|
          adder(doc)
        end
      end

      # def adder(doc)
      #   o = []
      #   b = nil
      #   doc.content.each_line do |l|
      #     if blockquote?(l) && empty_block?(b)
      #       if (m = l.match(/^\>\s+([a-z]+)\s+\"(.*)\"$/i))
      #         y, t = m.captures
      #         b = { 'title' => t.strip, 'type' => y.strip.downcase, 'content' => [] }
      #       else
      #         o << l
      #       end
      #     elsif blockquote?(l) && !empty_block?(b)
      #       b['content'] << l.match(/^\>\s?(.*)$/i).captures[0]
      #     else
      #       if !blockquote?(l) && !empty_block?(b)
      #         o << render_block(b)
      #         b = nil
      #       end
      #       o << l
      #     end
      #   end
      #   o << render_block(b) unless empty_block?(b)
      #   doc.content = o.join
      # end

      def adder(doc)
        debug = false
        doc.path == "/chaos-monkey/advanced-tips" ? debug = true : debug = false
        o = []
        b = nil
        spacing = nil
        doc.content.each_line do |l|
          if blockquote?(l) && empty_block?(b)
            if (m = l.match(/^(\s*)\>\s+([a-z]+)\s+\"(.*)\"$/i))
              spacing, y, t = m.captures
              #puts "------- '#{t}' spacing #: #{spacing.length} -------"
              b = { 'title' => t.strip, 'type' => y.strip.downcase, 'content' => [], 'spacing' => spacing }
            else
              o << l
            end
          elsif blockquote?(l) && !empty_block?(b)
            #b['content'] << l.match(/^\s*\>\s?(.*)$/i).captures[0]
            spacing, match = l.match(/^(\s*)\>\s?(.*)$/i).captures
            b['content'] << match            
            # if debug 
            #   puts "Spacing: #{spacing.length}"
            #   puts "Match: #{match}"
            # end


            # if match.empty?
            #   b['content'] << ""
            # else
            #   b['content'] << "#{match}"
            # end


            
            # if debug
            #   puts b['content']
            # end
          else
            if !blockquote?(l) && !empty_block?(b)
              o << render_block(b)
              b = nil
            end
            o << l
          end
        end
        o << render_block(b) unless empty_block?(b)
        doc.content = o.join
        # if debug
        #   puts doc.content
        # end
      end      

      # def blockquote?(l)
      #   l.strip.start_with?('>')
      # end

      def blockquote?(l)
        # Reverse nonexistence.
        !l.match(/^\s*\>/i).nil?
      end

      def empty_block?(b)
        b.nil?
      end

      def render_block(b)
        t = create_resource(b)
        #c = "#{@resources.markdown.convert(b['content'].join("\n"))}\n\n"
        c = "#{@resources.markdown.convert(b['content'].join("\n"))}"
        #puts c
        #c = "#{@resources.markdown.convert(b['content'].join("\n"))}"
        # puts b['content'].class
        # puts b['content'].join("\n").class
        # c = "#{@resources.markdown.convert(b['content'])}"
        template = Liquid::Template.parse(t['template'], error_mode: :strict)
        #puts c
        r = template.render(
          {
            'header' => !t['title'].nil?,
            'title' => t['title'],
            # Strip additional spacing before including in template, to prevent extraneous <div>.
            'content' => c.strip,
            'type' => b['type'],
            'meta' => t['meta'],
            'spacing' => t['spacing']
          },
          strict_variables: true
        )
        # Add back additional spacing after template HTML created, for further markdown line processing.
        r += "\n\n"
        #puts r
        r
      end

      def create_resource(b)
        c = {
          'template' => @resources.config['default']['template'],
          'title' => @resources.config['default']['title'],
          'meta' => @resources.config['default']['meta'],
          'spacing' => @resources.config['default']['spacing']
        }
        @resources.config['types'].each do |id, t|
          next unless id == b['type']
          c['title'] = b['title'].empty? || b['title'].nil? ? t['default_title'] : b['title']
          c['template'] = t['template'] unless t['template'].nil?
          c['meta'] = c['meta'].merge(t['meta']) unless t['meta'].nil?
          c['spacing'] = b['spacing'].empty? || b['spacing'].nil? ? '' : b['spacing']
        end
        c
      end
    end
  end
end
