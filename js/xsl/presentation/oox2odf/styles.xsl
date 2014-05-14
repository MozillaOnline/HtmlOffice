<?xml version="1.0" encoding="UTF-8" ?>
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
	xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" 
   xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" 
  xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" 
  xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" 
  xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" 
  xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" 
  xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" 
  xmlns:xlink="http://www.w3.org/1999/xlink" 
  xmlns:dc="http://purl.org/dc/elements/1.1/" 
  xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" 
  xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" 
  xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0" 
  xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" 
  xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" 
  xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" 
  xmlns:math="http://www.w3.org/1998/Math/MathML" 
  xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" 
  xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" 
  xmlns:ooo="http://openoffice.org/2004/office" 
  xmlns:ooow="http://openoffice.org/2004/writer" 
  xmlns:oooc="http://openoffice.org/2004/calc" 
  xmlns:dom="http://www.w3.org/2001/xml-events" 
  xmlns:smil="urn:oasis:names:tc:opendocument:xmlns:smil-compatible:1.0" 
  xmlns:anim="urn:oasis:names:tc:opendocument:xmlns:animation:1.0" 
  xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" 
  xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" 
  xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships"
  exclude-result-prefixes="xlink form">


	<!-- Shape constants-->
	<xsl:variable name ="dot">
		<xsl:value-of select ="'0.07'"/>
	</xsl:variable>
	<xsl:variable name ="dash">
		<xsl:value-of select ="'0.282'"/>
	</xsl:variable>
	<xsl:variable name ="longDash">
		<xsl:value-of select ="'0.564'"/>
	</xsl:variable>
	<xsl:variable name ="distance">
		<xsl:value-of select ="'0.211'"/>
	</xsl:variable>	
	<xsl:template name="styles">
    <xsl:message terminate="no">progress:a:p</xsl:message>
		<office:document-styles office:version="1.1">			
		<office:styles>
        <xsl:for-each select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:sldIdLst/p:sldId">
          <xsl:variable name ="pageSlide">
            <xsl:value-of select ="concat(concat('ppt/slides/slide',position()),'.xml')"/>
          </xsl:variable>
          <xsl:variable name ="SlideFileName">
            <xsl:value-of select ="concat(concat('slide',position()),'.xml')"/>
          </xsl:variable>
          <xsl:variable name ="slideRel">
            <xsl:value-of select ="concat('ppt/slides/_rels/',$SlideFileName,'.rels')"/>
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
          <xsl:variable name ="SMRel" >
            <xsl:value-of select ="concat('ppt/slideMasters/_rels/',$SMName,'.rels')"/>
          </xsl:variable>
          <xsl:variable name ="ThemeName" >
            <xsl:for-each select ="key('Part', $SMRel)//node()/@Target[contains(.,'theme')]">
              <xsl:value-of  select="concat('ppt',substring-after(.,'..'))"/>
            </xsl:for-each>
          </xsl:variable>
          <xsl:call-template name="tmpGradientFillStyle">
            <xsl:with-param name="FilePath" select="$pageSlide"/>
            <xsl:with-param name="FileName" select="$SlideFileName"/>
            <xsl:with-param name="FileType" select="concat('slide',position())"/>
            <xsl:with-param name="SMName" select="$SMName"/>
          </xsl:call-template>
          <xsl:call-template name="tmpBGgradientFillStyle">
            <xsl:with-param name="FilePath" select="$pageSlide"/>
            <xsl:with-param name="FileName" select="$SlideFileName"/>
            <xsl:with-param name="FileType" select="concat('slide',position())"/>
            <xsl:with-param name="SMName" select="$SMName"/>
          </xsl:call-template>
        </xsl:for-each>
				<xsl:call-template name ="InsertDefaultStyles" />
        <xsl:call-template name="SlideMaster"/>
				<xsl:call-template name="InsertShapeStyles"/>
        <xsl:call-template name="tmpInsertLayoutType"/>
        <xsl:for-each select="key('Part', 'ppt/presentation.xml')//p:sldMasterIdLst/p:sldMasterId">
          <xsl:message terminate="no">progress:a:p</xsl:message>
          <xsl:variable name="sldMasterIdRelation">
            <xsl:value-of select="@r:id"></xsl:value-of>
          </xsl:variable>
          <xsl:for-each select="key('Part', 'ppt/_rels/presentation.xml.rels')//node()[@Id=$sldMasterIdRelation]">
            <xsl:variable name="slideMasterPath">
              <xsl:value-of select="substring-after(@Target,'/')"/>
            </xsl:variable>
            <xsl:variable name="slideMasterName">
              <xsl:value-of select="substring-before($slideMasterPath,'.xml')"/>
            </xsl:variable>
            <xsl:call-template name="NMasterSubtitleOutlineStyle">
              <xsl:with-param name="slideMasterPath" select="'notesMaster1.xml'"/>
              <xsl:with-param name="slideMasterName" select="$slideMasterName"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="key('Part', 'ppt/presentation.xml')//p:handoutMasterIdLst/p:handoutMasterId">
          <xsl:variable name ="handoutMasterIdRelation">
            <xsl:value-of select ="./@r:id"/>
          </xsl:variable>
          <xsl:variable name ="curPos" select ="position()"/>
          <xsl:for-each select="key('Part', 'ppt/_rels/presentation.xml.rels')//node()[@Id=$handoutMasterIdRelation]">
            <xsl:variable name="handoutMasterPath">
              <xsl:value-of select="substring-after(@Target,'/')"/>
            </xsl:variable>
            <xsl:variable name="handoutMasterName">
              <xsl:value-of select="substring-before($handoutMasterPath,'.xml')"/>
            </xsl:variable>
            <xsl:call-template name="tmpGradientFillStyle">
              <xsl:with-param name="FilePath" select="concat('ppt/handoutMasters/',$handoutMasterPath)"/>
              <xsl:with-param name="FileName" select="$handoutMasterPath"/>
              <xsl:with-param name="FileType" select="$handoutMasterName"/>
            </xsl:call-template>
            <xsl:call-template name="tmpgetBackImage">
              <xsl:with-param name="FilePath" select="concat('ppt/handoutMasters/',$handoutMasterPath)"/>
              <xsl:with-param name="FileName" select="$handoutMasterPath"/>
              <xsl:with-param name="FileType" select="$handoutMasterName"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:for-each>
        <xsl:call-template name="tmpgetBackImage">
          <xsl:with-param name="FilePath" select="'ppt/notesMasters/notesMaster1.xml'"/>
          <xsl:with-param name="FileName" select="'notesMaster1.xml'"/>
          <xsl:with-param name="FileType" select="'notesMaster1'"/>
        </xsl:call-template>
			</office:styles>
		<office:automatic-styles>
        <!-- added by Vipul to insert background color for Slide master-->
        <!--start-->
        <xsl:call-template name="tmpSMDrawingPageStyle"/>
        <!-- end-->
      <!-- Template Added by Vijayeta
           Insert Handout styles
           Date:30th July-->
      <xsl:call-template name="tmpHandoutDrawingPageStyle"/>
      <!-- End of Template Added by Vijayeta to Insert Handout styles-->
				<xsl:call-template name="InsertSlideSize"/><!-- Change By Vijayeta-->
				<!--<xsl:call-template name="InsertNotesSize"/>-->
       <xsl:call-template name ="InsertHandoutMasterSize"/>
       <xsl:call-template name="NotesMasterSlideSize"/>
        <!--Added by Vipul to insert style for shapes-->
        <xsl:call-template name="GraphicStyleForSlideMaster"/>
       <!-- Template Added by Vijayeta
           Insert Handout Graphic styles
           Date:30th July-->
      <xsl:call-template name="tmpHandoutGraphicStyle"/>
      <!-- End of Template Added by Vijayeta to Insert Handout Graphic styles-->
       <xsl:call-template name="GraphicStyleForNotesMaster"/>
			</office:automatic-styles>
      <xsl:call-template name="slideMasterStylePage"></xsl:call-template>
		</office:document-styles>
	</xsl:template>
	<xsl:template name ="InsertDefaultStyles">
		<style:style style:name="standard" style:family="graphic">
			<style:graphic-properties draw:stroke="solid" svg:stroke-color="#385d8a" svg:stroke-width=".07cm" draw:marker-start-width="0.3cm" draw:marker-start-center="false" draw:marker-end-width="0.3cm" draw:marker-end-center="false" draw:fill="solid" draw:fill-color="#4F81BD" fo:padding-top="0.125cm" fo:padding-bottom="0.125cm" fo:padding-left="0.25cm" fo:padding-right="0.25cm">
				<text:list-style>
					<text:list-level-style-bullet text:level="1" text:bullet-char="●">
						<style:text-properties fo:font-family="StarSymbol" style:use-window-font-color="true" fo:font-size="45%"/>
					</text:list-level-style-bullet>
					<text:list-level-style-bullet text:level="2" text:bullet-char="●">
						<style:list-level-properties text:space-before="0.6cm" text:min-label-width="0.6cm"/>
						<style:text-properties fo:font-family="StarSymbol" style:use-window-font-color="true" fo:font-size="45%"/>
					</text:list-level-style-bullet>
					<text:list-level-style-bullet text:level="3" text:bullet-char="●">
						<style:list-level-properties text:space-before="1.2cm" text:min-label-width="0.6cm"/>
						<style:text-properties fo:font-family="StarSymbol" style:use-window-font-color="true" fo:font-size="45%"/>
					</text:list-level-style-bullet>
					<text:list-level-style-bullet text:level="4" text:bullet-char="●">
						<style:list-level-properties text:space-before="1.8cm" text:min-label-width="0.6cm"/>
						<style:text-properties fo:font-family="StarSymbol" style:use-window-font-color="true" fo:font-size="45%"/>
					</text:list-level-style-bullet>
					<text:list-level-style-bullet text:level="5" text:bullet-char="●">
						<style:list-level-properties text:space-before="2.4cm" text:min-label-width="0.6cm"/>
						<style:text-properties fo:font-family="StarSymbol" style:use-window-font-color="true" fo:font-size="45%"/>
					</text:list-level-style-bullet>
					<text:list-level-style-bullet text:level="6" text:bullet-char="●">
						<style:list-level-properties text:space-before="3cm" text:min-label-width="0.6cm"/>
						<style:text-properties fo:font-family="StarSymbol" style:use-window-font-color="true" fo:font-size="45%"/>
					</text:list-level-style-bullet>
					<text:list-level-style-bullet text:level="7" text:bullet-char="●">
						<style:list-level-properties text:space-before="3.6cm" text:min-label-width="0.6cm"/>
						<style:text-properties fo:font-family="StarSymbol" style:use-window-font-color="true" fo:font-size="45%"/>
					</text:list-level-style-bullet>
					<text:list-level-style-bullet text:level="8" text:bullet-char="●">
						<style:list-level-properties text:space-before="4.2cm" text:min-label-width="0.6cm"/>
						<style:text-properties fo:font-family="StarSymbol" style:use-window-font-color="true" fo:font-size="45%"/>
					</text:list-level-style-bullet>
					<text:list-level-style-bullet text:level="9" text:bullet-char="●">
						<style:list-level-properties text:space-before="4.8cm" text:min-label-width="0.6cm"/>
						<style:text-properties fo:font-family="StarSymbol" style:use-window-font-color="true" fo:font-size="45%"/>
					</text:list-level-style-bullet>
					<text:list-level-style-bullet text:level="10" text:bullet-char="●">
						<style:list-level-properties text:space-before="5.4cm" text:min-label-width="0.6cm"/>
						<style:text-properties fo:font-family="StarSymbol" style:use-window-font-color="true" fo:font-size="45%"/>
					</text:list-level-style-bullet>
				</text:list-style>
			</style:graphic-properties>
			<style:paragraph-properties fo:margin-left="0cm" fo:margin-right="0cm" fo:margin-top="0cm" fo:margin-bottom="0cm" fo:line-height="100%" text:enable-numbering="false" fo:text-indent="0cm"/>
			<style:text-properties style:use-window-font-color="true" style:text-outline="false" style:text-line-through-style="none" fo:font-family="Arial" style:font-family-generic="roman" style:font-pitch="variable" fo:font-size="18pt" fo:font-style="normal" fo:text-shadow="none" style:text-underline-style="none" fo:font-weight="normal" style:font-family-asian="&apos;Arial Unicode MS&apos;" style:font-family-generic-asian="system" style:font-pitch-asian="variable" style:font-size-asian="18pt" style:font-style-asian="normal" style:font-weight-asian="normal" style:font-family-complex="Tahoma" style:font-family-generic-complex="system" style:font-pitch-complex="variable" style:font-size-complex="18pt" style:font-style-complex="normal" style:font-weight-complex="normal" style:text-emphasize="none" style:font-relief="none"/>
		</style:style>
    <!-- Added by vijayeta, AL02T6 thumbnails defining all the slides, 30th july '07-->
    <style:presentation-page-layout style:name="AL0T26">
      <presentation:placeholder presentation:object="handout" svg:x="2.058cm" svg:y="1.743cm" svg:width="6.104cm" svg:height="-0.233cm" />
      <presentation:placeholder presentation:object="handout" svg:x="10.962cm" svg:y="1.743cm" svg:width="6.104cm" svg:height="-0.233cm" />
      <presentation:placeholder presentation:object="handout" svg:x="19.866cm" svg:y="1.743cm" svg:width="6.104cm" svg:height="-0.233cm" />
      <presentation:placeholder presentation:object="handout" svg:x="2.058cm" svg:y="3.612cm" svg:width="6.104cm" svg:height="-0.233cm" />
      <presentation:placeholder presentation:object="handout" svg:x="10.962cm" svg:y="3.612cm" svg:width="6.104cm" svg:height="-0.233cm" />
      <presentation:placeholder presentation:object="handout" svg:x="19.866cm" svg:y="3.612cm" svg:width="6.104cm" svg:height="-0.233cm" />
      <presentation:placeholder presentation:object="handout" svg:x="2.058cm" svg:y="5.481cm" svg:width="6.104cm" svg:height="-0.233cm" />
      <presentation:placeholder presentation:object="handout" svg:x="10.962cm" svg:y="5.481cm" svg:width="6.104cm" svg:height="-0.233cm" />
      <presentation:placeholder presentation:object="handout" svg:x="19.866cm" svg:y="5.481cm" svg:width="6.104cm" svg:height="-0.233cm" />
    </style:presentation-page-layout>
		</xsl:template>
	
	<xsl:template name="InsertShapeStyles">

		<xsl:for-each select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:sldIdLst/p:sldId">
			
			<xsl:variable name ="SlideId">
				<xsl:value-of  select ="concat(concat('slide',position()),'.xml')" />
			</xsl:variable>
						
			<xsl:for-each select ="key('Part', concat('ppt/slides/',$SlideId))/p:sld/p:cSld/p:spTree//p:sp/p:spPr/a:ln">
        <xsl:call-template name="tmpArrowProp"/>
			</xsl:for-each>

      <xsl:for-each select ="key('Part', concat('ppt/slides/',$SlideId))/p:sld/p:cSld/p:spTree//p:cxnSp/p:spPr/a:ln ">
        <xsl:call-template name="tmpArrowProp"/>
      </xsl:for-each>
			</xsl:for-each >
		
	</xsl:template>
  <xsl:template name="tmpArrowProp">
				<!--Dash types-->
				<xsl:if test ="a:prstDash/@val">
					<xsl:call-template name ="getDashType">
						<xsl:with-param name ="val" select ="a:prstDash/@val" />
						<xsl:with-param name ="cap" select ="@cap" />
					</xsl:call-template>
				</xsl:if>
				<!-- Head End-->
				<xsl:if test ="a:headEnd">
					<xsl:call-template name ="getArrowType">
						<xsl:with-param name ="type" select ="a:headEnd/@type" />
					</xsl:call-template>
				</xsl:if>

				<!-- Tail End-->
				<xsl:if test ="a:tailEnd">
					<xsl:call-template name ="getArrowType">
						<xsl:with-param name ="type" select ="a:tailEnd/@type" />
					</xsl:call-template>
				</xsl:if>
			</xsl:template>
  <!-- Notes Size-->
  <xsl:template name="NotesMasterSlideSize">
    <xsl:for-each select ="key('Part', 'ppt/presentation.xml')//p:presentation/p:notesSz">
      <xsl:message terminate="no">progress:a:p</xsl:message>
      <style:page-layout style:name="PMNotes">
        <style:page-layout-properties 
				 fo:margin-top="0cm" 
				 fo:margin-bottom="0cm" 
				 fo:margin-left="0cm" 
				 fo:margin-right="0cm">
          <xsl:attribute name ="fo:page-width">
            <xsl:call-template name="ConvertEmu">
              <xsl:with-param name="length" select="@cx"/>
              <xsl:with-param name="unit">cm</xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name ="fo:page-height">
            <xsl:call-template name="ConvertEmu">
              <xsl:with-param name="length" select="@cy"/>
              <xsl:with-param name="unit">cm</xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name ="style:print-orientation">
            <xsl:call-template name="CheckOrientation">
              <xsl:with-param name="cx" select="@cx"/>
              <xsl:with-param name="cy" select="@cy"/>
            </xsl:call-template>
            <!--<xsl:value-of select ="'portrait'"/>-->
          </xsl:attribute>
        </style:page-layout-properties>
      </style:page-layout>
    </xsl:for-each>
  </xsl:template>
  <!--End-->

	<xsl:template name ="getArrowType">
		<xsl:param name ="type" />
		<xsl:choose>

			<!--Triangle-->
			<xsl:when test ="($type='triangle')">
				<draw:marker draw:name="triangle" draw:display-name="Arrow" svg:viewBox="0 0 20 30" svg:d="m10 0-10 30h20z"/>
			</xsl:when>

			<!--Arrow-->
			<xsl:when test ="($type='arrow')">
				<draw:marker draw:name="arrow" draw:display-name="Line Arrow" svg:viewBox="0 0 1122 2243" svg:d="m0 2108v17 17l12 42 30 34 38 21 43 4 29-8 30-21 25-26 13-34 343-1532 339 1520 13 42 29 34 39 21 42 4 42-12 34-30 21-42v-39-12l-4 4-440-1998-9-42-25-39-38-25-43-8-42 8-38 25-26 39-8 42z"/>
			</xsl:when>

			<!--Stealth-->
			<xsl:when test ="($type='stealth')">
				<draw:marker draw:name="stealth" draw:display-name="Arrow concave" svg:viewBox="0 0 1131 1580" svg:d="m1013 1491 118 89-567-1580-564 1580 114-85 136-68 148-46 161-17 161 13 153 46z"/>
			</xsl:when>

			<!--Oval-->
			<xsl:when test ="($type='oval')">
				<draw:marker draw:name="oval" draw:display-name="Oval" svg:viewBox="0 0 1131 1131" svg:d="m462 1118-102-29-102-51-93-72-72-93-51-102-29-102-13-105 13-102 29-106 51-102 72-89 93-72 102-50 102-34 106-9 101 9 106 34 98 50 93 72 72 89 51 102 29 106 13 102-13 105-29 102-51 102-72 93-93 72-98 51-106 29-101 13z"/>
			</xsl:when>

			<!--Diamond-->
			<xsl:when test ="($type='diamond')">
				<draw:marker draw:name="diamond" draw:display-name="Square" svg:viewBox="0 0 1131 1131" svg:d="m0 564 564 567 567-567-567-564z"/>
			</xsl:when >
			
		</xsl:choose>
	</xsl:template>

	<xsl:template name ="getDashType">
		<xsl:param name ="val" />
		<xsl:param name ="cap" />
		<xsl:choose>
			<xsl:when test ="($val='sysDot')">
				<xsl:call-template name ="AddDashType">
					<xsl:with-param name ="name" select ="'sysDot'" />
					<xsl:with-param name ="cap" select ="$cap" />
					<xsl:with-param name ="dot1" select ="'1'" />
					<xsl:with-param name ="dot1-length" select = "$dot" />
					<xsl:with-param name ="distance" select ="$dot" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test ="($val='sysDash')">
				<xsl:call-template name ="AddDashType">
					<xsl:with-param name ="name" select ="'sysDash'" />
					<xsl:with-param name ="cap" select ="$cap" />
					<xsl:with-param name ="dot1" select ="'1'" />
					<xsl:with-param name ="dot1-length" select = "$dot" />
					<xsl:with-param name ="distance" select ="$dot" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test ="($val='dash')">
				<xsl:call-template name ="AddDashType">
					<xsl:with-param name ="name" select ="'dash'" />
					<xsl:with-param name ="cap" select ="$cap" />
					<xsl:with-param name ="dot2" select ="'1'" />
					<xsl:with-param name ="dot2-length" select = "$dash" />
					<xsl:with-param name ="distance" select ="$distance" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test ="($val='dashDot')">
				<xsl:call-template name ="AddDashType">
					<xsl:with-param name ="name" select ="'dashDot'" />
					<xsl:with-param name ="cap" select ="$cap" />
					<xsl:with-param name ="dot1" select ="'1'" />
					<xsl:with-param name ="dot1-length" select = "$dot" />
					<xsl:with-param name ="dot2" select ="'1'" />
					<xsl:with-param name ="dot2-length" select = "$dash" />
					<xsl:with-param name ="distance" select ="$distance" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test ="($val='lgDash')">
				<xsl:call-template name ="AddDashType">
					<xsl:with-param name ="name" select ="'lgDash'" />
					<xsl:with-param name ="cap" select ="$cap" />
					<xsl:with-param name ="dot2" select ="'1'" />
					<xsl:with-param name ="dot2-length" select = "$longDash" />
					<xsl:with-param name ="distance" select ="$distance" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test ="($val='lgDashDot')">
				<xsl:call-template name ="AddDashType">
					<xsl:with-param name ="name" select ="'lgDashDot'" />
					<xsl:with-param name ="cap" select ="$cap" />
					<xsl:with-param name ="dot1" select ="'1'" />
					<xsl:with-param name ="dot1-length" select = "$dot" />
					<xsl:with-param name ="dot2" select ="'1'" />
					<xsl:with-param name ="dot2-length" select = "$longDash" />
					<xsl:with-param name ="distance" select ="$distance" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test ="($val='lgDashDotDot')">
				<xsl:call-template name ="AddDashType">
					<xsl:with-param name ="name" select ="'lgDashDotDot'" />
					<xsl:with-param name ="cap" select ="$cap" />
					<xsl:with-param name ="dot1" select ="'2'" />
					<xsl:with-param name ="dot1-length" select = "$dot" />
					<xsl:with-param name ="dot2" select ="'1'" />
					<xsl:with-param name ="dot2-length" select = "$longDash" />
					<xsl:with-param name ="distance" select ="$distance" />
				</xsl:call-template>
			</xsl:when>
			
		</xsl:choose>
	</xsl:template>
	<xsl:template name ="AddDashType">
		<xsl:param name ="name" />
		<xsl:param name ="cap" />
		<xsl:param name ="dot1" />
		<xsl:param name ="dot1-length" />
		<xsl:param name ="dot2" />
		<xsl:param name ="dot2-length" />
		<xsl:param name ="distance" />

		<draw:stroke-dash>
			<xsl:if test ="$cap='rnd'">
				<xsl:attribute name ="draw:name">
					<xsl:value-of select ="concat($name,'Round')"/>
				</xsl:attribute>
				<xsl:attribute name ="draw:style">
					<xsl:value-of select ="'round'"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test ="not($cap) or ($cap!='rnd')">
				<xsl:attribute name ="draw:name">
					<xsl:value-of select ="$name"/>
				</xsl:attribute>
				<xsl:attribute name ="draw:style">
					<xsl:value-of select ="'rect'"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:attribute name ="draw:display-name">
				<xsl:value-of select ="$name"/>
			</xsl:attribute>
			<xsl:if test ="(string-length($dot1) != 0)">
				<xsl:attribute name ="draw:dots1">
					<xsl:value-of select ="$dot1" />
				</xsl:attribute>
			</xsl:if>
			<xsl:if test ="(string-length($dot1-length) != 0)">
				<xsl:attribute name ="draw:dots1-length">
					<xsl:value-of select ="concat($dot1-length,'cm')" />
				</xsl:attribute>
			</xsl:if>
			<xsl:if test ="(string-length($dot2) != 0)">
				<xsl:attribute name ="draw:dots2">
					<xsl:value-of select ="$dot2" />
				</xsl:attribute>
			</xsl:if>
			<xsl:if test ="(string-length($dot2-length) != 0)">
				<xsl:attribute name ="draw:dots2-length">
					<xsl:value-of select ="concat($dot2-length,'cm')" />
				</xsl:attribute>
			</xsl:if>
			<xsl:if test ="(string-length($distance) != 0)">
				<xsl:attribute name ="draw:distance">
					<xsl:value-of select ="concat($distance,'cm')"/>
				</xsl:attribute>
			</xsl:if>
		</draw:stroke-dash>
		
	</xsl:template>
	<!-- Changes made by Vijayeta-->
	<!-- Slide Size-->
	<xsl:template name="InsertSlideSize">
		<xsl:for-each select ="key('Part', 'ppt/presentation.xml')//p:presentation/p:sldSz">
			<style:page-layout style:name="PM1">
				<style:page-layout-properties 
				 fo:margin-top="0cm" 
				 fo:margin-bottom="0cm" 
				 fo:margin-left="0cm" 
				 fo:margin-right="0cm">
					<xsl:attribute name ="fo:page-width">
						<xsl:call-template name="ConvertEmu">
							<xsl:with-param name="length" select="@cx"/>
							<xsl:with-param name="unit">cm</xsl:with-param>
						</xsl:call-template>
					</xsl:attribute>
					<xsl:attribute name ="fo:page-height">
						<xsl:call-template name="ConvertEmu">
							<xsl:with-param name="length" select="@cy"/>
							<xsl:with-param name="unit">cm</xsl:with-param>
						</xsl:call-template>
					</xsl:attribute>
					<xsl:attribute name ="style:print-orientation">
						<xsl:call-template name="CheckOrientation">
							<xsl:with-param name="cx" select="@cx"/>
							<xsl:with-param name="cy" select="@cy"/>
						</xsl:call-template>
						<!--<xsl:value-of select ="'portrait'"/>-->
					</xsl:attribute>
				</style:page-layout-properties>
			</style:page-layout>			
		</xsl:for-each>
	</xsl:template>
	<!-- Notes Size-->
	<!--<xsl:template name="InsertNotesSize">
		--><!-- Check if notesSlide is present in the package--><!--
		<xsl:if test ="key('Part', 'ppt/notesSlides/notesSlide1.xml')">
			<xsl:variable name ="Flag">
				--><!--Check if size defined in notesSlide --><!--
				<xsl:for-each select ="key('Part', 'ppt/notesSlides/notesSlide1.xml')//p:notes/p:cSld/p:spTree/p:sp">
					<xsl:if test ="p:nvSpPr/p:cNvPr/@name[contains(.,'Notes Placeholder 2')]">
						<xsl:if test ="p:spPr/a:xfrm/a:ext[@cx]">
							<xsl:value-of select ="'true'"/>
						</xsl:if>
						<xsl:if test ="not(p:spPr/a:xfrm/a:ext[@cx])">
							<xsl:value-of select ="'false'"/>
						</xsl:if>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:choose >
				<xsl:when test ="$Flag='true'">
					--><!-- notesSlide has Size Definition(user defined)--><!--
					<xsl:for-each select ="key('Part', 'ppt/notesSlides/notesSlide1.xml')//p:notes/p:cSld/p:spTree/p:sp">
						<xsl:if test ="p:nvSpPr/p:cNvPr/@name[contains(.,'Notes Placeholder 2')]">
							<style:page-layout style:name="PM2">
								<style:page-layout-properties>
									<xsl:for-each select ="p:spPr/a:xfrm/a:ext[@cx]">
										<xsl:attribute name ="fo:page-width">
											<xsl:call-template name="ConvertEmu">
												<xsl:with-param name="length" select="@cx"/>
												<xsl:with-param name="unit">cm</xsl:with-param>
											</xsl:call-template>
										</xsl:attribute>
									</xsl:for-each>
									<xsl:for-each select ="p:spPr/a:xfrm/a:ext[@cy]">
										<xsl:attribute name ="fo:page-height">
											<xsl:call-template name="ConvertEmu">
												<xsl:with-param name="length" select="@cy"/>
												<xsl:with-param name="unit">cm</xsl:with-param>
											</xsl:call-template>
										</xsl:attribute>
									</xsl:for-each>
									<xsl:attribute name ="style:print-orientation">
										<xsl:call-template name="CheckOrientation">
											<xsl:with-param name="cx" select="@cx"/>
											<xsl:with-param name="cy" select="@cy"/>
										</xsl:call-template>
									</xsl:attribute>
								</style:page-layout-properties>
							</style:page-layout>
						</xsl:if>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					--><!-- pre-defined size definition in notesMaster--><!--
					<xsl:for-each select ="key('Part', 'ppt/notesMasters/notesMaster1.xml')//p:notesMaster/p:cSld/p:spTree/p:sp">
						<xsl:if test ="p:nvSpPr/p:cNvPr/@name[contains(.,'Notes Placeholder 4')]">
							<style:page-layout style:name="PM2">
								<style:page-layout-properties>
									<xsl:for-each select ="p:spPr/a:xfrm/a:ext[@cx]">
										<xsl:attribute name ="fo:page-width">
											<xsl:call-template name="ConvertEmu">
												<xsl:with-param name="length" select="@cx"/>
												<xsl:with-param name="unit">cm</xsl:with-param>
											</xsl:call-template>
										</xsl:attribute>
									</xsl:for-each>
									<xsl:for-each select ="p:spPr/a:xfrm/a:ext[@cy]">
										<xsl:attribute name ="fo:page-height">
											<xsl:call-template name="ConvertEmu">
												<xsl:with-param name="length" select="@cy"/>
												<xsl:with-param name="unit">cm</xsl:with-param>
											</xsl:call-template>
										</xsl:attribute>
									</xsl:for-each>
									<xsl:attribute name ="style:print-orientation">
										<xsl:call-template name="CheckOrientation">
											<xsl:with-param name="cx" select="@cx"/>
											<xsl:with-param name="cy" select="@cy"/>
										</xsl:call-template>
									</xsl:attribute>
								</style:page-layout-properties>
							</style:page-layout>
						</xsl:if>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		--><!--Default Size in presentation.xml--><!--
		<xsl:if test ="not(key('Part', 'ppt/notesSlides/notesSlide1.xml'))">
			<xsl:for-each select ="key('Part', 'ppt/presentation.xml')//p:presentation/p:notesSz">
				<style:page-layout style:name="PM2">
					<style:page-layout-properties>
						<xsl:attribute name ="fo:page-width">
							<xsl:call-template name="ConvertEmu">
								<xsl:with-param name="length" select="@cx"/>
								<xsl:with-param name="unit">cm</xsl:with-param>
							</xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name ="fo:page-height">
							<xsl:call-template name="ConvertEmu">
								<xsl:with-param name="length" select="@cy"/>
								<xsl:with-param name="unit">cm</xsl:with-param>
							</xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name ="style:print-orientation">
							<xsl:call-template name="CheckOrientation">
								<xsl:with-param name="cx" select="@cx"/>
								<xsl:with-param name="cy" select="@cy"/>
							</xsl:call-template>
						</xsl:attribute>
					</style:page-layout-properties>
				</style:page-layout>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>-->
	<!-- Slide Number,The equvivalent Not present in ODP-->

  <!-- Added by Vijayeta
       Set Handout size(PM0)
       Dated: 30th July '07-->
  <xsl:template name ="InsertHandoutMasterSize">
    <xsl:for-each select ="key('Part', 'ppt/presentation.xml')//p:presentation/p:sldSz">
      <style:page-layout style:name="PMhandOut">
        <style:page-layout-properties
         fo:margin-top="0cm"
         fo:margin-bottom="0cm"
         fo:margin-left="0cm"
         fo:margin-right="0cm"
         fo:page-width="27.94cm"
         fo:page-height="21.59cm"
         style:print-orientation="landscape" >
          <!--<xsl:attribute name ="fo:page-width">
            <xsl:call-template name="ConvertEmu">
              <xsl:with-param name="length" select="@cx"/>
              <xsl:with-param name="unit">cm</xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name ="fo:page-height">
            <xsl:call-template name="ConvertEmu">
              <xsl:with-param name="length" select="@cy"/>
              <xsl:with-param name="unit">cm</xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name ="style:print-orientation">
            <xsl:call-template name="CheckOrientation">
              <xsl:with-param name="cx" select="@cx"/>
              <xsl:with-param name="cy" select="@cy"/>
            </xsl:call-template>
            <xsl:value-of select ="'portrait'"/>
          </xsl:attribute>-->
        </style:page-layout-properties>
      </style:page-layout>
    </xsl:for-each>
  </xsl:template>
  <!--End of snippet added by Vijayeta Set Handout size(PM0)-->
	<xsl:template name="InsertSlideNumber">
		<xsl:for-each select ="key('Part', 'ppt/presentation.xml')//p:presentation">
			<draw:frame presentation:class="page-number">
				<draw:text-box>
					<text:p>
						<xsl:if test ="@firstSlideNum">
							<text:page-number>
								<xsl:value-of select ="@firstSlideNum"/>
							</text:page-number>
						</xsl:if>
					</text:p>
				</draw:text-box>
			</draw:frame>
		</xsl:for-each>
	</xsl:template>
	<!-- Add MasterStyles Definition-->

	<xsl:template name="InsertMasterStylesDefinition">

		<!--<style:handout-master style:page-layout-name="PM0"/>-->
		<style:master-page style:name="Default" style:page-layout-name="PM1">
			<xsl:call-template name ="SetDateFooterPageNumberPosition">
				<xsl:with-param name ="PlaceHolder">
					<xsl:value-of select ="'dt'"/>
				</xsl:with-param>
				<xsl:with-param name ="PresentationClass">
					<xsl:value-of select ="'date-time'"/>
				</xsl:with-param>
        <!--Change made by Vijayeta,adding another parameter -->
        <xsl:with-param name ="TextStyleName">
          <xsl:value-of select ="'P1'"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name ="SetDateFooterPageNumberPosition">
        <xsl:with-param name ="PlaceHolder">
          <xsl:value-of select ="'ftr'"/>
        </xsl:with-param>
        <xsl:with-param name ="PresentationClass">
          <xsl:value-of select ="'footer'"/>
        </xsl:with-param>
        <!--Change made by Vijayeta,adding another parameter-->
        <xsl:with-param name ="TextStyleName">
          <xsl:value-of select ="'P2'"/>
        </xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name ="SetDateFooterPageNumberPosition">
				<xsl:with-param name ="PlaceHolder">
					<xsl:value-of select ="'sldNum'"/>
				</xsl:with-param>
				<xsl:with-param name ="PresentationClass">
					<xsl:value-of select ="'page-number'"/>
				</xsl:with-param>
        <!--Change made by Vijayeta,adding another parameter -->
        <xsl:with-param name ="TextStyleName">
          <xsl:value-of select ="'P3'"/>
        </xsl:with-param>
      </xsl:call-template>
      <presentation:notes style:page-layout-name="PM2">
        <xsl:call-template name="InsertSlideNumber" />
      </presentation:notes>
    </style:master-page>
  </xsl:template>
  <!--checks cx/cy ratio,for orientation-->
	<xsl:template name ="CheckOrientation">
		<xsl:param name="cx"/>
		<xsl:param name="cy"/>
		<xsl:variable name="orientation"/>
		<xsl:choose>
			<xsl:when test ="$cx > $cy">
				<xsl:value-of select="'landscape'" />
			</xsl:when>
			<xsl:otherwise >
				<xsl:value-of select ="'portrait'"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$orientation"/>
	</xsl:template>
	<!--  converts emu to given unit-->
	<xsl:template name="ConvertEmu">
		<xsl:param name="length"/>
		<xsl:param name="unit"/>
		<xsl:choose>
			<xsl:when
					test="$length = '' or not($length) or $length = 0 or format-number($length div 360000, '#.##') = ''">
				<xsl:value-of select="concat(0,'cm')"/>
			</xsl:when>
			<xsl:when test="$unit = 'cm'">
				<xsl:value-of select="concat(format-number($length div 360000, '#.##'), 'cm')"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- Changes made by Vijayeta-->
	<!--SetDateFooterPageNumberValues -->
	<xsl:template name ="SetDateFooterPageNumberPosition">
		<xsl:param name ="PlaceHolder"/>
		<xsl:param name ="PresentationClass"/>
    <xsl:param name ="TextStyleName"/>
		<xsl:for-each select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:sldIdLst/p:sldId">
			<!-- for each slide-->
			<xsl:variable name ="currentpos">
				<xsl:value-of select="position()"/>
			</xsl:variable>
			<xsl:variable name ="footerSlide">
				<xsl:value-of select ="concat(concat('ppt/slides/slide',position()),'.xml')"/>
			</xsl:variable>
			<xsl:variable name ="Flag">
				<xsl:for-each select ="key('Part', $footerSlide)/p:sld/p:cSld/p:spTree/p:sp">
					<!-- for each shape in current slide-->
					<xsl:if test ="p:nvSpPr/p:nvPr/p:ph/@type[contains(.,$PlaceHolder)]">
						<xsl:if test ="p:spPr/a:xfrm">
							<xsl:value-of select ="'slide'"/>
						</xsl:if>
					</xsl:if>
				</xsl:for-each>
				<!--END, for each shape in current slide-->
				<xsl:variable name ="SlideLayout">
					<xsl:variable name ="bool">
						<xsl:for-each select ="key('Part', $footerSlide)/p:sld/p:cSld/p:spTree/p:sp">
							<xsl:if test ="p:nvSpPr/p:nvPr/p:ph/@type[contains(.,$PlaceHolder)]">
								<xsl:if  test ="not(p:sp/p:spPr/a:xfrm)">
									<xsl:value-of select ="'true'"/>
								</xsl:if>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:if test = "$bool = 'true'">
						<xsl:for-each select ="key('Part', concat(concat(('ppt/slides/_rels/slide'),$currentpos),'.xml.rels'))//rels:Relationships/rels:Relationship[@Target]">
							<!-- for each find 'slideLayoutX.xml'-->
							<xsl:value-of select ="substring(@Target,17)"/>
						</xsl:for-each>
					</xsl:if>
				</xsl:variable>
				<xsl:for-each select ="key('Part', concat(('ppt/slideLayouts/'),($SlideLayout)))//p:sldLayout/p:cSld/p:spTree/p:sp">
					<!-- for each Shape in layout-->
					<xsl:if test ="p:nvSpPr/p:nvPr/p:ph/@type[contains(.,$PlaceHolder)]">
						<xsl:if test ="p:spPr/a:xfrm">
							<xsl:value-of select ="'layout'"/>
						</xsl:if>
					</xsl:if>
				</xsl:for-each>
				<!--END, for each Shape in layout-->
			</xsl:variable>
      <!-- Change made by Vijayeta-->
      <xsl:if test ="$currentpos =1"> 
        <xsl:choose>
          <xsl:when test ="$Flag = 'slide'">
            <xsl:for-each select ="key('Part', $footerSlide)/p:sld/p:cSld/p:spTree/p:sp">
              <xsl:if test ="p:nvSpPr/p:nvPr/p:ph/@type[contains(.,$PlaceHolder)]">
                <draw:frame draw:layer="backgroundobjects" presentation:style-name="pr1">
                  <xsl:for-each select ="p:spPr/a:xfrm/a:off[@x]">
                    <xsl:attribute name ="presentation:class">
                      <xsl:value-of select ="$PresentationClass"/>
                    </xsl:attribute>
                    <!-- Change made by Vijayeta,Text style included to align Footer,Date-Time and Page Number-->
                    <xsl:attribute name ="draw:text-style-name">
                      <xsl:value-of select ="$TextStyleName"/>
                    </xsl:attribute>
                    <xsl:attribute name ="svg:x">
                      <xsl:call-template name="ConvertEmu">
                        <xsl:with-param name="length" select="@x"/>
                        <xsl:with-param name="unit">cm</xsl:with-param>
                      </xsl:call-template>
                    </xsl:attribute>
                  </xsl:for-each>
                  <xsl:for-each select ="p:spPr/a:xfrm/a:off[@y]">
                    <xsl:attribute name ="svg:y">
                      <xsl:call-template name="ConvertEmu">
                        <xsl:with-param name="length" select="@y"/>
                        <xsl:with-param name="unit">cm</xsl:with-param>
                      </xsl:call-template>
                    </xsl:attribute>
                  </xsl:for-each>
                  <xsl:for-each select ="p:spPr/a:xfrm/a:ext[@cx]">
                    <xsl:attribute name ="svg:width">
                      <xsl:call-template name="ConvertEmu">
                        <xsl:with-param name="length" select="@cx"/>
                        <xsl:with-param name="unit">cm</xsl:with-param>
                      </xsl:call-template>
                    </xsl:attribute>
                  </xsl:for-each>
                  <xsl:for-each select ="p:spPr/a:xfrm/a:ext[@cy]">
                    <xsl:attribute name ="svg:height">
                      <xsl:call-template name="ConvertEmu">
                        <xsl:with-param name="length" select="@cy"/>
                        <xsl:with-param name="unit">cm</xsl:with-param>
                      </xsl:call-template>
                      <xsl:value-of select ="SlideHeight"/>
                    </xsl:attribute>
                  </xsl:for-each>
                  <xsl:if test ="$PresentationClass = 'date-time'">
                    <xsl:call-template name ="date-time"/>
                  </xsl:if>
                  <xsl:if test ="$PresentationClass = 'footer'">
                    <xsl:call-template name ="footer"/>
                  </xsl:if>
                  <xsl:if test ="$PresentationClass = 'page-number'">
                    <xsl:call-template name ="page-number"/>
                  </xsl:if>
                </draw:frame>
              </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test ="$Flag = 'layout'">
            <xsl:variable name ="SlideLayout">
              <xsl:for-each select ="key('Part', concat(concat(('ppt/slides/_rels/slide'),$currentpos),'.xml.rels'))//rels:Relationships/rels:Relationship[@Target]">
                <xsl:value-of select ="substring(@Target,17)"/>
              </xsl:for-each>
            </xsl:variable>
            <!--<xsl:for-each select ="key('Part', concat(('ppt/slideLayouts/'),($SlideLayout)))//p:sldLayout/p:cSld/p:spTree/p:sp">-->
            <xsl:for-each select ="key('Part', concat(('ppt/slideLayouts/'),($SlideLayout)))//p:sldLayout/p:cSld/p:spTree/p:sp">
              <xsl:if test ="p:nvSpPr/p:nvPr/p:ph/@type[contains(.,$PlaceHolder)]">
                <draw:frame draw:layer="backgroundobjects" presentation:style-name="pr1">
                  <xsl:for-each select ="p:spPr/a:xfrm/a:off[@x]">
                    <xsl:attribute name ="presentation:class">
                      <xsl:value-of select ="$PresentationClass"/>
                    </xsl:attribute>
                    <!-- Change made by Vijayeta,Text style included to align Footer,Date-Time and Page Number-->
                    <xsl:attribute name ="draw:text-style-name">
                      <xsl:value-of select ="$TextStyleName"/>
                    </xsl:attribute>
                    <xsl:attribute name ="svg:x">
                      <xsl:call-template name="ConvertEmu">
                        <xsl:with-param name="length" select="@x"/>
                        <xsl:with-param name="unit">cm</xsl:with-param>
                      </xsl:call-template>
                    </xsl:attribute>
                  </xsl:for-each>
                  <xsl:for-each select ="p:spPr/a:xfrm/a:off[@y]">
                    <xsl:attribute name ="svg:y">
                      <xsl:call-template name="ConvertEmu">
                        <xsl:with-param name="length" select="@y"/>
                        <xsl:with-param name="unit">cm</xsl:with-param>
                      </xsl:call-template>
                    </xsl:attribute>
                  </xsl:for-each>
                  <xsl:for-each select ="p:spPr/a:xfrm/a:ext[@cx]">
                    <xsl:attribute name ="svg:width">
                      <xsl:call-template name="ConvertEmu">
                        <xsl:with-param name="length" select="@cx"/>
                        <xsl:with-param name="unit">cm</xsl:with-param>
                      </xsl:call-template>
                    </xsl:attribute>
                  </xsl:for-each>
                  <xsl:for-each select ="p:spPr/a:xfrm/a:ext[@cy]">
                    <xsl:attribute name ="svg:height">
                      <xsl:call-template name="ConvertEmu">
                        <xsl:with-param name="length" select="@cy"/>
                        <xsl:with-param name="unit">cm</xsl:with-param>
                      </xsl:call-template>
                      <xsl:value-of select ="SlideHeight"/>
                    </xsl:attribute>
                  </xsl:for-each>
                  <xsl:if test ="$PresentationClass = 'date-time'">
                    <xsl:call-template name ="date-time"/>
                  </xsl:if>
                  <xsl:if test ="$PresentationClass = 'footer'">
                    <xsl:call-template name ="footer"/>
                  </xsl:if>
                  <xsl:if test ="$PresentationClass = 'page-number'">
                    <xsl:call-template name ="page-number"/>
                  </xsl:if>
                </draw:frame>
              </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <!-- SlideMaster-->
            <xsl:for-each select ="key('Part', 'ppt/slideMasters/slideMaster1.xml')//p:sldMaster/p:cSld/p:spTree/p:sp">
              <xsl:if test ="p:nvSpPr/p:nvPr/p:ph/@type[contains(.,$PlaceHolder)]">
                <draw:frame draw:layer="backgroundobjects" presentation:style-name="pr1">
                  <xsl:attribute name ="presentation:class">
                    <xsl:value-of select ="$PresentationClass"/>
                  </xsl:attribute>
                  <!-- Change made by Vijayeta,Text style included to align Footer,Date-Time and Page Number-->
                  <xsl:attribute name ="draw:text-style-name">
                    <xsl:value-of select ="$TextStyleName"/>
                  </xsl:attribute>
                  <xsl:for-each select ="p:spPr/a:xfrm/a:off[@x]">
                    <xsl:attribute name ="svg:x">
                      <xsl:call-template name="ConvertEmu">
                        <xsl:with-param name="length" select="@x"/>
                        <xsl:with-param name="unit">cm</xsl:with-param>
                      </xsl:call-template>
                    </xsl:attribute>
                  </xsl:for-each>
                  <xsl:for-each select ="p:spPr/a:xfrm/a:off[@y]">
                    <xsl:attribute name ="svg:y">
                      <xsl:call-template name="ConvertEmu">
                        <xsl:with-param name="length" select="@y"/>
                        <xsl:with-param name="unit">cm</xsl:with-param>
                      </xsl:call-template>
                    </xsl:attribute>
                  </xsl:for-each>
                  <xsl:for-each select ="p:spPr/a:xfrm/a:ext[@cx]">
                    <xsl:attribute name ="svg:width">
                      <xsl:call-template name="ConvertEmu">
                        <xsl:with-param name="length" select="@cx"/>
                        <xsl:with-param name="unit">cm</xsl:with-param>
                      </xsl:call-template>
                    </xsl:attribute>
                  </xsl:for-each>
                  <xsl:for-each select ="p:spPr/a:xfrm/a:ext[@cy]">
                    <xsl:attribute name ="svg:height">
                      <xsl:call-template name="ConvertEmu">
                        <xsl:with-param name="length" select="@cy"/>
                        <xsl:with-param name="unit">cm</xsl:with-param>
                      </xsl:call-template>
                      <xsl:value-of select ="SlideHeight"/>
                    </xsl:attribute>
                  </xsl:for-each>
                  <xsl:if test ="$PresentationClass = 'date-time'">
                    <xsl:call-template name ="date-time"/>
                  </xsl:if>
                  <xsl:if test ="$PresentationClass = 'footer'">
                    <xsl:call-template name ="footer"/>
                  </xsl:if>
                  <xsl:if test ="$PresentationClass = 'page-number'">
                    <xsl:call-template name ="page-number"/>
                  </xsl:if>
                </draw:frame>
              </xsl:if>
            </xsl:for-each>
          </xsl:otherwise>
          <!-- END,SlideMaster-->
        </xsl:choose>
      </xsl:if >
		</xsl:for-each>
		<!-- END,for each slide-->

	</xsl:template>
	<xsl:template name ="date-time">
		<draw:text-box>
			<text:p>
				<presentation:date-time/>
			</text:p>
		</draw:text-box>
	</xsl:template>
	<xsl:template name ="footer">
		<draw:text-box>
			<text:p>
				<presentation:footer/>
			</text:p>
		</draw:text-box>
	</xsl:template>
	<xsl:template name ="page-number">
		<draw:text-box>
			<text:p>
				<text:page-number> &lt;number&gt;</text:page-number>
			</text:p>
		</draw:text-box>
	</xsl:template>
  <xsl:template name ="tmpInsertLayoutType">
    <xsl:variable name="SlideLayoutType">
      <xsl:for-each select="key('Part', 'ppt/presentation.xml')//p:sldMasterIdLst/p:sldMasterId">
        <xsl:message terminate="no">progress:a:p</xsl:message>
        <xsl:variable name="sldMasterIdRelation">
          <xsl:value-of select="@r:id"></xsl:value-of>
        </xsl:variable>
        <xsl:for-each select="key('Part', 'ppt/_rels/presentation.xml.rels')//node()[@Id=$sldMasterIdRelation]">
          <xsl:variable name="slideMasterPath">
            <xsl:value-of select="substring-after(@Target,'/')"/>
          </xsl:variable>
          <xsl:for-each select="key('Part', concat('ppt/slideMasters/_rels/',$slideMasterPath,'.rels'))//node()/@Target[contains(.,'slideLayouts')]">
            <xsl:variable name="slideLayoutName">
              <xsl:value-of select="substring-after(.,'..')"/>
            </xsl:variable>
            <xsl:for-each select ="key('Part', concat('ppt',$slideLayoutName))/p:sldLayout/@type">
              <xsl:value-of select="concat(.,'@')"/>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>
    <!--Style defination for GetLayOutName template-->
    <!--@@Title and chart-->
    <xsl:if test="contains($SlideLayoutType,'chart@')">
      <style:presentation-page-layout style:name="AL6T2">
			<presentation:placeholder presentation:object="title" svg:x="2.058cm" svg:y="1.743cm" svg:width="23.912cm" svg:height="3.507cm" />
        <presentation:placeholder presentation:object="chart" svg:x="2.058cm" svg:y="5.838cm" svg:width="23.912cm" svg:height="13.23cm"/>
      </style:presentation-page-layout>
    </xsl:if>
    <!--@@Title, clipart on left, text on right-->
    <xsl:if test="contains($SlideLayoutType,'clipArtAndTx@')">
      <style:presentation-page-layout style:name="AL8T9">
        <presentation:placeholder presentation:object="title" svg:x="2.058cm" svg:y="1.743cm" svg:width="23.912cm" svg:height="3.507cm"/>
        <presentation:placeholder presentation:object="graphic" svg:x="2.058cm" svg:y="5.838cm" svg:width="11.67cm" svg:height="13.23cm"/>
        <presentation:placeholder presentation:object="outline" svg:x="14.311cm" svg:y="5.838cm" svg:width="-0.585cm" svg:height="13.23cm"/>
      </style:presentation-page-layout>
    </xsl:if>
    <!--@@Title and four objects-->
    <xsl:if test="contains($SlideLayoutType,'fourObj@')">
      <style:presentation-page-layout style:name="AL19T18">
        <presentation:placeholder presentation:object="title" svg:x="2.058cm" svg:y="1.743cm" svg:width="23.912cm" svg:height="3.507cm"/>
        <presentation:placeholder presentation:object="object" svg:x="2.058cm" svg:y="5.838cm" svg:width="11.67cm" svg:height="6.311cm"/>
        <presentation:placeholder presentation:object="object" svg:x="14.311cm" svg:y="5.838cm" svg:width="-0.585cm" svg:height="6.311cm"/>
        <presentation:placeholder presentation:object="object" svg:x="2.058cm" svg:y="12.748cm" svg:width="11.67cm" svg:height="-0.601cm"/>
        <presentation:placeholder presentation:object="object" svg:x="14.311cm" svg:y="12.748cm" svg:width="-0.585cm" svg:height="-0.601cm"/>
		</style:presentation-page-layout>
    </xsl:if>
    <!--@@Title and Object only-->
    <xsl:if test="contains($SlideLayoutType,'obj@') or contains($SlideLayoutType,'tx@')">
		<style:presentation-page-layout style:name="AL2T1">
			<presentation:placeholder presentation:object="title" svg:x="2.058cm" svg:y="1.743cm" svg:width="23.912cm" svg:height="3.507cm" />
        <presentation:placeholder presentation:object="object" svg:x="2.058cm" svg:y="5.838cm" svg:width="23.912cm" svg:height="13.23cm"/>
      </style:presentation-page-layout>
    </xsl:if>
    <!--@@Title, object on left, text on right-->
    <xsl:if test="contains($SlideLayoutType,'objAndTx@')">
      <style:presentation-page-layout style:name="AL14T13">
        <presentation:placeholder presentation:object="title" svg:x="2.058cm" svg:y="1.743cm" svg:width="23.912cm" svg:height="3.507cm"/>
        <presentation:placeholder presentation:object="object" svg:x="2.058cm" svg:y="5.838cm" svg:width="11.67cm" svg:height="13.23cm"/>
        <presentation:placeholder presentation:object="outline" svg:x="14.311cm" svg:y="5.838cm" svg:width="-0.585cm" svg:height="13.23cm"/>
      </style:presentation-page-layout>
    </xsl:if>
    <!--@@Title, object on top, text on bottom-->
    <xsl:if test="contains($SlideLayoutType,'objOverTx@')">
      <style:presentation-page-layout style:name="AL15T14">
        <presentation:placeholder presentation:object="title" svg:x="2.058cm" svg:y="1.743cm" svg:width="23.912cm" svg:height="3.507cm"/>
        <presentation:placeholder presentation:object="object" svg:x="2.058cm" svg:y="5.838cm" svg:width="23.912cm" svg:height="6.311cm"/>
        <presentation:placeholder presentation:object="outline" svg:x="2.058cm" svg:y="12.748cm" svg:width="23.912cm" svg:height="-0.601cm"/>
      </style:presentation-page-layout>
    </xsl:if>
    <!--@@Title and table-->
    <xsl:if test="contains($SlideLayoutType,'tbl@')">
      <style:presentation-page-layout style:name="AL7T8">
        <presentation:placeholder presentation:object="title" svg:x="2.058cm" svg:y="1.743cm" svg:width="23.912cm" svg:height="3.507cm"/>
        <presentation:placeholder presentation:object="table" svg:x="2.058cm" svg:y="5.838cm" svg:width="23.912cm" svg:height="13.23cm"/>
		</style:presentation-page-layout>
    </xsl:if>
     <!--@@Title only layout--> 
    <xsl:if test="contains($SlideLayoutType,'titleOnly@')">
      <style:presentation-page-layout style:name="AL4T19">
        <presentation:placeholder presentation:object="title" svg:x="2.058cm" svg:y="1.743cm" svg:width="23.912cm" svg:height="3.507cm" />
      </style:presentation-page-layout>
    </xsl:if>
    <!--@@Title, text on left, text on right-->
    <xsl:if test="contains($SlideLayoutType,'twoColTx@') or contains($SlideLayoutType,'twoObj@') or contains($SlideLayoutType,'twoTxTwoObj@')">
		<style:presentation-page-layout style:name="AL3T3">
			<presentation:placeholder presentation:object="title" svg:x="2.058cm" svg:y="1.743cm" svg:width="23.912cm" svg:height="3.507cm" />
			<presentation:placeholder presentation:object="outline" svg:x="2.058cm" svg:y="5.838cm" svg:width="11.67cm" svg:height="13.23cm" />
			<presentation:placeholder presentation:object="outline" svg:x="14.311cm" svg:y="5.838cm" svg:width="-0.585cm" svg:height="13.23cm" />
		</style:presentation-page-layout>
    </xsl:if>
    <!--@@Title, two objects on left, text on right-->
    <xsl:if test="contains($SlideLayoutType,'twoObjAndTx@')">
      <style:presentation-page-layout style:name="AL16T15">
			<presentation:placeholder presentation:object="title" svg:x="2.058cm" svg:y="1.743cm" svg:width="23.912cm" svg:height="3.507cm" />
        <presentation:placeholder presentation:object="object" svg:x="2.058cm" svg:y="5.838cm" svg:width="11.67cm" svg:height="6.311cm"/>
        <presentation:placeholder presentation:object="object" svg:x="2.058cm" svg:y="12.748cm" svg:width="11.67cm" svg:height="-0.601cm"/>
        <presentation:placeholder presentation:object="outline" svg:x="14.311cm" svg:y="5.838cm" svg:width="-0.585cm" svg:height="13.23cm"/>
		</style:presentation-page-layout>
    </xsl:if>
    <!--@@Title, two objects on top, text on bottom-->
    <xsl:if test="contains($SlideLayoutType,'twoObjOverTx@')">
      <style:presentation-page-layout style:name="AL17T16">
			<presentation:placeholder presentation:object="title" svg:x="2.058cm" svg:y="1.743cm" svg:width="23.912cm" svg:height="3.507cm" />
        <presentation:placeholder presentation:object="object" svg:x="2.058cm" svg:y="5.838cm" svg:width="11.67cm" svg:height="6.311cm"/>
        <presentation:placeholder presentation:object="object" svg:x="14.311cm" svg:y="5.838cm" svg:width="-0.585cm" svg:height="6.311cm"/>
        <presentation:placeholder presentation:object="outline" svg:x="2.058cm" svg:y="12.748cm" svg:width="23.912cm" svg:height="-0.601cm"/>
		</style:presentation-page-layout>
    </xsl:if>
    <!--@@Title, text on left, clip art on right-->
    <xsl:if test="contains($SlideLayoutType,'txAndClipArt@')">
      <style:presentation-page-layout style:name="AL10T6">
        <presentation:placeholder presentation:object="title" svg:x="2.058cm" svg:y="1.743cm" svg:width="23.912cm" svg:height="3.507cm" />
        <presentation:placeholder presentation:object="outline" svg:x="2.058cm" svg:y="5.838cm" svg:width="11.67cm" svg:height="13.23cm" />
        <presentation:placeholder presentation:object="graphic" svg:x="14.311cm" svg:y="5.838cm" svg:width="-0.585cm" svg:height="13.23cm"/>
      </style:presentation-page-layout>
    </xsl:if>
    <!--@@Title, text on left, object on right-->
    <xsl:if test="contains($SlideLayoutType,'txAndObj@')">
      <style:presentation-page-layout style:name="AL12T10">
        <presentation:placeholder presentation:object="title" svg:x="2.058cm" svg:y="1.743cm" svg:width="23.912cm" svg:height="3.507cm" />
        <presentation:placeholder presentation:object="outline" svg:x="2.058cm" svg:y="5.838cm" svg:width="11.67cm" svg:height="13.23cm"/>
        <presentation:placeholder presentation:object="object" svg:x="14.311cm" svg:y="5.838cm" svg:width="-0.585cm" svg:height="13.23cm"/>
      </style:presentation-page-layout>
    </xsl:if>
    <!--@@Title, Text &  Objects-->
    <xsl:if test="contains($SlideLayoutType,'txAndTwoObj@')">
      <style:presentation-page-layout style:name="AL13T12">
        <presentation:placeholder presentation:object="title" svg:x="2.058cm" svg:y="1.743cm" svg:width="23.912cm" svg:height="3.507cm" />
        <presentation:placeholder presentation:object="outline" svg:x="2.058cm" svg:y="5.838cm" svg:width="11.67cm" svg:height="13.23cm"/>
        <presentation:placeholder presentation:object="object" svg:x="14.311cm" svg:y="5.838cm" svg:width="-0.585cm" svg:height="6.311cm"/>
        <presentation:placeholder presentation:object="object" svg:x="14.311cm" svg:y="12.748cm" svg:width="-0.585cm" svg:height="-0.601cm"/>
      </style:presentation-page-layout>
    </xsl:if>
    <!--@@Title, text on top, object on bottom-->
    <xsl:if test="contains($SlideLayoutType,'txOverObj@')">
      <style:presentation-page-layout style:name="AL18T17">
        <presentation:placeholder presentation:object="title" svg:x="2.058cm" svg:y="1.743cm" svg:width="23.912cm" svg:height="3.507cm"/>
        <presentation:placeholder presentation:object="outline" svg:x="2.058cm" svg:y="5.838cm" svg:width="23.912cm" svg:height="6.311cm"/>
        <presentation:placeholder presentation:object="object" svg:x="2.058cm" svg:y="12.748cm" svg:width="23.912cm" svg:height="-0.601cm"/>
      </style:presentation-page-layout>
    </xsl:if>
    <!--@@Title & SubTitle-->
    <xsl:if test="contains($SlideLayoutType,'title@') or contains($SlideLayoutType,'secHead@')">
      <style:presentation-page-layout style:name="AL1T0">
        <presentation:placeholder presentation:object="title" svg:x="2.058cm" svg:y="1.743cm" svg:width="23.912cm" svg:height="3.507cm"/>
        <presentation:placeholder presentation:object="subtitle" svg:x="2.058cm" svg:y="5.838cm" svg:width="23.912cm" svg:height="13.23cm"/>
      </style:presentation-page-layout>
    </xsl:if>
    <!--@@Title,Text& Chart-->
    <xsl:if test="contains($SlideLayoutType,'vertTx@') or contains($SlideLayoutType,'txAndChart@')">
      <style:presentation-page-layout style:name="AL9T4">
        <presentation:placeholder presentation:object="title" svg:x="2.058cm" svg:y="1.743cm" svg:width="23.912cm" svg:height="3.507cm"/>
        <presentation:placeholder presentation:object="outline" svg:x="2.058cm" svg:y="5.838cm" svg:width="11.67cm" svg:height="13.23cm"/>
        <presentation:placeholder presentation:object="chart" svg:x="14.311cm" svg:y="5.838cm" svg:width="-0.585cm" svg:height="13.23cm"/>
      </style:presentation-page-layout>
    </xsl:if>
    <!--@@Title,Chart & Text-->
    <xsl:if test="contains($SlideLayoutType,'chartAndTx@')">
      <style:presentation-page-layout style:name="AL11T7">
        <presentation:placeholder presentation:object="title" svg:x="2.058cm" svg:y="1.743cm" svg:width="23.912cm" svg:height="3.507cm"/>
        <presentation:placeholder presentation:object="chart" svg:x="2.058cm" svg:y="5.838cm" svg:width="11.67cm" svg:height="13.23cm"/>
        <presentation:placeholder presentation:object="outline" svg:x="14.311cm" svg:y="5.838cm" svg:width="-0.585cm" svg:height="13.23cm"/>
      </style:presentation-page-layout>
    </xsl:if>
	</xsl:template>
</xsl:stylesheet>

