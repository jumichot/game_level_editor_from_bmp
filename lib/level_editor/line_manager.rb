module LevelEditor
  class LineManager
    attr_reader :image_interroger, :lines, :lines_array

    COLOR = "black"

    def initialize(image_interroger)
      @image_interroger = image_interroger
      @lines =  Hash.new{|hash, key| hash[key] = []}
      @lines_array =  Hash.new{|hash, key| hash[key] = []}
    end

    def scan_line(x,y)
      return if @image_interroger.get_color(x,y) != COLOR
      [:horizontal,:vertical].each do |direction|
        consecutive_pixels_array = @image_interroger.find_all_pixels_on_axis(direction,x,y)
        add_line(consecutive_pixels_array) if consecutive_pixels_array.count > 1
      end
    end

    def add_line(consecutive_pixels_array)
      all_x, all_y = consecutive_pixels_array.transpose
      line =  Line.new(all_x.min,all_y.min,all_x.max,all_y.max)
      unless @lines_array[line.direction].include? line.to_a
        @lines[line.direction] << line
        @lines_array[line.direction] << line.to_a
      end
    end
  end
end
