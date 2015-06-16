#! /bin/sh
# using default saxon path if SAXON variable not defined
DEFAULT_SAXON=~/Development/SaxonHE9-6-0-4J/saxon9he.jar
SAXON=${SAXON-$DEFAULT_SAXON}

java -cp $SAXON net.sf.saxon.Transform -s:$1 -xsl:java_objects_parser.xsl -it:"{https://github.com/fourier/cgn/java}gen-parser-main"
#-o:../../dummy.xml

