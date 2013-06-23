module LevelEditor
  class Editor
    attr_reader :image, :objects
    def initialize(image_path)
      @image = LevelEditor::Image.new image_path
      @objects = @image.detect_objects
    end
  end
end
