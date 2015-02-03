<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">

  <xsl:template match="cgn:object" mode="jcgn:phase3">
    <xsl:copy>
      <!-- copy the attributes -->
      <xsl:copy-of select="@*" />

      <!--
          parent attributes (in cgn:objects) already specified by
          the previous (3) phase of transformation
      -->
      <!-- builder attribute: from parent (cgn:objects) or own -->
      <xsl:if test="not(@jcgn:builder)">
        <xsl:attribute name="jcgn:builder" select="../@jcgn:builder"/>
      </xsl:if>

      <!-- parcelable attribute: from parent (cgn:objects) or own -->
      <xsl:if test="not(@jcgn:parcelable)">
        <xsl:attribute name="jcgn:parcelable" select="../@jcgn:parcelable"/>
      </xsl:if>
      
      <!-- date-type attribute: from parent (cgn:objects) or own -->
      <xsl:if test="not(@jcgn:date-type)">
        <xsl:attribute name="jcgn:date-type" select="../@jcgn:date-type"/>
      </xsl:if>
      
      <!-- copy the rest nodes -->
      <xsl:copy-of select="node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="jcgn:phase3">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="jcgn:phase3"/>
    </xsl:copy>
  </xsl:template>
  
  

</xsl:stylesheet>
