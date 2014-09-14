<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">

  <xsl:include href="../cgn_prepobjects.xsl"/>
  <xsl:include href="java_variables.xsl"/>
  <xsl:include href="java_phase1.xsl"/>
  <xsl:include href="java_phase2.xsl"/>

  <xsl:variable name="jcgn:preprocessed-objects1">
    <!-- 1st phase: adding default values defined in jcgn to cgn:objects -->
    <xsl:apply-templates select="$cgn:preprocessed-objects" mode="jcgn:phase1" />
  </xsl:variable>

  <xsl:variable name="jcgn:preprocessed-objects">
    <!-- 2nd phase: adding values from cgn:objects to cgn:object, if not exist already -->
    <xsl:apply-templates select="$jcgn:preprocessed-objects1" mode="jcgn:phase2" />
  </xsl:variable>

  
  <xsl:template match="/" mode="jcgn:preprocess">
    <xsl:copy-of select="$jcgn:preprocessed-objects"/>
  </xsl:template>
  
</xsl:stylesheet>

