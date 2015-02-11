<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:this="https://github.com/fourier/cgn/generator/java/this.xsl"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">

  <xsl:template match="/" mode="jcgn:gengenerator">
    <!-- json generator template -->
    <xsl:param name="class-name"/>
    <xsl:param name="package"/>
    <!-- creating generator -->
    <xsl:message>Generating JSON generator</xsl:message>
    <xsl:call-template name="jcgn:generate-json-generator">
      <xsl:with-param name="package" select="$package"/>
      <xsl:with-param name="class-name" select="$class-name"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="/" mode="jcgn:genparser">
    <!-- json parser template -->
    <xsl:param name="class-name"/>
    <xsl:param name="package"/>
    <!-- creating parser -->
    <xsl:message>Generating JSON parser</xsl:message>
    <xsl:call-template name="jcgn:generate-json-parser">
      <xsl:with-param name="package" select="$package"/>
      <xsl:with-param name="class-name" select="$class-name"/>
    </xsl:call-template>
  </xsl:template>

  
</xsl:stylesheet>
