<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java"
                xmlns:this="https://github.com/fourier/cgn/java/prep_templates">

  <xsl:template name="jcgn:preprocess-date-field">
    <!-- if not specified jcgn:date-type get from parent  -->
    <xsl:if test="(@cgn:type = 'date' or (cgn:is-array(@cgn:type) and cgn:array-type(@cgn:type) = 'date')) and not(@jcgn:date-type)" >
      <xsl:attribute name="jcgn:date-type" select="../@jcgn:date-type"/>
    </xsl:if>
  </xsl:template>

  
  <!-- preprocess jcgn:date-type attribute -->
  <!-- accepted values: case-insesitive java, joda -->
  <xsl:template name="jcgn:date-type-attribute-preprocess">
    <xsl:param name="default-value" select="$jcgn:default-date-type"/>
    <xsl:variable name="value" select="."/>
    <xsl:variable name="attribute-name" select="'jcgn:date-type'"/>
    <!-- lower case value for case-insensitive comparison -->
    <xsl:variable name="ivalue" select="lower-case($value)"/>

    <xsl:attribute name="jcgn:date-type">
      <xsl:choose>
        <xsl:when test="$ivalue = 'java' or $ivalue = 'default' or $ivalue = 'java.util.date'">
          <xsl:text>java</xsl:text>
        </xsl:when>
        <xsl:when test="$ivalue = 'joda' or $ivalue = 'org.joda.time.datetime'">
          <xsl:text>joda</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:choose>
              <xsl:when test="name(..) = 'objects'">
                <xsl:value-of select="concat('WARNING: ',
                                      $attribute-name,
                                      ' attribute value in the package ',
                                      ../@cgn:package,
                                      ' must be either default/java/java.util.Date or joda/org.joda.time.DateTime, assuming ',
                                      $default-value)"/>
              </xsl:when>
              <xsl:when test="name(..) = 'object'">
                <xsl:value-of select="concat('WARNING: ',
                                      $attribute-name,
                                      ' attribute value in the object ',
                                      ../@cgn:name,
                                      ' must be either default/java/java.util.Date or joda/org.joda.time.DateTime, assuming ',
                                      $default-value)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('WARNING: ',
                                      $attribute-name,
                                      ' attribute value in the element &quot;',
                                      name(..),
                                      '&quot; must be either default/java/java.util.Date or joda/org.joda.time.DateTime, assuming ',
                                      $default-value)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:message>
          <xsl:value-of select="$default-value"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>


  <xsl:function name="this:java-type" as="xs:string">
    <xsl:param name="extract" as="xs:boolean"/>
    <xsl:param name="type"/>
    <xsl:param name="datetype"/>
    <xsl:choose>
      <xsl:when test="not($extract)">
        <!-- do as usual -->
        <xsl:value-of select="jcgn:type-to-java-type($type, $datetype)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="jcgn:type-to-java-type-extract($type, $datetype)"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:function>


  <xsl:template name="jcgn:object-fields">
    <!-- called from cgn:object, creates the tree like
         <field name="some-name" type="[SomeClass]" java-name="iSomeName" java-type="ArrayList<SomeClass>"/>
         This child contains elements like
         <field name="some-name" type="[SomeClass]"
         java-name="iSomeName" java-type="ArrayList<SomeClass>
         java-full-type="ArrayList<com.test.SomeClass>"/>
         @name and @type are the same as in cgn:field
         @java-name is the member variable name, like iField
         @java-type is the type used in class for this field,
         like ArrayList<String>
         @java-full-type will be the FQDN class name if the type
         is an object (or array of objects).
         The difference between @java-type and @java-full-type is what the
         @java-type takes an import or package into consideration.
         The algorithm for this is the following:
         1) If the field type is declared in the same package or
         field type is unambiguous(count = 1) (since it will be imported),
         use the short name
         2) Otherwise use the FQDN
         ...
         Usage example:
         <xsl:variable name="fields">
           <xsl:call-template name="jcgn:object-fields"/>
         </xsl:variable>

         <xsl:for-each select="$fields/field">
           <xsl:message>
             <xsl:value-of select="concat('name: ', ./@name, ' type: ', ./@type, ' java-name: ', ./@java-name, ' java-type: ', ./@java-type)"/>
           </xsl:message>
         </xsl:for-each>
    -->
    <xsl:param name="type-counts">
      <xsl:call-template name="cgn:create-type-counts-xml"/>
    </xsl:param>
    
    <xsl:for-each select="cgn:field">
      <xsl:variable name="type" select="cgn:extract-type(@cgn:type)"/>
      <!-- determine if the custom type if we need to extract it or use FQDN -->
      <xsl:variable name="extract" as="xs:boolean">
        <xsl:choose>
          <xsl:when test="cgn:is-primitive-type($type)">
            <xsl:sequence select="false()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="count" select="$type-counts/fqdn[@type = $type]/@count"/>
            <xsl:sequence select="($count = 1) or cgn:type-is-in-package($type, ../@cgn:package)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:element name="field">
        <xsl:attribute name="name" select="@cgn:name"/>
        <xsl:attribute name="type" select="@cgn:type"/>
        <xsl:attribute name="java-name" select="jcgn:generate-field-name(@cgn:name)"/>
        <xsl:variable name="java-type" select="this:java-type($extract,./@cgn:type, ./@jcgn:date-type)"/>
        <xsl:variable name="java-full-type" select="this:java-type(false(),./@cgn:type, ./@jcgn:date-type)"/>
        <xsl:attribute name="java-type">
          <xsl:value-of select="$java-type"/>
        </xsl:attribute>
        <xsl:attribute name="java-full-type">
          <xsl:value-of select="$java-full-type"/>
        </xsl:attribute>
      </xsl:element>
    </xsl:for-each>

    </xsl:template>

  
  
</xsl:stylesheet>
