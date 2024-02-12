# frozen_string_literal: true

class Shot
  attr_reader :pin_count

  def initialize(pin_count)
    @pin_count = pin_count
  end

  def convert_to_int
    pin_count == 'X' ? 10 : pin_count.to_i
  end
end
