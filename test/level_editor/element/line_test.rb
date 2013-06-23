require "minitest_helper"

describe LevelEditor::Line do

  before do
    @horizontal_line = LevelEditor::Line.new(0,1,2,1)
    @vertical_line = LevelEditor::Line.new(5,0,5,1)
  end

  it "knows its direction" do
    @horizontal_line.direction.must_equal :horizontal
    @vertical_line.direction.must_equal :vertical
  end

  it "knows its length" do
    @horizontal_line.length.must_equal 3
    @vertical_line.length.must_equal 2
  end

  it "knows its length" do
    @horizontal_line.to_a.must_equal [0,2,1]
    @vertical_line.to_a.must_equal [5,0,1]
  end

end
