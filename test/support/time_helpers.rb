# frozen_string_literal: true

module TimeHelpers
  ##
  # Time Helper to freeze the time at die_wende for the duration of a block
  # stub goes away once the block is done
  def at_time(time = die_wende, &block)
    Time.stub :now, time do
      Date.stub :today, time.to_date do
        yield block
      end
    end
  end

  ##
  # Time Helper, returns a Time
  # Time is the moment the Berlin Wall fell: 9-11-1989 18:57:00
  #
  #    November 1989
  #  zo ma di wo do vr za
  #           1  2  3  4
  # > 5  6  7  8  9 10 11
  #  12 13 14 15 16 17 18
  #  19 20 21 22 23 24 25
  #  26 27 28 29 30
  def die_wende
    Time.local(1989, 11, 9, 18, 57, 0, 0)
  end

  ##
  # Assert after a certain time
  def assert_time_after(expected, actual = Time.now.getlocal)
    assert expected < actual, "#{actual} is not after #{expected}"
  end

  ##
  # Assert before a certain time
  def assert_time_before(expected, actual = Time.now.getlocal)
    assert expected > actual, "#{actual} is not before #{expected}"
  end
end
