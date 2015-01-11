<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">

  <xsl:template name="jcgn:preprocess-date-field">
    <!-- default jcgn:type for date is java.util.Date -->
      <xsl:choose>
        <xsl:when test="@cgn:type = 'date' and not(@jcgn:type)">
          <xsl:attribute name="jcgn:type" select="$jcgn:default-date-type"/>
        </xsl:when>
        <xsl:when test="cgn:is-array(@cgn:type) and (cgn:array-type(@cgn:type) = 'date') and not(@jcgn:type)">
          <xsl:attribute name="jcgn:type" select="$jcgn:default-date-type"/>
        </xsl:when>
      </xsl:choose>
  </xsl:template>
  
  
</xsl:stylesheet>
