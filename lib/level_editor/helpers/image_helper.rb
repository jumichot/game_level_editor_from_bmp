module ImageHelper
  def convert_2D_to_1D(x,y)
    raise OutofBound if x >= width or y  >= height
    x + (y * width)
  end

  def convert_1D_to_2D(index)
    raise OutofBound if index > ((width * height )-1)
    [index % width,index / width ]
  end

  class OutofBound < Exception
  end
end
