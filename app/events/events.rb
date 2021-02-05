# frozen_string_literal: true

##
# A confirmation email has been sent
ConfirmationEmailSent = Class.new(EventSourcery::Event)

##
# A Contact was added to a Member
# +aggregate_id+, UUID of the contact aggregate
# +body.owner_id+, UUID of the member owning the contact: the contact shows
#   up in this member's contacts
# +body.handle+, Handle, the handle of the contact to be added.
ContactAdded = Class.new(EventSourcery::Event)

##
# A follower was added to a member
FollowerAdded = Class.new(EventSourcery::Event)

##
# A Member was added
MemberAdded = Class.new(EventSourcery::Event)

##
# A profile bio was updated
MemberBioUpdated = Class.new(EventSourcery::Event)

##
# A Member was invited
MemberInvited = Class.new(EventSourcery::Event)

##
# A profile bio was updated
MemberNameUpdated = Class.new(EventSourcery::Event)

##
# A Member was Tagged
MemberTagAdded = Class.new(EventSourcery::Event)

##
# A Registration is confirmed
RegistrationConfirmed = Class.new(EventSourcery::Event)

##
# A visitor has registered: reguested a new registration
RegistrationRequested = Class.new(EventSourcery::Event)

##
# A Logged in session was started
SessionStarted = Class.new(EventSourcery::Event)
