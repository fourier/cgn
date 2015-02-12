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
    <xsl:text>    private static final Map&lt;String, String&gt; DATE_FORMAT_REGEXPS = new HashMap&lt;String, String&gt;();
    static {
        DATE_FORMAT_REGEXPS.put("^\\d{8}$", "yyyyMMdd");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}-\\d{1,2}-\\d{4}$", "dd-MM-yyyy");
        DATE_FORMAT_REGEXPS.put("^\\d{4}-\\d{1,2}-\\d{1,2}$", "yyyy-MM-dd");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}/\\d{1,2}/\\d{4}$", "MM/dd/yyyy");
        DATE_FORMAT_REGEXPS.put("^\\d{4}/\\d{1,2}/\\d{1,2}$", "yyyy/MM/dd");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}\\s[a-z]{3}\\s\\d{4}$", "dd MMM yyyy");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}\\s[a-z]{4,}\\s\\d{4}$", "dd MMMM yyyy");
        DATE_FORMAT_REGEXPS.put("^\\d{12}$", "yyyyMMddHHmm");
        DATE_FORMAT_REGEXPS.put("^\\d{8}\\s\\d{4}$", "yyyyMMdd HHmm");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}-\\d{1,2}-\\d{4}\\s\\d{1,2}:\\d{2}$", "dd-MM-yyyy HH:mm");
        DATE_FORMAT_REGEXPS.put("^\\d{4}-\\d{1,2}-\\d{1,2}\\s\\d{1,2}:\\d{2}$", "yyyy-MM-dd HH:mm");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}/\\d{1,2}/\\d{4}\\s\\d{1,2}:\\d{2}$", "MM/dd/yyyy HH:mm");
        DATE_FORMAT_REGEXPS.put("^\\d{4}/\\d{1,2}/\\d{1,2}\\s\\d{1,2}:\\d{2}$", "yyyy/MM/dd HH:mm");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}\\s[a-z]{3}\\s\\d{4}\\s\\d{1,2}:\\d{2}$", "dd MMM yyyy HH:mm");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}\\s[a-z]{4,}\\s\\d{4}\\s\\d{1,2}:\\d{2}$", "dd MMMM yyyy HH:mm");
        DATE_FORMAT_REGEXPS.put("^\\d{14}$", "yyyyMMddHHmmss");
        DATE_FORMAT_REGEXPS.put("^\\d{8}\\s\\d{6}$", "yyyyMMdd HHmmss");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}-\\d{1,2}-\\d{4}\\s\\d{1,2}:\\d{2}:\\d{2}$", "dd-MM-yyyy HH:mm:ss");
        DATE_FORMAT_REGEXPS.put("^\\d{4}-\\d{1,2}-\\d{1,2}\\s\\d{1,2}:\\d{2}:\\d{2}$", "yyyy-MM-dd HH:mm:ss");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}/\\d{1,2}/\\d{4}\\s\\d{1,2}:\\d{2}:\\d{2}$", "MM/dd/yyyy HH:mm:ss");
        DATE_FORMAT_REGEXPS.put("^\\d{4}/\\d{1,2}/\\d{1,2}\\s\\d{1,2}:\\d{2}:\\d{2}$", "yyyy/MM/dd HH:mm:ss");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}\\s[a-z]{3}\\s\\d{4}\\s\\d{1,2}:\\d{2}:\\d{2}$", "dd MMM yyyy HH:mm:ss");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}\\s[a-z]{4,}\\s\\d{4}\\s\\d{1,2}:\\d{2}:\\d{2}$", "dd MMMM yyyy HH:mm:ss");
        DATE_FORMAT_REGEXPS.put("^\\d{4}-\\d{2}-\\d{2}t\\d{2}:\\d{2}:\\d{2}[+-]\\d{2}\\d{2}$", "yyyy-MM-dd'T'HH:mm:ssZ");
    }

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
    <xsl:param name="date-type"/>
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
      <xsl:when test="$type='date' and $date-type='java'">
        <xsl:text>parseDate(</xsl:text>
      </xsl:when>
      <xsl:when test="$type='date' and $date-type='joda'">
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


  <xsl:template match="cgn:object" mode="this:create-new-field-instance">
    <xsl:param name="object-with-field"/> <!-- FQDN object which contains this field -->
    <xsl:param name="parser-cls"/> <!-- parser class -->
    <xsl:param name="parser-var"/> <!-- parser variable -->
    <xsl:param name="field-name"/> <!-- field name we create this instance for -->
    <xsl:variable name="name" select="cgn:create-fqdn-full-type(@cgn:package, @cgn:name)"/>
    <!-- check if the field type has a json flag set -->
    <xsl:choose>
      <xsl:when test="@cgn:json = 'false'">
        <xsl:message terminate="no">
          <xsl:value-of select="concat('WARNING: while generating JSON-parser for ', $object-with-field,':')"/>
          <xsl:value-of select="concat(' the type ', $name, ' of field ', $field-name, ' doesn''t have cgn:json=true flag')"/>
        </xsl:message>
        <xsl:value-of select="'null'"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- now determine if it has setters or builder -->
        <xsl:choose>
          <xsl:when test="@cgn:read-only = 'false'">
            <xsl:value-of select="concat($parser-cls,
                                  '.parse(',
                                  $parser-var,
                                  ', new ',
                                  $name,
                                  '())')"/>
          </xsl:when>
          <xsl:when test="@jcgn:builder = 'true'">
            <xsl:value-of select="concat($parser-cls,
                                  '.parse(',
                                  $parser-var,
                                  ', new ',
                                  $name,
                                  '.Builder())')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message terminate="no">
              <xsl:value-of select="concat('WARNING: while generating JSON-parser for ', $object-with-field, ':')"/>
              <xsl:value-of select="concat(' the type ', $name, ' of field ', $field-name, ' have neither jcgn:builder=true nor cgn:read-only=false')"/>
            </xsl:message>
            <xsl:value-of select="'null'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="cgn:field" mode="this:create-new-field-instance">
    <!-- create a string like 'new MyClass()' or 'new MyClass.Builder() for the field -->
    <xsl:param name="parser-cls"/> <!-- parser class -->
    <xsl:param name="parser-var"/> <!-- parser variable -->
    <xsl:variable name="name" select="@cgn:name"/>
    <xsl:variable name="object" select="../@cgn:name"/>
    <xsl:variable name="package" select="../@cgn:package"/>
    <!-- get object's FQDN -->
    <xsl:variable name="class-name" select="cgn:extract-type-name(@cgn:type)"/>
    <xsl:variable name="class-pkg" select="cgn:extract-type-name(@cgn:type)"/>
    <!-- find object and generate new instance for it -->
    <xsl:apply-templates select="//cgn:object[@cgn:name=$class-name and @cgn:package=$class-pkg]" mode="this:create-new-field-instance">
      <xsl:with-param name="object-with-field" select="cgn:create-fqdn-full-type($package, $object)"/>
      <xsl:with-param name="field-name" select="$name"/>
      <xsl:with-param name="parser-cls" select="$parser-cls"/> 
      <xsl:with-param name="parser-var" select="$parser-var"/>
    </xsl:apply-templates>
  </xsl:template>

  
  <xsl:template name="this:create-field-parser">
    <xsl:param name="parser-var" select="'parser'"/>
    <xsl:param name="parser-class"/>
    
    <xsl:variable name="type" select="./@cgn:type"/>
    <xsl:variable name="jtype" select="./@jcgn:type-expanded"/>
    <xsl:variable name="date-type" select="./@jcgn:date-type"/>
    <xsl:choose>
      <!-- primitive type - use a table above -->
      <xsl:when test="cgn:is-primitive-type($type)">
        <xsl:value-of select="this:json-node-getter-for-type($type, $date-type, $parser-var,$parser-class)"/>
      </xsl:when>
      <!-- array - use special helper -->
      <xsl:when test="cgn:is-array($type)">
        <xsl:text>array</xsl:text>
      </xsl:when>
      <!-- object - use parser defined -->
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="this:create-new-field-instance">
          <xsl:with-param name="parser-class" select="$parser-class"/>
          <xsl:with-param name="parser-var" select="$parser-var"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  
  <xsl:template match="cgn:field[cgn:is-array(@cgn:type)]" mode="this:generate-field-parser">
    <xsl:param name="parser-class"/>
    <xsl:param name="pojo" select="cgn:create-fqdn-full-type(../@cgn:package, ../@cgn:name)"/>
    <xsl:param name="indent" select="1"/>
    <xsl:variable name="name" select="./@cgn:name"/>
    <xsl:variable name="type" select="./@cgn:type"/>
    <xsl:variable name="date-type" select="./@jcgn:date-type"/>
    <xsl:variable name="jtype" select="@jcgn:type-expanded"/>

    <xsl:variable name="array-type" select="cgn:array-type($type)"/>
    <xsl:value-of select="concat(cgn:indent($indent),
                          '/* Create the array */&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent),
                          $jtype,
                          ' array = new ',
                          $jtype,
                          '();&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent),
                          '/* Loop until the end of the array */&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent),
                          'while (parser.nextToken() != JsonToken.END_ARRAY) {&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent+1),
                          '/* We expect not null elements of correct type */&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent+1),
                          this:generate-type-assert('parser.getCurrentToken()', jcgn:array-type($jtype), concat($name,'[i]'), $pojo))"/>
    <xsl:value-of select="concat(cgn:indent($indent+1),
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
        <xsl:message terminate="yes">stop it</xsl:message>
