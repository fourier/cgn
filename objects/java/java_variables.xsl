<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">
  
  <!-- defaults -->
  <xsl:variable name="jcgn:default-builder">false</xsl:variable>
  <xsl:variable name="jcgn:default-parcelable">false</xsl:variable>
  <xsl:variable name="jcgn:default-date-type">java</xsl:variable>

  <!-- type mappings -->
  <xsl:variable name="jcgn:primitive-type-to-java-type-map">
    <entry key="string">String</entry>
    <entry key="date">java.util.Date</entry>
    <entry key="int">Integer</entry>
    <entry key="double">Double</entry>
    <entry key="long">Long</entry>
    <entry key="boolean">Boolean</entry>
    <entry key="byte">Byte</entry>
  </xsl:variable>
  
  <xsl:variable name="jcgn:primitive-type-to-java-primitive-type-map">
    <entry key="string">String</entry>
    <entry key="date">java.util.Date</entry>
    <entry key="int">int</entry>
    <entry key="double">double</entry>
    <entry key="long">long</entry>
    <entry key="boolean">boolean</entry>
    <entry key="byte">byte</entry>
  </xsl:variable>

  
</xsl:stylesheet>

