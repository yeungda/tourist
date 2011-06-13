# Journey Man

# Why?

Test frameworks that focus on acceptance testing often repeat the same steps over and over again. Isn't once enough? I'm tired of slow, inefficient testing suites that look a lot like unit tests at a functional level.

so if you had states a, b, c and d that you wanted to test, the execution would look like:
a
a -> b
a -> c
a -> d

One nice feature of this approach is that if you had infinite machines, the testing would take only as long as the longest test.

For those without huge infrastructure for scaling testing, a journey might allow more to be done with less. A journey might look something more like this:
a -> b -> c -> d

# What are you trying to do?

Acceptance Test Journeys are considered a way to reduce this inefficiency by combining many similar tests into one. I think it is clunky to implement journies in current tooling such as cucumber or jbehave. So I'm trying trying to solve some of the problems in scaling a testing suite. I'm trying out a number of ideas to help such as:

* Can we create a state transition map that allows us to find journeys based on only some end goal? Will this put an end to procedural test suites? Hopefully we won't rebuild the page model
* Delay assertions until after testing is done. This means seperating observation from assertion.
* Users know things, so let's model it so that Users have data.
* Scenarios that describe things users do at a macro level.

# Design
* Data is located in users.
* States are goals users try to get to.
* State transitions describe how to get from State to State
* Scenarios describe User journeys
* Observations record what a User sees
* Assertions describe expectations for Observations
