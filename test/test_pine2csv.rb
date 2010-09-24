require 'helper'

class TestPine2csv < Test::Unit::TestCase
  context "Accept valid single lines" do
    setup do
      @p = Pine2CSV.new
    end

    should "require abook data" do
      assert_raise Pine2CSV::Error do
        @p.to_csv
      end
    end

    should "require string data" do
      assert_raise Pine2CSV::Error do
        @p.abook = @p
      end
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

    should "not allow blank recipient" do
      @p.abook = "ben\tben walton\t\n"
      assert_raise Pine2CSV::Error do
        @p.to_csv
      end
    end

    should "allow an fcc without a comment" do
      @p.abook = "ben\tben walton\tbwalton@example.org\tfcc\n"
      assert_equal @p.to_csv, "ben,ben walton,person,<bwalton@example.org>\n"
    end

    should "allow all 5 possible fields" do
      @p.abook = "ben\tben walton\tbwalton@example.org\tfcc\tcomment text\n"
      assert_equal @p.to_csv, "ben,ben walton,person,<bwalton@example.org>\n"
    end

    should "allow double quoted name" do
      @p.abook = "ben\t\"ben walton\"\tbwalton@example.org\tfcc\tcomment text\n"
      assert_equal @p.to_csv, "ben,ben walton,person,<bwalton@example.org>\n"
    end

    should "allow single quoted name" do
      @p.abook = "ben\t'ben walton'\tbwalton@example.org\tfcc\tcomment text\n"
      assert_equal @p.to_csv, "ben,ben walton,person,<bwalton@example.org>\n"
    end

    should "allow single quoted name with embedded single quote" do
      @p.abook = "ben\t'ben o''walton'\tbwalton@example.org\tfcc\tcomment text\n"
      assert_equal @p.to_csv, "ben,ben o'walton,person,<bwalton@example.org>\n"
    end

    should "allow double quoted name with embedded double quote" do
      @p.abook = "ben\t\"ben \"\"quoted\"\" walton\"\tbwalton@example.org\tfcc\tcomment text\n"
      assert_equal @p.to_csv, "ben,\"ben \"\"quoted\"\" walton\",person,<bwalton@example.org>\n"
    end


    should "allow recipient with name and email" do
      @p.abook = "ben\tben\tBen Walton <bwalton@example.org>\n"
      assert_equal @p.to_csv, "ben,ben,person,Ben Walton <bwalton@example.org>\n"
    end

    should "allow recipient with double quoted name" do
      @p.abook = "ben\tben\t\"Ben Walton\" <bwalton@example.org>\n"
      assert_equal @p.to_csv, "ben,ben,person,Ben Walton <bwalton@example.org>\n"
    end

    should "allow recipient with single quoted name" do
      @p.abook = "ben\tben\t'Ben Walton' <bwalton@example.org>\n"
      assert_equal @p.to_csv, "ben,ben,person,Ben Walton <bwalton@example.org>\n"
    end

    should "allow recipient with single quoted name with embedded double quote" do
      @p.abook = "ben\tben\t'Ben \"quoted\" Walton' <bwalton@example.org>\n"
      assert_equal @p.to_csv, "ben,ben,person,\"Ben \"\"quoted\"\" Walton <bwalton@example.org>\"\n"
    end
  end
end
