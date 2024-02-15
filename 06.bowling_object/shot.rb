# frozen_string_literal: true

class Shot
  def initialize(pin_count)
    @pin_count = pin_count
  end

  def point
    strike? ? 10 : @pin_count.to_i
  end

  def strike?
    @pin_count == 'X'
  end
end
