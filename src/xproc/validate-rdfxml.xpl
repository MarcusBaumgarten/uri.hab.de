<p:declare-step version="1.0"
                xmlns:d="http://dmaus.name/ns/xproc"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#">

  <p:documentation>
    Validiert die RDF/XML-Ddateien. Das Schema wird anhand der Klasse des ersten Individuums ausgewählt.
  </p:documentation>

  <p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>

  <p:declare-step type="d:directory-list-recursive">
    <p:option name="path" required="true"/>
    <p:output port="result" primary="true"/>

    <p:directory-list>
      <p:with-option name="path" select="$path"/>
    </p:directory-list>
    <p:viewport match="c:directory/c:directory">
      <d:directory-list-recursive>
        <p:with-option name="path" select="resolve-uri(c:directory/@name, base-uri(.))"/>
      </d:directory-list-recursive>
    </p:viewport>
  </p:declare-step>

  <d:directory-list-recursive path="../../public/"/>

  <p:for-each>
    <p:iteration-source select="//c:file[ends-with(@name, '.rdf')]"/>
    <p:variable name="filename" select="c:file/@name"/>
    <p:load>
      <p:with-option name="href" select="resolve-uri(c:file/@name, base-uri(.))"/>
    </p:load>
    <p:choose>
      <p:when test="/rdf:RDF/*[1][self::skos:ConceptScheme]">
        <cx:message>
          <p:with-option name="message" select="concat('Validating ', $filename)"/>
        </cx:message>
        <p:validate-with-relax-ng>
          <p:input port="schema">
            <p:data href="../schema/vocab.rnc" content-type="text/plain"/>
          </p:input>
        </p:validate-with-relax-ng>
      </p:when>
      <p:otherwise>
        <cx:message>
          <p:with-option name="message" select="concat('Not validating ', $filename)"/>
        </cx:message>
      </p:otherwise>
    </p:choose>
  </p:for-each>

  <p:sink/>

</p:declare-step>
