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

* a
* a -> b
* a -> b -> c
* a -> b -> c -> d

One nice feature of this approach is that if you had infinite machines, the testing would take only as long as the longest test.

For those without huge infrastructure for scaling testing, a journey might allow more to be done with less. A journey might look something more like this:

* a -> b -> c -> d

Is thinking in terms of states a useful thing? I think it is progress when we are thinking in these terms because it is clearer than a script as to the value of the testing.

## What are you trying to do?

I'm trying to understand whether by breaking down the problem of scaling a testing suite into smaller problems, we can achieve better scalability. Tourist attempts to use journeys to gain coverage of an application and observations to capture what happened for later. By doing so, we can temporally decouple concerns such as assertions from automation.

Acceptance Test Journeys are considered a way to reduce this inefficiency by combining many similar tests into one. I think it is clunky to implement journeys in current tooling such as cucumber or jbehave. So I'm trying trying to solve some of the problems in scaling a testing suite. I'm trying out a number of ideas to help such as:

* Can we create a state transition map that allows us to find journeys based on only some end goal?
* Delay assertions until after testing is done. This means seperating observation from assertion.
* Users know things, so let's model it so that Users have data.
* Scenarios that describe things users do at a macro level.

## The Problem with unit testing for acceptance testing

Consider the following unit test:
  it does something important
    given I these actions have been completed, where a = 1 and b = 2
    when i do something
    then the result should be 10

i only have to read these few lines to understand what the test is doing.  The intent of the test is captured in the test name. The actions I need to take are captured in the given and when. I can see all the relevant inputs that are required for the test scenario to happen. And I can see exactly what we were expecting to happen.
All the concerns that matter, the actions, inputs, expectations and intent, are tightly coupled, as one is mixed with the other in code and also temporally. A unit test is the coupling of all the concerns that matter. 

Just because it works for unit tests, does not mean the same applies at a functional level. What's good for the goose, is not necessarily good for then gander.

in functional tests, the given actions often take a very long time. They are often also very complex. In a perfect world, we would simply parallelise all tests so the testing takes as long as the longest test. This is sadly very far from reality. Projects pay for the time it takes to run functional tests in spades. Whether it's running them, or maintaining them.

Functional tests often require a number of steps to be taken to get to a state that they can test. For example, we must first log in and create a blog post before we can see it on the blog. Unit tests rarely have so many steps to take before they can be executed. 

By shoehorning our unit testing paradigm onto functional tests, I think we are missing the point. A real user doesn't usually doesn't use an application and only try one small piece of functionality, they usually want to complete a process of some kind. Unit tests at a functional level do not simulate real user behaviour.

Some say that tests should be consolidated into feature level journeys. If we were to use the unit testing paradigm to build these, it might look like a very very long procedure. And I think as we build a more higher level test, we lose the intent of what we are testing, since our single test name cannot describe all the things that are happening adequately.

Unit tests don't scale to journeys. As is common practise in other endeavours, what if we attempted to separate concerns?

journeys
  users
    input data
  itinerary
states
  transitions
  observations
  states 
    transitions
    observations
    states ...
verifications
  intent
  expected outputs

