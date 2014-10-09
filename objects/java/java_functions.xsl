<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">
  

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


  <xsl:function name="jcgn:is-primitive-java-type">
    <xsl:param name="name"/>
    <xsl:variable name="primitive-java-types">byte,short,int,long,float,double,boolean,char,String</xsl:variable>
    <xsl:variable name="primitive-java-types-list" select="tokenize($primitive-java-types, ',')"/>
    <xsl:sequence select="exists($primitive-java-types-list[. = $name])"/>
  </xsl:function>
  
  
  <xsl:function name="jcgn:primitive-type-to-java-type">
    <xsl:param name="type"/>
    <xsl:value-of select="$jcgn:primitive-type-to-java-primitive-type-map/entry[@key=$type]"/>
  </xsl:function>

  <xsl:function name="jcgn:array-to-java-type">
    <xsl:param name="type"/>
    <xsl:param name="jtype"/>
    <xsl:variable name="array-type" select="cgn:array-type($type)"/>
    <xsl:choose>
      <xsl:when test="cgn:is-primitive-type($array-type)">
        <!-- handle case of the jcgn:type separately -->
        <xsl:choose>
          <xsl:when test="not($jtype)">
            <xsl:value-of select="$jcgn:primitive-type-to-java-type-map/entry[@key=$array-type]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$jtype"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$array-type"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="cgn:type-to-java-type">
    <xsl:param name="type"/>
    <xsl:param name="jtype"/>
    <xsl:choose>
      <!-- first verify if primitive type -->
      <xsl:when test="cgn:is-primitive-type($type)">
        <!-- handle case of the jcgn:type separately -->
        <xsl:choose>
          <xsl:when test="not($jtype)">
            <xsl:value-of select="jcgn:primitive-type-to-java-type($type)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$jtype"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- not a primitive type, verify if an array -->
        <xsl:choose>
          <xsl:when test="cgn:is-array($type)">
            <xsl:value-of select="concat('java.util.ArrayList&lt;', jcgn:array-to-java-type($type, $jtype), '&gt;')"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- not an array, just return as it is -->
            <xsl:value-of select="$type"/>
            <!--xsl:message terminate="yes"><xsl:value-of select="concat('Unknown type: ', $type)"/></xsl:message-->
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


  <xsl:function name="jcgn:create-setter-name">
    <xsl:param name="name"/>
    <xsl:value-of select="concat('set',
      cgn:pascalize-string($name))"/>
  </xsl:function>

  <xsl:function name="jcgn:create-is-set-name">
    <xsl:param name="name"/>
    <xsl:value-of select="concat('isSet',
      cgn:pascalize-string($name))"/>
  </xsl:function>

  
  <xsl:function name="jcgn:create-getter-name">
    <xsl:param name="name"/>
    <xsl:value-of select="concat('get',
      cgn:pascalize-string($name))"/>
  </xsl:function>

  <xsl:function name="jcgn:create-function-argument">
    <xsl:param name="name"/>
    <xsl:variable name="arg-name" select="cgn:camelize-string($name)"/>
    <xsl:choose>
      <xsl:when test="jcgn:is-primitive-java-type($arg-name)">
        <xsl:value-of select="concat('_', $arg-name)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$arg-name"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="jcgn:generate-field-assignment">
    <!--
        convert a parameter to the field name. Example:
        cgn:generate-field-assignment("user-name")
        returns iUserName = userName;
    -->
    <xsl:param name="field"/>
    <xsl:value-of select="concat(
                          jcgn:generate-field-name($field),
                          ' = ',
                          jcgn:create-function-argument($field),
                          ';&#10;')"/>
  </xsl:function>

  <xsl:function name="jcgn:generate-field-name">
    <!--
        convert a parameter to the field name. Example:
        jcgn:generate-field-name("user-name")
        returns iUserName
    -->
    <xsl:param name="field"/>
    <xsl:value-of select="concat('m', cgn:pascalize-string($field))"/>
  </xsl:function>
  
  
  <xsl:function name="jcgn:bitfields-var-name">
    <xsl:param name="class-name"/>
    <xsl:value-of select="concat('m',$class-name,'FieldsSetBitMask')"/>
  </xsl:function>
  
  <xsl:function name="jcgn:bitfield-name">
    <xsl:param name="name"/>
    <xsl:value-of select="concat(upper-case(replace($name, '-', '_')), '_FIELD_MASK')"/>
  </xsl:function>

  
</xsl:stylesheet>
