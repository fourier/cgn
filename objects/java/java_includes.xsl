<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">

  <!-- common includes, with preprocessing and all templates -->
  <xsl:include href="java_variables.xsl"/>
  <xsl:include href="java_functions.xsl"/>
  <xsl:include href="java_prep_templates.xsl"/>
  <xsl:include href="java_phase1.xsl"/>
  <xsl:include href="java_phase2.xsl"/>
  <xsl:include href="java_phase3.xsl"/>
  <xsl:include href="java_phase4.xsl"/>
  <xsl:include href="java_phase5.xsl"/>
  <xsl:include href="java_phase6.xsl"/>
  <xsl:include href="java_phase7.xsl"/>
  <xsl:include href="java_prepobjects.xsl"/>
  <xsl:include href="java_templates.xsl"/>
  <!-- java object generation -->
  <xsl:include href="java_object.xsl"/>
  <xsl:include href="java_genobjects.xsl"/>
  <!-- java json parser/generator -->
  <xsl:include href="../../json/java/java_parser.xsl" />
  <xsl:include href="../../json/java/java_generator.xsl" />
  <xsl:include href="../../json/java/java_genparsers.xsl" />

</xsl:stylesheet>
