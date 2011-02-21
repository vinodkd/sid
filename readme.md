Sid: Say its done..
===================
Sid is a system that allows you to specify an application's architecture to the level you're comfortable, and then asks the question:
    "Ok, **say all that's done**, now...

* how is feature x going to implemented?"
* what goes into component x? Is is built? Or just used? Or bought?"
* how does the architecture look like?"

it therefore servers as a documentation of architecture, and (much like BDD does for features) allows thinking about the architecture in a lightweight fashion.
it also helps to validate some of the dependencies between aspects of architecture by allowing expression of those dependencies.

Sid is, therefore:

* a file format to specify the early architecture of an app
* a tool that reads said file format and:
  * displays it
  * processes it to ask questions such as:
    * what features does your application have? what capabilities?
    * what logical componenents are required to meet those features and capabilities?
    * how would the logical components fit together?
    * how would you realize the logical components? what would you build and/or buy/reuse?
* (future) a tool that consolidates accross multiple sid files and generates a project roadmap
* (future) a tool to extract out BDD-style feature definitions from the sid spec.

Audience
--------
* developers starting on their pet projects who want a bit of definition around their initial architecture thinking
* organizations that need a lightweight project description/validation tool

Samples
-------
* Sid's own sid spec is available at the root. The source is sid-vxx.sid and the output is sid-vxx.html
   ** note: the source file has more information than the display processes currently. That's the big open todo
* There are more samples in /test

Getting Started
---------------
* install ruby
* download sid
* create a .sid file of your own
* run sid:
    `sid yourapp.sid`
    
Todos:
======
* Add logic to display child component definitions
