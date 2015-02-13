<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn">

  <xsl:template match="cgn:object" mode="cgn:phase3">
    <!-- cgn:name MUST always present! -->
    <xsl:if test="not(@cgn:name)">
      <xsl:message terminate="yes">
        <xsl:value-of select="concat('Object without cgn:name attribute found in package ', ../@cgn:package)"/>
      </xsl:message>
    </xsl:if>

    <xsl:copy>
      <!-- copy attributes -->
      <xsl:copy-of select="@*" />

      <!--
          parent attributes (in cgn:objects) already specified by
          the first phase of transformation
      -->
      <!-- 1. copyright attribute: from parent (cgn:objects) or own -->
      <xsl:if test="not(@cgn:copyright)">
          <xsl:attribute name="cgn:copyright" select="../@cgn:copyright"/>
      </xsl:if>

      <!-- 2. author attribute: from parent (cgn:objects) or own -->
      <xsl:if test="not(@cgn:author)">
        <xsl:attribute name="cgn:author" select="../@cgn:author"/>
      </xsl:if>

      <!-- 3. package attribute: from parent (cgn:objects) or own -->
      <xsl:if test="not(@cgn:package)">
        <xsl:attribute name="cgn:package" select="../@cgn:package"/>
      </xsl:if>

      <!-- 4. read-only attribute: from parent (cgn:objects) or own -->
      <xsl:if test="not(@cgn:read-only)">
        <xsl:attribute name="cgn:read-only" select="../@cgn:read-only"/>
      </xsl:if>

      <!-- 5. json attribute: from parent (cgn:objects) or own -->
      <xsl:if test="not(@cgn:json)">
        <xsl:attribute name="cgn:json" select="../@cgn:json"/>
      </xsl:if>

      <!-- 6. is-set attribute: from parent (cgn:objects) or own -->
      <xsl:if test="not(@cgn:is-set)">
        <xsl:attribute name="cgn:is-set" select="../@cgn:is-set"/>
      </xsl:if>
      
      <!-- copy the rest nodes -->
      <xsl:copy-of select="node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="cgn:phase3">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="cgn:phase3"/>
    </xsl:copy>
  </xsl:template>
    

</xsl:stylesheet>
