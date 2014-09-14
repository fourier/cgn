#! /bin/sh

java -cp ../saxon/saxon9he.jar net.sf.saxon.Transform -s:example.xml -xsl:../objects/java/java_prepobjects.xsl -im:"{https://github.com/fourier/cgn/java}preprocess" -strip:all \!indent=yes
#java -cp ../../../saxon/saxon9he.jar net.sf.saxon.Transform -s:example.xml -xsl:../../cgn_prepobjects.xsl -im:"{https://github.com/fourier/cgn}preprocess" -strip:all \!indent=yes
#-o:../../dummy.xml

