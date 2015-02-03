<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java"
                xmlns:jtmp="https://github.com/fourier/cgn/java/temp">

  
  <xsl:template match="cgn:field" mode="jcgn:phase6">
    <xsl:variable name="name" select="@cgn:name"/>
    <xsl:copy>
      <!-- copy all the attributes -->
      <xsl:copy-of select="@*" />
      <!-- create a new attributes using the temporary object-fields node -->
      <xsl:attribute name="jcgn:type" select="../jtmp:object-fields/field[@name=$name]/@java-type"/>
      <xsl:attribute name="jcgn:variable-name" select="../jtmp:object-fields/field[@name=$name]/@java-name"/>
      <!-- copy all nodes -->
      <xsl:copy-of select="node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="jcgn:phase6">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="jcgn:phase6"/>
    </xsl:copy>
  </xsl:template>

  
  
   

</xsl:stylesheet>
