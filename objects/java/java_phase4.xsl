<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">

  <xsl:template match="cgn:field" mode="jcgn:phase4">
    <xsl:copy>
      <xsl:call-template name="jcgn:preprocess-date-field"/>
      <!-- copy the rest -->
      <xsl:copy-of select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="jcgn:phase4">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="jcgn:phase4"/>
    </xsl:copy>
  </xsl:template>

   

</xsl:stylesheet>
