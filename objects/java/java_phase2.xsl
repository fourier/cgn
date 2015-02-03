<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">

  <xsl:template match="cgn:objects" mode="jcgn:phase2">
    <xsl:copy>
      <!-- copy all attributes -->
      <xsl:copy-of select="@*"/>
      <!-- builder attribute -->
      <xsl:if test="not(@jcgn:builder)">
        <xsl:attribute name="jcgn:builder" select="$jcgn:default-builder"/>
      </xsl:if>

      <!-- parcelable attribute -->
      <xsl:if test="not(@jcgn:parcelable)">
        <xsl:attribute name="jcgn:parcelable" select="$jcgn:default-parcelable"/>
      </xsl:if>

      <!-- date-type attribute -->
      
      <xsl:if test="not(@jcgn:date-type)">
        <xsl:attribute name="jcgn:date-type" select="$jcgn:default-date-type"/>
      </xsl:if>

      <!-- copy the rest -->
      <xsl:copy-of select="node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="jcgn:phase2">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="jcgn:phase2"/>
    </xsl:copy>
  </xsl:template>

  
</xsl:stylesheet>
