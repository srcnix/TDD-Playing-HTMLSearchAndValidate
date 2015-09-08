module SearchEngines
  class Base
    USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:32.0) '+
                 'Gecko/20100101 Firefox/32.0'

    attr_reader :agent

    def initialize
      @agent = Mechanize.new

      self.agent.user_agent = USER_AGENT
    end

    def get_content_for_link(link)
      page = link.click

      page.content
    end
  end
end
