<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">

  <xsl:variable name="cgn:xml-name" select="base-uri()" as="xs:string"/>

  <xsl:variable name="cgn:copyright-var">
    <xsl:apply-templates mode="cgn:create-copyright-sequence"/>
  </xsl:variable>

  

  <xsl:include href="java_prepobjects.xsl"/>

  <xsl:include href="java_object.xsl"/>
  <xsl:include href="java_functions.xsl"/>
  <xsl:include href="java_templates.xsl"/>
  
  <xsl:output indent="no" method="text"/>
  <xsl:strip-space elements="*" />

  <xsl:template name="jcgn:genobjects">
    <xsl:message>Generating POJO classes</xsl:message>
    <xsl:apply-templates select="$jcgn:preprocessed-objects" mode="java"/>
  </xsl:template>


  
</xsl:stylesheet>

