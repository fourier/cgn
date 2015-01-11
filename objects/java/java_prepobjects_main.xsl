<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">

  <xsl:include href="../cgn_phase1.xsl"/>
  <xsl:include href="../cgn_phase2.xsl"/>
  <xsl:include href="../cgn_phase3.xsl"/>
  <xsl:include href="../cgn_prepobjects.xsl"/>
  <xsl:include href="../cgn_variables.xsl"/>
  <xsl:include href="../cgn_lib.xsl"/>
  <xsl:include href="../cgn_prep_templates.xsl"/>
  <xsl:include href="java_variables.xsl"/>
  <xsl:include href="java_prep_templates.xsl"/>
  <xsl:include href="java_phase1.xsl"/>
  <xsl:include href="java_phase2.xsl"/>
  <xsl:include href="java_phase3.xsl"/>
  <xsl:include href="java_prepobjects.xsl"/>

  <xsl:template match="/" mode="jcgn:preprocess">
    <xsl:copy-of select="$jcgn:preprocessed-objects"/>
  </xsl:template>

  
</xsl:stylesheet>
