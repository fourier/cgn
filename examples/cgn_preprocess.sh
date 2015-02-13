#! /bin/sh
SAXON_PATH=~/Development/SaxonHE9-6-0-4J
if [ ! -z $1 ] && [ "$1" -ge "1" ] && [ "$1" -le "4" ]; then
    java -cp $SAXON_PATH/saxon9he.jar net.sf.saxon.Transform -s:example.xml -xsl:../objects/cgn_prepobjects_main.xsl -im:"{https://github.com/fourier/cgn}preprocess$1" -strip:all \!indent=yes
else 
    java -cp $SAXON_PATH/saxon9he.jar net.sf.saxon.Transform -s:example.xml -xsl:../objects/cgn_prepobjects_main.xsl -im:"{https://github.com/fourier/cgn}preprocess" -strip:all \!indent=yes          
fi
