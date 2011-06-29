# Tourist

## What?

Tourist is an experiment into automated journeys through systems. I hope to use it to answer the following questions:
* Can journeys be used to test a CMS application?
* Can journeys be used to test a wizard application?
* Can journeys be used to test a restful web service?
* Can journeys be used to collect data about an application and reason about it? Can it be used to check whether a global stylesheet has unused styles? What about page load times or number of clicks required?

## Usage
Start the application we are going to test

>  `cd apps/cms`
>  `script/rails s`

Describe your application states in the maps directory

>  `location :homepage do end`
>  `location :articles do end`
>  `location :article do end`

Describe the tranisitions that can be made from state to state and how to do it.

>  `location :a_location`
>  `  to :another_location do end`
>  `end`

### Calculate the plan
>  `ruby test.rb plan`

desired side effect: 
* new file called reports/map.gv
* new file called reports/coverage.gv

### Execute the plan
>  `ruby test.rb execute`

desired side effect:
* new file called reports/observations.yml

### Print the Observations
>  `ruby test.rb print`

### Validate the observations
>  `ruby test.rb validate`

desired side effect:
* new file called reports/validation.?

## What is interesting about this?
Here is some speculation about why this might be interesting

### Intention
When I want to plan a journey, I can now ask a computer how to get from A to B and it will work out all the details for me. My intention is important, the details are not. Tourist allows you to describe your intention and it will resolve a path through the system that it can execute. So you probably won't have to to write a big procedure for each scenario you have.

### Test Coverage
Building a map of the system's states will allow us to visualise coverage in a graph. You will be able to see what states are still not visited.

### Reduce Waste
A single journey could cover a large number of states in the system. This is quite different from the approach of writing a lot of tests that test a single concern. Each of these tests probably repeats a large number of steps, such as loggin in, setting up data, etc.

### Exploring
An interactive mode could allow someone to navigate a system.

### Recording Data
What if we just wrote down what we saw and checked it later? If something went wrong, we would probably have more data to work with so it would be easier to tell what went wrong. 

## Why?

Test frameworks that focus on acceptance testing often repeat the same steps over and over again. Isn't once enough? I'm tired of slow, inefficient testing suites that look a lot like unit tests at a functional level.

so if you had states a, b, c and d that you wanted to test, the execution would look like:
a
a -> b
a -> c
a -> d

One nice feature of this approach is that if you had infinite machines, the testing would take only as long as the longest test.

For those without huge infrastructure for scaling testing, a journey might allow more to be done with less. A journey might look something more like this:
a -> b -> c -> d

Is thinking in terms of states a useful thing? I think it is progress when we are thinking in these terms because it is clearer than a script as to the value of the testing.

## What are you trying to do?

Acceptance Test Journeys are considered a way to reduce this inefficiency by combining many similar tests into one. I think it is clunky to implement journies in current tooling such as cucumber or jbehave. So I'm trying trying to solve some of the problems in scaling a testing suite. I'm trying out a number of ideas to help such as:

* Can we create a state transition map that allows us to find journeys based on only some end goal?
* Delay assertions until after testing is done. This means seperating observation from assertion.
* Users know things, so let's model it so that Users have data.
* Scenarios that describe things users do at a macro level.

## What do I need to know
* What does my map look like?
* What do my plans look like?
* What is not yet covered, and what is the best journey to cover it with?

# how do you model system state changes?

