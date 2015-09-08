#TDD - HTML Search and Validate example

##Prerequisites

* The only available search engine to use is Google
* The only available validator to use is W3CMarkup

##Basic usage:

Note: Don't forget to run bundle install

```ssh
ruby ./bin/first_link_validator.rb
```

Specify query to search

```ssh
ruby ./bin/first_link_validator.rb --query 'Ruby on Rails'
```

Specify search engine to use

```ssh
ruby ./bin/first_link_validator.rb --search_engine 'Google'
```

Specify validator to use

```ssh
ruby ./bin/first_link_validator.rb --validator 'W3CMarkup'
```

##Adding a search engine
You can add a search engine by extending SearchEngines::Base. The following methods are required for compatibility:

* get_links_for(query)
* search(query)

##Adding a validator
You can add an additional validator by extending Validators::Base. The following methods are required for compatibility:

* validate_content(content)

##TO DO / Possible optimising
As this is purely an example time has not permitted optimising the code base. However, it could be enhanced by doing the following

* Speed up tests by mocking external requests
* Speed up tests by stubbing additional methods with return values
* Cache search results for duration
* Possible: Use meta programming for proxying methods from SearchLinks to SearchEngines
