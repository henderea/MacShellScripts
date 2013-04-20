My Mac shell scripts
====================

This repository is a collection of the shell scripts I have written for my Mac.

---

Here are the descriptions for the scripts:

* `chmodrd`: recursively change the permissions to the given parameter on all directories within and including the one given
   * **parameters:**
      * the directory permission bits (same as first parameter to regular `chmod`)
      * the folder name
   * **action:** recursively change the permissions to the given parameter on all directories within and including the one given
* `chmodrf`: recursively change the permissions to the given parameter on all files within the directory given
   * **parameters:**
      * the file permission bits (same as first parameter to regular `chmod`)
      * the folder name
   * **action:** recursively change the permissions to the given parameter on all files within the directory given
* `cssmin`: use the YUI compressor to minify a CSS file
   * **parameters:**
      * the filename (single file)
      * any optional YUI compressor parameters
   * **outputs:** the minified file with name `<name>.min.css`, where `<name>` is the name of the input file without the extension
   * **displays:** prints the file size percent remaining
   * **requires:** `yuicompressor-2.4.7.jar` and `fsizecomp`
* `factors`: find the factor of a number including 1, but not the number itself
   * **required parameters:**
      * the number (a positive integer)
   * **optional parameters:**
      * `-1` to output one per line; disables default delimeter
      * `-d DELIM` or `--delimiter DELIM` to use `DELIM` as the delimiter; overrides delimiter disable of `-1`; leaving `DELIM` blank will disable the delimiter
   * **displays:** prints the factors separated by a delimiter (if not disabled).  If `-1` has been specified, the factors will be on separate lines
   * **requires:** Ruby and `lib/format.rb`
* `factorsum`: find the sum of the factors of a number and output it along with the percentage it is of the number
   * **parameters:**
      * the number (a positive integer)
   * **displays:** prints the sum of the factors of the number as well as what percentage it is of the number, or an error message if the input is missing or not a positive integer
   * **requires:** Ruby and `lib/format.rb`
* `fsize`: get the size of a file
   * **used in:** `fsizecomp`
* `fsizecomp`: compare the sizes of 2 files
   * **used in:** `cssmin`, `jscomp`, and `jsmin`
   * **requires:** `fsize`
* `jscomp`: use the Closure JavaScript compiler to compile and minify a JavaScript file
   * **parameters:**
      * the filename (single file)
   * **outputs:** the commpressed file with name `<name>.comp.js`, where `<name>` is the name of the input file without the extension
   * **displays:** prints the file size percent remaining
   * **requires:** `compiler.jar` and `fsizecomp`
* `jsmin`: use the YUI compressor to minify a JavaScript file
   * **parameters:**
      * the filename (single file)
      * any optional YUI compressor parameters
   * **outputs:** the minified file with name `<name>.min.js`, where `<name>` is the name of the input file without the extension
   * **displays:** prints the file size percent remaining
   * **note:** `jscomp` is probably better
   * **requires:** `yuicompressor-2.4.7.jar` and `fsizecomp`
* `mvnst`: run a maven build, skipping tests
   * **displays:** a Growl notification indicating success or failure
   * **requires:** maven, Growl, and `growlnotify`
   * **note:** `growlnotify` is available in Homebrew and from the Growl website
* `mvnst2`: a Ruby script that runs a maven build, skipping tests, and only outputs the lines that come after a compile failure or build success start line
   * **parameters:**
      * optional: `-t` or `--timer` to display a timer while the build is in progress
   * **displays:** a Growl notification indicating success or failure
   * **requires:** maven, Growl, and `growlnotify`
   * **note:** `growlnotify` is available in Homebrew and from the Growl website
* `mvnta`: run a maven build, including tests
   * **displays:** a Growl notification indicating success or failure
   * **requires:** maven, Growl, and `growlnotify`
   * **note:** `growlnotify` is available in Homebrew and from the Growl website
* `mvnta2`: a Ruby script that runs a maven build, including tests, and only outputs the lines that come after a compile failure or test result start line
   * **parameters:**
      * optional: `-t` or `--timer` to display a timer while the build is in progress
   * **displays:** a Growl notification indicating success or failure
   * **requires:** Ruby, maven, Growl, and `growlnotify`
   * **note:** `growlnotify` is available in Homebrew and from the Growl website
* `mvr`: a Ruby script that allows you to rename a group of files via regular expression
   * **parameters:**
      * match pattern
      * replacement pattern (use `\1` for first match, `\2` for second match, and so on)
      * filenames
   * **displays:** prints a color-coded list of file names and their replacement names; also asks for confirmation
      * **Color Coding:** grey background for no change, red background for conflict
   * **action:** if you type `y` or `yes` (case insensitive), it will rename the files; anything else will cause it to cancel the operation
   * **note:** you may need to change the path on the first line of the file to point to your installation of Ruby, but hopefully it will work properly as-is
   * **requires:** Ruby and `lib/format.rb`
* `openf`: open the first file in the folder
   * **note:** uses `ls -1` to get the listing
* `prg`: run the Mac purge command
   * **displays:** a Growl notification indicating how much memory was freed
   * **requires:** Growl and `growlnotify`
   * **note:** `growlnotify` is available in Homebrew and from the Growl website
* `rmf`: remove the first file in the folder
   * **note:** uses `ls -1` to get the listing

---

Here is information on the 2 JAR files:

* `compiler.jar`: the JAR file for the Closure JavaScript compiler
* `yuicompressor-2.4.7.jar` the JAR file for the YUI compressor