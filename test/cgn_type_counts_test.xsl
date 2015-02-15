<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:include href="../objects/cgn_includes.xsl"/>


  <xsl:template match="cgn:object" mode="type-counts">
    <xsl:copy>
      <!-- copy all attributes and fields -->
      <xsl:copy-of select="@* | node()"/>

      <!-- create a child type-counts -->
      <xsl:element name="type-counts">
        <xsl:call-template name="cgn:create-type-counts-xml"/>
      </xsl:element>

    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="type-counts">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="type-counts"/>
    </xsl:copy>
  </xsl:template>

  
  <xsl:template name="create-type-counts-xml-test">
    <xsl:variable name="type-counts">
      <!-- construct cgn:object/object-counts  -->
      <xsl:apply-templates select="$cgn:preprocessed-objects" mode="type-counts" />
    </xsl:variable>

    <xsl:message>Testing cgn:create-type-counts-xml template</xsl:message>
    <!-- template for command line output -->
    <xsl:sequence select="$type-counts"/>

  </xsl:template>


</xsl:stylesheet>

