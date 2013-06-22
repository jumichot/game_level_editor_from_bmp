require './editor.rb'
describe LevelEditor::Image do
  before do
    @image = LevelEditor::Image.new("test_case1.bmp")

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

  it "build an array of visited pixel with the image size" do
    @image.identified_pixels.size.must_equal(18)
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

  it "can know if the next pixel on the right is on the same line" do
    @image.right_pixel_identical?(0,0).must_equal(true)
    @image.right_pixel_identical?(2,0).must_equal(false)
    @image.right_pixel_identical?(5,0).must_equal(false)
    @image.right_pixel_identical?(3,1).must_equal(false)
    @image.right_pixel_identical?(3,0).must_equal(false)
    @image.right_pixel_identical?(4,2).must_equal(false)
    @image.right_pixel_identical?(5,2).must_equal(false)
  end

  it "can know if the next pixel on the right is on the same line" do
    @image.left_pixel_identical?(0,0).must_equal(false)
    @image.left_pixel_identical?(1,0).must_equal(true)
    @image.left_pixel_identical?(5,2).must_equal(false)
    @image.left_pixel_identical?(4,2).must_equal(true)
    @image.left_pixel_identical?(4,1).must_equal(false)
    @image.left_pixel_identical?(2,1).must_equal(true)
    @image.left_pixel_identical?(1,1).must_equal(true)
    @image.left_pixel_identical?(3,1).must_equal(false)
  end

  it "can retrieve all pixels of the same line on the right" do
    @image.detect_pixels_on_the_right([],2,2).must_equal([[2,2],[3,2],[4,2]])
    @image.detect_pixels_on_the_right([],3,1).must_equal([[3,1]])
    @image.detect_pixels_on_the_right([],5,0).must_equal([[5,0]])
    @image.detect_pixels_on_the_right([],1,0).must_equal([[1,0],[2,0]])
  end

  it "can retrieve all pixels of the same line on the left" do
    @image.detect_pixels_on_the_left([],0,0).must_equal([[0,0]])
    @image.detect_pixels_on_the_left([],3,1).must_equal([[3,1]])
    @image.detect_pixels_on_the_left([],4,1).must_equal([[4,1]])
    @image.detect_pixels_on_the_left([],5,1).must_equal([[5,1],[4,1]])
    @image.detect_pixels_on_the_left([],4,2).must_equal([[4,2],[3,2],[2,2],[1,2],[0,2]])
    @image.detect_pixels_on_the_left([],2,1).must_equal([[2,1],[1,1],[0,1]])
  end

  it "can detect the pixels on the right" do
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

  it "can get all the horizontal lines of black pixels" do
    @image.horizontal_lines("black").size.must_equal(1)
    @image.horizontal_lines("black").must_equal([[0,2,1]])
  end

  it "can get all the horizontal lines of white pixels" do
    @image.horizontal_lines("white").size.must_equal(4)
    @image.horizontal_lines("white").must_equal([[0,2,0],[4,5,0],[4,5,1],[0,4,2]])
  end

end
