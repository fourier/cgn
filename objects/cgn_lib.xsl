<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">

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

  <xsl:function name="cgn:get-short-filename">
    <!--
        returns the short file name of the argument supplied. Example:
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

  <xsl:function name="cgn:is-primitive-type">
    <xsl:param name="type"/>
    <xsl:sequence select="exists($cgn:primitive-types-list[. = $type])"/>
  </xsl:function>

  <xsl:function name="cgn:is-array">
    <xsl:param name="type"/>
    <xsl:sequence select="starts-with($type, '[') and ends-with($type,']')"/>
  </xsl:function>

  <xsl:function name="cgn:array-type">
    <xsl:param name="type"/>
    <xsl:sequence select="substring($type, 2, string-length($type)-2)"/>
  </xsl:function>

  <xsl:function name="cgn:create-array">
    <xsl:param name="type"/>
    <xsl:value-of select="concat('[', $type, ']')"/>
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

  <!--
      functions
      left-trim,
      extract-type-package,
      extract-type-name
      are based on http://www.xsltfunctions.com/ -->
  <xsl:function name="cgn:left-trim" as="xs:string">
    <xsl:param name="arg" as="xs:string?"/>
    <xsl:sequence select="replace($arg,'^\s+','')"/>
  </xsl:function>

  <xsl:function name="cgn:type-contains-package" as="xs:boolean">
    <xsl:param name="type" as="xs:string?"/>
    <xsl:value-of select='contains($type, ".")'/>    
  </xsl:function>

  <xsl:function name="cgn:extract-type-name" as="xs:string">
    <xsl:param name="type" as="xs:string?"/>
    <xsl:value-of select="replace($type,concat('^.*','\.'),'')"/>
  </xsl:function>

  <xsl:function name="cgn:extract-type-package" as="xs:string">
    <xsl:param name="arg" as="xs:string?"/>
    <xsl:value-of select="
                          if (matches($arg, '\.'))
                          then replace($arg,
                          concat('^(.*)', '\.','.*'),
                          '$1')
                          else ''"/>
  </xsl:function>

  <xsl:function name="cgn:extract-type" as="xs:string">
    <xsl:param name="type"/>
    <xsl:value-of select="if (not(cgn:is-array($type))) then $type else cgn:array-type($type)"/>
  </xsl:function>

  
  <xsl:function name="cgn:create-fqdn-full-type" as="xs:string">
    <xsl:param name="package" as="xs:string?"/>
    <xsl:param name="type" as="xs:string?"/>
    <xsl:variable name="class-name" select="if (cgn:type-contains-package($type)) then cgn:extract-type-name($type) else $type"/>
    <xsl:variable name="class-pkg" select="if (cgn:type-contains-package($type)) then cgn:extract-type-package($type) else $package"/>
    <xsl:value-of select="concat($class-pkg,'.',$class-name)"/>
  </xsl:function>

  <xsl:function name="cgn:type-is-in-package" as="xs:boolean">
    <xsl:param name="type" as="xs:string"/>
    <xsl:param name="package" as="xs:string"/>
    <xsl:sequence select="cgn:extract-type-package($type) = $package"/>
  </xsl:function>

  
</xsl:stylesheet>
