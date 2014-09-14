<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">

  <xsl:template match="cgn:objects" mode="jcgn:phase1">
    <xsl:copy>
      <!-- builder attribute -->
      <xsl:choose>
        <xsl:when test="not(@jcgn:builder)">
          <xsl:attribute name="jcgn:builder" select="$jcgn:default-builder"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="@jcgn:builder"/>
        </xsl:otherwise>
      </xsl:choose>

      <!-- parcelable attribute -->
      <xsl:choose>
        <xsl:when test="not(@jcgn:parcelable)">
          <xsl:attribute name="jcgn:parcelable" select="$jcgn:default-parcelable"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="@jcgn:parcelable"/>
        </xsl:otherwise>
      </xsl:choose>      

      <!-- copy the rest -->
      <xsl:copy-of select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="jcgn:phase1">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  
</xsl:stylesheet>
