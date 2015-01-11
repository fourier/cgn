#! /bin/sh

java -cp ../saxon/saxon9he.jar net.sf.saxon.Transform -s:example.xml -xsl:../objects/cgn_prepobjects_main.xsl -im:"{https://github.com/fourier/cgn}preprocess" -strip:all \!indent=yes
#-o:../../dummy.xml

