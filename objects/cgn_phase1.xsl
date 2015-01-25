<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn">

  <!--
      1st transformation phase. Verify all known attributes for correct
      values, i.e. boolean values true/false or yes/no and transform
      them to the common format (i.e. lower-case true/false values)
  -->
         
  <xsl:template match="@* | node()" mode="cgn:phase1">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="cgn:phase1"/>
    </xsl:copy>
  </xsl:template>

  <!-- preprocess cgn:read-only attribute -->
  <xsl:template match="@cgn:read-only" mode="cgn:phase1">
    <xsl:call-template name="cgn:boolean-attribute-preprocess">
      <xsl:with-param name="attribute-name" select="'cgn:read-only'"/>
      <xsl:with-param name="default-value" select="$cgn:default-read-only"/>
    </xsl:call-template>
  </xsl:template>

  <!-- preprocess cgn:json attribute -->
  <xsl:template match="@cgn:json" mode="cgn:phase1">
    <xsl:call-template name="cgn:boolean-attribute-preprocess">
      <xsl:with-param name="attribute-name" select="'cgn:json'"/>
      <xsl:with-param name="default-value" select="$cgn:default-json"/>
    </xsl:call-template>
  </xsl:template>

  <!-- preprocess cgn:is-set attribute -->
  <xsl:template match="@cgn:is-set" mode="cgn:phase1">
    <xsl:call-template name="cgn:boolean-attribute-preprocess">
      <xsl:with-param name="attribute-name" select="'cgn:is-set'"/>
      <xsl:with-param name="default-value" select="$cgn:default-is-set"/>
    </xsl:call-template>
  </xsl:template>
  
</xsl:stylesheet>
