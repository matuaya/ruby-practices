# frozen_string_literal: true

require_relative 'frame'

class Game
  FINAL_FRAME_SHOT = 18
  FINAL_FRAME = 9
  def initialize(score)
    @score = score
  end

  def calculate_total_score
    frames = generate_frames(@score)
    frames.each.sum { |frame| frame.calculate_score(frames) }
  end

  private

  def generate_frames(score)
    game_shots = score.split(',')

    shot_values = []
    game_shots.each do |shot|
      if shot_values.size < FINAL_FRAME_SHOT && shot == 'X'
        shot_values << 'X'
        shot_values << 0
      else
        shot_values << shot
      end
    end

    frames = []
    final_frame_shots = []
    shot_values.each_slice(2).each_with_index do |shot_pair, frame_number|
      if frame_number < FINAL_FRAME
        frames << Frame.new(shot_pair, frame_number)
      else
        final_frame_shots.concat(shot_pair)
      end
    end
    frames << Frame.new(final_frame_shots, FINAL_FRAME)
  end
end

score = ARGV[0]
puts Game.new(score).calculate_total_score
