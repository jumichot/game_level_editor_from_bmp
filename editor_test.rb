require './editor.rb'
describe LevelEditor::Image do
  describe "simple test case with 6x3 image with only horizontal bars" do
    before do
      @image = LevelEditor::Image.new("images/test_case1.bmp")

      #   012345
      # 0 xxxoxx    x white
      # 1 ooo-xx    o black
      # 2 xxxxxo    - red

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

    it "can know if the next pixel on the right is identical" do
      @image.pixel_identical?(:right,0,0).must_equal(true)
      @image.pixel_identical?(:right,2,0).must_equal(false)
      @image.pixel_identical?(:right,5,0).must_equal(false)
      @image.pixel_identical?(:right,3,1).must_equal(false)
      @image.pixel_identical?(:right,3,0).must_equal(false)
      @image.pixel_identical?(:right,4,2).must_equal(false)
      @image.pixel_identical?(:right,5,2).must_equal(false)
    end

    it "can know if the next pixel on the right is identical" do
      @image.pixel_identical?(:left,0,0).must_equal(false)
      @image.pixel_identical?(:left,1,0).must_equal(true)
      @image.pixel_identical?(:left,5,2).must_equal(false)
      @image.pixel_identical?(:left,4,2).must_equal(true)
      @image.pixel_identical?(:left,4,1).must_equal(false)
      @image.pixel_identical?(:left,2,1).must_equal(true)
      @image.pixel_identical?(:left,1,1).must_equal(true)
      @image.pixel_identical?(:left,3,1).must_equal(false)
    end

    it "can retrieve all pixels of the same line on the right" do
      @image.find_consecutive_pixels(:right,2,2,[]).must_equal([[2,2],[3,2],[4,2]])
      @image.find_consecutive_pixels(:right,3,1,[]).must_equal([[3,1]])
      @image.find_consecutive_pixels(:right,5,0,[]).must_equal([[5,0]])
      @image.find_consecutive_pixels(:right,1,0,[]).must_equal([[1,0],[2,0]])
    end

    it "can retrieve all pixels of the same line on the left" do
      @image.find_consecutive_pixels(:left,0,0,[]).must_equal([[0,0]])
      @image.find_consecutive_pixels(:left,3,1,[]).must_equal([[3,1]])
      @image.find_consecutive_pixels(:left,4,1,[]).must_equal([[4,1]])
      @image.find_consecutive_pixels(:left,5,1,[]).must_equal([[5,1],[4,1]])
      @image.find_consecutive_pixels(:left,4,2,[]).must_equal([[4,2],[3,2],[2,2],[1,2],[0,2]])
      @image.find_consecutive_pixels(:left,2,1,[]).must_equal([[2,1],[1,1],[0,1]])
    end

    it "can detect all the pixels of a line" do
      @image.horizontale_line_pixels(0,0).must_equal([[0,0],[1,0],[2,0]])
      @image.horizontale_line_pixels(2,0).must_equal([[0,0],[1,0],[2,0]])
      @image.horizontale_line_pixels(1,0).must_equal([[0,0],[1,0],[2,0]])
      @image.horizontale_line_pixels(2,2).must_equal([[0,2],[1,2],[2,2],[3,2],[4,2]])
      @image.horizontale_line_pixels(3,1).must_equal([[3,1]])
      @image.horizontale_line_pixels(4,0).must_equal([[4,0],[5,0]])
    end

    it "output the x_start, x_end, and the y of a line" do
      @image.horizontale_line_output(2,2).must_equal([0,4,2])
      @image.horizontale_line_output(3,1).must_be_nil
    end

    it "can get all the horizontal lines" do
      @image.detect_objects["horizontal_bars"].size.must_equal(1)
      @image.detect_objects["horizontal_bars"].must_equal([[0,2,1]])
    end

    it "know pixels already identified for a color" do
      ary = []
      ary[0] =  @image.get_color(0,0)
      @image.already_identified?(ary,0,0).must_equal(true)
    end

  end

  describe "crash test with 100x51 image with only horizontal lines" do
    before do
      @image = LevelEditor::Image.new("images/test_case_horizontale_lines.bmp")
    end

    it "can get all the horizontal lines of black pixels" do
      @image.detect_objects["horizontal_bars"].size.must_equal(9)
      @image.detect_objects["horizontal_bars"].must_equal([[0, 23, 0], [120, 139, 0], [13, 36, 11], [127, 139, 22], [0, 35, 25], [22, 36, 31], [8, 52, 32], [0, 31, 50], [123, 139, 50]])
    end
  end

  describe "simple test case with 6x3 images with only vertical bars" do
    before do
      @image = LevelEditor::Image.new("images/test_case_2.bmp")

      #   012345
      # 0 oxoxxx    x white
      # 1 oxoxxo    o black
      # 2 xxoxxo    - red
    end

    it "has no horizontal bar" do
      @image.detect_objects["horizontal_bars"].size.must_equal(0)
    end

    it "can know if the next pixel on the top is identical" do
      @image.pixel_identical?(:top,0,0).must_equal(false)
      @image.pixel_identical?(:top,3,0).must_equal(false)
      @image.pixel_identical?(:top,0,1).must_equal(true)
      @image.pixel_identical?(:top,2,1).must_equal(true)
      @image.pixel_identical?(:top,2,2).must_equal(true)
      @image.pixel_identical?(:top,5,1).must_equal(false)
      @image.pixel_identical?(:top,5,2).must_equal(true)
    end

    it "can know if the next pixel on the right is identical" do
      @image.pixel_identical?(:bottom,0,0).must_equal(true)
      @image.pixel_identical?(:bottom,0,1).must_equal(false)
      @image.pixel_identical?(:bottom,0,2).must_equal(false)
      @image.pixel_identical?(:bottom,5,1).must_equal(true)
      @image.pixel_identical?(:bottom,5,1).must_equal(true)
      @image.pixel_identical?(:bottom,2,1).must_equal(true)
      @image.pixel_identical?(:bottom,5,2).must_equal(false)
    end

     it "can retrieve all pixels of the same line in the top direction" do
      @image.find_consecutive_pixels(:top,0,0,[]).must_equal([[0,0]])
      @image.find_consecutive_pixels(:top,0,1,[]).must_equal([[0,1],[0,0]])
      @image.find_consecutive_pixels(:top,2,2,[]).must_equal([[2,2],[2,1],[2,0]])
    end

    it "can retrieve all pixels of the same line in the bottom direction" do
      @image.find_consecutive_pixels(:bottom,0,0,[]).must_equal([[0,0],[0,1]])
      @image.find_consecutive_pixels(:bottom,0,1,[]).must_equal([[0,1]])
      @image.find_consecutive_pixels(:bottom,2,0,[]).must_equal([[2,0],[2,1],[2,2]])
      @image.find_consecutive_pixels(:bottom,2,2,[]).must_equal([[2,2]])
    end

    it "can detect all the pixels of a line" do
      first_black_line  = [[0,0],[0,1]]
      second_black_line = [[2,0],[2,1],[2,2]]
      third_black_line  = [[5,1],[5,2]]
      @image.vertical_line_pixels(0,0).must_equal(first_black_line)
      @image.vertical_line_pixels(0,1).must_equal(first_black_line)
      @image.vertical_line_pixels(2,1).must_equal(second_black_line)
      @image.vertical_line_pixels(2,0).must_equal(second_black_line)
      @image.vertical_line_pixels(2,2).must_equal(second_black_line)
      @image.vertical_line_pixels(5,1).must_equal(third_black_line)
    end
  end

  # Finished in 1.328345s, 12.7979 runs/s, 40.6521 assertions/s.
  # Finished in 0.943738s, 18.0135 runs/s, 56.1597 assertions/s. après amélioration
end
