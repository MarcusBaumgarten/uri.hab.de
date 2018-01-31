TRANG := trang.cmd
JING  := jing.cmd
SAXON := transform.cmd
XSPEC := xspec.cmd
XPROC := calabash.cmd
COPY  := cp
RM    := rm -f

%.rng: %.rnc
	$(TRANG) -I rnc -O rng $< $@

%.sch: %.rng
	$(SAXON) -xsl:src/xslt/extract-schematron.xsl -o:$@ $<

test/schema/%.rnc: src/schema/%.rnc
	$(COPY) $< $@

.PHONY: test
test: copy-schema test/schema/common.sch test/schema/common.xspec test/schema/vocab.sch test/schema/vocab.xspec
	$(XSPEC) -s test/schema/common.xspec
	$(XSPEC) -s test/schema/vocab.xspec

.PHONY: validate
validate:
	$(XPROC) src/xproc/validate-rdfxml.xpl

.PHONY: clean
clean:
	$(RM) test/schema/*.rnc
	$(RM) test/schema/*.rng
	$(RM) test/schema/*.sch
	$(RM) test/schema/*-compiled.xspec
	$(RM) -r test/scheme/xspec

copy-schema: test/schema/common.rnc test/schema/vocab.rnc
