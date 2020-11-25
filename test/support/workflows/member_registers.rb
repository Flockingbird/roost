# frozen_string_literal: true

module Workflows
  class MemberRegisters < Base
    def registered
      visit '/'
      click_link 'Register'

      fill_in('Username', with: form_attributes[:username])
      fill_in('Password', with: form_attributes[:password])
      fill_in('Email', with: form_attributes[:email])
      click_button('Register')
      process_events(%w[registration_requested])
      page
    end

    def confirmed
      visit confirmation_path_from_mail
      process_events(%w[registration_confirmed member_added])
      page
    end

    def form_attributes
      {
        username: 'hpotter',
        password: 'caput draconis',
        email: 'harry@hogwards.edu.wiz'
      }.merge(@form_attributes)
    end

    private

    def confirmation_path_from_mail
      mail = Mail::TestMailer.deliveries.reverse.find do |email|
        email.subject.match?(/Please confirm your email address/)
      end

      refute_nil(mail)
      base_url = Roost.config.web_url
      path = mail.body.match(%r{#{base_url}(/confirmation/.*)})
      path[1]
    end

    def steps
      %i[registered confirmed].freeze
    end
  end
end
