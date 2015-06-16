#! /bin/sh
# using default saxon path if SAXON_PATH variable not defined
DEFAULT_SAXON_PATH=~/Development/SaxonHE9-6-0-4J
SAXON_PATH=${SAXON_PATH-$DEFAULT_SAXON_PATH}

CURRENT_PATH=$(dirname $0)
if [ -z $1 ] && [ -z $2 ] && [ -z $3 ]; then
    echo "Usage: $0 testfile.xsl template-name testfile.xml"
    exit 1
fi
java -cp $SAXON_PATH/saxon9he.jar net.sf.saxon.Transform -s:$3 -xsl:$1 -it:$2 -strip:all \!indent=yes

