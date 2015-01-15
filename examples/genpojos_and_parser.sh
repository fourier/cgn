#! /bin/sh
SAXON_PATH=~/Development/SaxonHE9-6-0-4J
java -cp $SAXON_PATH/saxon9he.jar net.sf.saxon.Transform -s:example.xml -xsl:example_parser.xsl -it:"{https://github.com/fourier/cgn/java}gen-parser-main"
#-o:../../dummy.xml

