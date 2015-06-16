#! /bin/sh
# using default saxon path if SAXON_PATH variable not defined
DEFAULT_SAXON_PATH=~/Development/SaxonHE9-6-0-4J
SAXON_PATH=${SAXON_PATH-$DEFAULT_SAXON_PATH}

if [ -z $1 ]; then
    echo "Usage: $0 testfile.xml [1..6]"
    exit 1
fi

if [ ! -z $2 ] && [ "$2" -ge "1" ] && [ "$2" -le "6" ]; then
    java -cp $SAXON_PATH/saxon9he.jar net.sf.saxon.Transform -s:$1 -xsl:../objects/java/java_prepobjects_main.xsl -im:"{https://github.com/fourier/cgn/java}preprocess$2" -strip:all \!indent=yes
else 
    java -cp $SAXON_PATH/saxon9he.jar net.sf.saxon.Transform -s:$1 -xsl:../objects/java/java_prepobjects_main.xsl -im:"{https://github.com/fourier/cgn/java}preprocess" -strip:all \!indent=yes 
fi




