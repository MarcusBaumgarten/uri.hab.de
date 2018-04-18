<xsl:transform version="1.0"
               xmlns:mods="http://www.loc.gov/mods/v3"
               xmlns:pica="info:srw/schema/5/picaXML-v1.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="pica:record">
    <xsl:variable name="recordType" select="substring(pica:datafield[@tag = '002@']/pica:subfield[@code = '0'], 2, 1)"/>

    <mods:mods>
      <xsl:choose>
        <xsl:when test="pica:datafield[@tag = '021A']">
          <xsl:call-template name="mods:titleInfo">
            <xsl:with-param name="titleField" select="pica:datafield[@tag = '021A']"/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </mods:mods>
  </xsl:template>

  <xsl:template name="mods:titleInfo">
    <xsl:param name="titleField"/>

    <mods:titleInfo>
      <xsl:choose>
        <xsl:when test="contains($titleField/pica:subfield[@code = 'a'], '@')">
          <xsl:if test="substring-before($titleField/pica:subfield[@code = 'a'], '@')">
            <mods:nonSort>
              <xsl:value-of select="substring-before($titleField/pica:subfield[@code = 'a'], '@')"/>
            </mods:nonSort>
            <mods:title>
              <xsl:value-of select="substring-after($titleField/pica:subfield[@code = 'a'], '@')"/>
            </mods:title>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <mods:title>
            <xsl:value-of select="$titleField/pica:subfield[@code = 'a']"/>
          </mods:title>
        </xsl:otherwise>
      </xsl:choose>
    </mods:titleInfo>

  </xsl:template>

</xsl:transform>
