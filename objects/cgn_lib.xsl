<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn">


  <xsl:function name="cgn:camelize-string">
    <!--
        removes dashes from string and camelizes. Example:
        cgn:camelize-string("user-name")
        returns userName
    -->
    <xsl:param name="word"/>
    <xsl:variable name="result">
      <xsl:for-each select="tokenize($word, '-')">
        <xsl:variable name="token" select="."/>
        <xsl:choose>
          <xsl:when test="position()=1">
            <xsl:value-of select="concat(lower-case(substring($token,1,1)),
                                  substring($token,2))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat(upper-case(substring($token,1,1)),
                                  substring($token,2))"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="$result"/>
  </xsl:function>


    <xsl:function name="cgn:pascalize-string">
    <!--
        removes dashes from string and pascalizes. Example:
        cgn:pascalize-string("user-name")
        returns UserName
    -->
    <xsl:param name="word"/>
    <xsl:variable name="result">
      <xsl:for-each select="tokenize($word, '-')">
        <xsl:variable name="token" select="."/>
        <xsl:value-of select="concat(upper-case(substring($token,1,1)),
                              substring($token,2))"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="$result"/>
  </xsl:function>

  <xsl:function name="cgn:generate-field-name">
    <!--
        convert a parameter to the field name. Example:
        cgn:generate-field-name("user-name")
        returns iUserName
    -->
    <xsl:param name="field"/>
    <xsl:value-of select="concat('i', cgn:pascalize-string($field))"/>
  </xsl:function>

  <xsl:function name="cgn:generate-field-assignment">
    <!--
        convert a parameter to the field name. Example:
        cgn:generate-field-assignment("user-name")
        returns iUserName = userName;
    -->
    <xsl:param name="field"/>
    <xsl:value-of select="concat(
                          cgn:generate-field-name($field),
                          ' = ',
                          cgn:camelize-string($field),
                          ';&#10;')"/>
  </xsl:function>


  <xsl:function name="cgn:get-short-filename">
    <!--
        returns the short file name of the argument supplied. Examlp:
        cgn:get-short-filename("/Users/alexeyv/Sources/Veroveli/ttandroid/src/com/veroveli/tiro/tasks/model/protocol/protocol.xml")
        returns "protocol.xml"
    -->
    <xsl:param name="full-file-name"/>
    <xsl:variable name="tokenized"><xsl:value-of select="tokenize($full-file-name, '/')[last()]"/></xsl:variable>
    <xsl:value-of select="$tokenized"/>
  </xsl:function>
  
  <xsl:function name="cgn:get-current-date">
    <!-- returns the current date in format dd/mm/yyyy -->
    <xsl:variable name="now" select="current-dateTime()" />
    <xsl:variable name="result" select="concat(day-from-dateTime($now), '/', month-from-dateTime($now), '/', year-from-dateTime($now))" />
    <xsl:value-of select="$result"/>
  </xsl:function>

  
  <xsl:function name="cgn:generate-class-comment">
    <xsl:param name="file"/>
    <xsl:value-of select="concat('/**&#10; * Generated from ', cgn:get-short-filename($file), ' on ', cgn:get-current-date(), '&#10; */&#10;')"/>
  </xsl:function>

  <xsl:function name="cgn:is-primitive-type">
    <xsl:param name="type"/>
    <xsl:sequence select="exists($cgn:primitive-types-list[. = $type])"/>
  </xsl:function>

  <xsl:function name="cgn:indent">
    <xsl:param name="level"/>
    <xsl:variable name="result">
      <xsl:for-each select="(1 to $level*$cgn:indent-size)">
        <xsl:text>&#32;</xsl:text>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="$result"/>
  </xsl:function>

  
</xsl:stylesheet>