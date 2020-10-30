# frozen_string_literal: true

module Reactors
  ##
  # Sends the invitation to a member
  class InvitationMailer
    include EventSourcery::Postgres::Reactor

    processor_name :invitation_mailer

    # emits_events ExampleEvent, AnotherEvent

    # table :reactor_invitation_mailer do
    #   column :todo_id, :uuid, primary_key: true
    #   column :title,   :text
    # end

    process MemberInvited do |event|
      request_attributes = event.body['data']['attributes']
      inviter = event.body['inviter']

      # TODO: implement a failure handling catching errors from Pony.
      email = Mail.new(
        to: request_attributes['to_email'],
        from: from(inviter).format,
        subject: subject(inviter)
      )
      email.deliver
    end

    private

    def from(inviter)
      from = Mail::Address.new
      from.address = inviter['email']
      from.display_name = inviter['name']
      from
    end

    def subject(inviter)
      "#{inviter['name']} invited you to join Flockingbird"
    end
  end
end
