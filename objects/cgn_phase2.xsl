<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn">

  <xsl:template match="cgn:objects" mode="cgn:phase2">
    <xsl:variable name="copyright"
                  select="if (not(../cgn:copyright))
                          then $cgn:default-copyright
                          else ../cgn:copyright"/>
    <xsl:variable name="author"
                  select="if (not(../cgn:author))
                          then $cgn:default-author
                          else ../cgn:author"/>
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <!-- 1. copyright attribute -->
      <!--
          NOTE: unable to move this to template because XPath qnames
          could not be evaluated in runtime, and saxon:evaluate is not
          available in HE version of Saxon
      -->
      <xsl:if test="not(@cgn:copyright)">
          <xsl:attribute name="cgn:copyright" select="$copyright"/>
      </xsl:if>
          
      <!-- 2. author field -->
      <xsl:if test="not(@cgn:author)">
          <xsl:attribute name="cgn:author" select="$author"/>
      </xsl:if>
        
      <!-- 3. package attribute -->
      <xsl:if test="not(@cgn:package)">
        <xsl:attribute name="cgn:package" select="$cgn:default-package"/>
      </xsl:if>

      <!-- 4. read-only attribute -->
      <xsl:if test="not(@cgn:read-only)">
        <xsl:attribute name="cgn:read-only" select="$cgn:default-read-only"/>
      </xsl:if>

      <!-- 5. json attribute -->
      <xsl:if test="not(@cgn:json)">
        <xsl:attribute name="cgn:json" select="$cgn:default-json"/>
      </xsl:if>

      <!-- 6. isset attribute -->
      <xsl:if test="not(@cgn:is-set)">
        <xsl:attribute name="cgn:is-set" select="$cgn:default-is-set"/>
      </xsl:if>
      
      <!-- copy the rest nodes -->
      <xsl:copy-of select="node()" />
    </xsl:copy>
  </xsl:template>


  <xsl:template match="@*|node()" mode="cgn:phase2">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="cgn:phase2"/>
    </xsl:copy>
  </xsl:template>


</xsl:stylesheet>
