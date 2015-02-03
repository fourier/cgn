<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">

  <xsl:include href="../cgn_phase1.xsl"/>
  <xsl:include href="../cgn_phase2.xsl"/>
  <xsl:include href="../cgn_phase3.xsl"/>
  <xsl:include href="../cgn_phase4.xsl"/>
  <xsl:include href="../cgn_phase5.xsl"/>
  <xsl:include href="../cgn_prepobjects.xsl"/>
  <xsl:include href="../cgn_variables.xsl"/>
  <xsl:include href="../cgn_lib.xsl"/>
  <xsl:include href="../cgn_prep_templates.xsl"/>
  <xsl:include href="java_variables.xsl"/>
  <xsl:include href="java_functions.xsl"/>
  <xsl:include href="java_prep_templates.xsl"/>
  <xsl:include href="java_phase1.xsl"/>
  <xsl:include href="java_phase2.xsl"/>
  <xsl:include href="java_phase3.xsl"/>
  <xsl:include href="java_phase4.xsl"/>
  <xsl:include href="java_phase5.xsl"/>
  <xsl:include href="java_phase6.xsl"/>
  <xsl:include href="java_prepobjects.xsl"/>

  <xsl:template match="/" mode="jcgn:preprocess">
    <xsl:message>Preprocess variable: jcgn:preprocessed-objects</xsl:message>
    <xsl:copy-of select="$jcgn:preprocessed-objects"/>
  </xsl:template>

  <xsl:template match="/" mode="jcgn:preprocess1">
    <xsl:message>Preprocess variable: jcgn:preprocessed-objects1</xsl:message>
    <!-- template for command line output -->
    <xsl:sequence select="$jcgn:preprocessed-objects1"/>
  </xsl:template>

  <xsl:template match="/" mode="jcgn:preprocess2">
    <xsl:message>Preprocess variable: jcgn:preprocessed-objects2</xsl:message>
    <!-- template for command line output -->
    <xsl:sequence select="$jcgn:preprocessed-objects2"/>
  </xsl:template>

  <xsl:template match="/" mode="jcgn:preprocess3">
    <xsl:message>Preprocess variable: jcgn:preprocessed-objects3</xsl:message>
    <!-- template for command line output -->
    <xsl:sequence select="$jcgn:preprocessed-objects3"/>
  </xsl:template>

  <xsl:template match="/" mode="jcgn:preprocess4">
    <xsl:message>Preprocess variable: jcgn:preprocessed-objects4</xsl:message>
    <!-- template for command line output -->
    <xsl:sequence select="$jcgn:preprocessed-objects4"/>
  </xsl:template>

  
</xsl:stylesheet>
