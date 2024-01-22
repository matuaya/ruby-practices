# frozen_string_literal: true

require_relative 'shot'

class Frame
  # フレームがストライクか、スペアか、それ以外かを決める
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(shots)
    @first_shot = Shot.new(shots[0]).convert_shot
    @second_shot = Shot.new(shots[1]).convert_shot
    @third_shot = Shot.new(shots[2]).convert_shot
  end

  def shot_type
    if @first_shot == 10
      'strike'
    elsif @first_shot + @second_shot == 10
      'spare'
    else
      'open frame'
    end
  end
end
