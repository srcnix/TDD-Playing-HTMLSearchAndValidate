module Validators
  class Base
    USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:32.0) '+
                 'Gecko/20100101 Firefox/32.0'

    attr_reader :agent

    def initialize
      @agent = Mechanize.new

      self.agent.user_agent = USER_AGENT
    end
  end
end
