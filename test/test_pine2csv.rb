require 'helper'

class TestPine2csv < Test::Unit::TestCase
  context "Accept valid single lines" do
    setup do
      @p = Pine2CSV.new
    end

    should "take simple line" do
      @p.abook = "ben\tben walton\tbwalton@example.org\n"
      assert_equal @p.to_csv, "ben,ben walton,person,<bwalton@example.org>\n"
    end

    should "allow blank nickname" do
      @p.abook = "\tben walton\tbwalton@example.org\n"
      assert_equal @p.to_csv, "\"\",ben walton,person,<bwalton@example.org>\n"
    end

    should "allow blank name" do
      @p.abook = "ben\t\tbwalton@example.org\n"
      assert_equal @p.to_csv, "ben,\"\",person,<bwalton@example.org>\n"
    end
  end
end
