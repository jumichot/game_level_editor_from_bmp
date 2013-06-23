require "minitest_helper"

describe "ImageHelper" do

  #   012345
  # 0 xxxoxx    x white
  # 1 ooo-xx    o black
  # 2 xxxxxo    - red

  # 1D coordinates
  #   0     1     2     3     4     5     6     7  8  9  10 11 12 13 14 15 16 17
  # 2D coordinates
  # [0,0] [1,0] [2,0] [3,0] [4,0] [5,0] [0,1] [1,1]
  # values
  #  x      x     x     o     x     x     o     o  o  -  x  x  x  x  x  x  x  o

  class ImageBidon
    include ImageHelper
    def width
      6
    end
    def height
      3
    end
  end

  before do
    @img = ImageBidon.new
  end

  it "can convert 2D coordinates into array index" do
    @img.convert_2D_to_1D(5,2).must_equal(17)
    @img.convert_2D_to_1D(1,0).must_equal(1)
    @img.convert_2D_to_1D(2,0).must_equal(2)
    @img.convert_2D_to_1D(0,1).must_equal(6)
  end

  it "can convert array index into 2D coordinates" do
    @img.convert_1D_to_2D(1).must_equal([1,0])
    @img.convert_1D_to_2D(2).must_equal([2,0])
    @img.convert_1D_to_2D(6).must_equal([0,1])
    @img.convert_1D_to_2D(17).must_equal([5,2])
  end

  it "raise an exception if out of array of image" do
    lambda {@img.convert_1D_to_2D(18)}.must_raise(ImageHelper::OutofBound)
  end

  it "raise an exception if out of array of image" do
    lambda {@img.convert_2D_to_1D(6,2)}.must_raise(ImageHelper::OutofBound)
  end
end
