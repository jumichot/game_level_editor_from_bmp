require "minitest_helper"

describe LevelEditor::LineManager do
  it "has an instance attribute of level editor image" do
    img = LevelEditor::Image.new("images/test_case1.bmp")
    @manager = LevelEditor::LineManager.new(img)
    @manager.image.must_equal(img)
  end
end
