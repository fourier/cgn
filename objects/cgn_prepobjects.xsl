<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn">

  <xsl:variable name="cgn:preprocessed-objects1">
    <!-- 1st phase: process known values, like boolean -->
    <xsl:apply-templates select="/" mode="cgn:phase1" />
  </xsl:variable>
  
  <xsl:variable name="cgn:preprocessed-objects2">
    <!-- 2nd phase: adding default values to cgn:objects -->
    <xsl:apply-templates select="$cgn:preprocessed-objects1" mode="cgn:phase2" />
  </xsl:variable>

  <xsl:variable name="cgn:preprocessed-objects3">
    <!-- 3rd phase: merge values from cgn:objects to cgn:object -->
    <xsl:apply-templates select="$cgn:preprocessed-objects2" mode="cgn:phase3" />
  </xsl:variable>
  
  <xsl:variable name="cgn:preprocessed-objects4">
    <!-- 4th phase: applying the default values for field types -->
    <xsl:apply-templates select="$cgn:preprocessed-objects3" mode="cgn:phase4" />
  </xsl:variable>
  
  <xsl:variable name="cgn:preprocessed-objects">
    <!-- 5th phase: process construct FQDN names for object field types -->
    <xsl:apply-templates select="$cgn:preprocessed-objects4" mode="cgn:phase5" />
  </xsl:variable>

</xsl:stylesheet>

