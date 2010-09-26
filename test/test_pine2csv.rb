require 'helper'

class TestPine2csv < Test::Unit::TestCase
  context "Require valid data" do
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
  end

  context "Accept valid single entries" do
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


    should "allow bracketed email recipient with no name" do
      @p.abook = "ben\tben\t<bwalton@example.com>\n"
      assert_equal @p.to_csv, "ben,ben,person,<bwalton@example.com>\n"
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

    should "allow recipient with single quoted name with embedded quote" do
      @p.abook = "ben\tben\t'Ben O''Walton' <bwalton@example.org>\n"
      assert_equal @p.to_csv, "ben,ben,person,Ben O'Walton <bwalton@example.org>\n"
    end

    should "allow recipient with double quoted name with embedded double quote" do
      @p.abook = "ben\tben\t\"Ben \"\"quoted\"\" Walton\" <bwalton@example.org>\n"
      assert_equal @p.to_csv, "ben,ben,person,\"Ben \"\"quoted\"\" Walton <bwalton@example.org>\"\n"
    end

    should "allow simple group" do
      @p.abook = "bens\tthe bens\t(ben1@example.com,ben2@example.com)\n"
      assert_equal @p.to_csv, "bens,the bens,group,<ben1@example.com>,<ben2@example.com>\n"
    end

    should "allow group with single quoted names" do
      @p.abook = "bens\tthe bens\t('ben1' <ben1@example.com>, 'ben2' <ben2@example.com>)\n"
      assert_equal @p.to_csv, "bens,the bens,group,ben1 <ben1@example.com>,ben2 <ben2@example.com>\n"
    end

    should "allow group with double quoted names" do
      @p.abook = "bens\tthe bens\t(\"ben1\" <ben1@example.com>, \"ben2\" <ben2@example.com>)\n"
      assert_equal @p.to_csv, "bens,the bens,group,ben1 <ben1@example.com>,ben2 <ben2@example.com>\n"
    end

    should "allow group with double quoted names containing double quotes" do
      @p.abook = "bens\tthe bens\t(\"ben1\" <ben1@example.com>, \"ben2 o\"\"walton\" <ben2@example.com>)\n"
      assert_equal @p.to_csv, "bens,the bens,group,ben1 <ben1@example.com>,\"ben2 o\"\"walton <ben2@example.com>\"\n"
    end

    should "allow group with double quoted names containing single quotes" do
      @p.abook = "bens\tthe bens\t(\"ben1\" <ben1@example.com>, \"ben2 o'walton\" <ben2@example.com>)\n"
      assert_equal @p.to_csv, "bens,the bens,group,ben1 <ben1@example.com>,ben2 o'walton <ben2@example.com>\n"
    end

    should "allow group with quoted names containing single quotes" do
      @p.abook = "bens\tthe bens\t(\"ben1\" <ben1@example.com>, 'ben2 o''walton' <ben2@example.com>)\n"
      assert_equal @p.to_csv, "bens,the bens,group,ben1 <ben1@example.com>,ben2 o'walton <ben2@example.com>\n"
    end

    should "allow continuation after nickname" do
      @p.abook = "ben\t\n   ben walton\tbwalton@example.com\n"
      assert_equal @p.to_csv, "ben,ben walton,person,<bwalton@example.com>\n"
    end

    should "allow continuation after name" do
      @p.abook = "ben\tben walton\t\n   bwalton@example.com\n"
      assert_equal @p.to_csv, "ben,ben walton,person,<bwalton@example.com>\n"
    end

    should "allow continuation after email (with fcc)" do
      @p.abook = "ben\tben walton\tbwalton@example.com\t\n   fcc\n"
      assert_equal @p.to_csv, "ben,ben walton,person,<bwalton@example.com>\n"
    end

    should "allow continuation after fcc (with comment)" do
      @p.abook = "ben\tben walton\tbwalton@example.com\tfcc\t\n   comment\n"
      assert_equal @p.to_csv, "ben,ben walton,person,<bwalton@example.com>\n"
    end

    should "allow multiple continuations" do
      @p.abook = "ben\t\n   ben walton\tbwalton@example.com\tfcc\t\n   comment\n"
      assert_equal @p.to_csv, "ben,ben walton,person,<bwalton@example.com>\n"
      @p.abook = "ben\tben walton\t\n   bwalton@example.com\tfcc\t\n   comment\n"
      assert_equal @p.to_csv, "ben,ben walton,person,<bwalton@example.com>\n"
      @p.abook = "ben\tben walton\t\n   bwalton@example.com\t\n   fcc\t\n   comment\n"
      assert_equal @p.to_csv, "ben,ben walton,person,<bwalton@example.com>\n"
    end
  end

  context "Reject invalid entries" do
    setup do
      @p = Pine2CSV.new
    end

    should "reject missing recipient" do
      [ "ben\tben walton\t\tfcc\tcomment\n",
        "ben\tben walton\t\n",
        "ben\tben walton\n"
      ].each do |missing_recip|
        @p.abook = missing_recip
        assert_raise Pine2CSV::Error do
          @p.to_csv
        end
      end
    end

    should "reject non-escaped quotes in name field" do
      [
       "ben\t'ben o'walton'\tbwalton@example.org\n",
       "ben\t\"ben \"bad quote\" walton\"\tbwalton@example.org\n"
      ].each do |bad|
        @p.abook = bad
        assert_raise Pine2CSV::Error do
          @p.to_csv
        end
      end
    end

    should "reject missing angle quote on email" do
      [ "ben\tben walton\t<bwalton@example.com\n",
        "ben\tben walton\tbwalton@example.com>\n"
      ].each do |missing_bracket|
        @p.abook = missing_bracket
        assert_raise Pine2CSV::Error do
          @p.to_csv
        end
      end
    end
  end

  context "Accept multiple lines" do
    setup do
      @p = Pine2CSV.new
    end

    should "allow multiple lines" do
      @p.abook = "ben\tben walton\tbwalton@example.org\nben\tben walton\tbwalton@example.org\n"
      assert_equal @p.to_csv, "ben,ben walton,person,<bwalton@example.org>\nben,ben walton,person,<bwalton@example.org>\n"
    end
  end
end
