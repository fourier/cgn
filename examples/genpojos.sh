#! /bin/sh
# using default saxon path if SAXON variable not defined
DEFAULT_SAXON=~/Development/SaxonHE9-6-0-4J/saxon9he.jar
SAXON=${SAXON-$DEFAULT_SAXON}

if [ "$1" == "-d" ]
then
  java -cp $SAXON net.sf.saxon.Transform -T -s:example.xml -xsl:example_main.xsl -it:"{https://github.com/fourier/cgn/java}genobjects"
else
  java -cp $SAXON net.sf.saxon.Transform -s:example.xml -xsl:example_main.xsl -it:"{https://github.com/fourier/cgn/java}genobjects"
fi
#-o:../../dummy.xml

