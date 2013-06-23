module LevelEditor
  class Editor
    attr_reader :image_interroger, :objects, :line_manager

    def initialize(image_path)
      @image_interroger = ImageInterroger.new image_path
      @line_manager = LineManager.new(@image_interroger)
    end

    def objects
      @all_objects ||= @image_interroger.detect_objects
    end
  end
end
