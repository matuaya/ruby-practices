# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots, :score

  def initialize(score, frame_number)
    @shots = Shot.new(score)
    @frame_number = frame_number
    @score = @shots.convert_to_int
  end

  def calculate_score(frames)
    next_frame = frames[@frame_number + 1]
    after_next_frame = frames[@frame_number + 2]

    next_frame_shots = next_frame.shots if next_frame

    current_frame_score_sum = @score.sum

    if next_frame.nil?
      current_frame_score_sum
    elsif @shots.strike?
      if next_frame_shots.strike? && after_next_frame
        current_frame_score_sum + next_frame.score[0] + after_next_frame.score[0]
      else
        current_frame_score_sum + next_frame.score[0] + next_frame.score[1]
      end
    elsif @shots.spare?
      current_frame_score_sum + next_frame.score[0]
    else
      current_frame_score_sum
    end
  end
end
