# frozen_string_literal: true

require_relative 'frame'
require_relative 'shot'

class Game
  FINAL_FRAME_SHOT = 18
  FINAL_FRAME = 9

  def calculate_total_score(result)
    frames = generate_frames(result)
    frames.sum { |frame| frame.calculate_score(frames) }
  end

  private

  def generate_frames(result)
    pin_counts = result.split(',')

    all_shots = []
    pin_counts.each do |pin_count|
      shot = Shot.new(pin_count)
      if all_shots.size < FINAL_FRAME_SHOT && shot.strike?
        all_shots << shot
        all_shots << Shot.new('0')
      else
        all_shots << shot
      end
    end

    frames = []
    final_frame_shots = []
    all_shots.each_slice(2).each_with_index do |shots, frame_number|
      if frame_number < FINAL_FRAME
        frames << Frame.new(shots, frame_number)
      else
        final_frame_shots.concat(shots)
      end
    end
    frames << Frame.new(final_frame_shots, FINAL_FRAME)
    frames
  end
end

result = ARGV[0]
puts Game.new.calculate_total_score(result)
