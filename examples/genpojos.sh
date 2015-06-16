#! /bin/sh
# using default saxon path if SAXON_PATH variable not defined
DEFAULT_SAXON_PATH=~/Development/SaxonHE9-6-0-4J
SAXON_PATH=${SAXON_PATH-$DEFAULT_SAXON_PATH}

if [ "$1" == "-d" ]
then
  java -cp $SAXON_PATH/saxon9he.jar net.sf.saxon.Transform -T -s:example.xml -xsl:example_main.xsl -it:"{https://github.com/fourier/cgn/java}genobjects"
else
  java -cp $SAXON_PATH/saxon9he.jar net.sf.saxon.Transform -s:example.xml -xsl:example_main.xsl -it:"{https://github.com/fourier/cgn/java}genobjects"
fi
#-o:../../dummy.xml

