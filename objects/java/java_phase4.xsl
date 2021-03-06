<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java"
                xmlns:jtmp="https://github.com/fourier/cgn/java/temp">

  <!-- 4th phase. If the field is of type 'date' or '[date]' and no
       jcgn:date-type set, add the jcgn:date-type from parent
  -->
  <xsl:template match="cgn:field" mode="jcgn:phase4">
    <xsl:copy>
      <!-- copy attributes -->
      <xsl:copy-of select="@*" />
      <!-- if the date field do some preprocessing -->
      <xsl:call-template name="jcgn:preprocess-date-field"/>
      <!-- copy nodes -->
      <xsl:copy-of select="node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="jcgn:phase4">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="jcgn:phase4"/>
    </xsl:copy>
  </xsl:template>

  
  
   

</xsl:stylesheet>
