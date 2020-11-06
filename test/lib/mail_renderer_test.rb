# frozen_string_literal: true

require 'test_helper'

class MailRendererTest < Minitest::Spec
  let(:templates_root) { Roost.root.join('tmp').to_s }
  subject { MailRenderer.new(templates_root: templates_root) }

  before :each do
    # ensure we have a template file
    File.write(File.join(templates_root, "#{template}.erb"), template_body)
  end

  after :each do
    # Clean up the template file
    File.unlink(File.join(templates_root, "#{template}.erb"))
  end

  describe '#render' do
    let(:template) { :test_mail_body }
    let(:template_body) { 'Hello <%= planet %>' }

    it 'renders a template with ERB' do
      assert_equal(
        subject.render(template, { planet: 'world' }),
        'Hello world'
      )
    end

    it 'raises a NameError for unkown locals' do
      assert_raises(NameError) { subject.render(template, {}) }
    end

    it 'raises an Errno::ENOENT for a missing template' do
      assert_raises(Errno::ENOENT) { subject.render(:missing) }
    end
  end
end
