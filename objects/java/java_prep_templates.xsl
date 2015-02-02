<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">

  <xsl:template name="jcgn:preprocess-date-field">
    <!-- if not specified jcgn:date-type get from parent  -->
    <xsl:if test="(@cgn:type = 'date' or (cgn:is-array(@cgn:type) and cgn:array-type(@cgn:type) = 'date')) and not(@jcgn:date-type)">
          <xsl:attribute name="jcgn:date-type" select="../@jcgn:date-type"/>
    </xsl:if>
  </xsl:template>

  
  <!-- preprocess jcgn:date-type attribute -->
  <!-- accepted values: case-insesitive java, joda -->
  <xsl:template name="jcgn:date-type-attribute-preprocess">
    <xsl:param name="default-value" select="$jcgn:default-date-type"/>
    <xsl:variable name="value" select="."/>
    <xsl:variable name="attribute-name" select="'jcgn:date-type'"/>
    <!-- lower case value for case-insensitive comparison -->
    <xsl:variable name="ivalue" select="lower-case($value)"/>

    <xsl:attribute name="jcgn:date-type">
      <xsl:choose>
        <xsl:when test="$ivalue = 'java' or $ivalue = 'default' or $ivalue = 'java.util.date'">
          <xsl:text>java</xsl:text>
        </xsl:when>
        <xsl:when test="$ivalue = 'joda' or $ivalue = 'org.joda.time.datetime'">
          <xsl:text>joda</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:choose>
              <xsl:when test="name(..) = 'objects'">
                <xsl:value-of select="concat('WARNING: ',
                                      $attribute-name,
                                      ' attribute value in the package ',
                                      ../@cgn:package,
                                      ' must be either default/java/java.util.Date or joda/org.joda.time.DateTime, assuming ',
                                      $default-value)"/>
              </xsl:when>
              <xsl:when test="name(..) = 'object'">
                <xsl:value-of select="concat('WARNING: ',
                                      $attribute-name,
                                      ' attribute value in the object ',
                                      ../@cgn:name,
                                      ' must be either default/java/java.util.Date or joda/org.joda.time.DateTime, assuming ',
                                      $default-value)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('WARNING: ',
                                      $attribute-name,
                                      ' attribute value in the element &quot;',
                                      name(..),
                                      '&quot; must be either default/java/java.util.Date or joda/org.joda.time.DateTime, assuming ',
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
