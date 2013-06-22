require "rmagick"
require "minitest/autorun"

module LevelEditor
  class Level
    attr_reader :original_image

    def initialize(image_path)
      @original_image = Magick::Image::read(image_path).first
    end

    def length
      @original_image.columns
    end
  end
end

describe "Use case on a simple image 6x3" do
  before do
    @editor = LevelEditor::Level.new("test2.bmp")
  end

  it "must have an Magick::Image instance attribute" do
    @editor.original_image.class.must_equal Magick::Image
  end

  it "can retrieve the length in meter of the level" do
    @editor.length.must_equal(6)
  end

end




