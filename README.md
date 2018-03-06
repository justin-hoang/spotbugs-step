Wercker SpotBugs Step

A Wercker step to run SpotBugs on a Java project.

This step will download and install SpotBugs, curl, tar, gzip and then execute the goals you have requested. You must provide the output format, output file including path and the classpath.

The box that you run this step in must either have curl, tar, gzip, installed in it. 

The box that you run this step must have a JDK (1.8 or later) installed in it (as SpotBugs requires a JDK).
Usage

To use this step, include it in your wercker.yml pipeline, for example:

```
regular-test:
  steps:
    - justin-hoang/spotbugs-step:
      format: -xml
      output: ./result.log
      classpath: target/classes
```


After the SpotBugs step has completed, you will see the result in your output file specified.

Parameters:
All parameters are required unless otherwise specified.

Format parameters:
-xml:  Produce the bug reports as XML. The XML data produced may be viewed in the GUI at a later time. You may also specify this option as -xml:withMessages; when this variant of the option is used, the XML output will contain human-readable messages describing the warnings contained in the file. XML files generated this way are easy to transform into reports.

-html:  Generate HTML output. By default, SpotBugs will use the default.xsl XSLT stylesheet to generate the HTML: you can find this file in spotbugs.jar, or in the SpotBugs source or binary distributions. Variants of this option include -html:plain.xsl, -html:fancy.xsl and -html:fancy-hist.xsl. The plain.xsl stylesheet does not use Javascript or DOM, and may work better with older web browsers, or for printing. The fancy.xsl stylesheet uses DOM and Javascript for navigation and CSS for visual presentation. The fancy-hist.xsl an evolution of fancy.xsl stylesheet. It makes an extensive use of DOM and Javascript for dynamically filtering the lists of bugs.
  If you want to specify your own XSLT stylesheet to perform the transformation to HTML, specify the option as -html:myStylesheet.xsl, where myStylesheet.xsl is the filename of the stylesheet you want to use.

-emacs:  Produce the bug reports in Emacs format.

-xdocs:  Produce the bug reports in xdoc XML format for use with Apache Maven.

output parameter:
Produce the output in the specified file.

Classpath parameter:
jar/zip/class files, directories...

Sample Application:
A sample application is provided at https://github.com/justin-hoang/sample-spotbugs-step that shows how to use this SpotBugs step.
