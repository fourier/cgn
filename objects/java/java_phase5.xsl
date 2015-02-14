<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java"
                xmlns:jtmp="https://github.com/fourier/cgn/java/temp">


  <xsl:template match="cgn:object" mode="jcgn:phase5">
    <xsl:copy>
      <!-- copy all attributes and fields -->
      <xsl:copy-of select="@* | node()"/>

      <!-- create a temporary child jtmp:object-fields -->
      <xsl:element name="jtmp:object-fields">
        <xsl:call-template name="jcgn:object-fields"/>
      </xsl:element>

    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="jcgn:phase5">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="jcgn:phase5"/>
    </xsl:copy>
  </xsl:template>

  
  
   

</xsl:stylesheet>
