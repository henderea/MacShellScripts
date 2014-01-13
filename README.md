My Mac shell scripts
====================

This repository is a collection of the shell scripts I have written for my Mac.

---

**NOTE:** if you are accessing this repository on GitHub, I have moved it to Bitbucket.  You can find it at <https://bitbucket.org/henderea/macshellscripts>.

---

**NOTE:** the ticket system has been moved to <https://everydayprogramminggenius.atlassian.net/browse/MSS>.  You should be able to log tickets without an account.

---

Here are the descriptions for the scripts:

* `chmodrd`: recursively change the permissions to the given parameter on all directories within and including the one given
* `chmodrf`: recursively change the permissions to the given parameter on all files within the directory given
* `colorconfig`: create/edit a color configuration file for `mvn2` and `mvr`
* `cssmin`: use the YUI compressor to minify a CSS file
* `factors`: find the factor of a number including 1, but not the number itself
* `factorsum`: find the sum of the factors of a number and output it along with the percentage it is of the number
* `fsize`: get the size of a file
* `fsizecomp`: compare the sizes of 2 files
* `jrank`: get jenkins rankings.  It gets data from <http://ci2.plab.interactions.net:8080/cigame/?> and sorts the scores in descending order by absolute value.
* `jscomp`: use the Closure JavaScript compiler to compile and minify a JavaScript file
* `jsmin`: use the YUI compressor to minify a JavaScript file
* `kmeans`: calculate the kmeans on a set of data
* `mvn2`: a Ruby script that runs a maven build, including (or not including) tests, and only outputs the lines that come after a compile failure, build success, test result, or reactor summary start line
* `nmeans`: calculate the nmeans on a set of data
* `openf`: open the first file in the folder
* `outliers`: calculate the outliers of a set of data (based on clusters from n-means)
* `prg`: run the Mac purge command
* `rmf`: remove the first file in the folder

---

Here is information on the 2 JAR files:

* `compiler.jar`: the JAR file for the Closure JavaScript compiler
* `yuicompressor-2.4.7.jar` the JAR file for the YUI compressor