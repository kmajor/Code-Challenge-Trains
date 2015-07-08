Write any notes you want to make here.

This could use some more work for sure, but there are only so many hours in the
day... I refactored searches to be an array of search objects instead of a hash.
This makes it searchable and more easily sorted/queried.
Also moved most of the calculations into search and out of the parsing method
Broke out the massive methods into more reasonable SRPish style methods


Todos:
Break out the html bit into something that builds the html, then outputs it.
Allow it to take parameters from the command line, no hardcoded paths.
A few of the methods aren't exactly SRP and could use more refactoring
Create some kind of display class to manage all the output
Alot of the calcs are ugly and could use a little cleanup
0 error handling as it currently stands, could use some work



