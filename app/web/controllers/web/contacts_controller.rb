# frozen_string_literal: true

module Web
  ##
  # Handles contacts index and addition
  class ContactsController < WebController
    # Index
    get '/' do
      contacts = ViewModels::Profile.from_collection(
        Projections::Contacts::Query.for_member(member_id)
      )
      erb :contacts, layout: :layout_member, locals: { contacts: contacts }
    end

    # Add
    post '/' do
      requires_authorization
      handle = Handle.parse(params['handle'])
      Commands.handle('Contact', 'Add',
                      { 'handle' => handle.to_s, 'owner_id' => member_id })

      flash[:success] = "#{handle} was added to your contacts"
      redirect "/m/@#{handle.username}"
    end
  end
end
