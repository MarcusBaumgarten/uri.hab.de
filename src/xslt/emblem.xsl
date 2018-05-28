<xsl:transform version="2.0"
               exclude-result-prefixes="#all"
               xmlns:dct="http://purl.org/dc/terms/"
               xmlns:foaf="http://xmlns.com/foaf/0.1/"
               xmlns:owl="http://www.w3.org/2002/07/owl#"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="utf-8"/>

  <xsl:template match="rdf:RDF">
    <html>
      <head>
        <title><xsl:value-of select="rdf:Description/dct:title[1]"/></title>
        <style type="text/css">
          body { max-width: 60em; margin: 0 auto; font-family: "Open Sans", sans-serif; }
          table, tr, th, td { border-collapse: collapse; }
          th { text-align: left; vertical-align: top; }
          th, td { padding: 0.25em 0.5em; }
        </style>
        <link rel="schema.DCTERMS" href="http://purl.org/dc/terms/" />
        <xsl:for-each select="rdf:Description/dct:*">
          <xsl:if test="normalize-space()">
            <meta name="DCTERMS.{local-name()}" content="{normalize-space()}"/>
          </xsl:if>
          <xsl:for-each select="owl:sameAs | foaf:page | foaf:homepage">
            <link rel="DCT.{local-name(..)}" href="{@rdf:resource}"/>
          </xsl:for-each>
        </xsl:for-each>
      </head>
      <body>
        <xsl:apply-templates select="rdf:Description"/>
        <h2>Classes</h2>
        <xsl:apply-templates select="rdfs:Class"/>
        <h2>Properties</h2>
        <xsl:apply-templates select="rdfs:Property"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="rdf:Description">
    <h1><xsl:value-of select="dct:title[1]"/></h1>
    <ul>
      <xsl:for-each select="dct:creator/foaf:Person">
        <xsl:sort select="foaf:name"/>
        <li>
          <xsl:value-of select="foaf:name"/>
          <xsl:if test="foaf:mbox">
            <xsl:value-of select="concat(' &lt;', substring-after(foaf:mbox/@rdf:resource, 'mailto:'), '&gt;')"/>
          </xsl:if>
        </li>
      </xsl:for-each>
    </ul>
    <h2>See also</h2>
    <ul>
      <xsl:for-each select="dct:relation">
        <li>
          <a href="{foaf:homepage/@rdf:resource}" target="_blank">
            <xsl:value-of select="dct:title[1]"/>
          </a>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template match="rdfs:Class">
    <h3 id="{substring-after(@rdf:about, '#')}"><xsl:value-of select="rdfs:label[not(@xml:lang) or @xml:lang = 'en']"/></h3>
    <table>
      <tbody>
        <xsl:call-template name="common-properties"/>
        <xsl:if test="../rdfs:Class/rdfs:subClassOf[@rdf:resource = current()/@rdf:about]">
          <tr>
            <th>Subclasses</th>
            <td>
              <xsl:for-each select="../rdfs:Class[rdfs:subClassOf[@rdf:resource = current()/@rdf:about]]">
                <xsl:if test="position() &gt; 1">
                  <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:call-template name="uri-to-link">
                  <xsl:with-param name="target" select="@rdf:about"/>
                </xsl:call-template>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="../rdfs:Property/rdfs:domain[@rdf:resource = current()/@rdf:about]">
          <tr>
            <th>Properties</th>
            <td>
              <xsl:for-each select="../rdfs:Property[rdfs:domain[@rdf:resource = current()/@rdf:about]]">
                <xsl:if test="position() &gt; 1">
                  <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:call-template name="uri-to-link">
                  <xsl:with-param name="target" select="@rdf:about"/>
                </xsl:call-template>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="rdfs:Property">
    <h3 id="{substring-after(@rdf:about, '#')}"><xsl:value-of select="rdfs:label[not(@xml:lang) or @xml:lang = 'en']"/></h3>
    <table>
      <tbody>
        <xsl:call-template name="common-properties"/>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template name="uri-to-link">
    <xsl:param name="target" select="@rdf:resource"/>
    <xsl:choose>
      <xsl:when test="starts-with($target, 'http://uri.hab.de/ontology/emblem#')">
        <a href="#{substring-after($target, '#')}">
          <xsl:value-of select="substring-after($target, '#')"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$target}" target="_blank">
          <xsl:value-of select="$target"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="common-properties">
    <tr>
      <th>URI</th><td><xsl:value-of select="@rdf:about"/></td>
    </tr>
    <xsl:for-each select="rdfs:*[not(@xml:lang) or @xml:lang = 'en'][not(local-name() = 'label')]">
      <tr>
        <th><xsl:value-of select="local-name()"/></th>
        <td>
          <xsl:choose>
            <xsl:when test="@rdf:resource">
              <xsl:value-of select="@rdf:resource"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="normalize-space()"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>

</xsl:transform>
