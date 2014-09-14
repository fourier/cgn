#! /bin/sh

java -cp ../saxon/saxon9he.jar net.sf.saxon.Transform -s:example.xml -xsl:example_parser.xsl -it:"{https://github.com/fourier/cgn/java}gen-parser-main"
#-o:../../dummy.xml