<!--
        <xsl:apply-templates select="." mode="this:create-new-field-instance">
          <xsl:with-param name="parser-class" select="$parser-class"/>
          <xsl:with-param name="parser-var" select="$parser-var"/>
        </xsl:apply-templates>

<xsl:value-of select="this:create-new-field-instance(//cgn:object, $parser-class, 'parser', ../@cgn:package, ../@cgn:name, $array-type, $name)"/>
        -->
        </xsl:otherwise>

    </xsl:choose>
    <xsl:text>);&#10;</xsl:text>
    <xsl:value-of select="concat(cgn:indent($indent),'}&#10;')"/>

    
  </xsl:template>

  
  <xsl:template match="cgn:field" mode="jcgn:generate-pojo-parser">
    <xsl:param name="indent" select="1"/>
    <xsl:param name="pojo" select="cgn:create-fqdn-full-type(../@cgn:package, ../@cgn:name)"/>
    <xsl:param name="parser-class"/>
    <xsl:param name="instance"/>
    <xsl:variable name="name" select="./@cgn:name"/>
    <xsl:variable name="type" select="./@cgn:type"/>
    <xsl:variable name="date-type" select="./@jcgn:date-type"/>
    <xsl:variable name="jtype" select="@jcgn:type-expanded"/>
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
                          $jtype,
                          ' */ ',
                          '{&#10;')"/>
    <!-- generate assert -->
    <xsl:value-of select="concat(cgn:indent($indent+3),
                          '/* type verification, either NULL or ',
                          $jtype,
                          ' */&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent+3), this:generate-type-assert('parser.getCurrentToken()', $type, $name, $pojo))"/>
    <!-- add if !null statement -->
    <xsl:value-of select="concat(cgn:indent($indent+3),
                          '/* if not NULL try to parse */&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent+3),
                          'if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {&#10;')"/>
    <!-- generate parser -->
    <xsl:apply-templates select="." mode="this:generate-field-parser">
      <xsl:with-param name="parser-class" select="$parser-class"/>
      <xsl:with-param name="indent" select="$indent+4"/>
      <xsl:with-param name="pojo" select="$pojo"/>
    </xsl:apply-templates>
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
  </xsl:template>


  <!--
  
    public static PersonalUserData parseJson(JsonNode node, PersonalUserData.Builder builder) {
        return builder.create();
    }
    -->
  <xsl:template match="cgn:object" mode="jcgn:generate-pojo-parser">
    <!-- arguments -->
    <xsl:param name="indent" select="1"/>
    <xsl:param name="parser-class"/>
    <!-- variables -->
    <xsl:variable name="pojo" select="cgn:create-fqdn-full-type(@cgn:package, @cgn:name)"/>
    <xsl:variable name="date-type" select="./@jcgn:type"/>
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
      <xsl:apply-templates select="." mode="jcgn:generate-pojo-parser">
        <xsl:with-param name="indent" select="$indent"/>
        <xsl:with-param name="pojo" select="$pojo"/>
        <xsl:with-param name="parser-class" select="$parser-class"/>
        <xsl:with-param name="instance" select="$instance"/>
      </xsl:apply-templates>
    </xsl:for-each>
    <!-- add skip all elements if unknown array or object -->
    <xsl:choose>
      <xsl:when test="count(cgn:field) > 0">
        <xsl:value-of select="concat(cgn:indent($indent+2),
                              'else {&#10;',
                              cgn:indent($indent+3),
                              '/* unknown element. Call skipChildren() if the element is an array or object */&#10;',
                              cgn:indent($indent+3),
                              'parser.skipChildren();&#10;',
                              cgn:indent($indent+2),
                              '}&#10;')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(cgn:indent($indent+2),
                              '/* unknown element. Call skipChildren() if the element is an array or object */&#10;',
                              cgn:indent($indent+2),
                              'parser.skipChildren();&#10;')"/>
      </xsl:otherwise>
    </xsl:choose>
    

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

  
  <xsl:template name="jcgn:generate-json-parser">
    <xsl:param name="package" />
    <xsl:param name="class-name" select="'JsonParser'"/>
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
      <xsl:call-template name="this:parser-generate-imports" />

      <!-- generate class header string like "class UserName {" -->
      <xsl:call-template name="jcgn:class-header">
        <xsl:with-param name="class-name" select="$class-name"/>
      </xsl:call-template>
      <xsl:text>&#10;</xsl:text>

      <!-- if necessary, generate Java Date parser -->
      <xsl:if test="//cgn:object[@cgn:json='true']/cgn:field[@jcgn:date-type='java']">
        <xsl:call-template name="this:generate-date-parser"/>
      </xsl:if>
      
      <!-- if necessary, generate Joda DateTime parser -->
      <xsl:if test="//cgn:object[@cgn:json='true']/cgn:field[@jcgn:date-type='joda']">
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
            <xsl:apply-templates select="." mode="jcgn:generate-pojo-parser">
              <xsl:with-param name="indent" select="1"/>
              <xsl:with-param name="parser-class" select="$class-name"/>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      
      <!-- closing class -->
      <xsl:call-template name="jcgn:class-footer"/>
      
    </xsl:result-document>

    
  </xsl:template>

</xsl:stylesheet>
