<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">

  <!--
      1st transformation phase. Verify all known attributes for correct
      values, i.e. boolean values true/false or yes/no and transform
      them to the common format (i.e. lower-case true/false values)
  -->

  <!-- acquire the jcgn namespace, in case if it changes in the future -->
  <xsl:variable name="jcgn:namespace" select="(//namespace::*[name() = 'jcgn'])[1]"/>
         
  <xsl:template match="@* | node()" mode="jcgn:phase1">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="jcgn:phase1"/>
    </xsl:copy>
  </xsl:template>

  <!-- preprocess jcgn:builder attribute -->
  <xsl:template match="@jcgn:builder" mode="jcgn:phase1">
    <xsl:call-template name="cgn:boolean-attribute-preprocess">
      <xsl:with-param name="attribute-name" select="'builder'"/>
      <xsl:with-param name="attribute-namespace" select="$jcgn:namespace"/>
      <xsl:with-param name="default-value" select="$jcgn:default-builder"/>
    </xsl:call-template>
  </xsl:template>

  <!-- preprocess jcgn:parcelable attribute -->
  <xsl:template match="@jcgn:parcelable" mode="jcgn:phase1">
    <xsl:call-template name="cgn:boolean-attribute-preprocess">
      <xsl:with-param name="attribute-name" select="'parcelable'"/>
      <xsl:with-param name="attribute-namespace" select="$jcgn:namespace"/>
      <xsl:with-param name="default-value" select="$jcgn:default-parcelable"/>
    </xsl:call-template>
  </xsl:template>
  
</xsl:stylesheet>
