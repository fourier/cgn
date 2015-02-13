<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn">

  <xsl:template match="cgn:field" mode="cgn:phase4">
    <!-- cgn:name MUST always present! -->
    <xsl:if test="not(@cgn:name)">
      <xsl:message terminate="yes">
        <xsl:value-of select="concat('Field without cgn:name attribute found in object ', cgn:create-fqdn-full-type(../@cgn:package,../@cgn:name))"/>
      </xsl:message>
    </xsl:if>

    <xsl:copy>
      <!-- copy all attributes -->
      <xsl:copy-of select="@*"/>
      <xsl:call-template name="cgn:preprocess-undeclared-type-field"/>
      <!-- copy all nodes -->
      <xsl:copy-of select="node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="cgn:phase4">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="cgn:phase4"/>
    </xsl:copy>
  </xsl:template>  

</xsl:stylesheet>
