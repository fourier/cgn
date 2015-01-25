<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">

  <xsl:include href="cgn_phase1.xsl"/>
  <xsl:include href="cgn_phase2.xsl"/>
  <xsl:include href="cgn_phase3.xsl"/>
  <xsl:include href="cgn_phase4.xsl"/>
  <xsl:include href="cgn_phase5.xsl"/>
  <xsl:include href="cgn_prepobjects.xsl"/>
  <xsl:include href="cgn_variables.xsl"/>
  <xsl:include href="cgn_prep_templates.xsl"/>
  
  <xsl:template match="/" mode="cgn:preprocess">
    <xsl:message>Preprocess variable: cgn:preprocessed-objects</xsl:message>
    <!-- template for command line output -->
    <xsl:sequence select="$cgn:preprocessed-objects"/>
  </xsl:template>

  <xsl:template match="/" mode="cgn:preprocess1">
    <xsl:message>Preprocess variable: cgn:preprocessed-objects1</xsl:message>
    <!-- template for command line output -->
    <xsl:sequence select="$cgn:preprocessed-objects1"/>
  </xsl:template>

  <xsl:template match="/" mode="cgn:preprocess2">
    <xsl:message>Preprocess variable: cgn:preprocessed-objects2</xsl:message>
    <!-- template for command line output -->
    <xsl:sequence select="$cgn:preprocessed-objects2"/>
  </xsl:template>

  <xsl:template match="/" mode="cgn:preprocess3">
    <xsl:message>Preprocess variable: cgn:preprocessed-objects3</xsl:message>
    <!-- template for command line output -->
    <xsl:sequence select="$cgn:preprocessed-objects3"/>
  </xsl:template>

  <xsl:template match="/" mode="cgn:preprocess4">
    <xsl:message>Preprocess variable: cgn:preprocessed-objects4</xsl:message>
    <!-- template for command line output -->
    <xsl:sequence select="$cgn:preprocessed-objects4"/>
  </xsl:template>
  
  
</xsl:stylesheet>
