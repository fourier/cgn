<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">
  
  <xsl:template name="jcgn:file-header">
    <!-- arguments: (optional)package - package name -->
    <xsl:param name="package"/>
    <xsl:if test="$cgn:copyright-var != ''">
      <xsl:text>/*&#10;</xsl:text>
      <xsl:for-each select="tokenize($cgn:copyright-var, '\n\r?')">
        <xsl:value-of select="concat(' * ', ., '&#10;')"/>
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
  <xsl:template name="java-class-header">
    <!-- generate class header string like "class UserName [extends Task][implements BaseRequest]{" -->
    <xsl:param name="class-name"/>
    <xsl:param name="extends-class"/>
    <xsl:param name="implements-interface"/>
    <xsl:param name="access" select="'public'"/>
    <xsl:param name="attributes"/>
    <xsl:param name="indent" select="0" />
    <xsl:if test="($indent = 0 and $cgn:xml-name)">
      <xsl:value-of select="cgn:generate-class-comment($cgn:xml-name)"/>
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

  <xsl:template name="java-class-footer">
    <xsl:param name="indent" select="0" />
    <!-- generate class footer string "}" -->
    <xsl:value-of select="cgn:indent($indent)"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:template>

  <!--
      Java interface template: header (footer is the same as java class)
  -->
  <xsl:template name="java-interface-header">
    <!-- generate class header string like "class UserName [extends Task][implements BaseRequest]{" -->
    <xsl:param name="class-name"/>
    <xsl:param name="access" select="'public'"/>    
    <xsl:param name="extends-interface"/>
    <xsl:param name="attributes"/>
    <xsl:param name="indent" select="0" />
    <xsl:if test="($indent = 0 and $cgn:xml-name)">
      <xsl:value-of select="cgn:generate-class-comment($cgn:xml-name)"/>
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
    <xsl:variable name="name" select="jcgn:generate-field-name(./@cgn:name)"/>
    <xsl:variable name="type" select="cgn:type-to-java-type(./@cgn:type, ./@jcgn:type)"/>
    <xsl:variable name="final-string" select="if ($final) then 'final ' else ''"/>
    <xsl:value-of select="concat(cgn:indent($indent+1), 'private ', $final-string ,$type, ' ', $name, ';&#10;')"/>
  </xsl:template>
  
  <xsl:template match="cgn:field" mode="jcgn:generate-getter">
    <!--
        Generate a getter for a field.
    -->
    <xsl:param name="indent" select="0" />
    <xsl:value-of select="concat(cgn:indent($indent+1), 'public ', cgn:type-to-java-type(./@cgn:type, ./@jcgn:type))"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="concat(jcgn:create-getter-name(./@cgn:name),
                          '() {&#10;',
                          cgn:indent($indent+2),
                          'return this.',
                          jcgn:generate-field-name(./@cgn:name),
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
    <xsl:variable name="type" select="cgn:type-to-java-type(./@cgn:type, ./@jcgn:type)"/>
    <xsl:variable name="var-name" select="jcgn:generate-field-name($name)"/>
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
                          jcgn:generate-field-assignment($name),
                          cgn:indent($indent+2),
                          'return this;&#10;',
                          cgn:indent($indent+1),
                          '}&#10;&#10;')"/>
  </xsl:template>

  <xsl:template name="jcgn:generate-arguments">
    <!-- arguments list -->
    <xsl:for-each select="cgn:field">
      <!-- take type, space, variable name -->
      <xsl:value-of select="concat(cgn:type-to-java-type(./@cgn:type, ./@jcgn:type),
                            ' ',
                            jcgn:create-function-argument(./@cgn:name))"/>
      <xsl:if test="position() != last( )">, </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="jcgn:generate-assignments">
    <xsl:param name="indent" select="0" />
    <xsl:for-each select="cgn:field">
      <xsl:value-of select="concat(cgn:indent($indent+2),
                            jcgn:generate-field-assignment(./@cgn:name))"/>
    </xsl:for-each>
  </xsl:template>
    

  <xsl:template name="java-constructor">
    <!-- called from cgn:object, generates a constructor from fields, like:
         public UserName(String date) {
         iDate = date;
         }
    -->
    <xsl:param name="class-name"/>
    <xsl:param name="indent" select="0" />
    <xsl:value-of select="concat(cgn:indent($indent+1),'public ', $class-name,'(')"/>
    <!-- generate arguments -->
    <xsl:call-template name="jcgn:generate-arguments"/>
    <xsl:text>) {&#10;</xsl:text>
    <!-- body of constructor : list of field assignments -->
    <xsl:call-template name="jcgn:generate-assignments">
      <xsl:with-param name="indent" select="$indent"/>
    </xsl:call-template>
    <xsl:value-of select="concat(cgn:indent($indent+1),'}&#10;&#10;')"/>
  </xsl:template>

  <xsl:template name="java-constructor-empty">
    <!-- called from cgn:object, generates an empty constructor, like:
         public UserName() {
         }
    -->
    <xsl:param name="class-name"/>
    <xsl:param name="indent" select="0" />
    <xsl:value-of select="concat(cgn:indent($indent+1),'public ', $class-name,'() {&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent+1),'}&#10;&#10;')"/>
  </xsl:template>
  
  <xsl:template name="jcgn:test-builder-value">
    <!-- determine correctness of the builder value -->
    <xsl:if test="./@jcgn:builder and not(./@jcgn:builder = 'true') and not(./@jcgn:builder = 'false')">
      <xsl:message terminate="yes">
        <xsl:text>jcgn:builder attribute can have either 'false' or 'true' values, or absent(false by default)</xsl:text>
      </xsl:message>
    </xsl:if>
  </xsl:template>

  
  
</xsl:stylesheet>
