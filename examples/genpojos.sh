#! /bin/sh

java -cp ../saxon/saxon9he.jar net.sf.saxon.Transform -s:example.xml -xsl:example_main.xsl -it:"{https://github.com/fourier/cgn/java}genobjects"
#-o:../../dummy.xml

