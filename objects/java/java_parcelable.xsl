<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:jcgn="https://github.com/fourier/cgn/java"
                xmlns:this="https://github.com/fourier/cgn/java/parcelable">
    
  <xsl:template match="cgn:field" mode="this:parcel-reader">
    <xsl:param name="indent"/>
    <xsl:variable name="name" select="cgn:generate-field-name(./@cgn:name)"/>
    <xsl:variable name="type" select="./@cgn:type"/>
    <xsl:variable name="java-type" select="cgn:type-to-java-type(./@cgn:type, ../@jcgn:date-type)"/>
    <xsl:variable name="primitive-type-reader-map">
      <entry key="string">in.readString()</entry>
      <entry key="int">in.readInt()</entry>
      <entry key="double">in.readDouble()</entry>
      <entry key="long">in.readLong()</entry>
      <entry key="boolean">in.readByte() == 0 ? false : true</entry>
      <entry key="byte">in.readByte()</entry>
      <entry key="date">(java.util.Date)in.readSerializable()</entry>
    </xsl:variable>

    <xsl:value-of select="concat(cgn:indent($indent+1),
      'this.',
      $name,
      ' = ')"/>
    <xsl:choose>
      <!-- test if not an array -->
      <xsl:when test="not(cgn:is-array($type))">
        <xsl:choose>
          <!-- if primitive type, use the map above -->
          <xsl:when test="cgn:is-primitive-type($type)">
            <xsl:value-of select="$primitive-type-reader-map/entry[@key=$type]"/>
          </xsl:when>
          <!-- otherwise readParcelable -->
          <xsl:otherwise>
            <xsl:value-of select="concat('(',
                                  $type,
                                  ')in.readParcelable(',
                                  $type,
                                  '.class.getClassLoader())')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- if array use an appropriate readers -->
      <xsl:otherwise>
        <xsl:variable name="array-type" select="cgn:array-type($type)"/>
        <xsl:choose>
          <xsl:when test="cgn:is-primitive-type($array-type)">
            <xsl:value-of select="concat('(',
                                  $java-type,
                                  ')in.readSerializable()')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('new ',
                                  $java-type,
                                  '(); ')"/>
            <xsl:value-of select="concat(' in.readTypedList(',
                                  $name,
                                  ', ',
                                  $array-type,
                                  '.CREATOR)')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>;&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="cgn:field" mode="this:parcel-writer">
    <xsl:param name="indent"/>
    <xsl:variable name="name" select="cgn:generate-field-name(./@cgn:name)"/>
    <xsl:variable name="type" select="./@cgn:type"/>
    <xsl:variable name="java-type" select="cgn:type-to-java-type(./@cgn:type, ../@jcgn:date-type)"/>
    <xsl:variable name="primitive-type-writer-map">
      <entry key="string">out.writeString(</entry>
      <entry key="int">out.writeInt(</entry>
      <entry key="double">out.writeDouble(</entry>
      <entry key="long">out.writeLong(</entry>
      <entry key="boolean">out.writeByte((byte)(</entry>
      <entry key="byte">out.writeByte(</entry>
      <entry key="date">out.writeSerializable(</entry>
    </xsl:variable>

    <xsl:value-of select="cgn:indent($indent+1)"/>
    <xsl:choose>
      <!-- test if not an array -->
      <xsl:when test="not(cgn:is-array($type))">
        <xsl:choose>
          <!-- if primitive type, use the map above -->
          <xsl:when test="cgn:is-primitive-type($type)">
            <xsl:value-of select="$primitive-type-writer-map/entry[@key=$type]"/>
            <xsl:value-of select="$name"/>
            <xsl:if test="$type='boolean'">
              <xsl:text> ? 1 : 0)</xsl:text>
            </xsl:if>
            <xsl:text>)</xsl:text>
          </xsl:when>
          <!-- otherwise writeParcelable -->
          <xsl:otherwise>
            <xsl:value-of select="concat('out.writeParcelable(',
                                  $name,
                                  ', flags)')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- if array use an appropriate writers -->
      <xsl:otherwise>
        <xsl:variable name="array-type" select="cgn:array-type($type)"/>
        <xsl:choose>
          <xsl:when test="cgn:is-primitive-type($array-type)">
            <xsl:value-of select="concat('out.writeSerializable(',
                                  $name,
                                  ')')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('out.writeTypedList(',
                                  $name,
                                  ')')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>;&#10;</xsl:text>
  </xsl:template>

  
  <xsl:template name="this:describe-contents">
    <xsl:param name="indent"/>
    <xsl:value-of select="cgn:indent($indent)"/>
    <xsl:text>@Override&#10;</xsl:text>
    <xsl:value-of select="cgn:indent($indent)"/>
    <xsl:text>public int describeContents() {&#10;</xsl:text>
    <xsl:value-of select="cgn:indent($indent)"/>
    <xsl:text>    return 0;&#10;</xsl:text>
    <xsl:value-of select="cgn:indent($indent)"/>
    <xsl:text>}&#10;&#10;</xsl:text>
  </xsl:template>

  <xsl:template name="this:creator">
    <xsl:param name="indent"/>
    <xsl:param name="class-name"/>
    <xsl:variable name="creator" select="concat('android.os.Parcelable.Creator&lt;',
                                         $class-name,
                                         '&gt;')"/>
    <xsl:value-of select="concat(cgn:indent($indent),
                          'public static final ',
                          $creator,
                          ' CREATOR = new ',
                          $creator,
                          '() {&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent+1),
                          'public ',
                          $class-name,
                          ' createFromParcel(android.os.Parcel in) {&#10;',
                          cgn:indent($indent+2),
                          'return new ',
                          $class-name,
                          '(in);&#10;',
                          cgn:indent($indent+1),
                          '}&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent+1),
                          'public ',
                          $class-name,
                          '[] newArray(int size) {&#10;',
                          cgn:indent($indent+2),
                          'return new ',
                          $class-name,
                          '[size];&#10;',
                          cgn:indent($indent+1),
                          '}&#10;')"/>
    <xsl:value-of select="concat(cgn:indent($indent),'};&#10;&#10;')"/>

  </xsl:template>

  
  <xsl:template match="cgn:object" mode="jcgn:parcelable">
    <!-- this template shall only be called from base cgn:object template -->
    <xsl:param name="class-name" />
    <!-- supposedly call this template for inner classes -->
    <xsl:param name="indent" select="1"/>
    <xsl:value-of select="cgn:indent($indent)"/>
    <xsl:text>/*&#10;</xsl:text>
    <xsl:value-of select="cgn:indent($indent)"/>
    <xsl:text> * Implementing Parcelable interface &#10;</xsl:text>
    <xsl:value-of select="cgn:indent($indent)"/>
    <xsl:text> */&#10;</xsl:text>
    <!-- create contsructor -->
    <xsl:value-of select="concat(cgn:indent($indent),
                          'public ',
                          $class-name,
                          '(android.os.Parcel in) {&#10;')"/>
    <xsl:for-each select="cgn:field">
      <xsl:apply-templates select="." mode="this:parcel-reader">
        <xsl:with-param name="indent" select="$indent"/>
      </xsl:apply-templates>
    </xsl:for-each>

    <xsl:value-of select="concat(cgn:indent($indent),'}&#10;&#10;')"/>
    
    <!-- create writeToParcel -->
    <xsl:value-of select="cgn:indent($indent)"/>
    <xsl:text>@Override&#10;</xsl:text>
    <xsl:value-of select="concat(cgn:indent($indent),
                          'public void writeToParcel(android.os.Parcel out, int flags) {&#10;')"/>
    <xsl:for-each select="cgn:field">
      <xsl:apply-templates select="." mode="this:parcel-writer">
        <xsl:with-param name="indent" select="$indent"/>
      </xsl:apply-templates>
    </xsl:for-each>
    <xsl:value-of select="concat(cgn:indent($indent),'}&#10;&#10;')"/>

    <!-- create describeContents -->
    <xsl:call-template name="this:describe-contents">
      <xsl:with-param name="indent" select="$indent"/>
    </xsl:call-template>
    
    <!-- create CREATOR -->
    <xsl:call-template name="this:creator">
      <xsl:with-param name="indent" select="$indent"/>
      <xsl:with-param name="class-name" select="$class-name"/>
    </xsl:call-template>

    <xsl:value-of select="cgn:indent($indent)"/>
    <xsl:text>/*&#10;</xsl:text>
    <xsl:value-of select="cgn:indent($indent)"/>
    <xsl:text> * Parcelable interface implementation done &#10;</xsl:text>
    <xsl:value-of select="cgn:indent($indent)"/>
    <xsl:text> */&#10;&#10;</xsl:text>

  </xsl:template>
  
</xsl:stylesheet>
