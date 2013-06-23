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
      return (@x_start - @x_end).abs + 1 if horizontal?
      return (@y_start - @y_end).abs + 1 if vertical?
    end

    def to_a
      return [@x_start,@x_end,@y_start] if horizontal?
      return [@x_start,@y_start,@y_end] if vertical?
    end

    def to_unity
      ary = to_a
      "add_#{direction}_bar(#{ary[0]},#{ary[1]},#{ary[2]})"
    end

    def horizontal?
      direction == :horizontal
    end

    def vertical?
      direction == :vertical
    end
  end
end
