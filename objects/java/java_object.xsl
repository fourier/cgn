<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">
  <xsl:include href="java_builder.xsl"/>
  <xsl:include href="java_parcelable.xsl"/>

  <!--xsl:template match="cgn:object" mode="builderJava"-->

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

    <!-- sanity checks -->
    <xsl:call-template name="jcgn:test-builder-value"/>
    <xsl:call-template name="cgn:test-read-only-value"/>
    
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
      <xsl:text>&#10;</xsl:text>

      <!-- generate fields of the class from the list of param elements, like
           "private String iDate;"
      -->
      <xsl:for-each select="cgn:field">
        <xsl:apply-templates select="." mode="jcgn:generate-field"/>
      </xsl:for-each>
      <xsl:text>&#10;</xsl:text>

      <!-- create a builder if necessary -->
      <xsl:if test="$builder='true'">
        <xsl:apply-templates select="." mode="jcgn:builder">
          <xsl:with-param name="class-name" select="$class-name"/>
          <xsl:with-param name="indent" select="1"/>
          <xsl:with-param name="builder" select="$builder-class-name"/>
          <xsl:with-param name="create-func-name" select="'create'"/>
          <xsl:with-param name="attributes" select="'static '"/>
        </xsl:apply-templates>
      </xsl:if>

      <!-- if class is read-only or builder defined, generate constructor -->
      <xsl:if test="$read-only='true' or $builder='true'">
        <xsl:call-template name="java-constructor">
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
      <xsl:for-each select="cgn:field">
        <xsl:apply-templates select="." mode="jcgn:generateGetter"/>
      </xsl:for-each>

      <!-- verify if class is not read-only, generate setters -->
      <xsl:if test="$read-only='false'">
        <xsl:for-each select="cgn:field">
          <xsl:apply-templates select="." mode="jcgn:generateSetter">
            <xsl:with-param name="class-name" select="$class-name"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:if>
      
      <!-- closing class -->
      <xsl:call-template name="java-class-footer"/>
    </xsl:result-document>
    
  </xsl:template>

</xsl:stylesheet>
