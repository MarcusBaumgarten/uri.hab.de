<!-- See: https://www.loc.gov/standards/mods/mods-dcsimple.html -->
<xsl:transform version="1.0"
               exclude-result-prefixes="mods"
               xmlns:dc="http://purl.org/dc/elements/1.1/"
               xmlns:mods="http://www.loc.gov/mods/v3"
               xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="mods:mods">
    <oai_dc:dc xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
      <xsl:apply-templates/>
    </oai_dc:dc>
  </xsl:template>

  <xsl:template match="mods:mods/mods:titleInfo">
    <dc:title>
      <xsl:value-of select="normalize-space(concat(mods:nonSort, ' ', mods:title, ' ', mods:subTitle))"/>
    </dc:title>
  </xsl:template>

  <xsl:template match="mods:name[mods:role/mods:roleTerm = 'aut']">
    <dc:creator>
      <xsl:value-of select="mods:displayForm"/>
    </dc:creator>
  </xsl:template>

  <xsl:template match="mods:subject[mods:topic or mods:name or mods:occupation]">
    <dc:subject>
      <xsl:value-of select="."/>
    </dc:subject>
  </xsl:template>

  <xsl:template match="mods:genre">
    <dc:type>
      <xsl:if test="@authority">
        <xsl:value-of select="concat('(', @authority, ')')"/>
      </xsl:if>
      <xsl:value-of select="."/>
    </dc:type>
  </xsl:template>

  <xsl:template match="mods:note">
    <dc:description>
      <xsl:value-of select="."/>
    </dc:description>
  </xsl:template>

  <xsl:template match="mods:originInfo[mods:dateIssued or mods:dateCreated]">
    <dc:publisher>
      <xsl:if test="mods:place/mods:placeTerm">
        <xsl:for-each select="mods:place/mods:placeTerm">
          <xsl:if test="position() > 1">
            <xsl:text>; </xsl:text>
          </xsl:if>
          <xsl:value-of select="."/>
        </xsl:for-each>
        <xsl:text> : </xsl:text>
      </xsl:if>
      <xsl:for-each select="mods:publisher">
        <xsl:if test="position() > 1">
          <xsl:text>; </xsl:text>
        </xsl:if>
        <xsl:value-of select="."/>
      </xsl:for-each>
    </dc:publisher>
  </xsl:template>

  <xsl:template match="mods:originInfo/mods:dateIssued | mods:originInfo/mods:dateCreated">
    <dc:date>
      <xsl:value-of select="."/>
    </dc:date>
  </xsl:template>

  <xsl:template match="mods:physicalDescription | mods:extent">
    <dc:format>
      <xsl:value-of select="."/>
    </dc:format>
  </xsl:template>

  <xsl:template match="mods:identifier">
    <dc:identifier>
      <xsl:if test="@type">
        <xsl:value-of select="concat('(', @type, ')')"/>
      </xsl:if>
      <xsl:value-of select="."/>
    </dc:identifier>
  </xsl:template>

  <xsl:template match="mods:language/mods:languageTerm">
    <dc:language>
      <xsl:value-of select="."/>
    </dc:language>
  </xsl:template>

  <xsl:template match="mods:subject[mods:geographic or mods:temporal or mods:hierarchicalGeographic or mods:cartographics]">
    <dc:coverage>
      <xsl:value-of select="."/>
    </dc:coverage>
  </xsl:template>

  <xsl:template match="text()"/>

</xsl:transform>
