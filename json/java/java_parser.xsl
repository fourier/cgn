<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:this="https://github.com/fourier/cgn/parser/java/this.xsl"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java">

  <xsl:template name="this:generate-date-parser">
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
            if (dateString.toLowerCase().matches(regexp)) {
                return DATE_FORMAT_REGEXPS.get(regexp);
            }
        }
        return null; // Unknown format.
    }

    public static Date parseDate(String dateString) throws IOException {
        String dateFormat = determineDateFormat(dateString);
        SimpleDateFormat fmt = dateFormat != null ? new SimpleDateFormat(dateFormat) : SimpleDateFormat();
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
    <xsl:text>    private static org.joda.time.DateTime parseISODate(String dateString) throws IOException {
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
    <xsl:text>import java.text.SimpleDateFormat;&#10;</xsl:text>
    <xsl:text>import java.util.Date;&#10;</xsl:text>
    <xsl:text>import com.fasterxml.jackson.core.JsonParser;&#10;</xsl:text>
    <xsl:text>import com.fasterxml.jackson.core.JsonToken;&#10;</xsl:text>
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
      <xsl:when test="$type='date' and $date-type='java.util.Date'">
        <xsl:text>parseDate(</xsl:text>
      </xsl:when>
      <xsl:when test="$type='date' and $date-type='org.joda.time.DateTime'">
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
        
  <xsl:template name="this:create-field-parser">
    <xsl:param name="parser-var" select="'parser'"/>
    <xsl:param name="parser-class"/>
    
    <xsl:variable name="type" select="./@cgn:type"/>
    <xsl:variable name="date-type" select="../@cgn:date-type"/>
    <xsl:choose>
      <!-- primitive type - use a table above -->
      <xsl:when test="cgn:is-primitive-type($type)">
        <xsl:value-of select="this:json-node-getter-for-type($type,../@jcgn:date-type, $parser-var,$parser-class)"/>
      </xsl:when>
      <!-- array - use special helper -->
      <xsl:when test="cgn:is-array($type)">
        <xsl:text>array</xsl:text>
      </xsl:when>
      <!-- object - use parser defined -->
      <xsl:otherwise>
        <xsl:value-of select="concat($parser-class,
                              '.parse(',
                              $parser-var,
                              ', new ',
                              $type,
                              '.Builder())')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  
  <!--
  
    public static PersonalUserData parseJson(JsonNode node, PersonalUserData.Builder builder) {
        return builder.create();
    }
    -->
  <xsl:template name="cgn:generate-pojo-parser">
    <xsl:param name="indent" select="1"/>
    <xsl:param name="parser-class"/>
    <xsl:variable name="pojo" select="./@cgn:name"/>
    <xsl:variable name="date-type" select="./@jcgn:date-type"/>
    <xsl:value-of select="concat(cgn:indent($indent),
      'public static ',
      $pojo,
      ' parse(JsonParser parser, ',
      $pojo,
      '.Builder builder) throws IOException {&#10;')"/>
    <!-- actual parsing -->
    <!-- object type guard -->
    <xsl:variable name="exception-string" select="concat('Json node for ',
      $pojo,
      ' is not a Json Object')"/>
    <xsl:value-of select="concat(cgn:indent($indent+1),
      'if (parser.getCurrentToken() != JsonToken.START_OBJECT) ',
      this:java-exception($exception-string),
      '&#10;&#10;')"/>
    <!-- starting the while loop -->
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
      <xsl:variable name="setter-name" select="cgn:create-setter-name(./@cgn:name)"/>
      <!-- generate if switch -->
      <xsl:value-of select="cgn:indent($indent+2)"/>
      <xsl:if test="position()!=1">
        <xsl:text>else </xsl:text>
      </xsl:if>
      <xsl:value-of select="concat(
        'if (&quot;',
        $name,
        '&quot;.equals(currentName)) {&#10;')"/>
      <!-- generate assert -->
      <xsl:value-of select="concat(cgn:indent($indent+3), this:generate-type-assert('parser.getCurrentToken()', $type, $name, $pojo))"/>
      <!-- add if !null statement -->
      <xsl:value-of select="concat(cgn:indent($indent+3),
        'if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {&#10;')"/>
      <!-- if array - special processing -->
      <xsl:if test="cgn:is-array($type)">
        <xsl:variable name="array-type" select="cgn:array-type($type)"/>
        <xsl:variable name="java-array-type" select="concat('java.util.ArrayList&lt;', jcgn:array-to-java-type($type, $date-type), '&gt;')"/>
        <xsl:value-of select="concat(cgn:indent($indent+4),
          $java-array-type,
          ' array = new ',
          $java-array-type,
          '();&#10;')"/>
        <xsl:value-of select="concat(cgn:indent($indent+4),
          'while (parser.nextToken() != JsonToken.END_ARRAY) {&#10;')"/>
        <xsl:value-of select="concat(cgn:indent($indent+5),
          this:generate-type-assert('parser.getCurrentToken()', $array-type, concat($name,'[i]'), $pojo))"/>
        <xsl:value-of select="concat(cgn:indent($indent+5),
                              'array.add(')"/>
        <xsl:choose>
          <xsl:when test="cgn:is-primitive-type($array-type)">
            <xsl:value-of select="concat(jcgn:array-to-java-type($type, $date-type),
                                  '.valueOf(',
                                  this:json-node-getter-for-type($array-type, $date-type, 'parser', $parser-class),
                                  ')')"/>
          </xsl:when>
          <xsl:otherwise> <!-- for classes -->
            <xsl:value-of select="concat($parser-class, '.parse(parser, new ',
              $array-type,
              '.Builder())')"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>);&#10;</xsl:text>
        <xsl:value-of select="concat(cgn:indent($indent+4),'}&#10;')"/>
      </xsl:if>
      <!-- call setter -->
      <xsl:value-of select="concat(cgn:indent($indent+4),
      'builder.',
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
      'parser.skipChildren();&#10;',
      cgn:indent($indent+2),
      '}&#10;')"/>

    <!-- closing the while loop -->
    <xsl:value-of select="concat(cgn:indent($indent+1),
                          '}&#10;&#10;')"/>
    
    
    <xsl:value-of select="concat(cgn:indent($indent+1), 'return builder.create();&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent), '}&#10;&#10;')"/>
  </xsl:template>


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
      ' == JsonToken.VALUE_NUMBER_FLOAT')"/></entry>
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
      <xsl:for-each select="//cgn:object[@cgn:json='true']">
        <xsl:if test="@jcgn:date-type='org.joda.time.DateTime'">
          <xsl:call-template name="this:generate-iso-date-parser"/>
        </xsl:if>
    </xsl:for-each>

      <!-- generate actual parsers -->
      <xsl:for-each select="//cgn:object[@cgn:json='true']">
        <xsl:call-template name="cgn:generate-pojo-parser">
          <xsl:with-param name="indent" select="1"/>
          <xsl:with-param name="parser-class" select="$parser-class"/>
        </xsl:call-template>
      </xsl:for-each>
      
      <!-- closing class -->
      <xsl:call-template name="java-class-footer"/>
      
    </xsl:result-document>

    
  </xsl:template>

</xsl:stylesheet>
