This is a refactoring exercise.

The `searches.csv` file contains information about a number of searches
performed on Loco2.com. The three fields are:

1. Start
2. Finish
3. Duration the search took to complete

The `analyse_searches.rb` file contains some code to analyse this data.
For each unique pair of start and finish stations, it computes the
number of searches performed, as well as the min, max and mean
durations.

It outputs this information as an HTML table, showing the most popular
searches first.

You can run the code like this:

    $ ruby analyse_searches.rb > output.html

You can then open the `output.html` file in your browser to see the
results.

## Your task ##

Your task is to refactor the code to make it more maintainable and
easier to change.

There are no tests. If you want to add some, please feel free. However
you will not be marked down for not adding tests; we're primarily
interested in how you restructure the production code. If tests help
you, use them, if not, don't.

## If you're not familiar with Ruby ##

We're open to applicants who are not already familiar with Ruby,
provided they have good experience in another language and can show that
they'd be able to get to grips with Ruby. If you don't know Ruby, this
task will obviously be harder for you. Therefore please note this in the
`YOUR_NOTES.md` file and we'll bear it in mind when reviewing your
solution.

## Hints ##

* As with task 1, think about separation of concerns: parsing, domain
  modeling and output formatting
* Please don't spend time making the HTML output pretty; that's not what
  we're testing here
* Feel free to use external libraries if they are useful
