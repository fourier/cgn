<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn">

  <xsl:template match="/">
    <xsl:apply-templates select="/" mode="dump"/>
  </xsl:template>
  <!-- just copy everything -->
  <xsl:template match="@* | node()" mode="dump"> 
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="dump"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
