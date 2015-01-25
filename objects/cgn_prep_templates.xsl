<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn">

  <xsl:template name="cgn:preprocess-undeclared-type-field">
    <xsl:if test="not(@cgn:type)">
      <xsl:attribute name="cgn:type" select="'string'"/>
    </xsl:if>
  </xsl:template>

  <!-- preprocess boolean attribute -->
  <!-- accepted values: case-insesitive true, false, yes, no -->
  <xsl:template name="cgn:boolean-attribute-preprocess">

    <xsl:param name="attribute-name"/>
    <xsl:param name="default-value"/>
    <xsl:variable name="value" select="."/>
    <!-- lower case value for case-insensitive comparison -->
    <xsl:variable name="ivalue" select="lower-case($value)"/>
    <xsl:attribute name="{$attribute-name}">
      <xsl:choose>
        <xsl:when test="$ivalue = 'true' or $ivalue = 'yes'">
          <xsl:text>true</xsl:text>
        </xsl:when>
        <xsl:when test="$ivalue = 'false' or $ivalue = 'no'">
          <xsl:text>false</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:choose>
              <xsl:when test="name(..) = 'objects'">
                <xsl:value-of select="concat('WARNING: ',
                                      $attribute-name,
                                      ' attribute value in the package ',
                                      ../@cgn:package,
                                      ' must be either false/no or true/yes, assuming ',
                                      $default-value)"/>
              </xsl:when>
              <xsl:when test="name(..) = 'object'">
                <xsl:value-of select="concat('WARNING: ',
                                      $attribute-name,
                                      ' attribute value in the object ',
                                      ../@cgn:name,
                                      ' must be either false/no or true/yes, assuming ',
                                      $default-value)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('WARNING: ',
                                      $attribute-name,
                                      ' attribute value in the element &quot;',
                                      name(..),
                                      '&quot; must be either false/no or true/yes, assuming ',
                                      $default-value)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:message>
          <xsl:value-of select="$default-value"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>




</xsl:stylesheet>
