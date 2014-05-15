<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  * Copyright (c) 2006-2008 Clever Age
  * Copyright (c) 2006-2009 DIaLOGIKa
  *
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
  *     * Neither the names of copyright holders, nor the names of its contributors 
  *       may be used to endorse or promote products derived from this software 
  *       without specific prior written permission.
  * 
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
  * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
  * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
  * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
  * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
  * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
  * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
  * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF 
  * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
  -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
  xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
  xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
  xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
  xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
  xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
  xmlns:uri="http://schemas.openxmlformats.org/drawingml/2006/picture"
  xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
  xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
  xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:pzip="urn:cleverage:xmlns:post-processings:zip"
  xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships"
  xmlns:oox="urn:oox"
  exclude-result-prefixes="w wp r uri a pic oox rels">

  <xsl:template name="CopyPictures">
    <xsl:param name="document"/>
    <xsl:param name="rId"/>
    <xsl:param name="targetName"/>
    <xsl:param name="destFolder" select="'Pictures'"/>

    <!--  Copy Pictures Files to the picture catalog -->
    <xsl:variable name="id">
      <xsl:choose>
        <xsl:when test="$rId != ''">
          <xsl:value-of select="$rId"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="a:graphic/a:graphicData/pic:pic/pic:blipFill/a:blip/@r:embed"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:for-each select="key('Part', concat('word/_rels/',$document,'.rels'))/rels:Relationships/rels:Relationship[@Id=$id]" >
      <xsl:variable name="targetmode" select="./@TargetMode"/>
      <xsl:variable name="pzipsource" select="./@Target"/>
      <xsl:variable name="pziptarget">
        <xsl:choose>
          <xsl:when test="$targetName != ''">
            <xsl:value-of select="$targetName"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring-after($pzipsource,'/')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$targetmode='External'"/>
        <xsl:when test="$destFolder = '.'">
          <pzip:copy pzip:source="{concat('word/',$pzipsource)}" pzip:target="{$pziptarget}"/>
        </xsl:when>
        <xsl:otherwise>
          <pzip:copy pzip:source="{concat('word/',$pzipsource)}" pzip:target="{concat($destFolder,'/',$pziptarget)}"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!--  gets document name where image is placed (header, footer, document)-->
  <xsl:template name="GetDocumentName">

    <xsl:variable name="path" select="ancestor::oox:part/@oox:name" />
    <xsl:choose>
      <xsl:when test="contains($path, '/')">
        <xsl:value-of select="substring-after($path, '/')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$path" />
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="GetTarget">
    <xsl:param name="document"/>
    <xsl:param name="id"/>

    <xsl:value-of select="key('Part', concat('word/_rels/',$document,'.rels'))/rels:Relationships/rels:Relationship[@Id=$id]/@Target"/>
    <!--xsl:if test="key('Part', concat('word/_rels/',$document,'.rels'))">
      <xsl:for-each
        select="key('Part', concat('word/_rels/',$document,'.rels'))//node()[name() = 'Relationship']">
        <xsl:if test="./@Id=$id">
          <xsl:value-of select="./@Target"/>   
        </xsl:if>
      </xsl:for-each>
    </xsl:if-->
  </xsl:template>
</xsl:stylesheet>
