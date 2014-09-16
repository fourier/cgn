<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">

  <xsl:template match="cgn:object" mode="jcgn:phase2">
    <xsl:copy>
      <!--
          parent attributes (in cgn:objects) already specified by
          the previous (3) phase of transformation
      -->
      <!-- builder attribute: from parent (cgn:objects) or own -->
      <xsl:choose>
        <xsl:when test="not(@jcgn:builder)">
          <xsl:attribute name="jcgn:builder" select="../@jcgn:builder"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="@jcgn:builder"/>
        </xsl:otherwise>
      </xsl:choose>

      <!-- parcelable attribute: from parent (cgn:objects) or own -->
      <xsl:choose>
        <xsl:when test="not(@jcgn:parcelable)">
          <xsl:attribute name="jcgn:parcelable" select="../@jcgn:parcelable"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="@jcgn:parcelable"/>
        </xsl:otherwise>
      </xsl:choose>

      <!-- date-type attribute: from parent (cgn:objects) or own -->
      <xsl:choose>
        <xsl:when test="not(@jcgn:date-type)">
          <xsl:attribute name="jcgn:date-type" select="../@jcgn:date-type"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="@jcgn:date-type"/>
        </xsl:otherwise>
      </xsl:choose>

      
      <!-- copy the rest -->
      <xsl:copy-of select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="jcgn:phase2">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="cgn:phase4"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="cgn:objects" mode="jcgn:phase2">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" mode="jcgn:phase2"/> 
    </xsl:copy>
  </xsl:template>
  

</xsl:stylesheet>
