#! /bin/sh
# using default saxon path if SAXON variable not defined
DEFAULT_SAXON=~/Development/SaxonHE9-6-0-4J/saxon9he.jar
SAXON=${SAXON-$DEFAULT_SAXON}

CURRENT_PATH=$(dirname $0)
if [ -z $1 ] && [ -z $2 ] && [ -z $3 ]; then
    echo "Usage: $0 testfile.xsl template-name testfile.xml"
    exit 1
fi
java -cp $SAXON net.sf.saxon.Transform -s:$3 -xsl:$1 -it:$2 -strip:all \!indent=yes

