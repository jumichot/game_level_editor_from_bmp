module LevelEditor

  class Level
    attr_reader :image_interroger, :objects, :line_manager

    def initialize(image_path)
      @image_interroger = ImageInterroger.new image_path
      @line_manager = LineManager.new(@image_interroger)
      # @objects = Hash.new{|hash, key| hash[key] = []}
    end

    def objects
      @all_objects ||= @image_interroger.detect_objects
    end

    def test
      @image_interroger.each_pixels do |x,y|
        @line_manager.scan_line(x,y)
      end
    end


  end

end
