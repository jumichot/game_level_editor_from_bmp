module LevelEditor
  class Editor
    attr_reader :image, :objects, :line_manager

    def initialize(image_path)
      @image = Image.new image_path
      @line_manager = LineManager.new(@image)
      @objects = @image.detect_objects
    end
  end
end
