# frozen_string_literal: true

require_relative 'frame'

class Game
  FINAL_FRAME_SHOT = 18
  FINAL_FRAME = 9

  def initialize(result)
    @result = result
  end

  def calculate_total_score
    frames = generate_frames(@result)
    frames.each.sum { |frame| frame.calculate_score(frames) }
  end

  private

  def generate_frames(result)
    pin_counts = result.split(',')

    shots = []
    pin_counts.each do |pin_count|
      if shots.size < FINAL_FRAME_SHOT && pin_count == 'X'
        shots << Shot.new(pin_count)
        shots << Shot.new('0')
      else
        shots << Shot.new(pin_count)
      end
    end

    frames = []
    final_frame_shots = []
    shots.each_slice(2).each_with_index do |shot_pair, frame_number|
      if frame_number < FINAL_FRAME
        frames << Frame.new(shot_pair, frame_number)
      else
        final_frame_shots.concat(shot_pair)
      end
    end
    frames << Frame.new(final_frame_shots, FINAL_FRAME)
  end
end

result = ARGV[0]
puts Game.new(result).calculate_total_score
