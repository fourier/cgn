<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">

  <xsl:output indent="no" method="text"/>
  <xsl:strip-space elements="*" />

  <xsl:template name="jcgn:genobjects">
    <xsl:message>Generating POJO classes</xsl:message>
    <xsl:apply-templates select="$jcgn:preprocessed-objects//cgn:objects" mode="jcgn:genobjects"/>
  </xsl:template>


  
</xsl:stylesheet>

