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

    should "allow groups with fcc values" do
      @p.abook = "bens\tthe bens\t(ben1@example.com,ben2@example.com)\tfcc\n"
      assert_equal @p.to_csv, "bens,the bens,group,<ben1@example.com>,<ben2@example.com>\n"
    end

    should "allow groups with fcc and comment values" do
      @p.abook = "bens\tthe bens\t(ben1@example.com,ben2@example.com)\tfcc\tcomment\n"
      assert_equal @p.to_csv, "bens,the bens,group,<ben1@example.com>,<ben2@example.com>\n"
    end

    should "allow group with only one member" do
      @p.abook = "bens\tthe bens\t(ben1@example.com)\n"
      assert_equal @p.to_csv, "bens,the bens,group,<ben1@example.com>\n"
    end

    should "allow group with only one (named) member" do
      @p.abook = "bens\tthe bens\t('ben1' <ben1@example.com>)\n"
      assert_equal @p.to_csv, "bens,the bens,group,ben1 <ben1@example.com>\n"
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
      [ "ben\t\n   ben walton\tbwalton@example.com\tfcc\t\n   comment\n",
        "ben\tben walton\t\n   bwalton@example.com\tfcc\t\n   comment\n",
        "ben\tben walton\t\n   bwalton@example.com\t\n   fcc\t\n   comment\n"
      ].each do |continued_line|
        @p.abook = continued_line
        assert_equal @p.to_csv, "ben,ben walton,person,<bwalton@example.com>\n"
      end
    end

    should "allow continuations in a group list" do
      @p.abook = "bens\tthe bens\t(\n   ben1@example.com,\n   ben2@example.com,\n   ben3@example.com)\n"
      assert_equal @p.to_csv, "bens,the bens,group,<ben1@example.com>,<ben2@example.com>,<ben3@example.com>\n"
    end

    should "allow continuations in a group list with named recipients" do
      @p.abook = "bens\tthe bens\t(\n   'ben1' <ben1@example.com>,\n   ben2@example.com,\n   ben3@example.com)\n"
      assert_equal @p.to_csv, "bens,the bens,group,ben1 <ben1@example.com>,<ben2@example.com>,<ben3@example.com>\n"
    end

    should "allow group with fcc and command mixed in continuations" do
      @p.abook = "bens\tthe bens\t\n   (bwalton@example.org,\n   ben2@example.org)\t\n   fcc\tcomment\n"
      assert_equal @p.to_csv, "bens,the bens,group,<bwalton@example.org>,<ben2@example.org>\n"
    end

  end


  context "Reject invalid entries" do
    setup do
      @p = Pine2CSV.new
    end

    should "reject entry with no newline" do
      [ "ben\tben\tbwalton@example.org",
        "ben1\tben1\tben1@example.org\nben2\tben2\tben2@example.org"
      ].each do |missing_eol|
        @p.abook = missing_eol
        assert_raise Pine2CSV::Error do
          @p.to_csv
        end
      end
    end

    should "reject abook with extra newline" do
      @p.abook = "ben\tben\tbwalton@example.org\n\n"
      assert_raise Pine2CSV::Error do
        @p.to_csv
      end
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

    should "reject recipient with no @ in address" do
      [ "ben\tben walton\tbwaltonATexample.org\n",
        "ben\tben walton\t<bwaltonATexample.org>\n"
      ].each do |bad_address|
        @p.abook = bad_address
        assert_raise Pine2CSV::Error do
          @p.to_csv
        end
      end
    end

    should "reject named recipient when address not bracketed" do
      @p.abook = "ben\tben\t'ben' bwalton@example.com\n"
      assert_raise Pine2CSV::Error do
        @p.to_csv
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

    should "reject groups with missing brackets" do
      [ "bens\tthe bens\tben1@example.com,ben2@example.com\n",
        "bens\tthe bens\t(ben1@example.com,ben2@example.com\n",
        "bens\tthe bens\tben1@example.com,ben2@example.com)\n"
      ].each do |missing_bracket|
        @p.abook = missing_bracket
        assert_raise Pine2CSV::Error do
          @p.to_csv
        end
      end
    end

    should "reject entries with dangling continuations" do
      [ "ben\tben\tbwalton@example.org\n   ",
        "ben\tben\tbwalton@example.org\tfcc\n   ",
        "ben\tben\tbwalton@example.org\t\n   fcc\n   ",
      ].each do |bad_cont|
        @p.abook = bad_cont
        assert_raise Pine2CSV::Error do
          @p.to_csv
        end
      end
    end

    should "reject a bad continuation mixed in valid entries" do
      @p.abook = "ben\tben\tbwalton@example.org\nben2\tben2\n   \nben3\tben3\tben3@example.org\n"
      assert_raise Pine2CSV::Error do
        @p.to_csv
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

    should "allow mixed group with single recipient lines" do
      @p.abook = "ben\tben\tbwalton@example.org\nbens\tthe bens\t(ben1@example.org,ben2@example.org)\n"
      assert_equal @p.to_csv, "ben,ben,person,<bwalton@example.org>\nbens,the bens,group,<ben1@example.org>,<ben2@example.org>\n"

      @p.abook = "bens\tthe bens\t(ben1@example.org,ben2@example.org)\nben\tben\tbwalton@example.org\n"
      assert_equal @p.to_csv, "bens,the bens,group,<ben1@example.org>,<ben2@example.org>\nben,ben,person,<bwalton@example.org>\n"
    end
  end
end
