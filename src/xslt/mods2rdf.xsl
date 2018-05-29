<xsl:transform version="1.0"
               xmlns:dct="http://purl.org/dc/terms/"
               xmlns:foaf="http://xmlns.com/foaf/0.1/"
               xmlns:marcrel="http://id.loc.gov/vocabulary/relators/"
               xmlns:owl="http://www.w3.org/2002/07/owl#"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:rdau="http://rdaregistry.info/Elements/u/"
               xmlns:skos="http://www.w3.org/2004/02/skos/core#"
               xmlns:mods="http://www.loc.gov/mods/v3"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:variable name="proxyBaseUrl">http://uri.hab.de/instance/proxy/opac-de-23/record/</xsl:variable>

  <xsl:template match="mods:mods">
    <rdf:RDF>
      <dct:BibliographicResource rdf:about="{$proxyBaseUrl}{mods:recordInfo/mods:recordIdentifier}">
        <skos:prefLabel>
          <!-- Verfasser -->
          <xsl:if test="mods:name[mods:role/mods:roleTerm = 'aut'][mods:namePart[@type = 'family' or @type = 'given']]">
            <xsl:for-each select="mods:name[mods:role/mods:roleTerm = 'aut'][mods:namePart[@type = 'family' or @type = 'given']]">
              <xsl:if test="position() > 1">
                <xsl:text>; </xsl:text>
              </xsl:if>
              <xsl:if test="mods:namePart[@type = 'family'] and mods:namePart[@type = 'given']">
                <xsl:value-of select="mods:namePart[@type = 'family']"/>
                <xsl:text>, </xsl:text>
              </xsl:if>
              <xsl:value-of select="mods:namePart[@type = 'given']"/>
            </xsl:for-each>
            <xsl:text>: </xsl:text>
          </xsl:if>
          <!-- Titel -->
          <xsl:value-of select="mods:titleInfo[not(preceding-sibling::mods:titleInfo)]/mods:title"/>
          <xsl:text>. - </xsl:text>
          <!-- Ort und Verlage -->
          <xsl:for-each select="mods:originInfo[mods:dateIssued]/mods:place">
            <xsl:if test="position() > 1">
              <xsl:text>; </xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:for-each>
          <xsl:if test="mods:originInfo[mods:dateIssued]/mods:place and mods:originInfo[mods:dateIssued]/mods:publisher">
            <xsl:text> : </xsl:text>
          </xsl:if>
          <xsl:for-each select="mods:originInfo[mods:dateIssued]/mods:publisher">
            <xsl:if test="position() > 1">
              <xsl:text>; </xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:for-each>
          <!-- Datum -->
          <xsl:if test="mods:originInfo[mods:dateIssued]/mods:place or mods:originInfo[mods:dateIssued]/mods:publisher">
            <xsl:text>, </xsl:text>
          </xsl:if>
          <xsl:value-of select="mods:originInfo/mods:dateIssued"/>

          <!-- Signatur -->
          <xsl:if test="mods:location/mods:shelfLocator">
            <xsl:text>. - HAB Wolfenbüttel </xsl:text>
            <xsl:value-of select="mods:location/mods:shelfLocator[1]"/>
          </xsl:if>
        </skos:prefLabel>

        <xsl:apply-templates/>
      </dct:BibliographicResource>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="mods:mods/mods:titleInfo[not(preceding-sibling::mods:titleInfo)]">
    <dct:title>
      <xsl:value-of select="normalize-space(concat(mods:nonSort, ' ', mods:title))"/>
      <xsl:if test="mods:subTitle">
        <xsl:value-of select="concat(' : ', mods:subTitle)"/>
      </xsl:if>
    </dct:title>
  </xsl:template>

  <xsl:template match="mods:language/mods:languageTerm[@type = 'code'][@authority = 'iso639-2b']">
    <dct:language>
      <skos:Concept>
        <owl:sameAs rdf:resource="http://id.loc.gov/vocabulary/iso639-2/{.}"/>
        <skos:prefLabel><xsl:value-of select="."/></skos:prefLabel>
      </skos:Concept>
    </dct:language>
  </xsl:template>

  <xsl:template match="mods:subject[@authority = 'gnd']/mods:topic">
    <dct:subject>
      <skos:Concept>
        <xsl:choose>
          <xsl:when test="starts-with(@valueURI, 'http://uri.hab.de')">
            <xsl:attribute name="rdf:about"><xsl:value-of select="@valueURI"/></xsl:attribute>
          </xsl:when>
          <xsl:when test="@valueURI">
            <owl:sameAs rdf:resource="{@valueURI}"/>
          </xsl:when>
        </xsl:choose>
        <skos:prefLabel><xsl:value-of select="."/></skos:prefLabel>
      </skos:Concept>
    </dct:subject>
  </xsl:template>

  <xsl:template match="mods:classification">
    <dct:subject>
      <skos:Concept>
        <xsl:choose>
          <xsl:when test="starts-with(@valueURI, 'http://uri.hab.de')">
            <xsl:attribute name="rdf:about"><xsl:value-of select="@valueURI"/></xsl:attribute>
          </xsl:when>
          <xsl:when test="@valueURI">
            <owl:sameAs rdf:resource="{@valueURI}"/>
          </xsl:when>
        </xsl:choose>
        <skos:prefLabel><xsl:value-of select="."/></skos:prefLabel>
      </skos:Concept>
    </dct:subject>
  </xsl:template>

  <xsl:template match="mods:originInfo[mods:dateIssued]">
    <dct:issued><xsl:value-of select="mods:dateIssued"/></dct:issued>
    <xsl:if test="mods:place/mods:placeTerm[@type = 'text']">
      <rdau:P60163><xsl:value-of select="mods:place/mods:placeTerm[@type = 'text']"/></rdau:P60163>
    </xsl:if>
    <xsl:if test="mods:publisher">
      <rdau:P60547><xsl:value-of select="mods:publisher"/></rdau:P60547>
    </xsl:if>
  </xsl:template>

  <xsl:template match="mods:name[@type = 'personal'][mods:role/mods:roleTerm[@authority = 'marcrelator' and @type = 'code']]">
    <xsl:element name="marcrel:{mods:role/mods:roleTerm[@authority = 'marcrelator' and @type = 'code']}">
      <dct:Agent>
        <xsl:if test="@valueURI">
          <owl:sameAs rdf:resource="{@valueURI}"/>
        </xsl:if>
        <skos:prefLabel><xsl:value-of select="mods:displayForm"/></skos:prefLabel>
      </dct:Agent>
    </xsl:element>
  </xsl:template>

  <xsl:template match="text()"/>

</xsl:transform>
