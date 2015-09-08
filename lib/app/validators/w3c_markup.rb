module Validators
  class W3CMarkup < Base
    def validate_content(content)
      valid = true

      page = self.agent.post(
        'https://validator.w3.org/nu/?out=json',
        content,
        {
          'Content-type' => 'text/html; charset=utf-8'
        }
      )

      response = JSON.parse(page.content)

      response['messages'].each do |message|
        if ['warning', 'error'].include?(message['type'])
          valid = false
          break
        end
      end

      { valid: valid, messages: response['messages'] }
    end
  end
end
