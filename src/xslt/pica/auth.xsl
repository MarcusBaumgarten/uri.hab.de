<xsl:transform version="1.0"
               exclude-result-prefixes="rdf pica skos"
               xmlns:dct="http://purl.org/dc/terms/"
               xmlns:pica="info:srw/schema/5/picaXML-v1.0"
               xmlns:owl="http://www.w3.org/2002/07/owl#"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:skos="http://www.w3.org/2004/02/skos/core#"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="pica:record[starts-with(pica:datafield[@tag = '002@']/pica:subfield[@code = '0'], 'Tp')]">
    <rdf:RDF>
      <dct:Agent rdf:about="http://uri.hab.de/instance/proxy/opac-de-23/{pica:datafield[@tag = '003@']/pica:subfield[@code = '0']}">
        <xsl:apply-templates/>
        <xsl:call-template name="dct:Agent">
          <xsl:with-param name="nameField" select="pica:datafield[@tag = '028A']"/>
        </xsl:call-template>
      </dct:Agent>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="pica:record">
    <xsl:variable name="recordType" select="substring(pica:datafield[@tag = '002@']/pica:subfield[@code = '0'], 2, 1)"/>
    <rdf:RDF>
      <skos:Concept rdf:about="http://uri.hab.de/instance/proxy/opac-de-23/{pica:datafield[@tag = '003@']/pica:subfield[@code = '0']}"/>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="pica:datafield[@tag = '003U']">
    <owl:sameAs rdf:resource="{pica:subfield[@code = 'a']}"/>
  </xsl:template>

  <xsl:template name="dct:Agent">
    <xsl:param name="nameField"/>

    <xsl:variable name="nameValue">
      <xsl:choose>
        <xsl:when test="$nameField/pica:subfield[@code = 'P']">
          <xsl:value-of select="$nameField/pica:subfield[@code = 'P']"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$nameField/pica:subfield[@code = 'd']"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$nameField/pica:subfield[@code = 'a']"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$nameField/pica:subfield[@code = 'l']">
        <xsl:value-of select="concat(' &lt;', $nameField/pica:subfield[@code = 'l'], '&gt;')"/>
      </xsl:if>
    </xsl:variable>

    <skos:prefLabel><xsl:value-of select="normalize-space($nameValue)"/></skos:prefLabel>

  </xsl:template>

  <xsl:template match="text()"/>

</xsl:transform>
