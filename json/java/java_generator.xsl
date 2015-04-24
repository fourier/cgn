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
                          'public static SimpleDateFormat ISO8601_JAVA_DATE_FORMAT = new SimpleDateFormat(&quot;yyyy-MM-dd&apos;'T&apos;'HH:mm:ssZ&quot;, java.util.Locale.US);&#10;')"/>
  </xsl:template>

  <xsl:template name="this:generate-iso-date-formatter">
    <xsl:param name="indent" select="1"/>
    <xsl:value-of select="concat(cgn:indent($indent),
                          'public static org.joda.time.format.DateTimeFormatter ISO8601_JODA_DATE_FORMAT = org.joda.time.format.ISODateTimeFormat.dateTime();&#10;')"/>
  </xsl:template>


  <xsl:template match="cgn:field[cgn:is-array(@cgn:type)]" mode="this:generate-field">
    <xsl:param name="indent"/>
    <xsl:param name="gen-class"/>

    <xsl:variable name="getter-name" select="jcgn:create-getter-name(./@cgn:name)"/>
    <xsl:variable name="field-value" select="concat('object.',
                                             $getter-name,
                                             '()')"/>
    <xsl:variable name="field-type" select="@cgn:type"/>
    <xsl:variable name="field-name" select="@cgn:name"/>
    <xsl:variable name="package" select="@cgn:package"/>
    <xsl:variable name="date-type" select="@jcgn:date-type"/>

    <xsl:variable name="type" select="cgn:array-type($field-type)"/>
    <xsl:variable name="java-type" select="if (cgn:is-primitive-type($type)) then jcgn:array-to-java-type($field-type, $date-type) else cgn:create-fqdn-full-type($package, $type)"/>

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
          <xsl:when test="$date-type = 'joda'">
            <xsl:value-of select="concat(cgn:indent($indent+2),
                                  'gen.writeString(ISO8601_JODA_DATE_FORMAT.print(value));&#10;')"/>
          </xsl:when>
          <xsl:when test="$date-type = 'java'">
            <xsl:value-of select="concat(cgn:indent($indent+2),
                                  'gen.writeString(ISO8601_JAVA_DATE_FORMAT.format(value));&#10;')"/>
          </xsl:when>
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

  <xsl:template match="cgn:field[not(cgn:is-array(@cgn:type))]" mode="this:generate-field">
    <xsl:param name="indent"/>
    <xsl:param name="gen-class"/>

    <xsl:variable name="getter-name" select="jcgn:create-getter-name(./@cgn:name)"/>
    <xsl:variable name="field-value" select="concat('object.',
                                             $getter-name,
                                             '()')"/>
    <xsl:variable name="field-type" select="@cgn:type"/>
    <xsl:variable name="field-name" select="@cgn:name"/>
    <xsl:variable name="date-type" select="@jcgn:date-type"/>

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
              <xsl:when test="$date-type = 'joda'">
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
              <xsl:when test="$date-type = 'java'">
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
    <xsl:param name="package"/>
    <xsl:param name="pojo"/>
    <xsl:value-of select="concat(cgn:indent($indent),
                          'public static void generateJson(JsonGenerator gen, ',
                          $package,
                          '.',
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
  <xsl:template match="cgn:object" mode="jcgn:generate-pojo-generator">
    <xsl:param name="indent" select="1"/>
    <xsl:param name="gen-class"/>
    <xsl:variable name="pojo" select="./@cgn:name"/>
    <xsl:variable name="package" select="./@cgn:package"/>

    <!-- generate 2 args method first -->
    <xsl:call-template name="this:generate-2args-generator">
      <xsl:with-param name="indent" select="$indent"/>
      <xsl:with-param name="package" select="$package"/>
      <xsl:with-param name="pojo" select="$pojo"/>
    </xsl:call-template>
    
    <xsl:value-of select="concat(cgn:indent($indent),
                          'private static void generateJson(JsonGenerator gen, ',
                          $package,
                          '.',
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
      <xsl:variable name="jtype" select="./@jcgn:type"/>
      <xsl:variable name="getter-name" select="jcgn:create-getter-name(./@cgn:name)"/>

      <xsl:value-of select="concat('&#10;',
                            cgn:indent($indent+3),
                            '/* processing field: &quot;',
                            $name,
                            '&quot; */&#10;')"/>

      <xsl:apply-templates select="." mode="this:generate-field">
        <xsl:with-param name="indent" select="$indent+3"/>
        <xsl:with-param name="gen-class" select="$gen-class"/>
      </xsl:apply-templates>
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

 
  <xsl:template name="jcgn:generate-json-generator">
    <xsl:param name="package" />
    <xsl:param name="class-name" select="'JsonGenerator'"/>
    <xsl:param name="copyright" select="if (not(//cgn:copyright))
                                        then ($cgn:default-copyright)
                                        else (//cgn:copyright)"/>
    <xsl:param name="author" select="if (not(//cgn:author))
                                     then ($cgn:default-author)
                                     else (//cgn:author)"/>
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
        <xsl:with-param name="copyright" select="$copyright"/>
      </xsl:call-template>
      
      <!-- generate imports -->
      <xsl:call-template name="this:gen-generate-imports" />

      <!-- generate class header string like "class UserName {" -->
      <xsl:call-template name="jcgn:class-header">
        <xsl:with-param name="class-name" select="$class-name"/>
        <xsl:with-param name="author" select="$author"/>
      </xsl:call-template>
      <xsl:text>&#10;</xsl:text>

      <!-- generate static formatter for java.util.date -->
      <xsl:if test="//cgn:object[@cgn:json='true']/cgn:field[@jcgn:date-type='java']">
        <xsl:call-template name="this:generate-datetime-field">
          <xsl:with-param name="indent" select="1"/>
        </xsl:call-template>
      </xsl:if>

      <!-- if necessary, generate Joda DateTime formatter -->
      <xsl:if test="//cgn:object[@cgn:json='true']/cgn:field[@jcgn:date-type='joda']">
        <xsl:call-template name="this:generate-iso-date-formatter"/>
      </xsl:if>

      <xsl:text>&#10;</xsl:text>
      <xsl:value-of select="concat(cgn:indent(1),
                            '/**&#10;',
                            cgn:indent(1), ' * set of actual generator methods, 2 per class&#10;',
                            cgn:indent(1), ' */&#10;&#10;')"/>
      
      <!-- generate actual parsers -->
      <xsl:for-each select="//cgn:object[@cgn:json='true']">
        <xsl:apply-templates select="." mode="jcgn:generate-pojo-generator">
          <xsl:with-param name="indent" select="1"/>
          <xsl:with-param name="gen-class" select="$class-name"/>
        </xsl:apply-templates>
      </xsl:for-each>
      
      <!-- closing class -->
      <xsl:call-template name="jcgn:class-footer"/>
      
    </xsl:result-document>

    
  </xsl:template>

</xsl:stylesheet>
