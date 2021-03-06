module LevelEditor
  class ImageInterroger
    include ImageHelper
    attr_reader :original_image, :pixels, :already_analized_pixel

    LINE_ELEMENT = "black"

    def initialize(image_path)
      @original_image = Magick::Image::read(image_path).first
      @pixels = create_pixels_array
      @already_analized_pixel = Array.new(width*height)
    end

    def create_pixels_array
      pixels = []
      @original_image.each_pixel {|pixel, col, row| pixels << pixel }
      pixels
    end

    def width
      @original_image.columns
    end

    def height
      @original_image.rows
    end

    def get(x,y)
      pixels[convert_2D_to_1D(x,y)]
    end

    def get_color(x,y)
      get(x,y).to_color
    end

    def pixel_identical?(direction,x,y)
      case direction
      when :top
        y != 0 and get_color(x,y) == get_color(x,y-1)
      when :right
        x + 1 < width and get_color(x,y) == get_color(x + 1, y)
      when :bottom
        y + 1 < height and get_color(x,y) == get_color(x, y + 1)
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

    def find_all_pixels_on_axis(direction,x,y)
      line = []
      case direction
      when :vertical
        [:top,:bottom].each {|d| find_consecutive_pixels(d,x,y,line)}
      when :horizontal
        [:right,:left].each {|d| find_consecutive_pixels(d,x,y,line)}
      end
      return line.uniq.sort
    end

    def mark_visited_horizontal_pixels(line)
      line.each do |x,y|
        mark_pixel_as_visited(x,y)
      end
    end

    def mark_pixel_as_visited(x,y)
      @already_analized_pixel[convert_2D_to_1D(x,y)] = get_color(x,y)
    end

    def each_pixels
      @pixels.each_with_index do |pixel, index|
          x, y = convert_1D_to_2D(index)
          yield(x,y)
      end
    end

    def pixel_already_identified?(x,y)
      get_color(x,y) == @already_analized_pixel[convert_2D_to_1D(x,y)]
    end

  end

end
