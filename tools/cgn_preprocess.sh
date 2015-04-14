#! /bin/sh
SAXON_PATH=~/Development/SaxonHE9-6-0-4J
CURRENT_PATH=$(dirname $0)
if [ -z $1 ]; then
    echo "Usage: $0 testfile.xml [1..4]"
    exit 1
fi
if [ ! -z $2 ] && [ "$2" -ge "1" ] && [ "$2" -le "4" ]; then
    java -cp $SAXON_PATH/saxon9he.jar net.sf.saxon.Transform -s:$1 -xsl:$CURRENT_PATH/../objects/cgn_prepobjects_main.xsl -im:"{https://github.com/fourier/cgn}preprocess$2" -strip:all \!indent=yes
else 
    java -cp $SAXON_PATH/saxon9he.jar net.sf.saxon.Transform -s:$1 -xsl:$CURRENT_PATH/../objects/cgn_prepobjects_main.xsl -im:"{https://github.com/fourier/cgn}preprocess" -strip:all \!indent=yes
fi
