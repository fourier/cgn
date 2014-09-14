<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn">



  <xsl:template name="cgn:test-read-only-value">
    <!-- determine correctness of the read-only value -->
    <xsl:if test="./@cgn:read-only and not(./@cgn:read-only = 'true') and not(./@cgn:read-only = 'false')">
      <xsl:message terminate="yes">
        <xsl:text>cgn:read-only attribute can have either 'false' or 'true' values, or absent(false by default)</xsl:text>
      </xsl:message>
    </xsl:if>
  </xsl:template>


  <xsl:template match="cgn:copyright" mode="cgn:create-copyright-sequence">
    <xsl:value-of select="." />
    <!---xsl:value-of select="tokenize($copyright-val, '\n\r?')"/-->
  </xsl:template>
  
</xsl:stylesheet>
