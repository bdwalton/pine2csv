require 'rubygems'
require 'treetop'
require 'polyglot'
require 'pine_addressbook'

class Pine2CSV
  attr :abook, true

  def initialize(abook = nil)
    @abook = abook if abook
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
