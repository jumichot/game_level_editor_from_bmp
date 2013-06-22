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
  end
end

describe "Use case on a simple image 6x3" do
  before do
    @image = LevelEditor::Image.new("test_case1.bmp")
  end

  it "must have an Magick::Image instance attribute" do
    @image.original_image.class.must_equal Magick::Image
  end

  it "can retrieve the length in meter of the level" do
    @image.width.must_equal(6)
  end

end
