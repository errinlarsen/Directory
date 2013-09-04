module Switchvox
  class Extension
    attr_reader :name, :ext

    def initialize(options = {})
      @name = options["display"] || "unknown"
      @ext = options["number"]   || "0000"
    end

    def nope_doesnt_happen
      puts "never gets here"
    end
  end
end
