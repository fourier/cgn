<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java"
                xmlns:this="https://github.com/fourier/jcgn/builder/this">

  <xsl:template name="this:builderMainFunction">
    <xsl:param name="class-name"/>
    <xsl:param name="indent" select="1"/>
    <xsl:param name="funcname" select="'create'"/>
    <!-- comment -->
    <xsl:value-of select="concat(cgn:indent($indent),
                          '/**&#10;',
                          cgn:indent($indent),
                          ' * Creates the object instance &#10;',
                          cgn:indent($indent),
                          ' * @return created instance of the &lt;code&gt;',
                          $class-name,
                          '&lt;/code&gt;&#10;',
                          cgn:indent($indent),
                          ' */&#10;')"/>
    <!-- function body -->
    <xsl:value-of select="concat(
                          cgn:indent($indent),
                          'public',
                          ' ',
                          $class-name,
                          ' ',
                          $funcname,
                          '() {&#10;',
                          cgn:indent($indent+1),
                          'return new ',
                          $class-name,
                          '(this);&#10;',
                          cgn:indent($indent),
                          '}&#10;')"/>
  </xsl:template>
  
  
  <xsl:template match="cgn:object" mode="jcgn:builder">
    <!-- this template shall only be called from base cgn:object template -->
    <xsl:param name="class-name" />
    <!-- supposedly call this template for inner classes -->
    <xsl:param name="indent" select="1"/>
    <xsl:param name="builder" select="concat($class-name, 'Builder')"/>
    <xsl:param name="create-func-name" select="concat('create', $class-name)"/>
    <xsl:param name="attributes" />
    <!-- name of the builder class from 'name' attribute -->
    <xsl:variable name="builder-class-name" select="$builder"/>
    <!-- generate class header string like "class UserName {" -->
    <xsl:call-template name="jcgn:class-header">
      <xsl:with-param name="class-name" select="$builder-class-name"/>
      <xsl:with-param name="indent" select="$indent"/>
      <xsl:with-param name="attributes" select="$attributes"/>
      <!--xsl:with-param name="implements-interface" select="$request-base-class"/-->
    </xsl:call-template>
    <xsl:text>&#10;</xsl:text>

    <!-- add bitfield if is-set is true -->
    <xsl:if test="@cgn:is-set = 'true'">
      <xsl:value-of select="concat(cgn:indent($indent+1),
                            'private long ',
                            jcgn:bitfields-var-name($builder),
                            ' = 0;&#10;')"/>
    </xsl:if>
    
    <!-- generate fields of the class from the list of param elements, like
         "private String iDate;"
    -->
    <xsl:for-each select="cgn:field">
      <xsl:apply-templates select="." mode="jcgn:generate-field">
        <xsl:with-param name="indent" select="$indent"/>
      </xsl:apply-templates>
    </xsl:for-each>
    <xsl:text>&#10;</xsl:text>

    <xsl:call-template name="jcgn:constructor-empty">
      <xsl:with-param name="class-name" select="$builder-class-name"/>
      <xsl:with-param name="indent" select="$indent"/>
    </xsl:call-template>

    <!-- generate setters -->
    <xsl:for-each select="cgn:field">
      <xsl:choose>
        <xsl:when test="../@cgn:is-set = 'true'">
          <xsl:apply-templates select="." mode="jcgn:generate-bitfield-setter">
            <xsl:with-param name="class-name" select="$builder-class-name"/>
            <xsl:with-param name="indent" select="$indent"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="." mode="jcgn:generate-setter">
            <xsl:with-param name="class-name" select="$builder-class-name"/>
            <xsl:with-param name="indent" select="$indent"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>

    <xsl:call-template name="this:builderMainFunction">
      <xsl:with-param name="class-name" select="$class-name"/>
      <xsl:with-param name="indent" select="$indent+1"/>
      <xsl:with-param name="funcname" select="$create-func-name"/>
    </xsl:call-template>
    
    <!-- closing class -->
    <xsl:call-template name="jcgn:class-footer">
      <xsl:with-param name="indent" select="$indent"/>
    </xsl:call-template>

    <!-- one extra new line to make it look better in inner classes -->
    <xsl:text>&#10;</xsl:text>
    
  </xsl:template>

</xsl:stylesheet>
