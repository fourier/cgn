<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java"
                xmlns:this="https://github.com/fourier/cgn/parser/example/java/this">

  <xsl:include href="../objects/cgn_phase1.xsl"/>
  <xsl:include href="../objects/cgn_phase2.xsl"/>
  <xsl:include href="../objects/cgn_phase3.xsl"/>
  <xsl:include href="../objects/cgn_phase4.xsl"/>
  <xsl:include href="../objects/cgn_phase5.xsl"/>
  <xsl:include href="../objects/cgn_prepobjects.xsl"/>
  <xsl:include href="../objects/cgn_variables.xsl"/>
  <xsl:include href="../objects/cgn_lib.xsl"/>
  <xsl:include href="../objects/cgn_templates.xsl"/>
  <xsl:include href="../objects/cgn_prep_templates.xsl"/>
  <xsl:include href="../objects/java/java_prep_templates.xsl"/>
  <xsl:include href="../objects/java/java_prepobjects.xsl"/>
  <xsl:include href="../objects/java/java_genobjects.xsl"/>
  <xsl:include href="../objects/java/java_object.xsl"/>
  <xsl:include href="../objects/java/java_functions.xsl"/>
  <xsl:include href="../objects/java/java_templates.xsl"/>
  <xsl:include href="../objects/java/java_variables.xsl"/>
  <xsl:include href="../objects/java/java_phase1.xsl" />
  <xsl:include href="../objects/java/java_phase2.xsl" />
  <xsl:include href="../objects/java/java_phase3.xsl" />
  <xsl:include href="../objects/java/java_phase4.xsl" />

  <xsl:include href="../json/java/java_parser.xsl" />
  <xsl:include href="../json/java/java_generator.xsl" />



  <xsl:variable name="this:parser-class">ObjectsParser</xsl:variable>
  <xsl:variable name="this:parser-package">com.mycompany.example.parser</xsl:variable>
  <xsl:variable name="this:generator-class">ObjectsGenerator</xsl:variable>
  <xsl:variable name="this:generator-package">com.mycompany.example.generator</xsl:variable>

  
  <xsl:template match="/" mode="this:genparser">
    <xsl:param name="parser-class"/>
    <xsl:param name="parser-package"/>
    <xsl:param name="copyright"/>
    <!-- creating parser -->
    <xsl:message>Generating JSON parser</xsl:message>
    <xsl:call-template name="cgn:generate-json-parser">
      <xsl:with-param name="parser-package" select="$parser-package"/>
      <xsl:with-param name="parser-class" select="$parser-class"/>
      <xsl:with-param name="copyright" select="$copyright"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="/" mode="this:gengenerator">
    <xsl:param name="gen-class"/>
    <xsl:param name="gen-package"/>
    <xsl:param name="copyright"/>
    <!-- creating parser -->
    <xsl:message>Generating JSON generator</xsl:message>
    <xsl:call-template name="cgn:generate-json-generator">
      <xsl:with-param name="gen-package" select="$gen-package"/>
      <xsl:with-param name="gen-class" select="$gen-class"/>
      <xsl:with-param name="copyright" select="$copyright"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="jcgn:gen-parser-main">
    <xsl:variable name="objects" select="$jcgn:preprocessed-objects//cgn:objects"/>
    <xsl:message><xsl:value-of select="concat('size: ', count($objects))"/></xsl:message>

    <xsl:call-template name="jcgn:genobjects"/>
    <!-- take copyright from the root element: /cgn:copyright -->
    <xsl:variable name="copyright" select="//cgn:copyright"/>
    <!-- generate json parser -->
    <xsl:apply-templates select="$objects" mode="this:genparser">
      <xsl:with-param name="parser-class" select="$this:parser-class"/>
      <xsl:with-param name="parser-package" select="$this:parser-package"/>
      <xsl:with-param name="copyright" select="$copyright"/>
    </xsl:apply-templates>
    <!-- generate json generator -->
    <xsl:apply-templates select="$objects" mode="this:gengenerator">
      <xsl:with-param name="gen-class" select="$this:generator-class"/>
      <xsl:with-param name="gen-package" select="$this:generator-package"/>
      <xsl:with-param name="copyright" select="$copyright"/>
    </xsl:apply-templates>

  </xsl:template>
  
  
</xsl:stylesheet>

