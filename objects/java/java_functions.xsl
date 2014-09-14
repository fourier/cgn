<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">
  

  <xsl:variable name="primitive-type-to-java-type-map">
    <entry key="string">String</entry>
    <entry key="date">java.util.Date</entry>
    <entry key="int">Integer</entry>
    <entry key="double">Double</entry>
    <entry key="long">Long</entry>
    <entry key="boolean">Boolean</entry>
    <entry key="byte">Byte</entry>
  </xsl:variable>

  <xsl:variable name="primitive-type-to-java-primitive-type-map">
    <entry key="string">String</entry>
    <entry key="date">java.util.Date</entry>
    <entry key="int">int</entry>
    <entry key="double">double</entry>
    <entry key="long">long</entry>
    <entry key="boolean">boolean</entry>
    <entry key="byte">byte</entry>
  </xsl:variable>

  
  <xsl:function name="cgn:primitive-type-to-java-type">
    <xsl:param name="type"/>
    <xsl:value-of select="$primitive-type-to-java-primitive-type-map/entry[@key=$type]"/>
  </xsl:function>

  <xsl:function name="cgn:array-to-java-type">
    <xsl:param name="array-type"/>
    <xsl:choose>
      <xsl:when test="cgn:is-primitive-type($array-type)">
        <xsl:value-of select="$primitive-type-to-java-type-map/entry[@key=$array-type]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$array-type"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="cgn:type-to-java-type">
    <xsl:param name="type"/>
    <xsl:param name="array-type"/>
    <xsl:choose>
      <!-- first verify if primitive type -->
      <xsl:when test="cgn:is-primitive-type($type)">
        <xsl:value-of select="cgn:primitive-type-to-java-type($type)"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- not a primitive type, verify if an array -->
        <xsl:choose>
          <xsl:when test="$type='array'">
            <xsl:value-of select="concat('java.util.ArrayList&lt;', cgn:array-to-java-type($array-type), '&gt;')"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- not an array, just return as it is -->
            <xsl:value-of select="$type"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="jcgn:generate-import">
    <xsl:param name="package"/>
    <xsl:value-of select="concat('import ', $package, ';&#10;')"/>
  </xsl:function>

  <xsl:function name="cgn:create-java-file-name">
    <xsl:param name="package"/>
    <xsl:param name="file-name"/>
    <xsl:variable name="path">
      <xsl:for-each select="tokenize($package, '\.')">
        <xsl:variable name="component" select="."/>
        <xsl:value-of select="concat($component,'/')"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="concat('gen/', $path, $file-name)"/>
  </xsl:function>                  


  <xsl:function name="cgn:create-setter-name">
    <xsl:param name="name"/>
    <xsl:value-of select="concat('set',
      cgn:pascalize-string($name))"/>
  </xsl:function>
  
</xsl:stylesheet>
