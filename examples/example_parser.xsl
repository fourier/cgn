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
  <xsl:include href="../objects/java/java_phase5.xsl"/>
  <xsl:include href="../objects/java/java_phase6.xsl"/>
  <xsl:include href="../objects/java/java_phase7.xsl"/>

  <xsl:include href="../json/java/java_parser.xsl" />
  <xsl:include href="../json/java/java_generator.xsl" />
  <xsl:include href="../json/java/java_genparsers.xsl" />



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

