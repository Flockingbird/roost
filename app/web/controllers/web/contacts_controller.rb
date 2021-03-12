# frozen_string_literal: true

module Web
  ##
  # Handles contacts index and addition
  class ContactsController < WebController
    include LoadHelpers
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
      redirect '/remote' unless authorized?

      authorize { may_add_contact? }

      Commands.handle(
        'Contact', 'Add',
        { 'handle' => handle, 'owner_id' => current_member.member_id }
      )

      flash[:success] = "#{handle} was added to your contacts"
      redirect "/m/#{handle}"
    end

    private

    def contact
      decorate(
        load(
          Aggregates::Member,
          Projections::Members::Query.aggregate_id_for(handle.to_s)
        ),
        ViewModels::Profile,
        ViewModels::Profile::NullProfile
      )
    end

    def handle
      Handle.parse(params[:handle])
    end
  end
end
