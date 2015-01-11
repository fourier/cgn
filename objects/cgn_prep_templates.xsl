<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn">

  <xsl:template name="cgn:preprocess-undeclared-type-field">
    <xsl:if test="not(@cgn:type)">
      <xsl:attribute name="cgn:type" select="'string'"/>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
