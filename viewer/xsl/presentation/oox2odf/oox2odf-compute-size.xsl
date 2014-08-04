<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright (c) 2007, Sonata Software Limited
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * Neither the name of Sonata Software Limited nor the names of its contributors
*       may be used to endorse or promote products derived from this software
*       without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE
-->
  <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:oox="urn:oox"
xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" 
xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0"
xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0"
xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:dom="http://www.w3.org/2001/xml-events" 
xmlns="http://schemas.openxmlformats.org/package/2006/relationships"
xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships"
xmlns:pzip="urn:cleverage:xmlns:post-processings:zip"
xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties"
xmlns:dc="http://purl.org/dc/elements/1.1/"
xmlns:dcterms="http://purl.org/dc/terms/"
exclude-result-prefixes="p a r xlink ">
 
  <xsl:key name="Part" match="/oox:source/oox:part" use="@oox:name"/>
  <xsl:template match="/oox:source">
    <xsl:for-each select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:sldIdLst/p:sldId">
      <xsl:variable name ="SlideId">
        <xsl:value-of  select ="concat(concat('slide',position()),'.xml')" />
      </xsl:variable>
      <xsl:variable name ="slideRel">
        <xsl:value-of select ="concat('ppt/slides/_rels/',$SlideId,'.rels')"/>
      </xsl:variable>
      <xsl:variable name ="LayoutFileNo">
        <xsl:for-each select ="key('Part', $slideRel)//node()/@Target[contains(.,'slideLayouts')]">
          <xsl:value-of select ="concat('ppt',substring(.,3))"/>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name ="newLayout" >
        <xsl:for-each select ="key('Part', $slideRel)//node()/@Target[contains(.,'slideLayouts')]">
          <xsl:value-of  select ="substring-after(.,'../slideLayouts/')"/>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name ="LayoutRel" >
        <xsl:value-of select ="concat('ppt/slideLayouts/_rels/',$newLayout,'.rels')"/>
      </xsl:variable>
      <xsl:variable name ="SMName" >
        <xsl:for-each select ="key('Part', $LayoutRel)//node()/@Target[contains(.,'slideMasters')]">
          <xsl:value-of  select ="substring-after(.,'../slideMasters/')"/>
        </xsl:for-each>
      </xsl:variable>
      <xsl:call-template name="tmpCompulteSize">
        <xsl:with-param name="docName" select="concat('ppt/slides/',$SlideId)"/>
      </xsl:call-template>
      <xsl:call-template name="tmpCompulteSize">
        <xsl:with-param name="docName" select="concat('ppt/slides/',$SlideId)"/>
      </xsl:call-template>
      <xsl:call-template name="tmpCompulteSize">
        <xsl:with-param name="docName" select="$LayoutFileNo"/>
      </xsl:call-template>
      <xsl:call-template name="tmpCompulteSize">
        <xsl:with-param name="docName" select="$LayoutFileNo"/>
      </xsl:call-template>
      <xsl:call-template name="tmpCompulteSize">
        <xsl:with-param name="docName" select="concat('ppt/slideMasters/',$SMName)"/>
      </xsl:call-template>
      <xsl:call-template name="tmpCompulteSize">
        <xsl:with-param name="docName" select="concat('ppt/slideMasters/',$SMName)"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="tmpCompulteSize">
    <xsl:param name="docName"/>
   
    <xsl:for-each select ="key('Part', $docName)//a:p">
      <xsl:message terminate="no">progress:a:p</xsl:message>
    </xsl:for-each>
    <xsl:for-each select ="key('Part', $docName)//a:r">
      <xsl:message terminate="no">progress:a:p</xsl:message>
    </xsl:for-each>
    <xsl:for-each select ="key('Part', $docName)//p:bodyStyle">
      <xsl:message terminate="no">progress:a:p</xsl:message>
    </xsl:for-each>
    <xsl:for-each select ="key('Part', $docName)//p:titleStyle">
      <xsl:message terminate="no">progress:a:p</xsl:message>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
