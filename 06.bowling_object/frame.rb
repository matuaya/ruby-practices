# frozen_string_literal: true

class Frame
  def initialize(shots, frame_number)
    @shots = shots
    @frame_number = frame_number
  end

  def calculate_score(frames)
    next_frame = frames[@frame_number + 1]

    return points.sum if next_frame.nil?

    bonus_point =
      if strike?
        after_next_frame = frames[@frame_number + 2]
        strike_points(next_frame, after_next_frame)
      elsif spare?
        spare_points(next_frame)
      end

    points.sum + bonus_point.to_i
  end

  def points
    @shots.map(&:point)
  end

  def strike?
    @shots[0].strike?
  end

  private

  def strike_points(next_frame, after_next_frame)
    if next_frame.strike? && after_next_frame
      next_frame.points[0] + after_next_frame.points[0]
    else
      next_frame.points.take(2).sum
    end
  end

  def spare_points(next_frame)
    next_frame.points[0]
  end

  def spare?
    !strike? && points.sum == 10
  end
end
