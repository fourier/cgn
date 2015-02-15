<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java"
                xmlns:this="https://github.com/fourier/cgn/parser/example/java/this">
  <xsl:output indent="no" method="text"/>
  <xsl:strip-space elements="*" />

  <xsl:include href="../objects/cgn_includes.xsl"/>
  <xsl:include href="../objects/java/java_includes.xsl"/>

  <xsl:variable name="this:parser-class">ObjectsParser</xsl:variable>
  <xsl:variable name="this:parser-package">com.mycompany.example.parser</xsl:variable>
  <xsl:variable name="this:generator-class">ObjectsGenerator</xsl:variable>
  <xsl:variable name="this:generator-package">com.mycompany.example.generator</xsl:variable>

  <xsl:template name="jcgn:gen-parser-main">
    <xsl:call-template name="jcgn:genobjects"/>
    <!-- generate json parser -->
    <xsl:apply-templates select="$jcgn:preprocessed-objects" mode="jcgn:genparser">
      <xsl:with-param name="class-name" select="$this:parser-class"/>
    <xsl:with-param name="package" select="$this:parser-package"/>
  </xsl:apply-templates>
    <!-- generate json generator -->
    <xsl:apply-templates select="$jcgn:preprocessed-objects" mode="jcgn:gengenerator">
      <xsl:with-param name="class-name" select="$this:generator-class"/>
      <xsl:with-param name="package" select="$this:generator-package"/>
    </xsl:apply-templates>

  </xsl:template>
  
  
</xsl:stylesheet>

