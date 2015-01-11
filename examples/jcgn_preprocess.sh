#! /bin/sh

java -cp ../saxon/saxon9he.jar net.sf.saxon.Transform -s:example.xml -xsl:../objects/java/java_prepobjects_main.xsl -im:"{https://github.com/fourier/cgn/java}preprocess" -strip:all \!indent=yes

