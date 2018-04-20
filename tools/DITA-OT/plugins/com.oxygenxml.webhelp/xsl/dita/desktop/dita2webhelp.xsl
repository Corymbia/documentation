<?xml version="1.0" encoding="UTF-8"?>
<!--
    
Oxygen Webhelp plugin
Copyright (c) 1998-2014 Syncro Soft SRL, Romania.  All rights reserved.
Licensed under the terms stated in the license file EULA_Webhelp.txt 
available in the base directory of this Oxygen Webhelp plugin.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="2.0">
  
  <xsl:import href="../dita2webhelp.xsl"/>  
  <xsl:import href="fixup.xsl"/>
  
  <!-- Enable debugging from here. --> 
  <xsl:param name="WEBHELP_DEBUG" select="false()"/>
  <xsl:param name="PATH2PROJ">
  	<xsl:call-template name="fixed-path2project"/>
  </xsl:param>

  <!--
    When copy-to is used the path2project is incorrect, leading to broken
    references for css and js in some pages
  -->
  <xsl:template name="fixed-path2project">
  	<xsl:variable name="original-path">
  	  <xsl:apply-templates select="/processing-instruction('path2project')[1]" mode="get-path2project"/>
  	</xsl:variable>
    <xsl:choose>
      <xsl:when test="contains($original-path,'/en_us/')">../</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$original-path"/>       
      </xsl:otherwise>  	
    </xsl:choose>
  </xsl:template>
  
  <!-- Normal Webhelp transformation, filtered. -->
  <xsl:template match="/">
    
    <xsl:variable name="topicContent">
      <xsl:apply-imports/>
    </xsl:variable>    
    
    <xsl:choose>
      <xsl:when test="$WEBHELP_DEBUG">
        <!-- This generates Invalid HTML, but is OK for debugging. -->
        <html>
          <xsl:apply-templates select="$topicContent" mode="fixup_desktop"/>                 
          <hr/>
          <h1>Original content:</h1>
          <xsl:copy-of select="$topicContent"/>                
        </html>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$topicContent" mode="fixup_desktop"/>        
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
</xsl:stylesheet>
