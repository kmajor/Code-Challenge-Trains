In the `search.xml` file is some XML output from a hypothetical rail
search API. The scenario is that we have performed a search from London
to Barcelona, and this is the output which we need to parse and display.

Unfortunately the real rail APIs are nowhere near this simple, but this
example provides more than enough complexity for the challenge!

Some definitions:

* There are 3 *search results*, representing different options for
  making the journey

* A search result has one or more *connections*, representing the
  individual train rides which make up the whole journey

* A *fare* represents the cost of travelling on this train in a given
  class of service (standard class, first class, etc). The currency is
  indicated in the XML, but it's always GBP (British Pounds) in our example.
  Please note that the decimal point (`.`) separates pence/cents from pounds,
  so `25.50` means 25 pounds and 50 pence.

## Your task ##

Your task is to write a program which will parse the XML file and output
information gleaned from the data.

The output should contain the following information for each search
result:

* ID of search result
* Description of each connection (start/finish/departure time/arrival
  time/train name)
* Duration of each connection
* How many train changes need to be made
* How much time the passenger has for each train change
* Duration of the whole journey
* Fare names / prices for each connection

If you're feeling enthusastic, you could also highlight:

* The cheapest search result
* The quickest search result

## What we're looking for ##

We are mainly interested in the quality of your solution, not whether
it's 100% complete with all bells, whistles and performance
optimisations. If you run out of time, that's fine. We would rather see
a small amount of well-written object oriented and test-driven code that
is incomplete than a messy but complete solution that just happens to
work.

The formatting of the output of the program is also unimportant so don't
spend much time on this. There's no need to make it into a web app or
anything - a console program with text output is fine.

You are expected to write tests to guide your development, and make
regular commits to the repository so that we can see the progression of
how it developed. You may use whichever language, testing framework or
tools you are comfortable with.

## Hints ##

Here are some things to think about:

* Appropriate modelling of the domain using objects
* Separation of concerns: parsing, domain modelling and output
  formatting
* Avoid over-engineering
