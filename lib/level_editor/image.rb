module LevelEditor
  class Image
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

    def line_output(direction,x,y)
      line = find_all_pixels_on_axis(direction,x,y)
      return if line.count == 1
      case direction
      when :vertical
        [line.first[0], line.first[1], line.last[1]]
      when :horizontal
        mark_visited_horizontal_pixels(line)
        [line.first[0], line.last[0], line.first[1]]
      end
    end

    def mark_visited_horizontal_pixels(line)
      line.each do |x,y|
        @already_analized_pixel[convert_2D_to_1D(x,y)] = get_color(line.first[0],line.first[1])
      end
    end

    def detect_objects
      result = Hash.new { |hash, key| hash[key] = [] }
      @already_analized_pixel = Array.new(width*height)
      (0..height-1).each do |y|
        (0..width-1).each do |x|
          unless already_identified?(@already_analized_pixel,x,y)
            result[:horizontal_bars] << line_output(:horizontal,x,y) if get_color(x,y) == LINE_ELEMENT
          end
            result[:vertical_bars] << line_output(:vertical,x,y) if get_color(x,y) == LINE_ELEMENT
        end
      end
      result.each {|key,value| value.uniq!.compact!}
    end

    def already_identified?(ary,x,y)
       get_color(x,y) == ary[convert_2D_to_1D(x,y)]
    end

  end

end
