module LevelEditor

  class Level
    attr_reader :image_interroger, :objects, :line_manager

    def initialize(image_path)
      @image_interroger = ImageInterroger.new image_path
      @line_manager = LineManager.new(@image_interroger)
    end

    def objects
      @all_objects ||= outputs_objects
    end

    def find_all_objects
      @image_interroger.each_pixels do |x,y|
        @line_manager.scan_line(x,y)
      end
    end

    def outputs_objects
      find_all_objects
      @all_objects = Hash.new{|hash, key| hash[key] = []}
      @all_objects[:horizontal_bars] = @line_manager.lines_array[:horizontal]
      @all_objects[:vertical_bars] = @line_manager.lines_array[:vertical]
      @all_objects
    end
  end

end
