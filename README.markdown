# Tourist

Tourist is a framework for automating acceptance test journeys. Tourist takes your users on journeys through your application's states. As it visits each state on a journey, it records observations (like a tourist taking photos). When the journeys are complete, it verifys that the observations are as expected.

Within Tourist you can describe your application as states, transitions and observations. You can simulate people using your application by describing journeys, users and expectations.

# How does Tourist take a journey?

Tourist starts by planning a journey based on the states you list that you want to visit. It uses the map of states you have created to find a path that visits all the states you have listed.

Next Tourist asks a user to visit each planned state. It does this by executing the block of code you defined in transition for getting to the next state. From time to time, a transition will require some input, like a login, which the user supplies. After each transition, the user will record any observations that are available for the state it is in.

Finally, Tourist reads each observation recorded. Any expectations that are applicable to the observation will be validated.

# Usage
Create the directory structure tourist requires
> `tourist init`

Print some information about your journeys on the console
>  `tourist describe`

List your journeys
>  `tourist list`

Take your journeys
>  `tourist journey`

Verify your observations
>  `tourist verify`

# Parallelisation

Many tourist processes can run in parallel on the same machine.

## 1 process per journey

Here is a simple way to run each journey in separate processes, with a limit of 2 processes at onceusing GNU parallel:
> `tourist list | parallel -j 2 tourist journey`
> `tourist verify`

## 1 process per bucket

By categorising your tests, you can create buckets for running in separate processes.

```
journey :x do
  category :bucket_a
end

journey :y do
  category :bucket_b
end
```

create a file called buckets containing the commands for each process:

```
tourist journey .bucket_a
tourist journey .bucket_b
```

now run each process

`cat buckets | parallel && tourist verify`

# Getting Started

Here be dragons. This is a work in progress. If you want to give it a go, these are all the steps I know of to get it to work.

## Build Tourist
```
cd tourist
bundle
./build.sh
```

## Run the CMS example
Start the example app
```
cd projects/cms
bundle
rake db:drop db:create db:migrate db:seed && rails s
```

then run the journeys
```
tourist journey
tourist verify
```

## A simple example

In this example, we will check that a search on google returns 10 results. You can also find the code in the projects/google directory

### Initialise the project
```
mkdir google
cd google
gem install tourist
tourist init
```

### Setup our testing Tool
Tourist is tool agnostic. We're going to use webdriver here.
```
gem install selenium-webdriver
```

create tools/web_driver_tool.rb
```ruby
require "selenium-webdriver"
class WebDriverTool
  def get
    @@browser ||= Selenium::WebDriver.for :firefox
  end

  def off
    @@browser.close unless @browser.nil?
  end
end

tool :browser do
  WebDriverTool.new
end
```

### Describe states of google's search
create states/start.rb
```ruby
state :start do
  to :search do |browser, data|
    browser.navigate.to data[:url]
  end
end
```

create states/search.rb
```ruby
state :search do
  to :results do |browser, data|
    browser.find_element(:name => 'q').send_keys data[:query]
    browser.find_element(:name => 'btnG').click
    wait = Selenium::WebDriver::Wait.new(:timeout => 30)
    wait.until do
      browser.find_elements(:css => '.r').size > 0
    end
  end
end
```

create states/results.rb
```ruby
state :results do
  observations do |browser|
    result_headings = browser.find_elements(:css => 'h3.r').map &:text
    {
      :results => result_headings
    }
  end
end
```

### describe a user
create users/searcher.rb
```ruby
user :searcher, :tool => :browser do
  {
    :url => 'http://www.google.com/',
    :query => 'recursion'
  }
end
```

### describe our journey
```ruby
journey :search do
  stage do
    user_name :searcher
    intention [:start, :results]
  end
end
```

### describe our expectation
```ruby
scope "Results" do
  criteria 'location' => :results

  it "should show 10 results" do |observations|
    throw 'not 10 results' unless observations[:results].size == 10
  end
end
```

### start our journey

```
$ tourist journey
@searcher -> #search -> start -> search -> results
```

we can see what we recorded in reports/observations/search.yaml

```yaml
--- 
location: :search
timestamp: 2012-06-11 19:07:49.903706 +10:00
journey: :search
tags: []

id: 1
context: []

observations: {}

--- 
location: :results
timestamp: 2012-06-11 19:07:51.306699 +10:00
journey: :search
tags: []

id: 2
context: []

observations: 
  :results: 
  - Recursion - Wikipedia, the free encyclopedia
  - Recursion (computer science) - Wikipedia, the free encyclopedia
  - Google Helps You Understand Recursion
  - "ThinkGeek :: Recursion"
  - Recursion | Define Recursion at Dictionary.com
  - Recursive | Define Recursive at Dictionary.com
  - Recursion Ventures
  - Recursion
  - Recursion -- from Wolfram MathWorld
  - Did you mean recursion? - Digg

```

### Verify our expectations
now let's verify what we've observed matches our expectations.

```
$ tourist verify
[2][OK] Results should show 10 results

1 passed, 0 failed
```

