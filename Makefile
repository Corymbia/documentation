#
# Simple driver to build the documentation. ant is used to build everything
# This simplifies environment variables and enables building
# the docs "out of the box"
#
# The following environment variables customize
# documentation output.
#
export BUILD_VERSION_STRING=STAGING

# Eucalyptus version string
export DOC_VERSION_NUMBER=4.4.4

# Euca2ools version string
export EUCA2OOLS_VERSION_NUMBER=3.4.1

#
# The following environment variables are needed in order
# for ant/java to function correctly
#
export DITA_HOME := $(CURDIR)/tools/DITA-OT
export DOC_HOME := $(CURDIR)/content
export DITA_DIR=$(DITA_HOME)/

export ANT_OPTS :=-Xmx512m ${ANT_OPTS} -Djavax.xml.transform.TransformerFactory=net.sf.saxon.TransformerFactoryImpl
export ANT_HOME :=$(DITA_HOME)/tools/ant
export PATH :=$(DITA_HOME)/tools/ant/bin:${PATH}
export SAXON_EE_LICENSED_ENV=true

#
# Construct a java classpath to properly run webhelp
#
class_path := $(DITA_HOME)/plugins/com.oxygenxml.webhelp/lib/xslthl-2.0.1.jar \
              $(DITA_HOME)/plugins/com.oxygenxml.webhelp/lib/xml-apis.jar \
              $(DITA_HOME)/plugins/com.oxygenxml.webhelp/lib/xml-apis-ext.jar \
              $(DITA_HOME)/plugins/com.oxygenxml.webhelp/lib/xhtml-indexer.jar \
              $(DITA_HOME)/plugins/com.oxygenxml.webhelp/lib/xercesImpl.jar \
              $(DITA_HOME)/plugins/com.oxygenxml.webhelp/lib/webhelpXsltExtensions.jar \
              $(DITA_HOME)/plugins/com.oxygenxml.webhelp/lib/resolver.jar \
              $(DITA_HOME)/plugins/com.oxygenxml.webhelp/lib/lucene-core-4.0.0.jar \
              $(DITA_HOME)/plugins/com.oxygenxml.webhelp/lib/lucene-analyzers-common-4.0.0.jar \
              $(DITA_HOME)/plugins/com.oxygenxml.webhelp/lib/log4j.jar \
              $(DITA_HOME)/plugins/com.oxygenxml.webhelp/lib/license.jar \
              $(DITA_HOME)/plugins/com.oxygenxml.webhelp/lib/ant-contrib-1.0b3.jar \
              $(DITA_HOME)/lib/saxon/saxon9-dom.jar \
              $(DITA_HOME)/lib/saxon/saxon9.jar \
              $(DITA_HOME)/lib/xml-apis.jar \
              $(DITA_HOME)/lib/xercesImpl.jar \
              $(DITA_HOME)/lib/icu4j.jar \
              $(DITA_HOME)/lib/resolver.jar \
              $(DITA_HOME)/lib/commons-codec-1.4.jar \
              $(DITA_HOME)/lib \
              $(DITA_HOME)/lib/dost.jar

# Build the class path environment variable
space := $(subst ,, )
canonical_classpath := $(subst $(space),:,$(class_path))
export CLASSPATH := $(canonical_classpath)

#
# Rules
#
.PHONY: pdf webhelp clean all help


all: pdf webhelp ## (default) Build HTML and PDF documentation

pdf: ## Build the PDF documents
	cd content/en_us && ant pdf

webhelp: ## Compile the HTML help files
	cd content/en_us && ant webhelp

clean: ## Clean out temporary files and build artifacts
	cd content/en_us && ant clean

help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-10s\033[0m- %s\n", $$1, $$2}' $(MAKEFILE_LIST)
