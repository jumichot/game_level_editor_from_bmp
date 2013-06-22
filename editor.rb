require "rmagick"
require "minitest/autorun"

module LevelEditor
  class Image
    attr_reader :original_image, :pixels, :visited_horizontal_pixels

    LINE_ELEMENT = "black"

    def initialize(image_path)
      @original_image = Magick::Image::read(image_path).first
      create_pixels_and_identified_pixels_arrays
    end

    def create_pixels_and_identified_pixels_arrays
      @pixels = []

      @original_image.each_pixel do |pixel, col, row|
        @pixels << pixel
      end
      @visited_horizontal_pixels = Array.new(width*heigth)
    end

    def width
      @original_image.columns
    end

    def heigth
      @original_image.rows
    end

    def get(x,y)
      pixels[convert_2D_to_1D(x,y)]
    end

    def get_color(x,y)
      get(x,y).to_color
    end

    def convert_2D_to_1D(x,y)
      x + (y * width)
    end

    def right_pixel_identical?(x,y)
      return false if x + 1 >= width
      get_color(x,y) == get_color(x + 1,y)
    end

    def left_pixel_identical?(x,y)
      return false if x == 0
      get_color(x,y) == get_color(x - 1,y)
    end

    def detect_pixels_on_the_right(line,x,y)
      line << [x,y]
      return line unless right_pixel_identical?(x,y)
      detect_pixels_on_the_right(line,x+1,y)
    end

    def detect_pixels_on_the_left(line,x,y)
      line << [x,y]
      return line unless left_pixel_identical?(x,y)
      detect_pixels_on_the_left(line,x-1,y)
    end

    def horizontale_line_pixels(x,y)
      line = []
      detect_pixels_on_the_right(line,x,y)
      detect_pixels_on_the_left(line,x,y)
      return line.uniq.sort
    end

    def mark_identified_pixel(line)
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
      mark_identified_pixel(line)
      [line.first[0], line.last[0], line.first[1]]
    end

    def detect_objects
      result = {}
      result["horizontal_bars"] = []
      @visited_horizontal_pixels = Array.new(width*heigth)
      (0..heigth-1).each do |y|
        (0..width-1).each do |x|
          next if already_identified?( @visited_horizontal_pixels,x,y)
          result["horizontal_bars"] << horizontale_line_output(x,y) if get_color(x,y) == LINE_ELEMENT
        end
      end
      result["horizontal_bars"] = result["horizontal_bars"].uniq.compact
      result

    end

  end
end
