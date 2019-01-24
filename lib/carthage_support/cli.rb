require "carthage_support"
require "thor"

module CarthageSupport
  class CLI < Thor
    desc "{usage}", "{description}"
    def setup()
      p "################## setup"
    end
  end
end
