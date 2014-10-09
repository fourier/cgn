<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn">

  <xsl:template match="cgn:object" mode="cgn:phase2">
    <xsl:copy>
      <!--
          parent attributes (in cgn:objects) already specified by
          the first phase of transformation
      -->
      <!-- 1. package attribute: from parent (cgn:objects) or own -->
      <xsl:choose>
        <xsl:when test="not(@cgn:package)">
          <xsl:attribute name="cgn:package" select="../@cgn:package"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="@cgn:package"/>
        </xsl:otherwise>
      </xsl:choose>

      <!-- 2. read-only attribute: from parent (cgn:objects) or own -->
      <xsl:choose>
        <xsl:when test="not(@cgn:read-only)">
          <xsl:attribute name="cgn:read-only" select="../@cgn:read-only"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="@cgn:read-only"/>
        </xsl:otherwise>
      </xsl:choose>

      <!-- 3. json attribute: from parent (cgn:objects) or own -->
      <xsl:choose>
        <xsl:when test="not(@cgn:json)">
          <xsl:attribute name="cgn:json" select="../@cgn:json"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="@cgn:json"/>
        </xsl:otherwise>
      </xsl:choose>

      <!-- 4. is-set attribute: from parent (cgn:objects) or own -->
      <xsl:choose>
        <xsl:when test="not(@cgn:is-set)">
          <xsl:attribute name="cgn:is-set" select="../@cgn:is-set"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="@cgn:is-set"/>
        </xsl:otherwise>
      </xsl:choose>

      
      <!-- copy the rest -->
      <xsl:copy-of select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="cgn:phase2">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="cgn:objects" mode="cgn:phase2">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" mode="cgn:phase2"/> 
    </xsl:copy>
  </xsl:template>
  

</xsl:stylesheet>
