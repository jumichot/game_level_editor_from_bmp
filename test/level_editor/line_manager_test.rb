require "minitest_helper"

describe LevelEditor::LineManager do

  describe "with two crossing lines" do
    before do
      @image_interroger = LevelEditor::ImageInterroger.new("images/test_case_2.bmp")
      @line_manager = LevelEditor::LineManager.new(@image_interroger)
    end

    it "output the x_start, x_end, and the y of a vertical line" do
      @line_manager.scan_line(0,0)
      @line_manager.lines[:vertical].first.to_a.must_equal([0,0,1])
    end

    it "output the x_start, x_end, and the y of a vertical line" do
      @line_manager.scan_line(2,0)
      @line_manager.lines[:vertical].first.to_a.must_equal([2,0,2])
    end

    it "output the x_start, x_end, and the y of a vertical line" do
      @line_manager.scan_line(5,2)
      @line_manager.lines[:vertical].first.to_a.must_equal([5,1,2])
    end

    it "output the x_start, x_end, and the y of a vertical line" do
      @line_manager.scan_line(3,1)
      @line_manager.lines[:horizontal].first.must_be_nil
      @line_manager.lines[:vertical].first.must_be_nil
    end
  end

  describe "with two crossing lines" do
    before do
      @image_interroger = LevelEditor::ImageInterroger.new("images/test_case_3.bmp")
      @line_manager = LevelEditor::LineManager.new(@image_interroger)
    end

    it "has an instance attribute of level editor image" do
      @line_manager.image_interroger.must_equal(@image_interroger)
    end

    it "build arrays of line from arrays of consecutive vertical pixels" do
      horizontal_consecutive_pixels = @image_interroger.find_all_pixels_on_axis(:horizontal,1,1)
      @line_manager.add_line(horizontal_consecutive_pixels)
      @line_manager.lines[:horizontal].first.to_a.must_equal([0,3,1])
      @line_manager.lines[:horizontal].size.must_equal(1)
    end

    it "build arrays of line from arrays of consecutive horizontal pixels" do
      vertical_consecutive_pixels = @image_interroger.find_all_pixels_on_axis(:vertical,3,1)
      @line_manager.add_line(vertical_consecutive_pixels)
      @line_manager.lines[:vertical].first.to_a.must_equal([3,0,1])
      @line_manager.lines[:vertical].size.must_equal(1)
    end

    it "can scan line without doublon" do
      @line_manager.scan_line(0,1)
      @line_manager.lines[:horizontal].count.must_equal(1)
      @line_manager.lines[:vertical].must_be_empty
      @line_manager.scan_line(1,1)
      @line_manager.lines[:horizontal].count.must_equal(1)
      @line_manager.lines[:vertical].must_be_empty
    end

    it "doesnt count the isolated 1x1 block" do
      @line_manager.scan_line(4,3)
      lines_must_be_empty
    end

    it "doesnt count the other color block" do
      @line_manager.scan_line(7,4)
      lines_must_be_empty
    end

    def lines_must_be_empty
      @line_manager.lines[:horizontal].must_be_empty
      @line_manager.lines[:vertical].must_be_empty
    end
  end

end
