<?php

require_once __DIR__ . '/../../../../../vendor/autoload.php';

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\RedirectResponse;

use Negotiation\Negotiator;

use HAB\Pica\Record\Record;
use HAB\Pica\Reader\PicaNormReader;
use HAB\Pica\Writer\PicaXmlWriter;

HAB\Pica\Record\Subfield::$validSubfieldCodePattern = '/^.$/Di';

define('PSI_TEMPLATE', 'http://opac.lbs-braunschweig.gbv.de/DB=2/PLAIN=Y/CHARSET=UTF8/PLAINTTLCHARSET=UTF8/PPN?PPN=%s');
define('PICA_TEMPLATE', 'http://uri.hab.de/instance/proxy/opac-de-23/record/%s.xml');
define('MODS_TEMPLATE', 'http://uri.hab.de/instance/proxy/opac-de-23/record/%s.mods');
define('RDF_TEMPLATE', 'http://uri.hab.de/instance/proxy/opac-de-23/record/%s.rdf');

function terminate (Request $request, Response $response) {
    $response->prepare($request);
    $response->send();
    exit();
}

function load ($ident) {
    $context = stream_context_create(['http' => ['timeout' => 0.5]]);
    $content = @file_get_contents(sprintf(PSI_TEMPLATE, $ident), false, $context);
    if ($content) {
        $content = normalizer_normalize($content);
    } else {
        $context = <<<CONTENT
<record xmlns="info:srw/schema/5/picaXML-v1.0">
  <field tag="003@">
    <subfield code="0">$ident</subfield>
  </field>
</record>
CONTENT;
    }
    $reader = new PicaNormReader();
    $reader->open($content);
    return $reader->read();
}

function transform ($sourceUri, $templateUri) {
    $source = new DOMDocument();
    if (@$source->load($sourceUri) === false) {
        return false;
    }
    $xslt = new DOMDocument();
    if (@$xslt->load($templateUri, LIBXML_NOENT) === false ) {
        return false;
    }
    $proc = new XSLTProcessor();
    if (@$proc->importStylesheet($xslt) === false) {
        return false;
    }
    $result = $proc->transformToDoc($source);
    return $result->saveXml($result->documentElement);
}

$request = Request::createFromGlobals();

$route = basename($request->server->get('REQUEST_URI'));


if (preg_match('@^(?<ident>[0-9]+[0-9X])(?<format>\.[a-z]+)?$@', $route, $match)) {
    if (!array_key_exists('format', $match)) {
        $response = new RedirectResponse(sprintf(RDF_TEMPLATE, $match['ident']), 303);
        terminate($request, $response);
    }
} else {
    $response = new Response('<h1>400 Bad Request</h1>', 400, array('Content-Type' => 'text/html'));
    terminate($request, $response);
}

list($ident, $format) = explode('.', $route);

$record = load($ident);

if (!$record) {
    $response = new Response('<h1>404 Not Found</h1>', 404, array('Content-Type' => 'text/html'));
    terminate($request, $response);
}

switch ($format) {
    case 'xml':
        $writer = new PicaXmlWriter();
        $content = $writer->write($record);
        $response = new Response($content, 200, array('Content-Type' => 'application/xml'));
        break;
    case 'mods':
        $type = (string)$record->getFirstMatchingField('002@/00')->getNthSubfield(0, '0');
        if ($type[0] === 'T') {
            $response = new Response('<h1>406 Not Acceptable</h1>', 406, array('Content-Type' => 'text/html'));
        } else {
            $templateUri = __DIR__ . '/../../../../../src/xslt/pica/mods.xsl';
            $sourceUri = sprintf(PICA_TEMPLATE, $ident);
            $content = transform($sourceUri, $templateUri);
            if ($content) {
                $response = new Response($content, 200, array('Content-Type' => 'application/xml'));
                break;
            }
        }
        $response = new Response('<h1>406 Not Acceptable</h1>', 406, array('Content-Type' => 'text/html'));
        break;
    case 'dc':
        $type = (string)$record->getFirstMatchingField('002@/00')->getNthSubfield(0, '0');
        if ($type[0] === 'T') {
            $response = new Response('<h1>406 Not Acceptable</h1>', 406, array('Content-Type' => 'text/html'));
        } else {
            $templateUri = __DIR__ . '/../../../../../src/xslt/mods2dc.xsl';
            $sourceUri = sprintf(MODS_TEMPLATE, $ident);
            $content = transform($sourceUri, $templateUri);
            if ($content) {
                $response = new Response($content, 200, array('Content-Type' => 'application/xml'));
                break;
            }
        }
        $response = new Response('<h1>406 Not Acceptable</h1>', 406, array('Content-Type' => 'text/html'));
        break;
    case 'rdf':
        $type = (string)$record->getFirstMatchingField('002@/00')->getNthSubfield(0, '0');
        if ($type[0] === 'T') {
            $templateUri = __DIR__ . '/../../../../../src/xslt/pica/auth.xsl';
            $sourceUri = sprintf(PICA_TEMPLATE, $ident);
            $content = transform($sourceUri, $templateUri);
            if ($content) {
                $response = new Response($content, 200, array('Content-Type' => 'application/rdf+xml'));
                break;
            }
        } else {
            $templateUri = __DIR__ . '/../../../../../src/xslt/mods2rdf.xsl';
            $sourceUri = sprintf(MODS_TEMPLATE, $ident);
            $content = transform($sourceUri, $templateUri);
            if ($content) {
                $response = new Response($content, 200, array('Content-Type' => 'application/rdf+xml'));
                break;
            }
        }
        $response = new Response('<h1>406 Not Acceptable</h1>', 406, array('Content-Type' => 'text/html'));
        break;
    default:
        $response = new Response('<h1>406 Not Acceptable</h1>', 406, array('Content-Type' => 'text/html'));
}

terminate($request, $response);
