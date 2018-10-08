class Admonition < Liquid::Block

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
    <<~ADMONITION
    <div class="admonition #{@type}">
      <p class="admonition-#{@title}"></p>
      <p>#{content}</p>
    </div>
    ADMONITION
  end
end

Liquid::Template.register_tag('admonition', Admonition)