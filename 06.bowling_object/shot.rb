# frozen_string_literal: true

class Shot
  attr_reader :pin_count

  def initialize(pin_count)
    @pin_count = pin_count
  end

  def point
    pin_count == 'X' ? 10 : pin_count.to_i
  end

  def strike?
    pin_count == 'X'
  end
end
