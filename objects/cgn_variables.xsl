<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn">

  <!-- defaults -->
  <xsl:variable name="cgn:default-package">com.example.cgn</xsl:variable>
  <xsl:variable name="cgn:default-read-only">false</xsl:variable>
  
    
  <xsl:variable name="cgn:primitive-types">string,date,int,double,long,boolean,byte</xsl:variable>
  <xsl:variable name="cgn:primitive-types-list" select="tokenize($cgn:primitive-types, ',')"/>
  <xsl:variable name="cgn:indent-size" select="4"/>
  <xsl:variable name="cgn:default-json">false</xsl:variable>
  <xsl:variable name="cgn:default-is-set">false</xsl:variable>
    
</xsl:stylesheet>

