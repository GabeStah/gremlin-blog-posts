class Note < Liquid::Block

  @@icons = {
    'note'    => 'fa-check-square',
    'info'    => 'fa-info-circle',
    'warning' => 'fa-exclamation-circle',
    'error'   => 'fa-exclamation-triangle'
  }

  def initialize (tag_name, markup, tokens)
    super
    bind_params(eval("{#{markup}}"))
  end

  def bind_params (params)
    @title = params[:title]
    @type = params[:type]
  end

  def render (context)
    converter = context.registers[:site].find_converter_instance(::Jekyll::Converters::Markdown)
    content = converter.convert(super(context))
    header = @title && !@title.blank? ? "<p class=\"header\">#{@title}</p>" : ""
    # "<div class=\"premonition #{@type}\">
    #    <div class=\"fa #{@@icons[@type]}\"></div>
    #    <div class=\"content\">
    #      #{header}
    #      #{content}
    #    </div>
    #  </div>"
    <<~NOTE
    <div class="premonition #{@type}">
      <div class="fa #{@@icons[@type]}"></div>
      <div class="content">
        #{header}
        #{content}
      </div>
    </div>
    NOTE
  end
end

Liquid::Template.register_tag('note', Note)