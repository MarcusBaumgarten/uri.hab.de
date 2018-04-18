<xsl:transform version="1.0"
               exclude-result-prefixes="rdf pica skos"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:pica="info:srw/schema/5/picaXML-v1.0"
               xmlns:skos="http://www.w3.org/2004/02/skos/core#"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="pica:record">
    <xsl:variable name="recordType" select="substring(pica:datafield[@tag = '002@']/pica:subfield[@code = '0'], 2, 1)"/>
    <rdf:RDF>
      <skos:Concept rdf:about="http://uri.hab.de/instance/proxy/opac-de-23/{pica:datafield[@tag = '003@']/pica:subfield[@code = '0']}">
        <xsl:choose>
          <xsl:when test="$recordType = 's'">
            <skos:prefLabel>
              <xsl:value-of select="translate(pica:datafield[@tag = '041A']/pica:subfield[@code = 'a'], '@', '')"/>
            </skos:prefLabel>
          </xsl:when>
        </xsl:choose>
      </skos:Concept>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="text()"/>

</xsl:transform>
