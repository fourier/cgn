<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn">

  <xsl:template match="cgn:field" mode="cgn:phase4">
    <xsl:copy>
      <xsl:call-template name="cgn:preprocess-undeclared-type-field"/>
      <!-- copy the rest -->
      <xsl:copy-of select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="cgn:phase4">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="cgn:phase4"/>
    </xsl:copy>
  </xsl:template>

  
  <xsl:template match="cgn:object" mode="cgn:phase4">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" mode="cgn:phase4"/> 
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="cgn:objects" mode="cgn:phase4">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" mode="cgn:phase4"/> 
    </xsl:copy>
  </xsl:template>
  

</xsl:stylesheet>
