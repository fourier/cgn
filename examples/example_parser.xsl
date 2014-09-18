<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java"
                xmlns:this="https://github.com/fourier/cgn/parser/example/java/this">
  
  <xsl:import href="../objects/java/java_genobjects.xsl" />
  <xsl:include href="../json/java/java_parser.xsl" />
  <xsl:include href="../json/java/java_generator.xsl" />
  

  <xsl:variable name="this:parser-class">ObjectsParser</xsl:variable>
  <xsl:variable name="this:parser-package">com.veroveli.example.parser</xsl:variable>
  <xsl:variable name="this:generator-class">ObjectsGenerator</xsl:variable>
  <xsl:variable name="this:generator-package">com.veroveli.example.generator</xsl:variable>

  
  <xsl:template match="/" mode="this:genparser">
    <xsl:param name="parser-class"/>
    <xsl:param name="parser-package"/>
    <!-- creating parser -->
    <xsl:message>Generating JSON parser</xsl:message>
    <xsl:call-template name="cgn:generate-json-parser">
      <xsl:with-param name="parser-package" select="$parser-package"/>
      <xsl:with-param name="parser-class" select="$parser-class"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="/" mode="this:gengenerator">
    <xsl:param name="gen-class"/>
    <xsl:param name="gen-package"/>
    <!-- creating parser -->
    <xsl:message>Generating JSON generator</xsl:message>
    <xsl:call-template name="cgn:generate-json-generator">
      <xsl:with-param name="gen-package" select="$gen-package"/>
      <xsl:with-param name="gen-class" select="$gen-class"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="jcgn:gen-parser-main">
    <xsl:call-template name="jcgn:genobjects"/>
    <!-- generate json parser -->
    <xsl:apply-templates select="$jcgn:preprocessed-objects" mode="this:genparser">
      <xsl:with-param name="parser-class" select="$this:parser-class"/>
      <xsl:with-param name="parser-package" select="$this:parser-package"/>
    </xsl:apply-templates>
    <!-- generate json generator -->
    <xsl:apply-templates select="$jcgn:preprocessed-objects" mode="this:gengenerator">
      <xsl:with-param name="gen-class" select="$this:generator-class"/>
      <xsl:with-param name="gen-package" select="$this:generator-package"/>
    </xsl:apply-templates>

  </xsl:template>
  
  
</xsl:stylesheet>

