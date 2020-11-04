# frozen_string_literal: true

##
# Helpers for Mail deliveries and specification
module MailHelpers
  protected

  def assert_mail_deliveries(amount)
    actual = Roost.mailer.deliveries.length
    subjects = Roost.mailer.deliveries.map(&:subject).join(', ')

    assert_equal(
      amount,
      actual,
      "Expected #{amount} mails delivered, got #{actual}."\
      " Mails where: #{subjects}"
    )
  end
end
