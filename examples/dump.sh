#! /bin/sh
SAXON_PATH=~/Development/SaxonHE9-6-0-4J
java -cp $SAXON_PATH/saxon9he.jar net.sf.saxon.Transform -s:example.xml -xsl:dump.xsl  -strip:all \!indent=yes          

