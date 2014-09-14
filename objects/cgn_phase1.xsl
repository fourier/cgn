<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn">

  <xsl:template match="cgn:objects" mode="cgn:phase1">
    <xsl:copy>
      <!-- 1. package attribute -->
      <!--
          NOTE: unable to move this to template because XPath qnames
          could not be evaluated in runtime, and saxon:evaluate is not
          available in HE version of Saxon
      -->
      <xsl:choose>
        <xsl:when test="not(@cgn:package)">
          <xsl:attribute name="cgn:package" select="$cgn:default-package"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="@cgn:package"/>
        </xsl:otherwise>
      </xsl:choose>

      <!-- 2. read-only attribute -->
      <xsl:choose>
        <xsl:when test="not(@cgn:read-only)">
          <xsl:attribute name="cgn:read-only" select="$cgn:default-read-only"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="@cgn:read-only"/>
        </xsl:otherwise>
      </xsl:choose>


      <!-- 3. json attribute -->
      <xsl:choose>
        <xsl:when test="not(@cgn:json)">
          <xsl:attribute name="cgn:json" select="$cgn:default-json"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="@cgn:json"/>
        </xsl:otherwise>
      </xsl:choose>

      
      <!-- copy the rest -->
      <xsl:copy-of select="@*|node()" />
    </xsl:copy>
  </xsl:template>


  <xsl:template match="@*|node()" mode="cgn:phase1">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>


</xsl:stylesheet>