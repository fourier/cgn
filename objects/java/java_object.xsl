<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java"
                xmlns:this="https://github.com/fourier/cgn/java/object">
  <xsl:include href="java_builder.xsl"/>
  <xsl:include href="java_parcelable.xsl"/>

  <!--xsl:template match="cgn:object" mode="builderJava"-->

  
  <xsl:template match="cgn:field" mode="this:generate-bitfield-const">
    <xsl:param name="pos"/>
    <xsl:param name="indent"/>
    <xsl:variable name="name" select="jcgn:bitfield-name(@cgn:name)"/>
    <xsl:value-of select="concat(cgn:indent($indent),
                          'private static long ',
                          $name,
                          ' = 1 &lt;&lt; ',
                          ($pos)-1,
                          ';&#10;')"/>
  </xsl:template>


  <xsl:template name="this:generate-bitfields">
    <xsl:param name="class-name"/>
    <xsl:param name="indent"/>
    <xsl:value-of select="concat(cgn:indent($indent),
                          '/**&#10;',
                          cgn:indent($indent),
                          ' * Bit field variable and set of masks to determine if the appropriate data field is set&#10;',
                          cgn:indent($indent),
                          ' */&#10;',
                          cgn:indent($indent),
                          'private long ',
                          jcgn:bitfields-var-name($class-name),
                          ' = 0;&#10;')"/>
    <xsl:for-each select="cgn:field">
      <xsl:apply-templates select="." mode="this:generate-bitfield-const">
        <xsl:with-param name="pos" select="position()"/>
        <xsl:with-param name="indent" select="$indent"/>
      </xsl:apply-templates>
    </xsl:for-each>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="cgn:field" mode="this:generate-is-set">
    <xsl:param name="class-name"/>
    <xsl:param name="indent"/>
    <xsl:variable name="name" select="./@cgn:name"/>
    <xsl:variable name="bitfield-name" select="jcgn:bitfield-name($name)"/>
    <xsl:value-of select="concat(cgn:indent($indent), '/**&#10;',
                          cgn:indent($indent), ' * Returns &lt;code&gt;true&lt;/code&gt; if the value of the &quot;', @cgn:name, '&quot; field is set&#10;',
                          cgn:indent($indent), ' * &#10;',
                          cgn:indent($indent), ' * @return &lt;code&gt;true&lt;/code&gt; if the value of the &quot;', @cgn:name, '&quot; field is set&#10;',
                          cgn:indent($indent), ' */&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent),'public boolean ',
                          jcgn:create-is-set-name(./@cgn:name),
                          '() {&#10;',
                          cgn:indent($indent+1),
                          'return (this.',
                          jcgn:bitfields-var-name($class-name),
                          ' &amp; ',
                          $bitfield-name,
                          ') == ',
                          $bitfield-name,
                          ';&#10;',
                          cgn:indent($indent),
                          '}&#10;&#10;')"/>
  </xsl:template>

  
  
  <xsl:template name="jcgn:generate-imports">
    <xsl:variable name="package" select="./@cgn:package"/>
    <!-- iterate over field, extracting type -->
    <xsl:for-each select="cgn:field">
      <xsl:variable name="type" select="if (not(cgn:is-array(@cgn:type))) then @cgn:type else cgn:array-type(@cgn:type)"/>
      <!-- iterate over objects trying to find the same type -->
      <xsl:for-each select="//cgn:object[@cgn:name=$type and not(@cgn:package = $package)]">
        <xsl:value-of select="jcgn:generate-import(concat(@cgn:package, '.', @cgn:name))"/>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:variable name="builder-class-name" select="'Builder'"/>
  
  <xsl:template match="cgn:object" mode="java">
    <!-- extract necessary parameters for convenience -->
    <xsl:variable name="package" select="./@cgn:package"/>
    <xsl:variable name="builder" select="./@jcgn:builder"/>
    <xsl:variable name="parcelable" select="./@jcgn:parcelable"/>
    <xsl:variable name="read-only" select="./@cgn:read-only"/>
    <xsl:variable name="is-set" select="./@cgn:is-set"/>

    <!-- sanity checks -->
    <xsl:call-template name="cgn:test-read-only-value"/>
    <xsl:call-template name="jcgn:test-builder-value"/>
    <xsl:call-template name="jcgn:test-isset-applicable"/>
    
    <!-- name of class from 'name' attribute -->
    <xsl:variable name="class-name" select="./@cgn:name"/>
    <!-- java file name -->
    <xsl:variable name="file-name" select="cgn:create-java-file-name($package, concat($class-name, '.java'))"/>
    <xsl:message>
      <xsl:value-of select="concat('Generating class ',
                            $package,
                            '.',
                            $class-name,
                            ': ',
                            $file-name)"/>
    </xsl:message>
    <xsl:result-document href="{$file-name}" method="text">
      <!-- header -->
      <xsl:call-template name="jcgn:file-header">
        <xsl:with-param name="package" select="$package"/>
      </xsl:call-template>
      <xsl:text>&#10;</xsl:text>
      <!-- imports should be here if necessary-->
      <xsl:call-template name="jcgn:generate-imports"/>
      <xsl:text>&#10;</xsl:text>

      <!-- generate class header string like "class UserName {" -->
      <xsl:choose>
        <xsl:when test="$parcelable='true'">
          <xsl:call-template name="java-class-header">
            <xsl:with-param name="class-name" select="$class-name"/>
            <xsl:with-param name="implements-interface" select="'android.os.Parcelable'"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="java-class-header">
            <xsl:with-param name="class-name" select="$class-name"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

      <!-- generate bit fields values for different parameters -->
      <xsl:if test="$is-set='true'">
        <xsl:call-template name="this:generate-bitfields">
          <xsl:with-param name="class-name" select="$class-name"/>
          <xsl:with-param name="indent" select="1"/>
        </xsl:call-template>
      </xsl:if>


      <!-- generate fields of the class from the list of param elements, like
           "private String iDate;"
      -->
      <xsl:value-of select="concat(cgn:indent(1),
                            '/**&#10;',
                            cgn:indent(1),
                            ' * private fields &#10;',
                            cgn:indent(1),
                            ' */&#10;')"/>
      <xsl:variable name="final" select="@cgn:read-only='true'"/>
      <xsl:for-each select="cgn:field">
        <xsl:apply-templates select="." mode="jcgn:generate-field">
          <xsl:with-param name="final" select="$final"/>
        </xsl:apply-templates>
      </xsl:for-each>
      <xsl:text>&#10;</xsl:text>

      <!-- create a builder if necessary -->
      <xsl:if test="$builder='true'">
        <xsl:value-of select="concat(cgn:indent(1),
                              '/**&#10;',
                              cgn:indent(1),
                              ' * Internal Builder class for the ',
                              $class-name,
                              '&#10;',
                              cgn:indent(1),
                              ' */&#10;')"/>
        <xsl:apply-templates select="." mode="jcgn:builder">
          <xsl:with-param name="class-name" select="$class-name"/>
          <xsl:with-param name="indent" select="1"/>
          <xsl:with-param name="builder" select="$builder-class-name"/>
          <xsl:with-param name="create-func-name" select="'create'"/>
          <xsl:with-param name="attributes" select="'static '"/>
        </xsl:apply-templates>
      </xsl:if>

      <!-- if class is not read only and has no builder
           need to add an empty contstructor
      -->
      <xsl:if test="$read-only='false' and $builder='false'">
        <xsl:call-template name="java-constructor-empty">
          <xsl:with-param name="class-name" select="$class-name"/>
        </xsl:call-template>
      </xsl:if>

      <!-- if not read only or read-only and no builder - add fields constructor -->
      <xsl:if test="$read-only='false' or ($read-only='true' and $builder = 'true')">
        <xsl:call-template name="java-constructor">
          <xsl:with-param name="class-name" select="$class-name"/>
        </xsl:call-template>
      </xsl:if>
      
      <!-- if builder created, generate constructor from builder -->
      <xsl:if test="$builder = 'true'">
        <xsl:call-template name="java-constructor-from-builder">
          <xsl:with-param name="class-name" select="$class-name"/>
        </xsl:call-template>
      </xsl:if>

      <!-- if class is parcellable, generate appropriate methods -->
      <xsl:if test="$parcelable='true'">
        <xsl:apply-templates select="." mode="jcgn:parcelable">
          <xsl:with-param name="class-name" select="$class-name"/>
          <xsl:with-param name="indent" select="1"/>
        </xsl:apply-templates>
      </xsl:if>
      

      <!-- now generate a list of getters for params -->
      <xsl:value-of select="concat(cgn:indent(1),
                            '/**&#10;',
                            cgn:indent(1),
                            ' * Getters &#10;',
                            cgn:indent(1),
                            ' */&#10;&#10;')"/>
      <xsl:for-each select="cgn:field">
        <xsl:apply-templates select="." mode="jcgn:generate-getter"/>
      </xsl:for-each>

      <!-- verify if class is not read-only, generate setters -->
      <xsl:if test="$read-only='false'">
        <xsl:value-of select="concat(cgn:indent(1),
                              '/**&#10;',
                              cgn:indent(1),
                              ' * Setters &#10;',
                              cgn:indent(1),
                              ' */&#10;&#10;')"/>
        <xsl:for-each select="cgn:field">
          <xsl:choose>
            <xsl:when test="$is-set='true'">
              <xsl:apply-templates select="." mode="jcgn:generate-bitfield-setter">
                <xsl:with-param name="class-name" select="$class-name"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="." mode="jcgn:generate-setter">
                <xsl:with-param name="class-name" select="$class-name"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:if>

      <!-- generate a list of isSet functions for params -->
      <xsl:if test="$is-set='true'">
        <xsl:value-of select="concat(cgn:indent(1), '/**&#10;',
                              cgn:indent(1), ' * Set of methods determining if the field is set &#10;',
                              cgn:indent(1), ' */&#10;&#10;')"/>
        <xsl:for-each select="cgn:field">
          <xsl:apply-templates select="." mode="this:generate-is-set">
            <xsl:with-param name="class-name" select="$class-name"/>
            <xsl:with-param name="indent" select="1"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:if>
      
      <!-- closing class -->
      <xsl:call-template name="java-class-footer"/>
    </xsl:result-document>
    
  </xsl:template>

</xsl:stylesheet>
