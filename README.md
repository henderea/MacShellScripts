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
* `kmeans`: calculate the kmeans on a set of data
    * **required parameters:**
        * k (the number of means)
    * **optional parameters:**
        * `-f FILE` or `--file FILE` to read data from the file `FILE`, assuming 1 entry per line (default is to read from `stdin` (EOF or blank line signals end of input))
        * `-1` or `--one-per-line` to output one per line; disables default delimeter
        * `-d DELIM` or `--delimiter DELIM` to use `DELIM` as the delimiter; overrides delimiter disable of `-1`; leaving `DELIM` blank will disable the delimiter (default delimeter is ', ' (comma followed by a space))
    * **displays:** the k-means for the clusters, using the provided k
    * **requires:** Ruby, `lib/maputil.rb`, and `lib/kmeans.rb`
    * **note:** you may need to change the path on the first line of the file to point to your installation of Ruby, but hopefully it will work properly as-is
* `mvn2`: a Ruby script that runs a maven build, including (or not including) tests, and only outputs the lines that come after a compile failure, build success, test result, or reactor summary start line
    * **optional parameters:**
        * `-t` or `--timer` to display a timer while the build is in progress (default is display nothing)
        * `-s` or `--skip-tests` to skip tests (default is running tests)
        * `-n` or `--no-sticky` to make the growl notification non-sticky (default is sticky)
        * `-a` or `--display-all` to display all output (default is to only display the output after a compile failure, build success, test result, or reactor summary start line)
        * `-k` or `--track-average` to update the average (stored in `avg.txt`) and also display a progress bar while the build is in progress (default is not to do track average or display progress bar)
        * `-u` or `--track-full-average` to update the average list (stored in `avg-skip.txt` or `avg-test.txt`) and also display a progress bar while the build is in progress (default is to not do track average or display progress bar) (including this option will cause the progress bar to use the average calculated from the average list if available, but if `-k` or `--track-average` is specified, `avg.txt` will still be updated)
        * `-c` or `--colored` to display some colors in the timer/progress message
        * `-l` or `--write-log` to write all of the output to a log file (default is to not write to a log file)
        * `-f NAME` or `--log-file NAME` to set the log file name to `NAME` (default is `build.log`)
        * `-d` or `--advanced-average` to use k-means (with minimum optimal k) to find a list of averages and use the closest one for the progress bar and displayed average (default is to use overall average)
        * `-o` or `--command-override` to override the maven command (disables average tracking options and skip test option) (default is `clean install` (with optional `-D skipTests`) and not disabling any options)
        * `-p` or `--package` to run `mvn clean package` (with optional `-D skipTests`) (default is `mvn clean install` (with optional `-D skipTests`) (supports average tracking)
        * `-h` or `--hide-between` to hide the output between the end of test results (the line starting with "Tests run:") and the next trigger line
        * `-w` or `--show-average` to show the average(s) before and after the build (average tracking must be enabled) (default is to not show averages)
    * **displays:** a Growl notification indicating success or failure
    * **requires:** Ruby, maven, Growl, `growlnotify`, `lib/format.rb`, `lib/maputil.rb`, and `lib/kmeans.rb`
    * **note:** `growlnotify` is available in Homebrew and from the Growl website
* `mvr`: a Ruby script that allows you to rename a group of files via regular expression
    * **required parameters:**
        * match pattern
        * replacement pattern (use `\1` for first match, `\2` for second match, and so on)
        * filenames
    * **optional parameters:**
        * `-e` or `--exclude-extension` to exclude the extension of the file from the pattern matching/replacement
    * **displays:** prints a color-coded list of file names and their replacement names; also asks for confirmation
        * **Color Coding:** grey background for no change, red background for conflict
    * **action:** if you type `y` or `yes` (case insensitive), it will rename the files; anything else will cause it to cancel the operation
    * **note:** you may need to change the path on the first line of the file to point to your installation of Ruby, but hopefully it will work properly as-is
    * **requires:** Ruby and `lib/format.rb`
* `nmeans`: calculate the nmeans on a set of data
    * **optional parameters:**
        * `-f FILE` or `--file FILE` to read data from the file `FILE`, assuming 1 entry per line (default is to read from `stdin` (EOF or blank line signals end of input))
        * `-1` or `--one-per-line` to output one per line; disables default delimeter
        * `-d DELIM` or `--delimiter DELIM` to use `DELIM` as the delimiter; overrides delimiter disable of `-1`; leaving `DELIM` blank will disable the delimiter (default delimeter is ', ' (comma followed by a space))
    * **displays:** the k-means for the clusters, using the minimum optimal k
    * **requires:** Ruby, `lib/maputil.rb`, and `lib/kmeans.rb`
    * **note:** you may need to change the path on the first line of the file to point to your installation of Ruby, but hopefully it will work properly as-is
* `outliers`: calculate the outliers of a set of data (based on clusters from n-means)
    * **optional parameters:**
        * `-f FILE` or `--file FILE` to read data from the file `FILE`, assuming 1 entry per line (default is to read from `stdin` (EOF or blank line signals end of input))
        * `-1` or `--one-per-line` to output one per line; disables default delimeter
        * `-d DELIM` or `--delimiter DELIM` to use `DELIM` as the delimiter; overrides delimiter disable of `-1`; leaving `DELIM` blank will disable the delimiter (default delimeter is ', ' (comma followed by a space))
        * `-s LEVEL` or `--sensitivity LEVEL` to set the sensitivity level to `LEVEL` (float between 0 and 1) (default is 0.5)
        * `-k KVALUE` or `--k-value KVALUE` to fix k at `KVALUE` instead of using the minimum optimal k
    * **displays:** the k-means for the clusters, using the minimum optimal k
    * **requires:** Ruby, `lib/maputil.rb`, and `lib/kmeans.rb`
    * **note:** you may need to change the path on the first line of the file to point to your installation of Ruby, but hopefully it will work properly as-is
    * **requires:** Ruby, `lib/maputil.rb`, and `lib/kmeans.rb`
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