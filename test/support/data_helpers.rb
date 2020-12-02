# frozen_string_literal: true

##
# Helpers for test-data
module DataHelpers
  protected

  ##
  # Generate a deterministic fake UUID for an aggregate.
  # +klass+ the Aggregate to generate the UUID for. Makes it easy to recognise
  # +sequence+ sequence number to guarantee uniqueness.
  def fake_uuid(klass, sequence)
    klass_n = {
      Aggregates::Member => 1,
      Aggregates::Registration => 2,
      Aggregates::Session => 3
    }.fetch(klass, 0)

    format(
      '%08<klass_n>x-0000-4000-8000-%012<sequence>x',
      klass_n: klass_n,
      sequence: sequence
    )
  end

  def fixtures(file)
    Hours.base_path.join('test', 'fixtures', file).to_s
  end

  def json_fixtures(file)
    JSON.parse(File.read(fixtures(file)), symbolize_names: true)
  end

  def harry
    registers = member_registers
    registers.upto(:confirmed)

    member_registers.form_attributes
  end

  def ron
    ron = { username: 'ron', email: 'ron@example.org', password: 'secret' }
    member_registers(ron).upto(:confirmed).html

    ron
  end
end
