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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:oox="urn:oox"
  xmlns:pzip="urn:cleverage:xmlns:post-processings:zip"
  xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships"
  xmlns:manifest="urn:oasis:names:tc:opendocument:xmlns:manifest:1.0"
  xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" 

  exclude-result-prefixes="oox rels">

	<xsl:import href="content.xsl"/>
	<xsl:import href="styles.xsl"/>
	<xsl:import href="settings.xsl"/>
	<xsl:import href="meta.xsl"/>
	<xsl:import href="common.xsl"/>
	<xsl:import href="pictures.xsl"/>
	<xsl:import href="shapes_reverse.xsl"/>
	<xsl:import href="customAnim.xsl"/>
	<xsl:import href="notesOox2Odf.xsl"/>
	<!-- Import Bullets and numbering-->
	<xsl:import href="BulletsNumberingoox2odf.xsl"/>
	<xsl:import href="SlideMaster.xsl"/>
	<xsl:import href="notesMaster.xsl"/>
	
	<xsl:param name="outputFile"/>

  <!-- a string containing detailed information on environment and
       converter version to be added to the document's meta data -->
  <xsl:param name="generator"/>
  <xsl:param name="documentType" />
  
	<xsl:output method="xml" encoding="UTF-8"/>
        <xsl:key name="Part" match="/oox:source/oox:part" use="@oox:name"/>
	<!-- App version number -->
	<xsl:variable name="app-version">2.0.0</xsl:variable>
	<xsl:template match="/oox:source">
		<pzip:archive pzip:target="{$outputFile}">
      <!--Conformance Test-->
      <!-- mimetype -->
          <pzip:entry pzip:target="mimetype" pzip:compression="none" pzip:content-type="text/plain" pzip:content="application/vnd.oasis.opendocument.presentation" />
        
			<!-- Manifest -->
			<pzip:entry pzip:target="META-INF/manifest.xml">
				<manifest:manifest xmlns:manifest="urn:oasis:names:tc:opendocument:xmlns:manifest:1.0">
					<manifest:file-entry manifest:media-type="application/vnd.oasis.opendocument.presentation"
					  manifest:full-path="/"/>
          <manifest:file-entry manifest:media-type="" manifest:full-path="Configurations2/statusbar/"/>
					<manifest:file-entry manifest:media-type="" manifest:full-path="Configurations2/accelerator/current.xml"/>
					<manifest:file-entry manifest:media-type="" manifest:full-path="Configurations2/accelerator/"/>
					<manifest:file-entry manifest:media-type="" manifest:full-path="Configurations2/floater/"/>
					<manifest:file-entry manifest:media-type="" manifest:full-path="Configurations2/popupmenu/"/>
					<manifest:file-entry manifest:media-type="" manifest:full-path="Configurations2/progressbar/"/>
					<manifest:file-entry manifest:media-type="" manifest:full-path="Configurations2/menubar/"/>
					<manifest:file-entry manifest:media-type="" manifest:full-path="Configurations2/toolbar/"/>
					<manifest:file-entry manifest:media-type="" manifest:full-path="Configurations2/images/Bitmaps/"/>
					<manifest:file-entry manifest:media-type="" manifest:full-path="Configurations2/images/"/>
					<manifest:file-entry manifest:media-type="application/vnd.sun.xml.ui.configuration" manifest:full-path="Configurations2/"/>
					<manifest:file-entry manifest:media-type="text/xml" manifest:full-path="content.xml"/>
					<manifest:file-entry manifest:media-type="text/xml" manifest:full-path="styles.xml"/>
					<manifest:file-entry manifest:media-type="text/xml" manifest:full-path="meta.xml"/>
					<manifest:file-entry manifest:media-type="" manifest:full-path="Thumbnails/"/>
					<manifest:file-entry manifest:media-type="" manifest:full-path="Thumbnails/thumbnail.png"/>
					<manifest:file-entry manifest:media-type="text/xml" manifest:full-path="settings.xml"/>
                                        
					<xsl:for-each
					  select="key('Part', 'ppt/presentation.xml')//node()[name() = 'Relationship'][substring-before(@Target,'/') = 'media']">
						<xsl:call-template name="InsertManifestFileEntry"/>
					</xsl:for-each >
          <xsl:call-template name="tmpMenifestEntryForOLEobject" />
				</manifest:manifest>
			</pzip:entry>
                              
			
			<pzip:entry pzip:target="content.xml">
				<xsl:call-template name="content" />
			</pzip:entry >
			<pzip:entry pzip:target="styles.xml">
				<xsl:call-template name="styles" />
			</pzip:entry>
			<pzip:entry pzip:target="settings.xml">
				<xsl:call-template name="settings" />
			</pzip:entry>
			<pzip:entry pzip:target="meta.xml">
        <xsl:call-template name="meta">
          <xsl:with-param name="app-version" select="$app-version" />
          <xsl:with-param name="generator" select="$generator" />
        </xsl:call-template>
			</pzip:entry>
			<pzip:entry pzip:target="Configurations2/accelerator/current.xml">
				<xsl:call-template name="InsertManifestFileEntry"/>
			</pzip:entry>

		</pzip:archive>
	</xsl:template>
	<xsl:template name="InsertManifestFileEntry">
		<manifest:file-entry>
			<xsl:attribute name="manifest:media-type">
				<xsl:if test="substring-after(@Target,'.') = 'gif'">
					<xsl:text>image/gif</xsl:text>
				</xsl:if>
				<xsl:if
				  test="substring-after(@Target,'.') = 'jpg' or substring-after(@Target,'.') = 'jpeg'  or substring-after(@Target,'.') = 'jpe' or substring-after(@Target,'.') = 'jfif' ">
					<xsl:text>image/jpeg</xsl:text>
				</xsl:if>
				<xsl:if test="substring-after(@Target,'.') = 'tif' or substring-after(@Target,'.') = 'tiff'">
					<xsl:text>image/tiff</xsl:text>
				</xsl:if>
				<xsl:if test="substring-after(@Target,'.') = 'png'">
					<xsl:text>image/png</xsl:text>
				</xsl:if>
			</xsl:attribute>
			<xsl:attribute name="manifest:full-path">
				<xsl:text>Pictures/</xsl:text>
				<xsl:value-of select="substring-after(@Target,'/')"/>
			</xsl:attribute>
		</manifest:file-entry>
	</xsl:template>
</xsl:stylesheet>