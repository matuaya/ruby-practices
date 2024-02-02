# frozen_string_literal: true

class Shot
  def initialize(score)
    @score = score
  end

  def convert_to_int
    @score.map { |shot| shot == 'X' ? 10 : shot.to_i }
  end

  def strike?
    shots = convert_to_int
    shots[0] == 10
  end

  def spare?
    shots = convert_to_int
    shots[0] + shots[1] == 10
  end
end
