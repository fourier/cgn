<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:cgn="https://github.com/fourier/cgn">

  <!-- run this template in context of the class, so cgn:field is available -->
  <!-- creates an tree like
       <fqdn type="com.example.Class1" count="1"/>
       <fqdn type="com.example.something.Class2" count="3"/>
       <fqdn type="com.example.Class3" count="2"/>
       from the fields of the cgn:object. 
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
    
    <!-- now create the mapping between the distinct FQDN type and -->
    <!-- amount of class names equal to the class name of the FQDN type -->
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
