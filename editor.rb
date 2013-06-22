require "rmagick"
require "minitest/autorun"

module LevelEditor
  class Image
    attr_reader :original_image, :pixels

    def initialize(image_path)
      @original_image = Magick::Image::read(image_path).first
      create_pixels_array
    end

    def width
      @original_image.columns
    end

    def heigth
      @original_image.rows
    end

    def create_pixels_array
      @pixels = []
      @original_image.each_pixel do |pixel, col, row|
        @pixels << pixel
      end
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

    def next_pixel_on_the_right_on_the_same_line?(x,y)
      return false if x >= width
      next_x = x + 1
      get_color(x,y) == get_color(next_x,y)
    end
  end
end

describe LevelEditor::Image do
  before do
    @image = LevelEditor::Image.new("test_case1.bmp")
  end

  it "must have an Magick::Image instance attribute" do
    @image.original_image.class.must_equal Magick::Image
  end

  it "can retrieve is width" do
    @image.width.must_equal(6)
  end

  it "can retrieve his heigth" do
    @image.heigth.must_equal(3)
  end

  it "convert the original image into an array of pixels" do
    @image.pixels.must_be_instance_of(Array)
    @image.pixels.size.must_equal(18)
  end

  it "can convert 2d coordinate into 1d to access in an 1D array" do
    @image.convert_2D_to_1D(0,0).must_equal(0)
    @image.convert_2D_to_1D(1,0).must_equal(1)
    @image.convert_2D_to_1D(5,0).must_equal(5)
    @image.convert_2D_to_1D(1,1).must_equal(7)
    @image.convert_2D_to_1D(5,2).must_equal(17)
  end

  it "can access to a pixel" do
    @image.get(0,0).must_be_instance_of(Magick::Pixel)
  end

  it "can access to a pixel color" do
    @image.get_color(0,0).must_equal("white")
    @image.get_color(3,0).must_equal("black")
    @image.get_color(3,1).must_equal("red")
  end

  it "can know if the next pixel horizontal is on the same line" do
    @image.next_pixel_on_the_right_on_the_same_line?(0,0).must_equal(true)  # white pixel
    @image.next_pixel_on_the_right_on_the_same_line?(0,1).must_equal(true)  # black pixel
    @image.next_pixel_on_the_right_on_the_same_line?(5,0).must_equal(false) # right border
    @image.next_pixel_on_the_right_on_the_same_line?(3,1).must_equal(false) # red pixel
    @image.next_pixel_on_the_right_on_the_same_line?(2,0).must_equal(false) # color change
    @image.next_pixel_on_the_right_on_the_same_line?(3,0).must_equal(false) # color change
    @image.next_pixel_on_the_right_on_the_same_line?(4,2).must_equal(false) # color change
  end

end




