#! /bin/sh
SAXON_PATH=~/Development/SaxonHE9-6-0-4J
CURRENT_PATH=$(dirname $0)
java -cp $SAXON_PATH/saxon9he.jar net.sf.saxon.Transform -s:$1 -xsl:$CURRENT_PATH/dump.xsl  -strip:all \!indent=yes          

