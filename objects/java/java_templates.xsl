<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">
  
  <xsl:template name="jcgn:file-header">
    <!-- arguments: (optional)package - package name -->
    <xsl:param name="package"/>
    <xsl:param name="copyright" select="$cgn:default-copyright"/>
    <xsl:if test="$copyright != ''">
      <xsl:text>/**&#10;</xsl:text>
      <xsl:for-each select="tokenize($copyright, '\n\r?')">
        <xsl:if test="not((position() = 1 or position() = last()) and string-length(normalize-space(.)) = 0)">
          <xsl:value-of select="concat(' * ', cgn:left-trim(.), '&#10;')"/>
        </xsl:if>
      </xsl:for-each>
      <xsl:text> */&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="$package">
      <xsl:value-of select="concat('package ', $package, ';&#10;&#10;')"/>
    </xsl:if>
  </xsl:template>
  
  <!--
      Java class templates: header and footer
  -->
  <xsl:template name="jcgn:class-header">
    <!-- generate class header string like "class UserName [extends Task][implements BaseRequest]{" -->
    <xsl:param name="class-name"/>
    <xsl:param name="author" select="@cgn:author"/>
    <xsl:param name="extends-class"/>
    <xsl:param name="implements-interface"/>
    <xsl:param name="access" select="'public'"/>
    <xsl:param name="attributes"/>
    <xsl:param name="indent" select="0" />
    <xsl:if test="$indent = 0">
      <xsl:choose>
        <xsl:when test="(string-length($author) > 0) and (string-length($cgn:xml-name) > 0)">
          <xsl:value-of select="jcgn:generate-class-comment-by-author-file($author, $cgn:xml-name)"/>
        </xsl:when>
        <xsl:when test="string-length($author) > 0">
          <xsl:value-of select="jcgn:generate-class-comment-by-author($author)"/>
        </xsl:when>
        <xsl:when test="string-length($cgn:xml-name) > 0">
          <xsl:value-of select="jcgn:generate-class-comment-by-file($cgn:xml-name)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
    <xsl:value-of select="concat(cgn:indent($indent), $access, ' ', $attributes, 'class ', $class-name, ' ')" />
    <xsl:if test="$extends-class">
      <xsl:value-of select="concat('extends ', $extends-class, ' ')"/>
    </xsl:if>
    <xsl:if test="$implements-interface">
      <xsl:value-of select="concat('implements ', $implements-interface, ' ')"/>
    </xsl:if>
    <xsl:text>{&#10;</xsl:text>
  </xsl:template>

  <xsl:template name="jcgn:class-footer">
    <xsl:param name="indent" select="0" />
    <!-- generate class footer string "}" -->
    <xsl:value-of select="cgn:indent($indent)"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:template>

  <!--
      Java interface template: header (footer is the same as java class)
  -->
  <xsl:template name="jcgn:interface-header">
    <!-- generate class header string like "class UserName [extends Task][implements BaseRequest]{" -->
    <xsl:param name="class-name"/>
    <xsl:param name="access" select="'public'"/>    
    <xsl:param name="extends-interface"/>
    <xsl:param name="attributes"/>
    <xsl:param name="indent" select="0" />
    <xsl:if test="($indent = 0 and $cgn:xml-name)">
      <xsl:value-of select="jcgn:generate-class-comment-by-file($cgn:xml-name)"/>
    </xsl:if>
    <xsl:value-of select="concat(cgn:indent($indent), $access, ' ', $attributes, ' interface ', $class-name, ' ')" />
    <xsl:if test="$extends-interface and not($extends-interface = '')">
      <xsl:value-of select="concat('extends ', $extends-interface, ' ')"/>
    </xsl:if>
    <xsl:text>{&#10;</xsl:text>
  </xsl:template>

  
  <xsl:template match="cgn:field" mode="jcgn:generate-field">
    <!--
        Generates a field in class like
        "    private String name;\n"
    -->
    <xsl:param name="indent" select="0" />
    <xsl:param name="final" select="false()"/>
    <!-- if we should exctract type from FQDN name -->
    <xsl:variable name="name" select="./@jcgn:variable-name"/>
    <xsl:variable name="type" select="./@jcgn:type"/>
    <xsl:variable name="final-string" select="if ($final) then 'final ' else ''"/>
    <xsl:value-of select="concat(cgn:indent($indent+1), 'private ', $final-string ,$type, ' ', $name, ';&#10;')"/>
  </xsl:template>
  
  <xsl:template match="cgn:field" mode="jcgn:generate-getter">
    <!--
        Generate a getter for a field.
    -->
    <xsl:param name="indent" select="0" />
    <xsl:variable name="variable-name"
                  select="if (not(@jcgn:variable-name))
                          then (jcgn:generate-field-name(@cgn:name))
                          else (@jcgn:variable-name)"/>
    <xsl:variable name="type"
                  select="if (not(@jcgn:type))
                          then (jcgn:type-to-java-type(./@cgn:type, ./@jcgn:date-type))
                          else (@jcgn:type)"/>
    <xsl:value-of select="concat(cgn:indent($indent+1), '/**&#10;',
                          cgn:indent($indent+1), ' * @return the value of the &quot;', @cgn:name, '&quot; field&#10;',
                          cgn:indent($indent+1), ' */&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent+1), 'public ', 
                          $type)"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="concat(jcgn:create-getter-name(./@cgn:name),
                          '() {&#10;',
                          cgn:indent($indent+2),
                          'return this.',
                          $variable-name,
                          ';&#10;',
                          cgn:indent($indent+1),
                          '}&#10;&#10;')"/>
  </xsl:template>

  <xsl:template match="cgn:field" mode="jcgn:generate-setter">
    <!--
        Generate a setter for a field.
    -->
    <xsl:param name="class-name"/>
    <xsl:param name="indent" select="0" />
    <xsl:variable name="name" select="./@cgn:name"/>
    <xsl:variable name="var-name"
                  select="if (not(@jcgn:variable-name))
                          then (jcgn:generate-field-name(@cgn:name))
                          else (@jcgn:variable-name)"/>
    <xsl:variable name="type"
                  select="if (not(@jcgn:type))
                          then (jcgn:type-to-java-type(./@cgn:type, ./@jcgn:date-type))
                          else (@jcgn:type)"/>
    <xsl:variable name="bitfield-name" select="jcgn:bitfield-name($name)"/>
    <xsl:variable name="bitfield-var-name" select="jcgn:bitfields-var-name($class-name)"/>
    <xsl:value-of select="concat(cgn:indent($indent+1), '/**&#10;',
                          cgn:indent($indent+1), ' * Sets the &quot;', @cgn:name, '&quot; field to the value supplied &#10;',
                          cgn:indent($indent+1), ' * &#10;',
                          cgn:indent($indent+1), ' * @param ', jcgn:create-function-argument($name), ' the value to the set into the &quot;', @cgn:name, '&quot; field&#10;',
                          cgn:indent($indent+1), ' * @return reference to this object instance&#10;',
                          cgn:indent($indent+1), ' */&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent+1),'public ', $class-name, ' ')"/>   
    <xsl:value-of select="concat(
                          jcgn:create-setter-name(./@cgn:name),
                          '(',
                          $type,
                          ' ',
                          jcgn:create-function-argument($name),
                          ') {&#10;',
                          cgn:indent($indent+2),
                          'this.')"/>
    <xsl:apply-templates select="." mode="jcgn:generate-field-assignment"/>
    <xsl:value-of select="concat(cgn:indent($indent+2),
                          'return this;&#10;',
                          cgn:indent($indent+1),
                          '}&#10;&#10;')"/>
  </xsl:template>

  <xsl:template match="cgn:field" mode="jcgn:generate-bitfield-setter">
    <!--
        Generate a setter for a field.
    -->
    <xsl:param name="class-name"/>
    <xsl:param name="indent" select="0" />
    <xsl:variable name="name" select="./@cgn:name"/>
    <xsl:variable name="var-name"
                  select="if (not(@jcgn:variable-name))
                          then (jcgn:generate-field-name(@cgn:name))
                          else (@jcgn:variable-name)"/>
    <xsl:variable name="type"
                  select="if (not(@jcgn:type))
                          then (jcgn:type-to-java-type(./@cgn:type, ./@jcgn:date-type))
                          else (@jcgn:type)"/>
    <xsl:variable name="bitfield-name" select="jcgn:bitfield-name($name)"/>
    <xsl:variable name="bitfield-var-name" select="jcgn:bitfields-var-name($class-name)"/>
    <xsl:value-of select="concat(cgn:indent($indent+1), '/**&#10;',
                          cgn:indent($indent+1), ' * Sets the &quot;', @cgn:name, '&quot; field to the value supplied &#10;',
                          cgn:indent($indent+1), ' * &#10;',
                          cgn:indent($indent+1), ' * @param ', jcgn:create-function-argument($name), ' the value to the set into the &quot;', @cgn:name, '&quot; field&#10;',
                          cgn:indent($indent+1), ' * @return reference to this object instance&#10;',
                          cgn:indent($indent+1), ' */&#10;')"/>

    <xsl:value-of select="concat(cgn:indent($indent+1),'public ', $class-name, ' ')"/>   
    <xsl:value-of select="concat(
                          jcgn:create-setter-name(./@cgn:name),
                          '(',
                          $type,
                          ' ',
                          jcgn:create-function-argument($name),
                          ') {&#10;',
                          cgn:indent($indent+2),
                          'this.',
                          jcgn:generate-field-assignment($name))"/>
    <xsl:value-of select="concat(cgn:indent($indent+2),
                          'this.',
                          $bitfield-var-name,
                          ' |= ',
                          $bitfield-name,
                          ';&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent+2),
                          'return this;&#10;',
                          cgn:indent($indent+1),
                          '}&#10;&#10;')"/>
  </xsl:template>

  
  <xsl:template name="jcgn:generate-arguments">
    <xsl:param name="class-name" select="cgn:pascalize-string(@cgn:name)"/>
    <xsl:param name="indent" select="1"/>
    <xsl:variable name="start-string" select="concat(cgn:indent($indent+1),'public ', $class-name,'(')"/>
    <xsl:variable name="offset">
      <xsl:for-each select="(1 to string-length($start-string))">
        <xsl:text>&#32;</xsl:text>
      </xsl:for-each>
    </xsl:variable>
    <!-- arguments list -->
    <xsl:for-each select="cgn:field">
      <!-- take type, space, variable name -->
      <xsl:variable name="arg" 
                    select="concat(./@jcgn:type,
                            ' ',
                            jcgn:create-function-argument(./@cgn:name))"/>
      <xsl:if test="position() != 1">
        <xsl:value-of select="$offset"/>
      </xsl:if>
      <xsl:value-of select="$arg"/>
      <xsl:if test="position() != last( )">,&#10;</xsl:if>
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="cgn:field" mode="jcgn:generate-field-assignment">
    <xsl:param name="argument-name" select="jcgn:create-function-argument(@cgn:name)"/>
    <xsl:param name="indent" select="0"/>
    <xsl:variable name="variable-name"
                  select="if (not(@jcgn:variable-name))
                          then (jcgn:generate-field-name(@cgn:name))
                          else (@jcgn:variable-name)"/>
    <xsl:value-of select="concat(cgn:indent($indent),
                          $variable-name,
                          ' = ',
                          $argument-name,
                          ';&#10;')"/>
  </xsl:template>

  
  <xsl:template name="jcgn:generate-assignments">
    <xsl:param name="indent" select="0" />
    <xsl:for-each select="cgn:field">
      <xsl:value-of select="cgn:indent($indent)"/>
      <xsl:apply-templates select="." mode="jcgn:generate-field-assignment"/> 
    </xsl:for-each>
  </xsl:template>
  

  <xsl:template name="jcgn:constructor">
    <!-- called from cgn:object, generates a constructor from fields, like:
         public UserName(String date) {
         iDate = date;
         }
    -->
    <xsl:param name="class-name"/>
    <xsl:param name="indent" select="0" />
    <xsl:value-of select="concat(cgn:indent($indent+1),'public ', $class-name,'(')"/>
    <!-- generate arguments -->
    <xsl:call-template name="jcgn:generate-arguments">
      <xsl:with-param name="class-name" select="$class-name"/>
      <xsl:with-param name="indent" select="$indent"/>
    </xsl:call-template>
    <xsl:text>) {&#10;</xsl:text>
    <!-- body of constructor : list of field assignments -->
    <xsl:call-template name="jcgn:generate-assignments">
      <xsl:with-param name="indent" select="$indent+2"/>
    </xsl:call-template>
    <!-- set fields in case of is-set flag -->
    <xsl:if test="@cgn:is-set='true'">
      <xsl:value-of select="concat(cgn:indent($indent+2),
                            jcgn:bitfields-var-name($class-name),
                            ' = (1 &lt;&lt; ',
                            count(cgn:field),
                            ') - 1;&#10;')"/>
    </xsl:if>
    <xsl:value-of select="concat(cgn:indent($indent+1),'}&#10;&#10;')"/>
  </xsl:template>

  <xsl:template name="jcgn:constructor-from-builder">
    <!-- called from cgn:object, generates a constructor from builder:
         protected UserName(UserNameBuilder builder) {
             iDate = builder.iDate;
         }
         protected to allow to use in derived classes as well
    -->
    <xsl:param name="class-name"/>
    <xsl:param name="indent" select="0" />
    <xsl:value-of select="concat(cgn:indent($indent+1),
                          '/**&#10;',
                          cgn:indent($indent+1),
                          ' * Constructor from the Builder &#10;',
                          cgn:indent($indent+1),
                          ' */&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent+1),
                          'protected ',
                          $class-name,'(Builder builder) {&#10;')"/>
    <!-- body of constructor : list of field assignments -->
    <xsl:for-each select="cgn:field">
      <xsl:value-of select="concat(cgn:indent($indent+2),
                            jcgn:generate-field-name(@cgn:name),
                            ' = builder.',
                            jcgn:generate-field-name(@cgn:name),
                            ';&#10;')"/>
    </xsl:for-each>
    <!-- set fields in case of is-set flag -->
    <xsl:if test="@cgn:is-set='true'">
      <xsl:value-of select="concat(cgn:indent($indent+2),
                            jcgn:bitfields-var-name($class-name),
                            ' = builder.',
                            jcgn:bitfields-var-name('Builder'),
                            ';&#10;')"/>
    </xsl:if>
    <xsl:value-of select="concat(cgn:indent($indent+1),'}&#10;&#10;')"/>
  </xsl:template>

  
  <xsl:template name="jcgn:constructor-empty">
    <!-- called from cgn:object, generates an empty constructor, like:
         public UserName() {
         }
    -->
    <xsl:param name="class-name"/>
    <xsl:param name="indent" select="0" />
    <xsl:value-of select="concat(cgn:indent($indent+1),'public ', $class-name,'() {&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent+1),'}&#10;&#10;')"/>
  </xsl:template>
  

  <xsl:template name="jcgn:test-isset-applicable">
    <!-- determine correctness of the builder value -->
    <xsl:if test="@cgn:is-set = 'true' and count(cgn:field)>31">
      <xsl:message terminate="yes">
        <xsl:value-of select="concat('Object ',
                              @cgn:package,
                              '.',
                              @cgn:name,
                              ' has ',
                              count(cgn:field),
                              ' fields, but only 31 supported for now in order to generate isSet-family of methods')"/>
      </xsl:message>
    </xsl:if>
  </xsl:template>


</xsl:stylesheet>
