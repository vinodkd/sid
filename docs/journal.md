Journal
=======
*Sun Feb 24 01:58:17 2013* : Beginning a journal as I'm taking up sid after a long hiatus. I finally got bart working with sid correctly, but when I got it to run all the test?.arch files, all of them failed. Since it has been over a year that I've not worked on sid, I didnt understand why they were failing. About 5-8 hours later I know this:

- test1.arch always failed. 
- test2-4 used to work, but now dont because of the introduction of gen_children.rb.
- test5-6 always failed. I still dont know if that's a good thing.

All of this is in the shadow of the "impending since 2 years for now" rewrite to version 2, which would be plugin-based heaven. My game plan right now is to either get it to work with children with some reasonable amount of effort, or to focus on the rewite instead. Ruby itself has changed quite a lot in the year(s) between - especially on YAML support that sid uses.
