Journal
=======
*Sun Feb 24 01:58:17 2013* : Beginning a journal as I'm taking up sid after a long hiatus. I finally got bart working with sid correctly, but when I got it to run all the test?.arch files, all of them failed. Since it has been over a year that I've not worked on sid, I didnt understand why they were failing. About 5-8 hours later I know this:

- test1.arch always failed. 
- test2-4 used to work, but now dont because of the introduction of gen_children.rb.
- test5-6 always failed. I still dont know if that's a good thing.

All of this is in the shadow of the "impending since 2 years for now" rewrite to version 2, which would be plugin-based heaven. My game plan right now is to either get it to work with children with some reasonable amount of effort, or to focus on the rewite instead. Ruby itself has changed quite a lot in the year(s) between - especially on YAML support that sid uses.

Sun Feb 24 05:51:55 2013 : Sort of figured out how to get children generated in teh ast, but still trying to figure out how to get it to generate the html. fixed the ast generation by calling a Sid.new() but currently cheating by giving it a file to process anyway. this will break for others. refactored sid.erb to extract common logic out and put it in gen_impl_details.erb, but its not working yet.

Sun Feb 24 06:25:58 2013 : still trying to figure out why the sub sid.new doesnt return output

Sun Feb 24 11:51:48 2013 : figured it out. sid.new was not the right thing to call. the root doc has the structure
	 root
	 	/features
	 	/capabilities
	    /requires
	    /realizing-architecture
	    /to-build
	    	/<<component name>>
..while the components under the child `to-build` has the structure:

	<<component name>>
		/requires
		/realizing-architecture.

so the right thing to do was to call a subset of the process and generate logic. So I had to refactor out just the required bits into `process_impl_details()` and `gen_impl_details.erb`.

The new impl seems to work for sid.arch. todos: 
	- run bart on all the test arch files
	- fix the arch diagram logic. This still works for the main architecture diagram alone

Sun Feb 24 12:47:38 2013 : was trying to put a name for the main and sub to-build components so that the arch.png will have a unique suffix when the wife wanted me to be with her while she cooked.

Sun Feb 24 14:14:05 2013 : just found an issue with the process logic: sid.rb:173-182 needs to treat the case where a component is refered to but not declared above separate from a declared component that might have implementation details. right now both are subsumed. will fix it after getting the gen code to work for arch images

Sun Feb 24 15:45:10 2013 : fixed all issues with img creation as well as the process logic. Naming this version 1.5 because its not quite the rewrite that warrants a 2.0 tag; yet fixes a lot of issues and makes sid really usable now.
Sun Feb 24 17:32:10 2013 : Todo: figure out how best to organize documentation. The current gh-pages is out of sync with the recent changes and i dont see the point of continuing. maybe just keep the readme updated, keep the dogfood files out of gitignore and then point to the generated html should do it, methinks.
Sat Apr  6 05:15:40 2013: Fixed the unique names for child architecture diagrams problem again. Dont know how that code got missed, but couldnt find it at all, so i rewrote that logic. Discovered it when I ran sid agains wordpic.
