<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:cgn="https://github.com/fourier/cgn"
                xmlns:this="https://github.com/fourier/cgn/phase5"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:template name="this:construct-type">
    <xsl:param name="old-type"/>
    <xsl:param name="new-type"/>
    <xsl:choose>
      <xsl:when test="not(cgn:is-array($old-type))">
        <xsl:attribute name="cgn:type" select='$new-type'/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="cgn:type" select='cgn:create-array($new-type)'/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="cgn:object/cgn:field/@cgn:type" mode="cgn:phase5">
    <xsl:variable name="type" select="cgn:extract-type(.)"/>
    <xsl:choose>
      <!-- if user-defined type -->
      <xsl:when test="not(cgn:is-primitive-type($type))">
        <!-- test if it is FQDN and it is exist -->
        <xsl:choose>
          <xsl:when test="cgn:type-contains-package($type)">
            <xsl:if test="not($cgn:fqdn-objects-list[ . = $type])">
              <xsl:message>
                <xsl:value-of select="concat('WARNING: type ',
                                      $type,
                                      ' for the field &quot;',
                                      ../@cgn:name,
                                      '&quot; of the object ',
                                      ../../@cgn:package,
                                      '.',
                                      ../../@cgn:name,
                                      ' is unknown, you may experience compilation problems'
                                      )"/>
              </xsl:message>
            </xsl:if>
            <xsl:copy-of select="."/>
          </xsl:when>
          <!-- not FQDN, try to find all classes with this name -->
          <xsl:otherwise>
            <xsl:variable name="found" select="$cgn:fqdn-objects-list[ cgn:extract-type-name(.) = $type]" as="xs:string*"/>
            <!-- now try to find if such class exists at all -->
            <xsl:choose>
              <!-- not found :( -->
              <xsl:when test="count($found) = 0">
                <xsl:message>
                  <xsl:value-of select="concat('WARNING: type ',
                                        $type,
                                        ' for the field &quot;',
                                        ../@cgn:name,
                                        '&quot; of the object ',
                                        ../../@cgn:package,
                                        '.',
                                        ../../@cgn:name,
                                        ' is unknown, you may experience compilation problems'
                                        )"/>
                </xsl:message>
                <xsl:copy-of select="."/>
              </xsl:when>
              <!-- found exactly one -->
              <xsl:when test="count($found) = 1">
                <!-- construct type -->
                <xsl:call-template name="this:construct-type">
                  <xsl:with-param name="old-type" select="."/>
                  <xsl:with-param name="new-type" select="$found[1]"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="current-pkg" select="../../@cgn:package"/>
                <!-- if the number of other packages with this class more than 1-->
                <!-- find ones within the current package -->
                <xsl:variable name="current" select="$found[ cgn:extract-type-package(.) = $current-pkg ]" as="xs:string*"/>
                <xsl:choose>
                  <!-- found this type in current package, drop a warning and use it -->
                  <xsl:when test="count($current) > 0">
                    <xsl:message>
                      <xsl:value-of select="concat('WARNING: type ',
                                            $type,
                                            ' for the field &quot;',
                                            ../@cgn:name,
                                            '&quot; of the object ',
                                            ../../@cgn:package,
                                            '.',
                                            ../../@cgn:name,
                                            ' is ambiguous. Possible choices: ')"/>
                      <xsl:for-each select="$found">
                        <xsl:value-of select="concat(.,
                                              if (position() != last()) then ', ' else '')"/>
                      </xsl:for-each>
                      <xsl:value-of select="concat(
                                            '. Choosing ',
                                            $current[1],
                                            ' since it is in the same package'
                                            )"/>
                    </xsl:message>
                    <!-- construct type -->
                    <xsl:call-template name="this:construct-type">
                      <xsl:with-param name="old-type" select="."/>
                      <xsl:with-param name="new-type" select="$current[1]"/>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- when no such type in current package, just select the first one -->
                  <xsl:otherwise>
                    <xsl:message>
                      <xsl:value-of select="concat('WARNING: type ',
                                            $type,
                                            ' for the field &quot;',
                                            ../@cgn:name,
                                            '&quot; of the object ',
                                            ../../@cgn:package,
                                            '.',
                                            ../../@cgn:name,
                                            ' is ambiguous. Possible choices: ')"/>
                      <xsl:for-each select="$found">
                        <xsl:value-of select="concat(.,
                                              if (position() != last()) then ', ' else '')"/>
                      </xsl:for-each>
                      <xsl:value-of select="concat(
                                            '. Choosing the first one: ',
                                            $found[1]
                                            )"/>
                    </xsl:message>
                    <!-- construct type -->
                    <xsl:call-template name="this:construct-type">
                      <xsl:with-param name="old-type" select="."/>
                      <xsl:with-param name="new-type" select="$found[1]"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- primitive type -->
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*|node()" mode="cgn:phase5">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="cgn:phase5"/>
    </xsl:copy>
  </xsl:template>  

</xsl:stylesheet>
