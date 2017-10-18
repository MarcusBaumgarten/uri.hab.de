<xsl:transform version="2.0"
               exclude-result-prefixes="#all"
               xmlns:rng="http://relaxng.org/ns/structure/1.0"
               xmlns:sch="http://purl.oclc.org/dsdl/schematron"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="rng:grammar">
    <sch:schema queryBinding="xslt">
      <xsl:sequence select="//sch:ns"/>
      <xsl:sequence select="//sch:pattern"/>
    </sch:schema>
  </xsl:template>
  
</xsl:transform>
