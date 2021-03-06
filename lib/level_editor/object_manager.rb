module LevelEditor

  class ObjectManager

    def initialize(image_interroger)
      @image_interroger = image_interroger
      @all_objects = Hash.new{|hash, key| hash[key] = []}
    end

    ELEMENTS = {poisons: "red" , croissants: "yellow", milkeries: "blue"}

    ELEMENTS.each do |method, color|
      define_method method do
        @all_objects[method].sort || []
      end
    end

    def scan_pixel(x,y)
      pixel_color = @image_interroger.get_color(x,y)
      return unless known_object?(pixel_color)
      key = ELEMENTS.key(pixel_color)
      @all_objects[key] << [x,y]
    end

    def known_object?(pixel_color)
      ELEMENTS.has_value?(pixel_color)
    end

    def to_unity
      ELEMENTS.each do |key, value|
        @all_objects[key].uniq.each {|elem| puts "add_#{key}_bar(#{elem[0]},#{elem[1]})"}
      end
    end
  end

end
