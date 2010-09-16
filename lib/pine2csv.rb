require 'rubygems'
require 'treetop'
require 'polyglot'
require 'pine_addressbook'

class Pine2CSV

  class Error < Exception
    def initialize(msg)
      super(msg)
    end
  end

  attr :abook, true

  def initialize(abook = nil)
    @abook = abook
    @parser = PineAddressbookParser.new
  end

  def to_csv
    raise Pine2CSV::Error.new("No address book data supplied.") unless abook
    tree = @parser.parse(@abook)
    if tree.nil?
      $stderr.puts @parser.failure_reason
    else
      tree.to_csv
    end
  end
end
