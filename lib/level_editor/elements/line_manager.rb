module LevelEditor
  class LineManager
    attr_reader :image_interroger

    COLOR = "black"

    def initialize(image_interroger)
      @image_interroger = image_interroger
    end
  end
end
