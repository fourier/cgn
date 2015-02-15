<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:cgn="https://github.com/fourier/cgn">


  <xsl:template name="cgn:preprocess-undeclared-type-field">
    <xsl:if test="not(@cgn:type)">
      <xsl:attribute name="cgn:type" select="'string'"/>
    </xsl:if>
  </xsl:template>

  <!-- preprocess boolean attribute -->
  <!-- accepted values: case-insesitive true, false, yes, no -->
  <xsl:template name="cgn:boolean-attribute-preprocess">

    <xsl:param name="attribute-name"/>
    <xsl:param name="attribute-namespace"/>
    <xsl:param name="default-value"/>
    <xsl:variable name="value" select="."/>
    <!-- lower case value for case-insensitive comparison -->
    <xsl:variable name="ivalue" select="lower-case($value)"/>
    <xsl:attribute name="{$attribute-name}" namespace="{$attribute-namespace}">
      <xsl:choose>
        <xsl:when test="$ivalue = 'true' or $ivalue = 'yes'">
          <xsl:text>true</xsl:text>
        </xsl:when>
        <xsl:when test="$ivalue = 'false' or $ivalue = 'no'">
          <xsl:text>false</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:choose>
              <xsl:when test="name(..) = 'objects'">
                <xsl:value-of select="concat('WARNING: ',
                                      $attribute-name,
                                      ' attribute value in the package ',
                                      ../@cgn:package,
                                      ' must be either false/no or true/yes, assuming ',
                                      $default-value)"/>
              </xsl:when>
              <xsl:when test="name(..) = 'object'">
                <xsl:value-of select="concat('WARNING: ',
                                      $attribute-name,
                                      ' attribute value in the object ',
                                      ../@cgn:name,
                                      ' must be either false/no or true/yes, assuming ',
                                      $default-value)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('WARNING: ',
                                      $attribute-name,
                                      ' attribute value in the element &quot;',
                                      name(..),
                                      '&quot; must be either false/no or true/yes, assuming ',
                                      $default-value)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:message>
          <xsl:value-of select="$default-value"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!-- run this template in context of the class, so cgn:field is available -->
  <!-- creates an tree like
       <fqdn type="com.example.Class1" count="1"/>
       <fqdn type="com.example.something.Class2" count="3"/>
       <fqdn type="com.example.Class3" count="2"/>
       from the fields of the cgn:object.
       This template extracts all FQDN names used in object as field types
       and caclulates the number of FQDN names with the same short name.
       For normal FQDN names the number will be 1.
       When the object contains fields with the different FQDN but the
       same short type name(class name), the number will be > 1
       depending on number of short name clashes.
       Used to determine the amount of possible name clashes.
       Usage example:

       <xsl:variable name="type-counts">
       <xsl:call-template name="cgn:create-type-counts-xml"/>
       </xsl:variable>

       <xsl:for-each select="cgn:field">
       <xsl:variable name="type" select="cgn:extract-type(@cgn:type)"/>
       <xsl:if test="not(cgn:is-primitive-type($type))">
       <xsl:message>
       <xsl:value-of select="concat('Type: ',
       $type,
       ' count: ',
       $type-counts/fqdn[@type = $type]/@count)"/>
       </xsl:message>
       </xsl:if>
       </xsl:for-each>
  -->
  <xsl:template name="cgn:create-type-counts-xml">
    <!-- first, extract all distinct FQDN-types of fields -->
    <xsl:variable name="types" select="distinct-values(cgn:field[ not(cgn:is-primitive-type(cgn:extract-type(@cgn:type)))]/cgn:extract-type(@cgn:type))" as="xs:string*"/>

    <!-- for each distinct FQDN-name extract the class name -->
    <xsl:variable name="short-types" as="xs:string*">
      <xsl:for-each select="$types">
        <xsl:sequence select="cgn:extract-type-name(.)"/>          
      </xsl:for-each>
    </xsl:variable>
    
    <!-- now create the mapping between the distinct FQDN type and 
         amount of class names equal to the class name of the FQDN type
    -->
    <xsl:for-each select="$types">
      <xsl:variable name="short-type" select="cgn:extract-type-name(.)"/>
      <xsl:variable name="same" select="$short-types[. = $short-type]" as="xs:string*"/>

      <xsl:element name="fqdn">
        <xsl:attribute name="type" select="."/>
        <xsl:attribute name="count" select="count($same)"/>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>



</xsl:stylesheet>
