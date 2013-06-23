require "minitest_helper"

describe LevelEditor::ImageInterroger do

  describe "6x3 image with 1 horizontal bar" do
    #   012345
    # 0 xxxoxx    x white
    # 1 ooo-xx    o black
    # 2 xxxxxo    - red

    before do
      @image_interroger = LevelEditor::ImageInterroger.new("images/test_case1.bmp")
    end

    it "must have an Magick::Image instance attribute" do
      @image_interroger.original_image.class.must_equal Magick::Image
    end

    it "can retrieve is width" do
      @image_interroger.width.must_equal(6)
    end

    it "can retrieve his heigth" do
      @image_interroger.height.must_equal(3)
    end

    it "convert the original image into an array of pixels" do
      @image_interroger.pixels.must_be_instance_of(Array)
      @image_interroger.pixels.size.must_equal(18)
    end

    it "can convert 2d coordinate into 1d to access in an 1D array" do
      @image_interroger.convert_2D_to_1D(0,0).must_equal(0)
      @image_interroger.convert_2D_to_1D(1,0).must_equal(1)
      @image_interroger.convert_2D_to_1D(5,0).must_equal(5)
      @image_interroger.convert_2D_to_1D(1,1).must_equal(7)
      @image_interroger.convert_2D_to_1D(5,2).must_equal(17)
    end

    it "can access to a pixel" do
      @image_interroger.get(0,0).must_be_instance_of(Magick::Pixel)
    end

    it "can access to a pixel color" do
      @image_interroger.get_color(0,0).must_equal("white")
      @image_interroger.get_color(3,0).must_equal("black")
      @image_interroger.get_color(3,1).must_equal("red")
    end

    it "can know if the next pixel on the right is identical" do
      @image_interroger.pixel_identical?(:right,0,0).must_equal(true)
      @image_interroger.pixel_identical?(:right,2,0).must_equal(false)
      @image_interroger.pixel_identical?(:right,5,0).must_equal(false)
      @image_interroger.pixel_identical?(:right,3,1).must_equal(false)
      @image_interroger.pixel_identical?(:right,3,0).must_equal(false)
      @image_interroger.pixel_identical?(:right,4,2).must_equal(false)
      @image_interroger.pixel_identical?(:right,5,2).must_equal(false)
    end

    it "can know if the next pixel on the left is identical" do
      @image_interroger.pixel_identical?(:left,0,0).must_equal(false)
      @image_interroger.pixel_identical?(:left,1,0).must_equal(true)
      @image_interroger.pixel_identical?(:left,5,2).must_equal(false)
      @image_interroger.pixel_identical?(:left,4,2).must_equal(true)
      @image_interroger.pixel_identical?(:left,4,1).must_equal(false)
      @image_interroger.pixel_identical?(:left,2,1).must_equal(true)
      @image_interroger.pixel_identical?(:left,1,1).must_equal(true)
      @image_interroger.pixel_identical?(:left,3,1).must_equal(false)
    end

    it "can know if the next pixel on the top is identical" do
      @image_interroger.pixel_identical?(:top,0,0).must_equal(false)
      @image_interroger.pixel_identical?(:top,3,0).must_equal(false)
      @image_interroger.pixel_identical?(:top,0,1).must_equal(false)
      @image_interroger.pixel_identical?(:top,4,2).must_equal(true)
      @image_interroger.pixel_identical?(:top,5,1).must_equal(true)
      @image_interroger.pixel_identical?(:top,5,2).must_equal(false)
      @image_interroger.pixel_identical?(:top,3,1).must_equal(false)
    end

    it "can know if the next pixel on the right is identical" do
      @image_interroger.pixel_identical?(:bottom,0,0).must_equal(false)
      @image_interroger.pixel_identical?(:bottom,0,1).must_equal(false)
      @image_interroger.pixel_identical?(:bottom,3,1).must_equal(false)
      @image_interroger.pixel_identical?(:bottom,5,1).must_equal(false)
      @image_interroger.pixel_identical?(:bottom,5,2).must_equal(false)
      @image_interroger.pixel_identical?(:bottom,5,0).must_equal(true)
    end

    it "can retrieve all pixels of the same line on the right" do
      @image_interroger.find_consecutive_pixels(:right,2,2,[]).must_equal([[2,2],[3,2],[4,2]])
      @image_interroger.find_consecutive_pixels(:right,3,1,[]).must_equal([[3,1]])
      @image_interroger.find_consecutive_pixels(:right,5,0,[]).must_equal([[5,0]])
      @image_interroger.find_consecutive_pixels(:right,1,0,[]).must_equal([[1,0],[2,0]])
    end

    it "can retrieve all pixels of the same line on the left" do
      @image_interroger.find_consecutive_pixels(:left,0,0,[]).must_equal([[0,0]])
      @image_interroger.find_consecutive_pixels(:left,3,1,[]).must_equal([[3,1]])
      @image_interroger.find_consecutive_pixels(:left,4,1,[]).must_equal([[4,1]])
      @image_interroger.find_consecutive_pixels(:left,5,1,[]).must_equal([[5,1],[4,1]])
      @image_interroger.find_consecutive_pixels(:left,4,2,[]).must_equal([[4,2],[3,2],[2,2],[1,2],[0,2]])
      @image_interroger.find_consecutive_pixels(:left,2,1,[]).must_equal([[2,1],[1,1],[0,1]])
    end

    it "can detect all the pixels of an horizontal line" do
      @image_interroger.find_all_pixels_on_axis(:horizontal,0,0).must_equal([[0,0],[1,0],[2,0]])
      @image_interroger.find_all_pixels_on_axis(:horizontal,2,0).must_equal([[0,0],[1,0],[2,0]])
      @image_interroger.find_all_pixels_on_axis(:horizontal,1,0).must_equal([[0,0],[1,0],[2,0]])
      @image_interroger.find_all_pixels_on_axis(:horizontal,2,2).must_equal([[0,2],[1,2],[2,2],[3,2],[4,2]])
      @image_interroger.find_all_pixels_on_axis(:horizontal,3,1).must_equal([[3,1]])
      @image_interroger.find_all_pixels_on_axis(:horizontal,4,0).must_equal([[4,0],[5,0]])
    end
  end

  describe "simple test case with 6x3 images with only vertical bars" do
    #   012345
    # 0 oxoxxx    x white
    # 1 oxo-xo    o black
    # 2 xxoxxo    - red

    before do
      @image_interroger = LevelEditor::ImageInterroger.new("images/test_case_2.bmp")
    end

    it "can retrieve all pixels of the same line in the top direction" do
      @image_interroger.find_consecutive_pixels(:top,0,0,[]).must_equal([[0,0]])
      @image_interroger.find_consecutive_pixels(:top,0,1,[]).must_equal([[0,1],[0,0]])
      @image_interroger.find_consecutive_pixels(:top,2,2,[]).must_equal([[2,2],[2,1],[2,0]])
    end

    it "can retrieve all pixels of the same line in the bottom direction" do
      @image_interroger.find_consecutive_pixels(:bottom,0,0,[]).must_equal([[0,0],[0,1]])
      @image_interroger.find_consecutive_pixels(:bottom,0,1,[]).must_equal([[0,1]])
      @image_interroger.find_consecutive_pixels(:bottom,2,0,[]).must_equal([[2,0],[2,1],[2,2]])
      @image_interroger.find_consecutive_pixels(:bottom,2,2,[]).must_equal([[2,2]])
    end

    it "can detect all the pixels of a line" do
      first_black_line  = [[0,0],[0,1]]
      second_black_line = [[2,0],[2,1],[2,2]]
      third_black_line  = [[5,1],[5,2]]
      @image_interroger.find_all_pixels_on_axis(:vertical,0,0).must_equal(first_black_line)
      @image_interroger.find_all_pixels_on_axis(:vertical,0,1).must_equal(first_black_line)
      @image_interroger.find_all_pixels_on_axis(:vertical,2,1).must_equal(second_black_line)
      @image_interroger.find_all_pixels_on_axis(:vertical,2,0).must_equal(second_black_line)
      @image_interroger.find_all_pixels_on_axis(:vertical,2,2).must_equal(second_black_line)
      @image_interroger.find_all_pixels_on_axis(:vertical,5,1).must_equal(third_black_line)
    end
  end

end
