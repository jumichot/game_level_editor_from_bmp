require "rmagick"
require "minitest/autorun"

module LevelEditor
  class Image
    attr_reader :original_image, :pixels, :visited_horizontal_pixels

    LINE_ELEMENT = "black"

    def initialize(image_path)
      @original_image = Magick::Image::read(image_path).first
      @pixels = create_pixels_array
      @visited_horizontal_pixels = Array.new(width*heigth)
    end

    def create_pixels_array
      pixels = []
      @original_image.each_pixel {|pixel, col, row| pixels << pixel }
      pixels
    end

    def width; @original_image.columns ; end
    def heigth; @original_image.rows; end

    def get(x,y)
      pixels[convert_2D_to_1D(x,y)]
    end

    def get_color(x,y)
      get(x,y).to_color
    end

    def convert_2D_to_1D(x,y)
      x + (y * width)
    end

    def pixel_identical?(direction,x,y)
      case direction
      when :top
        y != 0 and get_color(x,y) == get_color(x,y-1)
      when :right
        x + 1 < width and get_color(x,y) == get_color(x + 1, y)
      when :bottom
        y + 1 < heigth and get_color(x,y) == get_color(x, y + 1)
      when :left
        x != 0 and get_color(x,y) == get_color(x - 1, y)
      end
    end

    def find_consecutive_pixels(direction,x,y,line)
      line << [x,y]
      return line unless pixel_identical?(direction,x,y)
      case direction
      when :right
        find_consecutive_pixels(direction,x+1,y,line)
      when :left
        find_consecutive_pixels(direction,x-1,y,line)
      when :top
        find_consecutive_pixels(direction,x,y-1,line)
      when :bottom
        find_consecutive_pixels(direction,x,y+1,line)
      end
    end

    def horizontale_line_pixels(x,y)
      line = []
      find_consecutive_pixels(:right,x,y,line)
      find_consecutive_pixels(:left,x,y,line)
      return line.uniq.sort
    end

    def mark_visited_horizontal_pixels(line)
      line.each do |x,y|
        @visited_horizontal_pixels[convert_2D_to_1D(x,y)] = get_color(line.first[0],line.first[1])
      end
    end

    def already_identified?(ary,x,y)
       get_color(x,y) == ary[convert_2D_to_1D(x,y)]
    end

    def horizontale_line_output(x,y)
      line = horizontale_line_pixels(x,y)
      return if line.count == 1
      mark_visited_horizontal_pixels(line)
      [line.first[0], line.last[0], line.first[1]]
    end

    def detect_objects
      result = {}
      result["horizontal_bars"] = []
      @visited_horizontal_pixels = Array.new(width*heigth)
      (0..heigth-1).each do |y|
        (0..width-1).each do |x|
          unless already_identified?(@visited_horizontal_pixels,x,y)
            result["horizontal_bars"] << horizontale_line_output(x,y) if get_color(x,y) == LINE_ELEMENT
          end
        end
      end
      result["horizontal_bars"] = result["horizontal_bars"].uniq.compact
      result

    end

  end
end
