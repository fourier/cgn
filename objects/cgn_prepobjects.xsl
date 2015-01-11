<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn">


  <xsl:variable name="cgn:preprocessed-objects1">
    <!-- 1st phase: adding default values to cgn:objects -->
    <xsl:apply-templates select="//cgn:objects" mode="cgn:phase1" />
  </xsl:variable>

  <xsl:variable name="cgn:preprocessed-objects2">
    <!-- 2nd phase: merge values from cgn:objects to cgn:object -->
    <xsl:apply-templates select="$cgn:preprocessed-objects1" mode="cgn:phase2" />
  </xsl:variable>

  <xsl:variable name="cgn:preprocessed-objects">
    <!-- 3rd phase: applying the default values for field types -->
    <xsl:apply-templates select="$cgn:preprocessed-objects2" mode="cgn:phase3" />
  </xsl:variable>

  <xsl:template match="/" mode="cgn:preprocess">
    <!-- template for command line output -->
    <xsl:sequence select="$cgn:preprocessed-objects"/>
  </xsl:template>

  
</xsl:stylesheet>

