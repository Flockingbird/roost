# frozen_string_literal: true

module Web
  ##
  # Handles contacts index and addition
  class ContactsController < WebController
    include PolicyHelpers

    # Index
    get '/contacts' do
      contacts = ViewModels::Profile.from_collection(
        Projections::Contacts::Query.for_member(member_id)
      )
      erb :contacts, layout: :layout_member, locals: { contacts: contacts }
    end

    # Add
    post '/contacts' do
      requires_authorization
      authorize { may_add_contact? }

      Commands.handle(
        'Contact', 'Add',
        { 'handle' => contact.handle, 'owner_id' => current_member.member_id }
      )

      flash[:success] = "#{contact.handle} was added to your contacts"
      redirect "/m/#{contact.handle}"
    end

    private

    def contact
      aggregate_id = Projections::Members::Query.aggregate_id_for(handle)
      Roost.repository.load(Aggregates::Member, aggregate_id)
    end

    def handle
      Handle.parse(params['handle'])
    end
  end
end
