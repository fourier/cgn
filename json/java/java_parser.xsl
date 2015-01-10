<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:this="https://github.com/fourier/cgn/parser/java/this.xsl"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">

  <xsl:template name="this:generate-date-parser">
    <xsl:text>    /**
     * List of regular expressions used in parsing date/time for java.util.Date
     * time class
     */&#10;</xsl:text>
    <xsl:text>    private static final Map&lt;String, String&gt; DATE_FORMAT_REGEXPS = new HashMap&lt;String, String&gt;() {{
        put("^\\d{8}$", "yyyyMMdd");
        put("^\\d{1,2}-\\d{1,2}-\\d{4}$", "dd-MM-yyyy");
        put("^\\d{4}-\\d{1,2}-\\d{1,2}$", "yyyy-MM-dd");
        put("^\\d{1,2}/\\d{1,2}/\\d{4}$", "MM/dd/yyyy");
        put("^\\d{4}/\\d{1,2}/\\d{1,2}$", "yyyy/MM/dd");
        put("^\\d{1,2}\\s[a-z]{3}\\s\\d{4}$", "dd MMM yyyy");
        put("^\\d{1,2}\\s[a-z]{4,}\\s\\d{4}$", "dd MMMM yyyy");
        put("^\\d{12}$", "yyyyMMddHHmm");
        put("^\\d{8}\\s\\d{4}$", "yyyyMMdd HHmm");
        put("^\\d{1,2}-\\d{1,2}-\\d{4}\\s\\d{1,2}:\\d{2}$", "dd-MM-yyyy HH:mm");
        put("^\\d{4}-\\d{1,2}-\\d{1,2}\\s\\d{1,2}:\\d{2}$", "yyyy-MM-dd HH:mm");
        put("^\\d{1,2}/\\d{1,2}/\\d{4}\\s\\d{1,2}:\\d{2}$", "MM/dd/yyyy HH:mm");
        put("^\\d{4}/\\d{1,2}/\\d{1,2}\\s\\d{1,2}:\\d{2}$", "yyyy/MM/dd HH:mm");
        put("^\\d{1,2}\\s[a-z]{3}\\s\\d{4}\\s\\d{1,2}:\\d{2}$", "dd MMM yyyy HH:mm");
        put("^\\d{1,2}\\s[a-z]{4,}\\s\\d{4}\\s\\d{1,2}:\\d{2}$", "dd MMMM yyyy HH:mm");
        put("^\\d{14}$", "yyyyMMddHHmmss");
        put("^\\d{8}\\s\\d{6}$", "yyyyMMdd HHmmss");
        put("^\\d{1,2}-\\d{1,2}-\\d{4}\\s\\d{1,2}:\\d{2}:\\d{2}$", "dd-MM-yyyy HH:mm:ss");
        put("^\\d{4}-\\d{1,2}-\\d{1,2}\\s\\d{1,2}:\\d{2}:\\d{2}$", "yyyy-MM-dd HH:mm:ss");
        put("^\\d{1,2}/\\d{1,2}/\\d{4}\\s\\d{1,2}:\\d{2}:\\d{2}$", "MM/dd/yyyy HH:mm:ss");
        put("^\\d{4}/\\d{1,2}/\\d{1,2}\\s\\d{1,2}:\\d{2}:\\d{2}$", "yyyy/MM/dd HH:mm:ss");
        put("^\\d{1,2}\\s[a-z]{3}\\s\\d{4}\\s\\d{1,2}:\\d{2}:\\d{2}$", "dd MMM yyyy HH:mm:ss");
        put("^\\d{1,2}\\s[a-z]{4,}\\s\\d{4}\\s\\d{1,2}:\\d{2}:\\d{2}$", "dd MMMM yyyy HH:mm:ss");
        put("^\\d{4}-\\d{2}-\\d{2}t\\d{2}:\\d{2}:\\d{2}[+-]\\d{2}\\d{2}$", "yyyy-MM-dd'T'HH:mm:ssZ");
    }};

    /**
     * Determine SimpleDateFormat pattern matching with the given date string. Returns null if
     * format is unknown. You can simply extend DateUtil with more formats if needed.
     * @param dateString The date string to determine the SimpleDateFormat pattern for.
     * @return The matching SimpleDateFormat pattern, or null if format is unknown.
     * @see SimpleDateFormat
     */
    private static String determineDateFormat(String dateString) {
        for (String regexp : DATE_FORMAT_REGEXPS.keySet()) {
            if (dateString.toLowerCase(Locale.US).matches(regexp)) {
                return DATE_FORMAT_REGEXPS.get(regexp);
            }
        }
        return null; /* Unknown format. */
    }
    /**
     * Parses the date string to the java.util.Date class using one of
     * formats from DATE_FORMAT_REGEXPS mapping
     * @param dateString the string containing the date/time to parse
     * @return java.util.Date object with the parsed date/time
     */
    public static Date parseDate(String dateString) throws IOException {
        String dateFormat = determineDateFormat(dateString);
        final DateFormat fmt = dateFormat != null ? new SimpleDateFormat(dateFormat, Locale.US) : SimpleDateFormat.getDateTimeInstance();
        Date result = null;
        try {
            result = fmt.parse(dateString);
        } catch (ParseException e) {
            throw new IOException("Unable to parse date: ".concat(dateString));
        }
        return result;
    }&#10;&#10;</xsl:text>
  </xsl:template>

  <xsl:template name="this:generate-iso-date-parser">
    <xsl:text>    /**
     * Parses the date/time string into the Joda DateTime object.
     * @param dateString the string containing the date/time to parse
     * @return org.joda.time.DateTime object with the parsed date/time
     */&#10;</xsl:text>
    <xsl:text>    public static org.joda.time.DateTime parseISODate(String dateString) throws IOException {
        org.joda.time.DateTime date = null;
        try {
           date = org.joda.time.format.ISODateTimeFormat.dateTimeParser().parseDateTime(dateString);
        } catch (UnsupportedOperationException e) {
            throw new IOException("Unable to parse date: ".concat(dateString));
        } catch (IllegalArgumentException e) {
            throw new IOException("Unable to parse date: ".concat(dateString));
        }
        return date;
    }&#10;&#10;</xsl:text>
  </xsl:template>

  <xsl:template name="this:parser-generate-imports">
    <xsl:text>import java.text.ParseException;&#10;</xsl:text>
    <xsl:text>import java.text.DateFormat;&#10;</xsl:text>
    <xsl:text>import java.text.SimpleDateFormat;&#10;</xsl:text>
    <xsl:text>import java.util.Locale;&#10;</xsl:text>
    <xsl:text>import java.util.Date;&#10;</xsl:text>
    <xsl:text>import java.util.Map;&#10;</xsl:text>
    <xsl:text>import java.util.HashMap;&#10;</xsl:text>
    <xsl:text>import com.fasterxml.jackson.core.JsonParser;&#10;</xsl:text>
    <xsl:text>import com.fasterxml.jackson.core.JsonToken;&#10;</xsl:text>
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


  <xsl:function name="this:json-node-getter-for-type">
    <xsl:param name="type"/>
    <xsl:param name="jtype"/>
    <xsl:param name="json-node-var"/>
    <xsl:param name="parser-class"/>
    <xsl:variable name="primitive-type-to-getter">
      <entry key="string">getText()</entry>
      <entry key="int">getValueAsInt()</entry>
      <entry key="double">getValueAsDouble()</entry>
      <entry key="long">getValueAsLong()</entry>
      <entry key="boolean">getValueAsBoolean()</entry>
      <entry key="byte">getValueAsInt()</entry>
      <entry key="date">getText()</entry>
    </xsl:variable>
    <xsl:variable name="result">
    <xsl:if test="$type='byte'">
      <xsl:text>(byte)</xsl:text>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$type='date' and $jtype='java.util.Date'">
        <xsl:text>parseDate(</xsl:text>
      </xsl:when>
      <xsl:when test="$type='date' and $jtype='org.joda.time.DateTime'">
        <xsl:text>parseISODate(</xsl:text>
      </xsl:when>
    </xsl:choose>
    
    <xsl:value-of select="concat($json-node-var, '.', $primitive-type-to-getter/entry[@key=$type])"/>
    <xsl:if test="$type='date'">
      <xsl:text>)</xsl:text>
    </xsl:if>
    </xsl:variable>
    <xsl:value-of select="$result"/>
  </xsl:function>

  <xsl:function name="this:has-builder" as="xs:boolean">
    <xsl:param name="objects"/>
    <xsl:param name="package" as="xs:string"/>
    <xsl:param name="name" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$objects[@cgn:name=$name and @cgn:package=$package and @jcgn:builder='true']">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="this:has-setters" as="xs:boolean">
    <xsl:param name="objects"/>
    <xsl:param name="package" as="xs:string"/>
    <xsl:param name="name" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$objects[@cgn:name=$name and @cgn:package=$package and @cgn:read-only='false']">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="this:has-json" as="xs:boolean">
    <xsl:param name="objects"/>
    <xsl:param name="package" as="xs:string"/>
    <xsl:param name="name" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$objects[@cgn:name=$name and @cgn:package=$package and @cgn:json='true']">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="this:create-new-field-instance" as="xs:string">
    <!-- create a string like 'new MyClass()' or 'new MyClass.Builder() for the field -->
    <xsl:param name="objects" />   <!-- all objects -->
    <xsl:param name="parser-cls"/> <!-- parser class -->
    <xsl:param name="parser-var"/> <!-- parser variable -->
    <xsl:param name="package"/>    <!-- parent package -->
    <xsl:param name="object"/>     <!-- parent object type -->
    <xsl:param name="field-type"/> <!-- field type -->
    <xsl:param name="field-name"/> <!-- field name -->
    <!-- get object's FQDN -->
    <xsl:variable name="class-name" select="if (cgn:type-contains-package($field-type)) then cgn:extract-type-name($field-type) else $field-type"/>
    <xsl:variable name="class-pkg" select="if (cgn:type-contains-package($field-type)) then cgn:extract-type-package($field-type) else $package"/>
    <!-- check if the field type has a json flag set -->
    <xsl:choose>
      <xsl:when test="not(this:has-json($objects, $class-pkg, $class-name))">
        <xsl:message terminate="no">
          <xsl:value-of select="concat('WARNING: while generating JSON-parser for ', $package, '.', $object,':')"/>
          <xsl:value-of select="concat(' the type ', $class-pkg, '.', $class-name, ' of field ', $field-name, ' doesn''t have cgn:json=true flag')"/>
        </xsl:message>
        <xsl:value-of select="'null'"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- now determine if it has setters or builder -->
        <xsl:choose>
          <xsl:when test="this:has-setters($objects, $class-pkg, $class-name)">
            <xsl:value-of select="concat($parser-cls,
                                  '.parse(',
                                  $parser-var,
                                  ', new ',
                                  $class-pkg,
                                  '.',
                                  $class-name,
                                  '())')"/>
          </xsl:when>
          <xsl:when test="this:has-builder($objects, $class-pkg, $class-name)">
            <xsl:value-of select="concat($parser-cls,
                                  '.parse(',
                                  $parser-var,
                                  ', new ',
                                  $class-pkg,
                                  '.',
                                  $class-name,
                                  '.Builder())')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message terminate="no">
              <xsl:value-of select="concat('WARNING: while generating JSON-parser for ', $package, '.', $object,':')"/>
              <xsl:value-of select="concat(' the type ', $class-pkg, '.', $class-name, ' of field ', $field-name, ' have neither jcgn:builder=true nor cgn:read-only=false')"/>
            </xsl:message>
            <xsl:value-of select="'null'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  
  <xsl:template name="this:create-field-parser">
    <xsl:param name="parser-var" select="'parser'"/>
    <xsl:param name="parser-class"/>
    
    <xsl:variable name="type" select="./@cgn:type"/>
    <xsl:variable name="jtype" select="./@jcgn:type"/>
    <xsl:choose>
      <!-- primitive type - use a table above -->
      <xsl:when test="cgn:is-primitive-type($type)">
        <xsl:value-of select="this:json-node-getter-for-type($type,./@jcgn:type, $parser-var,$parser-class)"/>
      </xsl:when>
      <!-- array - use special helper -->
      <xsl:when test="cgn:is-array($type)">
        <xsl:text>array</xsl:text>
      </xsl:when>
      <!-- object - use parser defined -->
      <xsl:otherwise>
        <xsl:value-of select="this:create-new-field-instance(//cgn:object, $parser-class, $parser-var, ../@cgn:package, ../@cgn:name, $type, @cgn:name)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  
  <!--
  
    public static PersonalUserData parseJson(JsonNode node, PersonalUserData.Builder builder) {
        return builder.create();
    }
    -->
  <xsl:template name="jcgn:generate-pojo-parser">
    <xsl:param name="indent" select="1"/>
    <xsl:param name="parser-class"/>
    <xsl:variable name="pojo" select="concat(./@cgn:package, '.', ./@cgn:name)"/>
    <xsl:variable name="jtype" select="./@jcgn:type"/>
    <xsl:variable name="instance" select="if (@cgn:read-only='false') then cgn:camelize-string(./@cgn:name) else 'builder'"/>
    <xsl:value-of select="concat(cgn:indent($indent),
                          'public static ',
                          $pojo,
                          ' parse(JsonParser parser, ',
                          $pojo,
                          if (@cgn:read-only = 'false') then concat(' ', $instance) else '.Builder builder',
                          ') throws IOException {&#10;')"/>
    <!-- actual parsing -->
    <!-- object type guard -->
    <xsl:variable name="exception-string" select="concat('Json node for ',
      $pojo,
      ' is not a Json Object')"/>
    <xsl:value-of select="concat(cgn:indent($indent+1),
      '/* object should start with the START_OBJECT token */&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent+1),
      'if (parser.getCurrentToken() != JsonToken.START_OBJECT) ',
      this:java-exception($exception-string),
      '&#10;&#10;')"/>
    <!-- starting the while loop -->
    <xsl:value-of select="concat(cgn:indent($indent+1),
      '/* loop through all fields of the object */&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent+1),
      'while(parser.nextValue() != JsonToken.END_OBJECT) {&#10;')"/>
    <!-- has token guard -->
    <xsl:value-of select="concat(cgn:indent($indent+2),
                          'if (!parser.hasCurrentToken()) ',
      this:java-exception('Malformed JSON'),
      '&#10;')"/>

    <!-- get the current key -->
    <xsl:value-of select="concat(cgn:indent($indent+2),
                          'final String currentName = parser.getCurrentName();&#10;&#10;')"/>
    <!-- iterate through fields -->
    <xsl:for-each select="cgn:field">
      <xsl:variable name="name" select="./@cgn:name"/>
      <xsl:variable name="type" select="./@cgn:type"/>
      <xsl:variable name="jtype" select="./@jcgn:type"/>
      <xsl:variable name="setter-name" select="jcgn:create-setter-name(./@cgn:name)"/>
      <!-- generate if switch -->
      <xsl:value-of select="cgn:indent($indent+2)"/>
      <xsl:if test="position()!=1">
        <xsl:text>else </xsl:text>
      </xsl:if>
      <xsl:value-of select="concat(
        'if (&quot;',
        $name,
        '&quot;.equals(currentName)) ',
        '/* parse &quot;',
        $name,
        '&quot; of type ',
        cgn:type-to-java-type($type, $jtype),
        ' */ ',
        '{&#10;')"/>
      <!-- generate assert -->
      <xsl:value-of select="concat(cgn:indent($indent+3),
                            '/* type verification, either NULL or ',
                            this:type-to-json-type($type),
                            ' */&#10;')"/>
      <xsl:value-of select="concat(cgn:indent($indent+3), this:generate-type-assert('parser.getCurrentToken()', $type, $name, $pojo))"/>
      <!-- add if !null statement -->
      <xsl:value-of select="concat(cgn:indent($indent+3),
                            '/* if not NULL try to parse */&#10;')"/>
      <xsl:value-of select="concat(cgn:indent($indent+3),
        'if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {&#10;')"/>
      <!-- if array - special processing -->
      <xsl:if test="cgn:is-array($type)">
        <xsl:variable name="array-type" select="cgn:array-type($type)"/>
        <xsl:variable name="java-array-type" select="concat('java.util.ArrayList&lt;',
                                                     if (cgn:is-primitive-type($array-type)) then jcgn:array-to-java-type($type, $jtype) else cgn:create-fqdn-full-type(../@cgn:package, $array-type),
                                                     '&gt;')"/>
        <xsl:value-of select="concat(cgn:indent($indent+4),
                              '/* Create the array */&#10;')"/>
        <xsl:value-of select="concat(cgn:indent($indent+4),
          $java-array-type,
          ' array = new ',
          $java-array-type,
          '();&#10;')"/>
        <xsl:value-of select="concat(cgn:indent($indent+4),
                              '/* Loop until the end of the array */&#10;')"/>
        <xsl:value-of select="concat(cgn:indent($indent+4),
          'while (parser.nextToken() != JsonToken.END_ARRAY) {&#10;')"/>
        <xsl:value-of select="concat(cgn:indent($indent+5),
                              '/* We expect not null elements of correct type */&#10;')"/>
        <xsl:value-of select="concat(cgn:indent($indent+5),
          this:generate-type-assert('parser.getCurrentToken()', $array-type, concat($name,'[i]'), $pojo))"/>
        <xsl:value-of select="concat(cgn:indent($indent+5),
                              'array.add(')"/>
        <xsl:choose>
          <xsl:when test="cgn:is-primitive-type($array-type)">
            <xsl:choose>
              <xsl:when test="($array-type = 'string') or ($array-type = 'date')">
                <xsl:value-of select="this:json-node-getter-for-type($array-type, $jtype, 'parser', $parser-class)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat(jcgn:array-to-java-type($type, $jtype),
                                      '.valueOf(',
                                      this:json-node-getter-for-type($array-type, $jtype, 'parser', $parser-class),
                                      ')')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise> <!-- for classes -->
            <xsl:value-of select="this:create-new-field-instance(//cgn:object, $parser-class, 'parser', ../@cgn:package, ../@cgn:name, $array-type, $name)"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>);&#10;</xsl:text>
        <xsl:value-of select="concat(cgn:indent($indent+4),'}&#10;')"/>
      </xsl:if>
      <!-- call setter -->
      <xsl:value-of select="concat(cgn:indent($indent+4),
        '/* call the setter and set field value */&#10;')"/>
      <xsl:value-of select="concat(cgn:indent($indent+4),
                            $instance,
                            '.',
                            $setter-name,
                            '(')"/>
      <!-- value for setter -->
      <xsl:call-template name="this:create-field-parser">
        <xsl:with-param name="parser-var" select="'parser'"/>
        <xsl:with-param name="parser-class" select="$parser-class"/>
      </xsl:call-template>
      <!-- close setter call -->
      <xsl:text>);&#10;</xsl:text>
      <!-- closing if statement -->
      <xsl:value-of select="concat(cgn:indent($indent+3),'}&#10;')"/>
      <!-- closing if statement -->
      <xsl:value-of select="concat(cgn:indent($indent+2),'}&#10;')"/>

    </xsl:for-each>
    <!-- add skip all elements if unknown array or object -->
    <xsl:value-of select="concat(cgn:indent($indent+2),
      'else {&#10;',
      cgn:indent($indent+3),
      '/* unknown element. Call skipChildren() if the element is an array or object */&#10;',
      cgn:indent($indent+3),
      'parser.skipChildren();&#10;',
      cgn:indent($indent+2),
      '}&#10;')"/>

    <!-- closing the while loop -->
    <xsl:value-of select="concat(cgn:indent($indent+1),
                          '}&#10;&#10;')"/>
    
    
    <xsl:value-of select="concat(cgn:indent($indent+1),
                          'return ',
                          if (@cgn:read-only='false') then $instance else 'builder.create()',
                          ';&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent), '}&#10;&#10;')"/>
  </xsl:template>

  <xsl:function name="this:type-to-json-type">
    <xsl:param name="type"/>
    <xsl:variable name="type-to-predicate-map">
      <entry key="string">JsonToken.VALUE_STRING</entry>
      <entry key="date">JsonToken.VALUE_STRING</entry>
      <entry key="int">JsonToken.VALUE_NUMBER_INT</entry>
      <entry key="double">JsonToken.VALUE_NUMBER_FLOAT || JsonToken.VALUE_NUMBER_INT</entry>
      <entry key="long">JsonToken.VALUE_NUMBER_INT</entry>
      <entry key="boolean">JsonToken.VALUE_FALSE || JsonToken.VALUE_TRUE</entry>
      <entry key="byte">JsonToken.VALUE_NUMBER_INT</entry>
    </xsl:variable>
    <xsl:variable name="statement">
    <xsl:choose>
      <xsl:when test="cgn:is-primitive-type($type)">
        <xsl:value-of select="$type-to-predicate-map/entry[@key=$type]"/>
      </xsl:when>
      <xsl:when test="cgn:is-array($type)">
        <xsl:value-of select="'JsonToken.START_ARRAY'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'JsonToken.START_OBJECT'"/>
      </xsl:otherwise>
    </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$statement"/>
  </xsl:function>
    

  <xsl:function name="this:type-to-predicate">
    <xsl:param name="type"/>
    <xsl:param name="token-var"/>
    <xsl:variable name="type-to-predicate-map">
      <entry key="string"><xsl:value-of select="concat($token-var,
      ' == JsonToken.VALUE_STRING')"/>
      </entry>
      <entry key="date"><xsl:value-of select="concat($token-var,
      ' == JsonToken.VALUE_STRING')"/>
      </entry>
      
      <entry key="int"><xsl:value-of select="concat($token-var,
      ' == JsonToken.VALUE_NUMBER_INT')"/></entry>
      <entry key="double"><xsl:value-of select="concat($token-var,
      ' == JsonToken.VALUE_NUMBER_FLOAT || ',
      $token-var,
      ' == JsonToken.VALUE_NUMBER_INT')"/></entry>
      <entry key="long"><xsl:value-of select="concat($token-var,
      ' == JsonToken.VALUE_NUMBER_INT')"/></entry>
      <entry key="boolean"><xsl:value-of select="concat($token-var,
      ' == JsonToken.VALUE_FALSE || ',
      $token-var,
      ' == JsonToken.VALUE_TRUE')"/></entry>
      <entry key="byte"><xsl:value-of select="concat($token-var,
      ' == JsonToken.VALUE_NUMBER_INT')"/></entry>
    </xsl:variable>
    <xsl:variable name="statement">
    <xsl:choose>
      <xsl:when test="cgn:is-primitive-type($type)">
        <xsl:value-of select="$type-to-predicate-map/entry[@key=$type]"/>
      </xsl:when>
      <xsl:when test="cgn:is-array($type)">
        <xsl:value-of select="concat($token-var, ' == JsonToken.START_ARRAY')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($token-var, ' == JsonToken.START_OBJECT')"/>
      </xsl:otherwise>
    </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="concat($statement,
                          ' || ',
                          $token-var,
                          ' == JsonToken.VALUE_NULL')"/>
  </xsl:function>
    

  
  <xsl:function name="this:generate-type-assert">
    <xsl:param name="node-var"/>
    <xsl:param name="type"/>
    <xsl:param name="name"/>
    <xsl:param name="pojo"/>
    <xsl:variable name="exception-string" select="concat('Json node for ',
                                                  $pojo,
                                                  '::',
                                                  $name,
                                                  ' is not of type ',
                                                  $type)"/>
    <xsl:value-of select="concat('if (!(',
                          this:type-to-predicate($type, $node-var),
                          ')) ',
                          this:java-exception($exception-string),
                          '&#10;')"/>
  </xsl:function>

  
  <xsl:template name="cgn:generate-json-parser">
    <xsl:param name="parser-package" />
    <xsl:param name="parser-class" />
    <xsl:param name="copyright" select="$cgn:default-copyright"/>
    <xsl:variable name="class-name" select="$parser-class"/>
    <xsl:variable name="file-name" select="cgn:create-java-file-name($parser-package, concat($class-name, '.java'))"/>

    <xsl:message>
      <xsl:value-of select="concat('Generating class ',
                            $parser-package,
                            '.',
                            $class-name,
                            ': ',
                            $file-name)"/>
    </xsl:message>
    
    <xsl:result-document href="{$file-name}" method="text">
      <!-- header -->
      <xsl:call-template name="jcgn:file-header">
        <xsl:with-param name="package" select="$parser-package"/>
        <xsl:with-param name="copyright" select="$copyright"/>
      </xsl:call-template>
      
      <!-- generate imports -->
      <xsl:call-template name="this:parser-generate-imports" />

      <!-- generate class header string like "class UserName {" -->
      <xsl:call-template name="java-class-header">
        <xsl:with-param name="class-name" select="$class-name"/>
      </xsl:call-template>
      <xsl:text>&#10;</xsl:text>

      <!-- generate static method for date parsing -->
      <xsl:call-template name="this:generate-date-parser"/>

      <!-- if necessary, generate Joda DateTime parser -->
      <xsl:if test="//cgn:object[@cgn:json='true']/cgn:field[@jcgn:type='org.joda.time.DateTime']">
        <xsl:call-template name="this:generate-iso-date-parser"/>
      </xsl:if>

      
      <!-- generate actual parsers -->
      <xsl:for-each select="//cgn:object[@cgn:json='true']">
        <xsl:choose>
          <!-- only generate parsers when for not read-only or classes with builder -->
          <xsl:when test="@jcgn:builder = 'false' and @cgn:read-only='true'">
            <xsl:message><xsl:value-of select="concat('WARNING: ', @cgn:package,
            '.',
            @cgn:name,
            ' have no builder set and read-only, skipping JSON parser generation')"/></xsl:message>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="jcgn:generate-pojo-parser">
              <xsl:with-param name="indent" select="1"/>
              <xsl:with-param name="parser-class" select="$parser-class"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      
      <!-- closing class -->
      <xsl:call-template name="java-class-footer"/>
      
    </xsl:result-document>

    
  </xsl:template>

</xsl:stylesheet>
