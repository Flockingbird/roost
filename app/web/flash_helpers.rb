# frozen_string_literal: true

##
# Module that wraps around Sinatra::Flash to render flash messages
module FlashHelpers
  protected

  def notifications
    flash(:flash).collect do |message|
      %(<div class="notification is-#{message[0]}">
        <button class="delete"></button>
        #{message[1]}
      </div>)
    end.join
  end
end
