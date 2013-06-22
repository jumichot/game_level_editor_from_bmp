require "rmagick"
require "minitest/autorun"

module LevelEditor
  class Image
    attr_reader :original_image

    def initialize(image_path)
      @original_image = Magick::Image::read(image_path).first
    end

    def width
      @original_image.columns
    end

    def heigth
      @original_image.rows
    end

  end
end

describe "Use case on a simple image 6x3" do
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
end
