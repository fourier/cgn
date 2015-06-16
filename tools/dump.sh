#! /bin/sh
# using default saxon path if SAXON variable not defined
DEFAULT_SAXON_PATH=~/Development/SaxonHE9-6-0-4J/saxon9he.jar
SAXON=${SAXON-$DEFAULT_SAXON}
CURRENT_PATH=$(dirname $0)
java -cp $SAXON net.sf.saxon.Transform -s:$1 -xsl:$CURRENT_PATH/dump.xsl  -strip:all \!indent=yes          

