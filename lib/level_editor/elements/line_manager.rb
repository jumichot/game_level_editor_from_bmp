module LevelEditor
  class LineManager
    attr_reader :image

    COLOR = "black"

    def initialize(level_editor_image)
      @image = level_editor_image
    end
  end
end
