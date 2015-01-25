<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn">

  <xsl:template match="cgn:field" mode="cgn:phase5">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="cgn:phase5"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="cgn:phase5">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="cgn:phase5"/>
    </xsl:copy>
  </xsl:template>

  
  <xsl:template match="cgn:object" mode="cgn:phase5">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" mode="cgn:phase5"/> 
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="cgn:objects" mode="cgn:phase5">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" mode="cgn:phase5"/> 
    </xsl:copy>
  </xsl:template>
  

</xsl:stylesheet>
