<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java"
                xmlns:jtmp="https://github.com/fourier/cgn/java/temp">

  
  <xsl:template match="jtmp:object-fields" mode="jcgn:phase7"/>

  <xsl:template match="@*|node()" mode="jcgn:phase7">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="jcgn:phase7"/>
    </xsl:copy>
  </xsl:template>

  
  
   

</xsl:stylesheet>
