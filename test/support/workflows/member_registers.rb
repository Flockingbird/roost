# frozen_string_literal: true

module Workflows
  class MemberRegisters < Base
    def registered
      visit '/'
      click_link 'Register'

      fill_in('Username', with: registration_params[:username])
      fill_in('Password', with: registration_params[:password])
      fill_in('Email', with: registration_params[:email])
      click_button('Register')
      process_events(%w[registration_requested])
      page
    end

    def confirmed
      visit confirmation_path_from_mail
      process_events(%w[registration_confirmed])
      page
    end

    def registration_params
      @registration_params ||= {
        username: 'hpotter',
        password: 'caput draconis',
        email: 'harry@hogwards.edu.wiz'
      }
    end

    private

    def confirmation_path_from_mail
      mail = Roost.mailer.deliveries.find do |email|
        email.subject.match?(/Please confirm your email address/)
      end

      base_url = Roost.config.web_url
      path = mail.body.match(%r{#{base_url}(/confirmation/.*)})
      path[1]
    end

    def steps
      %i[registered confirmed].freeze
    end
  end
end
