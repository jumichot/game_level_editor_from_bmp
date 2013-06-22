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
end
