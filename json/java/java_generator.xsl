<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:this="https://github.com/fourier/cgn/generator/java/this.xsl"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">

  <xsl:template name="this:gen-generate-imports">
    <xsl:text>import java.text.SimpleDateFormat;&#10;</xsl:text>
    <xsl:text>import java.util.Date;&#10;</xsl:text>
    <xsl:text>import com.fasterxml.jackson.core.JsonGenerator;&#10;</xsl:text>
    <xsl:text>import java.io.IOException;&#10;</xsl:text>
    <!-- import all objects -->
    <xsl:for-each select="//cgn:object[@cgn:json='true']">
        <xsl:value-of select="jcgn:generate-import(concat(@cgn:package, '.', @cgn:name))"/>
    </xsl:for-each>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:function name="this:java-exception">
    <xsl:param name="description"/>
    <xsl:value-of select="concat(
      'throw new IOException(&quot;',
      $description,
      '&quot;);')"/>
  </xsl:function>

  <xsl:template name="this:generate-datetime-field">
    <xsl:param name="indent" select="1"/>
    <xsl:value-of select="concat(cgn:indent($indent),
                          'private static SimpleDateFormat ISO8601_JAVA_DATE_FORMAT = new SimpleDateFormat(&quot;yyyy-MM-dd&apos;'T&apos;'HH:mm:ssZ&quot;);&#10;&#10;')"/>
  </xsl:template>

  <xsl:template name="this:generate-iso-date-formatter">
    <xsl:param name="indent" select="1"/>
    <xsl:value-of select="concat(cgn:indent($indent),
                          'private static org.joda.time.format.DateTimeFormatter ISO8601_JODA_DATE_FORMAT = org.joda.time.format.ISODateTimeFormat.dateTime();&#10;&#10;')"/>
  </xsl:template>


  <xsl:template name="this:generate-array-field">
    <xsl:param name="indent"/>
    <xsl:param name="gen-class"/>
    <xsl:param name="field-name"/>
    <xsl:param name="field-value"/>
    <xsl:param name="field-type"/>
    <xsl:param name="jtype"/>
    <xsl:variable name="type" select="cgn:array-type($field-type)"/>
    <xsl:variable name="java-type" select="jcgn:array-to-java-type($field-type, $jtype)"/>
    <xsl:value-of select="concat(cgn:indent($indent),
                          'if (',
                          $field-value,
                          ' != null) {&#10;')"/>
    
    <xsl:value-of select="concat(cgn:indent($indent+1),
                          'gen.writeArrayFieldStart(&quot;',
                          $field-name,
                          '&quot;);&#10;')"/>
    <!-- for loop -->
    <xsl:value-of select="concat(cgn:indent($indent+1),
                          'for (',
                          $java-type,
                          ' value : ',
                          $field-value,
                          ') {&#10;')"/>
    <xsl:choose>
      <xsl:when test="$type='int' or $type='long'
                      or $type='double' or $type='byte'">
        <xsl:value-of select="concat(cgn:indent($indent+2),
                              'gen.writeNumber(value.',
                              $type,
                              'Value());&#10;')"/>
      </xsl:when>
      <xsl:when test="$type='string'">
        <xsl:value-of select="concat(cgn:indent($indent+2),
                              'gen.writeString(value);&#10;')"/>
      </xsl:when>
      <xsl:when test="$type='date'">
        <!-- verify if joda time -->
        <xsl:choose>
          <xsl:when test="$jtype = 'org.joda.time.DateTime'">
            
            <xsl:value-of select="concat(cgn:indent($indent+2),
                                  'gen.writeString(ISO8601_JODA_DATE_FORMAT.print(value));&#10;')"/>
          </xsl:when>
          <xsl:when test="$jtype = 'java.util.Date'">
            <xsl:value-of select="concat(cgn:indent($indent+2),
                                  'gen.writeString(ISO8601_JAVA_DATE_FORMAT.format(value));&#10;')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message terminate="yes"><xsl:value-of select="concat('Unknown date type: ', $jtype)"/></xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="concat(cgn:indent($indent+2),
                              'generateJson(gen, value);&#10;')"/>
      </xsl:otherwise>
    </xsl:choose>
    <!-- end for loop -->
    <xsl:value-of select="concat(cgn:indent($indent+1),
                          '}&#10;')"/>
    
    <xsl:value-of select="concat(cgn:indent($indent+1),
                          'gen.writeEndArray();&#10;')"/>

    <xsl:value-of select="concat(cgn:indent($indent),
                          '}&#10;')"/>
  </xsl:template>

  <xsl:template name="this:generate-field">
    <xsl:param name="indent"/>
    <xsl:param name="gen-class"/>
    <xsl:param name="field-name"/>
    <xsl:param name="field-value"/>
    <xsl:param name="field-type"/>
    <xsl:param name="jtype"/>
    <!-- determine if field of simple type -->
    <xsl:choose>
      <xsl:when test="cgn:is-primitive-type($field-type)">
        <xsl:choose>
          <xsl:when test="$field-type='int' or $field-type='long'
                          or $field-type='double' or $field-type='byte'">
            <xsl:value-of select="concat(cgn:indent($indent),
                                  'gen.writeNumberField(&quot;',
                                  $field-name,
                                  '&quot;, ',
                                  $field-value,
                                  ');&#10;')"/>
          </xsl:when>
          <xsl:when test="$field-type='string'">
            <xsl:value-of select="concat(cgn:indent($indent),
                                  'if (',
                                  $field-value,
                                  ' != null)&#10;',
                                  cgn:indent($indent+1),
                                  'gen.writeStringField(&quot;',
                                  $field-name,
                                  '&quot;, ',
                                  $field-value,
                                  ');&#10;')"/>
          </xsl:when>
          <xsl:when test="$field-type='boolean'">
            <xsl:value-of select="concat(cgn:indent($indent),
                                  'gen.writeBooleanField(&quot;',
                                  $field-name,
                                  '&quot;, ',
                                  $field-value,
                                  ');&#10;')"/>
          </xsl:when>
          <xsl:when test="$field-type='date'">
            <!-- verify if joda time -->
            <xsl:choose>
              <xsl:when test="$jtype = 'org.joda.time.DateTime'">
                <xsl:value-of select="concat(cgn:indent($indent),
                                      'if (',
                                      $field-value,
                                      ' != null)&#10;',
                                      cgn:indent($indent+1),
                                      'gen.writeStringField(&quot;',
                                      $field-name,
                                      '&quot;, ISO8601_JODA_DATE_FORMAT.print(',
                                      $field-value,
                                      '));&#10;')"/>
              </xsl:when>
              <xsl:when test="$jtype = 'java.util.Date'">
                <xsl:value-of select="concat(cgn:indent($indent),
                                      'if (',
                                      $field-value,
                                      ' != null)&#10;',
                                      cgn:indent($indent+1),
                                      'gen.writeStringField(&quot;',
                                      $field-name,
                                      '&quot;, ISO8601_JAVA_DATE_FORMAT.format(',
                                      $field-value,
                                      '));&#10;')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:message terminate="yes"><xsl:value-of select="concat('Unknown date type: ', $jtype)"/></xsl:message>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message terminate="yes">Error: unknown type</xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- it is an object -->
      <xsl:otherwise>
        <xsl:value-of select="concat(cgn:indent($indent),
                              'if (',
                              $field-value,
                              ' != null)&#10;',
                              cgn:indent($indent+1),
                              $gen-class,
                              '.generateJson(gen, ',
                              $field-value,
                              ', &quot;',
                              $field-name,
                              '&quot;',
                              ');&#10;')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="this:generate-2args-generator">
    <xsl:param name="indent"/>
    <xsl:param name="pojo"/>
    <xsl:value-of select="concat(cgn:indent($indent),
      'public static void generateJson(JsonGenerator gen, ',
      $pojo,
      ' object) throws IOException {&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent+1),
      'generateJson(gen, object, null);&#10;',
      cgn:indent($indent),
      '}&#10;&#10;')"/>
  </xsl:template>

  <!--
  
    public static void generateJson(JsonGenerator gen, PersonalUserData object) {
        return builder.create();
    }
    -->
  <xsl:template name="cgn:generate-pojo-generator">
    <xsl:param name="indent" select="1"/>
    <xsl:param name="gen-class"/>
    <xsl:variable name="pojo" select="./@cgn:name"/>
    <xsl:variable name="jtype" select="./@jcgn:type"/>

    <!-- generate 2 args method first -->
    <xsl:call-template name="this:generate-2args-generator">
      <xsl:with-param name="indent" select="$indent"/>
      <xsl:with-param name="pojo" select="$pojo"/>
    </xsl:call-template>
    
    <xsl:value-of select="concat(cgn:indent($indent),
      'private static void generateJson(JsonGenerator gen, ',
      $pojo,
      ' object, String fieldName) throws IOException {&#10;')"/>
    <!-- actual generation -->
    <!-- try -->
    <xsl:value-of select="concat(cgn:indent($indent+1),
      'try {&#10;')"/>
    <!-- start of the object -->
    <xsl:value-of select="concat(cgn:indent($indent+2),
                          '/* start of the object */&#10;',
                          cgn:indent($indent+2),
                          'if (fieldName == null) { &#10;',
                          cgn:indent($indent+3),
                          'gen.writeStartObject();&#10;',
                          cgn:indent($indent+2),
                          '} else {&#10;',
                          cgn:indent($indent+3),
                          'gen.writeObjectFieldStart(fieldName);&#10;',
                          cgn:indent($indent+2),
                          '}&#10;&#10;')"/>
    <!-- if object is not null -->
    <xsl:value-of select="concat(cgn:indent($indent+2),
                          'if (object != null) {&#10;')"/>
    
    <!-- iterate through fields -->
    <xsl:for-each select="cgn:field">
      <xsl:variable name="name" select="./@cgn:name"/>
      <xsl:variable name="type" select="./@cgn:type"/>
      <xsl:variable name="getter-name" select="jcgn:create-getter-name(./@cgn:name)"/>

      <xsl:value-of select="concat('&#10;',
                            cgn:indent($indent+3),
                            '/* processing field: &quot;',
                            $name,
                            '&quot; */&#10;')"/>

      <!-- determine if array type -->
      <xsl:choose>
        <!-- array -->
        <xsl:when test="cgn:is-array($type)">
          <xsl:call-template name="this:generate-array-field">
            <xsl:with-param name="indent" select="$indent+3"/>
            <xsl:with-param name="gen-class" select="$gen-class"/>
            <xsl:with-param name="field-name" select="$name"/>
            <xsl:with-param name="field-value" select="concat('object.',
              $getter-name,
              '()')"/>
            <xsl:with-param name="field-type" select="$type"/>
            <xsl:with-param name="jtype" select="$jtype"/>
          </xsl:call-template>
        </xsl:when>
        <!-- not an array -->
        <xsl:otherwise>
          <xsl:call-template name="this:generate-field">
            <xsl:with-param name="indent" select="$indent+3"/>
            <xsl:with-param name="gen-class" select="$gen-class"/>
            <xsl:with-param name="field-name" select="$name"/>
            <xsl:with-param name="field-value" select="concat('object.',
              $getter-name,
              '()')"/>
            <xsl:with-param name="field-type" select="$type"/>
            <xsl:with-param name="jtype" select="$jtype"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>

    <!-- end of if object != null -->
    <xsl:value-of select="concat(cgn:indent($indent+2),
      '}&#10;')"/>
    
    <!-- end of the object -->
    <xsl:value-of select="concat('&#10; ',
                          cgn:indent($indent+2),
                          '/* end of the object */&#10;',
                          cgn:indent($indent+2),
                          'gen.writeEndObject();&#10;')"/>
    <!-- end od try -->
    <xsl:value-of select="concat(cgn:indent($indent+1),
      '} catch (IOException e) {&#10;',
      cgn:indent($indent+2),
      'throw e;&#10;',
      cgn:indent($indent+1),
      '} catch (Exception e) {&#10;',
      cgn:indent($indent+2),
      this:java-exception('Unable to generate JSON'),
      '&#10;',
      cgn:indent($indent+1),
      '}&#10;')"/>
      
    <xsl:value-of select="concat(cgn:indent($indent), '}&#10;&#10;')"/>
  </xsl:template>

 
  <xsl:template name="cgn:generate-json-generator">
    <xsl:param name="gen-package" />
    <xsl:param name="gen-class" />
    <xsl:variable name="class-name" select="$gen-class"/>
    <xsl:variable name="file-name" select="cgn:create-java-file-name($gen-package, concat($class-name, '.java'))"/>

    <xsl:message>
      <xsl:value-of select="concat('Generating class ',
                            $gen-package,
                            '.',
                            $class-name,
                            ': ',
                            $file-name)"/>
    </xsl:message>
    
    <xsl:result-document href="{$file-name}" method="text">
      <!-- header -->
      <xsl:call-template name="jcgn:file-header">
        <xsl:with-param name="package" select="$gen-package"/>
      </xsl:call-template>
      
      <!-- generate imports -->
      <xsl:call-template name="this:gen-generate-imports" />

      <!-- generate class header string like "class UserName {" -->
      <xsl:call-template name="java-class-header">
        <xsl:with-param name="class-name" select="$class-name"/>
      </xsl:call-template>
      <xsl:text>&#10;</xsl:text>

      <!-- generate static formatter for java.util.date -->
      <xsl:call-template name="this:generate-datetime-field">
        <xsl:with-param name="indent" select="1"/>
      </xsl:call-template>

      <!-- if necessary, generate Joda DateTime formatter -->
      <!-- TODO: fix this -->
      <xsl:if test="//cgn:object[@cgn:json='true' and @jcgn:date-type='org.joda.time.DateTime']">
        <xsl:call-template name="this:generate-iso-date-formatter"/>
      </xsl:if>

      
      <!-- generate actual parsers -->
      <xsl:for-each select="//cgn:object[@cgn:json='true']">
        <xsl:call-template name="cgn:generate-pojo-generator">
          <xsl:with-param name="indent" select="1"/>
          <xsl:with-param name="gen-class" select="$gen-class"/>
        </xsl:call-template>
      </xsl:for-each>
      
      <!-- closing class -->
      <xsl:call-template name="java-class-footer"/>
      
    </xsl:result-document>

    
  </xsl:template>

</xsl:stylesheet>
