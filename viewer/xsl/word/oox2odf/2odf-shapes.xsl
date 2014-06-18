<?xml version="1.0" encoding="UTF-8"?>
<!--
  * Copyright (c) 2006, Clever Age
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
  *     * Neither the name of Clever Age nor the names of its contributors 
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
  * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
  xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
  xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
  xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
  xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
  xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
  xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
  xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
  xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships"
  xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
  xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
  xmlns:o="urn:schemas-microsoft-com:office:office"
  xmlns:v="urn:schemas-microsoft-com:vml"
  xmlns:w10="urn:schemas-microsoft-com:office:word"
  xmlns:pzip="urn:cleverage:xmlns:post-processings:zip"
  xmlns:oox="urn:oox"
  exclude-result-prefixes="a pic w r wp o rels v w10 oox pzip">

  <!--
  *************************************************************************
  SUMMARY
  *************************************************************************
  This stylesheet handles the conversion of VML shapes and VML images.
  *************************************************************************
  -->

  <!-- Sona Added Dashed Border-->
  <!-- Shape constants-->
  <xsl:variable name="dot" select="'0.07'" />
  <xsl:variable name="dash" select="'0.0579'" />
  <!-- 0.282-->
  <xsl:variable name="longDash" select="'0.1300'" />
  <xsl:variable name="distance" select="'0.0508'" />

  <!-- Arrow size -->
  <xsl:variable name="sm-sm" select="'0.14'" />
  <xsl:variable name="sm-med" select="'0.245'" />
  <xsl:variable name="sm-lg" select="'0.2'" />
  <xsl:variable name="med-sm" select="'0.234'" />
  <xsl:variable name="med-med" select="'0.351'" />
  <xsl:variable name="med-lg" select="'0.3'" />
  <xsl:variable name="lg-sm" select="'0.31'" />
  <xsl:variable name="lg-med" select="'0.35'" />
  <xsl:variable name="lg-lg" select="'0.4'" />
  <xsl:variable name="lineWeightDefault" select="'0.75'" />

  <xsl:key name="shapeTypeById" match="v:shapetype" use="@id" />

  <!-- 
  *************************************************************************
  MATCHING TEMPLATES
  *************************************************************************
  -->
  <!--
  Summary: Converts picture shapes
  Author: Clever Age
  -->
  <xsl:template match="v:shape[v:imagedata/@r:id]">
    <draw:frame>
      <xsl:call-template name="InsertCommonShapeProperties">
        <xsl:with-param name="shape" select="." />
      </xsl:call-template>
      <xsl:call-template name="InsertShapeZindexAttribute" />

      <xsl:apply-templates />
      <!-- some of the shape types must be in odf draw:frame even if they are outside of v:shape in oox-->
      <!-- divo: don't see a reason to apply templates to the following sibling. This can have unwanted side-effects, 
           e.g by calling the built-in templates for that mode which causes e.g. content of o:FieldCode nodes to be written to the output document -->
      <!--<xsl:apply-templates select="self::node()/following-sibling::node()[1]" mode="draw:frame" />-->
    </draw:frame>
  </xsl:template>

  <!-- 
  Summary: inserts horizontal ruler as image
  Author: Clever Age
  -->
  <xsl:template match="v:imagedata[not(../../o:OLEObject) and @r:id]">
    <xsl:variable name="document">
      <xsl:call-template name="GetDocumentName" />
    </xsl:variable>
    <xsl:call-template name="CopyPictures">
      <xsl:with-param name="document" select="$document" />
      <xsl:with-param name="rId" select="@r:id" />
    </xsl:call-template>
    <draw:image xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad">
      <xsl:if test="key('Part', concat('word/_rels/',$document,'.rels'))">
        <xsl:call-template name="InsertImageHref">
          <xsl:with-param name="document" select="$document" />
          <xsl:with-param name="rId" select="@r:id" />
        </xsl:call-template>
      </xsl:if>
    </draw:image>
  </xsl:template>

  <!--
  Summary: Converts textbox shapes
  Author: Clever Age
  -->
  <!-- Sona : Removed as drawing a frame is not required-->
  <!--<xsl:template match="v:shape[v:textbox]">
    <xsl:if test="@type='#_x0000_t202'">
    <draw:frame>
      <xsl:call-template name="InsertCommonShapeProperties">
        <xsl:with-param name="shape" select="." />
      </xsl:call-template>
      <xsl:call-template name="InsertShapeZindexAttribute" />

      <xsl:apply-templates />
       -->
  <!--some of the shape types must be in odf draw:frame even if they are outside of v:shape in oox-->
  <!--
      <xsl:apply-templates select="self::node()/following-sibling::node()[1]" mode="draw:frame" />
    </draw:frame>
    </xsl:if>
  </xsl:template>-->

  <!--Summary: Creates variuos shapes based on the path
      Author: Sona
  -->
  <xsl:template name="GetShape">
    <xsl:param name="shapeTypeId" />
    <xsl:param name="pathId" />
    <xsl:variable name="pathModifier">
      <xsl:value-of select="@adj"/>
    </xsl:variable>
    <xsl:variable name="shapeStyle" select="./@style"/>
    <xsl:choose>
      <!--sonata: Free form shapes -->
      <xsl:when test="$pathId !='' and $shapeTypeId !=''">
        <xsl:variable name="EnhanceGeometry">
          <xsl:for-each select="key('shapeTypeById', $shapeTypeId)[1]">
            <xsl:call-template name="CreateEnhancePath">
              <xsl:with-param name="pathModifier" select="$pathModifier"/>
              <xsl:with-param name="shapeStyle" select="$shapeStyle"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:variable>
        <draw:custom-shape draw:style-name="{concat('ooc-NCNameFromString', '-oop-', concat(@id,generate-id(./parent::node())), '-ooe')}">
          <xsl:call-template name="InsertAnchorTypeAttribute" />
          <xsl:call-template name="InsertShapeWidth" />
          <xsl:call-template name="InsertShapeHeight" />
          <xsl:call-template name="InsertshapeAbsolutePos" />
          <xsl:call-template name="InsertShapeZindexAttribute" />
          <xsl:call-template name="InsertAlternativeTextElement" />
          <xsl:apply-templates select="v:textbox" >
            <xsl:with-param name="shapetype" select="'isosceles-triangle'" />
          </xsl:apply-templates >
          <xsl:copy-of select="$EnhanceGeometry"/>

        </draw:custom-shape>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="enhanceGeometry">
          <xsl:for-each select="key('shapeTypeById', $shapeTypeId)[1]">
            <xsl:call-template name="CreateEnhancePath">
              <xsl:with-param name="pathModifier" select="$pathModifier" />
            </xsl:call-template>
          </xsl:for-each>
        </xsl:variable>
        <draw:custom-shape draw:style-name="{concat('ooc-NCNameFromString', '-oop-', concat(@id,generate-id(./parent::node())), '-ooe')}">
          <xsl:call-template name="InsertAnchorTypeAttribute" />
          <xsl:call-template name="InsertShapeWidth" />
          <xsl:call-template name="InsertShapeHeight" />
          <xsl:call-template name="InsertshapeAbsolutePos" />
          <xsl:call-template name="InsertShapeZindexAttribute" />
          <xsl:call-template name="InsertAlternativeTextElement" />
          <xsl:apply-templates select="v:textbox" >
            <xsl:with-param name="shapetype" select="'isosceles-triangle'"/>
          </xsl:apply-templates >
          <xsl:choose>
            <xsl:when test="@path">
              <xsl:call-template name="CreateEnhancePath">
                <xsl:with-param name="pathModifier">
                  <xsl:value-of select="$pathModifier"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="$enhanceGeometry"/>
            </xsl:otherwise>
          </xsl:choose>
        </draw:custom-shape>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="CreateEnhancePath">
    <xsl:param name="pathModifier"/>
    <xsl:param name="shapeStyle"/>
    <draw:enhanced-geometry draw:type="non-primitive" >
      <xsl:attribute name="svg:viewBox">
        <xsl:value-of select="concat('0 0 ',translate(@coordsize,',',' '))"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="@adj">
          <xsl:attribute name="draw:modifiers">
            <xsl:value-of select="concat('ooc-Wordshapes-draw-modifier-oop-',@adj, '-ooe')"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="$pathModifier !=''">
          <xsl:attribute name="draw:modifiers">
            <xsl:value-of select="concat('ooc-Wordshapes-draw-modifier-oop-',$pathModifier, '-ooe')"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:attribute name="draw:enhanced-path">
        <xsl:value-of select="concat('ooc-WordshapesEnhance-Path-oop-',@path, '-ooe')"/>
      </xsl:attribute>
      <xsl:if test="contains($shapeStyle,'flip')">
        <xsl:variable name="var_flipH">
          <xsl:choose>
            <xsl:when test="contains($shapeStyle,'flip:x y')">
              <xsl:value-of select="'1'" />
            </xsl:when>
            <xsl:when test="contains($shapeStyle,'flip:x')">
              <xsl:value-of select="'1'" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'0'" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="var_flipV">
          <xsl:choose>
            <xsl:when test="contains($shapeStyle,'flip:x y')">
              <xsl:value-of select="'1'" />
            </xsl:when>
            <xsl:when test="contains($shapeStyle,'flip:y')">
              <xsl:value-of select="'1'" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'0'" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="tmpFlipwitoutRotation">
          <xsl:with-param name="flipH" select="$var_flipH"/>
          <xsl:with-param name="flipV" select="$var_flipV"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="v:formulas/v:f">
        <xsl:for-each select="v:formulas/v:f">
          <draw:equation>
            <xsl:attribute name="draw:name">
              <xsl:value-of select="concat('f',position()-1)"/>
            </xsl:attribute>
            <xsl:attribute name="draw:formula">
              <xsl:value-of select="concat('ooc-WordshapesFormula-oop-',@eqn,'-oop-',parent::node()/parent::node()/@coordsize, '-ooe')"/>
            </xsl:attribute>
          </draw:equation>
        </xsl:for-each>
      </xsl:if>

      <!--<draw:handle draw:handle-position="$0 top" draw:handle-range-x-minimum="0" draw:handle-range-x-maximum="21600"/>-->
    </draw:enhanced-geometry>
  </xsl:template>
  <!--
  Summary: Template writes rectangles/lines.
  Author: Clever Age
  -->
  <xsl:template match="v:rect|v:line|v:shape|v:oval|v:roundrect">
    <!-- version 1.1-->
    <xsl:choose>
      <!--<xsl:when test=".//w:drawing"> -->
      <!--If picture inside any shape is present ignore the shape for conversion since it is causing a crash in OOo.-->
      <!-- </xsl:when>-->
      <xsl:when test="v:imagedata/@r:id">
        <xsl:variable name="document">
          <xsl:call-template name="GetDocumentName" />
        </xsl:variable>
        <xsl:call-template name="CopyPictures">
          <xsl:with-param name="document" select="$document" />
          <xsl:with-param name="rId" select="v:imagedata/@r:id" />
        </xsl:call-template>
        <draw:frame draw:style-name="{concat('ooc-NCNameFromString', '-oop-', concat(@id,generate-id(./parent::node())), '-ooe')}">
          <!--TODO-->
          <xsl:attribute name="draw:name">
            <xsl:text>Frame1</xsl:text>
          </xsl:attribute>
          <xsl:call-template name="InsertAnchorTypeAttribute" />
          <xsl:call-template name="InsertShapeWidth" />
          <xsl:call-template name="InsertShapeHeight" />

		  <xsl:variable name="rotation">
		    <xsl:choose>
		      <xsl:when test="substring-before(substring-after(@style,'rotation:'), ';')">
		        <xsl:value-of select="substring-before(substring-after(@style,'rotation:'), ';')" />
		      </xsl:when>
		      <xsl:otherwise>
		        <xsl:value-of select="substring-after(@style,'rotation:')" />
		      </xsl:otherwise>
		    </xsl:choose>
		  </xsl:variable>
		  <xsl:variable name="left2">
		    <xsl:choose>
		      <xsl:when test="substring-before(substring-after(@style,'left:'), ';')">
		        <xsl:value-of select="substring-before(substring-after(@style,'left:'), ';')" />
		      </xsl:when>
		      <xsl:otherwise>
		        <xsl:value-of select="substring-after(@style,'left:')" />
		      </xsl:otherwise>
		    </xsl:choose>
		  </xsl:variable>
		  <xsl:variable name="width">
		    <xsl:choose>
		      <xsl:when test="substring-before(substring-after(@style,'width:'), ';')">
		        <xsl:value-of select="substring-before(substring-after(@style,'width:'), ';')" />
		      </xsl:when>
		      <xsl:otherwise>
		        <xsl:value-of select="substring-after(@style,'width:')" />
		      </xsl:otherwise>
		    </xsl:choose>
		  </xsl:variable>
		  <xsl:variable name="height">
		    <xsl:choose>
		      <xsl:when test="substring-before(substring-after(@style,'height:'), ';')">
		        <xsl:value-of select="substring-before(substring-after(@style,'height:'), ';')" />
		      </xsl:when>
		      <xsl:otherwise>
		        <xsl:value-of select="substring-after(@style,'height:')" />
		      </xsl:otherwise>
		    </xsl:choose>
		  </xsl:variable>
		  <xsl:variable name="top2">
		    <xsl:choose>
		      <xsl:when test="substring-before(substring-after(@style,'top:'), ';')">
		        <xsl:value-of select="substring-before(substring-after(@style,'top:'), ';')" />
		      </xsl:when>
		      <xsl:otherwise>
		        <xsl:value-of select="substring-after(@style,'top:')" />
		      </xsl:otherwise>
		    </xsl:choose>
		  </xsl:variable>

          <xsl:variable name="left">
			<xsl:choose>
			  <xsl:when test="contains($left2+$width,'cm')">
				<xsl:value-of select="concat(number(substring-before($left2+$width, 'cm')) * 1.0, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($left2+$width,'mm')">
				<xsl:value-of select="concat(number(substring-before($left2+$width, 'mm')) * 0.1, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($left2+$width,'in')">
				<xsl:value-of select="concat(number(substring-before($left2+$width, 'in')) * 2.54, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($left2+$width,'pt')">
				<xsl:value-of select="concat(number(substring-before($left2+$width, 'pt')) * 2.54 div 72.0, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($left2+$width,'twip')">
				<xsl:value-of select="concat(number(substring-before($left2+$width, 'twip')) * 2.54 div 1440, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($left2+$width,'pica')">
				<xsl:value-of select="concat(number(substring-before($left2+$width, 'pica')) * 2.54 div 6.0, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($left2+$width,'dpt')">
				<xsl:value-of select="concat(number(substring-before($left2+$width, 'dpt')) * 2.54 div 72.0, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($left2+$width,'px')">
				<xsl:value-of select="concat(number(substring-before($left2+$width, 'px')) * 2.54 div 96.0, 'cm')" />
			  </xsl:when>
			  <xsl:otherwise>
				<xsl:value-of select="concat(number(substring-before($left2+$width, 'twip')) * 2.54 div 1440, 'cm')" />
			  </xsl:otherwise>
			</xsl:choose>
		  </xsl:variable>
		  <xsl:variable name="top">
			<xsl:choose>
			  <xsl:when test="contains($top2+$height,'cm')">
				<xsl:value-of select="concat(number(substring-before($top2+$height, 'cm')) * 1.0, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($top2+$height,'mm')">
				<xsl:value-of select="concat(number(substring-before($top2+$height, 'mm')) * 0.1, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($top2+$height,'in')">
				<xsl:value-of select="concat(number(substring-before($top2+$height, 'in')) * 2.54, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($top2+$height,'pt')">
				<xsl:value-of select="concat(number(substring-before($top2+$height, 'pt')) * 2.54 div 72.0, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($top2+$height,'twip')">
				<xsl:value-of select="concat(number(substring-before($top2+$height, 'twip')) * 2.54 div 1440, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($top2+$height,'pica')">
				<xsl:value-of select="concat(number(substring-before($top2+$height, 'pica')) * 2.54 div 6.0, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($top2+$height,'dpt')">
				<xsl:value-of select="concat(number(substring-before($top2+$height, 'dpt')) * 2.54 div 72.0, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($top2+$height,'px')">
				<xsl:value-of select="concat(number(substring-before($top2+$height, 'px')) * 2.54 div 96.0, 'cm')" />
			  </xsl:when>
			  <xsl:otherwise>
				<xsl:value-of select="concat(number(substring-before($top2+$height, 'twip')) * 2.54 div 1440, 'cm')" />
			  </xsl:otherwise>
			</xsl:choose>
		  </xsl:variable>
		  <xsl:variable name="leftcm">
			<xsl:choose>
			  <xsl:when test="contains($left2,'cm')">
				<xsl:value-of select="concat(number(substring-before($left2, 'cm')) * 1.0, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($left2,'mm')">
				<xsl:value-of select="concat(number(substring-before($left2, 'mm')) * 0.1, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($left2,'in')">
				<xsl:value-of select="concat(number(substring-before($left2, 'in')) * 2.54, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($left2,'pt')">
				<xsl:value-of select="concat(number(substring-before($left2, 'pt')) * 2.54 div 72.0, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($left2,'twip')">
				<xsl:value-of select="concat(number(substring-before($left2, 'twip')) * 2.54 div 1440, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($left2,'pica')">
				<xsl:value-of select="concat(number(substring-before($left2, 'pica')) * 2.54 div 6.0, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($left2,'dpt')">
				<xsl:value-of select="concat(number(substring-before($left2, 'dpt')) * 2.54 div 72.0, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($left2,'px')">
				<xsl:value-of select="concat(number(substring-before($left2, 'px')) * 2.54 div 96.0, 'cm')" />
			  </xsl:when>
			  <xsl:otherwise>
				<xsl:value-of select="concat(number(substring-before($left2, 'twip')) * 2.54 div 1440, 'cm')" />
			  </xsl:otherwise>
			</xsl:choose>
		  </xsl:variable>
		  <xsl:variable name="topcm">
			<xsl:choose>
			  <xsl:when test="contains($top2,'cm')">
				<xsl:value-of select="concat(number(substring-before($top2, 'cm')) * 1.0, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($top2,'mm')">
				<xsl:value-of select="concat(number(substring-before($top2, 'mm')) * 0.1, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($top2,'in')">
				<xsl:value-of select="concat(number(substring-before($top2, 'in')) * 2.54, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($top2,'pt')">
				<xsl:value-of select="concat(number(substring-before($top2, 'pt')) * 2.54 div 72.0, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($top2,'twip')">
				<xsl:value-of select="concat(number(substring-before($top2, 'twip')) * 2.54 div 1440, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($top2,'pica')">
				<xsl:value-of select="concat(number(substring-before($top2, 'pica')) * 2.54 div 6.0, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($top2,'dpt')">
				<xsl:value-of select="concat(number(substring-before($top2, 'dpt')) * 2.54 div 72.0, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($top2,'px')">
				<xsl:value-of select="concat(number(substring-before($top2, 'px')) * 2.54 div 96.0, 'cm')" />
			  </xsl:when>
			  <xsl:otherwise>
				<xsl:value-of select="concat(number(substring-before($top2, 'twip')) * 2.54 div 1440, 'cm')" />
			  </xsl:otherwise>
			</xsl:choose>
		  </xsl:variable>

          <xsl:choose>
            <xsl:when test="$rotation != ''">
              <xsl:attribute name="draw:transform">
                <xsl:choose>
                  <xsl:when test="$rotation='270'">
                    <xsl:value-of select="concat('rotate (1.5707963267946) translate(',$leftcm,' ',$top,')')" />
                  </xsl:when>
                  <xsl:when test="$rotation='180'">
                    <xsl:value-of select="concat('rotate (3.1415926535892) translate(',$left,' ',$top,')')" />
                  </xsl:when>
                  <xsl:when test="$rotation='90'">
                    <xsl:value-of select="concat('rotate (-1.57079632679579) translate(',$left,' ',$topcm,')')" />
                  </xsl:when>
                </xsl:choose>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="InsertshapeAbsolutePos" />
            </xsl:otherwise>
          </xsl:choose>
          <!-- image href from relationships-->
          <draw:image xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad">
            <xsl:if test="key('Part', concat('word/_rels/',$document,'.rels'))">
              <xsl:call-template name="InsertImageHref">
                <xsl:with-param name="document" select="$document" />
                <xsl:with-param name="rId">
                  <xsl:value-of select="v:imagedata/@r:id" />
                </xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </draw:image>
        </draw:frame>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="self::v:line">
            <draw:line draw:style-name="{concat('ooc-NCNameFromString', '-oop-', concat(@id,generate-id(./parent::node())), '-ooe')}">
              <!--TODO-->
              <xsl:attribute name="draw:name">
                <xsl:text>Frame1</xsl:text>
              </xsl:attribute>
              <xsl:variable name="flip">
                <xsl:if test="contains(@style,'flip')">
                  <xsl:value-of select="substring-before(substring-after(@style,'flip:'),';')" />
                </xsl:if>
              </xsl:variable>
              <xsl:call-template name="InsertAnchorTypeAttribute" />
              <xsl:call-template name="InsertShapeZindexAttribute" />
              <xsl:call-template name="InsertLinePos1">
                <xsl:with-param name="flip" select="$flip" />
              </xsl:call-template>
              <xsl:call-template name="InsertLinePos2">
                <xsl:with-param name="flip" select="$flip" />
              </xsl:call-template>
              <xsl:call-template name="InsertAlternativeTextElement" />
            </draw:line>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <!--Rectangle -->
              <xsl:when  test="self::v:rect" >
                <!--added by yeswanth.s : converting rectangle with text into frame-->
                <xsl:choose>
                  <xsl:when test="./v:textbox">
                    <draw:frame draw:name="Frame1"
                                draw:style-name="{concat('ooc-NCNameFromString', '-oop-', concat(@id,generate-id(./parent::node())), '-ooe')}">
                      <xsl:call-template name="InsertAnchorTypeAttribute" />
                      <xsl:call-template name="InsertShapeWidth" />
                      <xsl:call-template name="InsertShapeHeight" />
                      <xsl:call-template name="InsertshapeAbsolutePos" />
                      <xsl:call-template name="InsertShapeZindexAttribute" />
                      <xsl:call-template name="InsertTextBoxRelSizeAttributes" />
                      <draw:text-box>
                        <xsl:apply-templates select="v:textbox" >
                          <xsl:with-param name="shapetype" select="'Rectangle'" />
                        </xsl:apply-templates >
                      </draw:text-box>
                    </draw:frame>
                  </xsl:when>
                  <xsl:otherwise>
                    <draw:rect draw:style-name="{concat('ooc-NCNameFromString', '-oop-', concat(parent::node()/v:rect/@id,generate-id(./parent::node())), '-ooe')}">
                      <!--TODO-->
                      <!-- Sona Resolved Defect #1989834-->
                      <xsl:attribute name="draw:name">
                        <xsl:text>Frame1</xsl:text>
                      </xsl:attribute>

                      <xsl:call-template name="InsertAnchorTypeAttribute" />
                      <xsl:call-template name="InsertShapeWidth" />
                      <xsl:call-template name="InsertShapeHeight" />
                      <xsl:call-template name="InsertshapeAbsolutePos" />
                      <xsl:call-template name="InsertShapeZindexAttribute" />
                      <xsl:call-template name="InsertAlternativeTextElement" />
                      <xsl:apply-templates select="v:textbox">
                        <xsl:with-param name="shapetype" select="'Rectangle'" />
                      </xsl:apply-templates >
                      <!--<xsl:call-template name="InsertParagraphToFrame" />-->
                      <!--</xsl:for-each>-->
                    </draw:rect>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <!-- Oval -->
              <xsl:when  test="self::v:oval">
                <draw:custom-shape draw:style-name="{concat('ooc-NCNameFromString', '-oop-', concat(@id,generate-id(./parent::node())), '-ooe')}">
                  <xsl:call-template name="InsertAnchorTypeAttribute" />
                  <xsl:call-template name="InsertShapeWidth" />
                  <xsl:call-template name="InsertShapeHeight" />
                  <xsl:call-template name="InsertshapeAbsolutePos" />
                  <xsl:call-template name="InsertShapeZindexAttribute" />
                  <xsl:call-template name="InsertAlternativeTextElement" />
                  <xsl:apply-templates select="v:textbox" >
                    <xsl:with-param name="shapetype" select="'Oval'" />
                  </xsl:apply-templates >
                  <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 3160 3160 0 10800 3160 18440 10800 21600 18440 18440 21600 10800 18440 3160" draw:text-areas="3200 3200 18400 18400" draw:type="ellipse" />
                </draw:custom-shape>
              </xsl:when>
              <!-- Rounded Rectangle -->
              <xsl:when  test="self::v:roundrect">
                <draw:custom-shape draw:style-name="{concat('ooc-NCNameFromString', '-oop-', concat(@id,generate-id(./parent::node())), '-ooe')}">
                  <xsl:call-template name="InsertAnchorTypeAttribute" />
                  <xsl:call-template name="InsertShapeWidth" />
                  <xsl:call-template name="InsertShapeHeight" />
                  <xsl:call-template name="InsertshapeAbsolutePos" />
                  <xsl:call-template name="InsertShapeZindexAttribute" />
                  <xsl:call-template name="InsertAlternativeTextElement" />
                  <xsl:apply-templates select="v:textbox" >
                    <xsl:with-param name="shapetype" select="'Rounded Rectangle'" />
                  </xsl:apply-templates >
                  <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:path-stretchpoint-x="10800" draw:path-stretchpoint-y="10800" draw:text-areas="?f3 ?f4 ?f5 ?f6" draw:type="round-rectangle" draw:modifiers="3600" draw:enhanced-path="M ?f7 0 X 0 ?f8 L 0 ?f9 Y ?f7 21600 L ?f10 21600 X 21600 ?f9 L 21600 ?f8 Y ?f10 0 Z N">
                    <draw:equation draw:name="f0" draw:formula="45" />
                    <draw:equation draw:name="f1" draw:formula="$0 *sin(?f0 *(pi/180))" />
                    <draw:equation draw:name="f2" draw:formula="?f1 *3163/7636" />
                    <draw:equation draw:name="f3" draw:formula="left+?f2 " />
                    <draw:equation draw:name="f4" draw:formula="top+?f2 " />
                    <draw:equation draw:name="f5" draw:formula="right-?f2 " />
                    <draw:equation draw:name="f6" draw:formula="bottom-?f2 " />
                    <draw:equation draw:name="f7" draw:formula="left+$0 " />
                    <draw:equation draw:name="f8" draw:formula="top+$0 " />
                    <draw:equation draw:name="f9" draw:formula="bottom-$0 " />
                    <draw:equation draw:name="f10" draw:formula="right-$0 " />
                    <draw:handle draw:handle-position="$0 top" draw:handle-switched="true" draw:handle-range-x-minimum="0" draw:handle-range-x-maximum="10800" />
                  </draw:enhanced-geometry>

                </draw:custom-shape>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="shapeTypeId" select="substring-after(@type,'#')" />
                <xsl:variable name="pathId">
                  <xsl:choose>
                    <xsl:when test="@path">
                      <xsl:value-of select="@path" />
                    </xsl:when>
                    <xsl:when test="$shapeTypeId">
                      <xsl:value-of select="key('shapeTypeById', $shapeTypeId)[1]/@path" />
                    </xsl:when>
                  </xsl:choose>
                </xsl:variable>

                <xsl:choose>
                  <xsl:when test="$pathId='m,l,21600r21600,l21600,xe' 
                                  or $pathId='m,l,21600l21600,21600l21600,xe'
                                  or $pathId='m0,0l0,21600l21600,21600l21600,0xe'
                                  or $pathId=''">
                    <draw:frame draw:name="Frame1"
                              draw:style-name="{concat('ooc-NCNameFromString', '-oop-', concat(@id,generate-id(./parent::node())), '-ooe')}">
                      <xsl:call-template name="InsertAnchorTypeAttribute" />
                      <xsl:call-template name="InsertShapeWidth" />
                      <xsl:call-template name="InsertShapeHeight" />
                      <xsl:call-template name="InsertshapeAbsolutePos" />
                      <xsl:call-template name="InsertShapeZindexAttribute" />
                      <xsl:call-template name="InsertTextBoxRelSizeAttributes" />
                      
                      <draw:text-box>
                        <xsl:apply-templates select="v:textbox" >
                          <xsl:with-param name="shapetype" select="'TextBox'" />
                        </xsl:apply-templates >
                      </draw:text-box>
                    </draw:frame>
                  </xsl:when>
                  <!--RefNo-1:To avoid canvas-->
                  <!--<xsl:when test="$pathId='m@4@5l@4@11@9@11@9@5xe'">
                  </xsl:when>-->
                  <xsl:otherwise>
                    <xsl:call-template name="GetShape">
                      <xsl:with-param name="currentShape" select="." />
                      <xsl:with-param name="shapeTypeId" select="$shapeTypeId"></xsl:with-param>
                      <xsl:with-param name="pathId" select="$pathId"></xsl:with-param>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
  makz: There is no need to generate a style for every v:rect 
  because there is already a style generates for the rect's pict
  
  <xsl:template match="v:rect|v:line" mode="automaticpict">
    <style:style>
    <xsl:attribute name="style:name">
    <xsl:call-template name="GenerateStyleName">
    <xsl:with-param name="node" select="self::node()" />
    </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="style:parent-style-name">
    <xsl:text>Graphics</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="style:family">
    <xsl:text>graphic</xsl:text>
    </xsl:attribute>
    <style:graphic-properties>
    <xsl:choose>
    <xsl:when test="v:imagedata">
    </xsl:when>
    </xsl:choose>
    <xsl:call-template name="InsertShapeShadow" />
    </style:graphic-properties>
    </style:style>
    <xsl:apply-templates mode="automaticpict" />
  </xsl:template>
  -->

  <!--
  Summary: Writes Texture,Picture fill style
  Author: Vipul
  Date: 6.09.2008
  -->
  <xsl:template match="v:fill[@type='tile' or @type='pattern' or @type='frame']" mode="officestyles">
    <xsl:variable name="parentShape" select="parent::node()" />
    <xsl:variable name="PicFillName" select="concat('BitmapFill_', generate-id(.))" />
    <xsl:variable name="PicrelId" select="parent::node()/v:fill/@r:id" />
    <xsl:variable name="PicfileSource">
      <xsl:for-each select="key('Part', 'word/_rels/document.xml.rels')/rels:Relationships/rels:Relationship[@Id=$PicrelId]/@Target">
        <xsl:value-of select="." />
      </xsl:for-each>
    </xsl:variable>
    <draw:fill-image xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad"
                     draw:name="{concat('ooc-NCNameFromString', '-oop-', $PicFillName, '-ooe')}"
                     draw:display-name="{$PicFillName}"
                     xlink:href="{concat('Pictures',substring-after($PicfileSource,'media'))}" />

    <pzip:copy pzip:source="{concat('word/',$PicfileSource)}" pzip:target="{concat('Pictures',substring-after($PicfileSource,'media'))}" />


  </xsl:template>
  <!--
  Summary: Writes gradient fill style
  Author: makz
  Date: 6.11.2007
  -->
  <xsl:template match="v:fill[@type='gradient']" mode="officestyles">
    <xsl:variable name="parentShape" select="parent::node()" />
    <xsl:variable name="gradientName" select="concat('Gradient_', generate-id(.))" />
    <xsl:variable name="focusValue" select="substring-before(@focus, '%')" />

    <draw:gradient draw:name="{concat('ooc-NCNameFromString', '-oop-', $gradientName, '-ooe')}"
                   draw:display-name="{$gradientName}">
      <xsl:attribute name="draw:style">
        <xsl:choose>
          <xsl:when test="not($focusValue) or $focusValue='100' or $focusValue='-100'">
            <xsl:text>linear</xsl:text>
          </xsl:when>
          <xsl:when test="$focusValue='50' or $focusValue='-50'">
            <xsl:text>axial</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>linear</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="draw:start-color">
        <xsl:choose>
          <xsl:when test="(@rotate='t' or @rotate='true' or @rotate='1') and $focusValue>0">
            <xsl:call-template name="InsertEndColor" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="InsertStartColor" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="draw:end-color">
        <xsl:choose>
          <xsl:when test="(@rotate='t' or @rotate='true' or @rotate='1') and $focusValue>0">
            <xsl:call-template name="InsertStartColor" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="InsertEndColor" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="draw:start-intensity">
        <xsl:choose>
          <xsl:when test="@opacity">
            <xsl:choose>
              <xsl:when test="contains(@opacity,'f')">
                <xsl:value-of select="concat(round((number(substring-before(@opacity,'f')) div 65536) * 100), '%')" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat(round(@opacity * 100), '%')" />
              </xsl:otherwise>
            </xsl:choose>
            <!-- calculate opacity -->
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>100%</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="draw:end-intensity">
        <xsl:choose>
          <xsl:when test="@o:opacity2">

            <xsl:choose>
              <xsl:when test="contains(@o:opacity2,'f')">
                <xsl:value-of select="concat(round((number(substring-before(@o:opacity2,'f')) div 65536) * 100), '%')" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat(round(@o:opacity2 * 100), '%')" />
              </xsl:otherwise>
            </xsl:choose>
            <!-- calculate opacity -->
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>100%</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="draw:angle">
        <xsl:choose>
          <xsl:when test="@angle">
            <xsl:value-of select="@angle" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>0</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="draw:border">0%</xsl:attribute>
    </draw:gradient>
  </xsl:template>

  <!--
  Summary: Hyperlinks in shapes
  Author: Clever Age
  -->
  <xsl:template match="w:pict[v:shape/@href]">
    <draw:a xlink:type="simple" xlink:href="{concat('ooc-UriFromPath', '-oop-', v:shape/@href, '-ooe')}">
      <xsl:apply-templates />
    </draw:a>
  </xsl:template>

  <!--
  Summary: text watermark feedback
  Author: Clever Age
  -->
  <xsl:template match="w:pict[contains(v:shape/@id,'WaterMark')]">
    <xsl:if test="v:shape/v:textpath">
      <xsl:message terminate="no">translation.oox2odf.background.textWatermark</xsl:message>
    </xsl:if>
  </xsl:template>

  <!-- 
  Summary: Template writes text boxes.
  Author: Clever Age
  -->
  <xsl:template match="v:textbox">
    <xsl:param name="shapetype" />
    <xsl:if test="parent::v:stroke/@dashstyle">
      <xsl:message terminate="no">translation.oox2odf.textbox.boder.dashed</xsl:message>
    </xsl:if>
    <xsl:if test="contains(parent::node()/@style, 'v-text-anchor')">
      <xsl:message terminate="no">translation.odf2oox.valignInsideTextbox</xsl:message>
    </xsl:if>
    <xsl:if test="$shapetype!='' ">
      <!-- shapes do not have fo:min-height and fo:min-width attributes -->
      <!--<xsl:call-template name="InsertMinHeightAttribute" />-->
      <xsl:apply-templates select="w:txbxContent/child::node()" />
    </xsl:if>
    <xsl:if test="$shapetype=''">
      <draw:text-box>
        <xsl:call-template name="InsertMinHeightAttribute" />
        <xsl:apply-templates select="w:txbxContent/child::node()" />
      </draw:text-box>
    </xsl:if>
  </xsl:template>

  <!--
  Summary:
  Author: Clever Age
  -->
  <xsl:template match="w:pict">
    <xsl:choose>
      <xsl:when test="v:group">
        <draw:g draw:style-name="{concat('ooc-NCNameFromString', '-oop-', concat(@id,generate-id(./parent::node())), '-ooe')}">
          <xsl:call-template name="InsertAnchorTypeAttribute">
            <xsl:with-param name="shape" select="v:group" />
          </xsl:call-template>
          <xsl:apply-templates />
        </draw:g>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- 
  Summary: inserts horizontal ruler as image
  Author: Clever Age
  -->
  <xsl:template match="v:imagedata[not(../../o:OLEObject) and @r:id]">
    <xsl:variable name="document">
      <xsl:call-template name="GetDocumentName" />
    </xsl:variable>
    <xsl:call-template name="CopyPictures">
      <xsl:with-param name="document" select="$document" />
      <xsl:with-param name="rId" select="@r:id" />
    </xsl:call-template>
    <draw:image xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad">
      <xsl:if test="key('Part', concat('word/_rels/',$document,'.rels'))">
        <xsl:call-template name="InsertImageHref">
          <xsl:with-param name="document" select="$document" />
          <xsl:with-param name="rId" select="@r:id" />
        </xsl:call-template>
      </xsl:if>
    </draw:image>
  </xsl:template>

  <!-- 
  Summary: Writes the style of PICT's
  Author: Clever Age
  -->
  <xsl:template match="w:pict[not(o:OLEObject)]" mode="automaticpict">
    <xsl:variable name="vmlElement" select="v:shape | v:rect | v:line | v:group | v:oval | v:roundrect" />

    <xsl:if test="$vmlElement[1]">
      <style:style style:family="graphic">
        <!--Sona-->
        <xsl:attribute name="style:name">
          <xsl:choose>
            <xsl:when test="$vmlElement[1]">
              <!--added by chhavi-->
              <xsl:value-of  select="concat('ooc-NCNameFromString', '-oop-', concat($vmlElement[1]/@id,generate-id()), '-ooe')" />
              <!--end here-->
              <!--<xsl:value-of  select="v:shape/@id" />-->
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', generate-id($vmlElement), '-ooe')" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <!--code added by yeswanth.s : bug# 1838676-->
        <xsl:if test="$vmlElement[1]/v:textbox">
          <xsl:attribute name="style:parent-style-name">
            <xsl:text>Frame</xsl:text>
          </xsl:attribute>
        </xsl:if>
        <!--end-->
        <!--in Word there are no parent style for image - make default Graphics in OO -->
        <!--<xsl:attribute name="style:parent-style-name">
        <xsl:text>Graphics</xsl:text>
        <xsl:value-of select="w:tblStyle/@w:val" />
      </xsl:attribute>-->

        <style:graphic-properties>
          <xsl:call-template name="InsertShapeStyleProperties">
            <xsl:with-param name="shape" select="$vmlElement" />
          </xsl:call-template>
        </style:graphic-properties>
      </style:style>
    </xsl:if>
    <!--Start of RefNo-1:Added style for the shapes in the group -->
    <xsl:if test="$vmlElement[1]/v:shape">
      <xsl:for-each select ="$vmlElement[1]/v:shape">
        <style:style style:family="graphic">          
          <xsl:attribute name="style:name">
            <xsl:value-of  select="concat('ooc-NCNameFromString', '-oop-', concat(@id,generate-id(./parent::node())), '-ooe')" />
          </xsl:attribute>          
          <xsl:if test="v:textbox">
            <xsl:attribute name="style:parent-style-name">
              <xsl:text>Frame</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <style:graphic-properties>
            <xsl:call-template name="InsertShapeStyleProperties">
              <xsl:with-param name="shape" select="." />
            </xsl:call-template>
          </style:graphic-properties>
        </style:style>
      </xsl:for-each>
    </xsl:if>
    <!--End of RefNo-1-->
    <!-- Sona: #2014221 and Arrow Feature Continuation-->
    <!--<xsl:call-template name="getDashType">
			<xsl:with-param name="shape" select="$vmlElement" />
		</xsl:call-template>
		<xsl:call-template name="InsertArrowStyle">
			<xsl:with-param name="shape" select="$vmlElement" />
		</xsl:call-template>-->
    <xsl:apply-templates mode="automaticpict" />
  </xsl:template>

  <!-- 
  Summary: don't process text when in automatic pict mode
  Author: Clever Age
  -->
  <xsl:template match="w:t" mode="automaticpict" />

  <!--
  Summary:
  Author: Clever Age
  -->
  <xsl:template match="o:extrusion">
    <xsl:message terminate="no">translation.oox2odf.shape.3dEffect</xsl:message>
  </xsl:template>

  <!-- 
  *************************************************************************
  CALLED TEMPLATES
  *************************************************************************
  -->

  <!--
  Summary: Inserts the Start color of a gradient fill
  Author: makz (DIaLOGIKa)
  Date: 6.11.2007
  -->
  <xsl:template name="InsertStartColor">
    <xsl:variable name="parentShape" select="parent::node()" />
    <xsl:choose>
      <xsl:when test="@color">
        <xsl:call-template name="InsertColor">
          <xsl:with-param name="color" select="@color" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$parentShape/@fillcolor">
        <xsl:call-template name="InsertColor">
          <xsl:with-param name="color" select="$parentShape/@fillcolor" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>#ffffff</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
  Summary: Inserts the End color of a gradient fill
  Author: makz (DIaLOGIKa)
  Date: 6.11.2007
  -->
  <xsl:template name="InsertEndColor">
    <xsl:variable name="parentShape" select="parent::node()" />
    <xsl:choose>
      <xsl:when test="@color2">
        <xsl:call-template name="InsertColor">
          <xsl:with-param name="color" select="@color2" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>#ffffff</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
  Summary:  Inserts the properties of a draw shape's style.
  Author:   CleverAge
  Params:   shape: The VML shape
  -->
  <xsl:template name="InsertShapeStyleProperties">
    <xsl:param name="shape" select="." />

    <!--<xsl:if test="parent::node()[name()='v:group']">
         TO DO v:shapes in v:group 
      </xsl:if>-->
    <xsl:call-template name="InsertShapeWrap">
      <xsl:with-param name="shape" select="$shape" />
    </xsl:call-template>
    <xsl:call-template name="InsertShapeFromTextDistance">
      <xsl:with-param name="shape" select="$shape" />
    </xsl:call-template>
    <xsl:call-template name="InsertShapeBorders">
      <xsl:with-param name="shape" select="$shape" />
    </xsl:call-template>
    <xsl:call-template name="InsertShapeAutomaticWidth">
      <xsl:with-param name="shape" select="$shape" />
    </xsl:call-template>
    <xsl:call-template name="InsertShapeHorizontalPos">
      <xsl:with-param name="shape" select="$shape" />
    </xsl:call-template>
    <xsl:call-template name="InsertShapeVerticalPos">
      <xsl:with-param name="shape" select="$shape" />
    </xsl:call-template>
    <xsl:call-template name="InsertShapeFlowWithText">
      <xsl:with-param name="shape" select="$shape" />
    </xsl:call-template>
    <xsl:call-template name="InsertShapeBackgroundColor">
      <xsl:with-param name="shape" select="$shape" />
    </xsl:call-template>
    <xsl:call-template name="InsertShapeZindexAttribute">
      <xsl:with-param name="shape" select="$shape" />
    </xsl:call-template>
    <xsl:call-template name="InsertShapeWrappedParagraphAttribute">
      <!--<xsl:with-param name="shape" select="$shape" />-->
    </xsl:call-template>
    <xsl:call-template name="InsertShapeShadow">
      <xsl:with-param name="shape" select="$shape" />
    </xsl:call-template>
    <!--####prad-->
    <xsl:choose>
      <xsl:when test="contains($shape/v:textbox/@style, 'mso-fit-shape-to-text:t') or contains($shape/v:textbox/@style, 'mso-fit-shape-to-text:true')">
        <xsl:attribute name="draw:auto-grow-height">
          <xsl:value-of select="'true'" />
        </xsl:attribute>
        <xsl:attribute name="draw:auto-grow-width">
          <xsl:value-of select="'false'" />
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="draw:auto-grow-height">
          <xsl:value-of select="'false'" />
        </xsl:attribute>
        <xsl:attribute name="draw:auto-grow-width">
          <xsl:value-of select="'false'" />
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <!-- Sona : Arrow Styles -->
    <xsl:call-template name="InsertLineArrowTemplateAttributes">
      <xsl:with-param name="shape" select="$shape" />
    </xsl:call-template>

    <xsl:for-each select="$shape/v:textbox">
      <xsl:call-template name="InsertTexboxTextDirectionAttribute" />
      <xsl:call-template name="InsertTextBoxPaddingAttributes" />
    </xsl:for-each>
    <!-- Sona: Gradient for Frame-->
    <xsl:variable name="shapeTypeId" select="substring-after($shape/@type,'#')" />
    <xsl:variable name="pathId">
      <xsl:choose>
        <xsl:when test="@path">
          <xsl:value-of select="@path" />
        </xsl:when>
        <xsl:when test="$shapeTypeId">
          <xsl:value-of select="key('shapeTypeById', $shapeTypeId)[1]/@path" />
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="($pathId='m,l,21600r21600,l21600,xe' or ($shape[name()='v:rect'] and $shape/v:textbox)) and ($shape/v:fill/@type='tile' or $shape/v:fill/@type='pattern' or $shape/v:fill/@type='frame')">
      <xsl:call-template name="InsertGradientFillForFrame">
        <xsl:with-param name="shape" select="$shape"></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Sona: Template for gradient fill for frame-->
  <xsl:template name="InsertGradientFillForFrame">
    <xsl:param name="shape" />

    <xsl:variable name="PicrelId" select="$shape/v:fill/@r:id" />
    <xsl:variable name="PicfileSource">
      <!-- divo:  TODO the original author didn't consider gradient fill in other parts than the main document -->
      <xsl:for-each select="key('Part', 'word/_rels/document.xml.rels')/rels:Relationships/rels:Relationship[@Id=$PicrelId]/@Target">
        <xsl:value-of select="." />
      </xsl:for-each>
    </xsl:variable>
    <style:background-image xlink:type="simple"
                            xlink:show="embed"
                            xlink:actuate="onLoad"
                            xlink:href="{concat('Pictures',substring-after($PicfileSource,'media'))}">
      <xsl:if test="$shape/v:fill[@type='frame']">
        <xsl:attribute name="style:repeat">
          <xsl:value-of select="'stretch'" />
        </xsl:attribute>
      </xsl:if>
    </style:background-image>
    <pzip:copy pzip:source="{concat('word/',$PicfileSource)}" pzip:target="{concat('Pictures',substring-after($PicfileSource,'media'))}" />

  </xsl:template>

  <!-- Sona Template for Arrow Styles-->
  <xsl:template name="InsertLineArrowTemplateAttributes">
    <xsl:param name="shape" />

    <xsl:variable name="actualShape" select="v:shape | v:line" />
    <xsl:if test="$actualShape/v:stroke/@endarrow">
      <xsl:attribute name="draw:marker-end">
        <xsl:call-template name="GetArrowType">
          <xsl:with-param name="arrow" select="$actualShape/v:stroke/@endarrow">
          </xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="draw:marker-end-width">
        <xsl:variable name="weightincm">
          <xsl:choose>
            <xsl:when test="($actualShape/@strokeweight) and ($actualShape/@strokeweight!='')">
              <xsl:call-template name="ConvertToCentimeters">
                <xsl:with-param name="length" select="$actualShape/@strokeweight" />
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="ConvertToCentimeters">
                <xsl:with-param name="length" select="concat($lineWeightDefault,'pt')" />
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="weight">
          <xsl:choose>
            <xsl:when test="($actualShape/@strokeweight) and ($actualShape/@strokeweight!='')">
              <xsl:value-of select="substring-before($actualShape/@strokeweight,'pt')" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$lineWeightDefault" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="GetArrowSize">
          <xsl:with-param name="arrowLength" select="$actualShape/v:stroke/@endarrowlength"></xsl:with-param>
          <xsl:with-param name="arrowWidth" select="$actualShape/v:stroke/@endarrowwidth" />
          <xsl:with-param name="weight" select="$weight" />
          <xsl:with-param name="weightincm" select="substring-before($weightincm,'cm')" />
          <xsl:with-param name="type" select="$actualShape/v:stroke/@endarrow" />
        </xsl:call-template>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="$actualShape/v:stroke/@startarrow">
      <xsl:attribute name="draw:marker-start">
        <xsl:call-template name="GetArrowType">
          <xsl:with-param name="arrow" select="$actualShape/v:stroke/@startarrow">
          </xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="draw:marker-start-width">
        <xsl:variable name="weightincm">
          <xsl:choose>
            <xsl:when test="($actualShape/@strokeweight) and ($actualShape/@strokeweight!='')">
              <xsl:call-template name="ConvertToCentimeters">
                <xsl:with-param name="length" select="$actualShape/@strokeweight" />
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="ConvertToCentimeters">
                <xsl:with-param name="length" select="concat($lineWeightDefault,'pt')" />
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="weight">
          <xsl:choose>
            <xsl:when test="($actualShape/@strokeweight) and ($actualShape/@strokeweight!='')">
              <!-- Sona: Fixed Arrow width defect #2014180-->
              <xsl:value-of select="substring-before($actualShape/@strokeweight,'pt')" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$lineWeightDefault" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="GetArrowSize">
          <xsl:with-param name="arrowLength" select="$actualShape/v:stroke/@startarrowlength"></xsl:with-param>
          <xsl:with-param name="arrowWidth" select="$actualShape/v:stroke/@startarrowwidth" />
          <xsl:with-param name="weight" select="$weight" />
          <xsl:with-param name="weightincm" select="substring-before($weightincm,'cm')" />
          <xsl:with-param name="type" select="$actualShape/v:stroke/@startarrow" />
        </xsl:call-template>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="InsertTexboxTextDirectionAttribute">
    <!-- Sona: Text direction  Defect #1989536-->
    <xsl:if test="contains(@style,'layout-flow:vertical')">
      <xsl:attribute name="style:writing-mode">
        <xsl:text>tb-rl</xsl:text>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="InsertMinHeightAttribute">
    <xsl:param name="textbox" select="." />

	<xsl:variable name="fitToText">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($textbox/@style,'mso-fit-shape-to-text:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($textbox/@style,'mso-fit-shape-to-text:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($textbox/@style,'mso-fit-shape-to-text:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>
    <!-- Sona: wrap and resize-->
    <xsl:if test="$fitToText='t' or $fitToText='true' or (not($textbox/@w:h) and $textbox/@hRule!='exact')">
      <xsl:attribute name="fo:min-height">
        <xsl:choose>
          <xsl:when test="$textbox/@hRule='atLeast'">
            <xsl:value-of select="$textbox/@hRule" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>0cm</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>


  <xsl:template name="InsertShapeWrappedParagraphAttribute">
    <!-- TODO inverstigate when this should not be set-->
    <!-- COMMENT : does not exist in OOX, so default value should be no-limit (rather than 1) -->
    <xsl:attribute name="style:number-wrapped-paragraphs">
      <!--xsl:text>1</xsl:text-->
      <xsl:text>no-limit</xsl:text>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="InsertShapeShadow">
    <xsl:param name="shape" />
    <!-- Sona: Shadow implementation-->
    <xsl:variable name="shapeTypeId" select="substring-after($shape/@type,'#')" />
    <xsl:variable name="pathId">
      <xsl:choose>
        <xsl:when test="@path">
          <xsl:value-of select="@path" />
        </xsl:when>
        <xsl:when test="$shapeTypeId">
          <xsl:value-of select="key('shapeTypeById', $shapeTypeId)[1]/@path" />
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:for-each select="$shape/v:shadow">
      <xsl:choose>
        <xsl:when test="$pathId='m,l,21600r21600,l21600,xe' or ($shape[name()='v:rect'] and $shape/v:textbox)">
          <xsl:attribute name="style:shadow">
            <xsl:choose>
              <xsl:when test="not(@on) or @on = 'false' or @on = 'f' or @on = '0'">none</xsl:when>
              <xsl:otherwise>
                <!-- report lost attributes -->
                <xsl:if test="@opacity">
                  <xsl:message terminate="no">translation.oox2odf.shape.shadow</xsl:message>
                </xsl:if>
                <xsl:if test="@obscured">
                  <xsl:message terminate="no">translation.oox2odf.shape.shadow.obscurity</xsl:message>
                </xsl:if>
                <xsl:if test="@type">
                  <!-- TODO is this a copy & paste error? -->
                  <xsl:message terminate="no">translation.oox2odf.shape.shadow.obscurity</xsl:message>
                </xsl:if>
                <xsl:if test="@matrix">
                  <xsl:message terminate="no">translation.oox2odf.shape.shadow.complexPerspective</xsl:message>
                </xsl:if>
                <!-- compute color -->
                <xsl:variable name="frameShadowColor">
                  <xsl:call-template name="InsertColor">
                    <xsl:with-param name="color">
                      <xsl:choose>
                        <xsl:when test="@color">
                          <xsl:value-of select="@color" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="@color2">
                            <xsl:value-of select="@color2" />
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:with-param>
                  </xsl:call-template>
                  <xsl:text> </xsl:text>
                </xsl:variable>
                <!-- shadow offset -->
                <xsl:variable name="frameShadowDistance">
                  <xsl:choose>
                    <xsl:when test="@offset">
                      <!-- horizontal distance -->
                      <xsl:call-template name="ComputeShadowDistance">
                        <xsl:with-param name="distance" select="substring-before(@offset, ',')" />
                        <xsl:with-param name="origin" select="substring-before(@origin, ',')" />
                        <xsl:with-param name="side">width</xsl:with-param>
                      </xsl:call-template>
                      <xsl:text> </xsl:text>
                      <!-- vertical distance -->
                      <xsl:call-template name="ComputeShadowDistance">
                        <xsl:with-param name="distance" select="substring-after(@offset, ',')" />
                        <xsl:with-param name="origin" select="substring-after(@origin, ',')" />
                        <xsl:with-param name="side">height</xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="@offset2">
                        <xsl:call-template name="ComputeShadowDistance">
                          <xsl:with-param name="distance" select="substring-before(@offset2, ',')" />
                          <xsl:with-param name="origin" select="substring-before(@origin, ',')" />
                          <xsl:with-param name="side">width</xsl:with-param>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                        <xsl:call-template name="ComputeShadowDistance">
                          <xsl:with-param name="distance" select="substring-after(@offset2, ',')" />
                          <xsl:with-param name="origin" select="substring-after(@origin, ',')" />
                          <xsl:with-param name="side">height</xsl:with-param>
                        </xsl:call-template>
                      </xsl:if>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="concat($frameShadowColor,$frameShadowDistance)" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="draw:shadow">
            <xsl:choose>
              <xsl:when test="not(@on) or @on = 'false' or @on = 'f' or @on = '0'">hidden</xsl:when>
              <xsl:otherwise>
                <!-- report lost attributes -->
                <xsl:if test="@opacity">
                  <xsl:message terminate="no">translation.oox2odf.shape.shadow</xsl:message>
                </xsl:if>
                <xsl:if test="@obscured">
                  <xsl:message terminate="no">translation.oox2odf.shape.shadow.obscurity</xsl:message>
                </xsl:if>
                <xsl:if test="@type">
                  <!-- TODO is this a copy & paste error? -->
                  <xsl:message terminate="no">translation.oox2odf.shape.shadow.obscurity</xsl:message>
                </xsl:if>
                <xsl:if test="@matrix">
                  <xsl:message terminate="no">translation.oox2odf.shape.shadow.complexPerspective</xsl:message>
                </xsl:if>
                <xsl:value-of select="'visible'" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="draw:shadow-color">
            <!-- compute color -->
            <xsl:call-template name="InsertColor">
              <xsl:with-param name="color">
                <xsl:choose>
                  <xsl:when test="@color">
                    <xsl:value-of select="@color" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="@color2">
                      <xsl:value-of select="@color2" />
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
            <!--<xsl:text> </xsl:text>-->
          </xsl:attribute>

          <!-- Transperency percentage-->
          <xsl:if test="@opacity">
            <xsl:attribute name="draw:shadow-opacity">
              <xsl:choose>
                <xsl:when test="contains(@opacity,'%')">
                  <xsl:value-of select="@opacity" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat(@opacity*100,'%')" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </xsl:if>

          <!-- shadow offset -->
          <xsl:choose>
            <xsl:when test="@offset">
              <xsl:attribute name="draw:shadow-offset-x">
                <!-- horizontal distance -->
                <xsl:call-template name="ComputeShadowDistance">
                  <xsl:with-param name="distance" select="substring-before(@offset, ',')" />
                  <xsl:with-param name="origin" select="substring-before(@origin, ',')" />
                  <xsl:with-param name="side">width</xsl:with-param>
                </xsl:call-template>
                <!--<xsl:text> </xsl:text>-->
              </xsl:attribute>
              <xsl:attribute name="draw:shadow-offset-y">
                <!-- vertical distance -->
                <xsl:call-template name="ComputeShadowDistance">
                  <xsl:with-param name="distance" select="substring-after(@offset, ',')" />
                  <xsl:with-param name="origin" select="substring-after(@origin, ',')" />
                  <xsl:with-param name="side">height</xsl:with-param>
                </xsl:call-template>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <!-- Default, if no offset value is present-->
              <xsl:if test="not(@offset2)">
                <xsl:attribute name="draw:shadow-offset-x">
                  <xsl:text>0.061cm</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="draw:shadow-offset-y">
                  <xsl:text>0.061cm</xsl:text>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="@offset2">
                <xsl:attribute name="draw:shadow-offset-x">
                  <xsl:call-template name="ComputeShadowDistance">
                    <xsl:with-param name="distance" select="substring-before(@offset2, ',')" />
                    <xsl:with-param name="origin" select="substring-before(@origin, ',')" />
                    <xsl:with-param name="side">width</xsl:with-param>
                  </xsl:call-template>
                  <!--<xsl:text> </xsl:text>-->
                </xsl:attribute>
                <xsl:attribute name="draw:shadow-offset-y">
                  <xsl:call-template name="ComputeShadowDistance">
                    <xsl:with-param name="distance" select="substring-after(@offset2, ',')" />
                    <xsl:with-param name="origin" select="substring-after(@origin, ',')" />
                    <xsl:with-param name="side">height</xsl:with-param>
                  </xsl:call-template>
                </xsl:attribute>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="ComputeShadowDistance">
    <xsl:param name="distance" />
    <xsl:param name="origin" />
    <xsl:param name="side" />
    <!-- if a value requires percent calculation -->
    <xsl:variable name="shapeLength">
      <xsl:if test="contains($distance, '%') or contains($origin, '%')">
	    <xsl:variable name="strValue">
		  <xsl:choose>
		    <xsl:when test="substring-before(substring-after(parent::node()/@style, concat($side, ':')), ';')">
			  <xsl:value-of select="substring-before(substring-after(parent::node()/@style, concat($side, ':')), ';')" />
		    </xsl:when>
		    <xsl:otherwise>
			  <xsl:value-of select="substring-after(parent::node()/@style, concat($side, ':'))" />
		    </xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>
		<xsl:choose>
		  <xsl:when test="contains($strValue,'cm')">
			<xsl:value-of select="concat(number(substring-before($strValue, 'cm')) * 1.0, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($strValue,'mm')">
			<xsl:value-of select="concat(number(substring-before($strValue, 'mm')) * 0.1, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($strValue,'in')">
			<xsl:value-of select="concat(number(substring-before($strValue, 'in')) * 2.54, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($strValue,'pt')">
			<xsl:value-of select="concat(number(substring-before($strValue, 'pt')) * 2.54 div 72.0, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($strValue,'twip')">
			<xsl:value-of select="concat(number(substring-before($strValue, 'twip')) * 2.54 div 1440, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($strValue,'pica')">
			<xsl:value-of select="concat(number(substring-before($strValue, 'pica')) * 2.54 div 6.0, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($strValue,'dpt')">
			<xsl:value-of select="concat(number(substring-before($strValue, 'dpt')) * 2.54 div 72.0, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($strValue,'px')">
			<xsl:value-of select="concat(number(substring-before($strValue, 'px')) * 2.54 div 96.0, 'cm')" />
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:value-of select="concat(number(substring-before($strValue, 'twip')) * 2.54 div 1440, 'cm')" />
		  </xsl:otherwise>
		</xsl:choose>
      </xsl:if>
    </xsl:variable>
    <!-- compute value of shadow offset -->
    <xsl:variable name="distanceVal">
      <xsl:choose>
        <xsl:when test="$distance = '' ">0</xsl:when>
        <xsl:when test="contains($distance, '%')">
          <xsl:value-of select="round(($shapeLength * $distance) div 100)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="ConvertMeasure">
            <xsl:with-param name="length" select="$distance" />
            <xsl:with-param name="destUnit">cm</xsl:with-param>
            <xsl:with-param name="addUnit">false</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- compute value of shadow origin -->
    <xsl:variable name="originVal">
      <xsl:choose>
        <xsl:when test="$origin = '' ">0</xsl:when>
        <xsl:when test="contains($origin, '%')">
          <xsl:value-of select="round(($shapeLength * $origin) div 100)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="ConvertMeasure">
            <xsl:with-param name="length" select="$origin" />
            <xsl:with-param name="destUnit">cm</xsl:with-param>
            <xsl:with-param name="addUnit">false</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="concat((number($distanceVal) + number($originVal)),'cm')" />
  </xsl:template>

  <!--
  Summary: writes the background and fill color of a shape
  Author: Clever Age
  Modified: makz (DIaLOGIKa)
  Date: 6.11.2007
  -->
  <xsl:template name="InsertShapeBackgroundColor">
    <xsl:param name="shape" select="." />
    <xsl:variable name="fillcolor">
      <xsl:choose>
        <xsl:when test="$shape/@fillcolor and not($shape/@fillcolor='') and not($shape/@fillcolor='window') and not($shape/@fillcolor='gradient')">
          <xsl:value-of select="$shape/@fillcolor" />
        </xsl:when>
        <xsl:otherwise>#ffffff</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="isFilled" select="$shape/@filled" />

    <!--dialogika, clam: if filled is set to false, make it transparent (as Word does; bugfix #1800779)-->
    <xsl:if test="$isFilled = 'f'">
      <xsl:attribute name="style:background-transparency">100%</xsl:attribute>
      <!-- Sona : For Fill:No Color-->
      <!--<xsl:attribute name="draw:opacity">0%</xsl:attribute>-->
    </xsl:if>
    <!-- Sona: Added code for transparency-->
    <xsl:if test="(not($isFilled) or $isFilled != 'f') and $shape/v:fill/@opacity">
      <xsl:attribute name="style:background-transparency">
        <xsl:if test="contains($shape/v:fill/@opacity,'f')">
          <xsl:value-of select="concat(100-(((substring-before($shape/v:fill/@opacity,'f')) div 65536) * 100),'%')" />
        </xsl:if>
        <xsl:if test="not(contains($shape/v:fill/@opacity,'f'))">
          <xsl:value-of select="concat(100-(($shape/v:fill/@opacity)*100),'%')" />
        </xsl:if>

      </xsl:attribute>
      <xsl:attribute name="draw:opacity">
        <xsl:if test="contains($shape/v:fill/@opacity,'f')">
          <xsl:value-of select="concat((((substring-before($shape/v:fill/@opacity,'f')) div 65536) * 100),'%')" />
        </xsl:if>
        <xsl:if test="not(contains($shape/v:fill/@opacity,'f'))">
          <xsl:value-of select="concat((($shape/v:fill/@opacity)*100),'%')" />
        </xsl:if>

      </xsl:attribute>
    </xsl:if>
    <!-- Insert background-color -->
    <xsl:attribute name="fo:background-color">
      <xsl:choose>
        <xsl:when test="(not($isFilled) or $isFilled != 'f') and $fillcolor != ''">
          <xsl:call-template name="InsertColor">
            <xsl:with-param name="color" select="$fillcolor" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="(not($isFilled) or $isFilled != 'f') and ($fillcolor = '' or not($fillcolor))">
          <xsl:call-template name="InsertColor">
            <xsl:with-param name="color">#ffffff</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <!--Vipul:Defect fix:  2706054 	SP2 - ODT roundtrip: frame - black frame -->
        <xsl:when test="$isFilled ='f'">
          <xsl:text>transparent</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <!--<xsl:text>transparent</xsl:text>-->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <!-- insert fill-color -->
    <!--RefNo-1:2630175<xsl:if test="$isFilled != 'f'">-->
      <xsl:attribute name="draw:fill-color">
        <xsl:call-template name="InsertColor">
          <xsl:with-param name="color" select="$fillcolor" />
        </xsl:call-template>
      </xsl:attribute>
    <!--</xsl:if>-->
    
    <!--Start of RefNo-1:Added shapeTypeFill to chk for shape type fill property.-->
    <xsl:variable name="shapeTypeId" select="substring-after($shape/@type,'#')" />
    <xsl:variable name="shapeTypeFill">
      <xsl:choose>
        <xsl:when test="$shapeTypeId">
          <xsl:value-of select="key('shapeTypeById', $shapeTypeId)[1]/@filled" />
        </xsl:when>      
      </xsl:choose>
    </xsl:variable>
    <!--End of RefNo-1-->
    <!--added by chhavi to fix bug 2003056-->
    <xsl:if test="$isFilled = 'f' or $shapeTypeFill = 'f'">
      <xsl:attribute name="draw:fill">
        <xsl:text>none</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <!--end here-->
    <!--Edited by Sona to implement Picture fill-->
    <xsl:variable name="pathId">
      <xsl:choose>
        <xsl:when test="@path">
          <xsl:value-of select="@path" />
        </xsl:when>
        <xsl:when test="$shapeTypeId">
          <xsl:value-of select="key('shapeTypeById', $shapeTypeId)[1]/@path" />
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    
    <!-- Sona: Gradient fill for frames-->
    <xsl:if test="($pathId!='m,l,21600r21600,l21600,xe' and not($shape[name()='v:rect'] and $shape/v:textbox))">
      <xsl:choose>
        <xsl:when test="$shape/v:fill[@type='tile' or @type='frame' or @type='pattern']">
          <xsl:attribute name="draw:fill">
            <xsl:text>bitmap</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="draw:fill-image-name">
            <xsl:value-of select="concat('BitmapFill_', generate-id($shape/v:fill))" />
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="$shape/v:fill[@type='tile']">
              <xsl:attribute name="draw:fill-image-ref-point-x">
                <xsl:value-of select="'100%'" />
              </xsl:attribute>
              <xsl:attribute name="draw:fill-image-ref-point-y">
                <xsl:value-of select="'100%'" />
              </xsl:attribute>
              <xsl:if test="$shape/v:fill/@recolor">
                <xsl:attribute name="draw:fill-image-ref-point">
                  <xsl:choose>
                    <xsl:when test="$shape/v:fill/@recolor='tl'">
                      <xsl:value-of select="'top-left'" />
                    </xsl:when>
                    <xsl:when test="$shape/v:fill/@recolor='t'">
                      <xsl:value-of select="'top'" />
                    </xsl:when>
                    <xsl:when test="$shape/v:fill/@recolor='tr'">
                      <xsl:value-of select="'top-right'" />
                    </xsl:when>
                    <xsl:when test="$shape/v:fill/@recolor='r'">
                      <xsl:value-of select="'right'" />
                    </xsl:when>
                    <xsl:when test="@recolor='bl'">
                      <xsl:value-of select="'bottom-left'" />
                    </xsl:when>
                    <xsl:when test="$shape/v:fill/@recolor='br'">
                      <xsl:value-of select="'bottom-right'" />
                    </xsl:when>
                    <xsl:when test="$shape/v:fill/@recolor='b'">
                      <xsl:value-of select="'bottom'" />
                    </xsl:when>
                    <xsl:when test="$shape/v:fill/@recolor='ctr'">
                      <xsl:value-of select="'center'" />
                    </xsl:when>
                  </xsl:choose>
                </xsl:attribute>
              </xsl:if>
            </xsl:when>
            <xsl:when test="$shape/v:fill[@type='frame']">
              <xsl:attribute name="style:repeat">
                <xsl:value-of select="'stretch'" />
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$shape/v:fill[@type='gradient']">
          <xsl:attribute name="draw:fill">
            <xsl:text>gradient</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="draw:fill-gradient-name">
            <xsl:value-of select="concat('Gradient_', generate-id($shape/v:fill))" />
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
    <!-- If the shape has a gradient fill -->

    <xsl:if test="$shape/v:fill/@opacity">
      <xsl:attribute name="draw:opacity">
        <xsl:choose>
          <xsl:when test="contains($shape/v:fill/@opacity,'f')">
            <xsl:value-of select="concat(round((number(substring-before($shape/v:fill/@opacity,'f')) div 65536) * 100),'%') " />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat(round($shape/v:fill/@opacity * 100),'%') " />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="InsertShapeFlowWithText">
    <xsl:param name="shape" select="." />
    <xsl:variable name="layoutInCell" select="$shape/@o:allowincell" />

    <xsl:variable name="verticalRelative">
      <xsl:choose>
        <xsl:when test="$shape[name()='w:framePr']">
          <xsl:value-of select="$shape/@w:vAnchor" />
        </xsl:when>
        <xsl:otherwise>
		  <xsl:choose>
			<xsl:when test="substring-before(substring-after($shape/@style,'mso-position-vertical-relative:'), ';')">
			  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-position-vertical-relative:'), ';')" />
			</xsl:when>
			<xsl:otherwise>
			  <xsl:value-of select="substring-after($shape/@style,'mso-position-vertical-relative:')" />
			</xsl:otherwise>
		  </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="horizontalRelative">
      <xsl:choose>
        <xsl:when test="$shape[name()='w:framePr']">
          <xsl:value-of select="$shape/@w:hAnchor" />
        </xsl:when>
        <xsl:otherwise>
		  <xsl:choose>
		    <xsl:when test="substring-before(substring-after($shape/@style,'mso-position-vertical-relative:'), ';')">
			  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-position-vertical-relative:'), ';')" />
		    </xsl:when>
		    <xsl:otherwise>
			  <xsl:value-of select="substring-after($shape/@style,'mso-position-vertical-relative:')" />
		    </xsl:otherwise>
		  </xsl:choose>
          <!-- Sona Defect #1990565-->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:attribute name="style:flow-with-text">
      <xsl:choose>
        <!-- a line flowing with text causes crash in OO (bug #1747143) -->
        <xsl:when test="$shape[name()='v:line']">
          <xsl:text>false</xsl:text>
        </xsl:when>
        <xsl:when test="$layoutInCell = 'f' ">
          <xsl:text>false</xsl:text>
        </xsl:when>
        <!--if ancestor is header or footer and frame is in background -->
        <!--If the shape is inside the Table-->
        <xsl:when test="(ancestor::w:hdr or ancestor::w:ftr) and not(w10:wrap/@type)">
          <xsl:choose>
            <xsl:when test="$shape/ancestor::w:tc">
              <xsl:text>true</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>false</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <!--Checking condition for shape position-->
        <xsl:when test="$verticalRelative='page' or $horizontalRelative='page'">
          <xsl:choose>
            <!--If the shape is inside the Table-->
            <xsl:when test="$shape/ancestor::w:tc">
              <xsl:text>true</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>false</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>false</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!--
  Inserts the absolute or relative position of draw:shapes
  -->
  <xsl:template name="InsertShapeHorizontalPos">
    <xsl:param name="shape" select="." />

	<xsl:variable name="pos">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'position:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'position:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'position:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>
	<xsl:variable name="horizontalPos">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'mso-position-horizontal:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-position-horizontal:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'mso-position-horizontal:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>
	<xsl:variable name="horizontalRel">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'mso-position-horizontal-relative:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-position-horizontal-relative:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'mso-position-horizontal-relative:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$shape/@o:hralign and $shape/@o:hr='t'">
        <xsl:call-template name="InsertGraphicPosH">
          <xsl:with-param name="align" select="$shape/@o:hralign" />
        </xsl:call-template>
      </xsl:when>
      <!--
      makz: changed due to problem with graph images in file ESTAT_SIF_FR.doc
      in compatibility mode
      <xsl:when test="$horizontalPos='' and ancestor::w:p/w:pPr/w:jc/@w:val and $horizontalRel!='page'">
      -->
      <xsl:when test="$horizontalPos='' and ancestor::w:p/w:pPr/w:jc/@w:val and $horizontalRel!='page' and $pos!='absolute'">
        <xsl:if test="ancestor::w:p/w:pPr/w:jc/@w:val">
          <xsl:call-template name="InsertGraphicPosH">
            <xsl:with-param name="align" select="ancestor::w:p/w:pPr/w:jc/@w:val" />
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="InsertGraphicPosH">
          <xsl:with-param name="align" select="$horizontalPos" />
          <xsl:with-param name="relativeFrom" select="$horizontalRel" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="InsertGraphicPosRelativeH">
      <xsl:with-param name="relativeFrom" select="$horizontalRel" />
      <xsl:with-param name="hPos" select="$horizontalPos" />
    </xsl:call-template>
  </xsl:template>

  <!--
  Summary:  Inserts the vertical position of a shape.
  Author:   CleverAge
  Params:   shape: The VML shape
  -->
  <xsl:template name="InsertShapeVerticalPos">
    <xsl:param name="shape" select="." />

	<xsl:variable name="verticalPos">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'mso-position-vertical:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-position-vertical:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'mso-position-vertical:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>
	<xsl:variable name="verticalRelative">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'mso-position-vertical-relative:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-position-vertical-relative:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'mso-position-vertical-relative:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>

    <!-- Sona changed parameter for defect #1844731-->
    <xsl:call-template name="InsertGraphicPosV">
      <xsl:with-param name="align" select="$verticalPos" />
      <xsl:with-param name="relativeFrom" select="$verticalRelative" />
    </xsl:call-template>
    <xsl:call-template name="InsertGraphicPosRelativeV">
      <xsl:with-param name="align" select="$verticalPos" />
      <xsl:with-param name="relativeFrom" select="$verticalRelative" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="InsertShapeWrap">
    <xsl:param name="shape" select="." />

    <xsl:choose>
      <xsl:when test="self::w:framePr">
        <xsl:if test="@w:wrap">
          <xsl:call-template name="InsertShapeWrapAttributes">
            <xsl:with-param name="shape" select="$shape" />
            <xsl:with-param name="wrap" select="." />
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="InsertShapeWrapAttributes">
          <xsl:with-param name="shape" select="$shape" />
          <xsl:with-param name="wrap" select="$shape/w10:wrap" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
  Summary:  Inserts the style:wrap attributes for draw:frames or draw:shapes
  Author:   CleverAge
  Modified: makz (DIaLOGIKa)
  Params:   shape: The VML shape
            wrap: The wrap value of the shape
  -->
  <xsl:template name="InsertShapeWrapAttributes">
    <xsl:param name="shape" />
    <xsl:param name="wrap" />

	<xsl:variable name="zindex">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'z-index:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'z-index:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'z-index:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>

    <!--
    makz:
    If no wrap is specified, Word wraps the shape in front of the text.
    If the shape is in a header or footer it will be rendered behind the text of the main document.
    If the zindex of the shapeis negative, it will also be rendered behind the text.
    -->
    <xsl:attribute name="style:run-through">
      <xsl:choose>
        <xsl:when test="not($wrap/@type) and not(@w:wrap) and $zindex &lt; 0">
          <xsl:text>background</xsl:text>
        </xsl:when>
        <xsl:when test="not($wrap/@type) and not(@w:wrap) and (ancestor::*[w:hdr] or ancestor::*[w:ftr])">
          <xsl:text>background</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>foreground</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <xsl:attribute name="style:wrap">
      <xsl:choose>
        <xsl:when test="not($wrap)">
          <xsl:choose>
            <!-- no wrap element and no z-index -->
            <xsl:when test="$zindex = '' ">
              <xsl:text>none</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>run-through</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="not($wrap/@type)">
          <xsl:text>run-through</xsl:text>
        </xsl:when>
        <xsl:when
				  test="($wrap/@type = 'square' or $wrap/@type = 'tight' or $wrap/@type = 'through' or @w:wrap='around') and not($wrap/@side)">
          <xsl:text>parallel</xsl:text>
        </xsl:when>
        <xsl:when
				  test="($wrap/@type = 'square' or $wrap/@type = 'tight' or $wrap/@type = 'through') and $wrap/@side = 'left' ">
          <xsl:text>left</xsl:text>
        </xsl:when>
        <xsl:when
				  test="($wrap/@type = 'square' or $wrap/@type = 'tight' or $wrap/@type = 'through') and $wrap/@side = 'right' ">
          <xsl:text>right</xsl:text>
        </xsl:when>
        <xsl:when
				  test="($wrap/@type = 'square' or $wrap/@type = 'tight' or $wrap/@type = 'through') and $wrap/@side = 'largest' ">
          <xsl:text>dynamic</xsl:text>
        </xsl:when>
        <xsl:when test="$wrap/@type = 'topAndBottom' ">
          <xsl:text>none</xsl:text>
        </xsl:when>
        <xsl:when test="not(@w:wrap) or @w:wrap='none' ">
          <xsl:text>none</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>

    <!-- Sona: Wrap implementation and also Defect #2025699 -->
    <xsl:if test="$wrap/@type = 'tight' or $wrap/@type = 'through'">
      <xsl:attribute name="style:wrap-contour">
        <xsl:value-of select="'true'" />
      </xsl:attribute>
      <xsl:attribute name="style:wrap-contour-mode">
        <xsl:value-of select="'outside'" />
      </xsl:attribute>
    </xsl:if>

  </xsl:template>

  <xsl:template name="InsertShapeFromTextDistance">
    <xsl:param name="shape" select="." />

	<xsl:variable name="horizontalRelative">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'mso-position-horizontal-relative:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-position-horizontal-relative:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'mso-position-horizontal-relative:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>
	<xsl:variable name="verticalRelative">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'mso-position-vertical-relative:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-position-vertical-relative:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'mso-position-vertical-relative:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>
	<xsl:variable name="horizontalPosition">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'mso-position-horizontal:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-position-horizontal:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'mso-position-horizontal:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>
	<xsl:variable name="verticalPosition">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'mso-position-vertical:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-position-vertical:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'mso-position-vertical:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>

    <xsl:variable name="margin-top">
      <xsl:choose>
        <xsl:when test="$verticalRelative='page' and $verticalPosition='top'">
          <xsl:text>0</xsl:text>
        </xsl:when>
        <xsl:otherwise>
		  <xsl:choose>
	        <xsl:when test="substring-before(substring-after($shape/@style,'mso-wrap-distance-top:'), ';')">
			  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-wrap-distance-top:'), ';')" />
			</xsl:when>
			<xsl:otherwise>
			  <xsl:value-of select="substring-after($shape/@style,'mso-wrap-distance-top:')" />
			</xsl:otherwise>
		  </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$margin-top !=''">
      <xsl:attribute name="fo:margin-top">
		<xsl:choose>
		  <xsl:when test="contains($margin-top,'cm')">
			<xsl:value-of select="concat(number(substring-before($margin-top, 'cm')) * 1.0, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-top,'mm')">
			<xsl:value-of select="concat(number(substring-before($margin-top, 'mm')) * 0.1, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-top,'in')">
			<xsl:value-of select="concat(number(substring-before($margin-top, 'in')) * 2.54, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-top,'pt')">
			<xsl:value-of select="concat(number(substring-before($margin-top, 'pt')) * 2.54 div 72.0, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-top,'twip')">
			<xsl:value-of select="concat(number(substring-before($margin-top, 'twip')) * 2.54 div 1440, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-top,'pica')">
			<xsl:value-of select="concat(number(substring-before($margin-top, 'pica')) * 2.54 div 6.0, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-top,'dpt')">
			<xsl:value-of select="concat(number(substring-before($margin-top, 'dpt')) * 2.54 div 72.0, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-top,'px')">
			<xsl:value-of select="concat(number(substring-before($margin-top, 'px')) * 2.54 div 96.0, 'cm')" />
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:value-of select="concat(number(substring-before($margin-top, 'twip')) * 2.54 div 1440, 'cm')" />
		  </xsl:otherwise>
		</xsl:choose>
      </xsl:attribute>
    </xsl:if>

    <xsl:variable name="margin-bottom">
      <xsl:choose>
        <xsl:when test="$verticalRelative='page' and $verticalPosition='bottom'">
          <xsl:text>0</xsl:text>
        </xsl:when>
        <xsl:otherwise>
		  <xsl:choose>
		    <xsl:when test="substring-before(substring-after($shape/@style,'mso-wrap-distance-bottom:'), ';')">
			  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-wrap-distance-bottom:'), ';')" />
		    </xsl:when>
		    <xsl:otherwise>
			  <xsl:value-of select="substring-after($shape/@style,'mso-wrap-distance-bottom:')" />
		    </xsl:otherwise>
		  </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$margin-bottom !=''">
      <xsl:attribute name="fo:margin-bottom">
		<xsl:choose>
		  <xsl:when test="contains($margin-bottom,'cm')">
			<xsl:value-of select="concat(number(substring-before($margin-bottom, 'cm')) * 1.0, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-bottom,'mm')">
			<xsl:value-of select="concat(number(substring-before($margin-bottom, 'mm')) * 0.1, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-bottom,'in')">
			<xsl:value-of select="concat(number(substring-before($margin-bottom, 'in')) * 2.54, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-bottom,'pt')">
			<xsl:value-of select="concat(number(substring-before($margin-bottom, 'pt')) * 2.54 div 72.0, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-bottom,'twip')">
			<xsl:value-of select="concat(number(substring-before($margin-bottom, 'twip')) * 2.54 div 1440, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-bottom,'pica')">
			<xsl:value-of select="concat(number(substring-before($margin-bottom, 'pica')) * 2.54 div 6.0, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-bottom,'dpt')">
			<xsl:value-of select="concat(number(substring-before($margin-bottom, 'dpt')) * 2.54 div 72.0, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-bottom,'px')">
			<xsl:value-of select="concat(number(substring-before($margin-bottom, 'px')) * 2.54 div 96.0, 'cm')" />
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:value-of select="concat(number(substring-before($margin-bottom, 'twip')) * 2.54 div 1440, 'cm')" />
		  </xsl:otherwise>
		</xsl:choose>
      </xsl:attribute>
    </xsl:if>

    <xsl:variable name="margin-left">
      <xsl:choose>
        <xsl:when test="$horizontalRelative='page' and $horizontalPosition='left'">
          <xsl:text>0</xsl:text>
        </xsl:when>
        <!--Sona Added margin for completing Shape Wrap feature-->
        <!-- Omit default values for in front of text-->
        <xsl:when test="not(contains($shape/@style,'mso-wrap-distance-left')) and $shape/w10:wrap/@type">
          <xsl:text>0.13in</xsl:text>
        </xsl:when>
        <xsl:otherwise>
		  <xsl:choose>
		    <xsl:when test="substring-before(substring-after($shape/@style,'mso-wrap-distance-left:'), ';')">
		      <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-wrap-distance-left:'), ';')" />
		    </xsl:when>
		    <xsl:otherwise>
		      <xsl:value-of select="substring-after($shape/@style,'mso-wrap-distance-left:')" />
		    </xsl:otherwise>
		  </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$margin-left !=''">
      <xsl:attribute name="fo:margin-left">
		<xsl:choose>
		  <xsl:when test="contains($margin-left,'cm')">
			<xsl:value-of select="concat(number(substring-before($margin-left, 'cm')) * 1.0, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-left,'mm')">
			<xsl:value-of select="concat(number(substring-before($margin-left, 'mm')) * 0.1, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-left,'in')">
			<xsl:value-of select="concat(number(substring-before($margin-left, 'in')) * 2.54, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-left,'pt')">
			<xsl:value-of select="concat(number(substring-before($margin-left, 'pt')) * 2.54 div 72.0, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-left,'twip')">
			<xsl:value-of select="concat(number(substring-before($margin-left, 'twip')) * 2.54 div 1440, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-left,'pica')">
			<xsl:value-of select="concat(number(substring-before($margin-left, 'pica')) * 2.54 div 6.0, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-left,'dpt')">
			<xsl:value-of select="concat(number(substring-before($margin-left, 'dpt')) * 2.54 div 72.0, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-left,'px')">
			<xsl:value-of select="concat(number(substring-before($margin-left, 'px')) * 2.54 div 96.0, 'cm')" />
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:value-of select="concat(number(substring-before($margin-left, 'twip')) * 2.54 div 1440, 'cm')" />
		  </xsl:otherwise>
		</xsl:choose>
      </xsl:attribute>
    </xsl:if>

    <xsl:if test="$margin-left=''">
      <xsl:attribute name="fo:margin-left">
        <xsl:text>0</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <xsl:variable name="margin-right">
      <xsl:choose>
        <xsl:when test="$horizontalRelative='page' and $horizontalPosition='right'">
          <xsl:text>0</xsl:text>
        </xsl:when>
        <!--Sona Added margin for completing Shape Wrap feature-->
        <!-- Omit default values for in front of text-->
        <xsl:when test="not(contains($shape/@style,'mso-wrap-distance-right')) and $shape/w10:wrap/@type">
          <xsl:text>0.13in</xsl:text>
        </xsl:when>
        <xsl:otherwise>
		  <xsl:choose>
		    <xsl:when test="substring-before(substring-after($shape/@style,'mso-wrap-distance-right:'), ';')">
		      <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-wrap-distance-right:'), ';')" />
		    </xsl:when>
		    <xsl:otherwise>
		      <xsl:value-of select="substring-after($shape/@style,'mso-wrap-distance-right:')" />
		    </xsl:otherwise>
		  </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$margin-right !=''">
      <xsl:attribute name="fo:margin-right">
		<xsl:choose>
		  <xsl:when test="contains($margin-right,'cm')">
			<xsl:value-of select="concat(number(substring-before($margin-right, 'cm')) * 1.0, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-right,'mm')">
			<xsl:value-of select="concat(number(substring-before($margin-right, 'mm')) * 0.1, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-right,'in')">
			<xsl:value-of select="concat(number(substring-before($margin-right, 'in')) * 2.54, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-right,'pt')">
			<xsl:value-of select="concat(number(substring-before($margin-right, 'pt')) * 2.54 div 72.0, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-right,'twip')">
			<xsl:value-of select="concat(number(substring-before($margin-right, 'twip')) * 2.54 div 1440, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-right,'pica')">
			<xsl:value-of select="concat(number(substring-before($margin-right, 'pica')) * 2.54 div 6.0, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-right,'dpt')">
			<xsl:value-of select="concat(number(substring-before($margin-right, 'dpt')) * 2.54 div 72.0, 'cm')" />
		  </xsl:when>
		  <xsl:when test="contains($margin-right,'px')">
			<xsl:value-of select="concat(number(substring-before($margin-right, 'px')) * 2.54 div 96.0, 'cm')" />
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:value-of select="concat(number(substring-before($margin-right, 'twip')) * 2.54 div 1440, 'cm')" />
		  </xsl:otherwise>
		</xsl:choose>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="$margin-right=''">
      <xsl:attribute name="fo:margin-right">
        <xsl:text>0</xsl:text>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!--
  Summary: Template writes the properties of a shape border.
  Author: Clever Age
  Modified: makz (DIaLOGIKa)
  Date: 16.10.2007
  -->
  <xsl:template name="InsertShapeBorders">
    <!-- current context is <v:shape> -->
    <xsl:param name="shape" select="." />
    <xsl:variable name="shapeTypeId" select="substring-after($shape/@type, '#')" />
    <xsl:variable name="shapetype" select="key('shapeTypeById', $shapeTypeId)[1]" />

    <xsl:variable name="paintBorder">
      <!-- The stroked attribute of the shape is stronger than the attribute of the shapetype -->
      <xsl:choose>
        <xsl:when test="$shape/@stroked">
          <xsl:choose>
            <!-- there is no v:stroke element, then only paint the border if stroked is set to true -->
            <xsl:when test="not($shape/v:stroke) and ($shape/@stroked='t' or $shape/@stroked='true' or $shape/@stroked='1')">
              <xsl:text>shape</xsl:text>
            </xsl:when>
            <!-- there is a v:stroke element, then paint the border if stroked isn't disabled -->
            <xsl:when test="$shape/v:stroke and ($shape/@stroked!='f' and $shape/@stroked!='false' and $shape/@stroked!='0')">
              <!--changed by chhavi ,shape to none ,to fix bugs 2003927 , 2003016-->
              <xsl:text>shape</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>none</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$shapetype/@stroked">
          <xsl:choose>
            <!-- there is no v:stroke element, then only paint the border if stroked is enabled -->
            <xsl:when test="not($shapetype/v:stroke) and ($shapetype/@stroked='t' or $shapetype/@stroked='true' or $shapetype/@stroked='1')">
              <xsl:text>shapetype</xsl:text>
            </xsl:when>
            <!-- there is a v:stroke element, then paint the border if stroked isn't disabled -->
            <xsl:when test="$shapetype/v:stroke and ($shapetype/@stroked!='f' and $shapetype/@stroked!='false' and $shapetype/@stroked!='0')">
              <xsl:text>shapetype</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>none</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <!-- 
          if no stroked attribute is set but a v:stroke element exists word paint a default border
          -->
          <xsl:choose>
            <xsl:when test="$shape/v:stroke or $shapetype/v:stroke">
              <xsl:text>default</xsl:text>
            </xsl:when>
            <!-- Sona: Added borders for shapes other than custom shapes like rounded rect,rect,oval,can-->
            <!--<xsl:when test="$shape=v:roundrect or $shape=v:rect or $shape=v:shape or $shape=v:oval">-->
            <xsl:when test="name($shape)='v:roundrect' or name($shape)='v:rect' or name($shape)='v:shape' or name($shape)='v:oval'">
              <xsl:text>default</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>none</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- 
    Shapes can have stroke attributes and a stroke element without having a border.
    In this case the stroked attribute is set to false.
    -->
    <xsl:choose>
      <xsl:when test="not($paintBorder='none')">

        <!-- calculate border color -->
        <xsl:variable name="borderColor">
          <xsl:choose>
            <!--Sona: Added Border Color-->
            <xsl:when test="($paintBorder='shape' or $paintBorder='default') and $shape/@strokecolor">

              <xsl:call-template name="InsertColor">
                <xsl:with-param name="color" select="$shape/@strokecolor" />
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="($paintBorder='shapetype' or $paintBorder='default') and $shapetype/@strokecolor">
              <!-- -->
              <xsl:call-template name="InsertColor">
                <xsl:with-param name="color" select="$shapetype/@strokecolor" />
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>#000000</xsl:text>
            </xsl:otherwise>
            <!--
            <xsl:when test="$paintBorder='default'">
              <xsl:text>#000000</xsl:text>
            </xsl:when>
            -->
          </xsl:choose>
        </xsl:variable>

        <!-- calculate border weight -->
        <xsl:variable name="borderWeight">
          <xsl:choose>
            <xsl:when test="($paintBorder='shape' or $paintBorder='default') and $shape/@strokeweight">
			  <xsl:choose>
			    <xsl:when test="contains($shape/@strokeweight,'cm')">
				  <xsl:value-of select="concat(number(substring-before($shape/@strokeweight, 'cm')) * 1.0, 'cm')" />
			    </xsl:when>
			    <xsl:when test="contains($shape/@strokeweight,'mm')">
				  <xsl:value-of select="concat(number(substring-before($shape/@strokeweight, 'mm')) * 0.1, 'cm')" />
			    </xsl:when>
			    <xsl:when test="contains($shape/@strokeweight,'in')">
				  <xsl:value-of select="concat(number(substring-before($shape/@strokeweight, 'in')) * 2.54, 'cm')" />
			    </xsl:when>
			    <xsl:when test="contains($shape/@strokeweight,'pt')">
				  <xsl:value-of select="concat(number(substring-before($shape/@strokeweight, 'pt')) * 2.54 div 72.0, 'cm')" />
			    </xsl:when>
			    <xsl:when test="contains($shape/@strokeweight,'twip')">
				  <xsl:value-of select="concat(number(substring-before($shape/@strokeweight, 'twip')) * 2.54 div 1440, 'cm')" />
			    </xsl:when>
			    <xsl:when test="contains($shape/@strokeweight,'pica')">
			 	  <xsl:value-of select="concat(number(substring-before($shape/@strokeweight, 'pica')) * 2.54 div 6.0, 'cm')" />
			    </xsl:when>
			    <xsl:when test="contains($shape/@strokeweight,'dpt')">
				  <xsl:value-of select="concat(number(substring-before($shape/@strokeweight, 'dpt')) * 2.54 div 72.0, 'cm')" />
			    </xsl:when>
			    <xsl:when test="contains($shape/@strokeweight,'px')">
				  <xsl:value-of select="concat(number(substring-before($shape/@strokeweight, 'px')) * 2.54 div 96.0, 'cm')" />
			    </xsl:when>
			    <xsl:otherwise>
				  <xsl:value-of select="concat(number(substring-before($shape/@strokeweight, 'twip')) * 2.54 div 1440, 'cm')" />
			    </xsl:otherwise>
			  </xsl:choose>
            </xsl:when>
            <xsl:when test="($paintBorder='shapetype' or $paintBorder='default') and $shapetype/@strokeweight">
			  <xsl:choose>
			    <xsl:when test="contains($shapetype/@strokeweight,'cm')">
				  <xsl:value-of select="concat(number(substring-before($shapetype/@strokeweight, 'cm')) * 1.0, 'cm')" />
			    </xsl:when>
			    <xsl:when test="contains($shapetype/@strokeweight,'mm')">
				  <xsl:value-of select="concat(number(substring-before($shapetype/@strokeweight, 'mm')) * 0.1, 'cm')" />
			    </xsl:when>
			    <xsl:when test="contains($shapetype/@strokeweight,'in')">
				  <xsl:value-of select="concat(number(substring-before($shapetype/@strokeweight, 'in')) * 2.54, 'cm')" />
			    </xsl:when>
			    <xsl:when test="contains($shapetype/@strokeweight,'pt')">
				  <xsl:value-of select="concat(number(substring-before($shapetype/@strokeweight, 'pt')) * 2.54 div 72.0, 'cm')" />
			    </xsl:when>
			    <xsl:when test="contains($shapetype/@strokeweight,'twip')">
				  <xsl:value-of select="concat(number(substring-before($shapetype/@strokeweight, 'twip')) * 2.54 div 1440, 'cm')" />
			    </xsl:when>
			    <xsl:when test="contains($shapetype/@strokeweight,'pica')">
			 	  <xsl:value-of select="concat(number(substring-before($shapetype/@strokeweight, 'pica')) * 2.54 div 6.0, 'cm')" />
			    </xsl:when>
			    <xsl:when test="contains($shapetype/@strokeweight,'dpt')">
				  <xsl:value-of select="concat(number(substring-before($shapetype/@strokeweight, 'dpt')) * 2.54 div 72.0, 'cm')" />
			    </xsl:when>
			    <xsl:when test="contains($shapetype/@strokeweight,'px')">
				  <xsl:value-of select="concat(number(substring-before($shapetype/@strokeweight, 'px')) * 2.54 div 96.0, 'cm')" />
			    </xsl:when>
			    <xsl:otherwise>
				  <xsl:value-of select="concat(number(substring-before($shapetype/@strokeweight, 'twip')) * 2.54 div 1440, 'cm')" />
			    </xsl:otherwise>
			  </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>0.0176cm</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <!-- Sona Border Weight-->
        <xsl:attribute name="svg:stroke-width">
          <xsl:value-of select="$borderWeight" />
        </xsl:attribute>
        <xsl:variable name="dashStyle" select="$shape/v:stroke/@dashstyle">
        </xsl:variable>

        <xsl:variable name="lineStyle" select="$shape/v:stroke/@linestyle">
        </xsl:variable>

        <!-- get border style -->
        <xsl:variable name="borderStyle">
          <xsl:choose>
            <xsl:when test="$lineStyle">
              <xsl:text>double</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>solid</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <!--code added by yeswanth.s : For defect# 1836547-->
        <xsl:variable name="bWNoUnit" select="number(substring-before($borderWeight,'cm'))" />

        <xsl:variable name="mappedBorderWeight">
          <xsl:choose>
            <xsl:when test="$lineStyle">
              <xsl:value-of select="$borderWeight" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="($bWNoUnit &gt;= 0) and ($bWNoUnit &lt;= 0.0165805556)">
                <xsl:value-of select="'0.00176388889cm'" />
              </xsl:if>
              <xsl:if test="($bWNoUnit &gt; 0.0165805556) and ($bWNoUnit &lt;= 0.0342194444)">
                <xsl:value-of select="'0.0176388889cm'" />
              </xsl:if>
              <xsl:if test="($bWNoUnit &gt; 0.0342194444) and ($bWNoUnit &lt;= 0.0871361111)">
                <xsl:value-of select="'0.0352777778cm'" />
              </xsl:if>
              <xsl:if test="($bWNoUnit &gt; 0.0871361111) and ($bWNoUnit &lt;= 0.140052778)">
                <xsl:value-of select="'0.0881944444cm'" />
              </xsl:if>
              <xsl:if test="($bWNoUnit &gt; 0.140052778) and ($bWNoUnit &lt;= 0.175330556)">
                <xsl:value-of select="'0.141111111cm'" />
              </xsl:if>
              <xsl:if test="($bWNoUnit &gt; 0.175330556)">
                <!--<xsl:if test="($bWNoUnit &gt; 0.141111111) and ($bWNoUnit &lt;= 0.176388889)">-->
                <xsl:value-of select="'0.176388889cm'" />
              </xsl:if>
              <!--<xsl:if test="($bWNoUnit &gt; 0.176388889)">
								<xsl:value-of select="'0.176388889cm'" />
							</xsl:if>-->
              <xsl:if test="($bWNoUnit &lt; 0)">
                <xsl:value-of select="'0cm'" />
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <!--end-->

        <!-- write attributes -->
        <xsl:attribute name="fo:border">
          <xsl:value-of select="concat($mappedBorderWeight,' ',$borderStyle,' ',$borderColor)" />
        </xsl:attribute>

        <xsl:attribute name="svg:stroke-color">
          <xsl:value-of select="$borderColor" />
        </xsl:attribute>

        <!--code changed by yeswanth.s : For defect# 1836547-->
        <!-- the border is double -->
        <xsl:if test="$lineStyle">
          <xsl:attribute name="style:border-line-width">
            <xsl:choose>
              <xsl:when test="$lineStyle='thinThin'">
                <xsl:if test="($bWNoUnit &gt;= 0) and ($bWNoUnit &lt;= 0.104775)">
                  <xsl:value-of select="'0.002032cm 0.035052cm 0.002032cm'" />
                </xsl:if>
                <xsl:if test="($bWNoUnit &gt; 0.104775) and ($bWNoUnit &lt;= 0.237066667)">
                  <xsl:value-of select="'0.002032cm 0.087884cm 0.002032cm'" />
                </xsl:if>
                <xsl:if test="($bWNoUnit &gt; 0.237066667) and ($bWNoUnit &lt;= 0.316441667)">
                  <xsl:value-of select="'0.035052cm 0.035052cm 0.035052cm'" />
                </xsl:if>
                <xsl:if test="($bWNoUnit &gt; 0.316441667)">
                  <xsl:value-of select="'0.087884cm 0.087884cm 0.087884cm'" />
                </xsl:if>
              </xsl:when>
              <xsl:when test="$lineStyle='thinThick'">
                <xsl:if test="($bWNoUnit &gt;= 0) and ($bWNoUnit &lt;= 0.240594444)">
                  <xsl:value-of select="'0.087884cm 0.035052cm 0.035052cm'" />
                </xsl:if>
                <xsl:if test="($bWNoUnit &gt; 0.240594444)">
                  <xsl:value-of select="'0.14097cm 0.087884cm 0.087884cm'" />
                </xsl:if>
              </xsl:when>
              <xsl:when test="$lineStyle='thickThin'">
                <xsl:if test="($bWNoUnit &gt;= 0) and ($bWNoUnit &lt;= 0.1524)">
                  <xsl:value-of select="'0.002032cm 0.087884cm 0.035052cm'" />
                </xsl:if>
                <xsl:if test="($bWNoUnit &gt; 0.1524) and ($bWNoUnit &lt;= 0.205316667)">
                  <xsl:value-of select="'0.002032cm 0.087884cm 0.087884cm'" />
                </xsl:if>
                <xsl:if test="($bWNoUnit &gt; 0.205316667) and ($bWNoUnit &lt;= 0.291747222)">
                  <xsl:value-of select="'0.002032cm 0.087884cm 0.14097cm'" />
                </xsl:if>
                <xsl:if test="($bWNoUnit &gt; 0.291747222)">
                  <xsl:value-of select="'0.087884cm 0.087884cm 0.14097cm'" />
                </xsl:if>
              </xsl:when>
              <xsl:when test="$lineStyle='thickBetweenThin'">
                <xsl:if test="($bWNoUnit &gt;= 0) and ($bWNoUnit &lt;= 0.0800805556)">
                  <xsl:value-of select="'0.002032cm 0.035052cm 0.002032cm'" />
                </xsl:if>
                <xsl:if test="($bWNoUnit &gt; 0.0800805556) and ($bWNoUnit &lt;= 0.185913889)">
                  <xsl:value-of select="'0.035052cm 0.035052cm 0.035052cm'" />
                </xsl:if>
                <xsl:if test="($bWNoUnit &gt; 0.185913889) and ($bWNoUnit &lt;= 0.291747222)">
                  <xsl:value-of select="'0.087884cm 0.087884cm 0.087884cm'" />
                </xsl:if>
                <xsl:if test="($bWNoUnit &gt; 0.291747222)">
                  <xsl:value-of select="'0.087884cm 0.087884cm 0.14097cm'" />
                </xsl:if>
              </xsl:when>
            </xsl:choose>
          </xsl:attribute>
        </xsl:if>
        <!--end-->

        <!-- the border is dashed -->
        <!-- Sona: Defect #2019374 contd-->
        <xsl:if test="$dashStyle!='' and $dashStyle!='solid'">
          <xsl:attribute name="draw:stroke">
            <xsl:text>dash</xsl:text>
          </xsl:attribute>
          <!-- Sona: Added Dashed border-->

          <xsl:attribute name="draw:stroke-dash">
            <xsl:choose>
              <xsl:when test="$dashStyle='1 1' and $shape/v:stroke/@endcap='round'">
                <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', 'Fine Dotted', '-ooe')" />
              </xsl:when>
              <xsl:when test="$dashStyle='1 1'">
                <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', 'SquareDot', '-ooe')" />
              </xsl:when>
              <xsl:when test="$dashStyle='dash'">
                <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', 'Ultrafine Dashed', '-ooe')" />
              </xsl:when>
              <xsl:when test="$dashStyle='longDash'">
                <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', 'Fine Dashed', '-ooe')" />
              </xsl:when>
              <xsl:when test="$dashStyle='longDashDotDot'">
                <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', '2 Dots 1 Dash', '-ooe')" />
              </xsl:when>
              <xsl:when test="$dashStyle='longDashDot'">
                <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', '1 Dot 2 Dashes', '-ooe')" />
              </xsl:when>
              <xsl:when test="$dashStyle='dashDot'">
                <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', '1 Dot 1 Dash', '-ooe')" />
              </xsl:when>
            </xsl:choose>
          </xsl:attribute>

        </xsl:if>
      </xsl:when>
      <!-- insert explicit NO border (only if the element is no line) -->
      <xsl:when test="not(name($shape)='v:line')">
        <xsl:attribute name="draw:stroke">
          <xsl:text>none</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="fo:border">
          <xsl:text>none</xsl:text>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- Sona Added Dash properties -->
  <xsl:template name="getDashType">
    <xsl:param name="shape" />
    <xsl:variable name="val" select="$shape/v:stroke/@dashstyle" />

    <xsl:variable name="cap">
      <xsl:choose>
        <xsl:when test="$shape/v:stroke/@endcap">
          <xsl:value-of select="'round'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'rect'" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="($val='1 1' and $cap='round')">
        <xsl:call-template name="AddDashType">
          <xsl:with-param name="name" select="'Fine Dotted'" />
          <xsl:with-param name="cap" select="$cap" />
          <xsl:with-param name="dot2" select="'1'" />
          <xsl:with-param name="dot2-length" select = "'0.0114in'" />
          <xsl:with-param name="distance" select="'0.0228in'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="($val='dash')">
        <xsl:call-template name="AddDashType">
          <xsl:with-param name="name" select="'Ultrafine Dashed'" />
          <xsl:with-param name="cap" select="$cap" />
          <xsl:with-param name="dot1" select="'1'" />
          <xsl:with-param name="dot1-length" select = "'0.0681in'" />
          <xsl:with-param name="dot2" select="'1'" />
          <xsl:with-param name="dot2-length" select = "'0.0681in'" />
          <xsl:with-param name="distance" select="'0.0453in'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="($val='1 1')">
        <xsl:call-template name="AddDashType">
          <xsl:with-param name="name" select="'SquareDot'" />
          <xsl:with-param name="cap" select="$cap" />
          <xsl:with-param name="dot1" select="'1'" />
          <xsl:with-param name="dot1-length" select = "'0.0228in'" />
          <xsl:with-param name="dot2" select="'1'" />
          <xsl:with-param name="dot2-length" select = "'0.0228in'" />
          <xsl:with-param name="distance" select="'0.0228in'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="($val='dashDot')">
        <xsl:call-template name="AddDashType">
          <xsl:with-param name="name" select="'_1_Dot_1_Dash'" />
          <xsl:with-param name="cap" select="$cap" />
          <xsl:with-param name="dot1" select="'1'" />
          <xsl:with-param name="dot2" select="'1'" />
          <xsl:with-param name="dot2-length" select = "'0.0681in'" />
          <xsl:with-param name="distance" select="'0.0453in'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="($val='longDash')">
        <xsl:call-template name="AddDashType">
          <xsl:with-param name="name" select="'Fine Dashed'" />
          <xsl:with-param name="cap" select="$cap" />
          <xsl:with-param name="dot1" select="'1'" />
          <xsl:with-param name="dot1-length" select = "'0.1362in'" />
          <xsl:with-param name="dot2" select="'1'" />
          <xsl:with-param name="dot2-length" select = "'0.1362in'" />
          <xsl:with-param name="distance" select="'0.0567in'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="($val='longDashDot')">
        <xsl:call-template name="AddDashType">
          <xsl:with-param name="name" select="'1 Dot 2 Dashes'" />
          <xsl:with-param name="cap" select="$cap" />
          <xsl:with-param name="dot1" select="'1'" />
          <xsl:with-param name="dot2" select="'1'" />
          <xsl:with-param name="dot2-length" select = "'0.1362in'" />
          <xsl:with-param name="distance" select="'0.0453in'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="($val='longDashDotDot')">
        <xsl:call-template name="AddDashType">
          <xsl:with-param name="name" select="'2 Dots 1 Dash'" />
          <xsl:with-param name="cap" select="$cap" />
          <xsl:with-param name="dot1" select="'2'" />
          <!--<xsl:with-param name="dot1-length" select = "$dot" />-->
          <xsl:with-param name="dot2" select="'1'" />
          <xsl:with-param name="dot2-length" select = "'0.1362in'" />
          <xsl:with-param name="distance" select="'0.0453in'" />
        </xsl:call-template>
      </xsl:when>

    </xsl:choose>
  </xsl:template>

  <xsl:template name="AddDashType">
    <xsl:param name="name" />
    <xsl:param name="cap" />
    <xsl:param name="dot1" />
    <xsl:param name="dot1-length" />
    <xsl:param name="dot2" />
    <xsl:param name="dot2-length" />
    <xsl:param name="distance" />

    <draw:stroke-dash>
      <xsl:choose>
        <xsl:when test="$cap='round'">
          <xsl:attribute name="draw:name">
            <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', concat($name,'Round'), '-ooe')" />
          </xsl:attribute>
          <xsl:attribute name="draw:style">
            <xsl:value-of select="'round'" />
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="draw:name">
            <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', $name, '-ooe')" />
          </xsl:attribute>
          <xsl:attribute name="draw:style">
            <xsl:value-of select="'rect'" />
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:attribute name="draw:display-name">
        <xsl:value-of select="$name" />
      </xsl:attribute>
      <xsl:if test="(string-length($dot1) != 0)">
        <xsl:attribute name="draw:dots1">
          <xsl:value-of select="$dot1" />
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="(string-length($dot1-length) != 0)">
        <xsl:attribute name="draw:dots1-length">
          <xsl:value-of select="$dot1-length" />
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="(string-length($dot2) != 0)">
        <xsl:attribute name="draw:dots2">
          <xsl:value-of select="$dot2" />
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="(string-length($dot2-length) != 0)">
        <xsl:attribute name="draw:dots2-length">
          <xsl:value-of select="$dot2-length" />
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="(string-length($distance) != 0)">
        <xsl:attribute name="draw:distance">
          <xsl:value-of select="$distance" />
        </xsl:attribute>
      </xsl:if>
    </draw:stroke-dash>

  </xsl:template>
  <!-- Sona Arrow Styles-->
  <xsl:template name="GetArrowType">
    <xsl:param name="arrow"></xsl:param>
    <xsl:choose>
      <xsl:when test="$arrow='open'">
        <xsl:value-of select="'open'" />
      </xsl:when>
      <xsl:when test="$arrow='block'">
        <xsl:value-of select="'block'" />
      </xsl:when>
      <xsl:when test="$arrow='classic'">
        <xsl:value-of select="'classic'" />
      </xsl:when>
      <xsl:when test="$arrow='oval'">
        <xsl:value-of select="'oval'" />
      </xsl:when>
      <xsl:when test="$arrow='diamond'">
        <xsl:value-of select="'diamond'" />
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--Sona Arrow Size -->
  <xsl:template name="GetArrowSize">
    <xsl:param name="arrowLength"></xsl:param>
    <xsl:param name="arrowWidth"></xsl:param>
    <xsl:param name="type"></xsl:param>
    <xsl:param name="weight"></xsl:param>
    <xsl:param name="weightincm"></xsl:param>
    <xsl:message terminate="no">translation.oox2odf.shapesTypeArrowHeadTailSize</xsl:message>
    <xsl:choose>
      <!-- selection for (top row arrow type) and (arrow size as 'arrow') -->
      <xsl:when test="(($weight &gt; '1.95') and ($type = 'block') and ($arrowWidth='narrow') and ($arrowLength='short')) or (($weight &gt; '1.95') and ($type = 'block') and ($arrowWidth='narrow') and ($arrowLength='long')) or (($weight &gt; '1.95') and ($type = 'block') and ($arrowWidth='narrow'))">
        <xsl:value-of select="concat(($weightincm) * (3.5),'cm')" />
      </xsl:when>
      <xsl:when test="(($weight &lt; '1.95') and ($type = 'block') and ($arrowWidth='narrow') and ($arrowLength='short')) or (($weight &lt; '1.95')  and ($type = 'block') and ($arrowWidth='narrow') and ($arrowLength='long')) or (($weight &lt; '1.95')  and ($type = 'block') and ($arrowWidth='narrow'))">
        <xsl:value-of select="concat($sm-med,'cm')" />
      </xsl:when>
      <!-- selection for (top row arrow type) and non-selection of (arrow size as 'arrow') -->
      <xsl:when test="(($weight &gt; '2') and ($arrowWidth='narrow') and ($arrowLength='short')) or (($weight &gt; '2') and ($arrowWidth='narrow') and ($arrowLength='long')) or (($weight &gt; '2') and ($arrowWidth='narrow'))">
        <xsl:value-of select="concat(($weightincm) * (2),'cm')" />
      </xsl:when>
      <xsl:when test="(($weight &lt; '2')  and ($arrowWidth='narrow') and ($arrowLength='short')) or (($weight &lt; '2')  and ($arrowWidth='narrow') and ($arrowLength='long')) or (($weight &lt; '2')  and ($arrowWidth='narrow'))">
        <xsl:value-of select="concat($sm-sm,'cm')" />
      </xsl:when>

      <!-- selection for (bottom row arrow type) and (arrow size as 'arrow') -->
      <xsl:when test="(($weight &gt; '1.95') and ($type = 'block') and ($arrowWidth='wide') and ($arrowLength='short')) or  (($weight &gt; '1.95') and ($type = 'block') and ($arrowWidth='wide') and ($arrowLength='long')) or (($weight &gt; '1.95') and ($type = 'block') and ($arrowWidth='wide'))">
        <xsl:value-of select="concat(($weightincm) * (6),'cm')" />
      </xsl:when>
      <xsl:when test="(($weight &lt; '1.95')  and ($type = 'block') and ($arrowWidth='wide') and ($arrowLength='short')) or (($weight &lt; '1.95') and ($type = 'block') and ($arrowWidth='wide') and ($arrowLength='long')) or (($weight &lt; '1.95')  and ($type = 'block') and ($arrowWidth='wide'))">
        <xsl:value-of select="concat($lg-med,'cm')" />
      </xsl:when>
      <!-- selection for (bottom row arrow type) and non-selection of (arrow size as 'arrow') -->
      <xsl:when test="(($weight &gt; '2') and ($arrowWidth='wide') and ($arrowLength='short')) or (($weight &gt; '2') and ($arrowWidth='wide') and ($arrowLength='long')) or (($weight &gt; '2') and ($arrowWidth='wide'))">
        <xsl:value-of select="concat(($weightincm) * (5),'cm')" />
      </xsl:when>
      <xsl:when test="(($weight &lt; '2')  and ($arrowWidth='wide') and ($arrowLength='short')) or (($weight &lt; '2')  and ($arrowWidth='wide') and ($arrowLength='long')) or (($weight &lt; '2')  and ($arrowWidth='wide'))">
        <xsl:value-of select="concat($lg-sm,'cm')" />
      </xsl:when>

      <!-- selection for (middle row arrow type) and (arrow size as 'arrow') -->
      <xsl:when test="(($weight &gt; '2.25') and ($type = 'block') and ($arrowLength='short')) or (($weight &gt; '2.25') and ($type = 'block') and ($arrowLength='long')) or (($weight &gt; '2.25') and ($type = 'block'))">
        <xsl:value-of select="concat(($weightincm) * (4.5),'cm')" />
      </xsl:when>
      <xsl:when test="(($weight &lt; '2.25')  and ($type = 'block') and ($arrowLength='short')) or (($weight &lt; '2.25')  and ($type = 'block') and ($arrowLength='long')) or (($weight &lt; '2.25') and ($type = 'block'))">
        <xsl:value-of select="concat($med-med,'cm')" />
      </xsl:when>

      <!-- selection for (middle row arrow type) and non-selection of (arrow size as 'arrow') -->
      <xsl:when test="(($weight &gt; '2.25') and ($arrowLength='short')) or (($weight &gt; '2.25') and ($arrowLength='long')) or (($weight &gt; '2.25'))">
        <xsl:value-of select="concat(($weightincm) * (3),'cm')" />
      </xsl:when>
      <xsl:when test="(($weight &lt; '2.25') and ($arrowLength='short')) or (($weight &lt; '2.25') and ($arrowLength='long')) or (($weight &lt; '2.25'))">
        <xsl:value-of select="concat($med-sm,'cm')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($med-med,'cm')" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Sona Arrow Style as in Styles.xml-->
  <xsl:template name="InsertArrowStyle">
    <xsl:param name="shape"></xsl:param>
    <xsl:variable name="arrowTypeStart" select="$shape/v:stroke/@startarrow"></xsl:variable>
    <xsl:variable name="arrowTypeEnd" select="$shape/v:stroke/@endarrow"></xsl:variable>
    <xsl:if test="$arrowTypeStart">

      <xsl:choose>
        <xsl:when test="$arrowTypeStart='block'">
          <draw:marker draw:name="block" draw:display-name="Symmetric Arrow" svg:viewBox="0 0 20 30" svg:d="m10 0-10 30h20z" />
        </xsl:when>

        <!--Arrow-->
        <xsl:when test="$arrowTypeStart='open'">
          <draw:marker draw:name="open" draw:display-name="Line Arrow" svg:viewBox="0 0 1122 2243" svg:d="m0 2108v17 17l12 42 30 34 38 21 43 4 29-8 30-21 25-26 13-34 343-1532 339 1520 13 42 29 34 39 21 42 4 42-12 34-30 21-42v-39-12l-4 4-440-1998-9-42-25-39-38-25-43-8-42 8-38 25-26 39-8 42z" />
        </xsl:when>

        <!--Stealth-->
        <xsl:when test="$arrowTypeStart='classic'">
          <draw:marker draw:name="classic" draw:display-name="Arrow concave" svg:viewBox="0 0 1131 1580" svg:d="m1013 1491 118 89-567-1580-564 1580 114-85 136-68 148-46 161-17 161 13 153 46z" />
        </xsl:when>

        <!--Oval-->
        <xsl:when test="$arrowTypeStart='oval'">
          <draw:marker draw:name="oval" draw:display-name="Oval" svg:viewBox="0 0 1131 1131" svg:d="m462 1118-102-29-102-51-93-72-72-93-51-102-29-102-13-105 13-102 29-106 51-102 72-89 93-72 102-50 102-34 106-9 101 9 106 34 98 50 93 72 72 89 51 102 29 106 13 102-13 105-29 102-51 102-72 93-93 72-98 51-106 29-101 13z" />
        </xsl:when>

        <!--Diamond-->
        <xsl:when test="$arrowTypeStart='diamond'">
          <draw:marker draw:name="diamond" draw:display-name="Square" svg:viewBox="0 0 1131 1131" svg:d="m0 564 564 567 567-567-567-564z" />
        </xsl:when >
      </xsl:choose>
    </xsl:if>
    <xsl:if test="$arrowTypeEnd">
      <xsl:choose>
        <xsl:when test="$arrowTypeEnd='block'">
          <draw:marker draw:name="block" draw:display-name="Symmetric Arrow" svg:viewBox="0 0 20 30" svg:d="m10 0-10 30h20z" />
        </xsl:when>

        <!--Arrow-->
        <xsl:when test="$arrowTypeEnd='open'">
          <draw:marker draw:name="open" draw:display-name="Line Arrow" svg:viewBox="0 0 1122 2243" svg:d="m0 2108v17 17l12 42 30 34 38 21 43 4 29-8 30-21 25-26 13-34 343-1532 339 1520 13 42 29 34 39 21 42 4 42-12 34-30 21-42v-39-12l-4 4-440-1998-9-42-25-39-38-25-43-8-42 8-38 25-26 39-8 42z" />
        </xsl:when>

        <!--Stealth-->
        <xsl:when test="$arrowTypeEnd='classic'">
          <draw:marker draw:name="classic" draw:display-name="Arrow concave" svg:viewBox="0 0 1131 1580" svg:d="m1013 1491 118 89-567-1580-564 1580 114-85 136-68 148-46 161-17 161 13 153 46z" />
        </xsl:when>

        <!--Oval-->
        <xsl:when test="$arrowTypeEnd='oval'">
          <draw:marker draw:name="oval" draw:display-name="Oval" svg:viewBox="0 0 1131 1131" svg:d="m462 1118-102-29-102-51-93-72-72-93-51-102-29-102-13-105 13-102 29-106 51-102 72-89 93-72 102-50 102-34 106-9 101 9 106 34 98 50 93 72 72 89 51 102 29 106 13 102-13 105-29 102-51 102-72 93-93 72-98 51-106 29-101 13z" />
        </xsl:when>

        <!--Diamond-->
        <xsl:when test="$arrowTypeEnd='diamond'">
          <draw:marker draw:name="diamond" draw:display-name="Square" svg:viewBox="0 0 1131 1131" svg:d="m0 564 564 567 567-567-567-564z" />
        </xsl:when >
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="InsertShapeAutomaticWidth">
    <xsl:param name="shape" select="." />

	<xsl:variable name="wrapStyle">
      <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'mso-wrap-style:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-wrap-style:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'mso-wrap-style:')" />
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
	<xsl:variable name="fitToText">
      <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'mso-fit-shape-to-text:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-fit-shape-to-text:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'mso-fit-shape-to-text:')" />
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>

    <xsl:choose>
      <xsl:when test="($fitToText='t' and $wrapStyle!='') or  ($fitToText='true' and $wrapStyle!='') 
                or ($fitToText!='t' and $wrapStyle!='') or  ($fitToText!='true' and $wrapStyle!='')
                or ($shape/@w:wrap and $shape/@w:wrap != 'none')">
        <xsl:attribute name="fo:min-width">
          <xsl:text>0cm</xsl:text>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
    <!--Sona Wrap and resize-->
    <xsl:attribute name="fo:wrap-option">
      <xsl:choose>
        <xsl:when test="$wrapStyle='none'">
          <xsl:value-of select="'wrap'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'no-wrap'" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!--
  Summary: Inserts the common properties of a v:shape element
  Author: Clever Age
  Modified: makz (DIaLOGIKa)
  Date: 15.11.2007
  -->
  <xsl:template name="InsertCommonShapeProperties">
    <xsl:param name="shape" />
    <xsl:call-template name="InsertShapeStyleName">
      <xsl:with-param name="shape" select="$shape" />
    </xsl:call-template>
    <xsl:call-template name="InsertAnchorTypeAttribute">
      <xsl:with-param name="shape" select="$shape" />
    </xsl:call-template>
    <xsl:call-template name="InsertShapeWidth">
      <xsl:with-param name="shape" select="$shape" />
    </xsl:call-template>
    <xsl:call-template name="InsertShapeHeight">
      <xsl:with-param name="shape" select="$shape" />
    </xsl:call-template>
    <xsl:call-template name="InsertshapeAbsolutePos">
      <xsl:with-param name="shape" select="$shape" />
    </xsl:call-template>
  </xsl:template>

  <!--
    Summary: Inserts position of first end of line 
    Author:  Tomasz Mueller (Clever Age)
    Date: 29.10.2007
  -->
  <xsl:template name="InsertLinePos1">
    <xsl:param name="flip" />
    <xsl:attribute name="svg:x1">
      <xsl:call-template name="ConvertToCentimeters">
        <xsl:with-param name="length">
          <xsl:choose>
            <xsl:when test="contains($flip,'x')">
              <xsl:value-of select="substring-before(@to,',')" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="substring-before(@from,',')" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="svg:y1">
      <xsl:call-template name="ConvertToCentimeters">
        <xsl:with-param name="length">
          <xsl:choose>
            <xsl:when test="contains($flip,'y')">
              <xsl:value-of select="substring-after(@to,',')" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="substring-after(@from,',')" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:attribute>
  </xsl:template>

  <!--
    Summary: Inserts position of second end of line 
    Author:  Tomasz Mueller (Clever Age)
    Date: 29.10.2007
  -->
  <xsl:template name="InsertLinePos2">
    <xsl:param name="flip" />

    <xsl:attribute name="svg:x2">
      <xsl:call-template name="ConvertToCentimeters">
        <xsl:with-param name="length">
          <xsl:choose>
            <xsl:when test="contains($flip,'x')">
              <xsl:value-of select="substring-before(@from,',')" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="substring-before(@to,',')" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="svg:y2">
      <xsl:call-template name="ConvertToCentimeters">
        <xsl:with-param name="length">
          <xsl:choose>
            <xsl:when test="contains($flip,'y')">
              <xsl:value-of select="substring-after(@from,',')" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="substring-after(@to,',')" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:attribute>
  </xsl:template>

  <!--
    Summary: inserts the svg:x and svg:y attribute
    Author: Clever Age
  -->
  <xsl:template name="InsertshapeAbsolutePos">
    <xsl:param name="shape" select="." />

	<xsl:variable name="position">
      <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'position:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'position:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'position:')" />
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
	<xsl:variable name="LeftPercent">
      <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'mso-left-percent:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-left-percent:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'mso-left-percent:')" />
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
    <xsl:variable name="relH">
      <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'mso-position-horizontal-relative:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-position-horizontal-relative:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'mso-position-horizontal-relative:')" />
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
    <xsl:variable name="relV">
      <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'mso-position-vertical-relative:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-position-vertical-relative:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'mso-position-vertical-relative:')" />
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>

    <!--added by chhavi for vertical top-margin-area-->
	<xsl:variable name="alignV">
      <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'mso-position-vertical:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-position-vertical:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'mso-position-vertical:')" />
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
    <!--end here-->
    <xsl:variable name="currentSectPr" select="key('sectPr', number(ancestor-or-self::node()/@oox:s))" />
    <!-- added by chhavi to calulate top bottom left  and right margin and page height and width  in case of mirror margin-->
    <xsl:variable name="pageWidth">
      <xsl:choose>
        <xsl:when test="$currentSectPr =''" >
          <xsl:value-of select="($currentSectPr)/w:pgSz/@w:w" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="key('Part', 'word/document.xml')/w:document/w:body//w:sectPr/w:pgSz/@w:w" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="pageHeight">
      <xsl:choose>
        <xsl:when test="$currentSectPr =''" >
          <xsl:value-of select="($currentSectPr)/w:pgSz/@w:h" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="key('Part', 'word/document.xml')/w:document/w:body//w:sectPr/w:pgSz/@w:h" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="marTop">
      <xsl:choose>
        <xsl:when test="$currentSectPr =''" >
          <xsl:value-of select="($currentSectPr)/w:pgMar/@w:top" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="key('Part', 'word/document.xml')/w:document/w:body//w:sectPr/w:pgMar/@w:top" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="marBottom">
      <xsl:choose>
        <xsl:when test="$currentSectPr =''" >
          <xsl:value-of select="($currentSectPr)/w:pgMar/@w:bottom" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="key('Part', 'word/document.xml')/w:document/w:body//w:sectPr/w:pgMar/@w:bottom" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="marLeft">
      <xsl:choose>
        <xsl:when test="$currentSectPr =''" >
          <xsl:value-of select="($currentSectPr)/w:pgMar/@w:left" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="key('Part', 'word/document.xml')/w:document/w:body//w:sectPr/w:pgMar/@w:left" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="marRight">
      <xsl:choose>
        <xsl:when test="$currentSectPr =''" >
          <xsl:value-of select="($currentSectPr)/w:pgMar/@w:right" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="key('Part', 'word/document.xml')/w:document/w:body//w:sectPr/w:pgMar/@w:right" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="HorizontalWidth">
      <!--end here-->
      <xsl:choose>

        <xsl:when test="$relH='margin'">
          <xsl:value-of select="number($pageWidth) - number($marLeft) - number($marRight)" />
        </xsl:when>
        <xsl:when test="$relH='right-margin-area' or $relH='inner-margin-area'">
          <xsl:value-of select="number($pageWidth) - number($marRight)" />
        </xsl:when>

        <xsl:otherwise>
          <xsl:value-of select="number($pageWidth)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="VerticalHeight">
      <xsl:choose>
        <!--  or $relV='inner-margin-area'-->
        <xsl:when test="$relV='bottom-margin-area'">
          <xsl:value-of select="number($pageHeight) - number($marBottom)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="number($pageHeight)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="myId">
      <xsl:variable name="myFileName" select="substring-after(ancestor::oox:part/@oox:name, 'word/')" />
      <xsl:value-of select="key('Part', 'word/_rels/document.xml.rels')/rels:Relationships/rels:Relationship[@Target=$myFileName]/@Id" />
    </xsl:variable>
    <xsl:variable name="myFooterSectPr" select="key('Part', 'word/document.xml')/w:document/w:body//w:sectPr[w:footerReference/@r:id=$myId]" />
    <xsl:variable name="myHeaderSectPr" select="key('Part', 'word/document.xml')/w:document/w:body//w:sectPr[w:headerReference/@r:id=$myId]" />

    <!-- 
    Don't insert svg:x and svg:y if the shape is part of the group.
    This workaround must be removed if group positioning is implemented.
    Wrong x and y values of elements inside of a group causes Open Office to crash.
    
    See bug: 1747143
    -->
    <xsl:if test="name($shape/..)!='v:group'">
      <xsl:variable name="posX">
        <xsl:if test="not(contains($shape/@style,'mso-left-percent'))">
          <xsl:variable name="x">
            <xsl:choose>
              <xsl:when test="$LeftPercent &gt; 0">
                <xsl:value-of select="$HorizontalWidth * $LeftPercent div 1000" />
              </xsl:when>

              <!-- Sona: Fixed Defect #1990593-->
              <xsl:when test="$shape[name()='v:rect' or name()='v:line']">
                <xsl:choose>
                  <xsl:when test="contains($shape/@style,'margin-left')">
					<xsl:variable name="margLeft">
					  <xsl:choose>
						<xsl:when test="substring-before(substring-after($shape/@style,'margin-left:'), ';')">
						  <xsl:value-of select="substring-before(substring-after($shape/@style,'margin-left:'), ';')" />
						</xsl:when>
						<xsl:otherwise>
						  <xsl:value-of select="substring-after($shape/@style,'margin-left:')" />
						</xsl:otherwise>
					  </xsl:choose>
					</xsl:variable>
                    <xsl:variable name="marginLeft">
                      <xsl:choose>
                        <xsl:when test="$margLeft != 0">
						  <xsl:choose>
						    <xsl:when test="contains($margLeft,'cm')">
							  <xsl:value-of select="concat(number(substring-before($margLeft, 'cm')) * 1.0, 'cm')" />
						    </xsl:when>
						    <xsl:when test="contains($margLeft,'mm')">
							  <xsl:value-of select="concat(number(substring-before($margLeft, 'mm')) * 0.1, 'cm')" />
						    </xsl:when>
						    <xsl:when test="contains($margLeft,'in')">
							  <xsl:value-of select="concat(number(substring-before($margLeft, 'in')) * 2.54, 'cm')" />
						    </xsl:when>
						    <xsl:when test="contains($margLeft,'pt')">
							  <xsl:value-of select="concat(number(substring-before($margLeft, 'pt')) * 2.54 div 72.0, 'cm')" />
						    </xsl:when>
						    <xsl:when test="contains($margLeft,'twip')">
							  <xsl:value-of select="concat(number(substring-before($margLeft, 'twip')) * 2.54 div 1440, 'cm')" />
						    </xsl:when>
						    <xsl:when test="contains($margLeft,'pica')">
							  <xsl:value-of select="concat(number(substring-before($margLeft, 'pica')) * 2.54 div 6.0, 'cm')" />
						    </xsl:when>
						    <xsl:when test="contains($margLeft,'dpt')">
							  <xsl:value-of select="concat(number(substring-before($margLeft, 'dpt')) * 2.54 div 72.0, 'cm')" />
						    </xsl:when>
						    <xsl:when test="contains($margLeft,'px')">
							  <xsl:value-of select="concat(number(substring-before($margLeft, 'px')) * 2.54 div 96.0, 'cm')" />
						    </xsl:when>
						    <xsl:otherwise>
							  <xsl:value-of select="concat(number(substring-before($margLeft, 'twip')) * 2.54 div 1440, 'cm')" />
						    </xsl:otherwise>
						  </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="'0'" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>

                    <xsl:choose>
                      <!-- Sona: #2149141 changes because mirror margins was lost-->
                      <xsl:when test="$relH='right-margin-area'">
                        <xsl:variable name="horWidth" select="concat($HorizontalWidth * 2.54 div 1440.0, 'cm')" />
                        <!-- concat((substring-before($horWidth,'cm')+substring-before($marginLeft,'cm')),'cm')-->
                        <xsl:value-of select="$marginLeft" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="$marginLeft" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
					<xsl:choose>
					  <xsl:when test="substring-before(substring-after($shape/@style,'left:'), ';')">
						<xsl:value-of select="substring-before(substring-after($shape/@style,'left:'), ';')" />
					  </xsl:when>
					  <xsl:otherwise>
						<xsl:value-of select="substring-after($shape/@style,'left:')" />
					  </xsl:otherwise>
					</xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
				<xsl:variable name="margLeft">
		          <xsl:choose>
					<xsl:when test="substring-before(substring-after($shape/@style,'margin-left:'), ';')">
					  <xsl:value-of select="substring-before(substring-after($shape/@style,'margin-left:'), ';')" />
					</xsl:when>
					<xsl:otherwise>
					  <xsl:value-of select="substring-after($shape/@style,'margin-left:')" />
					</xsl:otherwise>
				  </xsl:choose>
		        </xsl:variable>
                <xsl:variable name="marginLeft">
                  <xsl:choose>
                    <xsl:when test="$margLeft != 0">
					  <xsl:choose>
					    <xsl:when test="contains($margLeft,'cm')">
						  <xsl:value-of select="concat(number(substring-before($margLeft, 'cm')) * 1.0, 'cm')" />
					    </xsl:when>
					    <xsl:when test="contains($margLeft,'mm')">
						  <xsl:value-of select="concat(number(substring-before($margLeft, 'mm')) * 0.1, 'cm')" />
					    </xsl:when>
					    <xsl:when test="contains($margLeft,'in')">
						  <xsl:value-of select="concat(number(substring-before($margLeft, 'in')) * 2.54, 'cm')" />
					    </xsl:when>
					    <xsl:when test="contains($margLeft,'pt')">
						  <xsl:value-of select="concat(number(substring-before($margLeft, 'pt')) * 2.54 div 72.0, 'cm')" />
					    </xsl:when>
					    <xsl:when test="contains($margLeft,'twip')">
						  <xsl:value-of select="concat(number(substring-before($margLeft, 'twip')) * 2.54 div 1440, 'cm')" />
					    </xsl:when>
					    <xsl:when test="contains($margLeft,'pica')">
						  <xsl:value-of select="concat(number(substring-before($margLeft, 'pica')) * 2.54 div 6.0, 'cm')" />
					    </xsl:when>
					    <xsl:when test="contains($margLeft,'dpt')">
						  <xsl:value-of select="concat(number(substring-before($margLeft, 'dpt')) * 2.54 div 72.0, 'cm')" />
					    </xsl:when>
					    <xsl:when test="contains($margLeft,'px')">
						  <xsl:value-of select="concat(number(substring-before($margLeft, 'px')) * 2.54 div 96.0, 'cm')" />
					    </xsl:when>
					    <xsl:otherwise>
						  <xsl:value-of select="concat(number(substring-before($margLeft, 'twip')) * 2.54 div 1440, 'cm')" />
					    </xsl:otherwise>
					  </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="'0'" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>

                <xsl:choose>
                  <!-- Sona: #2149141 changes because mirror margins was lost-->
                  <xsl:when test="$relH='right-margin-area'">
                    <xsl:variable name="horWidth" select="concat($HorizontalWidth * 2.54 div 1440.0, 'cm')" />
                    <xsl:value-of select="$marginLeft" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$marginLeft" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:value-of select="$x" />

        </xsl:if>
      </xsl:variable>
      <xsl:if test="$posX !='' and not(contains($shape/@style,'rotation'))">
        <xsl:attribute name="svg:x">
          <xsl:choose>
            <xsl:when test="contains($posX, 'cm')">
              <xsl:value-of select="$posX" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($posX, 'cm')" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <xsl:variable name="posY">
        <xsl:if test="not(contains($shape/@style,'mso-top-percent'))">
          <xsl:variable name="y">
            <xsl:choose>
              <!-- Sona: Fixed Defect #1990593-->
              <xsl:when test="$shape[name()='v:rect' or name()='v:line']">
                <xsl:choose>
                  <xsl:when test="contains($shape/@style,'margin-top')">
					<xsl:variable name="margTop">
					  <xsl:choose>
						<xsl:when test="substring-before(substring-after($shape/@style,'margin-top:'), ';')">
						  <xsl:value-of select="substring-before(substring-after($shape/@style,'margin-top:'), ';')" />
						</xsl:when>
						<xsl:otherwise>
						  <xsl:value-of select="substring-after($shape/@style,'margin-top:')" />
						</xsl:otherwise>
					  </xsl:choose>
					</xsl:variable>
					<xsl:variable name="marginTop">
					  <xsl:choose>
					    <xsl:when test="contains($margTop,'cm')">
						  <xsl:value-of select="concat(number(substring-before($margTop, 'cm')) * 1.0, 'cm')" />
					    </xsl:when>
					    <xsl:when test="contains($margTop,'mm')">
						  <xsl:value-of select="concat(number(substring-before($margTop, 'mm')) * 0.1, 'cm')" />
					    </xsl:when>
					    <xsl:when test="contains($margTop,'in')">
						  <xsl:value-of select="concat(number(substring-before($margTop, 'in')) * 2.54, 'cm')" />
					    </xsl:when>
					    <xsl:when test="contains($margTop,'pt')">
						  <xsl:value-of select="concat(number(substring-before($margTop, 'pt')) * 2.54 div 72.0, 'cm')" />
					    </xsl:when>
					    <xsl:when test="contains($margTop,'twip')">
						  <xsl:value-of select="concat(number(substring-before($margTop, 'twip')) * 2.54 div 1440, 'cm')" />
					    </xsl:when>
					    <xsl:when test="contains($margTop,'pica')">
						  <xsl:value-of select="concat(number(substring-before($margTop, 'pica')) * 2.54 div 6.0, 'cm')" />
					    </xsl:when>
					    <xsl:when test="contains($margTop,'dpt')">
						  <xsl:value-of select="concat(number(substring-before($margTop, 'dpt')) * 2.54 div 72.0, 'cm')" />
					    </xsl:when>
					    <xsl:when test="contains($margTop,'px')">
						  <xsl:value-of select="concat(number(substring-before($margTop, 'px')) * 2.54 div 96.0, 'cm')" />
					    </xsl:when>
					    <xsl:otherwise>
						  <xsl:value-of select="concat(number(substring-before($margTop, 'twip')) * 2.54 div 1440, 'cm')" />
					    </xsl:otherwise>
					  </xsl:choose>
				    </xsl:variable>
                    <xsl:choose>

                      <!--added by chhavi for vertical alignment bottom-margin-area-->
                      <xsl:when test="$relV='bottom-margin-area' and $marginTop ='0cm'">
                        <xsl:choose>
                          <xsl:when test="$alignV = 'top'">
                            <xsl:value-of select="concat((($pageHeight - $marBottom) div 1440) * 2.54 , 'cm') " />
                          </xsl:when>
                          <xsl:when test="$alignV = 'center'">
                            <xsl:value-of select="concat((($pageHeight div 1440) - ($marBottom div 2880) - ((number(substring-before(substring-after(./@style,'height:'),'pt;'))) div 144))* 2.54 , 'cm') " />
                          </xsl:when>
                          <xsl:when test="$alignV = 'bottom'">
                            <xsl:value-of select="concat((($pageHeight div 1440) - ((number(substring-before(substring-after(./@style,'height:'),'pt;'))) div 72)) * 2.54 ,'cm')" />
                          </xsl:when>
                        </xsl:choose>
                      </xsl:when>
                      <!--end here-->
                      <!-- or $relV='inner-margin-area'-->
                      <xsl:when test="$relV='bottom-margin-area'">
                        <xsl:variable name="vertHeight" select="concat($VerticalHeight * 2.54 div 1440.0, 'cm')" />
                        <xsl:value-of select="concat((substring-before($vertHeight,'cm')+substring-before($marginTop,'cm')),'cm')" />
                      </xsl:when>
                      <!--changed for below of line-->
                      <!--<xsl:when test="$relV='line'">
                        <xsl:value-of select="concat(number(substring-before($marginTop,'cm')) * -1,'cm')" />
                      </xsl:when>-->
                      <!--added by chhavi for vertical alignment top-margin-area-->
                      <xsl:when test="$relV='top-margin-area' and $marginTop ='0cm'" >
                        <xsl:choose>

                          <xsl:when test="$alignV = 'center'">
                            <xsl:value-of select="concat(((($marTop div 1440) div 2) - (number(substring-before(substring-after(./@style,'height:'),'pt;'))) div 144)*2.54 ,'cm')" />
                          </xsl:when>
                          <xsl:when test="$alignV = 'bottom'">
                            <xsl:value-of select="concat(((($marTop div 1440)) - (number(substring-before(substring-after(./@style,'height:'),'pt;'))) div 72)* 2.54 , 'cm')" />
                          </xsl:when>

                        </xsl:choose>
                      </xsl:when>
                      <!--end here-->

                      <xsl:otherwise>
                        <xsl:value-of select="$marginTop"></xsl:value-of>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
				    <xsl:choose>
					  <xsl:when test="substring-before(substring-after($shape/@style,'top:'), ';')">
					    <xsl:value-of select="substring-before(substring-after($shape/@style,'top:'), ';')" />
					  </xsl:when>
					  <xsl:otherwise>
					    <xsl:value-of select="substring-after($shape/@style,'top:')" />
					  </xsl:otherwise>
				    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <!-- shape is in document -->
              <xsl:otherwise>
				<xsl:variable name="margTop">
				  <xsl:choose>
					<xsl:when test="substring-before(substring-after($shape/@style,'margin-top:'), ';')">
					  <xsl:value-of select="substring-before(substring-after($shape/@style,'margin-top:'), ';')" />
					</xsl:when>
					<xsl:otherwise>
					  <xsl:value-of select="substring-after($shape/@style,'margin-top:')" />
					</xsl:otherwise>
				  </xsl:choose>
				</xsl:variable>
				<xsl:variable name="marginTop">
				  <xsl:choose>
				    <xsl:when test="contains($margTop,'cm')">
					  <xsl:value-of select="concat(number(substring-before($margTop, 'cm')) * 1.0, 'cm')" />
				    </xsl:when>
				    <xsl:when test="contains($margTop,'mm')">
					  <xsl:value-of select="concat(number(substring-before($margTop, 'mm')) * 0.1, 'cm')" />
				    </xsl:when>
				    <xsl:when test="contains($margTop,'in')">
					  <xsl:value-of select="concat(number(substring-before($margTop, 'in')) * 2.54, 'cm')" />
				    </xsl:when>
				    <xsl:when test="contains($margTop,'pt')">
					  <xsl:value-of select="concat(number(substring-before($margTop, 'pt')) * 2.54 div 72.0, 'cm')" />
				    </xsl:when>
				    <xsl:when test="contains($margTop,'twip')">
					  <xsl:value-of select="concat(number(substring-before($margTop, 'twip')) * 2.54 div 1440, 'cm')" />
				    </xsl:when>
				    <xsl:when test="contains($margTop,'pica')">
					  <xsl:value-of select="concat(number(substring-before($margTop, 'pica')) * 2.54 div 6.0, 'cm')" />
				    </xsl:when>
				    <xsl:when test="contains($margTop,'dpt')">
					  <xsl:value-of select="concat(number(substring-before($margTop, 'dpt')) * 2.54 div 72.0, 'cm')" />
				    </xsl:when>
				    <xsl:when test="contains($margTop,'px')">
					  <xsl:value-of select="concat(number(substring-before($margTop, 'px')) * 2.54 div 96.0, 'cm')" />
				    </xsl:when>
				    <xsl:otherwise>
					  <xsl:value-of select="concat(number(substring-before($margTop, 'twip')) * 2.54 div 1440, 'cm')" />
				    </xsl:otherwise>
				  </xsl:choose>
			    </xsl:variable>
                <xsl:choose>

                  <!--added by chhavi for vertical alignment bottom-margin-area-->
                  <xsl:when test="$relV='bottom-margin-area' and $marginTop ='0cm'">
                    <xsl:choose>
                      <xsl:when test="$alignV = 'top'">
                        <xsl:value-of select="concat((($pageHeight - $marBottom) div 1440) * 2.54 , 'cm') " />
                      </xsl:when>
                      <xsl:when test="$alignV = 'center'">
                        <xsl:value-of select="concat((($pageHeight div 1440) - ($marBottom div 2880) - ((number(substring-before(substring-after(./@style,'height:'),'pt;'))) div 144))* 2.54 , 'cm') " />
                      </xsl:when>
                      <xsl:when test="$alignV = 'bottom'">
                        <xsl:value-of select="concat((($pageHeight div 1440) - ((number(substring-before(substring-after(./@style,'height:'),'pt;'))) div 72)) * 2.54 ,'cm')" />
                      </xsl:when>
                    </xsl:choose>
                  </xsl:when>
                  <!--end here-->
                  <!--or $relV='inner-margin-area'-->
                  <xsl:when test="$relV='bottom-margin-area'">
                    <xsl:variable name="vertHeight" select="concat($VerticalHeight * 2.54 div 1440.0, 'cm')" />
                    <xsl:value-of select="concat((substring-before($vertHeight,'cm')+substring-before($marginTop,'cm')),'cm')" />
                  </xsl:when>
                  <!--chnaged for below of line-->
                  <!--<xsl:when test="$relV='line'">
                    <xsl:value-of select="concat(number(substring-before($marginTop,'cm')) * -1,'cm')" />
                  </xsl:when>-->
                  <!--added by chhavi for vertical alignment top-margin-area-->
                  <xsl:when test="$relV='top-margin-area' and $marginTop ='0cm'" >
                    <xsl:choose>
                      <xsl:when test="$alignV = 'center'">
                        <xsl:value-of select="concat(((($marTop div 1440) div 2) - (number(substring-before(substring-after(./@style,'height:'),'pt;'))) div 144)*2.54 ,'cm')" />
                      </xsl:when>
                      <xsl:when test="$alignV = 'bottom'">
                        <xsl:value-of select="concat(((($marTop div 1440)) - (number(substring-before(substring-after(./@style,'height:'),'pt;'))) div 72)* 2.54 , 'cm')" />
                      </xsl:when>
                    </xsl:choose>
                  </xsl:when>
                  <!--end here-->

                  <xsl:otherwise>
                    <xsl:value-of select="$marginTop"></xsl:value-of>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:value-of select="$y" />

        </xsl:if>
      </xsl:variable>
      <xsl:if test="$posY !='' and not(contains($shape/@style,'rotation'))">
        <xsl:attribute name="svg:y">
          <xsl:choose>
            <xsl:when test="contains($posY, 'cm')">
              <xsl:value-of select="$posY" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($posY, 'cm')" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>

	  <xsl:variable name="relativeHeight">
		<xsl:choose>
				  <xsl:when test="substring-before(substring-after($shape/@style,'mso-top-percent:'), ';')">
					<xsl:value-of select="substring-before(substring-after($shape/@style,'mso-top-percent:'), ';')" />
				  </xsl:when>
				  <xsl:otherwise>
					<xsl:value-of select="substring-after($shape/@style,'mso-top-percent:')" />
				  </xsl:otherwise>
				</xsl:choose>
	  </xsl:variable>

      <xsl:variable name="verRelPos">
        <xsl:if test="contains($shape/@style,'mso-top-percent')">
          <xsl:choose>
            <xsl:when test="contains($shape/@style,'mso-position-vertical-relative:margin')">
              <!--<xsl:value-of select="ancestor::node()/w:sectPr/w:pgSz/@w:h div 1440 * ($relativeHeight div 1000)" />-->
              <xsl:value-of select="((($pageHeight div 1440)-($marTop div 1440)- ($marBottom div 1440))) * ($relativeHeight div 1000)" />
            </xsl:when>
            <xsl:when test="contains($shape/@style,'mso-position-vertical-relative:top-margin-area')">
              <xsl:value-of select="$marTop div 1440 * ($relativeHeight div 1000) " />
            </xsl:when>
            <xsl:when test="contains($shape/@style,'mso-position-vertical-relative:bottom-margin-area')">
              <!--<xsl:value-of select="$marBottom div 1440 " />-->
              <!--<xsl:value-of select="(//w:pgSz/@w:h div 1440) -(($marBottom div 1440) * ($relativeHeight div 1000))" />-->
              <!--<xsl:value-of select="((ancestor::node()/w:sectPr/w:pgSz/@w:h div 1440)-($marBottom div 1440)) +($marBottom div 1440 * $relativeHeight div 1000)" />-->
              <xsl:value-of select="(($pageHeight div 1440))-((1-($relativeHeight div 1000))* ($marBottom div 1440)) " />
            </xsl:when>
            <xsl:when test="contains($shape/@style,'mso-position-vertical-relative:inner-margin-area')">
              <xsl:value-of select="$marTop div 1440 * ($relativeHeight div 1000) " />
            </xsl:when>
            <xsl:when test="contains($shape/@style,'mso-position-vertical-relative:outer-margin-area')">
              <xsl:value-of select="$marBottom div 1440 * ($relativeHeight div 1000)" />
            </xsl:when>
            <xsl:when test="contains($shape/@style,'mso-position-vertical-relative:page')">
              <xsl:value-of select="$pageHeight div 1440 * ($relativeHeight div 1000)" />
            </xsl:when>
            <!--<xsl:otherwise>
            <xsl:value-of select="//w:pgSz/@w:h div 1440" />
          </xsl:otherwise>-->
          </xsl:choose>
        </xsl:if>
      </xsl:variable>
      <xsl:if test="$verRelPos !='' and not(contains($shape/@style,'rotation'))">
        <xsl:attribute name="svg:y">
          <xsl:value-of select="concat((format-number($verRelPos*2.54,'#.##')),'cm')" />
        </xsl:attribute>
      </xsl:if>

	  <xsl:variable name="relativeWidth">
		<xsl:choose>
				  <xsl:when test="substring-before(substring-after($shape/@style,'mso-left-percent:'), ';')">
					<xsl:value-of select="substring-before(substring-after($shape/@style,'mso-left-percent:'), ';')" />
				  </xsl:when>
				  <xsl:otherwise>
					<xsl:value-of select="substring-after($shape/@style,'mso-left-percent:')" />
				  </xsl:otherwise>
				</xsl:choose>
	  </xsl:variable>

      <xsl:variable name="horRelPos">
        <xsl:if test="contains($shape/@style,'mso-left-percent')">

          <xsl:choose>
            <xsl:when test="contains($shape/@style,'mso-position-horizontal-relative:margin')">
              <xsl:value-of select="((($pageWidth div 1440)- ($marRight div 1440)- ($marLeft div 1440)))* ($relativeWidth div 1000)" />
            </xsl:when>
            <xsl:when test="contains($shape/@style,'mso-position-horizontal-relative:left-margin-area')">
              <xsl:value-of select="$marLeft div 1440 * ($relativeWidth div 1000)" />
            </xsl:when>
            <xsl:when test="contains($shape/@style,'mso-position-horizontal-relative:right-margin')">
              <!--<xsl:value-of select="((//w:pgSz/@w:w div 1440)-($marRight div 1440))) -(($marRight div 1440) * ($relativeWidth div 1000))" />-->

              <xsl:value-of select="($marRight div 1440 * $relativeWidth div 1000)" />
            </xsl:when>
            <!-- Sona: #2149141 changes because mirror margins was lost-->
            <xsl:when test="contains($shape/@style,'mso-position-horizontal-relative:inner-margin-area')">
              <xsl:value-of select="$marLeft div 1440 * ($relativeWidth div 1000) " />
            </xsl:when>
            <!--chnaged by chhavi marright to marleft-->
            <xsl:when test="contains($shape/@style,'mso-position-horizontal-relative:outer-margin-area')">
              <xsl:value-of select="$marLeft div 1440 * ($relativeWidth div 1000)" />
            </xsl:when>
            <xsl:when test="contains($shape/@style,'mso-position-horizontal-relative:page')">
              <xsl:value-of select="$pageWidth div 1440 * ($relativeWidth div 1000)" />
            </xsl:when>
            <!--<xsl:otherwise>
            <xsl:value-of select="//w:pgSz/@w:w div 1440" />
          </xsl:otherwise>-->
          </xsl:choose>
        </xsl:if>
      </xsl:variable>
      <xsl:if test="$horRelPos !='' and not(contains($shape/@style,'rotation'))">
        <xsl:attribute name="svg:x">
          <xsl:value-of select="concat((format-number($horRelPos * 2.54,'#.##')),'cm')" />
        </xsl:attribute>
      </xsl:if>
      <!--Sona : Rotation Implementation -->
      <xsl:variable name="shapeTypeId" select="substring-after($shape/@type,'#')" />
      <xsl:variable name="pathId">
        <xsl:choose>
          <xsl:when test="@path">
            <xsl:value-of select="@path" />
          </xsl:when>
          <xsl:when test="$shapeTypeId">
            <xsl:value-of select="key('shapeTypeById', $shapeTypeId)[1]/@path" />
          </xsl:when>
        </xsl:choose>
      </xsl:variable>

      <xsl:if test="contains($shape/@style,'rotation')">
        <xsl:variable name="xCord">
          <xsl:choose>
            <xsl:when test="$horRelPos !=''">
              <xsl:call-template name="emu-measure">
                <xsl:with-param name="length" select="concat((format-number($horRelPos * 2.54,'#.##')),'cm')" />
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="emu-measure">
                <xsl:with-param name="length" select="$posX" />
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="yCord">
          <xsl:choose>
            <xsl:when test="$verRelPos !=''">
              <xsl:call-template name="emu-measure">
                <xsl:with-param name="length" select="concat((format-number($verRelPos*2.54,'#.##')),'cm')" />
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="emu-measure">
                <xsl:with-param name="length" select="$posY" />
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="xCenter">
          <xsl:call-template name="emu-measure">
            <xsl:with-param name="length" select="substring-before(substring-after($shape/@style,concat('width',':')),';')" />
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="yCenter">
          <xsl:call-template name="emu-measure">
            <xsl:with-param name="length" select="substring-before(substring-after($shape/@style,concat('height',':')),';')" />
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="var_flipH">
          <xsl:choose>
            <xsl:when test="contains($shape/@style,'flip:x y')">
              <xsl:value-of select="'1'" />
            </xsl:when>
            <xsl:when test="contains($shape/@style,'flip:x')">
              <xsl:value-of select="'1'" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'0'" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="var_flipV">
          <xsl:choose>
            <xsl:when test="contains($shape/@style,'flip:x y')">
              <xsl:value-of select="'1'" />
            </xsl:when>
            <xsl:when test="contains($shape/@style,'flip:y')">
              <xsl:value-of select="'1'" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'0'" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="angle">
          <xsl:variable name="tmprotval" select="substring-after($shape/@style,'rotation:')"/>
          <xsl:variable name="rotval">
            <xsl:choose>
            <xsl:when test="contains($tmprotval,'fd')">
              <xsl:value-of select="number(substring-before($tmprotval,'fd;')) div 60000"/>
            </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-before($tmprotval,';')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$var_flipH='0' and $var_flipV='1'">
              <xsl:call-template name="emu-measure">
                <xsl:with-param name="length" select="concat(360 - $rotval,'degrees')" />
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="emu-measure">
                <xsl:with-param name="length" select="concat($rotval,'degrees')" />
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="draw:transform">
          <xsl:value-of select="concat('ooc-draw-transform-oop-',$xCord, ':',$yCord, ':',$xCenter, ':', $yCenter, ':', $var_flipH, ':', $var_flipV, ':', $angle, '-ooe')" />
        </xsl:attribute>
      </xsl:if>
    </xsl:if>
  </xsl:template>
  <!--added by Vipul for shape flip without rotation-->
  <xsl:template name="tmpFlipwitoutRotation">
    <xsl:param name="flipH"/>
    <xsl:param name="flipV"/>
    <xsl:if test="$flipH='1'">
      <xsl:attribute name="draw:mirror-horizontal">
        <xsl:value-of select="'true'"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="$flipV='1'">
      <xsl:attribute name="draw:mirror-vertical">
        <xsl:value-of select="'true'"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
  <!--added by chhavi for alttext-->
  <xsl:template name="InsertAlternativeTextElement">
    <xsl:param name="shape" select="." />
    <xsl:if test="$shape/@alt!=''">
      <svg:desc>
        <xsl:value-of select="$shape/@alt" />
      </svg:desc>
    </xsl:if>
  </xsl:template>
  <!--end here-->

  <!--
  Summary: Writes the anchor-type attribute
  Author: Clever Age
  Modified: makz (DIaLOGIKa)
  Date: 19.10.2007
  -->
  <xsl:template name="InsertAnchorTypeAttribute">
    <xsl:param name="shape" select="." />

    <!-- 
			don't write anchor-type if the shape is part of a group.
			grouped elements are always anchored by their group.
		-->
    <xsl:if test="name($shape/..)!='v:group'">
      <xsl:attribute name="text:anchor-type">
        <xsl:choose>
          <!-- 
						makz: default for word inline shape elements.
							If no wrap is definied the style does not contain position information
							Fix #1786094
						20080714/divo: corrected condition for inline: if no position is specified or position 
							is 'static' the object is inline (see p4365f of the Part 4 of the OpenXML spec, position attribute of VML style attribute)
						-->
          <xsl:when test="not(w10:wrap) and (not(contains($shape/@style, 'position:')) or contains($shape/@style, 'position:static'))">
            <xsl:text>as-char</xsl:text>
          </xsl:when>

          <xsl:when test="w10:wrap/@type='none'">
            <xsl:text>as-char</xsl:text>
          </xsl:when>

          <!-- 
						anchor should be 'as-char' in some particular cases.
						Explanation of test :
						1. if no wrap is defined (default in OOX is inline with text)
						2. if there is another run in current paragraph OR we are in a table cell
						3. No absolute position is defined OR wrapping is explicitely set to 'as-char'

						JP 27/08/2007 
						Fix #1666915 if position is absolute must not be set as-char
						-->
          <xsl:when
					  test="not(w10:wrap) 
						  and (count(ancestor::w:r[1]/parent::node()/w:r) &gt; 1  or (not(count(ancestor::w:r[1]/parent::node()/w:r) &gt; 1) and ancestor::w:tc)) 
						  and (not(contains($shape/@style, 'position:absolute')))
						  and (contains($shape/@style, 'mso-position-horizontal-relative:text') or contains($shape/@style, 'mso-position-vertical-relative:text') or ($shape/@vAnchor='text') or ($shape/@hAnchor='relative') )">
            <xsl:text>as-char</xsl:text>
          </xsl:when>

          <!--
						makz: anchors in headers and footer which are not not as-char (if the previous conditions failed) 
						must be paragraph because because the frame/shape would no longer be in header if the 
						anchor is not set to paragraph or as-char
						-->
          <xsl:when test="(ancestor::w:hdr or ancestor::w:ftr) and (w10:wrap/@type!='' or $shape/@w:wrap!='')">
            <!-- Warning Messages 
						  <xsl:if test="ancestor::w:hdr">
							<xsl:message terminate="no">translation.oox2odf.frame.inHeader</xsl:message>
						  </xsl:if>
						  <xsl:if test="ancestor::w:ftr">
							<xsl:message terminate="no">translation.oox2odf.frame.inFooter</xsl:message>
						  </xsl:if>
						  -->
            <xsl:text>paragraph</xsl:text>
          </xsl:when>
          <!-- Sona changed parameter for defect #1844731-->
          <!--one more condition added for anchor shape-->
          <xsl:when test="(w10:wrap/@anchorx='page' and w10:wrap/@anchory='page') 
          or ($shape/@w:hAnchor='page' and $shape/@w:vAnchor='page')
          or (contains($shape/@style, 'mso-position-horizontal-relative:char')) 
          or (contains($shape/@style, 'mso-position-vertical-relative:line'))">
            <xsl:text>char</xsl:text>
          </xsl:when>
          <!-- added by chhavi to fix bug realted to vertical position to inside outside margin for office 2003-->
          <xsl:when test="(w10:wrap/@anchorx='page') and (contains($shape/@style, 'mso-position-vertical-relative:outer-margin-area') or contains($shape/@style, 'mso-position-vertical-relative:inner-margin-area'))">
            <xsl:text>page</xsl:text>
          </xsl:when>
          <!--end here-->
          <xsl:otherwise>
            <xsl:text>paragraph</xsl:text>
          </xsl:otherwise>

        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!--
  Summary:  Inserts the z-index for a draw:shape or draw.frame
  Author:   CleverAge
  Modified: makz (DIaLOGIKa)
  Params:   shape: The VML shape
  -->
  <xsl:template name="InsertShapeZindexAttribute">
    <xsl:param name="shape" select="." />

	<xsl:variable name="z-index">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'z-index:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'z-index:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'z-index:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>

    <xsl:attribute name="draw:z-index">
      <xsl:call-template name="NormalizeZIndex">
        <xsl:with-param name="z-index" select="$z-index" />
      </xsl:call-template>
    </xsl:attribute>

  </xsl:template>

  <xsl:template name="InsertShapeStyleName">
    <!--<xsl:param name="shape" select="ancestor::w:pict | ancestor::w:object" />-->
    <xsl:choose>
      <xsl:when test="self::v:shape">
        <xsl:attribute name="draw:style-name">
          <!--Code changed by yeswanth.s : bug #2207550-->
          <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', concat(./@id,generate-id(parent::node())), '-ooe')" />
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="self::o:OLEObject">
        <xsl:attribute name="draw:style-name">
          <xsl:value-of select="generate-id(../v:shape)" />
          <!--<xsl:value-of select="./@id" />-->
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
    <!--TODO-->
    <xsl:attribute name="draw:name">
      <xsl:text>Frame1</xsl:text>
    </xsl:attribute>

  </xsl:template>

  <xsl:template name="InsertShapeHeight">
    <xsl:param name="shape" select="." />

    <xsl:variable name="height">
      <xsl:choose>
        <xsl:when test="$shape[name()='w:framePr']">
          <xsl:value-of select="$shape/@w:h" />
        </xsl:when>
        <xsl:otherwise>
		  <xsl:choose>
		    <xsl:when test="substring-before(substring-after($shape/@style,'height:'), ';')">
			  <xsl:value-of select="substring-before(substring-after($shape/@style,'height:'), ';')" />
		    </xsl:when>
		    <xsl:otherwise>
			  <xsl:value-of select="substring-after($shape/@style,'height:')" />
		    </xsl:otherwise>
		  </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="relativeHeight">
      <xsl:choose>
        <xsl:when test="$shape[name()='w:framePr']" />
        <xsl:otherwise>
		  <xsl:choose>
		    <xsl:when test="substring-before(substring-after($shape/@style,'mso-height-percent:'), ';')">
			  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-height-percent:'), ';')" />
		    </xsl:when>
		    <xsl:otherwise>
			  <xsl:value-of select="substring-after($shape/@style,'mso-height-percent:')" />
		    </xsl:otherwise>
		  </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <!-- Sona: Change in height code-->
      <xsl:when test="$relativeHeight != '' and $relativeHeight != 0">
        <xsl:call-template name="InsertShapeRelativeHeight">
          <xsl:with-param name="shape" select="$shape" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="not(contains($shape/v:textbox/@style, 'mso-fit-shape-to-text:t')) or $shape/@w:h or
                         (contains($shape/v:textbox/@style, 'mso-fit-shape-to-text:t') and 
                not(contains($shape/@style,'mso-wrap-style:none')))">
          <xsl:attribute name="svg:height">
			<xsl:choose>
			  <xsl:when test="contains($height,'cm')">
				<xsl:value-of select="concat(number(substring-before($height, 'cm')) * 1.0, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($height,'mm')">
				<xsl:value-of select="concat(number(substring-before($height, 'mm')) * 0.1, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($height,'in')">
				<xsl:value-of select="concat(number(substring-before($height, 'in')) * 2.54, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($height,'pt')">
				<xsl:value-of select="concat(number(substring-before($height, 'pt')) * 2.54 div 72.0, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($height,'twip')">
				<xsl:value-of select="concat(number(substring-before($height, 'twip')) * 2.54 div 1440, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($height,'pica')">
				<xsl:value-of select="concat(number(substring-before($height, 'pica')) * 2.54 div 6.0, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($height,'dpt')">
				<xsl:value-of select="concat(number(substring-before($height, 'dpt')) * 2.54 div 72.0, 'cm')" />
			  </xsl:when>
			  <xsl:when test="contains($height,'px')">
				<xsl:value-of select="concat(number(substring-before($height, 'px')) * 2.54 div 96.0, 'cm')" />
			  </xsl:when>
			  <xsl:otherwise>
				<xsl:value-of select="concat(number(substring-before($height, 'twip')) * 2.54 div 1440, 'cm')" />
			  </xsl:otherwise>
			</xsl:choose>
          </xsl:attribute>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="InsertShapeRelativeHeight">
    <xsl:param name="shape" select="." />

	<xsl:variable name="relativeHeight">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'mso-height-percent:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-height-percent:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'mso-height-percent:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>
    <xsl:variable name="currentSectPrForSize" select="key('sectPr', number(ancestor-or-self::node()/@oox:s))" />

    <!-- the attribute style:rel-height is not valid in this context -->
    <!--<xsl:attribute name="style:rel-height">
      <xsl:value-of select="$relativeHeight div 10" />
    </xsl:attribute>-->

	<xsl:variable name="relativeTo">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'mso-height-relative:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-height-relative:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="substring-after($shape/@style,'mso-height-relative:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>
    <!--added to calulate the value of top bottom margin and page width height in case of mirror margin-->
    <xsl:variable name="marTop">
      <xsl:choose>
        <xsl:when test="$currentSectPrForSize =''" >
          <xsl:value-of select="($currentSectPrForSize)/w:pgMar/@w:top" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="key('Part', 'word/document.xml')/w:document/w:body//w:sectPr/w:pgMar/@w:top" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="marBottom">
      <xsl:choose>
        <xsl:when test="$currentSectPrForSize =''" >
          <xsl:value-of select="($currentSectPrForSize)/w:pgMar/@w:bottom" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="key('Part', 'word/document.xml')/w:document/w:body//w:sectPr/w:pgMar/@w:bottom" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="pageWidth">
      <xsl:choose>
        <xsl:when test="$currentSectPrForSize =''" >
          <xsl:value-of select="($currentSectPrForSize)/w:pgSz/@w:w" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="key('Part', 'word/document.xml')/w:document/w:body//w:sectPr/w:pgSz/@w:w" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="pageHeight">
      <xsl:choose>
        <xsl:when test="$currentSectPrForSize =''" >
          <xsl:value-of select="($currentSectPrForSize)/w:pgSz/@w:h" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="key('Part', 'word/document.xml')/w:document/w:body//w:sectPr/w:pgSz/@w:h" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!--end here-->
    <xsl:variable name="VarHeight">
      <xsl:choose>
        <xsl:when test="contains($shape/@style,'mso-height-relative:margin')">
          <xsl:value-of select="($pageHeight  - ($marBottom + $marTop)) div 1440 " />
        </xsl:when>
        <xsl:when test="contains($shape/@style,'mso-height-relative:top-margin-area')">
          <xsl:value-of select="$marTop div 1440 " />
        </xsl:when>
        <xsl:when test="contains($shape/@style,'mso-height-relative:bottom-margin-area')">
          <xsl:value-of select="$marBottom div 1440 " />
        </xsl:when>
        <!--changed to calulate relative height in case of inner and outer mar-->
        <xsl:when test="contains($shape/@style,'mso-height-relative:inner-margin-area')">
          <xsl:value-of select="$marTop div 1440 " />
        </xsl:when>
        <xsl:when test="contains($shape/@style,'mso-height-relative:outer-margin-area')">
          <xsl:value-of select="$marTop div 1440 " />
        </xsl:when>
        <!--end here-->
        <xsl:otherwise>
          <xsl:value-of select="$pageHeight div 1440" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:attribute name="svg:height">
      <xsl:value-of select="concat((($VarHeight * $relativeHeight ) div 1000)* 2.54,'cm')" />
    </xsl:attribute>


    <xsl:if test="$relativeTo != ''">
      <xsl:message terminate="no">translation.oox2odf.frame.relativeSize</xsl:message>
    </xsl:if>
  </xsl:template>

  <xsl:template name="InsertShapeWidth">
    <xsl:param name="shape" select="." />

    <xsl:variable name="wrapStyle">
      <xsl:choose>
        <xsl:when test="$shape[name()='w:framePr']">
          <xsl:value-of select="$shape/@w:wrap" />
        </xsl:when>
        <xsl:otherwise>
		  <xsl:choose>
		    <xsl:when test="substring-before(substring-after($shape/@style,'mso-wrap-style:'), ';')">
			  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-wrap-style:'), ';')" />
		    </xsl:when>
		    <xsl:otherwise>
		  	  <xsl:value-of select="substring-after($shape/@style,'mso-wrap-style:')" />
		    </xsl:otherwise>
		  </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
	<xsl:variable name="relativeWidth">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'mso-width-percent:'), ';')">
	      <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-width-percent:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'mso-width-percent:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <!-- Sona: Change in width code-->
      <xsl:when test="$relativeWidth != '' and $relativeWidth != 0">
        <xsl:call-template name="InsertShapeRelativeWidth">
          <xsl:with-param name="shape" select="$shape" />
        </xsl:call-template>
      </xsl:when>
      <!-- 20080714/divo Removed check if wrapStyle is none. Otherwise images might get 0-width -->
      <!--xsl:when test="$wrapStyle = '' or $wrapStyle != 'none' "-->
      <xsl:otherwise>
        <xsl:variable name="width">
          <xsl:choose>
            <xsl:when test="$shape[name()='w:framePr']">
              <xsl:value-of select="$shape/@w:w" />
            </xsl:when>
            <xsl:otherwise>
			  <xsl:choose>
			    <xsl:when test="substring-before(substring-after($shape/@style,'width:'), ';')">
				  <xsl:value-of select="substring-before(substring-after($shape/@style,'width:'), ';')" />
			    </xsl:when>
			    <xsl:otherwise>
				  <xsl:value-of select="substring-after($shape/@style,'width:')" />
			    </xsl:otherwise>
			  </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="shapeTypeId" select="substring-after($shape/@type,'#')" />
        <xsl:variable name="pathId">
          <xsl:choose>
            <xsl:when test="@path">
              <xsl:value-of select="@path" />
            </xsl:when>
            <xsl:when test="$shapeTypeId">
              <xsl:value-of select="key('shapeTypeById', $shapeTypeId)[1]/@path" />
            </xsl:when>
          </xsl:choose>
        </xsl:variable> 
        
        <!-- Don't insert the width if the textbox is set to auto-width -->
        <xsl:if test="(contains($shape/v:textbox/@style, 'mso-fit-shape-to-text:t') and 
                not(contains($shape/@style,'mso-wrap-style:none'))) or
                    (not(contains($shape/v:textbox/@style, 'mso-fit-shape-to-text:t')) 
                and not(contains($shape/@style,'mso-wrap-style:none')) and 
                ($pathId='m,l,21600r21600,l21600,xe' or ($shape[name()='v:rect'] and $shape/v:textbox))) or
                (not(contains($shape/v:textbox/@style, 'mso-fit-shape-to-text:t')) and ($pathId!='m,l,21600r21600,l21600,xe' 
                and not($shape[name()='v:rect'] and $shape/v:textbox)))">
          <xsl:attribute name="svg:width">
            <xsl:choose>
              <xsl:when test="$width = 0 and $shape//@o:hr='t'">
                <xsl:value-of select="concat(key('sectPr', number(ancestor-or-self::node()/@oox:s))/@w:w - following::w:pgMar/@w:right[1] - following::w:pgMar/@w:left[1] * 2.54 div 1440.0, 'cm')" />
              </xsl:when>
              <xsl:otherwise>
				<xsl:choose>
				  <xsl:when test="contains($width,'cm')">
					<xsl:value-of select="concat(number(substring-before($width, 'cm')) * 1.0, 'cm')" />
				  </xsl:when>
				  <xsl:when test="contains($width,'mm')">
					<xsl:value-of select="concat(number(substring-before($width, 'mm')) * 0.1, 'cm')" />
				  </xsl:when>
				  <xsl:when test="contains($width,'in')">
					<xsl:value-of select="concat(number(substring-before($width, 'in')) * 2.54, 'cm')" />
				  </xsl:when>
				  <xsl:when test="contains($width,'pt')">
					<xsl:value-of select="concat(number(substring-before($width, 'pt')) * 2.54 div 72.0, 'cm')" />
				  </xsl:when>
				  <xsl:when test="contains($width,'twip')">
					<xsl:value-of select="concat(number(substring-before($width, 'twip')) * 2.54 div 1440, 'cm')" />
				  </xsl:when>
				  <xsl:when test="contains($width,'pica')">
					<xsl:value-of select="concat(number(substring-before($width, 'pica')) * 2.54 div 6.0, 'cm')" />
				  </xsl:when>
				  <xsl:when test="contains($width,'dpt')">
					<xsl:value-of select="concat(number(substring-before($width, 'dpt')) * 2.54 div 72.0, 'cm')" />
				  </xsl:when>
				  <xsl:when test="contains($width,'px')">
					<xsl:value-of select="concat(number(substring-before($width, 'px')) * 2.54 div 96.0, 'cm')" />
				  </xsl:when>
				  <xsl:otherwise>
					<xsl:value-of select="concat(number(substring-before($width, 'twip')) * 2.54 div 1440, 'cm')" />
				  </xsl:otherwise>
				</xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="InsertTextBoxRelSizeAttributes">
    <xsl:param name="shape" select="." />

    <xsl:if test="contains($shape/v:textbox/@style, 'mso-fit-shape-to-text:t')">
      <xsl:attribute name="style:rel-width">
        <xsl:text>scale</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="style:rel-height">
        <xsl:text>scale-min</xsl:text>
      </xsl:attribute>
    </xsl:if>

  </xsl:template>


  <xsl:template name="InsertTextBoxPaddingAttributes">
    <xsl:param name="shape" select="." />

    <xsl:variable name="textBoxInset" select="$shape/@inset" />

    <!-- default values: "0.1in, 0.05in, 0.1in, 0.05in" (see p4716 of ODF specification) -->
    <xsl:attribute name="fo:padding-left">
	  <xsl:value-of select="concat('ooc-RegexReplaceCmFromMeasuredUnit', '-oop-', $shape/@inset, '-oop-',  '([^,]*),([^,]*),([^,]*),([^,]*)', '-oop-', '$1', '-oop-', true(), '-oop-', '0.1in', '-ooe')" />
    </xsl:attribute>

    <xsl:attribute name="fo:padding-top">
	  <xsl:value-of select="concat('ooc-RegexReplaceCmFromMeasuredUnit', '-oop-', $shape/@inset, '-oop-',  '([^,]*),([^,]*),([^,]*),([^,]*)', '-oop-', '$2', '-oop-', true(), '-oop-', '0.05in', '-ooe')" />
    </xsl:attribute>

    <xsl:attribute name="fo:padding-right">
	  <xsl:value-of select="concat('ooc-RegexReplaceCmFromMeasuredUnit', '-oop-', $shape/@inset, '-oop-',  '([^,]*),([^,]*),([^,]*),([^,]*)', '-oop-', '$3', '-oop-', true(), '-oop-', '0.1in', '-ooe')" />
    </xsl:attribute>

    <xsl:attribute name="fo:padding-bottom">
	  <xsl:value-of select="concat('ooc-RegexReplaceCmFromMeasuredUnit', '-oop-', $shape/@inset, '-oop-',  '([^,]*),([^,]*),([^,]*),([^,]*)', '-oop-', '$4', '-oop-', true(), '-oop-', '0.05in', '-ooe')" />
    </xsl:attribute>
  </xsl:template>


  <xsl:template name="InsertShapeRelativeWidth">
    <xsl:param name="shape" select="." />

	<xsl:variable name="relativeWidth">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'mso-width-percent:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-width-percent:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'mso-width-percent:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>
    <xsl:variable name="currentSectPrForWidth" select="key('sectPr', number(ancestor-or-self::node()/@oox:s))" />

    <!-- the attribute style:rel-width is not valid in this context -->
    <!--<xsl:attribute name="style:rel-width">
      <xsl:value-of select="$relativeWidth div 10" />
    </xsl:attribute>-->

	<xsl:variable name="relativeTo">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'mso-width-relative:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'mso-width-relative:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'mso-width-relative:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>

    <!--added to calulate the value of left right margin and page width height in case of mirror margin-->
    <xsl:variable name="pageWidth">
      <xsl:choose>
        <xsl:when test="$currentSectPrForWidth =''" >
          <xsl:value-of select="($currentSectPrForWidth)/w:pgSz/@w:w" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="key('Part', 'word/document.xml')/w:document/w:body//w:sectPr/w:pgSz/@w:w" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="pageHeight">
      <xsl:choose>
        <xsl:when test="$currentSectPrForWidth =''" >
          <xsl:value-of select="($currentSectPrForWidth)/w:pgSz/@w:h" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="key('Part', 'word/document.xml')/w:document/w:body//w:sectPr/w:pgSz/@w:h" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="marLeft">
      <xsl:choose>
        <xsl:when test="$currentSectPrForWidth =''" >
          <xsl:value-of select="($currentSectPrForWidth)/w:pgMar/@w:left" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="key('Part', 'word/document.xml')/w:document/w:body//w:sectPr/w:pgMar/@w:left" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="marRight">
      <xsl:choose>
        <xsl:when test="$currentSectPrForWidth =''" >
          <xsl:value-of select="($currentSectPrForWidth)/w:pgMar/@w:right" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="key('Part', 'word/document.xml')/w:document/w:body//w:sectPr/w:pgMar/@w:right" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!--end here-->




    <xsl:variable name="VarWidth">
      <xsl:choose>
        <xsl:when test="contains($shape/@style,'mso-width-relative:margin')">
          <xsl:value-of select="($pageWidth  - ($marLeft + $marRight)) div 1440 " />
        </xsl:when>
        <xsl:when test="contains($shape/@style,'mso-width-relative:left-margin-area')">
          <xsl:value-of select="$marLeft div 1440 " />
        </xsl:when>
        <xsl:when test="contains($shape/@style,'mso-width-relative:right-margin-area')">
          <xsl:value-of select="$marRight div 1440 " />
        </xsl:when>
        <!--changed for relative width-->
        <xsl:when test="contains($shape/@style,'mso-width-relative:inner-margin-area')">
          <xsl:value-of select="$marRight div 1440 " />
        </xsl:when>
        <xsl:when test="contains($shape/@style,'mso-width-relative:outer-margin-area')">
          <xsl:value-of select="$marLeft div 1440 " />
        </xsl:when>
        <!--end here-->
        <xsl:otherwise>
          <xsl:value-of select="$pageWidth div 1440" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:attribute name="svg:width">
      <xsl:value-of select="concat((($VarWidth * $relativeWidth ) div 1000) * 2.54,'cm')" />
    </xsl:attribute>

    <xsl:if test="$relativeTo != ''">
      <xsl:message terminate="no">translation.oox2odf.frame.relativeSize</xsl:message>
    </xsl:if>
  </xsl:template>

  <!-- Sona Line Functions-->
  <xsl:template name="InsertLineCoordinateAttributes">
    <xsl:param name="shape" select="." />

	<xsl:variable name="leftMarginTemp">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'margin-left:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'margin-left:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'margin-left:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>
	<xsl:variable name="topMarginTemp">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'margin-top:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'margin-top:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'margin-top:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>
	<xsl:variable name="widthTemp">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'width:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'width:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'width:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>
	<xsl:variable name="heightTemp">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'height:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'height:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'height:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>
	<xsl:variable name="flip">
	  <xsl:choose>
	    <xsl:when test="substring-before(substring-after($shape/@style,'flip:'), ';')">
		  <xsl:value-of select="substring-before(substring-after($shape/@style,'flip:'), ';')" />
	    </xsl:when>
	    <xsl:otherwise>
		  <xsl:value-of select="substring-after($shape/@style,'flip:')" />
	    </xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>

    <xsl:variable name="leftMargin">
      <xsl:choose>
        <xsl:when test="$leftMarginTemp=0">
          <xsl:value-of select="'0cm'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="ConvertToCentimeters">
            <xsl:with-param name="length" select="$leftMarginTemp" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="topMargin">
      <xsl:choose>
        <xsl:when test="$topMarginTemp=0">
          <xsl:value-of select="'0cm'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="ConvertToCentimeters">
            <xsl:with-param name="length" select="$topMarginTemp" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="width">
      <xsl:choose>
        <xsl:when test="$widthTemp=0">
          <xsl:value-of select="'0cm'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="ConvertToCentimeters">
            <xsl:with-param name="length" select="$widthTemp" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="height">
      <xsl:choose>
        <xsl:when test="$heightTemp=0">
          <xsl:value-of select="'0cm'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="ConvertToCentimeters">
            <xsl:with-param name="length" select="$heightTemp" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- Sona: Line Rotation implementation-->
    <xsl:if test="contains($shape/@style,'rotation')">
      <xsl:variable name="xCenter">
        <xsl:call-template name="emu-measure">
          <xsl:with-param  name="length" select="concat((number(substring-before($leftMargin,'cm')) + (number(substring-before($width,'cm')) div 2)),'cm')" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="yCenter">
        <xsl:call-template name="emu-measure">
          <xsl:with-param  name="length" select="concat((number(substring-before($topMargin,'cm')) + (number(substring-before($height,'cm')) div 2)),'cm')" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="rot">
        <xsl:call-template name="emu-measure">
          <xsl:with-param name="length" select="concat(substring-before(substring-after($shape/@style,concat('rotation',':')),';'),'degrees')" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="angle">
        <xsl:if test="not(contains($shape/@style,'rotation'))">
          <xsl:value-of select="0" />
        </xsl:if>
        <xsl:if test="contains($shape/@style,'rotation')">
          <xsl:value-of select="(number($rot) div 60000) * ((22 div 7) div 180)" />
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="cxBy2">
        <!--
          <xsl:call-template name="emu-measure">
            <xsl:with-param  name="length" select="concat(((-1 * number(substring-before($width,'cm'))) div 2),'cm')" />
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="($flip != 'x') and ($flip != 'x y') ">-->
        <xsl:call-template name="emu-measure">
          <xsl:with-param  name="length" select="concat((number(substring-before($width,'cm')) div 2),'cm')" />
        </xsl:call-template>
        <!--</xsl:if>-->
      </xsl:variable>
      <xsl:variable name="cyBy2">
        <!--<xsl:if test="($flip = 'y') or ($flip = 'x y')">
          <xsl:call-template name="emu-measure">
            <xsl:with-param  name="length" select="concat(((-1 * number(substring-before($height,'cm'))) div 2),'cm')" />
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="($flip != 'y') and ($flip != 'x y')">-->
        <xsl:call-template name="emu-measure">
          <xsl:with-param  name="length" select="concat((number(substring-before($height,'cm')) div 2),'cm')" />
        </xsl:call-template>
        <!--</xsl:if>-->
      </xsl:variable>
      <xsl:attribute name="svg:x1">
        <xsl:if test="($flip = 'x') or ($flip = 'x y')">
          <xsl:value-of select="concat('ooc-svg-x2-oop-',$xCenter, '-oop-', $cxBy2, '-oop-', $cyBy2, '-oop-', $angle, '-ooe')" />
        </xsl:if>
        <xsl:if test="($flip != 'x') and ($flip != 'x y') ">
          <xsl:value-of select="concat('ooc-svg-x1-oop-',$xCenter, '-oop-', $cxBy2, '-oop-', $cyBy2, '-oop-', $angle, '-ooe')" />
        </xsl:if>
      </xsl:attribute>
      <xsl:attribute name="svg:y1">
        <xsl:if test="($flip = 'y') or ($flip = 'x y')">
          <xsl:value-of select="concat('ooc-svg-y2-oop-',$yCenter, '-oop-', $cxBy2, '-oop-', $cyBy2, '-oop-', $angle, '-ooe')" />
        </xsl:if>
        <xsl:if test="($flip != 'y') and ($flip != 'x y')">
          <xsl:value-of select="concat('ooc-svg-y1-oop-',$yCenter, '-oop-', $cxBy2, '-oop-', $cyBy2, '-oop-', $angle, '-ooe')" />
        </xsl:if>
      </xsl:attribute>
      <xsl:attribute name="svg:x2">
        <xsl:if test="($flip = 'x') or ($flip = 'x y')">
          <xsl:value-of select="concat('ooc-svg-x1-oop-',$xCenter, '-oop-', $cxBy2, '-oop-', $cyBy2, '-oop-', $angle, '-ooe')" />
        </xsl:if>
        <xsl:if test="($flip != 'x') and ($flip != 'x y') ">
          <xsl:value-of select="concat('ooc-svg-x2-oop-',$xCenter, '-oop-', $cxBy2, '-oop-', $cyBy2, '-oop-', $angle, '-ooe')" />
        </xsl:if>
      </xsl:attribute>
      <xsl:attribute name="svg:y2">
        <xsl:if test="($flip = 'y') or ($flip = 'x y')">
          <xsl:value-of select="concat('ooc-svg-y1-oop-',$yCenter, '-oop-', $cxBy2, '-oop-', $cyBy2, '-oop-', $angle, '-ooe')" />
        </xsl:if>
        <xsl:if test="($flip != 'y') and ($flip != 'x y')">
          <xsl:value-of select="concat('ooc-svg-y2-oop-',$yCenter, '-oop-', $cxBy2, '-oop-', $cyBy2, '-oop-', $angle, '-ooe')" />
        </xsl:if>
      </xsl:attribute>
      <!--<xsl:attribute name="svg:x1">
        <xsl:value-of select="concat('svg-x1:',7.2365*360000, ':', -2.2095*360000, ':', 1.3095*360000, ':', 1.04761)" />
      </xsl:attribute>
      <xsl:attribute name="svg:y1">
        <xsl:value-of select="concat('svg-y1:',4.7755*360000, ':', -2.2095*360000, ':', 1.3095*360000, ':', 1.04761)" />
      </xsl:attribute>
      <xsl:attribute name="svg:x2">
        <xsl:value-of select="concat('svg-x2:',7.2365*360000, ':', -2.2095*360000, ':', 1.3095*360000, ':', 1.04761)" />
      </xsl:attribute>
      <xsl:attribute name="svg:y2">
        <xsl:value-of select="concat('svg-y2:',4.7755*360000, ':', -2.2095*360000, ':', 1.3095*360000, ':', 1.04761)" />
      </xsl:attribute>-->
    </xsl:if>

    <xsl:if test="not(contains($shape/@style,'rotation'))">
      <xsl:choose>
        <xsl:when test="$flip='y'">
          <xsl:attribute name="svg:x1">
            <xsl:value-of select="$leftMargin" />
          </xsl:attribute>
          <xsl:attribute name="svg:y1">
            <xsl:value-of select="concat((substring-before($height,'cm')+substring-before($topMargin,'cm')),'cm')" />
          </xsl:attribute>
          <xsl:attribute name="svg:x2">
            <xsl:value-of select="concat((substring-before($width,'cm')+substring-before($leftMargin,'cm')),'cm')" />
          </xsl:attribute>
          <xsl:attribute name="svg:y2">
            <xsl:value-of select="$topMargin" />
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="$flip='x'">
          <xsl:attribute name="svg:x1">
            <xsl:value-of select="concat((substring-before($width,'cm')+substring-before($leftMargin,'cm')),'cm')" />
          </xsl:attribute>
          <xsl:attribute name="svg:y1">
            <xsl:value-of select="$topMargin" />
          </xsl:attribute>
          <xsl:attribute name="svg:x2">
            <xsl:value-of select="$leftMargin" />
          </xsl:attribute>
          <xsl:attribute name="svg:y2">
            <xsl:value-of  select="concat((substring-before($height,'cm')+substring-before($topMargin,'cm')),'cm')" />
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="$flip='x y'">
          <xsl:attribute name="svg:x1">
            <xsl:value-of select="concat((substring-before($width,'cm')+substring-before($leftMargin,'cm')),'cm')" />
          </xsl:attribute>
          <xsl:attribute name="svg:y1">
            <xsl:value-of select="concat((substring-before($height,'cm')+substring-before($topMargin,'cm')),'cm')" />
          </xsl:attribute>
          <xsl:attribute name="svg:x2">
            <xsl:value-of select="$leftMargin" />
          </xsl:attribute>
          <xsl:attribute name="svg:y2">
            <xsl:value-of select="$topMargin" />
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="svg:x1">
            <xsl:value-of select="$leftMargin" />
          </xsl:attribute>
          <xsl:attribute name="svg:y1">
            <xsl:value-of select="$topMargin" />
          </xsl:attribute>
          <xsl:attribute name="svg:x2">
            <xsl:value-of select="concat((substring-before($width,'cm')+substring-before($leftMargin,'cm')),'cm')" />
          </xsl:attribute>
          <xsl:attribute name="svg:y2">
            <xsl:value-of select="concat((substring-before($height,'cm')+substring-before($topMargin,'cm')),'cm')" />
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:if>
  </xsl:template>

  <xsl:template name="emu-measure">
    <!-- @Private -->
    <!-- @Description: Convert to emu (1cm = 360000 emu) -->
    <!-- @Context: None -->

    <!-- (string) The length including the unit -->
    <xsl:param name="length" />

    <xsl:choose>
      <xsl:when test="contains($length, 'cm')">
        <xsl:value-of select="round(number(substring-before($length, 'cm')) * 360000)" />
      </xsl:when>
      <xsl:when test="contains($length, 'mm')">
        <xsl:value-of select="round(number(substring-before($length, 'mm')) * 36000)" />
      </xsl:when>
      <xsl:when test="contains($length, 'in')">
        <xsl:value-of select="round(number(substring-before($length, 'in')) * 360000 * 2.54)" />
      </xsl:when>
      <xsl:when test="contains($length, 'pt')">
        <xsl:value-of select="round(number(substring-before($length, 'pt')) * 360000 * 2.54 div 72)" />
      </xsl:when>
      <xsl:when test="contains($length, 'px')">
        <xsl:value-of select="round(number(substring-before($length, 'px')) * 360000 div 37.87)" />
      </xsl:when>
      <!-- Sona: For converting angles in degrees-->
      <xsl:when test="contains($length, 'degrees')">
        <xsl:value-of select="round(number(substring-before($length, 'degrees')) * 60000)" />
      </xsl:when>
      <xsl:when test="not($length) or $length=''">0</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$length" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
