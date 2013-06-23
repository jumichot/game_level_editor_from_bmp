module LevelEditor
  class Line
    def initialize(x_start, y_start, x_end, y_end)
      @x_start = x_start
      @y_start = y_start
      @x_end = x_end
      @y_end = y_end
    end

    def direction
      return :vertical if @x_start == @x_end
      return :horizontal if @y_start == @y_end
    end

    def length
      return (@x_start - @x_end).abs + 1 if direction == :horizontal
      return (@y_start - @y_end).abs + 1 if direction == :vertical
    end
  end
end
