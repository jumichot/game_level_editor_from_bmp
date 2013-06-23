require "minitest_helper"

describe LevelEditor::ObjectManager do

  before do
    @image_interroger = LevelEditor::ImageInterroger.new("images/test_case_4.bmp")
    @object_manager = LevelEditor::ObjectManager.new(@image_interroger)
  end

  describe "poisons" do
    it "no poison = empty array" do
      @object_manager.poisons.must_be_empty
    end

    it "can find the poisons" do
      scan_poisons
      @object_manager.poisons.count.must_equal(3)
    end

    it "can have the coordinates of poisons" do
      scan_poisons
      @object_manager.poisons.must_equal([[0,0],[1,1],[3,2]])
    end

    def scan_poisons
      @object_manager.scan_pixel(0,0)
      @object_manager.scan_pixel(3,2)
      @object_manager.scan_pixel(1,1)
    end
  end

end
