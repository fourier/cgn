#! /bin/sh
# using default saxon path if SAXON_PATH variable not defined
DEFAULT_SAXON_PATH=~/Development/SaxonHE9-6-0-4J
SAXON_PATH=${SAXON_PATH-$DEFAULT_SAXON_PATH}
CURRENT_PATH=$(dirname $0)
java -cp $SAXON_PATH/saxon9he.jar net.sf.saxon.Transform -s:$1 -xsl:$CURRENT_PATH/dump.xsl  -strip:all \!indent=yes          

