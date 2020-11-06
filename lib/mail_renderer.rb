# frozen_string_literal: true

##
# Mail Renderer: renders ERB templates from app/mail into mail
# body
class MailRenderer
  def initialize(templates_root: 'app/mail/', renderer: ERB)
    @templates_root = templates_root
    @renderer = renderer
  end

  def render(template, locals = {})
    renderer.new(file(template)).result_with_hash(locals)
  end

  private

  attr_reader :templates_root, :renderer

  def file(template)
    File.read(File.join("#{templates_root}/#{template}.erb"))
  end
end
