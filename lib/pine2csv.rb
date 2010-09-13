require 'rubygems'
require 'treetop'
require 'polyglot'
require 'pine_addressbook'

class Pine2CSV
  def initialize(abook)
    @abook = abook
    @parser = PineAddressbookParser.new
  end

  def to_csv
    tree = @parser.parse(@abook)
    if tree.nil?
      $stderr.puts @parser.failure_reason
    else
      tree.to_csv
    end
  end
end
