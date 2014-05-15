<?xml version="1.0" encoding="utf-8" ?>
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
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
  xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
  xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
  xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
  xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" 
  xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
  xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0"
  xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
  xmlns:xlink="http://www.w3.org/1999/xlink" 
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
  xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
  xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0"
  xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships"
  xmlns:pzip="urn:cleverage:xmlns:post-processings:zip"
  xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0"
  xmlns:exsl="http://exslt.org/common"
  exclude-result-prefixes="p a r dc xlink draw rels dr3d">
    <!-- Shape constants-->
	<!-- Arrow size -->
	<xsl:variable name="sm-sm">
		<xsl:value-of select ="'0.14'"/>
	</xsl:variable>
	<xsl:variable name="sm-med">
		<xsl:value-of select ="'0.245'"/>
	</xsl:variable>
	<xsl:variable name="sm-lg">
		<xsl:value-of select ="'0.2'"/>
	</xsl:variable>
	<xsl:variable name="med-sm">
		<xsl:value-of select ="'0.234'" />
	</xsl:variable>
	<xsl:variable name="med-med">
		<xsl:value-of select ="'0.351'"/>
	</xsl:variable>
	<xsl:variable name="med-lg">
		<xsl:value-of select ="'0.3'" />
	</xsl:variable>
	<xsl:variable name="lg-sm">
		<xsl:value-of select ="'0.31'" />
	</xsl:variable>
	<xsl:variable name="lg-med">
		<xsl:value-of select ="'0.35'" />
	</xsl:variable>
	<xsl:variable name="lg-lg">
		<xsl:value-of select ="'0.4'" />
	</xsl:variable>
  <!-- Template for Shapes in reverse conversion -->
  <xsl:template  name="shapes">
    <xsl:param name="GraphicId" />
    <xsl:param name="ParaId" />
    <xsl:param name="SlideRelationId" />
    <xsl:param name="TypeId" />
    <xsl:param name="var_pos" />
    <xsl:param name="grpBln" />
    <xsl:param name ="grpCordinates"/>
    <!-- parameter added by chhavi:for ODF1.1 conformance-->
    <xsl:param name ="layId"/>
    <!-- Extra parameter "slideId" added by lohith,requierd for template AddTextHyperlinks -->
    <xsl:param name="slideId" />
    <xsl:variable name="varHyperLinksForShapes">
      <!-- Added by lohith.ar - Start - Mouse click hyperlinks -->
      <office:event-listeners>
        <xsl:for-each select ="p:nvSpPr/p:cNvPr">
          <xsl:call-template name="tmpHyperLinkForShapesPic">
            <xsl:with-param name="SlideRelationId" select="$SlideRelationId"/>
                    </xsl:call-template>
        </xsl:for-each>
      </office:event-listeners>
      <!-- End - Mouse click hyperlinks-->
    </xsl:variable>
    <xsl:variable name="varHyperLinksForConnectors">
      <!-- Added by lohith.ar - Start - Mouse click hyperlinks -->
      <office:event-listeners>
        <xsl:for-each select ="p:nvCxnSpPr/p:cNvPr">
          <xsl:call-template name="tmpHyperLinkForShapesPic">
            <xsl:with-param name="SlideRelationId" select="$SlideRelationId"/>
                    </xsl:call-template>
                         </xsl:for-each>
      </office:event-listeners>
      <!-- End - Mouse click hyperlinks-->
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="p:spPr/a:prstGeom/@prst or p:spPr/a:custGeom">
        <xsl:variable name="enhancePath">
          <xsl:for-each select="p:spPr/a:custGeom/a:pathLst/a:path">
            <xsl:if test="@stroke='0'">
              <xsl:value-of select="'S ' "/>
            </xsl:if>
            <xsl:if test="@fill='none'">
              <xsl:value-of select="'F ' "/>
            </xsl:if>
            <xsl:for-each select="node()">
              <xsl:choose>
                <xsl:when test="name()='a:moveTo'">
                  <xsl:value-of select="concat('M ',a:pt/@x,' ',a:pt/@y,' ') "/>
                </xsl:when>
                <xsl:when test="name()='a:arcTo'">
                  <xsl:value-of select="concat('A ',@wR,' ',@hR,' ',@stAng,' ',@swAng,' ') "/>
                </xsl:when>
                <xsl:when test="name()='a:lnTo'">
                  <xsl:value-of select="concat('L ',a:pt/@x,' ',a:pt/@y,' ') "/>
                </xsl:when>
                <xsl:when test="name()='a:close'">
                  <xsl:value-of select="'Z N ' "/>
                </xsl:when>
                <xsl:when test="name()='a:cubicBezTo'">
                  <xsl:value-of select="concat('C ',a:pt[1]/@x,' ',a:pt[1]/@y,' ',a:pt[2]/@x,' ',a:pt[2]/@y,' ',a:pt[3]/@x,' ',a:pt[3]/@y,' ')"/>
                </xsl:when>
              </xsl:choose>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
      <!-- Basic shapes start-->

      <!--Custom shape - Rectangle -->
		  <xsl:when test ="p:spPr/a:prstGeom/@prst='rect'">
      <xsl:choose>
        <xsl:when test="p:style">
          <draw:custom-shape draw:layer="layout" >
            <xsl:call-template name ="CreateShape">
                    <!--parameter added by yeswanth:for ODF1.1 conformance-->
                    <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
              <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                    <!-- parameter added by chhavi:for ODF1.1 conformance-->
                    <xsl:with-param name ="layId" select ="$layId"/>
              <xsl:with-param name="sldId" select="$slideId" />
              <xsl:with-param name="grID" select ="$GraphicId"/>
              <xsl:with-param name ="prID" select="$ParaId" />
              <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
              <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
              <xsl:with-param name="TypeId" select ="$TypeId" />
              <xsl:with-param name="grpBln" select ="$grpBln" />
              <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
              <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            </xsl:call-template>
            <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
                       draw:type="rectangle" 
                       draw:enhanced-path="M 0 0 L 21600 0 21600 21600 0 21600 0 0 Z N">
              <xsl:call-template name="tmpFlip"/>
            </draw:enhanced-geometry>
           </draw:custom-shape>
        </xsl:when>
        <xsl:otherwise>
          <draw:frame draw:layer="layout">

            <xsl:call-template name ="CreateShape">
                    <!--parameter added by yeswanth:for ODF1.1 conformance-->
                    <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
              <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                    <!-- parameter added by chhavi:for ODF1.1 conformance-->
                    <xsl:with-param name ="layId" select="$layId"/>
              <xsl:with-param name="flagTextBox" select="'true'" />
              <xsl:with-param name="sldId" select="$slideId" />
              <xsl:with-param name="grID" select ="$GraphicId"/>
              <xsl:with-param name ="prID" select="$ParaId" />
              <xsl:with-param name="TypeId" select ="$TypeId" />
              <xsl:with-param name="grpBln" select ="$grpBln" />
              <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
              <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
              <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
              <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            </xsl:call-template>
          </draw:frame>
        </xsl:otherwise>
      </xsl:choose>
      
      </xsl:when>		
      <!-- Oval(Custom shape) -->
      <xsl:when test ="((p:nvSpPr/p:cNvPr/@name[contains(., 'Oval')]) and (p:spPr/a:prstGeom/@prst='ellipse')) or 
                          $enhancePath='M f28 f43 A f40 f41 f0 f1 A f40 f41 f2 f1 A f40 f41 f7 f1 A f40 f41 f1 f1 Z N ' or
                          $enhancePath='M f52 f53 A f9 f9 f33 f36 Z N ' or
                          $enhancePath='M l vc A wd2 hd2 cd2 cd4 A wd2 hd2 3cd4 cd4 A wd2 hd2 0 cd4 A wd2 hd2 cd4 cd4 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
		     	<xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
          <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
											draw:text-areas="3200 3200 18400 18400" 
											draw:type="ellipse"
											draw:glue-points="10800 0 3160 3160 0 10800 3160 18440 10800 21600 18440 18440 21600 10800 18440 3160">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
	  </xsl:when>

      <!--Added by Mathi for bug Fix on 17th Sep 2007-->
      <xsl:when test ="(not(p:nvSpPr/p:cNvPr/@name[contains(., 'Ellipse ')]) or (p:nvSpPr/p:cNvPr/@name[contains(., 'Ellipse ')])) and (p:spPr/a:prstGeom/@prst='ellipse')">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
											draw:text-areas="3200 3200 18400 18400" 
											draw:type="ellipse"
											draw:glue-points="10800 0 3160 3160 0 10800 3160 18440 10800 21600 18440 18440 21600 10800 18440 3160">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!--End of Code-->
      
      <!--Right Arrow (Added by A.Mathi as on 2/07/2007) -->
      <xsl:when test = "(p:spPr/a:prstGeom/@prst='rightArrow') or
                $enhancePath='M f7 f18 L f19 f18 L f19 f7 L f8 f9 L f19 f8 L f19 f20 L f7 f20 Z N ' or
                          $enhancePath='M f4 f11 L f12 f11 L f12 f4 L f5 f6 L f12 f5 L f12 f13 L f4 f13 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
			<xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
					  draw:text-areas="0 ?f0 ?f5 ?f2" 
					  draw:type="right-arrow" draw:modifiers="16200 5400" 
					  draw:enhanced-path="M 0 ?f0 L ?f1 ?f0 ?f1 0 21600 10800 ?f1 21600 ?f1 ?f2 0 ?f2 Z N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="$1 "/>
            <draw:equation draw:name="f1" draw:formula="$0 "/>
            <draw:equation draw:name="f2" draw:formula="21600-$1 "/>
            <draw:equation draw:name="f3" draw:formula="21600-?f1 "/>
            <draw:equation draw:name="f4" draw:formula="?f3 *?f0 /10800"/>
            <draw:equation draw:name="f5" draw:formula="?f1 +?f4 "/>
            <draw:equation draw:name="f6" draw:formula="?f1 *?f0 /10800"/>
            <draw:equation draw:name="f7" draw:formula="?f1 -?f6 "/>
            <draw:handle draw:handle-position="$0 $1" 
						  draw:handle-range-x-minimum="0" 
						  draw:handle-range-x-maximum="21600" 
						  draw:handle-range-y-minimum="0" 
						  draw:handle-range-y-maximum="10800"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!--Up Arrow (Added by A.Mathi as on 2/07/2007) -->
      <xsl:when test = "(p:spPr/a:prstGeom/@prst='upArrow') or
                $enhancePath='M f18 f8 L f18 f19 L f7 f19 L f9 f7 L f8 f19 L f20 f19 L f20 f8 Z N ' or
                          $enhancePath='M f11 f5 L f11 f12 L f4 f12 L f6 f4 L f5 f12 L f13 f12 L f13 f5 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
			<xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name ="grID" select="$GraphicId" />
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name ="SlideRelationId" select="$SlideRelationId" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
					  draw:text-areas="?f0 ?f7 ?f2 21600" 
					  draw:type="up-arrow" draw:modifiers="5400 5400" 
					  draw:enhanced-path="M ?f0 21600 L ?f0 ?f1 0 ?f1 10800 0 21600 ?f1 ?f2 ?f1 ?f2 21600 Z N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="$1 "/>
            <draw:equation draw:name="f1" draw:formula="$0 "/>
            <draw:equation draw:name="f2" draw:formula="21600-$1 "/>
            <draw:equation draw:name="f3" draw:formula="21600-?f1 "/>
            <draw:equation draw:name="f4" draw:formula="?f3 *?f0 /10800"/>
            <draw:equation draw:name="f5" draw:formula="?f1 +?f4 "/>
            <draw:equation draw:name="f6" draw:formula="?f1 *?f0 /10800"/>
            <draw:equation draw:name="f7" draw:formula="?f1 -?f6 "/>
            <draw:handle draw:handle-position="$1 $0" 
						  draw:handle-range-x-minimum="0" 
						  draw:handle-range-x-maximum="10800" 
						  draw:handle-range-y-minimum="0" 
						  draw:handle-range-y-maximum="21600"/>
          </draw:enhanced-geometry>
              <!--<xsl:copy-of select="$varHyperLinksForShapes"/>-->
        </draw:custom-shape>
      </xsl:when>
      <!--Left Arrow (Added by A.Mathi as on 2/07/2007) -->
      <xsl:when test = "(p:spPr/a:prstGeom/@prst='leftArrow') or
                $enhancePath='M f8 f18 L f19 f18 L f19 f7 L f7 f9 L f19 f8 L f19 f20 L f8 f20 Z N ' or
                          $enhancePath='M f5 f11 L f12 f11 L f12 f4 L f4 f6 L f12 f5 L f12 f13 L f5 f13 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
			<xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name ="grID" select="$GraphicId" />
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name ="SlideRelationId" select="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
					  draw:text-areas="?f7 ?f0 21600 ?f2" 
					  draw:type="left-arrow" 
					  draw:modifiers="5400 5400" 
					  draw:enhanced-path="M 21600 ?f0 L ?f1 ?f0 ?f1 0 0 10800 ?f1 21600 ?f1 ?f2 21600 ?f2 Z N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="$1 "/>
            <draw:equation draw:name="f1" draw:formula="$0 "/>
            <draw:equation draw:name="f2" draw:formula="21600-$1 "/>
            <draw:equation draw:name="f3" draw:formula="21600-?f1 "/>
            <draw:equation draw:name="f4" draw:formula="?f3 *?f0 /10800"/>
            <draw:equation draw:name="f5" draw:formula="?f1 +?f4 "/>
            <draw:equation draw:name="f6" draw:formula="?f1 *?f0 /10800"/>
            <draw:equation draw:name="f7" draw:formula="?f1 -?f6 "/>
            <draw:handle draw:handle-position="$0 $1" 
						  draw:handle-range-x-minimum="0" 
						  draw:handle-range-x-maximum="21600" 
						  draw:handle-range-y-minimum="0" 
						  draw:handle-range-y-maximum="10800"/>
          </draw:enhanced-geometry>
              <!--<xsl:copy-of select="$varHyperLinksForShapes"/>-->
        </draw:custom-shape>
      </xsl:when>
      <!--Down Arrow (Added by A.Mathi as on 2/07/2007) -->
      <xsl:when test = "(p:spPr/a:prstGeom/@prst='downArrow') or
                    $enhancePath='M f18 f7 L f18 f19 L f7 f19 L f9 f8 L f8 f19 L f20 f19 L f20 f7 Z N ' or
                          $enhancePath='M f11 f4 L f11 f12 L f4 f12 L f6 f5 L f5 f12 L f13 f12 L f13 f4 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
			<xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name ="grID" select ="$GraphicId" />
            <xsl:with-param name ="prID" select ="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name ="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
					  draw:text-areas="?f0 0 ?f2 ?f5" 
					  draw:type="down-arrow" 
					  draw:modifiers="16200 5400" 
					  draw:enhanced-path="M ?f0 0 L ?f0 ?f1 0 ?f1 10800 21600 21600 ?f1 ?f2 ?f1 ?f2 0 Z N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="$1 "/>
            <draw:equation draw:name="f1" draw:formula="$0 "/>
            <draw:equation draw:name="f2" draw:formula="21600-$1 "/>
            <draw:equation draw:name="f3" draw:formula="21600-?f1 "/>
            <draw:equation draw:name="f4" draw:formula="?f3 *?f0 /10800"/>
            <draw:equation draw:name="f5" draw:formula="?f1 +?f4 "/>
            <draw:equation draw:name="f6" draw:formula="?f1 *?f0 /10800"/>
            <draw:equation draw:name="f7" draw:formula="?f1 -?f6 "/>
            <draw:handle draw:handle-position="$1 $0" 
						  draw:handle-range-x-minimum="0" 
						  draw:handle-range-x-maximum="10800" 
						  draw:handle-range-y-minimum="0" 
						  draw:handle-range-y-maximum="21600"/>
          </draw:enhanced-geometry>
              <!--<xsl:copy-of select="$varHyperLinksForShapes"/>-->
        </draw:custom-shape>
      </xsl:when>
      <!--LeftRight Arrow (Added by A.Mathi as on 3/07/2007) -->
      <xsl:when test = "(p:spPr/a:prstGeom/@prst='leftRightArrow') or
                $enhancePath='M f29 f47 L f53 f29 L f53 f51 L f55 f51 L f55 f29 L f34 f47 L f55 f35 L f55 f52 L f53 f52 L f53 f35 Z N ' or
                          $enhancePath='M f4 f6 L f11 f4 L f11 f12 L f13 f12 L f13 f4 L f5 f6 L f13 f5 L f13 f14 L f11 f14 L f11 f5 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
			  <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name ="grID" select ="$GraphicId" />
            <xsl:with-param name ="prID" select ="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name ="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
					  draw:text-areas="?f5 ?f1 ?f6 ?f3" 
					  draw:type="left-right-arrow" 
					  draw:modifiers="4300 5400" 
					  draw:enhanced-path="M 0 10800 L ?f0 0 ?f0 ?f1 ?f2 ?f1 ?f2 0 21600 10800 ?f2 21600 ?f2 ?f3 ?f0 ?f3 ?f0 21600 Z N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="$0 "/>
            <draw:equation draw:name="f1" draw:formula="$1 "/>
            <draw:equation draw:name="f2" draw:formula="21600-$0 "/>
            <draw:equation draw:name="f3" draw:formula="21600-$1 "/>
            <draw:equation draw:name="f4" draw:formula="10800-$1 "/>
            <draw:equation draw:name="f5" draw:formula="$0 *?f4 /10800"/>
            <draw:equation draw:name="f6" draw:formula="21600-?f5 "/>
            <draw:equation draw:name="f7" draw:formula="10800-$0 "/>
            <draw:equation draw:name="f8" draw:formula="$1 *?f7 /10800"/>
            <draw:equation draw:name="f9" draw:formula="21600-?f8 "/>
            <draw:handle draw:handle-position="$0 $1" 
						  draw:handle-range-x-minimum="0" 
						  draw:handle-range-x-maximum="10800" 
						  draw:handle-range-y-minimum="0" 
						  draw:handle-range-y-maximum="10800"/>
          </draw:enhanced-geometry>
              <!--<xsl:copy-of select="$varHyperLinksForShapes"/>-->
        </draw:custom-shape>
      </xsl:when>
      <!-- UpDown Arrow (Added by A.Mathi as on 4/07/2007) -->
      <xsl:when test = "p:spPr/a:prstGeom/@prst='upDownArrow' 
                or $enhancePath='M f4 f12 L f6 f4 L f5 f12 L f13 f12 L f13 f14 L f5 f14 L f6 f5 L f4 f14 L f11 f14 L f11 f12 Z N '" >
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
			<xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name ="grID" select ="$GraphicId" />
            <xsl:with-param name ="prID" select ="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name ="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
					  draw:text-areas="?f0 ?f8 ?f2 ?f9" 
					  draw:type="up-down-arrow" 
					  draw:modifiers="5400 4300" 
					  draw:enhanced-path="M 0 ?f1 L 10800 0 21600 ?f1 ?f2 ?f1 ?f2 ?f3 21600 ?f3 10800 21600 0 ?f3 ?f0 ?f3 ?f0 ?f1 Z N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="$0 "/>
            <draw:equation draw:name="f1" draw:formula="$1 "/>
            <draw:equation draw:name="f2" draw:formula="21600-$0 "/>
            <draw:equation draw:name="f3" draw:formula="21600-$1 "/>
            <draw:equation draw:name="f4" draw:formula="10800-$1 "/>
            <draw:equation draw:name="f5" draw:formula="$0 *?f4 /10800"/>
            <draw:equation draw:name="f6" draw:formula="21600-?f5 "/>
            <draw:equation draw:name="f7" draw:formula="10800-$0 "/>
            <draw:equation draw:name="f8" draw:formula="$1 *?f7 /10800"/>
            <draw:equation draw:name="f9" draw:formula="21600-?f8 "/>
            <draw:handle draw:handle-position="$0 $1" 
						  draw:handle-range-x-minimum="0" 
						  draw:handle-range-x-maximum="10800" 
						  draw:handle-range-y-minimum="0" 
						  draw:handle-range-y-maximum="10800"/>
          </draw:enhanced-geometry>
              <!--<xsl:copy-of select="$varHyperLinksForShapes"/>-->
        </draw:custom-shape>
      </xsl:when>
      <!-- Isosceles Triangle -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='triangle') or 
                       $enhancePath='M f32 f39 L f50 f32 L f40 f39 Z N ' or
                       $enhancePath='M f15 f6 L f7 f7 L f6 f7 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
						draw:glue-points="10800 0 ?f1 10800 0 21600 10800 21600 21600 21600 ?f7 10800" 
						draw:text-areas="?f1 10800 ?f2 18000 ?f3 7200 ?f4 21600" 
						draw:type="isosceles-triangle" draw:modifiers="10800" 
						draw:enhanced-path="M ?f0 0 L 21600 21600 0 21600 Z N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="$0 "/>
            <draw:equation draw:name="f1" draw:formula="$0 /2"/>
            <draw:equation draw:name="f2" draw:formula="?f1 +10800"/>
            <draw:equation draw:name="f3" draw:formula="$0 *2/3"/>
            <draw:equation draw:name="f4" draw:formula="?f3 +7200"/>
            <draw:equation draw:name="f5" draw:formula="21600-?f0 "/>
            <draw:equation draw:name="f6" draw:formula="?f5 /2"/>
            <draw:equation draw:name="f7" draw:formula="21600-?f6 "/>
            <draw:handle draw:handle-position="$0 top" 
									 draw:handle-range-x-minimum="0" 
									 draw:handle-range-x-maximum="21600"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- Right Triangle -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='rtTriangle') or
                $enhancePath='M f26 f32 L f26 f26 L f33 f32 Z N ' or 
                          $enhancePath='M f5 f5 L f6 f6 L f5 f6 L f5 f5 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
											draw:glue-points="10800 0 5400 10800 0 21600 10800 21600 21600 21600 16200 10800" 
											draw:text-areas="1900 12700 12700 19700" 
											draw:type="right-triangle" 
											draw:enhanced-path="M 0 0 L 21600 21600 0 21600 0 0 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- Parallelogram -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='parallelogram') or
                $enhancePath='M f33 f40 L f60 f33 L f41 f33 L f65 f40 Z N ' or
                          $enhancePath='M f16 f6 L f7 f6 L f17 f7 L f6 f7 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
						draw:glue-points="?f6 0 10800 ?f8 ?f11 10800 ?f9 21600 10800 ?f10 ?f5 10800" 
						draw:text-areas="?f3 ?f3 ?f4 ?f4" draw:type="parallelogram" 
						draw:modifiers="5400" 
            draw:enhanced-path="M ?f0 0 L 21600 0 ?f1 21600 0 21600 Z N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="$0 "/>
            <draw:equation draw:name="f1" draw:formula="21600-$0 "/>
            <draw:equation draw:name="f2" draw:formula="$0 *10/24"/>
            <draw:equation draw:name="f3" draw:formula="?f2 +1750"/>
            <draw:equation draw:name="f4" draw:formula="21600-?f3 "/>
            <draw:equation draw:name="f5" draw:formula="?f0 /2"/>
            <draw:equation draw:name="f6" draw:formula="10800+?f5 "/>
            <draw:equation draw:name="f7" draw:formula="?f0 -10800"/>
            <draw:equation draw:name="f8" draw:formula="if(?f7 ,?f13 ,0)"/>
            <draw:equation draw:name="f9" draw:formula="10800-?f5 "/>
            <draw:equation draw:name="f10" draw:formula="if(?f7 ,?f12 ,21600)"/>
            <draw:equation draw:name="f11" draw:formula="21600-?f5 "/>
            <draw:equation draw:name="f12" draw:formula="21600*10800/?f0 "/>
            <draw:equation draw:name="f13" draw:formula="21600-?f12 "/>
            <draw:handle draw:handle-position="$0 top" 
									 draw:handle-range-x-minimum="0" 
									 draw:handle-range-x-maximum="21600"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- Trapezoid (Added by A.Mathi as on 24/07/2007) -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='trapezoid') or
                $enhancePath='M f26 f31 L f53 f26 L f56 f26 L f32 f31 Z N ' or 
                          $enhancePath='M f6 f6 L f7 f6 L f16 f7 L f17 f7 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
			<xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 914400 1216152" 
          draw:extrusion-allowed="true" 
          draw:text-areas="152400 202692 762000 1216152" 
          draw:glue-points="457200 0 114300 608076 457200 1216152 800100 608076" 
          draw:type="mso-spt100" 
          draw:enhanced-path="M 0 1216152 L 228600 0 L 685800 0 L 914400 1216152 Z N">
            <xsl:if test="$enhancePath='M f6 f6 L f7 f6 L f16 f7 L f17 f7 Z N '">
              <xsl:attribute name ="draw:mirror-vertical">
                <xsl:value-of select="'true'"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- Diamond   -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='diamond') or
                $enhancePath='M f14 f33 L f34 f14 L f17 f33 L f34 f18 Z N ' or
                          $enhancePath='M f7 f5 L f6 f7 L f7 f6 L f5 f7 L f7 f5 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
											draw:glue-points="10800 0 0 10800 10800 21600 21600 10800" 
											draw:text-areas="5400 5400 16200 16200" 
											draw:type="diamond" 
											draw:enhanced-path="M 10800 0 L 21600 10800 10800 21600 0 10800 10800 0 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- Regular Pentagon -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='pentagon') or
                $enhancePath='M f88 f89 L f58 f35 L f90 f89 L f86 f87 L f85 f87 Z N ' or
                          $enhancePath='M f7 f5 L f5 f8 L f9 f6 L f10 f6 L f6 f8 L f7 f5 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
											draw:glue-points="10800 0 0 8260 4230 21600 10800 21600 17370 21600 21600 8260" 
											draw:text-areas="4230 5080 17370 21600" 
											draw:type="pentagon" 
											draw:enhanced-path="M 10800 0 L 0 8260 4230 21600 17370 21600 21600 8260 10800 0 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- Hexagon -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='hexagon') or
                $enhancePath='M f32 f52 L f56 f72 L f59 f72 L f38 f52 L f59 f73 L f56 f73 Z N ' or
                          $enhancePath='M f16 f6 L f17 f6 L f7 f8 L f17 f7 L f16 f7 L f6 f8 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
											draw:glue-points="10800 0 0 10800 10800 21600 21600 10800" 
											draw:text-areas="?f3 ?f3 ?f4 ?f4" draw:type="hexagon" 
											draw:modifiers="5400" 
											draw:enhanced-path="M ?f0 0 L ?f1 0 21600 10800 ?f1 21600 ?f0 21600 0 10800 Z N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="$0 "/>
            <draw:equation draw:name="f1" draw:formula="21600-$0 "/>
            <draw:equation draw:name="f2" draw:formula="$0 *100/234"/>
            <draw:equation draw:name="f3" draw:formula="?f2 +1700"/>
            <draw:equation draw:name="f4" draw:formula="21600-?f3 "/>
            <draw:handle draw:handle-position="$0 top" 
                   draw:handle-range-x-minimum="0" 
                   draw:handle-range-x-maximum="10800"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- Octagon -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='octagon') or
                $enhancePath='M f39 f37 L f45 f37 L f40 f39 L f40 f46 L f45 f41 L f39 f41 L f37 f46 L f37 f39 Z N ' or
                $enhancePath='M f32 f47 L f47 f32 L f51 f32 L f39 f47 L f39 f52 L f51 f40 L f47 f40 L f32 f52 Z N ' or
                          $enhancePath='M f31 f30 L f39 f30 L f32 f31 L f32 f40 L f39 f33 L f31 f33 L f30 f40 L f30 f31 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600"
						draw:glue-points="10800 0 0 10800 10800 21600 21600 10800"
						draw:path-stretchpoint-x="10800" draw:path-stretchpoint-y="10800"
						draw:text-areas="?f5 ?f6 ?f7 ?f8" draw:type="octagon" draw:modifiers="5000"
						draw:enhanced-path="M ?f0 0 L ?f2 0 21600 ?f1 21600 ?f3 ?f2 21600 ?f0 21600 0 ?f3 0 ?f1 Z N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="left+$0 "/>
            <draw:equation draw:name="f1" draw:formula="top+$0 "/>
            <draw:equation draw:name="f2" draw:formula="right-$0 "/>
            <draw:equation draw:name="f3" draw:formula="bottom-$0 "/>
            <draw:equation draw:name="f4" draw:formula="$0 /2"/>
            <draw:equation draw:name="f5" draw:formula="left+?f4 "/>
            <draw:equation draw:name="f6" draw:formula="top+?f4 "/>
            <draw:equation draw:name="f7" draw:formula="right-?f4 "/>
            <draw:equation draw:name="f8" draw:formula="bottom-?f4 "/>
            <draw:handle draw:handle-position="$0 top"
									 draw:handle-range-x-minimum="0"
									 draw:handle-range-x-maximum="10800"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
          <!--Sp2: Circular Arrow-->

          <xsl:when test="$enhancePath='M f9 f10 A f11 f12 f13 f14 L f15 f16 L f17 f18 L f19 f20 L f21 f20 A f22 f23 f24 f8 Z N ' or
                     $enhancePath='M f247 f248 A f50 f50 f211 f229 L f249 f250 A f35 f35 f213 f232 L f119 f118 L f184 f183 L f121 f120 Z N '">
            <draw:custom-shape  draw:layer="layout" >
                <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
             <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:text-areas="0 0 21600 21600"
                draw:type="circular-arrow" draw:modifiers="180 0 5500" 
                                     draw:enhanced-path="B ?f3 ?f3 ?f20 ?f20 ?f19 ?f18 ?f17 ?f16 W 0 0 21600 21600 ?f9 ?f8 ?f11 ?f10 L ?f24 ?f23 ?f36 ?f35 ?f29 ?f28 Z N">
               <xsl:if test="p:spPr/a:xfrm/@flipH='1'">
                 <xsl:attribute name ="draw:mirror-horizontal">
                   <xsl:value-of select="'true'"/>
                 </xsl:attribute>
               </xsl:if>
               <xsl:if test="p:spPr/a:xfrm/@flipV='1'">
                 <xsl:attribute name ="draw:mirror-vertical">
                   <xsl:value-of select="'true'"/>
                 </xsl:attribute>
               </xsl:if>
                <draw:equation draw:name="f0" draw:formula="$0" />
                <draw:equation draw:name="f1" draw:formula="$1" />
                <draw:equation draw:name="f2" draw:formula="$2" />
                <draw:equation draw:name="f3" draw:formula="10800+$2" />
                <draw:equation draw:name="f4" draw:formula="10800*sin($0 *(pi/180))" />
                <draw:equation draw:name="f5" draw:formula="10800*cos($0 *(pi/180))" />
                <draw:equation draw:name="f6" draw:formula="10800*sin($1 *(pi/180))" />
                <draw:equation draw:name="f7" draw:formula="10800*cos($1 *(pi/180))" />
                <draw:equation draw:name="f8" draw:formula="?f4 +10800" />
                <draw:equation draw:name="f9" draw:formula="?f5 +10800" />
                <draw:equation draw:name="f10" draw:formula="?f6 +10800" />
                <draw:equation draw:name="f11" draw:formula="?f7 +10800" />
                <draw:equation draw:name="f12" draw:formula="?f3 *sin($0 *(pi/180))" />
                <draw:equation draw:name="f13" draw:formula="?f3 *cos($0 *(pi/180))" />
                <draw:equation draw:name="f14" draw:formula="?f3 *sin($1 *(pi/180))" />
                <draw:equation draw:name="f15" draw:formula="?f3 *cos($1 *(pi/180))" />
                <draw:equation draw:name="f16" draw:formula="?f12 +10800" />
                <draw:equation draw:name="f17" draw:formula="?f13 +10800" />
                <draw:equation draw:name="f18" draw:formula="?f14 +10800" />
                <draw:equation draw:name="f19" draw:formula="?f15 +10800" />
                <draw:equation draw:name="f20" draw:formula="21600-?f3" />
                <draw:equation draw:name="f21" draw:formula="13500*sin($1 *(pi/180))" />
                <draw:equation draw:name="f22" draw:formula="13500*cos($1 *(pi/180))" />
                <draw:equation draw:name="f23" draw:formula="?f21 +10800" />
                <draw:equation draw:name="f24" draw:formula="?f22 +10800" />
                <draw:equation draw:name="f25" draw:formula="$2 -2700" />
                <draw:equation draw:name="f26" draw:formula="?f25 *sin($1 *(pi/180))" />
                <draw:equation draw:name="f27" draw:formula="?f25 *cos($1 *(pi/180))" />
                <draw:equation draw:name="f28" draw:formula="?f26 +10800" />
                <draw:equation draw:name="f29" draw:formula="?f27 +10800" />
                <draw:equation draw:name="f30" draw:formula="($1+45)*pi/180" />
                <draw:equation draw:name="f31" draw:formula="sqrt(((?f29-?f24)*(?f29-?f24))+((?f28-?f23)*(?f28-?f23)))" />
                <draw:equation draw:name="f32" draw:formula="sqrt(2)/2*?f31" />
                <draw:equation draw:name="f33" draw:formula="?f32*sin(?f30)" />
                <draw:equation draw:name="f34" draw:formula="?f32*cos(?f30)" />
                <draw:equation draw:name="f35" draw:formula="?f28+?f33" />
                <draw:equation draw:name="f36" draw:formula="?f29+?f34" />
                <draw:handle draw:handle-position="10800 $0" draw:handle-polar="10800 10800" draw:handle-radius-range-minimum="10800" draw:handle-radius-range-maximum="10800" />
                <draw:handle draw:handle-position="$2 $1" draw:handle-polar="10800 10800" draw:handle-radius-range-minimum="0" draw:handle-radius-range-maximum="10800" />
              </draw:enhanced-geometry>
            </draw:custom-shape>

          </xsl:when>
      <!-- Circular Arrow or CurvedLeftArrow or curvedRightArrow or  CurvedDownArrow or CurvedUpArrow -->
      <xsl:when test ="p:spPr/a:prstGeom/@prst='circularArrow' or p:spPr/a:prstGeom/@prst='curvedRightArrow' or p:spPr/a:prstGeom/@prst='curvedLeftArrow' or p:spPr/a:prstGeom/@prst='curvedDownArrow' or p:spPr/a:prstGeom/@prst='curvedUpArrow' or
                $enhancePath='M f247 f248 A f50 f50 f211 f229 L f249 f250 A f35 f35 f213 f232 L f119 f118 L f184 f183 L f121 f120 Z N '">
        <!-- warn if CurvedLeftArrow or curvedRightArrow or  CurvedDownArrow or CurvedUpArrow   -->
        <xsl:message terminate="no">translation.oox2odf.shapesTypeCurvedLeftRightUpDownArrow</xsl:message>
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <xsl:if test="p:spPr/a:prstGeom/@prst='circularArrow' or p:spPr/a:prstGeom/@prst='curvedDownArrow' or p:spPr/a:prstGeom/@prst='curvedUpArrow'">
            <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:text-areas="0 0 21600 21600" 
                                  draw:modifiers="180 0 5500" draw:enhanced-path="B ?f3 ?f3 ?f20 ?f20 ?f19 ?f18 ?f17 ?f16 W 0 0 21600 21600 ?f9 ?f8 ?f11 ?f10 L ?f24 ?f23 ?f36 ?f35 ?f29 ?f28 Z N">
              <xsl:if test="p:spPr/a:prstGeom/@prst='curvedUpArrow'">
                <xsl:attribute name ="draw:type">
                  <xsl:value-of select="'curvedUpArrow'"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="p:spPr/a:prstGeom/@prst='curvedDownArrow'">
                <xsl:attribute name ="draw:type">
                  <xsl:value-of select="'curvedDownArrow'"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="p:spPr/a:prstGeom/@prst='circularArrow'">
                <xsl:attribute name ="draw:type">
                  <xsl:value-of select="'circular-arrow'"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="p:spPr/a:prstGeom/@prst='curvedUpArrow'">
                <xsl:attribute name ="draw:mirror-vertical">
                  <xsl:value-of select="'true'"/>
                </xsl:attribute>
              </xsl:if>
              <draw:equation draw:name="f0" draw:formula="$0 "/>
              <draw:equation draw:name="f1" draw:formula="$1 "/>
              <draw:equation draw:name="f2" draw:formula="$2 "/>
              <draw:equation draw:name="f3" draw:formula="10800+$2 "/>
              <draw:equation draw:name="f4" draw:formula="10800*sin($0 *(pi/180))"/>
              <draw:equation draw:name="f5" draw:formula="10800*cos($0 *(pi/180))"/>
              <draw:equation draw:name="f6" draw:formula="10800*sin($1 *(pi/180))"/>
              <draw:equation draw:name="f7" draw:formula="10800*cos($1 *(pi/180))"/>
              <draw:equation draw:name="f8" draw:formula="?f4 +10800"/>
              <draw:equation draw:name="f9" draw:formula="?f5 +10800"/>
              <draw:equation draw:name="f10" draw:formula="?f6 +10800"/>
              <draw:equation draw:name="f11" draw:formula="?f7 +10800"/>
              <draw:equation draw:name="f12" draw:formula="?f3 *sin($0 *(pi/180))"/>
              <draw:equation draw:name="f13" draw:formula="?f3 *cos($0 *(pi/180))"/>
              <draw:equation draw:name="f14" draw:formula="?f3 *sin($1 *(pi/180))"/>
              <draw:equation draw:name="f15" draw:formula="?f3 *cos($1 *(pi/180))"/>
              <draw:equation draw:name="f16" draw:formula="?f12 +10800"/>
              <draw:equation draw:name="f17" draw:formula="?f13 +10800"/>
              <draw:equation draw:name="f18" draw:formula="?f14 +10800"/>
              <draw:equation draw:name="f19" draw:formula="?f15 +10800"/>
              <draw:equation draw:name="f20" draw:formula="21600-?f3 "/>
              <draw:equation draw:name="f21" draw:formula="13500*sin($1 *(pi/180))"/>
              <draw:equation draw:name="f22" draw:formula="13500*cos($1 *(pi/180))"/>
              <draw:equation draw:name="f23" draw:formula="?f21 +10800"/>
              <draw:equation draw:name="f24" draw:formula="?f22 +10800"/>
              <draw:equation draw:name="f25" draw:formula="$2 -2700"/>
              <draw:equation draw:name="f26" draw:formula="?f25 *sin($1 *(pi/180))"/>
              <draw:equation draw:name="f27" draw:formula="?f25 *cos($1 *(pi/180))"/>
              <draw:equation draw:name="f28" draw:formula="?f26 +10800"/>
              <draw:equation draw:name="f29" draw:formula="?f27 +10800"/>
              <draw:equation draw:name="f30" draw:formula="($1+45)*pi/180"/>
              <draw:equation draw:name="f31" draw:formula="sqrt(((?f29-?f24)*(?f29-?f24))+((?f28-?f23)*(?f28-?f23)))"/>
              <draw:equation draw:name="f32" draw:formula="sqrt(2)/2*?f31"/>
              <draw:equation draw:name="f33" draw:formula="?f32*sin(?f30)"/>
              <draw:equation draw:name="f34" draw:formula="?f32*cos(?f30)"/>
              <draw:equation draw:name="f35" draw:formula="?f28+?f33"/>
              <draw:equation draw:name="f36" draw:formula="?f29+?f34"/>
              <draw:handle draw:handle-position="10800 $0" draw:handle-polar="10800 10800" draw:handle-radius-range-minimum="10800" draw:handle-radius-range-maximum="10800"/>
              <draw:handle draw:handle-position="$2 $1" draw:handle-polar="10800 10800" draw:handle-radius-range-minimum="0" draw:handle-radius-range-maximum="10800"/>
            </draw:enhanced-geometry>
          </xsl:if>
          <xsl:if test="p:spPr/a:prstGeom/@prst='curvedRightArrow' or p:spPr/a:prstGeom/@prst='curvedLeftArrow'">
            <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:text-areas="0 0 21600 21600"                                                                                  
                                      draw:mirror-vertical="true" draw:type="circular-arrow" draw:modifiers="84.1499444519454 -80.8262021942408 7331.32459905244" draw:enhanced-path="B ?f3 ?f3 ?f20 ?f20 ?f19 ?f18 ?f17 ?f16 W 0 0 21600 21600 ?f9 ?f8 ?f11 ?f10 L ?f24 ?f23 ?f36 ?f35 ?f29 ?f28 Z N">
              <xsl:if test="p:spPr/a:prstGeom/@prst='curvedRightArrow'">
                <xsl:attribute name ="draw:type">
                  <xsl:value-of select="'curvedRightArrow'"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="p:spPr/a:prstGeom/@prst='curvedLeftArrow'">
                <xsl:attribute name ="draw:type">
                  <xsl:value-of select="'curvedLeftArrow'"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="p:spPr/a:prstGeom/@prst='curvedRightArrow'">
                <xsl:attribute name ="draw:mirror-horizontal">
                  <xsl:value-of select="'false'"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="p:spPr/a:prstGeom/@prst='curvedLeftArrow'">
                <xsl:attribute name ="draw:mirror-horizontal">
                  <xsl:value-of select="'true'"/>
                </xsl:attribute>
              </xsl:if>
              <draw:equation draw:name="f0" draw:formula="$0 "/>
              <draw:equation draw:name="f1" draw:formula="$1 "/>
              <draw:equation draw:name="f2" draw:formula="$2 "/>
              <draw:equation draw:name="f3" draw:formula="10800+$2 "/>
              <draw:equation draw:name="f4" draw:formula="10800*sin($0 *(pi/180))"/>
              <draw:equation draw:name="f5" draw:formula="10800*cos($0 *(pi/180))"/>
              <draw:equation draw:name="f6" draw:formula="10800*sin($1 *(pi/180))"/>
              <draw:equation draw:name="f7" draw:formula="10800*cos($1 *(pi/180))"/>
              <draw:equation draw:name="f8" draw:formula="?f4 +10800"/>
              <draw:equation draw:name="f9" draw:formula="?f5 +10800"/>
              <draw:equation draw:name="f10" draw:formula="?f6 +10800"/>
              <draw:equation draw:name="f11" draw:formula="?f7 +10800"/>
              <draw:equation draw:name="f12" draw:formula="?f3 *sin($0 *(pi/180))"/>
              <draw:equation draw:name="f13" draw:formula="?f3 *cos($0 *(pi/180))"/>
              <draw:equation draw:name="f14" draw:formula="?f3 *sin($1 *(pi/180))"/>
              <draw:equation draw:name="f15" draw:formula="?f3 *cos($1 *(pi/180))"/>
              <draw:equation draw:name="f16" draw:formula="?f12 +10800"/>
              <draw:equation draw:name="f17" draw:formula="?f13 +10800"/>
              <draw:equation draw:name="f18" draw:formula="?f14 +10800"/>
              <draw:equation draw:name="f19" draw:formula="?f15 +10800"/>
              <draw:equation draw:name="f20" draw:formula="21600-?f3 "/>
              <draw:equation draw:name="f21" draw:formula="13500*sin($1 *(pi/180))"/>
              <draw:equation draw:name="f22" draw:formula="13500*cos($1 *(pi/180))"/>
              <draw:equation draw:name="f23" draw:formula="?f21 +10800"/>
              <draw:equation draw:name="f24" draw:formula="?f22 +10800"/>
              <draw:equation draw:name="f25" draw:formula="$2 -2700"/>
              <draw:equation draw:name="f26" draw:formula="?f25 *sin($1 *(pi/180))"/>
              <draw:equation draw:name="f27" draw:formula="?f25 *cos($1 *(pi/180))"/>
              <draw:equation draw:name="f28" draw:formula="?f26 +10800"/>
              <draw:equation draw:name="f29" draw:formula="?f27 +10800"/>
              <draw:equation draw:name="f30" draw:formula="($1+45)*pi/180"/>
              <draw:equation draw:name="f31" draw:formula="sqrt(((?f29-?f24)*(?f29-?f24))+((?f28-?f23)*(?f28-?f23)))"/>
              <draw:equation draw:name="f32" draw:formula="sqrt(2)/2*?f31"/>
              <draw:equation draw:name="f33" draw:formula="?f32*sin(?f30)"/>
              <draw:equation draw:name="f34" draw:formula="?f32*cos(?f30)"/>
              <draw:equation draw:name="f35" draw:formula="?f28+?f33"/>
              <draw:equation draw:name="f36" draw:formula="?f29+?f34"/>
              <draw:handle draw:handle-position="10800 $0" draw:handle-polar="10800 10800" draw:handle-radius-range-minimum="10800" draw:handle-radius-range-maximum="10800"/>
              <draw:handle draw:handle-position="$2 $1" draw:handle-polar="10800 10800" draw:handle-radius-range-minimum="0" draw:handle-radius-range-maximum="10800"/>
            </draw:enhanced-geometry>
          </xsl:if>
        </draw:custom-shape>
      </xsl:when>
      
      <!-- Left-Up Arrow -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='leftUpArrow') 
                    or $enhancePath='M f5 f21 L f12 f16 L f12 f26 L f26 f26 L f26 f12 L f16 f12 L f21 f5 L f6 f12 L f23 f12 L f23 f23 L f12 f23 L f12 f6 Z N '
                or $enhancePath='M f38 f67 L f60 f68 L f60 f73 L f75 f73 L f75 f60 L f69 f60 L f66 f38 L f45 f60 L f76 f60 L f76 f74 L f60 f74 L f60 f46 Z N '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
			<xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:mirror-horizontal="false" 
            draw:text-areas="?f2 ?f7 ?f1 ?f1 ?f7 ?f2 ?f1 ?f1" draw:type="mso-spt89" 
            draw:modifiers="10062 18378 6098" 
            draw:enhanced-path="M 0 ?f5 L ?f2 ?f0 ?f2 ?f7 ?f7 ?f7 ?f7 ?f2 ?f0 ?f2 ?f5 0 21600 ?f2 ?f1 ?f2 ?f1 ?f1 ?f2 ?f1 ?f2 21600 Z N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="$0 "/>
            <draw:equation draw:name="f1" draw:formula="$1 "/>
            <draw:equation draw:name="f2" draw:formula="$2 "/>
            <draw:equation draw:name="f3" draw:formula="21600-$0 "/>
            <draw:equation draw:name="f4" draw:formula="?f3 /2"/>
            <draw:equation draw:name="f5" draw:formula="$0 +?f4 "/>
            <draw:equation draw:name="f6" draw:formula="21600-$1 "/>
            <draw:equation draw:name="f7" draw:formula="$0 +?f6 "/>
            <draw:equation draw:name="f8" draw:formula="21600-?f6 "/>
            <draw:equation draw:name="f9" draw:formula="?f8 -?f6 "/>
            <draw:handle draw:handle-position="$1 $2" draw:handle-range-x-minimum="?f5" draw:handle-range-x-maximum="21600" draw:handle-range-y-minimum="0" draw:handle-range-y-maximum="$0"/>
            <draw:handle draw:handle-position="$0 top" draw:handle-range-x-minimum="$2" draw:handle-range-x-maximum="?f9"/>
          </draw:enhanced-geometry>
       </draw:custom-shape>
      </xsl:when>
          <!-- SP2: Bent-Up Arrow -->
          <xsl:when test="$enhancePath='M f38 f65 L f71 f65 L f71 f60 L f66 f60 L f67 f38 L f46 f60 L f70 f60 L f70 f45 L f38 f45 Z N '
                   ">
           
            <draw:custom-shape draw:layer="layout" >
              <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
                <xsl:with-param name="sldId" select="$slideId" />
                <xsl:with-param name ="grID" select ="$GraphicId" />
                <xsl:with-param name ="prID" select ="$ParaId" />
                <xsl:with-param name="TypeId" select ="$TypeId" />
                <xsl:with-param name="grpBln" select ="$grpBln" />
                <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
                <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering -->
                <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
                <!-- End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering -->
              </xsl:call-template>
              <draw:enhanced-geometry svg:viewBox="0 0 1219197 1143000"
                                    draw:extrusion-allowed="true"
                                    draw:text-areas="0 857250 1076322 1143000"
                                    draw:glue-points="933447 0 647697 285750 0 1000125 538161 1143000 1076322 714375 1219197 285750"
                                    draw:type="mso-spt100"
                                    draw:enhanced-path="M 0 857250 L 790572 857250 L 790572 285750 L 647697 285750 L 933447 0 L 1219197 285750 L 1076322 285750 L 1076322 1143000 L 0 1143000 Z N">
                <xsl:if test="p:spPr/a:xfrm/@flipH='1'">
                  <xsl:attribute name ="draw:mirror-horizontal">
                    <xsl:value-of select="'true'"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:if test="p:spPr/a:xfrm/@flipV='1'">
                  <xsl:attribute name ="draw:mirror-vertical">
                    <xsl:value-of select="'true'"/>
                  </xsl:attribute>
                </xsl:if>
              </draw:enhanced-geometry>
            </draw:custom-shape>
          </xsl:when>
      <!-- Bent-Up Arrow -->
      <!--Bug Fix for Shape Corner-Right Arrow from ODP to PPtx-->
      <xsl:when test="( p:nvSpPr/p:cNvPr/@name[contains(., 'bentUpArrow ')] and 
                         not(p:nvSpPr/p:cNvPr/@name[contains(., 'Bent-Up Arrow ')]) 
                        and p:spPr/a:prstGeom/@prst='bentUpArrow') 
                          or $enhancePath='M f3 f4 L f3 f5 L f6 f5 L f6 f0 L f0 f0 L f0 f7 L f3 f7 L f3 f2 L f1 f8 L f3 f4 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name ="grID" select ="$GraphicId" />
            <xsl:with-param name ="prID" select ="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!-- End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering -->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 841 854" 
            draw:mirror-horizontal="false" 
            draw:mirror-vertical="false" 
            draw:type="non-primitive" 
            draw:enhanced-path="M 517 247 L 517 415 264 415 264 0 0 0 0 680 517 680 517 854 841 547 517 247 Z N">
          </draw:enhanced-geometry>
          
        </draw:custom-shape>
      </xsl:when>
      <!--End of bug fix code-->
      
      <xsl:when test ="p:spPr/a:prstGeom/@prst='bentUpArrow'">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
			 <xsl:with-param name="sldId" select="$slideId" /> 
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
			<xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 3276600 1905000" draw:extrusion-allowed="true" 
              draw:text-areas="0 1428750 3038475 1905000" 
              draw:glue-points="2800350 0 2324100 476250 0 1666874 1519238 1905000 3038475 1190624 3276600 476250" 
              draw:type="mso-spt100" 
              draw:enhanced-path="M 0 1428750 L 2562225 1428750 L 2562225 476250 L 2324100 476250 L 2800350 0 L 3276600 476250 L 3038475 476250 L 3038475 1905000 L 0 1905000 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      
      <!-- Cube -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='cube') or
                $enhancePath='S M f32 f48 L f53 f48 L f53 f39 L f32 f39 Z N S M f53 f48 L f40 f32 L f40 f54 L f53 f39 Z N S M f32 f48 L f48 f32 L f40 f32 L f53 f48 Z N F M f32 f48 L f48 f32 L f40 f32 L f40 f54 L f53 f39 L f32 f39 Z N M f32 f48 L f53 f48 L f40 f32 M f53 f48 L f53 f39 ' or
                $enhancePath='M f37 f45 L f37 f39 L f39 f37 L f46 f37 L f46 f47 L f44 f45 Z N M f37 f39 L f39 f37 L f46 f37 L f44 f39 Z N M f44 f45 L f44 f39 L f46 f37 L f46 f47 Z N ' or
                          $enhancePath='M f28 f37 L f28 f35 L f35 f28 L f38 f28 L f38 f39 L f36 f37 Z N M f28 f35 L f35 f28 L f38 f28 L f36 f35 Z N M f36 f37 L f36 f35 L f38 f28 L f38 f39 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
						draw:glue-points="?f7 0 ?f6 ?f1 0 ?f10 ?f6 21600 ?f4 ?f10 21600 ?f9" 
						draw:path-stretchpoint-x="10800" draw:path-stretchpoint-y="10800" 
						draw:text-areas="0 ?f1 ?f4 ?f12" draw:type="cube" draw:modifiers="5400" 
						draw:enhanced-path="M 0 ?f12 L 0 ?f1 ?f2 0 ?f11 0 ?f11 ?f3 ?f4 ?f12 Z N M 0 ?f1 L ?f2 0 ?f11 0 ?f4 ?f1 Z N M ?f4 ?f12 L ?f4 ?f1 ?f11 0 ?f11 ?f3 Z N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="$0 "/>
            <draw:equation draw:name="f1" draw:formula="top+?f0 "/>
            <draw:equation draw:name="f2" draw:formula="left+?f0 "/>
            <draw:equation draw:name="f3" draw:formula="bottom-?f0 "/>
            <draw:equation draw:name="f4" draw:formula="right-?f0 "/>
            <draw:equation draw:name="f5" draw:formula="right-?f2 "/>
            <draw:equation draw:name="f6" draw:formula="?f5 /2"/>
            <draw:equation draw:name="f7" draw:formula="?f2 +?f6 "/>
            <draw:equation draw:name="f8" draw:formula="bottom-?f1 "/>
            <draw:equation draw:name="f9" draw:formula="?f8 /2"/>
            <draw:equation draw:name="f10" draw:formula="?f1 +?f9 "/>
            <draw:equation draw:name="f11" draw:formula="right"/>
            <draw:equation draw:name="f12" draw:formula="bottom"/>
            <draw:handle draw:handle-position="left $0" 
									 draw:handle-switched="true" 
									 draw:handle-range-y-minimum="0" 
									 draw:handle-range-y-maximum="21600"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- Can -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='can') or
                $enhancePath='S M f24 f38 A f33 f38 f1 f8 L f28 f40 A f33 f38 f7 f1 Z N S M f24 f38 A f33 f38 f1 f1 A f33 f38 f7 f1 Z N F M f28 f38 A f33 f38 f7 f1 A f33 f38 f1 f1 L f28 f40 A f33 f38 f7 f1 L f24 f38 ' or
                          $enhancePath='M f9 f6 C f13 f6 f6 f38 f6 f30 L f6 f34 C f6 f39 f13 f8 f9 f8 C f14 f8 f7 f39 f7 f34 L f7 f30 C f7 f38 f14 f6 f9 f6 Z N M f9 f6 C f13 f6 f6 f38 f6 f30 C f6 f40 f13 f31 f9 f31 C f14 f31 f7 f40 f7 f30 C f7 f38 f14 f6 f9 f6 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 88 21600"
						draw:glue-points="44 ?f6 44 0 0 10800 44 21600 88 10800"
						draw:text-areas="0 ?f6 88 ?f3" draw:type="can" draw:modifiers="5400"
						draw:enhanced-path="M 44 0 C 20 0 0 ?f2 0 ?f0 L 0 ?f3 C 0 ?f4 20 21600 44 21600 68 21600 88 ?f4 88 ?f3 L 88 ?f0 C 88 ?f2 68 0 44 0 Z N M 44 0 C 20 0 0 ?f2 0 ?f0 0 ?f5 20 ?f6 44 ?f6 68 ?f6 88 ?f5 88 ?f0 88 ?f2 68 0 44 0 Z N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="$0 *2/4" />
            <draw:equation draw:name="f1" draw:formula="?f0 *6/11" />
            <draw:equation draw:name="f2" draw:formula="?f0 -?f1" />
            <draw:equation draw:name="f3" draw:formula="21600-?f0" />
            <draw:equation draw:name="f4" draw:formula="?f3 +?f1" />
            <draw:equation draw:name="f5" draw:formula="?f0 +?f1" />
            <draw:equation draw:name="f6" draw:formula="$0 *2/2" />
            <draw:equation draw:name="f7" draw:formula="44" />
            <draw:handle draw:handle-position="?f7 $0" draw:handle-range-y-minimum="0" draw:handle-range-y-maximum="10800" />
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- Cross (Added by A.Mathi as on 19/07/2007)-->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='plus') or
                $enhancePath='M f17 f30 L f30 f30 L f30 f17 L f35 f17 L f35 f30 L f20 f30 L f20 f36 L f35 f36 L f35 f21 L f30 f21 L f30 f36 L f17 f36 Z N ' or
                $enhancePath='M f36 f35 L f40 f35 L f40 f36 L f37 f36 L f37 f41 L f40 f41 L f40 f38 L f36 f38 L f36 f41 L f35 f41 L f35 f36 L f36 f36 L f36 f35 Z N ' or
                          $enhancePath='M f33 f25 L f34 f25 L f34 f33 L f26 f33 L f26 f35 L f34 f35 L f34 f27 L f33 f27 L f33 f35 L f25 f35 L f25 f33 L f33 f33 L f33 f25 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
			<xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name ="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select ="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
            draw:glue-points="10800 0 0 10800 10800 21600 21600 10800" 
            draw:path-stretchpoint-x="10800" 
            draw:path-stretchpoint-y="10800" 
            draw:text-areas="?f1 ?f1 ?f2 ?f3" 
            draw:type="cross" 
            draw:modifiers="5400" 
            draw:enhanced-path="M ?f1 0 L ?f2 0 ?f2 ?f1 21600 ?f1 21600 ?f3 ?f2 ?f3 ?f2 21600 ?f1 21600 ?f1 ?f3 0 ?f3 0 ?f1 ?f1 ?f1 ?f1 0 Z N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="$0 *10799/10800"/>
            <draw:equation draw:name="f1" draw:formula="?f0 "/>
            <draw:equation draw:name="f2" draw:formula="right-?f0 "/>
            <draw:equation draw:name="f3" draw:formula="bottom-?f0 "/>
            <draw:handle draw:handle-position="$0 top" 
              draw:handle-switched="true" 
              draw:handle-range-x-minimum="0" 
              draw:handle-range-x-maximum="10800"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- "No" Symbol (Added by A.Mathi as on 19/07/2007)-->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='noSmoking') or
                $enhancePath='M f33 f56 A f51 f52 f1 f2 A f51 f52 f3 f2 A f51 f52 f8 f2 A f51 f52 f2 f2 Z N M f157 f158 A f67 f68 f126 f127 Z N M f159 f160 A f67 f68 f128 f127 Z N ' or
                          $enhancePath='M f132 f133 A f15 f15 f52 f61 Z N M f198 f199 A f66 f66 f162 f180 Z N M f200 f201 A f66 f66 f164 f183 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
			<xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name ="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select ="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
            draw:glue-points="10800 0 3160 3160 0 10800 3160 18440 10800 21600 18440 18440 21600 10800 18440 3160" 
            draw:text-areas="3200 3200 18400 18400" 
            draw:type="forbidden" 
            draw:modifiers="2700" 
            draw:enhanced-path="U 10800 10800 10800 10800 0 23592960 Z B ?f0 ?f0 ?f1 ?f1 ?f9 ?f10 ?f11 ?f12 Z B ?f0 ?f0 ?f1 ?f1 ?f13 ?f14 ?f15 ?f16 Z N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="$0 "/>
            <draw:equation draw:name="f1" draw:formula="21600-$0 "/>
            <draw:equation draw:name="f2" draw:formula="10800-$0 "/>
            <draw:equation draw:name="f3" draw:formula="$0 /2"/>
            <draw:equation draw:name="f4" draw:formula="sqrt(?f2 *?f2 -?f3 *?f3 )"/>
            <draw:equation draw:name="f5" draw:formula="10800-?f3 "/>
            <draw:equation draw:name="f6" draw:formula="10800+?f3 "/>
            <draw:equation draw:name="f7" draw:formula="10800-?f4 "/>
            <draw:equation draw:name="f8" draw:formula="10800+?f4 "/>
            <draw:equation draw:name="f9" draw:formula="(cos(45*(pi/180))*(?f5 -10800)+sin(45*(pi/180))*(?f7 -10800))+10800"/>
            <draw:equation draw:name="f10" draw:formula="-(sin(45*(pi/180))*(?f5 -10800)-cos(45*(pi/180))*(?f7 -10800))+10800"/>
            <draw:equation draw:name="f11" draw:formula="(cos(45*(pi/180))*(?f5 -10800)+sin(45*(pi/180))*(?f8 -10800))+10800"/>
            <draw:equation draw:name="f12" draw:formula="-(sin(45*(pi/180))*(?f5 -10800)-cos(45*(pi/180))*(?f8 -10800))+10800"/>
            <draw:equation draw:name="f13" draw:formula="(cos(45*(pi/180))*(?f6 -10800)+sin(45*(pi/180))*(?f8 -10800))+10800"/>
            <draw:equation draw:name="f14" draw:formula="-(sin(45*(pi/180))*(?f6 -10800)-cos(45*(pi/180))*(?f8 -10800))+10800"/>
            <draw:equation draw:name="f15" draw:formula="(cos(45*(pi/180))*(?f6 -10800)+sin(45*(pi/180))*(?f7 -10800))+10800"/>
            <draw:equation draw:name="f16" draw:formula="-(sin(45*(pi/180))*(?f6 -10800)-cos(45*(pi/180))*(?f7 -10800))+10800"/>
            <draw:handle draw:handle-position="$0 10800" 
              draw:handle-range-x-minimum="0" 
              draw:handle-range-x-maximum="7200"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!--  Folded Corner (Added by A.Mathi as on 19/07/2007) -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='foldedCorner') or
                $enhancePath='S M f17 f17 L f20 f17 L f20 f30 L f31 f21 L f17 f21 Z N S M f31 f21 L f32 f33 L f20 f30 Z N F M f31 f21 L f32 f33 L f20 f30 L f31 f21 L f17 f21 L f17 f17 L f20 f17 L f20 f30 ' or
                          $enhancePath='M f6 f6 L f7 f6 L f7 f16 L f16 f7 L f6 f7 Z N M f16 f7 L f37 f16 C f39 f34 f35 f36 f7 f16 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
			<xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId" />
            <xsl:with-param name ="prID" select ="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
            draw:glue-points="10800 0 0 10800 10800 21600 21600 10800" 
            draw:text-areas="0 0 21600 ?f11" 
            draw:type="paper" 
            draw:modifiers="18900" 
            draw:enhanced-path="M 0 0 L 21600 0 21600 ?f0 ?f0 21600 0 21600 Z N M ?f0 21600 L ?f3 ?f0 C ?f8 ?f9 ?f10 ?f11 21600 ?f0 Z N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="$0 "/>
            <draw:equation draw:name="f1" draw:formula="21600-?f0 "/>
            <draw:equation draw:name="f2" draw:formula="?f1 *8000/10800"/>
            <draw:equation draw:name="f3" draw:formula="21600-?f2 "/>
            <draw:equation draw:name="f4" draw:formula="?f1 /2"/>
            <draw:equation draw:name="f5" draw:formula="?f1 /4"/>
            <draw:equation draw:name="f6" draw:formula="?f1 /7"/>
            <draw:equation draw:name="f7" draw:formula="?f1 /16"/>
            <draw:equation draw:name="f8" draw:formula="?f3 +?f5 "/>
            <draw:equation draw:name="f9" draw:formula="?f0 +?f6 "/>
            <draw:equation draw:name="f10" draw:formula="21600-?f4 "/>
            <draw:equation draw:name="f11" draw:formula="?f0 +?f7 "/>
            <draw:handle draw:handle-position="$0 bottom" 
              draw:handle-range-x-minimum="10800" 
              draw:handle-range-x-maximum="21600"/>
          </draw:enhanced-geometry>
         </draw:custom-shape>
      </xsl:when>
      <!--  Lightning Bolt (Added by A.Mathi as on 20/07/2007) -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='lightningBolt') or
                $enhancePath='M f7 f5 L f8 f9 L f10 f11 L f12 f13 L f14 f15 L f6 f6 L f16 f17 L f18 f19 L f20 f21 L f22 f23 L f5 f24 Z N ' or
                          $enhancePath='M f3 f5 L f6 f7 L f8 f9 L f10 f2 L f11 f12 L f13 f14 L f15 f16 L f17 f18 L f2 f4 L f19 f20 L f21 f22 L f3 f5 L f3 f5 Z N '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
			<xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name ="grID" select ="$GraphicId" />
            <xsl:with-param name ="prID" select ="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 640 861" 
            draw:text-areas="257 295 414 566" 
            draw:type="non-primitive" 
            draw:enhanced-path="M 640 233 L 221 293 506 12 367 0 29 406 431 347 145 645 99 520 0 861 326 765 209 711 640 233 640 233 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
		<!--  Explosion 1 (Modified by A.Mathi) -->
		<xsl:when test ="(p:spPr/a:prstGeom/@prst='irregularSeal1') or 
              $enhancePath='M f7 f8 L f9 f5 L f10 f11 L f12 f13 L f14 f15 L f16 f17 L f18 f19 L f6 f20 L f21 f22 L f23 f24 L f25 f26 L f27 f28 L f29 f30 L f31 f6 L f32 f33 L f34 f35 L f36 f37 L f38 f39 L f40 f41 L f5 f42 L f43 f44 L f45 f46 L f47 f48 L f49 f46 Z N 'or
                          $enhancePath='M f7 f8 L f9 f10 L f11 f12 L f13 f14 L f15 f16 L f17 f18 L f19 f20 L f5 f21 L f22 f23 L f24 f25 L f26 f27 L f28 f6 L f29 f30 L f31 f32 L f33 f34 L f35 f36 L f37 f38 L f39 f34 L f40 f41 L f42 f43 L f44 f45 L f46 f47 L f48 f49 L f6 f50 L f44 f51 L f52 f53 L f54 f55 L f56 f5 L f7 f8 Z N '">
			<draw:custom-shape draw:layer="layout">
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
					<!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600"
										draw:glue-points="14623 106 106 8718 8590 21600 21600 13393"
										draw:text-areas="4680 6570 16140 13280"
										draw:type="mso-spt71"
										draw:enhanced-path="M 10901 5905 L 8458 2399 7417 6425 476 2399 4732 7722 106 8718 3828 11880 243 14689 5772 14041 4868 17719 7819 15730 8590 21600 10637 15038 13349 19840 14125 14561 18248 18195 16938 13044 21600 13393 17710 10579 21198 8242 16806 7417 18482 4560 14257 5429 14623 106 10901 5905 Z N">
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
            		</draw:custom-shape>
		</xsl:when>
      <!-- Chord (Added by A.Mathi as on 20/07/2007)-->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='chord') or
                $enhancePath='M f164 f165 A f59 f60 f56 f69 Z N '">
        <!-- warn if chord -->
        <xsl:message terminate="no">translation.oox2odf.shapesTypeChord</xsl:message>
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name ="grID" select ="$GraphicId" />
            <xsl:with-param name ="prID" select ="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 914400 914400" 
            draw:extrusion-allowed="true" 
            draw:text-areas="133911 133911 780489 780489" 
            draw:glue-points="780489 780489 457201 0 618845 390244" 
            draw:type="mso-spt100" draw:enhanced-path="M 780489 780489 W 0 0 914400 914400 780489 780489 457200 0 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
       </draw:custom-shape>
      </xsl:when>
      <!-- Left Bracket (Added by A.Mathi as on 20/07/2007) -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='leftBracket') or
              $enhancePath = 'M f7 f6 C f10 f6 f6 f28 f6 f17 L f6 f18 C f6 f29 f10 f7 f7 f7 '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
			<xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name ="grID" select ="$GraphicId" />
            <xsl:with-param name ="prID" select ="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="21600 0 0 10800 21600 21600" draw:text-areas="6350 ?f3 21600 ?f4" draw:type="left-bracket" draw:modifiers="1800" 
            draw:enhanced-path="M 21600 0 C 10800 0 0 ?f3 0 ?f1 L 0 ?f2 C 0 ?f4 10800 21600 21600 21600 N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="$0 /2"/>
            <draw:equation draw:name="f1" draw:formula="top+$0 "/>
            <draw:equation draw:name="f2" draw:formula="bottom-$0 "/>
            <draw:equation draw:name="f3" draw:formula="top+?f0 "/>
            <draw:equation draw:name="f4" draw:formula="bottom-?f0 "/>
            <draw:handle draw:handle-position="left $0" draw:handle-range-y-minimum="0" draw:handle-range-y-maximum="10800"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- Right Bracket (Added by A.Mathi as on 20/07/2007) -->
     <xsl:when test ="(p:spPr/a:prstGeom/@prst='rightBracket') or
                $enhancePath = 'M f6 f6 C f10 f6 f7 f28 f7 f17 L f7 f18 C f7 f29 f10 f7 f6 f7 '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
			<xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name ="grID" select ="$GraphicId" />
            <xsl:with-param name ="prID" select ="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="0 0 0 21600 21600 10800" draw:text-areas="0 ?f3 15150 ?f4" draw:type="right-bracket" draw:modifiers="1800" 
            draw:enhanced-path="M 0 0 C 10800 0 21600 ?f3 21600 ?f1 L 21600 ?f2 C 21600 ?f4 10800 21600 0 21600 N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="$0 /2"/>
            <draw:equation draw:name="f1" draw:formula="top+$0 "/>
            <draw:equation draw:name="f2" draw:formula="bottom-$0 "/>
            <draw:equation draw:name="f3" draw:formula="top+?f0 "/>
            <draw:equation draw:name="f4" draw:formula="bottom-?f0 "/>
            <draw:handle draw:handle-position="right $0" draw:handle-range-y-minimum="0" draw:handle-range-y-maximum="10800"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- Left Brace (Added by A.Mathi as on 20/07/2007) -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='leftBrace') or
                $enhancePath='S M f44 f45 A f54 f61 f3 f3 L f57 f64 A f54 f61 f8 f10 A f54 f61 f3 f10 L f57 f61 A f54 f61 f2 f3 Z N F M f44 f45 A f54 f61 f3 f3 L f57 f64 A f54 f61 f8 f10 A f54 f61 f3 f10 L f57 f61 A f54 f61 f2 f3 ' or
                          $enhancePath='M f8 f7 C f12 f7 f13 f20 f13 f21 L f13 f36 C f13 f37 f11 f22 f7 f22 C f11 f22 f13 f38 f13 f39 L f13 f23 C f13 f40 f12 f8 f8 f8 '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
			  <xsl:with-param name="sldId" select="$slideId" />
			  <xsl:with-param name ="grID" select ="$GraphicId" />
			  <xsl:with-param name ="prID" select ="$ParaId" />
			  <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
			  <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
			  <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
			  <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
		  </xsl:call-template>
		  <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="21600 0 0 10800 21600 21600" draw:text-areas="13800 ?f9 21600 ?f10" draw:type="left-brace" draw:modifiers="1800 10800" 
        draw:enhanced-path="M 21600 0 C 16200 0 10800 ?f0 10800 ?f1 L 10800 ?f2 C 10800 ?f3 5400 ?f4 0 ?f4 5400 ?f4 10800 ?f5 10800 ?f6 L 10800 ?f7 C 10800 ?f8 16200 21600 21600 21600 N">
        <xsl:call-template name="tmpFlip"/>
			  <draw:equation draw:name="f0" draw:formula="$0 /2"/>
			  <draw:equation draw:name="f1" draw:formula="$0 "/>
			  <draw:equation draw:name="f2" draw:formula="?f4 -$0 "/>
			  <draw:equation draw:name="f3" draw:formula="?f4 -?f0 "/>
			  <draw:equation draw:name="f4" draw:formula="$1 "/>
			  <draw:equation draw:name="f5" draw:formula="?f4 +?f0 "/>
			  <draw:equation draw:name="f6" draw:formula="?f4 +$0 "/>
			  <draw:equation draw:name="f7" draw:formula="21600-$0 "/>
			  <draw:equation draw:name="f8" draw:formula="21600-?f0 "/>
			  <draw:equation draw:name="f9" draw:formula="$0 *10000/31953"/>
			  <draw:equation draw:name="f10" draw:formula="21600-?f9 "/>
			  <draw:handle draw:handle-position="10800 $0" draw:handle-range-y-minimum="0" draw:handle-range-y-maximum="5400"/>
			  <draw:handle draw:handle-position="left $1" draw:handle-range-y-minimum="0" draw:handle-range-y-maximum="21600"/>
		  </draw:enhanced-geometry>
         </draw:custom-shape>
  </xsl:when>
      <!-- Right Brace (Added by A.Mathi as on 23/07/2007) -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='rightBrace') or
                $enhancePath='S M f38 f38 A f55 f63 f4 f3 L f58 f66 A f55 f63 f2 f11 A f55 f63 f4 f11 L f58 f67 A f55 f63 f9 f3 Z N F M f38 f38 A f55 f63 f4 f3 L f58 f66 A f55 f63 f2 f11 A f55 f63 f4 f11 L f58 f67 A f55 f63 f9 f3 ' or
                          $enhancePath='M f7 f7 C f11 f7 f12 f20 f12 f21 L f12 f36 C f12 f37 f13 f22 f8 f22 C f13 f22 f12 f38 f12 f39 L f12 f23 C f12 f40 f11 f8 f7 f8 '">
	  <draw:custom-shape draw:layer="layout" >
		  <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
			<xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name ="grID" select ="$GraphicId" />
            <xsl:with-param name ="prID" select ="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
            draw:glue-points="0 0 0 21600 21600 10800" 
            draw:text-areas="0 ?f9 7800 ?f10" 
            draw:type="right-brace" 
            draw:modifiers="1800 10800" 
            draw:enhanced-path="M 0 0 C 5400 0 10800 ?f0 10800 ?f1 L 10800 ?f2 C 10800 ?f3 16200 ?f4 21600 ?f4 16200 ?f4 10800 ?f5 10800 ?f6 L 10800 ?f7 C 10800 ?f8 5400 21600 0 21600 N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="$0 /2"/>
            <draw:equation draw:name="f1" draw:formula="$0 "/>
            <draw:equation draw:name="f2" draw:formula="?f4 -$0 "/>
            <draw:equation draw:name="f3" draw:formula="?f4 -?f0 "/>
            <draw:equation draw:name="f4" draw:formula="$1 "/>
            <draw:equation draw:name="f5" draw:formula="?f4 +?f0 "/>
            <draw:equation draw:name="f6" draw:formula="?f4 +$0 "/>
            <draw:equation draw:name="f7" draw:formula="21600-$0 "/>
            <draw:equation draw:name="f8" draw:formula="21600-?f0 "/>
            <draw:equation draw:name="f9" draw:formula="$0 *10000/31953"/>
            <draw:equation draw:name="f10" draw:formula="21600-?f9 "/>
            <draw:handle draw:handle-position="10800 $0" draw:handle-range-y-minimum="0" draw:handle-range-y-maximum="5400"/>
            <draw:handle draw:handle-position="right $1" draw:handle-range-y-minimum="0" draw:handle-range-y-maximum="21600"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
		<!-- Rectangular Callout (modified by A.Mathi) -->
		<xsl:when test ="(p:spPr/a:prstGeom/@prst='wedgeRectCallout') or 
              $enhancePath='M f7 f7 L f7 f12 L f54 f55 L f7 f13 L f7 f14 L f56 f57 L f7 f15 L f7 f8 L f12 f8 L f58 f59 L f13 f8 L f14 f8 L f60 f61 L f15 f8 L f8 f8 L f8 f15 L f62 f63 L f8 f14 L f8 f13 L f64 f65 L f8 f12 L f8 f7 L f15 f7 L f66 f67 L f14 f7 L f13 f7 L f68 f69 L f12 f7 L f7 f7 Z N ' or
                          $enhancePath='M f7 f7 L f7 f12 L f56 f57 L f7 f13 L f7 f14 L f58 f59 L f7 f15 L f7 f8 L f12 f8 L f60 f61 L f13 f8 L f14 f8 L f62 f63 L f15 f8 L f8 f8 L f8 f15 L f64 f65 L f8 f14 L f8 f13 L f66 f67 L f8 f12 L f8 f7 L f15 f7 L f68 f69 L f14 f7 L f13 f7 L f70 f71 L f12 f7 L f7 f7 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
					<!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
				  draw:glue-points="10800 0 0 10800 10800 21600 21600 10800 ?f40 ?f41" 
				  draw:text-areas="0 0 21600 21600" 
				  draw:type="rectangular-callout"
				  draw:enhanced-path="M 0 0 L 0 3590 ?f2 ?f3 0 8970 0 12630 ?f4 ?f5 0 18010 0 21600 3590 21600 ?f6 ?f7 8970 21600 12630 21600 ?f8 ?f9 18010 21600 21600 21600 21600 18010 ?f10 ?f11 21600 12630 21600 8970 ?f12 ?f13 21600 3590 21600 0 18010 0 ?f14 ?f15 12630 0 8970 0 ?f16 ?f17 3590 0 0 0 Z N">
					<xsl:call-template name="tmpCalloutAdj">
						<xsl:with-param name="defaultVal" select="'6300 24300'"/>
					</xsl:call-template>
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="$0 -10800"/>
					<draw:equation draw:name="f1" draw:formula="$1 -10800"/>
					<draw:equation draw:name="f2" draw:formula="if(?f18 ,$0 ,0)"/>
					<draw:equation draw:name="f3" draw:formula="if(?f18 ,$1 ,6280)"/>
					<draw:equation draw:name="f4" draw:formula="if(?f23 ,$0 ,0)"/>
					<draw:equation draw:name="f5" draw:formula="if(?f23 ,$1 ,15320)"/>
					<draw:equation draw:name="f6" draw:formula="if(?f26 ,$0 ,6280)"/>
					<draw:equation draw:name="f7" draw:formula="if(?f26 ,$1 ,21600)"/>
					<draw:equation draw:name="f8" draw:formula="if(?f29 ,$0 ,15320)"/>
					<draw:equation draw:name="f9" draw:formula="if(?f29 ,$1 ,21600)"/>
					<draw:equation draw:name="f10" draw:formula="if(?f32 ,$0 ,21600)"/>
					<draw:equation draw:name="f11" draw:formula="if(?f32 ,$1 ,15320)"/>
					<draw:equation draw:name="f12" draw:formula="if(?f34 ,$0 ,21600)"/>
					<draw:equation draw:name="f13" draw:formula="if(?f34 ,$1 ,6280)"/>
					<draw:equation draw:name="f14" draw:formula="if(?f36 ,$0 ,15320)"/>
					<draw:equation draw:name="f15" draw:formula="if(?f36 ,$1 ,0)"/>
					<draw:equation draw:name="f16" draw:formula="if(?f38 ,$0 ,6280)"/>
					<draw:equation draw:name="f17" draw:formula="if(?f38 ,$1 ,0)"/>
					<draw:equation draw:name="f18" draw:formula="if($0 ,-1,?f19 )"/>
					<draw:equation draw:name="f19" draw:formula="if(?f1 ,-1,?f22 )"/>
					<draw:equation draw:name="f20" draw:formula="abs(?f0 )"/>
					<draw:equation draw:name="f21" draw:formula="abs(?f1 )"/>
					<draw:equation draw:name="f22" draw:formula="?f20 -?f21 "/>
					<draw:equation draw:name="f23" draw:formula="if($0 ,-1,?f24 )"/>
					<draw:equation draw:name="f24" draw:formula="if(?f1 ,?f22 ,-1)"/>
					<draw:equation draw:name="f25" draw:formula="$1 -21600"/>
					<draw:equation draw:name="f26" draw:formula="if(?f25 ,?f27 ,-1)"/>
					<draw:equation draw:name="f27" draw:formula="if(?f0 ,-1,?f28 )"/>
					<draw:equation draw:name="f28" draw:formula="?f21 -?f20 "/>
					<draw:equation draw:name="f29" draw:formula="if(?f25 ,?f30 ,-1)"/>
					<draw:equation draw:name="f30" draw:formula="if(?f0 ,?f28 ,-1)"/>
					<draw:equation draw:name="f31" draw:formula="$0 -21600"/>
					<draw:equation draw:name="f32" draw:formula="if(?f31 ,?f33 ,-1)"/>
					<draw:equation draw:name="f33" draw:formula="if(?f1 ,?f22 ,-1)"/>
					<draw:equation draw:name="f34" draw:formula="if(?f31 ,?f35 ,-1)"/>
					<draw:equation draw:name="f35" draw:formula="if(?f1 ,-1,?f22 )"/>
					<draw:equation draw:name="f36" draw:formula="if($1 ,-1,?f37 )"/>
					<draw:equation draw:name="f37" draw:formula="if(?f0 ,?f28 ,-1)"/>
					<draw:equation draw:name="f38" draw:formula="if($1 ,-1,?f39 )"/>
					<draw:equation draw:name="f39" draw:formula="if(?f0 ,-1,?f28 )"/>
					<draw:equation draw:name="f40" draw:formula="$0 "/>
					<draw:equation draw:name="f41" draw:formula="$1 "/>
					<draw:handle draw:handle-position="$0 $1"/>
				</draw:enhanced-geometry>
            		</draw:custom-shape>
		</xsl:when>
		<!-- Rounded Rectangular Callout (modified by A.Mathi) -->
		<xsl:when test ="(p:spPr/a:prstGeom/@prst='wedgeRoundRectCallout') or 
              $enhancePath='M f13 f8 A f40 f41 f80 f65 L f96 f97 L f8 f14 L f8 f15 L f98 f99 L f8 f16 A f41 f46 f81 f68 L f100 f101 L f14 f9 L f15 f9 L f102 f103 L f16 f9 A f46 f51 f82 f71 L f104 f105 L f9 f15 L f9 f14 L f106 f107 L f9 f13 A f51 f40 f83 f74 L f108 f109 L f15 f8 L f14 f8 L f110 f111 Z N ' or
                          $enhancePath='M f12 f7 A f35 f36 f71 f59 L f87 f88 L f7 f13 L f7 f14 L f89 f90 L f7 f15 A f36 f41 f72 f62 L f91 f92 L f13 f8 L f14 f8 L f93 f94 L f15 f8 A f41 f46 f73 f65 L f95 f96 L f8 f14 L f8 f13 L f97 f98 L f8 f12 A f46 f35 f74 f68 L f99 f100 L f14 f7 L f13 f7 L f101 f102 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
					<!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
				  draw:text-areas="800 800 20800 20800" 
				  draw:type="round-rectangular-callout"
				  draw:enhanced-path="M 3590 0 X 0 3590 L ?f2 ?f3 0 8970 0 12630 ?f4 ?f5 0 18010 Y 3590 21600 L ?f6 ?f7 8970 21600 12630 21600 ?f8 ?f9 18010 21600 X 21600 18010 L ?f10 ?f11 21600 12630 21600 8970 ?f12 ?f13 21600 3590 Y 18010 0 L ?f14 ?f15 12630 0 8970 0 ?f16 ?f17 Z N">
					<xsl:call-template name="tmpCalloutAdj">
						<xsl:with-param name="defaultVal" select="'6300 24300'"/>
					</xsl:call-template>
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="$0 -10800"/>
					<draw:equation draw:name="f1" draw:formula="$1 -10800"/>
					<draw:equation draw:name="f2" draw:formula="if(?f18 ,$0 ,0)"/>
					<draw:equation draw:name="f3" draw:formula="if(?f18 ,$1 ,6280)"/>
					<draw:equation draw:name="f4" draw:formula="if(?f23 ,$0 ,0)"/>
					<draw:equation draw:name="f5" draw:formula="if(?f23 ,$1 ,15320)"/>
					<draw:equation draw:name="f6" draw:formula="if(?f26 ,$0 ,6280)"/>
					<draw:equation draw:name="f7" draw:formula="if(?f26 ,$1 ,21600)"/>
					<draw:equation draw:name="f8" draw:formula="if(?f29 ,$0 ,15320)"/>
					<draw:equation draw:name="f9" draw:formula="if(?f29 ,$1 ,21600)"/>
					<draw:equation draw:name="f10" draw:formula="if(?f32 ,$0 ,21600)"/>
					<draw:equation draw:name="f11" draw:formula="if(?f32 ,$1 ,15320)"/>
					<draw:equation draw:name="f12" draw:formula="if(?f34 ,$0 ,21600)"/>
					<draw:equation draw:name="f13" draw:formula="if(?f34 ,$1 ,6280)"/>
					<draw:equation draw:name="f14" draw:formula="if(?f36 ,$0 ,15320)"/>
					<draw:equation draw:name="f15" draw:formula="if(?f36 ,$1 ,0)"/>
					<draw:equation draw:name="f16" draw:formula="if(?f38 ,$0 ,6280)"/>
					<draw:equation draw:name="f17" draw:formula="if(?f38 ,$1 ,0)"/>
					<draw:equation draw:name="f18" draw:formula="if($0 ,-1,?f19 )"/>
					<draw:equation draw:name="f19" draw:formula="if(?f1 ,-1,?f22 )"/>
					<draw:equation draw:name="f20" draw:formula="abs(?f0 )"/>
					<draw:equation draw:name="f21" draw:formula="abs(?f1 )"/>
					<draw:equation draw:name="f22" draw:formula="?f20 -?f21 "/>
					<draw:equation draw:name="f23" draw:formula="if($0 ,-1,?f24 )"/>
					<draw:equation draw:name="f24" draw:formula="if(?f1 ,?f22 ,-1)"/>
					<draw:equation draw:name="f25" draw:formula="$1 -21600"/>
					<draw:equation draw:name="f26" draw:formula="if(?f25 ,?f27 ,-1)"/>
					<draw:equation draw:name="f27" draw:formula="if(?f0 ,-1,?f28 )"/>
					<draw:equation draw:name="f28" draw:formula="?f21 -?f20 "/>
					<draw:equation draw:name="f29" draw:formula="if(?f25 ,?f30 ,-1)"/>
					<draw:equation draw:name="f30" draw:formula="if(?f0 ,?f28 ,-1)"/>
					<draw:equation draw:name="f31" draw:formula="$0 -21600"/>
					<draw:equation draw:name="f32" draw:formula="if(?f31 ,?f33 ,-1)"/>
					<draw:equation draw:name="f33" draw:formula="if(?f1 ,?f22 ,-1)"/>
					<draw:equation draw:name="f34" draw:formula="if(?f31 ,?f35 ,-1)"/>
					<draw:equation draw:name="f35" draw:formula="if(?f1 ,-1,?f22 )"/>
					<draw:equation draw:name="f36" draw:formula="if($1 ,-1,?f37 )"/>
					<draw:equation draw:name="f37" draw:formula="if(?f0 ,?f28 ,-1)"/>
					<draw:equation draw:name="f38" draw:formula="if($1 ,-1,?f39 )"/>
					<draw:equation draw:name="f39" draw:formula="if(?f0 ,-1,?f28 )"/>
					<draw:equation draw:name="f40" draw:formula="$0 "/>
					<draw:equation draw:name="f41" draw:formula="$1 "/>
					<draw:handle draw:handle-position="$0 $1"/>
				</draw:enhanced-geometry>
             		</draw:custom-shape>
		</xsl:when>
		<!-- Oval Callout (modified by A.Mathi) -->
		<xsl:when test ="(p:spPr/a:prstGeom/@prst='wedgeEllipseCallout') or 
              $enhancePath='M f143 f144 A f33 f33 f125 f135 L f97 f98 Z N ' or
                          $enhancePath='M f141 f142 A f29 f29 f123 f133 L f95 f96 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
					<!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
				  draw:glue-points="10800 0 3160 3160 0 10800 3160 18440 10800 21600 18440 18440 21600 10800 18440 3160 ?f14 ?f15" 
				  draw:text-areas="3200 3200 18400 18400" 
				  draw:type="round-callout"
       				  draw:enhanced-path="W 0 0 21600 21600 ?f22 ?f23 ?f18 ?f19 L ?f14 ?f15 Z N">
					<xsl:call-template name="tmpCalloutAdj">
						<xsl:with-param name="defaultVal" select="'6300 24300'"/>
					</xsl:call-template>
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="$0 -10800"/>
					<draw:equation draw:name="f1" draw:formula="$1 -10800"/>
					<draw:equation draw:name="f2" draw:formula="?f0 *?f0 "/>
					<draw:equation draw:name="f3" draw:formula="?f1 *?f1 "/>
					<draw:equation draw:name="f4" draw:formula="?f2 +?f3 "/>
					<draw:equation draw:name="f5" draw:formula="sqrt(?f4 )"/>
					<draw:equation draw:name="f6" draw:formula="?f5 -10800"/>
					<draw:equation draw:name="f7" draw:formula="atan2(?f1 ,?f0 )/(pi/180)"/>
					<draw:equation draw:name="f8" draw:formula="?f7 -10"/>
					<draw:equation draw:name="f9" draw:formula="?f7 +10"/>
					<draw:equation draw:name="f10" draw:formula="10800*cos(?f7 *(pi/180))"/>
					<draw:equation draw:name="f11" draw:formula="10800*sin(?f7 *(pi/180))"/>
					<draw:equation draw:name="f12" draw:formula="?f10 +10800"/>
					<draw:equation draw:name="f13" draw:formula="?f11 +10800"/>
					<draw:equation draw:name="f14" draw:formula="if(?f6 ,$0 ,?f12 )"/>
					<draw:equation draw:name="f15" draw:formula="if(?f6 ,$1 ,?f13 )"/>
					<draw:equation draw:name="f16" draw:formula="10800*cos(?f8 *(pi/180))"/>
					<draw:equation draw:name="f17" draw:formula="10800*sin(?f8 *(pi/180))"/>
					<draw:equation draw:name="f18" draw:formula="?f16 +10800"/>
					<draw:equation draw:name="f19" draw:formula="?f17 +10800"/>
					<draw:equation draw:name="f20" draw:formula="10800*cos(?f9 *(pi/180))"/>
					<draw:equation draw:name="f21" draw:formula="10800*sin(?f9 *(pi/180))"/>
					<draw:equation draw:name="f22" draw:formula="?f20 +10800"/>
					<draw:equation draw:name="f23" draw:formula="?f21 +10800"/>
					<draw:handle draw:handle-position="$0 $1"/>
				</draw:enhanced-geometry>
            		</draw:custom-shape>
		</xsl:when>
		<!-- Cloud Callout (modified by A.Mathi) -->
		<xsl:when test ="(p:spPr/a:prstGeom/@prst='cloudCallout') or
              $enhancePath='M f20 f21 A f22 f23 f7 f24 A f25 f26 f8 f27 A f28 f29 f9 f30 A f31 f32 f10 f33 A f25 f34 f11 f35 A f36 f37 f12 f38 A f39 f40 f41 f42 A f43 f44 f45 f46 A f47 f48 f49 f50 A f51 f52 f13 f53 A f54 f29 f14 f55 Z N F M f56 f57 A f54 f29 f58 f59 M f60 f61 A f51 f52 f62 f63 M f64 f65 A f43 f44 f66 f67 M f68 f69 A f43 f44 f70 f71 M f72 f73 A f39 f40 f15 f74 M f75 f76 A f25 f34 f77 f78 M f79 f80 A f31 f32 f16 f81 M f82 f83 A f31 f32 f17 f84 M f85 f86 A f28 f29 f18 f87 M f88 f89 A f22 f23 f19 f90 M f91 f92 A f22 f23 f93 f94 ' or
                          $enhancePath='M f3 f4 L f5 f6 L f7 f8 L f9 f10 L f9 f11 L f5 f12 L f13 f14 L f15 f16 L f17 f18 L f19 f20 L f21 f18 L f22 f18 L f23 f24 L f25 f16 L f26 f18 L f27 f28 L f29 f30 L f31 f2 L f32 f30 L f33 f28 L f34 f18 L f35 f16 L f36 f37 L f38 f24 L f39 f24 L f40 f18 L f41 f24 L f42 f16 L f43 f44 L f45 f46 L f47 f48 L f49 f48 L f49 f48 L f49 f48 L f50 f48 L f51 f52 L f53 f11 L f54 f10 L f55 f56 L f0 f57 L f55 f58 L f59 f60 L f61 f62 L f63 f64 L f63 f64 L f63 f64 L f65 f64 L f66 f67 L f68 f69 L f70 f71 L f70 f72 L f68 f73 L f74 f75 L f76 f77 L f78 f79 L f80 f81 L f82 f77 L f83 f84 L f85 f86 L f87 f86 L f87 f86 L f88 f86 L f88 f86 L f88 f86 L f40 f86 L f40 f86 L f89 f84 L f90 f91 L f92 f77 L f93 f81 L f35 f81 L f34 f77 L f33 f91 L f94 f91 L f95 f91 L f95 f91 L f95 f91 L f95 f77 L f96 f97 L f98 f99 L f25 f55 L f100 f0 L f101 f55 L f102 f54 L f103 f77 L f104 f86 L f105 f106 L f105 f107 L f105 f107 L f105 f108 L f105 f109 L f110 f109 L f15 f109 L f111 f109 L f111 f109 L f3 f112 L f113 f114 L f115 f116 L f117 f64 L f1 f118 L f117 f58 L f115 f119 L f113 f120 L f3 f4 ' or
                          $enhancePath='M f12 f13 C f14 f15 f16 f17 f18 f17 C f19 f20 f21 f22 f23 f24 C f25 f26 f27 f28 f29 f28 C f30 f31 f32 f33 f34 f35 C f36 f37 f38 f7 f39 f7 C f40 f7 f41 f42 f43 f44 C f45 f46 f47 f7 f48 f7 C f49 f7 f50 f51 f52 f53 C f54 f55 f56 f57 f56 f58 C f56 f59 f60 f61 f62 f63 C f64 f65 f8 f66 f8 f67 C f8 f68 f69 f70 f71 f72 C f71 f73 f74 f75 f76 f75 C f77 f75 f78 f79 f80 f81 C f82 f54 f83 f8 f84 f8 C f85 f8 f86 f87 f88 f89 C f90 f91 f92 f93 f94 f93 C f95 f93 f96 f97 f98 f99 C f100 f101 f102 f103 f102 f104 C f102 f105 f31 f106 f107 f108 C f109 f110 f7 f34 f7 f111 C f7 f112 f113 f114 f12 f13 Z N F M f12 f13 C f20 f115 f116 f117 f118 f119 F M f23 f24 C f61 f120 f121 f122 f123 f124 F M f34 f35 C f125 f126 f127 f128 f129 f130 F M f43 f44 C f131 f132 f133 f134 f135 f136 F M f52 f53 C f137 f138 f139 f140 f141 f142 F M f62 f63 C f143 f144 f145 f146 f147 f148 F M f149 f72 C f150 f151 f152 f153 f154 f155 F M f80 f81 C f156 f157 f158 f159 f160 f161 F M f162 f89 C f163 f164 f165 f166 f167 f168 F M f98 f99 C f169 f101 f170 f171 f172 f173 F M f107 f108 C f132 f174 f175 f176 f177 f178 M f286 f287 A f182 f182 f211 f215 Z N M f288 f289 A f184 f184 f211 f215 Z N M f260 f261 A f186 f186 f211 f215 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
					<!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
				  draw:text-areas="3000 3320 17110 17330" 
				  draw:type="cloud-callout"
				  draw:enhanced-path="M 1930 7160 C 1530 4490 3400 1970 5270 1970 5860 1950 6470 2210 6970 2600 7450 1390 8340 650 9340 650 10004 690 10710 1050 11210 1700 11570 630 12330 0 13150 0 13840 0 14470 460 14870 1160 15330 440 16020 0 16740 0 17910 0 18900 1130 19110 2710 20240 3150 21060 4580 21060 6220 21060 6720 21000 7200 20830 7660 21310 8460 21600 9450 21600 10460 21600 12750 20310 14680 18650 15010 18650 17200 17370 18920 15770 18920 15220 18920 14700 18710 14240 18310 13820 20240 12490 21600 11000 21600 9890 21600 8840 20790 8210 19510 7620 20000 7930 20290 6240 20290 4850 20290 3570 19280 2900 17640 1300 17600 480 16300 480 14660 480 13900 690 13210 1070 12640 380 12160 0 11210 0 10120 0 8590 840 7330 1930 7160 Z N M 1930 7160 C 1950 7410 2040 7690 2090 7920 F N M 6970 2600 C 7200 2790 7480 3050 7670 3310 F N M 11210 1700 C 11130 1910 11080 2160 11030 2400 F N M 14870 1160 C 14720 1400 14640 1720 14540 2010 F N M 19110 2710 C 19130 2890 19230 3290 19190 3380 F N M 20830 7660 C 20660 8170 20430 8620 20110 8990 F N M 18660 15010 C 18740 14200 18280 12200 17000 11450 F N M 14240 18310 C 14320 17980 14350 17680 14370 17360 F N M 8220 19510 C 8060 19250 7960 18950 7860 18640 F N M 2900 17640 C 3090 17600 3280 17540 3460 17450 F N M 1070 12640 C 1400 12900 1780 13130 2330 13040 F N U ?f17 ?f18 1800 1800 0 23592960 Z N U ?f19 ?f20 1200 1200 0 23592960 Z N U ?f13 ?f14 700 700 0 23592960 Z N">
					<xsl:call-template name="tmpCalloutAdj">
						<xsl:with-param name="defaultVal" select="'6300 24300'"/>
					</xsl:call-template>
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="$0 -10800"/>
					<draw:equation draw:name="f1" draw:formula="$1 -10800"/>
					<draw:equation draw:name="f2" draw:formula="atan2(?f1 ,?f0 )/(pi/180)"/>
					<draw:equation draw:name="f3" draw:formula="10800*cos(?f2 *(pi/180))"/>
					<draw:equation draw:name="f4" draw:formula="10800*sin(?f2 *(pi/180))"/>
					<draw:equation draw:name="f5" draw:formula="?f3 +10800"/>
					<draw:equation draw:name="f6" draw:formula="?f4 +10800"/>
					<draw:equation draw:name="f7" draw:formula="$0 -?f5 "/>
					<draw:equation draw:name="f8" draw:formula="$1 -?f6 "/>
					<draw:equation draw:name="f9" draw:formula="?f7 /3"/>
					<draw:equation draw:name="f10" draw:formula="?f8 /3"/>
					<draw:equation draw:name="f11" draw:formula="?f7 *2/3"/>
					<draw:equation draw:name="f12" draw:formula="?f8 *2/3"/>
					<draw:equation draw:name="f13" draw:formula="$0 "/>
					<draw:equation draw:name="f14" draw:formula="$1 "/>
					<draw:equation draw:name="f15" draw:formula="?f3 /12"/>
					<draw:equation draw:name="f16" draw:formula="?f4 /12"/>
					<draw:equation draw:name="f17" draw:formula="?f9 +?f5 -?f15 "/>
					<draw:equation draw:name="f18" draw:formula="?f10 +?f6 -?f16 "/>
					<draw:equation draw:name="f19" draw:formula="?f11 +?f5 "/>
					<draw:equation draw:name="f20" draw:formula="?f12 +?f6 "/>
					<draw:handle draw:handle-position="$0 $1"/>
				</draw:enhanced-geometry>
            		</draw:custom-shape>
		</xsl:when>
		<!-- Line Callout 1) -->
		<xsl:when test ="(p:spPr/a:prstGeom/@prst='borderCallout1') or 
              $enhancePath='M f22 f22 L f25 f22 L f25 f26 L f22 f26 Z N M f41 f42 L f43 f44 ' or
                           $enhancePath= 'M f10 f10 L f11 f10 L f11 f11 L f10 f11 Z N M f20 f21 L f22 f23 '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
					<!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
					draw:mirror-horizontal="false"
					draw:type="line-callout-1"
					draw:enhanced-path="M 0 0 L 21600 0 21600 21600 0 21600 Z N M ?f0 ?f1 L ?f2 ?f3 N">
					<xsl:call-template name="tmpCalloutLineAdj">
						<xsl:with-param name="defaultVal" select="'-8300 24500 -1800 4000'"/>
					</xsl:call-template>
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="$0 "/>
					<draw:equation draw:name="f1" draw:formula="$1 "/>
					<draw:equation draw:name="f2" draw:formula="$2 "/>
					<draw:equation draw:name="f3" draw:formula="$3 "/>
					<draw:equation draw:name="f4" draw:formula="$4 "/>
					<draw:equation draw:name="f5" draw:formula="$5 "/>
					<draw:equation draw:name="f6" draw:formula="$6 "/>
					<draw:equation draw:name="f7" draw:formula="$7 "/>
					<draw:handle draw:handle-position="$0 $1"/>
					<draw:handle draw:handle-position="$2 $3"/>
				</draw:enhanced-geometry>
             		</draw:custom-shape>
		</xsl:when>
		<!-- Line Callout 2) -->
		<xsl:when test ="(p:spPr/a:prstGeom/@prst='borderCallout2') or 
              $enhancePath='M f26 f26 L f29 f26 L f29 f30 L f26 f30 Z N F M f51 f52 L f53 f54 L f55 f56 ' or
                          $enhancePath='M f10 f10 L f11 f10 L f11 f11 L f10 f11 Z N M f22 f23 L f24 f25 M f24 f25 L f26 f27 '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
					<!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600"
					draw:mirror-horizontal="false"
					draw:type="line-callout-2"
					draw:enhanced-path="M 0 0 L 21600 0 21600 21600 0 21600 Z N M ?f0 ?f1 L ?f2 ?f3 N M ?f2 ?f3 L ?f4 ?f5 N">
					<xsl:call-template name="tmpCalloutLineAdj">
						<xsl:with-param name="defaultVal" select="'-10000 24500 -3600 4000 -1800 4000'"/>
					</xsl:call-template>
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="$0 "/>
					<draw:equation draw:name="f1" draw:formula="$1 "/>
					<draw:equation draw:name="f2" draw:formula="$2 "/>
					<draw:equation draw:name="f3" draw:formula="$3 "/>
					<draw:equation draw:name="f4" draw:formula="$4 "/>
					<draw:equation draw:name="f5" draw:formula="$5 "/>
					<draw:equation draw:name="f6" draw:formula="$6 "/>
					<draw:equation draw:name="f7" draw:formula="$7 "/>
					<draw:handle draw:handle-position="$0 $1"/>
					<draw:handle draw:handle-position="$2 $3"/>
					<draw:handle draw:handle-position="$4 $5"/>
				</draw:enhanced-geometry>
            		</draw:custom-shape>
		</xsl:when>
		<!-- Line Callout 3) -->
		<xsl:when test ="(p:spPr/a:prstGeom/@prst='borderCallout3') or 
              $enhancePath='S M f26 f26 L f29 f26 L f29 f30 L f26 f30 Z N F M f51 f52 L f53 f54 L f55 f56 '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
					<!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600"
					draw:type="mso-spt49"
					draw:enhanced-path="M 0 0 L 21600 0 21600 21600 0 21600 Z N M ?f6 ?f7 F L ?f4 ?f5 ?f2 ?f3 ?f0 ?f1 N">
					<xsl:call-template name="tmpCalloutLineAdj">
						<xsl:with-param name="defaultVal" select="'-1800 0 -3600 0 -3600 0 -1800 4000'"/>
					</xsl:call-template>
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="$0 "/>
					<draw:equation draw:name="f1" draw:formula="$1 "/>
					<draw:equation draw:name="f2" draw:formula="$2 "/>
					<draw:equation draw:name="f3" draw:formula="$3 "/>
					<draw:equation draw:name="f4" draw:formula="$4 "/>
					<draw:equation draw:name="f5" draw:formula="$5 "/>
					<draw:equation draw:name="f6" draw:formula="$6 "/>
					<draw:equation draw:name="f7" draw:formula="$7 "/>
					<draw:handle draw:handle-position="$0 $1"/>
					<draw:handle draw:handle-position="$2 $3"/>
					<draw:handle draw:handle-position="$4 $5"/>
					<draw:handle draw:handle-position="$6 $7"/>
				</draw:enhanced-geometry>
            		</draw:custom-shape>
		</xsl:when>
		
      <!-- Bent Arrow (Added by A.Mathi as on 23/07/2007) -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='bentArrow') or
                $enhancePath='M f40 f47 L f40 f73 A f60 f60 f4 f5 L f65 f70 L f65 f40 L f46 f61 L f65 f76 L f65 f74 L f75 f74 A f71 f71 f6 f12 L f62 f47 Z N '">
        <!-- warn if bent Arrow -->
        <xsl:message terminate="no">translation.oox2odf.shapesTypeBentArrow</xsl:message>
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
			<xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name ="grID" select ="$GraphicId" />
            <xsl:with-param name ="prID" select ="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!-- End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering -->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 813816 868680" draw:extrusion-allowed="true" 
            draw:text-areas="0 0 813816 868680" draw:glue-points="610362 0 610362 406908 101727 868680 813816 203454" 
            draw:type="mso-spt100" 
            draw:enhanced-path="M 0 868680 L 0 457772 W 0 101727 712090 813817 0 457772 356046 101727 L 610362 101727 L 610362 0 L 813816 203454 L 610362 406908 L 610362 305181 L 356045 305181 A 203454 305181 508636 610363 356045 305181 203454 457772 L 203454 868680 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- U-Turn Arrow (Added by A.Mathi as on 23/07/2007) -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='uturnArrow') or
                $enhancePath = 'M f43 f50 L f43 f67 A f67 f67 f5 f6 L f86 f43 A f67 f67 f7 f6 L f82 f72 L f49 f72 L f73 f62 L f78 f72 L f83 f72 L f83 f84 A f79 f79 f12 f13 L f84 f68 A f79 f79 f7 f13 L f68 f50 Z N '">        
        <xsl:message terminate="no">translation.oox2odf.shapesTypeUTurnArrow</xsl:message>
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
			<xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name ="grID" select ="$GraphicId" />
            <xsl:with-param name ="prID" select ="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!-- End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering -->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 886968 877824" 
            draw:extrusion-allowed="true" draw:text-areas="0 0 886968 877824" 
            draw:glue-points="448056 438912 667512 658368 886968 438912 388620 0 109728 877824" 
            draw:type="mso-spt100" draw:enhanced-path="M 0 877824 L 0 384048 W 0 0 768096 768096 0 384048 384049 0 L 393192 0 W 9144 0 777240 768096 393192 0 777240 384049 L 777240 438912 L 886968 438912 L 667512 658368 L 448056 438912 L 557784 438912 L 557784 384048 A 228600 219456 557784 548640 557784 384048 393192 219456 L 384048 219456 A 219456 219456 548640 548640 384048 219456 219456 384048 L 219456 877824 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
		<!-- Quad Arrow -->
		<xsl:when test ="(p:spPr/a:prstGeom/@prst='quadArrow') or
              $enhancePath='M f23 f39 L f52 f56 L f52 f54 L f57 f54 L f57 f52 L f58 f52 L f40 f23 L f59 f52 L f60 f52 L f60 f54 L f61 f54 L f61 f56 L f26 f39 L f61 f62 L f61 f55 L f60 f55 L f60 f63 L f59 f63 L f40 f27 L f58 f63 L f57 f63 L f57 f55 L f52 f55 L f52 f62 Z N ' or 
                          $enhancePath='M f5 f7 L f14 f26 L f14 f15 L f15 f15 L f15 f14 L f26 f14 L f7 f5 L f27 f14 L f16 f14 L f16 f15 L f17 f15 L f17 f26 L f6 f7 L f17 f27 L f17 f16 L f16 f16 L f16 f17 L f27 f17 L f7 f6 L f26 f17 L f15 f17 L f15 f16 L f14 f16 L f14 f27 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering -->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
					<!-- End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering -->
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600"
										draw:text-areas="0 0 21600 21600"
										draw:type="quad-arrow"
										draw:modifiers="6500 8600 4300"
										draw:enhanced-path="M 0 10800 L ?f0 ?f1 ?f0 ?f2 ?f2 ?f2 ?f2 ?f0 ?f1 ?f0 10800 0 ?f3 ?f0 ?f4 ?f0 ?f4 ?f2 ?f5 ?f2 ?f5 ?f1 21600 10800 ?f5 ?f3 ?f5 ?f4 ?f4 ?f4 ?f4 ?f5 ?f3 ?f5 10800 21600 ?f1 ?f5 ?f2 ?f5 ?f2 ?f4 ?f0 ?f4 ?f0 ?f3 Z N">
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="$2 "/>
					<draw:equation draw:name="f1" draw:formula="$0 "/>
					<draw:equation draw:name="f2" draw:formula="$1 "/>
					<draw:equation draw:name="f3" draw:formula="21600-$0 "/>
					<draw:equation draw:name="f4" draw:formula="21600-$1 "/>
					<draw:equation draw:name="f5" draw:formula="21600-$2 "/>
					<draw:handle draw:handle-position="$1 $2" draw:handle-range-x-minimum="$0" draw:handle-range-x-maximum="10800" draw:handle-range-y-minimum="0" draw:handle-range-y-maximum="$0"/>
					<draw:handle draw:handle-position="$0 top" draw:handle-range-x-minimum="$2" draw:handle-range-x-maximum="$1"/>
				</draw:enhanced-geometry>
           		</draw:custom-shape>
		</xsl:when>
		<!-- Block Arc -->
		<xsl:when test ="(p:spPr/a:prstGeom/@prst='blockArc') or
      $enhancePath='M f222 f223 A f51 f52 f48 f74 L f224 f225 A f77 f78 f49 f79 Z N ' or 
                          $enhancePath='M f155 f156 A f25 f25 f119 f137 L f153 f154 A f34 f34 f117 f140 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering -->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
					<!-- End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering -->
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600"
										draw:type="block-arc"
										draw:modifiers="180 5400"
										draw:enhanced-path="B 0 0 21600 21600 ?f4 ?f3 ?f2 ?f3 W ?f5 ?f5 ?f6 ?f6 ?f2 ?f3 ?f4 ?f3 Z N">
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="10800*cos($0 *(pi/180))"/>
					<draw:equation draw:name="f1" draw:formula="10800*sin($0 *(pi/180))"/>
					<draw:equation draw:name="f2" draw:formula="?f0 +10800"/>
					<draw:equation draw:name="f3" draw:formula="?f1 +10800"/>
					<draw:equation draw:name="f4" draw:formula="21600-?f2 "/>
					<draw:equation draw:name="f5" draw:formula="10800-$1 "/>
					<draw:equation draw:name="f6" draw:formula="10800+$1 "/>
					<draw:equation draw:name="f7" draw:formula="?f5 *cos($0 *(pi/180))"/>
					<draw:equation draw:name="f8" draw:formula="?f5 *sin($0 *(pi/180))"/>
					<draw:handle draw:handle-position="$1 $0" draw:handle-polar="10800 10800" draw:handle-radius-range-minimum="0" draw:handle-radius-range-maximum="10800"/>
				</draw:enhanced-geometry>
         		</draw:custom-shape>
		</xsl:when>
		<!-- Notched Right Arrow -->
	<xsl:when test ="(p:spPr/a:prstGeom/@prst='notchedRightArrow') or
              $enhancePath = 'M f32 f52 L f55 f52 L f55 f32 L f38 f49 L f55 f39 L f55 f53 L f32 f53 L f57 f49 Z N ' or
                           $enhancePath ='M f4 f12 L f11 f12 L f11 f4 L f5 f6 L f11 f5 L f11 f13 L f4 f13 L f23 f6 L f4 f12 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering -->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
					<!-- End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering -->
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600"
										draw:text-areas="0 0 21600 21600"
										draw:type="notched-right-arrow"
										draw:modifiers="16200 5400"
	                                    draw:enhanced-path="M 0 ?f1 L ?f0 ?f1 ?f0 0 21600 10800 ?f0 21600 ?f0 ?f2 0 ?f2 ?f5 10800 0 ?f1 Z N">
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="$0 "/>
					<draw:equation draw:name="f1" draw:formula="$1 "/>
					<draw:equation draw:name="f2" draw:formula="21600-$1 "/>
					<draw:equation draw:name="f3" draw:formula="21600-$0 "/>
					<draw:equation draw:name="f4" draw:formula="10800-$1 "/>
					<draw:equation draw:name="f5" draw:formula="?f3 *?f4 /10800"/>
					<draw:handle draw:handle-position="$0 $1" draw:handle-range-x-minimum="0" draw:handle-range-x-maximum="21600" draw:handle-range-y-minimum="0" draw:handle-range-y-maximum="10800"/>
				</draw:enhanced-geometry>
             		</draw:custom-shape>
		</xsl:when>
		<!-- Pentagon -->
		<xsl:when test ="(p:spPr/a:prstGeom/@prst='homePlate') or 
              $enhancePath ='M f3 f3 L f11 f3 L f4 f7 L f11 f4 L f3 f4 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering -->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
					<!-- End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering -->
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600"
										draw:text-areas="0 0 21600 21600"
										draw:type="pentagon-right"
										draw:modifiers="16200"
										draw:enhanced-path="M 0 0 L ?f0 0 21600 10800 ?f0 21600 0 21600 Z N">
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="$0 "/>
					<draw:handle draw:handle-position="$0 top" draw:handle-range-x-minimum="0" draw:handle-range-x-maximum="21600"/>
				</draw:enhanced-geometry>
           		</draw:custom-shape>
		</xsl:when>
		<!-- Chevron -->
		<xsl:when test ="(p:spPr/a:prstGeom/@prst='chevron') or $enhancePath ='M f3 f3 L f11 f3 L f4 f7 L f11 f4 L f3 f4 L f18 f7 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering -->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
					<!-- End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering -->
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600"
										draw:text-areas="0 0 21600 21600"
										draw:type="chevron"
										draw:modifiers="16200"
										draw:enhanced-path="M 0 0 L ?f0 0 21600 10800 ?f0 21600 0 21600 ?f1 10800 Z N">
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="$0 "/>
					<draw:equation draw:name="f1" draw:formula="21600-?f0 "/>
					<draw:handle draw:handle-position="$0 top" draw:handle-range-x-minimum="0" draw:handle-range-x-maximum="21600"/>
				</draw:enhanced-geometry>
            		</draw:custom-shape>
		</xsl:when>

		<!--Equation Shapes-->
		<!--Equal-->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='mathEqual' or 
              $enhancePath ='M f58 f64 L f59 f64 L f59 f60 L f58 f60 Z N M f58 f61 L f59 f61 L f59 f65 L f58 f65 Z N ' or
      $enhancePath ='M f5 f6 L f7 f6 L f7 f8 L f5 f8 Z N M f5 f9 L f7 f9 L f7 f10 L f5 f10 Z N '">
			<draw:custom-shape draw:layer="layout">
				<xsl:call-template name="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering -->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 1295400 990600" draw:extrusion-allowed="true"
										draw:text-areas="171705 204064 1123695 786536"
										draw:glue-points="1123695 320558 1123695 670042 647700 786536 171705 320558 171705 670042 647700 204064"
										draw:enhanced-path="M 171705 204064 L 1123695 204064 L 1123695 437053 L 171705 437053 Z M 171705 553547 L 1123695 553547 L 1123695 786536 L 171705 786536 Z N">
					<xsl:if test="p:spPr/a:prstGeom/@prst='mathEqual'">
						<xsl:attribute name ="draw:type">
							<xsl:value-of select="'mathequal'"/>
						</xsl:attribute>
					</xsl:if>
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
            		</draw:custom-shape>
		</xsl:when>
		<!--Not Equal-->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='mathNotEqual' or 
              $enhancePath = 'M f67 f87 L f143 f87 L f158 f125 L f150 f121 L f151 f87 L f68 f87 L f68 f82 L f152 f82 L f153 f83 L f68 f83 L f68 f88 L f154 f88 L f162 f135 L f159 f126 L f144 f88 L f67 f88 L f67 f83 L f145 f83 L f146 f82 L f67 f82 Z N ' or
                           $enhancePath = 'M f7 f8 L f9 f8 L f10 f5 L f11 f12 L f13 f8 L f14 f8 L f14 f15 L f16 f15 L f17 f18 L f14 f18 L f14 f19 L f20 f19 L f21 f6 L f22 f23 L f24 f19 L f7 f19 L f7 f18 L f25 f18 L f26 f15 L f7 f15 Z N '">
			<draw:custom-shape draw:layer="layout">
				<xsl:call-template name="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering -->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 1371600 1066800" draw:extrusion-allowed="true"
										draw:text-areas="181806 219761 1189794 847039"
										draw:glue-points="1189794 345216 1189794 721583 507275 1023891 181806 345216 181806 721583 864324 42908"
										draw:enhanced-path="M 181806 219761 L 666448 219761 L 746435 0 L 982214 85817 L 933462 219761 L 1189794 219761 L 1189794 470672 L 842138 470672 L 796476 596128 L 1189794 596128 L 1189794 847039 L 705152 847039 L 625165 1066800 L 389386 980983 L 438138 847039 L 181806 847039 L 181806 596128 L 529462 596128 L 575124 470672 L 181806 470672 Z N">
					<xsl:if test="p:spPr/a:prstGeom/@prst='mathNotEqual'">
						<xsl:attribute name ="draw:type">
							<xsl:value-of select="'mathnotequal'"/>
						</xsl:attribute>
					</xsl:if>
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
             		</draw:custom-shape>
		</xsl:when>
		<!--Plus-->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='mathPlus' or 
              $enhancePath = 'M f59 f63 L f65 f63 L f65 f61 L f66 f61 L f66 f63 L f60 f63 L f60 f64 L f66 f64 L f66 f62 L f65 f62 L f65 f64 L f59 f64 Z N ' or
                           $enhancePath ='M f5 f6 L f7 f6 L f7 f8 L f9 f8 L f9 f6 L f10 f6 L f10 f11 L f9 f11 L f9 f12 L f7 f12 L f7 f11 L f5 f11 Z N '">
			<draw:custom-shape draw:layer="layout">
				<xsl:call-template name="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering -->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 1524000 1371600" draw:extrusion-allowed="true"
										draw:text-areas="202006 524500 1321994 847100"
										draw:glue-points="1321994 685800 762000 1189794 202006 685800 762000 181806"
										draw:enhanced-path="M 202006 524500 L 600700 524500 L 600700 181806 L 923300 181806 L 923300 524500 L 1321994 524500 L 1321994 847100 L 923300 847100 L 923300 1189794 L 600700 1189794 L 600700 847100 L 202006 847100 Z N">
					<xsl:if test="p:spPr/a:prstGeom/@prst='mathPlus'">
						<xsl:attribute name ="draw:type">
							<xsl:value-of select="'mathplus'"/>
						</xsl:attribute>
					</xsl:if>
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
             		</draw:custom-shape>
		</xsl:when>
		<!--Minus-->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='mathMinus' or 
              $enhancePath = 'M f52 f53 L f54 f53 L f54 f55 L f52 f55 Z N ' or
                            $enhancePath ='M f5 f6 L f7 f6 L f7 f8 L f5 f8 Z N '">
			<draw:custom-shape draw:layer="layout">
				<xsl:call-template name="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering -->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 1371600 1219200" draw:extrusion-allowed="true"
										draw:text-areas="181806 466222 1189794 752978"
										draw:glue-points="1189794 609600 685800 752978 181806 609600 685800 466222"
										draw:enhanced-path="M 181806 466222 L 1189794 466222 L 1189794 752978 L 181806 752978 Z N">
					<xsl:if test="p:spPr/a:prstGeom/@prst='mathMinus'">
						<xsl:attribute name ="draw:type">
							<xsl:value-of select="'mathminus'"/>
						</xsl:attribute>
					</xsl:if>
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
           		</draw:custom-shape>
		</xsl:when>
		<!--Multiply-->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='mathMultiply' or 
              $enhancePath = 'M f112 f114 L f115 f113 L f56 f128 L f122 f113 L f120 f114 L f129 f57 L f120 f123 L f122 f121 L f56 f131 L f115 f121 L f112 f123 L f130 f57 Z N ' or
      $enhancePath ='M f5 f6 L f7 f8 L f9 f10 L f11 f8 L f12 f6 L f13 f14 L f12 f15 L f11 f16 L f9 f17 L f7 f16 L f5 f15 L f18 f14 Z N '">
			<draw:custom-shape draw:layer="layout">
				<xsl:call-template name="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering -->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 1676400 1600200"
										draw:extrusion-allowed="true"
										draw:text-areas="272693 248204 1403707 1351996"
										draw:glue-points="402629 384328 1273771 384328 1273771 1215872 402629 1215872"
										draw:enhanced-path="M 272693 520452 L 532566 248204 L 838200 539946 L 1143834 248204 L 1403707 520452 L 1110742 800100 L 1403707 1079748 L 1143834 1351996 L 838200 1060254 L 532566 1351996 L 272693 1079748 L 565658 800100 Z N">
					<xsl:if test="p:spPr/a:prstGeom/@prst='mathMultiply'">
						<xsl:attribute name ="draw:type">
							<xsl:value-of select="'mathmultiply'"/>
						</xsl:attribute>
					</xsl:if>
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
            		</draw:custom-shape>
		</xsl:when>
		<!--Division-->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='mathDivide' or 
              $enhancePath = 'M f63 f73 A f64 f64 f6 f3 Z N M f63 f74 A f64 f64 f5 f3 Z N M f67 f68 L f69 f68 L f69 f70 L f67 f70 Z N ' or
                           $enhancePath ='M f5 f6 C f7 f6 f8 f9 f8 f10 C f8 f11 f12 f13 f5 f13 C f14 f13 f15 f16 f15 f10 C f15 f17 f18 f6 f5 f6 Z N M f5 f19 C f14 f19 f15 f20 f15 f21 C f15 f22 f18 f23 f5 f23 C f7 f23 f8 f24 f8 f21 C f8 f25 f12 f19 f5 f19 Z N M f26 f27 L f28 f27 L f28 f29 L f26 f29 L f26 f27 Z N '">
			<draw:custom-shape draw:layer="layout">
				<xsl:call-template name="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering -->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 3200400 1524000"
										draw:extrusion-allowed="true"
										draw:text-areas="0 0 3200400 1524000"
										draw:glue-points="1600200 179679 1779422 358901 1600200 538123 1420978 358901 1600200 179679 1600200 1344321 1420978 1165099 1600200 985877 1779422 1165099 1600200 1344321 424213 582778 2776186 582778 2776186 941222 424213 941222 424213 582778"
										draw:enhanced-path="M 1600200 179679 C 1699182 179679 1779422 259920 1779422 358901 C 1779422 457883 1699181 538123 1600200 538123 C 1501218 538123 1420978 457882 1420978 358901 C 1420978 259919 1501219 179679 1600200 179679 Z M 1600200 1344321 C 1501218 1344321 1420978 1264080 1420978 1165099 C 1420978 1066117 1501219 985877 1600200 985877 C 1699182 985877 1779422 1066118 1779422 1165099 C 1779422 1264081 1699181 1344321 1600200 1344321 Z M 424213 582778 L 2776187 582778 L 2776187 941222 L 424213 941222 L 424213 582778 Z N">
					<xsl:if test="p:spPr/a:prstGeom/@prst='mathDivide'">
						<xsl:attribute name ="draw:type">
							<xsl:value-of select="'mathdivide'"/>
						</xsl:attribute>
					</xsl:if>
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
            		</draw:custom-shape>
		</xsl:when>
      <!-- Connectors -->
      <!-- Line -->
      <xsl:when test ="p:spPr/a:prstGeom/@prst = 'line'">
        <draw:line draw:layer="layout">
          <xsl:call-template name ="DrawLine">
                <!--added by chhavi:for ODF1.1 conformance-->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
          </xsl:call-template>
          <xsl:copy-of select="$varHyperLinksForShapes" />
        </draw:line>
      </xsl:when>
      <!-- Straight Connector-->
      <xsl:when test ="p:spPr/a:prstGeom/@prst[contains(., 'straightConnector')]">
        <draw:line draw:layer="layout">
          <xsl:call-template name ="DrawLine">
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
          </xsl:call-template>
          <xsl:copy-of select="$varHyperLinksForShapes" />
        </draw:line >
      </xsl:when>
      <!-- Elbow Connector-->
      <xsl:when test ="p:spPr/a:prstGeom/@prst[contains(., 'bentConnector')]">
        <draw:connector draw:layer="layout">
          <xsl:call-template name ="DrawLine">
                <!--added by chhavi:for ODF1.1 conformance-->
                <xsl:with-param name ="layId" select="$layId"/>
                <xsl:with-param name="varShapeName" select="'connector'"/>
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
          </xsl:call-template>

              <xsl:if test="exsl:node-set($varHyperLinksForConnectors)//presentation:event-listener">
          <xsl:copy-of select="$varHyperLinksForConnectors" />
              </xsl:if>
        </draw:connector >
      </xsl:when>
      <!--Curved Connector-->
      <xsl:when test ="p:spPr/a:prstGeom/@prst[contains(., 'curvedConnector')]">
        <draw:connector draw:layer="layout" draw:type="curve">
          <xsl:call-template name ="DrawLine">
                <xsl:with-param name ="layId" select="$layId"/>
                <xsl:with-param name="varShapeName" select="'connector'"/>
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
          </xsl:call-template>
              <xsl:if test="exsl:node-set($varHyperLinksForConnectors)//presentation:event-listener">
          <xsl:copy-of select="$varHyperLinksForConnectors" />
              </xsl:if>
        </draw:connector >
      </xsl:when>
      <!-- Custom shapes: -->
      <!-- Rounded  Rectangle -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='roundRect') or
                $enhancePath='M f30 f29 A f39 f40 f73 f56 L f29 f36 A f40 f57 f82 f60 L f37 f31 A f61 f62 f83 f78 L f32 f30 A f67 f39 f79 f80 Z N ' or
                          $enhancePath='M f30 f29 A f39 f40 f73 f56 L f29 f36 A f40 f57 f82 f60 L f37 f31 A f61 f62 f83 f78 L f32 f30 A f67 f39 f79 f80 Z N ' or
                          $enhancePath='M l x1 A x1 x1 cd2 cd4 L x2 t A x1 x1 3cd4 cd4 L r y2 A x1 x1 0 cd4 L x1 b A x1 x1 cd4 cd4 Z N ' or
                         $enhancePath='M f38 f37 A f47 f48 f81 f64 L f37 f44 A f48 f65 f90 f68 L f45 f39 A f69 f70 f91 f86 L f40 f38 A f75 f47 f87 f88 Z N '">
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter inserted by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600"
            draw:path-stretchpoint-x="10800" draw:path-stretchpoint-y="10800"
            draw:text-areas="?f3 ?f4 ?f5 ?f6" draw:type="round-rectangle" draw:modifiers="3600"
            draw:enhanced-path="M ?f7 0 X 0 ?f8 L 0 ?f9 Y ?f7 21600 L ?f10 21600 X 21600 ?f9 L 21600 ?f8 Y ?f10 0 Z N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="45"/>
            <draw:equation draw:name="f1" draw:formula="$0 *sin(?f0 *(pi/180))"/>
            <draw:equation draw:name="f2" draw:formula="?f1 *3163/7636"/>
            <draw:equation draw:name="f3" draw:formula="left+?f2 "/>
            <draw:equation draw:name="f4" draw:formula="top+?f2 "/>
            <draw:equation draw:name="f5" draw:formula="right-?f2 "/>
            <draw:equation draw:name="f6" draw:formula="bottom-?f2 "/>
            <draw:equation draw:name="f7" draw:formula="left+$0 "/>
            <draw:equation draw:name="f8" draw:formula="top+$0 "/>
            <draw:equation draw:name="f9" draw:formula="bottom-$0 "/>
            <draw:equation draw:name="f10" draw:formula="right-$0 "/>
            <draw:handle draw:handle-position="$0 top"
                   draw:handle-switched="true"
                   draw:handle-range-x-minimum="0"
                   draw:handle-range-x-maximum="10800"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- Snip Single Corner Rectangle -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='snip1Rect') or 
                $enhancePath='M f17 f17 L f30 f17 L f21 f27 L f21 f20 L f17 f20 Z N ' or
                          $enhancePath='M f7 f5 L f6 f5 L f6 f6 L f5 f6 L f5 f7 L f7 f5 Z N '">
        <!-- warn if Snip Single Corner Rectangle-->
        <xsl:message terminate="no">translation.oox2odf.shapesTypeSnipSingleCornerRectangle</xsl:message>
        <draw:custom-shape draw:layer="layout" >
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter inserted by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
						draw:glue-points="10800 0 0 10800 10800 21600 21600 10800" 
						draw:text-areas="0 4300 21600 21600" 
						draw:mirror-horizontal="true" draw:type="flowchart-card" 
						draw:enhanced-path="M 4300 0 L 21600 0 21600 21600 0 21600 0 4300 4300 0 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
       </draw:custom-shape> 
      </xsl:when>

		<!-- Snip Same Side Corner Rectangle -->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='snip2SameRect' or 
              $enhancePath='M f35 f20 L f40 f20 L f23 f35 L f23 f41 L f42 f24 L f36 f24 L f20 f41 L f20 f35 Z N ' or 
              $enhancePath= 'M f8 f5 L f9 f5 L f6 f8 L f6 f7 L f6 f7 L f5 f7 L f5 f7 L f5 f8 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering -->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 2362200 1066800"
										draw:extrusion-allowed="true"
										draw:text-areas="88902 88902 2273298 1066799"
										draw:glue-points="2362200 533400 1181100 1066800 0 533400 1181100 0"
										draw:enhanced-path="M 177804 0 L 2184396 0 L 2362200 177804 L 2362200 1066800 L 2362200 1066800 L 0 1066800 L 0 1066800 L 0 177804 Z N">
					<xsl:if test="p:spPr/a:prstGeom/@prst='snip2SameRect'">
						<xsl:attribute name ="draw:type">
							<xsl:value-of select="'snip2samerect'"/>
						</xsl:attribute>
					</xsl:if>
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
           		</draw:custom-shape>
		</xsl:when>
		<!-- Snip Diagonal Corner Rectangle -->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='snip2DiagRect' or 
              $enhancePath='M f35 f20 L f38 f20 L f23 f36 L f23 f39 L f40 f24 L f36 f24 L f20 f41 L f20 f35 Z N ' or 
              $enhancePath ='M f5 f5 L f8 f5 L f6 f9 L f6 f7 L f6 f7 L f9 f7 L f5 f10 L f5 f5 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering -->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 2590800 1371600" draw:extrusion-allowed="true"
										draw:text-areas="114302 114302 2476498 1257298"
										draw:glue-points="2590800 685800 1295400 1371600 0 685800 1295400 0"
										draw:enhanced-path="M 0 0 L 2362195 0 L 2590800 228605 L 2590800 1371600 L 2590800 1371600 L 228605 1371600 L 0 1142995 L 0 0 Z N">
					<xsl:if test="p:spPr/a:prstGeom/@prst='snip2DiagRect'">
						<xsl:attribute name ="draw:type">
							<xsl:value-of select="'snip2diagrect'"/>
						</xsl:attribute>
					</xsl:if>
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
            		</draw:custom-shape>
		</xsl:when>
		<!-- Snip and Round Single Corner Rectangle -->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='snipRoundRect' or 
              $enhancePath='M f34 f22 L f38 f22 L f26 f35 L f26 f25 L f22 f25 L f22 f34 A f34 f34 f2 f3 Z N ' or 
              $enhancePath='M f10 f6 L f11 f6 L f7 f10 L f7 f8 L f6 f8 L f6 f10 L f69 f70 A f23 f23 f51 f61 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name ="grID" select ="$GraphicId" />
					<xsl:with-param name ="prID" select ="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering -->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 2514600 1295400" draw:extrusion-allowed="true"
										draw:text-areas="63236 63236 2406647 1295400"
										draw:glue-points="2514600 647700 1257300 1295400 0 647700 1257300 0"
										draw:enhanced-path="M 215904 0 L 2298696 0 L 2514600 215904 L 2514600 1295400 L 0 1295400 L 0 215904 W 0 0 431808 431808 0 215904 215904 0 Z N">
					<xsl:if test="p:spPr/a:prstGeom/@prst='snipRoundRect'">
						<xsl:attribute name ="draw:type">
							<xsl:value-of select="'sniproundrect'"/>
						</xsl:attribute>
					</xsl:if>
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
         		</draw:custom-shape>
		</xsl:when>
		<!-- Round Single Corner Rectangle -->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='round1Rect' or 
              $enhancePath='M f19 f19 L f31 f19 A f29 f29 f2 f1 L f23 f22 L f19 f22 Z N ' or 
              $enhancePath= 'M f6 f6 L f10 f6 L f73 f74 A f25 f26 f55 f65 L f7 f8 L f6 f8 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
					<!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 2438400 1066800" draw:extrusion-allowed="true"
										draw:text-areas="0 0 2386323 1066800"
										draw:glue-points="1219200 0 0 533400 1219200 1066800 2438400 533400" 
										draw:enhanced-path="M 0 0 L 2260596 0 W 2082792 0 2438400 355608 2260596 0 2438400 177804 L 2438400 1066800 L 0 1066800 Z N">
					<xsl:if test="p:spPr/a:prstGeom/@prst='round1Rect'">
						<xsl:attribute name="draw:type">
							<xsl:value-of select="'round1rect'"/>
						</xsl:attribute>
					</xsl:if>
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
           		</draw:custom-shape>
		</xsl:when>
		<!-- Round Same Side Corner Rectangle -->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='round2SameRect' or 
              $enhancePath='M f38 f23 L f42 f23 A f38 f38 f4 f3 L f26 f43 A f39 f39 f8 f3 L f39 f27 A f39 f39 f3 f3 L f23 f38 A f38 f38 f2 f3 Z N ' or 
              $enhancePath='M f10 f6 L f11 f6 L f111 f112 A f26 f27 f75 f93 L f7 f8 L f6 f8 L f6 f10 L f113 f114 A f27 f27 f77 f96 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
					<!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 2362200 1371600" draw:extrusion-allowed="true"
										draw:text-areas="66956 66956 2295244 1371600"
										draw:glue-points="2362200 685800 1181100 1371600 0 685800 1181100 0"
										draw:enhanced-path="M 228605 0 L 2133595 0 W 1904990 0 2362200 457210 2133595 0 2362200 228605 L 2362200 1371600 L 0 1371600 L 0 228605 W 0 0 457210 457210 0 228605 228605 0 Z N">
					<xsl:if test="p:spPr/a:prstGeom/@prst='round2SameRect'">
						<xsl:attribute name="draw:type">
							<xsl:value-of select="'round2samerect'"/>
						</xsl:attribute>
					</xsl:if>
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
          		</draw:custom-shape>
		</xsl:when>
		<!-- Round Diagonal Corner Rectangle -->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='round2DiagRect' or 
              $enhancePath='M f37 f23 L f41 f23 A f38 f38 f4 f3 L f26 f42 A f37 f37 f8 f3 L f38 f27 A f38 f38 f3 f3 L f23 f37 A f37 f37 f2 f3 Z N ' or 
              $enhancePath= 'M f10 f6 L f7 f6 L f7 f11 L f119 f120 A f29 f30 f83 f101 L f6 f8 L f6 f10 L f121 f122 A f31 f31 f85 f104 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
					<!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 2286000 1371600" draw:extrusion-allowed="true"
										draw:text-areas="66956 66956 2219044 1304644"
										draw:glue-points="2286000 685800 1143000 1371600 0 685800 1143000 0"
										draw:enhanced-path="M 228605 0 L 2286000 0 L 2286000 1142995 W 1828790 914390 2286000 1371600 2286000 1142995 2057395 1371600 L 0 1371600 L 0 228605 W 0 0 457210 457210 0 228605 228605 0 Z N">
					<xsl:if test="p:spPr/a:prstGeom/@prst='round2DiagRect'">
						<xsl:attribute name="draw:type">
							<xsl:value-of select="'round2diagrect'"/>
						</xsl:attribute>
					</xsl:if>
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
          		</draw:custom-shape>
		</xsl:when>
		<!-- Explosion 2 -->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='irregularSeal2'">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600"
										draw:glue-points="9722 1887 0 12875 11614 18844 21600 6646"
                                        draw:text-areas="5400 6570 14160 15290"
										draw:type="bang"
                                        draw:enhanced-path="M 11464 4340 L 9722 1887 8548 6383 4503 3626 5373 7816 1174 8270 3934 11592 0 12875 3329 15372 1283 17824 4804 18239 4918 21600 7525 18125 8698 19712 9871 17371 11614 18844 12178 15937 14943 17371 14640 14348 18878 15632 16382 12311 18270 11292 16986 9404 21600 6646 16382 6533 18005 3172 14524 5778 14789 0 11464 4340 Z N">
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
            		</draw:custom-shape>
		</xsl:when>

		<!-- Heptagon -->
		<xsl:when test ="(p:spPr/a:prstGeom/@prst='heptagon') or
              $enhancePath='M f70 f71 L f67 f68 L f43 f28 L f69 f68 L f72 f71 L f73 f74 L f75 f74 Z N ' or 
              $enhancePath='M f6 f7 L f8 f9 L f10 f5 L f11 f9 L f12 f7 L f13 f14 L f15 f14 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 1828800 1600200"
										draw:extrusion-allowed="true"
										draw:text-areas="181107 316941 1647693 1283259"
                                        draw:glue-points="1647693 316941 1828805 1029099 1321344 1600208 507456 1600208 -5 1029099 181107 316941 914400 0"
									    draw:enhanced-path="M -5 1029099 L 181107 316941 L 914400 0 L 1647693 316941 L 1828805 1029099 L 1321344 1600208 L 507456 1600208 Z N">
					<xsl:if test="p:spPr/a:prstGeom/@prst='heptagon'">
						<xsl:attribute name="draw:type">
							<xsl:value-of select="'HEPTAGON'"/>
						</xsl:attribute>
					</xsl:if>
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
           		</draw:custom-shape>
		</xsl:when>
		<!-- Decagon -->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='decagon' or
              $enhancePath ='M f5 f7 L f8 f9 L f10 f11 L f12 f11 L f13 f9 L f6 f7 L f13 f14 L f12 f15 L f10 f15 L f8 f14 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 2057400 1752600" draw:extrusion-allowed="true"
										draw:text-areas="196464 334718 1860936 1417882"
                                        draw:glue-points="1860936 334718 2057400 876300 1860936 1417882 1346585 1752598 710815 1752598 196464 1417882 0 876300 196464 334718 710815 2 1346585 2"
                                        draw:enhanced-path="M 0 876300 L 196464 334718 L 710815 2 L 1346585 2 L 1860936 334718 L 2057400 876300 L 1860936 1417882 L 1346585 1752598 L 710815 1752598 L 196464 1417882 Z N">
					<xsl:if test="p:spPr/a:prstGeom/@prst='decagon'">
						<xsl:attribute name="draw:type">
							<xsl:value-of select="'DECAGON'"/>
						</xsl:attribute>
					</xsl:if>
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
           		</draw:custom-shape>
		</xsl:when>
		<!-- Dodecagon -->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='dodecagon' or
              $enhancePath ='M f5 f8 L f9 f10 L f11 f5 L f12 f5 L f13 f10 L f6 f8 L f6 f14 L f13 f15 L f12 f7 L f11 f7 L f9 f15 L f5 f14 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 1905000 1828800" draw:extrusion-allowed="true"
										draw:text-areas="255235 245025 1649765 1583775"
									    draw:glue-points="1649765 245025 1905000 669375 1905000 1159425 1649765 1583775 1207735 1828800 697265 1828800 255235 1583775 0 1159425 0 669375 255235 245025 697265 0 1207735 0"
                                        draw:enhanced-path="M 0 669375 L 255235 245025 L 697265 0 L 1207735 0 L 1649765 245025 L 1905000 669375 L 1905000 1159425 L 1649765 1583775 L 1207735 1828800 L 697265 1828800 L 255235 1583775 L 0 1159425 Z N">
					<xsl:if test="p:spPr/a:prstGeom/@prst='dodecagon'">
						<xsl:attribute name="draw:type">
							<xsl:value-of select="'DODECAGON'"/>
						</xsl:attribute>
					</xsl:if>
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
           		</draw:custom-shape>
		</xsl:when>
		<!-- Pie -->
		<xsl:when test ="(p:spPr/a:prstGeom/@prst='pie') or
              $enhancePath='M f112 f113 A f47 f48 f44 f57 L f52 f53 Z N ' or
                          $enhancePath='M f172 f173 A f26 f26 f141 f155 L f11 f11 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry draw:glue-point-type="segments"
                                  draw:type="mso-spt100"
                                  draw:modifiers="-90 0"
                                  draw:enhanced-path="V 0 0 21600 21600 ?f5 ?f7 ?f1 ?f3 L 10800 10800 Z N">
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="10800*cos($0 *(pi/180))"/>
					<draw:equation draw:name="f1" draw:formula="?f0 +10800"/>
					<draw:equation draw:name="f2" draw:formula="10800*sin($0 *(pi/180))"/>
					<draw:equation draw:name="f3" draw:formula="?f2 +10800"/>
					<draw:equation draw:name="f4" draw:formula="10800*cos($1 *(pi/180))"/>
					<draw:equation draw:name="f5" draw:formula="?f4 +10800"/>
					<draw:equation draw:name="f6" draw:formula="10800*sin($1 *(pi/180))"/>
					<draw:equation draw:name="f7" draw:formula="?f6 +10800"/>
					<draw:handle draw:handle-position="10800 $0" draw:handle-polar="10800 10800" draw:handle-radius-range-minimum="10800" draw:handle-radius-range-maximum="10800"/>
					<draw:handle draw:handle-position="10800 $1" draw:handle-polar="10800 10800" draw:handle-radius-range-minimum="10800" draw:handle-radius-range-maximum="10800"/>
				</draw:enhanced-geometry>
         		</draw:custom-shape>
		</xsl:when>
		<!-- Frame -->
		<xsl:when test ="(p:spPr/a:prstGeom/@prst='frame') or
              $enhancePath='M f17 f17 L f20 f17 L f20 f21 L f17 f21 Z N M f27 f27 L f27 f29 L f28 f29 L f28 f27 Z N ' or
              $enhancePath='M f38 f38 L f41 f38 L f41 f42 L f38 f42 Z N M f37 f37 L f39 f37 L f39 f40 L f37 f40 Z N ' or
                          $enhancePath='M f31 f31 L f35 f31 L f35 f36 L f31 f36 Z N M f30 f30 L f33 f30 L f33 f34 L f30 f34 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!--Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks-->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!--Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600"
										draw:extrusion-origin="0 0"
										draw:extrusion-viewpoint="(0cm 0cm 25cm)"
                                        draw:extrusion-skew="0 0"
										dr3d:projection="perspective"
										draw:extrusion-depth="2.5cm 0"
										draw:text-areas="?f4 ?f6 ?f5 ?f7"
										draw:glue-point-type="segments"
										draw:path-stretchpoint-x="10800"
										draw:path-stretchpoint-y="10800"
										draw:type="frame"
										draw:modifiers="2000"
										draw:enhanced-path="M ?f0 ?f2 L ?f1 ?f2 ?f1 ?f3 ?f0 ?f3 Z M ?f4 ?f6 L ?f5 ?f6 ?f5 ?f7 ?f4 ?f7 Z N">
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="left"/>
					<draw:equation draw:name="f1" draw:formula="right"/>
					<draw:equation draw:name="f2" draw:formula="top"/>
					<draw:equation draw:name="f3" draw:formula="bottom"/>
					<draw:equation draw:name="f4" draw:formula="left+$0"/>
					<draw:equation draw:name="f5" draw:formula="right-$0"/>
					<draw:equation draw:name="f6" draw:formula="top+$0"/>
					<draw:equation draw:name="f7" draw:formula="bottom-$0"/>
					<draw:handle draw:handle-position="left $0" draw:handle-switched="true" draw:handle-range-y-minimum="0" draw:handle-range-y-maximum="10800"/>
				</draw:enhanced-geometry>
            		</draw:custom-shape>
		</xsl:when>
		<!-- Half Frame -->
		<xsl:when test ="(p:spPr/a:prstGeom/@prst='halfFrame') or
              $enhancePath='M f29 f29 L f34 f29 L f55 f45 L f46 f45 L f46 f56 L f29 f35 Z N ' or 
              $enhancePath='M f5 f5 L f6 f5 L f7 f8 L f8 f8 L f8 f7 L f5 f6 Z N '">     
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!--Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks-->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!--Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 1371600 1371600"
										draw:extrusion-allowed="true"
										draw:text-areas="0 0 1371600 1371600"
										draw:glue-points="1143002 228598 228598 1143002 0 685800 685800 0"
										draw:enhanced-path="M 0 0 L 1371600 0 L 914405 457195 L 457195 457195 L 457195 914405 L 0 1371600 Z N">
					<xsl:if test="p:spPr/a:prstGeom/@prst='halfFrame'">
						<xsl:attribute name="draw:type">
							<xsl:value-of select="'HALFFRAME'"/>
						</xsl:attribute>
					</xsl:if>
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
          		</draw:custom-shape>
		</xsl:when>
		<!-- L-Shape -->
		<xsl:when test ="(p:spPr/a:prstGeom/@prst='corner') or
              $enhancePath='M f29 f29 L f45 f29 L f45 f49 L f35 f49 L f35 f34 L f29 f34 Z N ' or 
              $enhancePath= 'M f5 f5 L f7 f5 L f7 f7 L f6 f7 L f6 f6 L f5 f6 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!--Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks-->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!--Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 914400 914400"
							 draw:extrusion-allowed="true"
							 draw:text-areas="0 0 457200 914400"
							 draw:glue-points="914400 685800 457200 914400 0 457200 228600 0"
						     draw:enhanced-path="M 0 0 L 457200 0 L 457200 457200 L 914400 457200 L 914400 914400 L 0 914400 Z N">
					<xsl:if test="p:spPr/a:prstGeom/@prst='corner'">
						<xsl:attribute name="draw:type">
							<xsl:value-of select="'CORNER'"/>
						</xsl:attribute>
					</xsl:if>
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
             		</draw:custom-shape>
		</xsl:when>
		<!-- Diagonal Stripe -->
		<xsl:when test ="(p:spPr/a:prstGeom/@prst='diagStripe') or
              $enhancePath='M f29 f49 L f50 f29 L f35 f29 L f29 f36 Z N ' or 
              $enhancePath='M f5 f8 L f9 f5 L f6 f5 L f5 f7 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!--Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks-->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!--Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 1524000 1219200"
										draw:extrusion-allowed="true"
                                        draw:text-areas="0 0 1142999 914400"
										draw:glue-points="762000 609600 0 914400 381000 304800 1142999 0"
                                        draw:enhanced-path="M 0 609600 L 762000 0 L 1524000 0 L 0 1219200 Z N">
					<xsl:if test="p:spPr/a:prstGeom/@prst='diagStripe'">
						<xsl:attribute name="draw:type">
							<xsl:value-of select="'diagstripe'"/>
						</xsl:attribute>
					</xsl:if>
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
             		</draw:custom-shape>
		</xsl:when>
		<!-- Plaque -->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='plaque' or
                                       $enhancePath ='M f44 f43 A f55 f56 f91 f73 L f43 f51 A f56 f74 f92 f77 L f52 f45 A f78 f79 f100 f95 L f46 f44 A f84 f55 f101 f98 Z N ' or 
              $enhancePath ='M f35 f34 A f46 f47 f81 f63 L f34 f43 A f47 f64 f82 f67 L f44 f36 A f68 f69 f91 f85 L f37 f35 A f74 f46 f92 f88 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!--Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks-->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!--Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600"
										draw:glue-points="10800 0 0 10800 10800 21600 21600 10800"
                                        draw:path-stretchpoint-x="10800" draw:path-stretchpoint-y="10800"
										draw:text-areas="?f12 ?f13 ?f14 ?f15"
                                        draw:type="mso-spt21"
										draw:modifiers="3600"
                                        draw:enhanced-path="M ?f0 0 Y 0 ?f1 L 0 ?f2 X ?f0 21600 L ?f3 21600 Y 21600 ?f2 L 21600 ?f1 X ?f3 0 Z N">
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="left+$0 "/>
					<draw:equation draw:name="f1" draw:formula="top+$0 "/>
					<draw:equation draw:name="f2" draw:formula="bottom-$0 "/>
					<draw:equation draw:name="f3" draw:formula="right-$0 "/>
					<draw:equation draw:name="f4" draw:formula="-(sin(45*(pi/180))*($0 -10800)-cos(45*(pi/180))*(0-10800))+10800"/>
					<draw:equation draw:name="f5" draw:formula="?f4 -10800"/>
					<draw:equation draw:name="f6" draw:formula="-$0 "/>
					<draw:equation draw:name="f7" draw:formula="?f6 -?f5 "/>
					<draw:equation draw:name="f8" draw:formula="left-?f7 "/>
					<draw:equation draw:name="f9" draw:formula="top-?f7 "/>
					<draw:equation draw:name="f10" draw:formula="right+?f7 "/>
					<draw:equation draw:name="f11" draw:formula="bottom+?f7 "/>
					<draw:equation draw:name="f12" draw:formula="left-?f5 "/>
					<draw:equation draw:name="f13" draw:formula="top-?f5 "/>
					<draw:equation draw:name="f14" draw:formula="right+?f5 "/>
					<draw:equation draw:name="f15" draw:formula="bottom+?f5 "/>
					<draw:handle draw:handle-position="$0 top" draw:handle-switched="true" draw:handle-range-x-minimum="0" draw:handle-range-x-maximum="10800"/>
				</draw:enhanced-geometry>
           		</draw:custom-shape>
		</xsl:when>
		<!-- Bevel -->
		<xsl:when test ="(p:spPr/a:prstGeom/@prst='bevel') or
              $enhancePath='S M f52 f52 L f53 f52 L f53 f54 L f52 f54 Z N  S M f32 f32 L f39 f32 L f53 f52 L f52 f52 Z N S M f32 f40 L f52 f54 L f53 f54 L f39 f40 Z N S M f32 f32 L f52 f52 L f52 f54 L f32 f40 Z N S M f39 f32 L f39 f40 L f53 f54 L f53 f52 Z Nf M f32 f32 L f39 f32 L f39 f40 L f32 f40 Z N M f52 f52 L f53 f52 L f53 f54 L f52 f54 Z N M f32 f32 L f52 f52 M f32 f40 L f52 f54 M f39 f32 L f53 f52 M f39 f40 L f53 f54 ' or
                          $enhancePath='M f19 f19 L f20 f19 L f20 f21 L f19 f21 Z N M f19 f19 L f20 f19 L f25 f24 L f24 f24 Z N M f20 f19 L f20 f21 L f25 f26 L f25 f24 Z N M f20 f21 L f19 f21 L f24 f26 L f25 f26 Z N M f19 f21 L f19 f19 L f24 f24 L f24 f26 Z N ' or
               $enhancePath='M f27 f27 L f29 f27 L f29 f30 L f27 f30 Z N M f27 f27 L f29 f27 L f31 f28 L f28 f28 Z N M f29 f27 L f29 f30 L f31 f32 L f31 f28 Z N M f29 f30 L f27 f30 L f28 f32 L f31 f32 Z N M f27 f30 L f27 f27 L f28 f28 L f28 f32 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!--Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks-->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!--Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600"
										draw:path-stretchpoint-x="10800"
										draw:path-stretchpoint-y="10800"
										draw:text-areas="?f0 ?f0 ?f1 ?f2"
										draw:type="quad-bevel"
										draw:modifiers="2700"
										draw:enhanced-path="M 0 0 L 21600 0 21600 21600 0 21600 Z N M 0 0 L 21600 0 ?f1 ?f0 ?f0 ?f0 Z N M 21600 0 L 21600 21600 ?f1 ?f2 ?f1 ?f0 Z N M 21600 21600 L 0 21600 ?f0 ?f2 ?f1 ?f2 Z N M 0 21600 L 0 0 ?f0 ?f0 ?f0 ?f2 Z N">
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="$0 *21599/21600"/>
					<draw:equation draw:name="f1" draw:formula="right-?f0 "/>
					<draw:equation draw:name="f2" draw:formula="bottom-?f0 "/>
					<draw:handle draw:handle-position="$0 top" draw:handle-switched="true" draw:handle-range-x-minimum="0" draw:handle-range-x-maximum="10800"/>
				</draw:enhanced-geometry>
           		</draw:custom-shape>
		</xsl:when>
		<!-- Donut -->
		<xsl:when test ="(p:spPr/a:prstGeom/@prst='donut') or
              $enhancePath='M f32 f50 A f46 f47 f1 f2 A f46 f47 f3 f2 A f46 f47 f8 f2 A f46 f47 f2 f2 Z N M f54 f50 A f57 f58 f1 f10 A f57 f58 f2 f10 A f57 f58 f8 f10 A f57 f58 f3 f10 Z N ' or
                          $enhancePath='M f69 f70 A f8 f8 f40 f44 Z N M f71 f72 A f20 f20 f40 f44 '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!--Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks-->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!--Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600"
										draw:glue-points="10800 0 3160 3160 0 10800 3160 18440 10800 21600 18440 18440 21600 10800 18440 3160"
										draw:text-areas="3200 3200 18400 18400"
										draw:type="ring"
										draw:modifiers="5400"
										draw:enhanced-path="U 10800 10800 10800 10800 0 23592960 Z U 10800 10800 ?f1 ?f1 0 23592960 N">
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="$0 "/>
					<draw:equation draw:name="f1" draw:formula="10800-$0 "/>
					<draw:handle draw:handle-position="$0 10800" draw:handle-range-x-minimum="0" draw:handle-range-x-maximum="10800"/>
				</draw:enhanced-geometry>
            		</draw:custom-shape>
		</xsl:when>
		<!-- Teardrop -->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='teardrop' or 
              $enhancePath ='M f5 f8 C f9 f10 f11 f12 f13 f14 C f15 f16 f17 f18 f19 f18 L f20 f5 C f6 f21 f6 f22 f6 f8 C f6 f23 f24 f25 f26 f27 C f28 f29 f30 f7 f31 f7 C f32 f7 f33 f34 f35 f36 C f37 f38 f39 f40 f41 f42 C f41 f43 f5 f43 f5 f8 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!--Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks-->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!--Extra parameter inserted by Vijayeta,For Bullets and numbering-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 2743200 1600200"
										draw:extrusion-allowed="true"
										draw:text-areas="0 0 2743200 1600200"
										draw:glue-points="0 685800 567077 93422 1143001 2 2285998 0 2286000 685800 1718924 1278180 1142999 1371600 567074 1278179 -1 685798 0 685800"
										draw:enhanced-path="M 0 800100 C 1 515531 259112 252377 680492 108992 C 890259 37613 1128753 2 1371601 2 L 2743199 0 C 2743200 266700 2743200 533400 2743200 800100 C 2743200 1084669 2484089 1347823 2062709 1491210 C 1852942 1562589 1614448 1600200 1371599 1600200 C 1128751 1600200 890256 1562588 680489 1491209 C 259109 1347822 -2 1084668 -1 800098 C -1 800099 0 800099 0 800100 Z N">
					<xsl:if test="p:spPr/a:prstGeom/@prst='teardrop'">
						<xsl:attribute name="draw:type">
							<xsl:value-of select="'TEARDROP'"/>
						</xsl:attribute>
					</xsl:if>
          <xsl:call-template name="tmpFlip"/>
				</draw:enhanced-geometry>
           		</draw:custom-shape>
		</xsl:when>

      <!-- Flow chart shapes -->

      <!-- Flowchart: Process -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartProcess') or
                $enhancePath = 'M f2 f2 L f3 f2 L f3 f3 L f2 f3 Z N ' or 
                           $enhancePath =  'M f5 f5 L f6 f5 L f6 f6 L f5 f6 L f5 f5 Z N '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 0 10800 10800 21600 21600 10800" draw:type="flowchart-process" draw:enhanced-path="M 0 0 L 21600 0 21600 21600 0 21600 0 0 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- Flowchart: Alternate Process -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartAlternateProcess') or
                $enhancePath =  'M f17 f27 A f27 f27 f0 f1 L f29 f17 A f27 f27 f2 f1 L f20 f30 A f27 f27 f6 f1 L f27 f21 A f27 f27 f1 f1 Z N ' or
                           $enhancePath =  'M f6 f11 A f32 f33 f65 f55 L f12 f6 A f38 f32 f66 f58 L f7 f12 A f43 f38 f67 f61 L f11 f7 A f33 f43 f68 f64 Z N '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:path-stretchpoint-x="10800" draw:path-stretchpoint-y="10800" draw:text-areas="?f3 ?f4 ?f5 ?f6" draw:type="round-rectangle" draw:modifiers="3600" draw:enhanced-path="M ?f7 0 X 0 ?f8 L 0 ?f9 Y ?f7 21600 L ?f10 21600 X 21600 ?f9 L 21600 ?f8 Y ?f10 0 Z N">
            <xsl:call-template name="tmpFlip"/>
            <draw:equation draw:name="f0" draw:formula="45"/>
            <draw:equation draw:name="f1" draw:formula="$0 *sin(?f0 *(pi/180))"/>
            <draw:equation draw:name="f2" draw:formula="?f1 *3163/7636"/>
            <draw:equation draw:name="f3" draw:formula="left+?f2 "/>
            <draw:equation draw:name="f4" draw:formula="top+?f2 "/>
            <draw:equation draw:name="f5" draw:formula="right-?f2 "/>
            <draw:equation draw:name="f6" draw:formula="bottom-?f2 "/>
            <draw:equation draw:name="f7" draw:formula="left+$0 "/>
            <draw:equation draw:name="f8" draw:formula="top+$0 "/>
            <draw:equation draw:name="f9" draw:formula="bottom-$0 "/>
            <draw:equation draw:name="f10" draw:formula="right-$0 "/>
            <draw:handle draw:handle-position="$0 top" draw:handle-switched="true" draw:handle-range-x-minimum="0" draw:handle-range-x-maximum="10800"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Decision -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartDecision') or
                $enhancePath = 'M f2 f4 L f4 f2 L f3 f4 L f4 f3 Z N ' or
                           $enhancePath =  'M f5 f7 L f7 f5 L f6 f7 L f7 f6 L f5 f7 Z N '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 0 10800 10800 21600 21600 10800" draw:text-areas="5400 5400 16200 16200" draw:type="flowchart-decision" 
            draw:enhanced-path="M 0 10800 L 10800 0 21600 10800 10800 21600 0 10800 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Data -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartInputOutput') or
                $enhancePath= 'M f5 f6 L f7 f5 L f6 f5 L f8 f6 Z N ' or
                          $enhancePath=  'M f7 f5 L f6 f5 L f8 f6 L f5 f6 L f7 f5 Z N '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>

            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="12960 0 10800 0 2160 10800 8600 21600 10800 21600 19400 10800" draw:text-areas="4230 0 17370 21600" draw:type="flowchart-data" draw:enhanced-path="M 4230 0 L 21600 0 17370 21600 0 21600 4230 0 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Predefined Process-->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartPredefinedProcess') or
                $enhancePath ='S M f5 f5 L f6 f5 L f6 f7 L f5 f7 Z N F M f8 f5 L f8 f7 M f9 f5 L f9 f7 F M f5 f5 L f6 f5 L f6 f7 L f5 f7 Z N ' or
                           $enhancePath = 'M f2 f2 L f3 f2 L f3 f3 L f2 f3 Z N M f4 f2 L f4 f3 M f5 f2 L f5 f3 '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:text-areas="2540 0 19060 21600" draw:type="flowchart-predefined-process" draw:enhanced-path="M 0 0 L 21600 0 21600 21600 0 21600 Z N M 2540 0 L 2540 21600 N M 19060 0 L 19060 21600 N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Internal Storage -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartInternalStorage') or
                $enhancePath ='S M f5 f5 L f6 f5 L f6 f7 L f5 f7 Z N F M f8 f5 L f8 f7 M f5 f9 L f6 f9 F M f5 f5 L f6 f5 L f6 f7 L f5 f7 Z N 'or
                           $enhancePath = 'M f2 f2 L f3 f2 L f3 f3 L f2 f3 Z N M f4 f2 L f4 f3 M f2 f4 L f3 f4 '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:text-areas="4230 4230 21600 21600" draw:type="flowchart-internal-storage" draw:enhanced-path="M 0 0 L 21600 0 21600 21600 0 21600 Z N M 4230 0 L 4230 21600 N M 0 4230 L 21600 4230 N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Document -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartDocument') or
                $enhancePath='M f5 f5 L f6 f5 L f6 f7 C f8 f7 f8 f9 f5 f10 Z N 'or
                          $enhancePath=  'M f5 f5 L f6 f5 L f6 f7 C f8 f9 f10 f11 f12 f6 C f13 f14 f15 f16 f5 f17 Z N '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 0 10800 10800 20320 21600 10800" draw:text-areas="0 0 21600 17360" draw:type="flowchart-document" draw:enhanced-path="M 0 0 L 21600 0 21600 17360 C 13050 17220 13340 20770 5620 21600 2860 21100 1850 20700 0 20120 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Multi document -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartMultidocument') or
                $enhancePath='S M f5 f7 C f8 f9 f8 f10 f11 f10 L f11 f12 L f5 f12 Z N M f13 f12 L f13 f14 L f15 f14 L f15 f16 C f17 f16 f11 f18 f11 f18 L f11 f12 Z N M f19 f14 L f19 f5 L f6 f5 L f6 f20 C f21 f20 f15 f22 f15 f22 L f15 f14 Z N F M f5 f12 L f11 f12 L f11 f10 C f8 f10 f8 f9 f5 f7 Z N M f13 f12 L f13 f14 L f15 f14 L f15 f16 C f17 f16 f11 f18 f11 f18 M f19 f14 L f19 f5 L f6 f5 L f6 f20 C f21 f20 f15 f22 f15 f22 S F M f5 f7 C f8 f9 f8 f10 f11 f10 L f11 f18 C f11 f18 f17 f16 f15 f16 L f15 f22 C f15 f22 f21 f20 f6 f20 L f6 f5 L f19 f5 L f19 f14 L f13 f14 L f13 f12 L f5 f12 Z N ' or
                           $enhancePath='M f5 f7 L f8 f7 L f8 f9 L f10 f9 L f10 f5 L f6 f5 L f6 f11 L f12 f11 L f12 f13 L f14 f13 L f14 f15 C f16 f17 f18 f19 f20 f21 C f22 f23 f24 f25 f5 f26 Z N F M f8 f7 L f14 f7 L f14 f13 F M f10 f9 L f12 f9 L f12 f11 '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 0 10800 10800 19890 21600 10800" draw:text-areas="0 3600 18600 18009" draw:type="flowchart-multidocument" draw:enhanced-path="M 0 3600 L 1500 3600 1500 1800 3000 1800 3000 0 21600 0 21600 14409 20100 14409 20100 16209 18600 16209 18600 18009 C 11610 17893 11472 20839 4833 21528 2450 21113 1591 20781 0 20300 Z N M 1500 3600 F L 18600 3600 18600 16209 N M 3000 1800 F L 20100 1800 20100 14409 N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Terminator -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartTerminator') or
                $enhancePath ='M f7 f5 L f8 f5 A f7 f9 f2 f0 L f7 f6 A f7 f9 f1 f0 Z N ' or
                           $enhancePath ='M f8 f7 A f35 f36 f73 f64 A f20 f21 f65 f66 L f11 f6 A f45 f46 f74 f69 A f26 f27 f70 f71 Z N '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 0 10800 10800 21600 21600 10800" draw:text-areas="1060 3180 20540 18420" draw:type="flowchart-terminator" draw:enhanced-path="M 3470 21600 X 0 10800 3470 0 L 18130 0 X 21600 10800 18130 21600 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Preparation -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartPreparation') or
                $enhancePath ='M f2 f4 L f5 f2 L f6 f2 L f3 f4 L f6 f3 L f5 f3 Z N ' or
                           $enhancePath ='M f7 f5 L f8 f5 L f6 f9 L f8 f6 L f7 f6 L f5 f9 L f7 f5 Z N '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->

                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 0 10800 10800 21600 21600 10800" draw:text-areas="4350 0 17250 21600" draw:type="flowchart-preparation" draw:enhanced-path="M 4350 0 L 17250 0 21600 10800 17250 21600 4350 21600 0 10800 4350 0 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
       </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Manual Input -->
      <xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartManualInput' or
                       $enhancePath='M f5 f7 L f6 f5 L f6 f6 L f5 f6 L f5 f7 Z N '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 2150 0 10800 10800 19890 21600 10800" draw:text-areas="0 4300 21600 21600" draw:type="flowchart-manual-input" draw:enhanced-path="M 0 4300 L 21600 0 21600 21600 0 21600 0 4300 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Manual Operation -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartManualOperation') or
                $enhancePath='M f5 f5 L f6 f5 L f7 f6 L f8 f6 Z N 'or
                          $enhancePath= 'M f5 f5 L f6 f5 L f7 f6 L f8 f6 L f5 f5 Z N '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 2160 10800 10800 21600 19440 10800" draw:text-areas="4350 0 17250 21600" draw:type="flowchart-manual-operation" draw:enhanced-path="M 0 0 L 21600 0 17250 21600 4350 21600 0 0 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
       </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Connector -->
      <xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartConnector'">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 3160 3160 0 10800 3160 18440 10800 21600 18440 18440 21600 10800 18440 3160" draw:text-areas="3180 3180 18420 18420" draw:type="flowchart-connector" draw:enhanced-path="U 10800 10800 10800 10800 0 23592960 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Off-page Connector -->
      <xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartOffpageConnector' or
                       $enhancePath= 'M f5 f5 L f6 f5 L f6 f7 L f8 f6 L f5 f7 L f5 f5 Z N '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 0 10800 10800 21600 21600 10800" draw:text-areas="0 0 21600 17150" draw:type="flowchart-off-page-connector" draw:enhanced-path="M 0 0 L 21600 0 21600 17150 10800 21600 0 17150 0 0 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Card -->
      <xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartPunchedCard'">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 0 10800 10800 21600 21600 10800" draw:text-areas="0 4300 21600 21600" draw:type="flowchart-card" draw:enhanced-path="M 4300 0 L 21600 0 21600 21600 0 21600 0 4300 4300 0 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Punched Tape -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartPunchedTape') or 
                $enhancePath ='M f5 f8 A f9 f8 f0 f7 A f9 f8 f0 f0 L f6 f10 A f9 f8 f5 f7 A f9 f8 f5 f0 Z N ' or
                           $enhancePath ='M f5 f7 C f8 f9 f10 f11 f12 f13 C f14 f15 f16 f17 f18 f19 C f20 f21 f22 f23 f24 f5 C f25 f26 f27 f28 f6 f7 L f6 f29 C f30 f31 f32 f33 f34 f35 C f36 f37 f38 f31 f39 f40 C f41 f42 f43 f44 f45 f6 C f46 f47 f48 f49 f5 f29 Z N '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 2020 0 10800 10800 19320 21600 10800" draw:text-areas="0 4360 21600 17240" draw:type="flowchart-punched-tape" draw:enhanced-path="M 0 2230 C 820 3990 3410 3980 5370 4360 7430 4030 10110 3890 10690 2270 11440 300 14200 160 16150 0 18670 170 20690 390 21600 2230 L 21600 19420 C 20640 17510 18320 17490 16140 17240 14710 17370 11310 17510 10770 19430 10150 21150 7380 21290 5290 21600 3220 21250 610 21130 0 19420 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Summing Junction -->
      <xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartSummingJunction' or
                $enhancePath='M f54 f55 A f9 f9 f35 f38 Z N M f10 f10 L f11 f11 M f10 f11 L f11 f10 '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 3160 3160 0 10800 3160 18440 10800 21600 18440 18440 21600 10800 18440 3160" draw:text-areas="3100 3100 18500 18500" draw:type="flowchart-summing-junction" draw:enhanced-path="U 10800 10800 10800 10800 0 23592960 Z N M 3100 3100 L 18500 18500 N M 3100 18500 L 18500 3100 N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Or -->
      <xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartOr' or 
                $enhancePath='M f54 f55 A f11 f11 f35 f38 Z N M f5 f11 L f6 f11 M f11 f5 L f11 f6 '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 3160 3160 0 10800 3160 18440 10800 21600 18440 18440 21600 10800 18440 3160" draw:text-areas="3100 3100 18500 18500" draw:type="flowchart-or" draw:enhanced-path="U 10800 10800 10800 10800 0 23592960 Z N M 0 10800 L 21600 10800 N M 10800 0 L 10800 21600 N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Collate -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartCollate') or 
                $enhancePath='M f5 f5 L f6 f5 L f7 f7 L f6 f6 L f5 f6 L f7 f7 Z N ' or
                           $enhancePath='M f5 f5 L f6 f6 L f5 f6 L f6 f5 L f5 f5 Z N '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 10800 10800 10800 21600" draw:text-areas="5400 5400 16200 16200" draw:type="flowchart-collate" draw:enhanced-path="M 0 0 L 21600 21600 0 21600 21600 0 0 0 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Sort -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartSort') or 
                $enhancePath ='S M f2 f4 L f4 f2 L f3 f4 L f4 f3 Z N F M f2 f4 L f3 f4 F M f2 f4 L f4 f2 L f3 f4 L f4 f3 Z N ' or
                          $enhancePath ='M f2 f4 L f4 f2 L f3 f4 L f4 f3 Z N M f2 f4 L f3 f4 '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:text-areas="5400 5400 16200 16200" draw:type="flowchart-sort" draw:enhanced-path="M 0 10800 L 10800 0 21600 10800 10800 21600 Z N M 0 10800 L 21600 10800 N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Extract -->
      <xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartExtract' 
                    or $enhancePath='M f7 f5 L f6 f6 L f5 f6 L f7 f5 Z N '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 5400 10800 10800 21600 16200 10800" draw:text-areas="5400 10800 16200 21600" draw:type="flowchart-extract" draw:enhanced-path="M 10800 0 L 21600 21600 0 21600 10800 0 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Merge-->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartMerge') or
                $enhancePath='M f5 f5 L f6 f5 L f7 f6 Z N ' or
                           $enhancePath= 'M f5 f5 L f6 f5 L f7 f6 L f5 f5 Z N '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 5400 10800 10800 21600 16200 10800" draw:text-areas="5400 0 16200 10800" draw:type="flowchart-merge" draw:enhanced-path="M 0 0 L 21600 0 10800 21600 0 0 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Stored Data -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartOnlineStorage') or
                $enhancePath='M f9 f5 L f6 f5 A f9 f10 f11 f8 L f9 f7 A f9 f10 f12 f13 Z N ' or
                          $enhancePath='M f8 f7 A f34 f35 f69 f60 A f19 f20 f61 f62 L f7 f6 A f44 f45 f70 f65 A f25 f26 f66 f67 Z N '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 0 10800 10800 21600 18000 10800" draw:text-areas="3600 0 18000 21600" draw:type="flowchart-stored-data" draw:enhanced-path="M 3600 21600 X 0 10800 3600 0 L 21600 0 X 18000 10800 21600 21600 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Delay -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartDelay') or
                $enhancePath='M f21 f21 L f35 f21 A f32 f33 f2 f0 L f21 f25 Z N ' or
                          $enhancePath='M f8 f6 A f26 f27 f48 f44 A f17 f18 f45 f46 L f6 f7 L f6 f6 Z N '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 0 10800 10800 21600 21600 10800" draw:text-areas="0 3100 18500 18500" draw:type="flowchart-delay" draw:enhanced-path="M 10800 0 X 21600 10800 10800 21600 L 0 21600 0 0 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Sequential Access Storage -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartMagneticTape') or 
                $enhancePath='M f40 f24 A f36 f37 f1 f1 A f36 f37 f0 f1 A f36 f37 f2 f1 A f36 f37 f6 f66 L f25 f64 L f25 f24 Z N 'or
                          $enhancePath='M f7 f8 L f7 f6 L f9 f6 C f10 f11 f5 f12 f5 f13 C f5 f14 f14 f5 f13 f5 C f15 f5 f6 f14 f6 f13 C f6 f16 f17 f18 f19 f20 Z N '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 0 10800 10800 21600 21600 10800" draw:text-areas="3100 3100 18500 18500" draw:type="flowchart-sequential-access" draw:enhanced-path="M 20980 18150 L 20980 21600 10670 21600 C 4770 21540 0 16720 0 10800 0 4840 4840 0 10800 0 16740 0 21600 4840 21600 10800 21600 13520 20550 16160 18670 18170 Z N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Direct Access Storage -->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartMagneticDrum') or 
                $enhancePath='S M f8 f5 L f9 f5 A f8 f10 f11 f12 L f8 f7 A f8 f10 f13 f12 Z N F M f9 f7 A f8 f10 f13 f12 F M f8 f5 L f9 f5 A f8 f10 f11 f12 L f8 f7 A f8 f10 f13 f12 Z N ' or
                          $enhancePath='M f8 f6 A f38 f39 f88 f74 A f21 f22 f75 f76 L f11 f7 A f48 f49 f89 f79 A f27 f28 f80 f81 Z N M f8 f6 A f58 f39 f90 f84 A f32 f22 f85 f86 '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 0 10800 10800 21600 14800 10800 21600 10800" draw:text-areas="3400 0 14800 21600" draw:type="flowchart-direct-access-storage" draw:enhanced-path="M 18200 0 X 21600 10800 18200 21600 L 3400 21600 X 0 10800 3400 0 Z N M 18200 0 X 14800 10800 18200 21600 N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Magnetic Disk-->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartMagneticDisk') or 
                $enhancePath='S M f5 f8 A f9 f8 f10 f10 L f6 f11 A f9 f8 f5 f10 Z N F M f6 f8 A f9 f8 f5 f10 F M f5 f8 A f9 f8 f10 f10 L f6 f11 A f9 f8 f5 f10 Z N 'or
                          $enhancePath= 'M f6 f8 A f38 f39 f82 f68 A f21 f22 f69 f70 L f7 f11 A f48 f49 f83 f73 A f27 f28 f74 f75 Z N M f6 f8 A f38 f58 f84 f78 A f21 f32 f79 f80 '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 6800 10800 0 0 10800 10800 21600 21600 10800" draw:text-areas="0 6800 21600 18200" draw:type="flowchart-magnetic-disk" draw:enhanced-path="M 0 3400 Y 10800 0 21600 3400 L 21600 18200 Y 10800 21600 0 18200 Z N M 0 3400 Y 10800 6800 21600 3400 N">
            <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
        </draw:custom-shape>
      </xsl:when>
      <!-- FlowChart: Display-->
      <xsl:when test ="(p:spPr/a:prstGeom/@prst='flowChartDisplay') or 
                $enhancePath='M f5 f8 L f9 f5 L f10 f5 A f9 f8 f11 f12 L f9 f7 Z N ' or
                          $enhancePath='M f8 f6 L f9 f6 A f28 f29 f49 f45 A f19 f20 f46 f47 L f8 f7 L f6 f12 Z N '">
        <draw:custom-shape draw:layer="layout">
          <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
            <xsl:with-param name="sldId" select="$slideId" />
            <xsl:with-param name="grID" select ="$GraphicId"/>
            <xsl:with-param name ="prID" select="$ParaId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="grpBln" select ="$grpBln" />
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          </xsl:call-template>
          <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 0 10800 10800 21600 21600 10800" draw:text-areas="3600 0 17800 21600" draw:type="flowchart-display" draw:enhanced-path="M 3600 0 L 17800 0 X 21600 10800 17800 21600 L 3600 21600 0 10800 Z N">
             <xsl:call-template name="tmpFlip"/>
          </draw:enhanced-geometry>
       </draw:custom-shape>
      </xsl:when>

		<!-- Action Buttons -->
		<!-- Action Buttons Back or Previous -->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='actionButtonBackPrevious' or 
              $enhancePath='S M f14 f14 L f17 f14 L f17 f18 L f14 f18 Z N M f31 f26 L f32 f33 L f32 f34 Z N S M f31 f26 L f32 f33 L f32 f34 Z N F M f31 f26 L f32 f33 L f32 f34 Z N F M f14 f14 L f17 f14 L f17 f18 L f14 f18 Z N '">
			<draw:custom-shape draw:layer="layout" >
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600"
										draw:path-stretchpoint-x="10800"
										draw:path-stretchpoint-y="10800"
										draw:text-areas="?f1 ?f2 ?f3 ?f4"
										draw:type="mso-spt194"
										draw:modifiers="1400"
										draw:enhanced-path="M 0 0 L 21600 0 21600 21600 0 21600 Z N M 0 0 L 21600 0 ?f3 ?f2 ?f1 ?f2 Z N M 21600 0 L 21600 21600 ?f3 ?f4 ?f3 ?f2 Z N M 21600 21600 L 0 21600 ?f1 ?f4 ?f3 ?f4 Z N M 0 21600 L 0 0 ?f1 ?f2 ?f1 ?f4 Z N M ?f10 ?f8 L ?f14 ?f12 ?f14 ?f16 Z N">
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="$0" />
					<draw:equation draw:name="f1" draw:formula="left+$0" />
					<draw:equation draw:name="f2" draw:formula="top+$0" />
					<draw:equation draw:name="f3" draw:formula="right-$0" />
					<draw:equation draw:name="f4" draw:formula="bottom-$0" />
					<draw:equation draw:name="f5" draw:formula="10800-$0" />
					<draw:equation draw:name="f6" draw:formula="?f5 /10800" />
					<draw:equation draw:name="f7" draw:formula="right/2" />
					<draw:equation draw:name="f8" draw:formula="bottom/2" />
					<draw:equation draw:name="f9" draw:formula="-8050*?f6" />
					<draw:equation draw:name="f10" draw:formula="?f9 +?f7" />
					<draw:equation draw:name="f11" draw:formula="-8050*?f6" />
					<draw:equation draw:name="f12" draw:formula="?f11 +?f8" />
					<draw:equation draw:name="f13" draw:formula="8050*?f6" />
					<draw:equation draw:name="f14" draw:formula="?f13 +?f7" />
					<draw:equation draw:name="f15" draw:formula="8050*?f6" />
					<draw:equation draw:name="f16" draw:formula="?f15 +?f8" />
					<draw:handle draw:handle-position="$0 top" draw:handle-switched="true" draw:handle-range-x-minimum="0" draw:handle-range-x-maximum="5400" />
				</draw:enhanced-geometry>
          		</draw:custom-shape >
		</xsl:when>
		<!-- Action Buttons Forward or Next -->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='actionButtonForwardNext' or 
              $enhancePath='S M f14 f14 L f17 f14 L f17 f18 L f14 f18 Z N M f31 f26 L f32 f33 L f32 f34 Z N S M f31 f26 L f32 f33 L f32 f34 Z N F M f31 f26 L f32 f34 L f32 f33 Z N F M f14 f14 L f17 f14 L f17 f18 L f14 f18 Z N '">
			<draw:custom-shape draw:layer="layout">
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600"
										draw:path-stretchpoint-x="10800"
										draw:path-stretchpoint-y="10800"
										draw:text-areas="?f1 ?f2 ?f3 ?f4"
										draw:type="mso-spt193"
										draw:modifiers="1400"
										draw:enhanced-path="M 0 0 L 21600 0 21600 21600 0 21600 Z N M 0 0 L 21600 0 ?f3 ?f2 ?f1 ?f2 Z N M 21600 0 L 21600 21600 ?f3 ?f4 ?f3 ?f2 Z N M 21600 21600 L 0 21600 ?f1 ?f4 ?f3 ?f4 Z N M 0 21600 L 0 0 ?f1 ?f2 ?f1 ?f4 Z N M ?f10 ?f12 L ?f14 ?f8 ?f10 ?f16 Z N">
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="$0" />
					<draw:equation draw:name="f1" draw:formula="left+$0" />
					<draw:equation draw:name="f2" draw:formula="top+$0" />
					<draw:equation draw:name="f3" draw:formula="right-$0" />
					<draw:equation draw:name="f4" draw:formula="bottom-$0" />
					<draw:equation draw:name="f5" draw:formula="10800-$0" />
					<draw:equation draw:name="f6" draw:formula="?f5 /10800" />
					<draw:equation draw:name="f7" draw:formula="right/2" />
					<draw:equation draw:name="f8" draw:formula="bottom/2" />
					<draw:equation draw:name="f9" draw:formula="-8050*?f6" />
					<draw:equation draw:name="f10" draw:formula="?f9 +?f7" />
					<draw:equation draw:name="f11" draw:formula="-8050*?f6" />
					<draw:equation draw:name="f12" draw:formula="?f11 +?f8" />
					<draw:equation draw:name="f13" draw:formula="8050*?f6" />
					<draw:equation draw:name="f14" draw:formula="?f13 +?f7" />
					<draw:equation draw:name="f15" draw:formula="8050*?f6" />
					<draw:equation draw:name="f16" draw:formula="?f15 +?f8" />
					<draw:handle draw:handle-position="$0 top" draw:handle-switched="true" draw:handle-range-x-minimum="0" draw:handle-range-x-maximum="5400" />
				</draw:enhanced-geometry>
          		</draw:custom-shape >
		</xsl:when>
		<!-- Action Buttons Beginning -->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='actionButtonBeginning'">
			<draw:custom-shape draw:layer="layout">
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600"
										draw:path-stretchpoint-x="10800"
										draw:path-stretchpoint-y="10800"
										draw:text-areas="?f1 ?f2 ?f3 ?f4"
										draw:type="mso-spt196"
										draw:modifiers="1400"
										draw:enhanced-path="M 0 0 L 21600 0 21600 21600 0 21600 Z N M 0 0 L 21600 0 ?f3 ?f2 ?f1 ?f2 Z N M 21600 0 L 21600 21600 ?f3 ?f4 ?f3 ?f2 Z N M 21600 21600 L 0 21600 ?f1 ?f4 ?f3 ?f4 Z N M 0 21600 L 0 0 ?f1 ?f2 ?f1 ?f4 Z N M ?f10 ?f8 L ?f14 ?f12 ?f14 ?f16 Z N M ?f18 ?f12 L ?f20 ?f12 ?f20 ?f16 ?f18 ?f16 Z N">
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="$0" />
					<draw:equation draw:name="f1" draw:formula="left+$0" />
					<draw:equation draw:name="f2" draw:formula="top+$0" />
					<draw:equation draw:name="f3" draw:formula="right-$0" />
					<draw:equation draw:name="f4" draw:formula="bottom-$0" />
					<draw:equation draw:name="f5" draw:formula="10800-$0" />
					<draw:equation draw:name="f6" draw:formula="?f5 /10800" />
					<draw:equation draw:name="f7" draw:formula="right/2" />
					<draw:equation draw:name="f8" draw:formula="bottom/2" />
					<draw:equation draw:name="f9" draw:formula="-4020*?f6" />
					<draw:equation draw:name="f10" draw:formula="?f9 +?f7" />
					<draw:equation draw:name="f11" draw:formula="-8050*?f6" />
					<draw:equation draw:name="f12" draw:formula="?f11 +?f8" />
					<draw:equation draw:name="f13" draw:formula="8050*?f6" />
					<draw:equation draw:name="f14" draw:formula="?f13 +?f7" />
					<draw:equation draw:name="f15" draw:formula="8050*?f6" />
					<draw:equation draw:name="f16" draw:formula="?f15 +?f8" />
					<draw:equation draw:name="f17" draw:formula="-8050*?f6" />
					<draw:equation draw:name="f18" draw:formula="?f17 +?f7" />
					<draw:equation draw:name="f19" draw:formula="-6140*?f6" />
					<draw:equation draw:name="f20" draw:formula="?f19 +?f7" />
					<draw:equation draw:name="f21" draw:formula="4020*?f6" />
					<draw:equation draw:name="f22" draw:formula="?f21 +?f7" />
					<draw:equation draw:name="f23" draw:formula="6140*?f6" />
					<draw:equation draw:name="f24" draw:formula="?f23 +?f7" />
					<draw:handle draw:handle-position="$0 top" draw:handle-switched="true" draw:handle-range-x-minimum="0" draw:handle-range-x-maximum="5400" />
				</draw:enhanced-geometry>
           		</draw:custom-shape >
		</xsl:when>
		<!-- Action Buttons end -->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='actionButtonEnd'">
			<draw:custom-shape draw:layer="layout">
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600"
										draw:path-stretchpoint-x="10800"
										draw:path-stretchpoint-y="10800"
										draw:text-areas="?f1 ?f2 ?f3 ?f4"
										draw:type="mso-spt195"
										draw:modifiers="1400"
										draw:enhanced-path="M 0 0 L 21600 0 21600 21600 0 21600 Z N M 0 0 L 21600 0 ?f3 ?f2 ?f1 ?f2 Z N M 21600 0 L 21600 21600 ?f3 ?f4 ?f3 ?f2 Z N M 21600 21600 L 0 21600 ?f1 ?f4 ?f3 ?f4 Z N M 0 21600 L 0 0 ?f1 ?f2 ?f1 ?f4 Z N M ?f22 ?f8 L ?f18 ?f16 ?f18 ?f12 Z N M ?f24 ?f12 L ?f24 ?f16 ?f14 ?f16 ?f14 ?f12 Z N">
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="$0" />
					<draw:equation draw:name="f1" draw:formula="left+$0" />
					<draw:equation draw:name="f2" draw:formula="top+$0" />
					<draw:equation draw:name="f3" draw:formula="right-$0" />
					<draw:equation draw:name="f4" draw:formula="bottom-$0" />
					<draw:equation draw:name="f5" draw:formula="10800-$0" />
					<draw:equation draw:name="f6" draw:formula="?f5 /10800" />
					<draw:equation draw:name="f7" draw:formula="right/2" />
					<draw:equation draw:name="f8" draw:formula="bottom/2" />
					<draw:equation draw:name="f9" draw:formula="-4020*?f6" />
					<draw:equation draw:name="f10" draw:formula="?f9 +?f7" />
					<draw:equation draw:name="f11" draw:formula="-8050*?f6" />
					<draw:equation draw:name="f12" draw:formula="?f11 +?f8" />
					<draw:equation draw:name="f13" draw:formula="8050*?f6" />
					<draw:equation draw:name="f14" draw:formula="?f13 +?f7" />
					<draw:equation draw:name="f15" draw:formula="8050*?f6" />
					<draw:equation draw:name="f16" draw:formula="?f15 +?f8" />
					<draw:equation draw:name="f17" draw:formula="-8050*?f6" />
					<draw:equation draw:name="f18" draw:formula="?f17 +?f7" />
					<draw:equation draw:name="f19" draw:formula="-6140*?f6" />
					<draw:equation draw:name="f20" draw:formula="?f19 +?f7" />
					<draw:equation draw:name="f21" draw:formula="4020*?f6" />
					<draw:equation draw:name="f22" draw:formula="?f21 +?f7" />
					<draw:equation draw:name="f23" draw:formula="6140*?f6" />
					<draw:equation draw:name="f24" draw:formula="?f23 +?f7" />
					<draw:handle draw:handle-position="$0 top" draw:handle-switched="true" draw:handle-range-x-minimum="0" draw:handle-range-x-maximum="5400" />
				</draw:enhanced-geometry>
           		</draw:custom-shape >
		</xsl:when>
		<!-- Action Buttons Home -->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='actionButtonHome'">
			<draw:custom-shape draw:layer="layout">
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!-- Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks -->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600"
										draw:path-stretchpoint-x="10800"
										draw:path-stretchpoint-y="10800"
										draw:text-areas="?f1 ?f2 ?f3 ?f4"
										draw:type="mso-spt190"
										draw:modifiers="1400"
										draw:enhanced-path="M 0 0 L 21600 0 21600 21600 0 21600 Z N M 0 0 L 21600 0 ?f3 ?f2 ?f1 ?f2 Z N M 21600 0 L 21600 21600 ?f3 ?f4 ?f3 ?f2 Z N M 21600 21600 L 0 21600 ?f1 ?f4 ?f3 ?f4 Z N M 0 21600 L 0 0 ?f1 ?f2 ?f1 ?f4 Z N M ?f7 ?f10 L ?f12 ?f14 ?f12 ?f16 ?f18 ?f16 ?f18 ?f20 ?f22 ?f8 ?f24 ?f8 ?f24 ?f26 ?f28 ?f26 ?f28 ?f8 ?f30 ?f8 Z N M ?f12 ?f14 L ?f12 ?f16 ?f18 ?f16 ?f18 ?f20 Z N M ?f32 ?f36 L ?f34 ?f36 ?f34 ?f26 ?f24 ?f26 ?f24 ?f8 ?f28 ?f8 ?f28 ?f26 ?f32 ?f26 Z N">
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="$0" />
					<draw:equation draw:name="f1" draw:formula="left+$0" />
					<draw:equation draw:name="f2" draw:formula="top+$0" />
					<draw:equation draw:name="f3" draw:formula="right-$0" />
					<draw:equation draw:name="f4" draw:formula="bottom-$0" />
					<draw:equation draw:name="f5" draw:formula="10800-$0" />
					<draw:equation draw:name="f6" draw:formula="?f5 /10800" />
					<draw:equation draw:name="f7" draw:formula="right/2" />
					<draw:equation draw:name="f8" draw:formula="bottom/2" />
					<draw:equation draw:name="f9" draw:formula="-8000*?f6" />
					<draw:equation draw:name="f10" draw:formula="?f9 +?f8" />
					<draw:equation draw:name="f11" draw:formula="2960*?f6" />
					<draw:equation draw:name="f12" draw:formula="?f11 +?f7" />
					<draw:equation draw:name="f13" draw:formula="-5000*?f6" />
					<draw:equation draw:name="f14" draw:formula="?f13 +?f8" />
					<draw:equation draw:name="f15" draw:formula="-7000*?f6" />
					<draw:equation draw:name="f16" draw:formula="?f15 +?f8" />
					<draw:equation draw:name="f17" draw:formula="5000*?f6" />
					<draw:equation draw:name="f18" draw:formula="?f17 +?f7" />
					<draw:equation draw:name="f19" draw:formula="-2960*?f6" />
					<draw:equation draw:name="f20" draw:formula="?f19 +?f8" />
					<draw:equation draw:name="f21" draw:formula="8000*?f6" />
					<draw:equation draw:name="f22" draw:formula="?f21 +?f7" />
					<draw:equation draw:name="f23" draw:formula="6100*?f6" />
					<draw:equation draw:name="f24" draw:formula="?f23 +?f7" />
					<draw:equation draw:name="f25" draw:formula="8260*?f6" />
					<draw:equation draw:name="f26" draw:formula="?f25 +?f8" />
					<draw:equation draw:name="f27" draw:formula="-6100*?f6" />
					<draw:equation draw:name="f28" draw:formula="?f27 +?f7" />
					<draw:equation draw:name="f29" draw:formula="-8000*?f6" />
					<draw:equation draw:name="f30" draw:formula="?f29 +?f7" />
					<draw:equation draw:name="f31" draw:formula="-1060*?f6" />
					<draw:equation draw:name="f32" draw:formula="?f31 +?f7" />
					<draw:equation draw:name="f33" draw:formula="1060*?f6" />
					<draw:equation draw:name="f34" draw:formula="?f33 +?f7" />
					<draw:equation draw:name="f35" draw:formula="4020*?f6" />
					<draw:equation draw:name="f36" draw:formula="?f35 +?f8" />
					<draw:handle draw:handle-position="$0 top" draw:handle-switched="true" draw:handle-range-x-minimum="0" draw:handle-range-x-maximum="5400" />
				</draw:enhanced-geometry>
             		</draw:custom-shape >
		</xsl:when>
		<!-- Action Buttons Information -->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='actionButtonInformation' or 
              $enhancePath='S M f16 f16 L f19 f16 L f19 f20 L f16 f20 Z N M f29 f49 A f39 f39 f1 f0 Z N S M f29 f49 A f39 f39 f1 f0 Z N M f29 f58 A f59 f59 f1 f0 M f60 f61 L f60 f62 L f63 f62 L f63 f64 L f60 f64 L f60 f65 L f66 f65 L f66 f64 L f67 f64 L f67 f61 Z N S M f29 f58 A f59 f59 f1 f0 M f60 f61 L f67 f61 L f67 f64 L f66 f64 L f66 f65 L f60 f65 L f60 f64 L f63 f64 L f63 f62 L f60 f62 Z N F M f29 f49 A f39 f39 f1 f0 Z N M f29 f58 A f59 f59 f1 f0 M f60 f61 L f67 f61 L f67 f64 L f66 f64 L f66 f65 L f60 f65 L f60 f64 L f63 f64 L f63 f62 L f60 f62 Z N F M f16 f16 L f19 f16 L f19 f20 L f16 f20 Z N '">
			<draw:custom-shape draw:layer="layout">
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!--Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks-->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!--Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
											draw:path-stretchpoint-x="10800"
											draw:path-stretchpoint-y="10800"
											draw:text-areas="?f1 ?f2 ?f3 ?f4"
											draw:type="mso-spt192"
											draw:modifiers="1400"
											draw:enhanced-path="M 0 0 L 21600 0 21600 21600 0 21600 Z N M 0 0 L 21600 0 ?f3 ?f2 ?f1 ?f2 Z N M 21600 0 L 21600 21600 ?f3 ?f4 ?f3 ?f2 Z N M 21600 21600 L 0 21600 ?f1 ?f4 ?f3 ?f4 Z N M 0 21600 L 0 0 ?f1 ?f2 ?f1 ?f4 Z N M ?f7 ?f12 X ?f10 ?f8 ?f7 ?f16 ?f14 ?f8 ?f7 ?f12 Z N M ?f7 ?f20 X ?f18 ?f42 ?f7 ?f24 ?f22 ?f42 ?f7 ?f20 Z N M ?f26 ?f28 L ?f30 ?f28 ?f30 ?f32 ?f34 ?f32 ?f34 ?f36 ?f26 ?f36 ?f26 ?f32 ?f38 ?f32 ?f38 ?f40 ?f26 ?f40 Z N">
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="$0 "/>
					<draw:equation draw:name="f1" draw:formula="left+$0 "/>
					<draw:equation draw:name="f2" draw:formula="top+$0 "/>
					<draw:equation draw:name="f3" draw:formula="right-$0 "/>
					<draw:equation draw:name="f4" draw:formula="bottom-$0 "/>
					<draw:equation draw:name="f5" draw:formula="10800-$0 "/>
					<draw:equation draw:name="f6" draw:formula="?f5 /10800"/>
					<draw:equation draw:name="f7" draw:formula="right/2"/>
					<draw:equation draw:name="f8" draw:formula="bottom/2"/>
					<draw:equation draw:name="f9" draw:formula="-8050*?f6 "/>
					<draw:equation draw:name="f10" draw:formula="?f9 +?f7 "/>
					<draw:equation draw:name="f11" draw:formula="-8050*?f6 "/>
					<draw:equation draw:name="f12" draw:formula="?f11 +?f8 "/>
					<draw:equation draw:name="f13" draw:formula="8050*?f6 "/>
					<draw:equation draw:name="f14" draw:formula="?f13 +?f7 "/>
					<draw:equation draw:name="f15" draw:formula="8050*?f6 "/>
					<draw:equation draw:name="f16" draw:formula="?f15 +?f8 "/>
					<draw:equation draw:name="f17" draw:formula="-2060*?f6 "/>
					<draw:equation draw:name="f18" draw:formula="?f17 +?f7 "/>
					<draw:equation draw:name="f19" draw:formula="-7620*?f6 "/>
					<draw:equation draw:name="f20" draw:formula="?f19 +?f8 "/>
					<draw:equation draw:name="f21" draw:formula="2060*?f6 "/>
					<draw:equation draw:name="f22" draw:formula="?f21 +?f7 "/>
					<draw:equation draw:name="f23" draw:formula="-3500*?f6 "/>
					<draw:equation draw:name="f24" draw:formula="?f23 +?f8 "/>
					<draw:equation draw:name="f25" draw:formula="-2960*?f6 "/>
					<draw:equation draw:name="f26" draw:formula="?f25 +?f7 "/>
					<draw:equation draw:name="f27" draw:formula="-2960*?f6 "/>
					<draw:equation draw:name="f28" draw:formula="?f27 +?f8 "/>
					<draw:equation draw:name="f29" draw:formula="1480*?f6 "/>
					<draw:equation draw:name="f30" draw:formula="?f29 +?f7 "/>
					<draw:equation draw:name="f31" draw:formula="5080*?f6 "/>
					<draw:equation draw:name="f32" draw:formula="?f31 +?f8 "/>
					<draw:equation draw:name="f33" draw:formula="2960*?f6 "/>
					<draw:equation draw:name="f34" draw:formula="?f33 +?f7 "/>
					<draw:equation draw:name="f35" draw:formula="6140*?f6 "/>
					<draw:equation draw:name="f36" draw:formula="?f35 +?f8 "/>
					<draw:equation draw:name="f37" draw:formula="-1480*?f6 "/>
					<draw:equation draw:name="f38" draw:formula="?f37 +?f7 "/>
					<draw:equation draw:name="f39" draw:formula="-1920*?f6 "/>
					<draw:equation draw:name="f40" draw:formula="?f39 +?f8 "/>
					<draw:equation draw:name="f41" draw:formula="-5560*?f6 "/>
					<draw:equation draw:name="f42" draw:formula="?f41 +?f8 "/>
					<draw:handle draw:handle-position="$0 top" draw:handle-switched="true" draw:handle-range-x-minimum="0" draw:handle-range-x-maximum="5400"/>
				</draw:enhanced-geometry>
             		</draw:custom-shape>
		</xsl:when>
		<!-- Action Buttons Return -->
		<xsl:when test ="p:spPr/a:prstGeom/@prst='actionButtonReturn'">
			<draw:custom-shape draw:layer="layout">
				<xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
					<!--Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks-->
                <xsl:with-param name ="layId" select="$layId"/>
					<xsl:with-param name="sldId" select="$slideId" />
					<xsl:with-param name="grID" select ="$GraphicId"/>
					<xsl:with-param name ="prID" select="$ParaId" />
					<xsl:with-param name="TypeId" select ="$TypeId" />
					<xsl:with-param name="grpBln" select ="$grpBln" />
					<xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
					<!--Extra parameter "SlideRelationId" added by lohith,requierd for template AddTextHyperlinks-->
					<xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
				</xsl:call-template>
				<draw:enhanced-geometry svg:viewBox="0 0 21600 21600" 
										draw:path-stretchpoint-x="10800"
										draw:path-stretchpoint-y="10800"
										draw:text-areas="?f1 ?f2 ?f3 ?f4"
										draw:type="mso-spt197"
										draw:modifiers="1400"
										draw:enhanced-path="M 0 0 L 21600 0 21600 21600 0 21600 Z N M 0 0 L 21600 0 ?f3 ?f2 ?f1 ?f2 Z N M 21600 0 L 21600 21600 ?f3 ?f4 ?f3 ?f2 Z N M 21600 21600 L 0 21600 ?f1 ?f4 ?f3 ?f4 Z N M 0 21600 L 0 0 ?f1 ?f2 ?f1 ?f4 Z N M ?f10 ?f12 L ?f14 ?f12 ?f14 ?f16 C ?f14 ?f18 ?f20 ?f22 ?f24 ?f22 L ?f7 ?f22 C ?f26 ?f22 ?f28 ?f18 ?f28 ?f16 L ?f28 ?f12 ?f7 ?f12 ?f30 ?f32 ?f34 ?f12 ?f36 ?f12 ?f36 ?f16 C ?f36 ?f38 ?f40 ?f42 ?f7 ?f42 L ?f24 ?f42 C ?f44 ?f42 ?f10 ?f38 ?f10 ?f16 Z N">
          <xsl:call-template name="tmpFlip"/>
					<draw:equation draw:name="f0" draw:formula="$0 "/>
					<draw:equation draw:name="f1" draw:formula="left+$0 "/>
					<draw:equation draw:name="f2" draw:formula="top+$0 "/>
					<draw:equation draw:name="f3" draw:formula="right-$0 "/>
					<draw:equation draw:name="f4" draw:formula="bottom-$0 "/>
					<draw:equation draw:name="f5" draw:formula="10800-$0 "/>
					<draw:equation draw:name="f6" draw:formula="?f5 /10800"/>
					<draw:equation draw:name="f7" draw:formula="right/2"/>
					<draw:equation draw:name="f8" draw:formula="bottom/2"/>
					<draw:equation draw:name="f9" draw:formula="-8050*?f6 "/>
					<draw:equation draw:name="f10" draw:formula="?f9 +?f7 "/>
					<draw:equation draw:name="f11" draw:formula="-3800*?f6 "/>
					<draw:equation draw:name="f12" draw:formula="?f11 +?f8 "/>
					<draw:equation draw:name="f13" draw:formula="-4020*?f6 "/>
					<draw:equation draw:name="f14" draw:formula="?f13 +?f7 "/>
					<draw:equation draw:name="f15" draw:formula="2330*?f6 "/>
					<draw:equation draw:name="f16" draw:formula="?f15 +?f8 "/>
					<draw:equation draw:name="f17" draw:formula="3390*?f6 "/>
					<draw:equation draw:name="f18" draw:formula="?f17 +?f8 "/>
					<draw:equation draw:name="f19" draw:formula="-3100*?f6 "/>
					<draw:equation draw:name="f20" draw:formula="?f19 +?f7 "/>
					<draw:equation draw:name="f21" draw:formula="4230*?f6 "/>
					<draw:equation draw:name="f22" draw:formula="?f21 +?f8 "/>
					<draw:equation draw:name="f23" draw:formula="-1910*?f6 "/>
					<draw:equation draw:name="f24" draw:formula="?f23 +?f7 "/>
					<draw:equation draw:name="f25" draw:formula="1190*?f6 "/>
					<draw:equation draw:name="f26" draw:formula="?f25 +?f7 "/>
					<draw:equation draw:name="f27" draw:formula="2110*?f6 "/>
					<draw:equation draw:name="f28" draw:formula="?f27 +?f7 "/>
					<draw:equation draw:name="f29" draw:formula="4030*?f6 "/>
					<draw:equation draw:name="f30" draw:formula="?f29 +?f7 "/>
					<draw:equation draw:name="f31" draw:formula="-7830*?f6 "/>
					<draw:equation draw:name="f32" draw:formula="?f31 +?f8 "/>
					<draw:equation draw:name="f33" draw:formula="8250*?f6 "/>
					<draw:equation draw:name="f34" draw:formula="?f33 +?f7 "/>
					<draw:equation draw:name="f35" draw:formula="6140*?f6 "/>
					<draw:equation draw:name="f36" draw:formula="?f35 +?f7 "/>
					<draw:equation draw:name="f37" draw:formula="5510*?f6 "/>
					<draw:equation draw:name="f38" draw:formula="?f37 +?f8 "/>
					<draw:equation draw:name="f39" draw:formula="3180*?f6 "/>
					<draw:equation draw:name="f40" draw:formula="?f39 +?f7 "/>
					<draw:equation draw:name="f41" draw:formula="8450*?f6 "/>
					<draw:equation draw:name="f42" draw:formula="?f41 +?f8 "/>
					<draw:equation draw:name="f43" draw:formula="-5090*?f6 "/>
					<draw:equation draw:name="f44" draw:formula="?f43 +?f7 "/>
					<draw:handle draw:handle-position="$0 top" draw:handle-switched="true" draw:handle-range-x-minimum="0" draw:handle-range-x-maximum="5400"/>
				</draw:enhanced-geometry>
			</draw:custom-shape>
		</xsl:when>
          <!--Custom Shapes-->
          <!--Added to retain text boxes-->
          <xsl:when test="$enhancePath='M f0 f0 L f1 f0 L f1 f1 L f0 f1 L f0 f0 Z N '">
            <draw:custom-shape draw:layer="layout" >
              <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
                <xsl:with-param name ="layId" select="$layId"/>
                <xsl:with-param name="sldId" select="$slideId" />
                <xsl:with-param name="grID" select ="$GraphicId"/>
                <xsl:with-param name ="prID" select="$ParaId" />
                <xsl:with-param name="TypeId" select ="$TypeId" />
                <xsl:with-param name="grpBln" select ="$grpBln" />
                <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
                <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
                <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
                <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
              </xsl:call-template>
              <draw:enhanced-geometry draw:type="non-primitive" svg:viewBox="0 0 21600 21600" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" draw:enhanced-path="M ?f8 ?f8 L ?f9 ?f8 ?f9 ?f9 ?f8 ?f9 ?f8 ?f8 Z N" draw:text-areas="?f10 ?f12 ?f11 ?f13">
                <draw:equation draw:name="f0" draw:formula="left" />
                <draw:equation draw:name="f1" draw:formula="right" />
                <draw:equation draw:name="f2" draw:formula="top" />
                <draw:equation draw:name="f3" draw:formula="bottom" />
                <draw:equation draw:name="f4" draw:formula="?f3 - ?f2" />
                <draw:equation draw:name="f5" draw:formula="?f1 - ?f0" />
                <draw:equation draw:name="f6" draw:formula="?f5 / 21600" />
                <draw:equation draw:name="f7" draw:formula="?f4 / 21600" />
                <draw:equation draw:name="f8" draw:formula="0" />
                <draw:equation draw:name="f9" draw:formula="21600" />
                <draw:equation draw:name="f10" draw:formula="?f0 / ?f6" />
                <draw:equation draw:name="f11" draw:formula="?f1 / ?f6" />
                <draw:equation draw:name="f12" draw:formula="?f2 / ?f7" />
                <draw:equation draw:name="f13" draw:formula="?f3 / ?f7" />
              </draw:enhanced-geometry>
            </draw:custom-shape>
          </xsl:when>
           <!--Arc-->
          <xsl:when test="$enhancePath='S M f159 f160 A f54 f55 f52 f74 L f66 f67 Z N F M f159 f160 A f54 f55 f52 f74 ' or
                          $enhancePath='M f155 f156 A f25 f25 f119 f137 L f153 f154 A f34 f34 f117 f140 Z N '">
            <draw:custom-shape draw:layer="layout" >
              <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
                <xsl:with-param name="sldId" select="$slideId" />
                <xsl:with-param name ="grID" select ="$GraphicId" />
                <xsl:with-param name ="prID" select ="$ParaId" />
                <xsl:with-param name="TypeId" select ="$TypeId" />
                <xsl:with-param name="grpBln" select ="$grpBln" />
                <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
                <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
                <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
                <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
              </xsl:call-template>
              <draw:enhanced-geometry draw:text-areas="10799 0 21599 10799" svg:viewBox="0 0 21600 21600" draw:type="mso-spt100" draw:modifiers="270 0" draw:enhanced-path="W 0 0 21600 21600 ?f3 ?f1 ?f7 ?f5 S L 10800 10800 Z N W 0 0 21600 21600 ?f3 ?f1 ?f7 ?f5 F N">
                <draw:equation draw:name="f0" draw:formula="10800*sin($0 *(pi/180))" />
                <draw:equation draw:name="f1" draw:formula="?f0 +10800" />
                <draw:equation draw:name="f2" draw:formula="10800*cos($0 *(pi/180))" />
                <draw:equation draw:name="f3" draw:formula="?f2 +10800" />
                <draw:equation draw:name="f4" draw:formula="10800*sin($1 *(pi/180))" />
                <draw:equation draw:name="f5" draw:formula="?f4 +10800" />
                <draw:equation draw:name="f6" draw:formula="10800*cos($1 *(pi/180))" />
                <draw:equation draw:name="f7" draw:formula="?f6 +10800" />
                <draw:handle draw:handle-position="10800 $0" draw:handle-polar="10800 10800" draw:handle-radius-range-minimum="10800" draw:handle-radius-range-maximum="10800" />
                <draw:handle draw:handle-position="10800 $1" draw:handle-polar="10800 10800" draw:handle-radius-range-minimum="10800" draw:handle-radius-range-maximum="10800" />
              </draw:enhanced-geometry>
            </draw:custom-shape>  
          </xsl:when>

          <!--Smileyface-->
          <xsl:when test="$enhancePath='M f76 f77 A f14 f14 f47 f51 Z N M f78 f79 A f16 f16 f47 f51 Z N M f80 f79 A f16 f16 f47 f51 Z N F M f17 f44 C f18 f45 f19 f45 f20 f44 ' or
                          $enhancePath='M f77 f78 A f14 f14 f49 f52 Z N M f79 f80 A f16 f16 f49 f52 Z N M f81 f80 A f16 f16 f49 f52 Z N M f17 f46 C f18 f47 f19 f47 f20 f46 '">
            <draw:custom-shape draw:layer="layout" >
              <xsl:call-template name="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
                <xsl:with-param name="sldId" select="$slideId" />
                <xsl:with-param name="grID" select ="$GraphicId" />
                <xsl:with-param name ="prID" select ="$ParaId" />
                <xsl:with-param name="TypeId" select ="$TypeId" />
                <xsl:with-param name="grpBln" select ="$grpBln" />
                <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
                <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
                <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
                <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
              </xsl:call-template>
              <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 3160 3160 0 10800 3160 18440 10800 21600 18440 18440 21600 10800 18440 3160" draw:text-areas="3200 3200 18400 18400" draw:type="smiley" draw:modifiers="17520" draw:enhanced-path="U 10800 10800 10800 10800 0 23592960 Z N U 7305 7515 1165 1165 0 23592960 Z N U 14295 7515 1165 1165 0 23592960 Z N M 4870 ?f1 C 8680 ?f2 12920 ?f2 16730 ?f1 F N">
                <draw:equation draw:name="f0" draw:formula="$0 -15510" />
                <draw:equation draw:name="f1" draw:formula="17520-?f0" />
                <draw:equation draw:name="f2" draw:formula="15510+?f0" />
                <draw:handle draw:handle-position="10800 $0" draw:handle-range-y-minimum="15510" draw:handle-range-y-maximum="17520" />
              </draw:enhanced-geometry>
            </draw:custom-shape>
          </xsl:when>
          <!--Heart-->
          <xsl:when test="$enhancePath='M f46 f39 C f48 f47 f49 f39 f46 f23 C f50 f39 f51 f47 f46 f39 Z N '">
            <draw:custom-shape draw:layer="layout" >
              <xsl:call-template name="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
                <xsl:with-param name="sldId" select="$slideId" />
                <xsl:with-param name="grID" select ="$GraphicId" />
                <xsl:with-param name ="prID" select ="$ParaId" />
                <xsl:with-param name="TypeId" select ="$TypeId" />
                <xsl:with-param name="grpBln" select ="$grpBln" />
                <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
                <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
                <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
                <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
              </xsl:call-template>
              <draw:enhanced-geometry svg:viewBox="0 0 21615 21602" draw:glue-points="10800 2180 3090 10800 10800 21600 18490 10800" draw:text-areas="5080 2540 16520 13550" draw:type="heart" 
                                      draw:enhanced-path="M 10800 21599 L 321 6886 70 6036 C -9 5766 -1 5474 2 5192 6 4918 43 4641 101 4370 159 4103 245 3837 353 3582 460 3326 591 3077 741 2839 892 2598 1066 2369 1253 2155 1443 1938 1651 1732 1874 1543 2097 1351 2337 1174 2587 1014 2839 854 3106 708 3380 584 3656 459 3945 350 4237 264 4533 176 4838 108 5144 66 5454 22 5771 1 6086 3 6407 7 6731 35 7048 89 7374 144 7700 226 8015 335 8344 447 8667 590 8972 756 9297 932 9613 1135 9907 1363 10224 1609 10504 1900 10802 2169 L 11697 1363 C 11971 1116 12304 934 12630 756 12935 590 13528 450 13589 335 13901 226 14227 144 14556 89 14872 35 15195 7 15517 3 15830 0 16147 22 16458 66 16764 109 17068 177 17365 264 17658 349 17946 458 18222 584 18496 708 18762 854 19015 1014 19264 1172 19504 1349 19730 1543 19950 1731 20158 1937 20350 2155 20536 2369 20710 2598 20861 2839 21010 3074 21143 3323 21251 3582 21357 3835 21443 4099 21502 4370 21561 4639 21595 4916 21600 5192 21606 5474 21584 5760 21532 6036 21478 6326 21366 6603 21282 6887 L 10802 21602 Z N" />
            </draw:custom-shape>
          </xsl:when>

          <!--Moon-->
          <xsl:when test="$enhancePath='M f6 f7 A f6 f10 f11 f12 A f13 f14 f9 f8 Z N ' or
                          $enhancePath='M f7 f6 C f40 f35 f24 f13 f24 f14 C f24 f15 f40 f41 f7 f7 C f16 f7 f6 f17 f6 f14 C f6 f18 f16 f6 f7 f6 Z N '">
            <draw:custom-shape draw:layer="layout">
              <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
                <xsl:with-param name="sldId" select="$slideId" />
                <xsl:with-param name ="grID" select ="$GraphicId" />
                <xsl:with-param name ="prID" select ="$ParaId" />
                <xsl:with-param name="TypeId" select ="$TypeId" />
                <xsl:with-param name="grpBln" select ="$grpBln" />
                <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
                <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
                <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
                <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
              </xsl:call-template>
              <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="21600 0 0 10800 21600 21600 ?f0 10800" draw:text-areas="?f9 ?f8 ?f0 ?f10" draw:type="moon" draw:modifiers="10800" draw:enhanced-path="M 21600 0 C ?f3 ?f4 ?f0 5080 ?f0 10800 ?f0 16520 ?f3 ?f5 21600 21600 9740 21600 0 16730 0 10800 0 4870 9740 0 21600 0 Z N">
                <draw:equation draw:name="f0" draw:formula="$0" />
                <draw:equation draw:name="f1" draw:formula="21600-$0" />
                <draw:equation draw:name="f2" draw:formula="?f1 /2" />
                <draw:equation draw:name="f3" draw:formula="?f2 +$0" />
                <draw:equation draw:name="f4" draw:formula="$0 *1794/10000" />
                <draw:equation draw:name="f5" draw:formula="21600-?f4" />
                <draw:equation draw:name="f6" draw:formula="$0 *400/18900" />
                <draw:equation draw:name="f7" draw:formula="(cos(?f6 *(pi/180))*(0-10800)+sin(?f6 *(pi/180))*(10800-10800))+10800" />
                <draw:equation draw:name="f8" draw:formula="-(sin(?f6 *(pi/180))*(0-10800)-cos(?f6 *(pi/180))*(10800-10800))+10800" />
                <draw:equation draw:name="f9" draw:formula="?f7 +?f7" />
                <draw:equation draw:name="f10" draw:formula="21600-?f8" />
                <draw:handle draw:handle-position="$0 10800" draw:handle-range-x-minimum="0" draw:handle-range-x-maximum="18900" />
              </draw:enhanced-geometry>
            </draw:custom-shape>
          </xsl:when>
          <!--Sun-->
          <xsl:when test="$enhancePath='M f29 f65 L f119 f127 L f119 f120 Z N M f66 f67 L f128 f121 L f129 f122 Z N M f68 f23 L f130 f111 L f123 f111 Z N M f69 f67 L f124 f122 L f125 f121 Z N M f23 f65 L f112 f120 L f112 f127 Z N M f69 f70 L f125 f131 L f124 f132 Z N M f68 f30 L f123 f126 L f130 f126 Z N M f66 f70 L f129 f132 L f128 f131 Z N M f71 f65 A f72 f73 f2 f1 Z N ' or
                          $enhancePath='M f6 f14 L f69 f79 L f69 f80 Z N M f244 f289 L f246 f290 L f248 f291 Z N M f250 f292 L f252 f293 L f254 f294 Z N M f256 f295 L f258 f296 L f260 f297 Z N M f262 f298 L f264 f299 L f266 f300 Z N M f268 f301 L f270 f302 L f272 f303 Z N M f274 f304 L f276 f305 L f278 f306 Z N M f280 f307 L f282 f308 L f284 f309 Z N M f318 f319 A f34 f34 f56 f68 Z N '">
            <draw:custom-shape draw:layer="layout">
              <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
                <xsl:with-param name="sldId" select="$slideId" />
                <xsl:with-param name ="grID" select ="$GraphicId" />
                <xsl:with-param name ="prID" select ="$ParaId" />
                <xsl:with-param name="TypeId" select ="$TypeId" />
                <xsl:with-param name="grpBln" select ="$grpBln" />
                <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
                <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
                <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
                <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
              </xsl:call-template>
              <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 0 10800 10800 21600 21600 10800" draw:text-areas="?f52 ?f52 ?f53 ?f53" draw:type="sun" draw:modifiers="5400" draw:enhanced-path="M 0 10800 L ?f4 ?f8 ?f4 ?f9 Z N M ?f10 ?f11 L ?f12 ?f13 ?f14 ?f15 Z N M ?f16 ?f17 L ?f18 ?f19 ?f20 ?f21 Z N M ?f22 ?f23 L ?f24 ?f25 ?f26 ?f27 Z N M ?f28 ?f29 L ?f30 ?f31 ?f32 ?f33 Z N M ?f34 ?f35 L ?f36 ?f37 ?f38 ?f39 Z N M ?f40 ?f41 L ?f42 ?f43 ?f44 ?f45 Z N M ?f46 ?f47 L ?f48 ?f49 ?f50 ?f51 Z N U 10800 10800 ?f54 ?f54 0 23592960 Z N">
                <draw:equation draw:name="f0" draw:formula="$0" />
                <draw:equation draw:name="f1" draw:formula="21600-$0" />
                <draw:equation draw:name="f2" draw:formula="$0 -2700" />
                <draw:equation draw:name="f3" draw:formula="?f2 *5080/7425" />
                <draw:equation draw:name="f4" draw:formula="?f3 +2540" />
                <draw:equation draw:name="f5" draw:formula="10125-$0" />
                <draw:equation draw:name="f6" draw:formula="?f5 *2120/7425" />
                <draw:equation draw:name="f7" draw:formula="?f6 +210" />
                <draw:equation draw:name="f8" draw:formula="10800+?f7" />
                <draw:equation draw:name="f9" draw:formula="10800-?f7" />
                <draw:equation draw:name="f10" draw:formula="(cos(45*(pi/180))*(0-10800)+sin(45*(pi/180))*(10800-10800))+10800" />
                <draw:equation draw:name="f11" draw:formula="-(sin(45*(pi/180))*(0-10800)-cos(45*(pi/180))*(10800-10800))+10800" />
                <draw:equation draw:name="f12" draw:formula="(cos(45*(pi/180))*(?f4 -10800)+sin(45*(pi/180))*(?f8 -10800))+10800" />
                <draw:equation draw:name="f13" draw:formula="-(sin(45*(pi/180))*(?f4 -10800)-cos(45*(pi/180))*(?f8 -10800))+10800" />
                <draw:equation draw:name="f14" draw:formula="(cos(45*(pi/180))*(?f4 -10800)+sin(45*(pi/180))*(?f9 -10800))+10800" />
                <draw:equation draw:name="f15" draw:formula="-(sin(45*(pi/180))*(?f4 -10800)-cos(45*(pi/180))*(?f9 -10800))+10800" />
                <draw:equation draw:name="f16" draw:formula="(cos(90*(pi/180))*(0-10800)+sin(90*(pi/180))*(10800-10800))+10800" />
                <draw:equation draw:name="f17" draw:formula="-(sin(90*(pi/180))*(0-10800)-cos(90*(pi/180))*(10800-10800))+10800" />
                <draw:equation draw:name="f18" draw:formula="(cos(90*(pi/180))*(?f4 -10800)+sin(90*(pi/180))*(?f8 -10800))+10800" />
                <draw:equation draw:name="f19" draw:formula="-(sin(90*(pi/180))*(?f4 -10800)-cos(90*(pi/180))*(?f8 -10800))+10800" />
                <draw:equation draw:name="f20" draw:formula="(cos(90*(pi/180))*(?f4 -10800)+sin(90*(pi/180))*(?f9 -10800))+10800" />
                <draw:equation draw:name="f21" draw:formula="-(sin(90*(pi/180))*(?f4 -10800)-cos(90*(pi/180))*(?f9 -10800))+10800" />
                <draw:equation draw:name="f22" draw:formula="(cos(135*(pi/180))*(0-10800)+sin(135*(pi/180))*(10800-10800))+10800" />
                <draw:equation draw:name="f23" draw:formula="-(sin(135*(pi/180))*(0-10800)-cos(135*(pi/180))*(10800-10800))+10800" />
                <draw:equation draw:name="f24" draw:formula="(cos(135*(pi/180))*(?f4 -10800)+sin(135*(pi/180))*(?f8 -10800))+10800" />
                <draw:equation draw:name="f25" draw:formula="-(sin(135*(pi/180))*(?f4 -10800)-cos(135*(pi/180))*(?f8 -10800))+10800" />
                <draw:equation draw:name="f26" draw:formula="(cos(135*(pi/180))*(?f4 -10800)+sin(135*(pi/180))*(?f9 -10800))+10800" />
                <draw:equation draw:name="f27" draw:formula="-(sin(135*(pi/180))*(?f4 -10800)-cos(135*(pi/180))*(?f9 -10800))+10800" />
                <draw:equation draw:name="f28" draw:formula="(cos(180*(pi/180))*(0-10800)+sin(180*(pi/180))*(10800-10800))+10800" />
                <draw:equation draw:name="f29" draw:formula="-(sin(180*(pi/180))*(0-10800)-cos(180*(pi/180))*(10800-10800))+10800" />
                <draw:equation draw:name="f30" draw:formula="(cos(180*(pi/180))*(?f4 -10800)+sin(180*(pi/180))*(?f8 -10800))+10800" />
                <draw:equation draw:name="f31" draw:formula="-(sin(180*(pi/180))*(?f4 -10800)-cos(180*(pi/180))*(?f8 -10800))+10800" />
                <draw:equation draw:name="f32" draw:formula="(cos(180*(pi/180))*(?f4 -10800)+sin(180*(pi/180))*(?f9 -10800))+10800" />
                <draw:equation draw:name="f33" draw:formula="-(sin(180*(pi/180))*(?f4 -10800)-cos(180*(pi/180))*(?f9 -10800))+10800" />
                <draw:equation draw:name="f34" draw:formula="(cos(225*(pi/180))*(0-10800)+sin(225*(pi/180))*(10800-10800))+10800" />
                <draw:equation draw:name="f35" draw:formula="-(sin(225*(pi/180))*(0-10800)-cos(225*(pi/180))*(10800-10800))+10800" />
                <draw:equation draw:name="f36" draw:formula="(cos(225*(pi/180))*(?f4 -10800)+sin(225*(pi/180))*(?f8 -10800))+10800" />
                <draw:equation draw:name="f37" draw:formula="-(sin(225*(pi/180))*(?f4 -10800)-cos(225*(pi/180))*(?f8 -10800))+10800" />
                <draw:equation draw:name="f38" draw:formula="(cos(225*(pi/180))*(?f4 -10800)+sin(225*(pi/180))*(?f9 -10800))+10800" />
                <draw:equation draw:name="f39" draw:formula="-(sin(225*(pi/180))*(?f4 -10800)-cos(225*(pi/180))*(?f9 -10800))+10800" />
                <draw:equation draw:name="f40" draw:formula="(cos(270*(pi/180))*(0-10800)+sin(270*(pi/180))*(10800-10800))+10800" />
                <draw:equation draw:name="f41" draw:formula="-(sin(270*(pi/180))*(0-10800)-cos(270*(pi/180))*(10800-10800))+10800" />
                <draw:equation draw:name="f42" draw:formula="(cos(270*(pi/180))*(?f4 -10800)+sin(270*(pi/180))*(?f8 -10800))+10800" />
                <draw:equation draw:name="f43" draw:formula="-(sin(270*(pi/180))*(?f4 -10800)-cos(270*(pi/180))*(?f8 -10800))+10800" />
                <draw:equation draw:name="f44" draw:formula="(cos(270*(pi/180))*(?f4 -10800)+sin(270*(pi/180))*(?f9 -10800))+10800" />
                <draw:equation draw:name="f45" draw:formula="-(sin(270*(pi/180))*(?f4 -10800)-cos(270*(pi/180))*(?f9 -10800))+10800" />
                <draw:equation draw:name="f46" draw:formula="(cos(315*(pi/180))*(0-10800)+sin(315*(pi/180))*(10800-10800))+10800" />
                <draw:equation draw:name="f47" draw:formula="-(sin(315*(pi/180))*(0-10800)-cos(315*(pi/180))*(10800-10800))+10800" />
                <draw:equation draw:name="f48" draw:formula="(cos(315*(pi/180))*(?f4 -10800)+sin(315*(pi/180))*(?f8 -10800))+10800" />
                <draw:equation draw:name="f49" draw:formula="-(sin(315*(pi/180))*(?f4 -10800)-cos(315*(pi/180))*(?f8 -10800))+10800" />
                <draw:equation draw:name="f50" draw:formula="(cos(315*(pi/180))*(?f4 -10800)+sin(315*(pi/180))*(?f9 -10800))+10800" />
                <draw:equation draw:name="f51" draw:formula="-(sin(315*(pi/180))*(?f4 -10800)-cos(315*(pi/180))*(?f9 -10800))+10800" />
                <draw:equation draw:name="f52" draw:formula="(cos(45*(pi/180))*($0 -10800)+sin(45*(pi/180))*(10800-10800))+10800" />
                <draw:equation draw:name="f53" draw:formula="(cos(225*(pi/180))*($0 -10800)+sin(225*(pi/180))*(10800-10800))+10800" />
                <draw:equation draw:name="f54" draw:formula="10800-$0" />
                <draw:handle draw:handle-position="$0 10800" draw:handle-range-x-minimum="2700" draw:handle-range-x-maximum="10125" />
              </draw:enhanced-geometry>
            </draw:custom-shape>
          </xsl:when>

          <!--Double Bracket-->
          <xsl:when test="$enhancePath='S M f20 f31 A f31 f31 f1 f2 L f33 f20 A f31 f31 f3 f2 L f23 f34 A f31 f31 f7 f2 L f31 f24 A f31 f31 f2 f2 Z N F M f31 f24 A f31 f31 f2 f2 L f20 f31 A f31 f31 f1 f2 M f33 f20 A f31 f31 f3 f2 L f23 f34 A f31 f31 f7 f2 ' or
                          $enhancePath='M f38 f8 A f60 f49 f90 f75 L f39 f26 A f65 f51 f76 f77 M f54 f9 A f78 f55 f98 f93 L f42 f25 A f83 f56 f94 f95 '">
            <draw:custom-shape draw:layer="layout" >
              <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
                <xsl:with-param name="sldId" select="$slideId" />
                <xsl:with-param name ="grID" select ="$GraphicId" />
                <xsl:with-param name ="prID" select ="$ParaId" />
                <xsl:with-param name="TypeId" select ="$TypeId" />
                <xsl:with-param name="grpBln" select ="$grpBln" />
                <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
                <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
                <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
                <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
              </xsl:call-template>
              <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 0 10800 10800 21600 21600 10800" draw:path-stretchpoint-x="10800" draw:text-areas="?f8 ?f9 ?f10 ?f11" draw:type="bracket-pair" draw:modifiers="3700" draw:enhanced-path="M ?f0 0 X 0 ?f1 L 0 ?f2 Y ?f0 21600 N M ?f3 21600 X 21600 ?f2 L 21600 ?f1 Y ?f3 0 N">
                <draw:equation draw:name="f0" draw:formula="left+$0" />
                <draw:equation draw:name="f1" draw:formula="top+$0" />
                <draw:equation draw:name="f2" draw:formula="bottom-$0" />
                <draw:equation draw:name="f3" draw:formula="right-$0" />
                <draw:equation draw:name="f4" draw:formula="-(sin(45*(pi/180))*($0 -10800)-cos(45*(pi/180))*(0-10800))+10800" />
                <draw:equation draw:name="f5" draw:formula="?f4 -10800" />
                <draw:equation draw:name="f6" draw:formula="-$0" />
                <draw:equation draw:name="f7" draw:formula="?f6 -?f5" />
                <draw:equation draw:name="f8" draw:formula="left-?f7" />
                <draw:equation draw:name="f9" draw:formula="top-?f7" />
                <draw:equation draw:name="f10" draw:formula="right+?f7" />
                <draw:equation draw:name="f11" draw:formula="bottom+?f7" />
                <draw:equation draw:name="f12" draw:formula="left-?f5" />
                <draw:equation draw:name="f13" draw:formula="top-?f5" />
                <draw:equation draw:name="f14" draw:formula="right+?f5" />
                <draw:equation draw:name="f15" draw:formula="bottom+?f5" />
                <draw:handle draw:handle-position="$0 top" draw:handle-switched="true" draw:handle-range-x-minimum="0" draw:handle-range-x-maximum="10800" />
              </draw:enhanced-geometry>
            </draw:custom-shape>
          </xsl:when>
          <!--Double Brace-->
          <xsl:when test="$enhancePath='S M f37 f24 A f38 f38 f2 f2 L f38 f40 A f38 f38 f7 f8 A f38 f38 f2 f8 L f38 f38 A f38 f38 f1 f2 L f41 f21 A f38 f38 f3 f2 L f42 f43 A f38 f38 f1 f8 A f38 f38 f3 f8 L f42 f44 A f38 f38 f7 f2 Z N F M f37 f24 A f38 f38 f2 f2 L f38 f40 A f38 f38 f7 f8 A f38 f38 f2 f8 L f38 f38 A f38 f38 f1 f2 M f41 f21 A f38 f38 f3 f2 L f42 f43 A f38 f38 f1 f8 A f38 f38 f3 f8 L f42 f44 A f38 f38 f7 f2 ' or
                          $enhancePath='M f54 f8 A f95 f55 f146 f132 L f40 f25 A f76 f57 f100 f101 A f81 f82 f133 f104 L f40 f23 A f105 f62 f134 f135 M f65 f9 A f110 f67 f147 f138 L f66 f34 A f115 f90 f139 f140 A f120 f69 f148 f143 L f66 f22 A f125 f70 f144 f145 '">
            <draw:custom-shape draw:layer="layout" >
              <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
                <xsl:with-param name="sldId" select="$slideId" />
                <xsl:with-param name ="grID" select ="$GraphicId" />
                <xsl:with-param name ="prID" select ="$ParaId" />
                <xsl:with-param name="TypeId" select ="$TypeId" />
                <xsl:with-param name="grpBln" select ="$grpBln" />
                <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
                <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
                <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
                <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
              </xsl:call-template>
              <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:glue-points="10800 0 0 10800 10800 21600 21600 10800" draw:path-stretchpoint-x="10800" draw:text-areas="?f11 ?f12 ?f13 ?f14" draw:type="brace-pair" draw:modifiers="1800" draw:enhanced-path="M ?f4 0 X ?f0 ?f1 L ?f0 ?f6 Y 0 10800 X ?f0 ?f7 L ?f0 ?f2 Y ?f4 21600 N M ?f8 21600 X ?f3 ?f2 L ?f3 ?f7 Y 21600 10800 X ?f3 ?f6 L ?f3 ?f1 Y ?f8 0 N">
                <draw:equation draw:name="f0" draw:formula="left+$0" />
                <draw:equation draw:name="f1" draw:formula="top+$0" />
                <draw:equation draw:name="f2" draw:formula="bottom-$0" />
                <draw:equation draw:name="f3" draw:formula="right-$0" />
                <draw:equation draw:name="f4" draw:formula="?f0 *2" />
                <draw:equation draw:name="f5" draw:formula="$0 *2" />
                <draw:equation draw:name="f6" draw:formula="10800-$0" />
                <draw:equation draw:name="f7" draw:formula="21600-?f6" />
                <draw:equation draw:name="f8" draw:formula="right-?f5" />
                <draw:equation draw:name="f9" draw:formula="$0 /3" />
                <draw:equation draw:name="f10" draw:formula="?f9 +$0" />
                <draw:equation draw:name="f11" draw:formula="left+?f10" />
                <draw:equation draw:name="f12" draw:formula="top+?f9" />
                <draw:equation draw:name="f13" draw:formula="right-?f10" />
                <draw:equation draw:name="f14" draw:formula="bottom-?f9" />
                <draw:handle draw:handle-position="left $0" draw:handle-switched="true" draw:handle-range-y-minimum="0" draw:handle-range-y-maximum="5400" />
              </draw:enhanced-geometry>
            </draw:custom-shape>
          </xsl:when>                 

          <!--Left Right Up Arrow-->
          <xsl:when test="$enhancePath='M f35 f66 L f62 f67 L f62 f75 L f68 f75 L f68 f62 L f69 f62 L f53 f35 L f70 f62 L f71 f62 L f71 f75 L f72 f75 L f72 f67 L f41 f66 L f72 f42 L f72 f76 L f62 f76 L f62 f42 Z N '">
            <draw:custom-shape draw:layer="layout" >
              <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
                <xsl:with-param name="sldId" select="$slideId" />
                <xsl:with-param name ="grID" select ="$GraphicId" />
                <xsl:with-param name ="prID" select ="$ParaId" />
                <xsl:with-param name="TypeId" select ="$TypeId" />
                <xsl:with-param name="grpBln" select ="$grpBln" />
                <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
                <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering -->
                <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
                <!-- End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering -->
              </xsl:call-template>
              <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:text-areas="0 0 21600 21600" draw:type="mso-spt182" draw:modifiers="6500 8600 6200" draw:enhanced-path="M 10800 0 L ?f3 ?f2 ?f4 ?f2 ?f4 ?f1 ?f5 ?f1 ?f5 ?f0 21600 10800 ?f5 ?f3 ?f5 ?f4 ?f2 ?f4 ?f2 ?f3 0 10800 ?f2 ?f0 ?f2 ?f1 ?f1 ?f1 ?f1 ?f2 ?f0 ?f2 Z N">
                <draw:equation draw:name="f0" draw:formula="$0" />
                <draw:equation draw:name="f1" draw:formula="$1" />
                <draw:equation draw:name="f2" draw:formula="?f3 *$2 /21600" />
                <draw:equation draw:name="f3" draw:formula="21600-$0" />
                <draw:equation draw:name="f4" draw:formula="21600-$1" />
                <draw:equation draw:name="f5" draw:formula="21600-?f2" />
                <draw:handle draw:handle-position="$1 $2" draw:handle-range-x-minimum="$0" draw:handle-range-x-maximum="10800" draw:handle-range-y-minimum="0" draw:handle-range-y-maximum="$0" />
                <draw:handle draw:handle-position="$0 top" draw:handle-range-x-minimum="$2" draw:handle-range-x-maximum="$1" />
              </draw:enhanced-geometry>
            </draw:custom-shape>
          </xsl:when>

          <!--curved right arrow-->
          <xsl:when test="$enhancePath ='S M f37 f79 A f48 f79 f3 f117 L f70 f96 L f43 f75 L f70 f97 L f70 f92 A f48 f79 f116 f114 Z N S M f43 f63 A f48 f79 f5 f122 A f48 f79 f124 f123 Z N F M f37 f79 A f48 f79 f3 f117 L f70 f96 L f43 f75 L f70 f97 L f70 f92 A f48 f79 f116 f114 L f37 f79 A f48 f79 f3 f4 L f43 f63 A f48 f79 f5 f122 '">
            <draw:custom-shape draw:layer="layout" >
              <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
                <xsl:with-param name="sldId" select="$slideId" />
                <xsl:with-param name="grID" select ="$GraphicId"/>
                <xsl:with-param name ="prID" select="$ParaId" />
                <xsl:with-param name="TypeId" select ="$TypeId" />
                <xsl:with-param name="grpBln" select ="$grpBln" />
                <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
                <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
                <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
                <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
              </xsl:call-template>
   <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:text-areas="0 0 21600 21600"
                                        draw:mirror-vertical="true" draw:type="circular-arrow" draw:modifiers="84.1499444519454 -80.8262021942408 7331.32459905244" draw:enhanced-path="B ?f3 ?f3 ?f20 ?f20 ?f19 ?f18 ?f17 ?f16 W 0 0 21600 21600 ?f9 ?f8 ?f11 ?f10 L ?f24 ?f23 ?f36 ?f35 ?f29 ?f28 Z N">
   <xsl:attribute name ="draw:type">
                  <xsl:value-of select="'curvedRightArrow'"/>
                </xsl:attribute>
  <xsl:attribute name ="draw:mirror-horizontal">
                  <xsl:value-of select="'false'"/>
                </xsl:attribute>
  <draw:equation draw:name="f0" draw:formula="$0 "/>
                <draw:equation draw:name="f1" draw:formula="$1 "/>
                <draw:equation draw:name="f2" draw:formula="$2 "/>
                <draw:equation draw:name="f3" draw:formula="10800+$2 "/>
                <draw:equation draw:name="f4" draw:formula="10800*sin($0 *(pi/180))"/>
                <draw:equation draw:name="f5" draw:formula="10800*cos($0 *(pi/180))"/>
                <draw:equation draw:name="f6" draw:formula="10800*sin($1 *(pi/180))"/>
                <draw:equation draw:name="f7" draw:formula="10800*cos($1 *(pi/180))"/>
                <draw:equation draw:name="f8" draw:formula="?f4 +10800"/>
                <draw:equation draw:name="f9" draw:formula="?f5 +10800"/>
                <draw:equation draw:name="f10" draw:formula="?f6 +10800"/>
                <draw:equation draw:name="f11" draw:formula="?f7 +10800"/>
                <draw:equation draw:name="f12" draw:formula="?f3 *sin($0 *(pi/180))"/>
                <draw:equation draw:name="f13" draw:formula="?f3 *cos($0 *(pi/180))"/>
                <draw:equation draw:name="f14" draw:formula="?f3 *sin($1 *(pi/180))"/>
                <draw:equation draw:name="f15" draw:formula="?f3 *cos($1 *(pi/180))"/>
                <draw:equation draw:name="f16" draw:formula="?f12 +10800"/>
                <draw:equation draw:name="f17" draw:formula="?f13 +10800"/>
                <draw:equation draw:name="f18" draw:formula="?f14 +10800"/>
                <draw:equation draw:name="f19" draw:formula="?f15 +10800"/>
                <draw:equation draw:name="f20" draw:formula="21600-?f3 "/>
                <draw:equation draw:name="f21" draw:formula="13500*sin($1 *(pi/180))"/>
                <draw:equation draw:name="f22" draw:formula="13500*cos($1 *(pi/180))"/>
                <draw:equation draw:name="f23" draw:formula="?f21 +10800"/>
                <draw:equation draw:name="f24" draw:formula="?f22 +10800"/>
                <draw:equation draw:name="f25" draw:formula="$2 -2700"/>
                <draw:equation draw:name="f26" draw:formula="?f25 *sin($1 *(pi/180))"/>
                <draw:equation draw:name="f27" draw:formula="?f25 *cos($1 *(pi/180))"/>
                <draw:equation draw:name="f28" draw:formula="?f26 +10800"/>
                <draw:equation draw:name="f29" draw:formula="?f27 +10800"/>
                <draw:equation draw:name="f30" draw:formula="($1+45)*pi/180"/>
                <draw:equation draw:name="f31" draw:formula="sqrt(((?f29-?f24)*(?f29-?f24))+((?f28-?f23)*(?f28-?f23)))"/>
                <draw:equation draw:name="f32" draw:formula="sqrt(2)/2*?f31"/>
                <draw:equation draw:name="f33" draw:formula="?f32*sin(?f30)"/>
                <draw:equation draw:name="f34" draw:formula="?f32*cos(?f30)"/>
                <draw:equation draw:name="f35" draw:formula="?f28+?f33"/>
                <draw:equation draw:name="f36" draw:formula="?f29+?f34"/>
                <draw:handle draw:handle-position="10800 $0" draw:handle-polar="10800 10800" draw:handle-radius-range-minimum="10800" draw:handle-radius-range-maximum="10800"/>
                <draw:handle draw:handle-position="$2 $1" draw:handle-polar="10800 10800" draw:handle-radius-range-minimum="0" draw:handle-radius-range-maximum="10800"/>
              </draw:enhanced-geometry>
  </draw:custom-shape>
          </xsl:when>
          <!--curved left arrow-->
          <xsl:when test="$enhancePath ='S M f38 f75 L f70 f97 L f70 f93 A f49 f79 f115 f121 A f49 f79 f123 f122 L f70 f98 Z N S M f44 f83 A f49 f79 f10 f12 L f38 f38 A f49 f79 f5 f4 Z N F M f44 f83 A f49 f79 f10 f12 L f38 f38 A f49 f79 f5 f4 L f44 f83 A f49 f79 f10 f115 L f70 f98 L f38 f75 L f70 f97 L f70 f93 A f49 f79 f115 f121 '">
            <draw:custom-shape draw:layer="layout" >
              <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
                <xsl:with-param name="sldId" select="$slideId" />
                <xsl:with-param name="grID" select ="$GraphicId"/>
                <xsl:with-param name ="prID" select="$ParaId" />
                <xsl:with-param name="TypeId" select ="$TypeId" />
                <xsl:with-param name="grpBln" select ="$grpBln" />
                <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
                <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
                <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
                <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
              </xsl:call-template>
   <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:text-areas="0 0 21600 21600"
                                        draw:mirror-vertical="true" draw:type="circular-arrow" draw:modifiers="84.1499444519454 -80.8262021942408 7331.32459905244" draw:enhanced-path="B ?f3 ?f3 ?f20 ?f20 ?f19 ?f18 ?f17 ?f16 W 0 0 21600 21600 ?f9 ?f8 ?f11 ?f10 L ?f24 ?f23 ?f36 ?f35 ?f29 ?f28 Z N">
    <xsl:attribute name ="draw:type">
                  <xsl:value-of select="'curvedLeftArrow'"/>
                </xsl:attribute>
  <xsl:attribute name ="draw:mirror-horizontal">
                  <xsl:value-of select="'true'"/>
                </xsl:attribute>
   <draw:equation draw:name="f0" draw:formula="$0 "/>
                <draw:equation draw:name="f1" draw:formula="$1 "/>
                <draw:equation draw:name="f2" draw:formula="$2 "/>
                <draw:equation draw:name="f3" draw:formula="10800+$2 "/>
                <draw:equation draw:name="f4" draw:formula="10800*sin($0 *(pi/180))"/>
                <draw:equation draw:name="f5" draw:formula="10800*cos($0 *(pi/180))"/>
                <draw:equation draw:name="f6" draw:formula="10800*sin($1 *(pi/180))"/>
                <draw:equation draw:name="f7" draw:formula="10800*cos($1 *(pi/180))"/>
                <draw:equation draw:name="f8" draw:formula="?f4 +10800"/>
                <draw:equation draw:name="f9" draw:formula="?f5 +10800"/>
                <draw:equation draw:name="f10" draw:formula="?f6 +10800"/>
                <draw:equation draw:name="f11" draw:formula="?f7 +10800"/>
                <draw:equation draw:name="f12" draw:formula="?f3 *sin($0 *(pi/180))"/>
                <draw:equation draw:name="f13" draw:formula="?f3 *cos($0 *(pi/180))"/>
                <draw:equation draw:name="f14" draw:formula="?f3 *sin($1 *(pi/180))"/>
                <draw:equation draw:name="f15" draw:formula="?f3 *cos($1 *(pi/180))"/>
                <draw:equation draw:name="f16" draw:formula="?f12 +10800"/>
                <draw:equation draw:name="f17" draw:formula="?f13 +10800"/>
                <draw:equation draw:name="f18" draw:formula="?f14 +10800"/>
                <draw:equation draw:name="f19" draw:formula="?f15 +10800"/>
                <draw:equation draw:name="f20" draw:formula="21600-?f3 "/>
                <draw:equation draw:name="f21" draw:formula="13500*sin($1 *(pi/180))"/>
                <draw:equation draw:name="f22" draw:formula="13500*cos($1 *(pi/180))"/>
                <draw:equation draw:name="f23" draw:formula="?f21 +10800"/>
                <draw:equation draw:name="f24" draw:formula="?f22 +10800"/>
                <draw:equation draw:name="f25" draw:formula="$2 -2700"/>
                <draw:equation draw:name="f26" draw:formula="?f25 *sin($1 *(pi/180))"/>
                <draw:equation draw:name="f27" draw:formula="?f25 *cos($1 *(pi/180))"/>
                <draw:equation draw:name="f28" draw:formula="?f26 +10800"/>
                <draw:equation draw:name="f29" draw:formula="?f27 +10800"/>
                <draw:equation draw:name="f30" draw:formula="($1+45)*pi/180"/>
                <draw:equation draw:name="f31" draw:formula="sqrt(((?f29-?f24)*(?f29-?f24))+((?f28-?f23)*(?f28-?f23)))"/>
                <draw:equation draw:name="f32" draw:formula="sqrt(2)/2*?f31"/>
                <draw:equation draw:name="f33" draw:formula="?f32*sin(?f30)"/>
                <draw:equation draw:name="f34" draw:formula="?f32*cos(?f30)"/>
                <draw:equation draw:name="f35" draw:formula="?f28+?f33"/>
                <draw:equation draw:name="f36" draw:formula="?f29+?f34"/>
                <draw:handle draw:handle-position="10800 $0" draw:handle-polar="10800 10800" draw:handle-radius-range-minimum="10800" draw:handle-radius-range-maximum="10800"/>
                <draw:handle draw:handle-position="$2 $1" draw:handle-polar="10800 10800" draw:handle-radius-range-minimum="0" draw:handle-radius-range-maximum="10800"/>
              </draw:enhanced-geometry>
  </draw:custom-shape>
          </xsl:when>
          <!--curved down arrow-->
          <xsl:when test="$enhancePath ='S M f73 f43 L f95 f68 L f91 f68 A f77 f47 f119 f117 L f81 f36 A f77 f47 f5 f115 L f96 f68 Z N S M f92 f104 A f77 f47 f123 f124 L f36 f43 A f77 f47 f3 f125 Z N F M f92 f104 A f77 f47 f123 f124 L f36 f43 A f77 f47 f3 f4 L f81 f36 A f77 f47 f5 f115 L f96 f68 L f73 f43 L f95 f68 L f91 f68 A f77 f47 f119 f117 '">
            <draw:custom-shape draw:layer="layout" >
              <xsl:call-template name ="CreateShape">
                <!--parameter added by yeswanth:for ODF1.1 conformance-->
                <xsl:with-param name="varHyperLinksForShapes" select="$varHyperLinksForShapes"/>
                <xsl:with-param name ="layId" select="$layId"/>
                <xsl:with-param name="sldId" select="$slideId" />
                <xsl:with-param name="grID" select ="$GraphicId"/>
                <xsl:with-param name ="prID" select="$ParaId" />
                <xsl:with-param name="TypeId" select ="$TypeId" />
                <xsl:with-param name="grpBln" select ="$grpBln" />
                <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
                <!-- Extra parameter inserted by Vijayeta,For Bullets and numbering-->
                <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
                <!--End of definition of Extra parameter inserted by Vijayeta,For Bullets and numbering-->
              </xsl:call-template>
              <draw:enhanced-geometry svg:viewBox="0 0 21600 21600" draw:text-areas="0 0 21600 21600"
                                    draw:modifiers="180 0 5500" draw:enhanced-path="B ?f3 ?f3 ?f20 ?f20 ?f19 ?f18 ?f17 ?f16 W 0 0 21600 21600 ?f9 ?f8 ?f11 ?f10 L ?f24 ?f23 ?f36 ?f35 ?f29 ?f28 Z N">
  <xsl:attribute name ="draw:type">
                  <xsl:value-of select="'curvedDownArrow'"/>
                </xsl:attribute>
 <draw:equation draw:name="f0" draw:formula="$0 "/>
                <draw:equation draw:name="f1" draw:formula="$1 "/>
                <draw:equation draw:name="f2" draw:formula="$2 "/>
                <draw:equation draw:name="f3" draw:formula="10800+$2 "/>
                <draw:equation draw:name="f4" draw:formula="10800*sin($0 *(pi/180))"/>
                <draw:equation draw:name="f5" draw:formula="10800*cos($0 *(pi/180))"/>
                <draw:equation draw:name="f6" draw:formula="10800*sin($1 *(pi/180))"/>
                <draw:equation draw:name="f7" draw:formula="10800*cos($1 *(pi/180))"/>
                <draw:equation draw:name="f8" draw:formula="?f4 +10800"/>
                <draw:equation draw:name="f9" draw:formula="?f5 +10800"/>
                <draw:equation draw:name="f10" draw:formula="?f6 +10800"/>
                <draw:equation draw:name="f11" draw:formula="?f7 +10800"/>
                <draw:equation draw:name="f12" draw:formula="?f3 *sin($0 *(pi/180))"/>
                <draw:equation draw:name="f13" draw:formula="?f3 *cos($0 *(pi/180))"/>
                <draw:equation draw:name="f14" draw:formula="?f3 *sin($1 *(pi/180))"/>
                <draw:equation draw:name="f15" draw:formula="?f3 *cos($1 *(pi/180))"/>
                <draw:equation draw:name="f16" draw:formula="?f12 +10800"/>
                <draw:equation draw:name="f17" draw:formula="?f13 +10800"/>
                <draw:equation draw:name="f18" draw:formula="?f14 +10800"/>
                <draw:equation draw:name="f19" draw:formula="?f15 +10800"/>
                <draw:equation draw:name="f20" draw:formula="21600-?f3 "/>
                <draw:equation draw:name="f21" draw:formula="13500*sin($1 *(pi/180))"/>
                <draw:equation draw:name="f22" draw:formula="13500*cos($1 *(pi/180))"/>
                <draw:equation draw:name="f23" draw:formula="?f21 +10800"/>
                <draw:equation draw:name="f24" draw:formula="?f22 +10800"/>
                <draw:equation draw:name="f25" draw:formula="$2 -2700"/>
                <draw:equation draw:name="f26" draw:formula="?f25 *sin($1 *(pi/180))"/>
                <draw:equation draw:name="f27" draw:formula="?f25 *cos($1 *(pi/180))"/>
                <draw:equation draw:name="f28" draw:formula="?f26 +10800"/>
                <draw:equation draw:name="f29" draw:formula="?f27 +10800"/>
                <draw:equation draw:name="f30" draw:formula="($1+45)*pi/180"/>
                <draw:equation draw:name="f31" draw:formula="sqrt(((?f29-?f24)*(?f29-?f24))+((?f28-?f23)*(?f28-?f23)))"/>
                <draw:equation draw:name="f32" draw:formula="sqrt(2)/2*?f31"/>
                <draw:equation draw:name="f33" draw:formula="?f32*sin(?f30)"/>
                <draw:equation draw:name="f34" draw:formula="?f32*cos(?f30)"/>
                <draw:equation draw:name="f35" draw:formula="?f28+?f33"/>
                <draw:equation draw:name="f36" draw:formula="?f29+?f34"/>
                <draw:handle draw:handle-position="10800 $0" draw:handle-polar="10800 10800" draw:handle-radius-range-minimum="10800" draw:handle-radius-range-maximum="10800"/>
                <draw:handle draw:handle-position="$2 $1" draw:handle-polar="10800 10800" draw:handle-radius-range-minimum="0" draw:handle-radius-range-maximum="10800"/>
              </draw:enhanced-geometry>
       </draw:custom-shape>
          </xsl:when>
          <!--End: Custom Shapes-->
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="tmpHyperLinkForShapesPic">
    <xsl:param name="SlideRelationId"/>
    <xsl:choose>
      <!-- Start => Go to previous slide-->
      <xsl:when test="a:hlinkClick/@action[contains(.,'jump=previousslide')]">
        <presentation:event-listener>
          <xsl:attribute name ="script:event-name">
            <xsl:value-of select ="'dom:click'"/>
          </xsl:attribute>
          <xsl:attribute name ="presentation:action">
            <xsl:value-of select ="'previous-page'"/>
          </xsl:attribute>
        </presentation:event-listener>
      </xsl:when>
      <!-- End => Go to previous slide-->
      <!-- Start => Go to Next slide -->
      <xsl:when test="a:hlinkClick/@action[contains(.,'jump=nextslide')]">
        <presentation:event-listener>
          <xsl:attribute name ="script:event-name">
            <xsl:value-of select ="'dom:click'"/>
          </xsl:attribute>
          <xsl:attribute name ="presentation:action">
            <xsl:value-of select ="'next-page'"/>
          </xsl:attribute>
        </presentation:event-listener>
      </xsl:when>
      <!-- End => Go to Next slide-->
      <!-- Start => Go to First slide -->
      <xsl:when test="a:hlinkClick/@action[contains(.,'jump=firstslide')]">
        <presentation:event-listener>
          <xsl:attribute name ="script:event-name">
            <xsl:value-of select ="'dom:click'"/>
          </xsl:attribute>
          <xsl:attribute name ="presentation:action">
            <xsl:value-of select ="'first-page'"/>
          </xsl:attribute>
        </presentation:event-listener>
      </xsl:when>
      <!-- End => Go to First slide -->
      <!-- Start => Go to Last slide -->
      <xsl:when test="a:hlinkClick/@action[contains(.,'jump=lastslide')]">
        <presentation:event-listener>
          <xsl:attribute name ="script:event-name">
            <xsl:value-of select ="'dom:click'"/>
          </xsl:attribute>
          <xsl:attribute name ="presentation:action">
            <xsl:value-of select ="'last-page'"/>
          </xsl:attribute>
        </presentation:event-listener>
      </xsl:when>
      <!-- End => Go to Last slide -->
      <!-- Start => EndShow -->
      <xsl:when test="a:hlinkClick/@action[contains(.,'jump=endshow')]">
        <presentation:event-listener>
          <xsl:attribute name ="script:event-name">
            <xsl:value-of select ="'dom:click'"/>
          </xsl:attribute>
          <xsl:attribute name ="presentation:action">
            <xsl:value-of select ="'stop'"/>
          </xsl:attribute>
        </presentation:event-listener>
      </xsl:when>
      <!-- End => End show -->
      <!-- Start => Go to Page or Object && Go to Other document && Run program  -->
      <xsl:when test="a:hlinkClick/@action[contains(.,'ppaction://hlinksldjump') or contains(.,'ppaction://hlinkfile') or contains(.,'ppaction://program') ]">
        <presentation:event-listener>
          <xsl:attribute name ="script:event-name">
            <xsl:value-of select ="'dom:click'"/>
          </xsl:attribute>
          <xsl:variable name="RelationId">
            <xsl:value-of select="a:hlinkClick/@r:id"/>
          </xsl:variable>
          <xsl:variable name="SlideVal">
            <xsl:value-of select="key('Part', $SlideRelationId)/rels:Relationships/rels:Relationship[@Id=$RelationId]/@Target"/>
          </xsl:variable>
          <!-- Condn Go to Other page/slide-->
          <xsl:if test="a:hlinkClick/@action[contains(.,'ppaction://hlinksldjump')]">
            <xsl:attribute name ="presentation:action">
              <xsl:value-of select ="'show'"/>
            </xsl:attribute>
            <xsl:attribute name ="xlink:href">
              <xsl:value-of select ="concat('#page',substring-before(substring-after($SlideVal,'slide'),'.xml'))"/>
            </xsl:attribute>
          </xsl:if>
          <!-- Condn Go to Other document-->
          <xsl:if test="a:hlinkClick/@action[contains(.,'ppaction://hlinkfile')]">
            <xsl:attribute name ="presentation:action">
              <xsl:value-of select ="'show'"/>
            </xsl:attribute>
            <xsl:attribute name ="xlink:href">
              <xsl:if test="string-length(substring-after($SlideVal,'file:///')) > 0">
                <xsl:value-of select ="concat('/',translate(substring-after($SlideVal,'file:///'),'\','/'))"/>
              </xsl:if>
              <xsl:if test="string-length(substring-after($SlideVal,'file:///')) = 0 ">
                <xsl:value-of select ="concat('../',$SlideVal)"/>
              </xsl:if>
            </xsl:attribute>
          </xsl:if>
          <!-- Condn Go to Run program-->
          <xsl:if test="a:hlinkClick/@action[contains(.,'ppaction://program') ]">
            <xsl:attribute name ="presentation:action">
              <xsl:value-of select ="'execute'"/>
            </xsl:attribute>
            <xsl:attribute name ="xlink:href">
              <xsl:if test="string-length(substring-after($SlideVal,'file:///')) > 0">
                <xsl:value-of select ="concat('/',translate(substring-after($SlideVal,'file:///'),'\','/'))"/>
              </xsl:if>
              <xsl:if test="string-length(substring-after($SlideVal,'file:///')) = 0">
                <!--added by chhavi for regression bug-->
                <xsl:choose>
                  <xsl:when test="contains($SlideVal,':/')">
                    <xsl:value-of select ="concat('/',$SlideVal)"/>
                  </xsl:when>
                  <xsl:otherwise>
                <xsl:value-of select ="concat('../',$SlideVal)"/>
                  </xsl:otherwise>
                </xsl:choose>
                <!--added by chhavi for regression end-->
              </xsl:if>
            </xsl:attribute>
          </xsl:if>
          <xsl:attribute name ="xlink:type">
            <xsl:value-of select ="'simple'"/>
          </xsl:attribute>
          <xsl:attribute name ="xlink:show">
            <xsl:value-of select ="'embed'"/>
          </xsl:attribute>
          <xsl:attribute name ="xlink:actuate">
            <xsl:value-of select ="'onRequest'"/>
          </xsl:attribute>
        </presentation:event-listener>
      </xsl:when>
      <!-- End => Go to Page or Object && Go to Other document && Run program -->
      <!-- Start => Play sound  -->
      <xsl:when test="a:hlinkClick/a:snd">
        <presentation:event-listener>
          <xsl:attribute name ="script:event-name">
            <xsl:value-of select ="'dom:click'"/>
          </xsl:attribute>
          <xsl:attribute name ="presentation:action">
            <xsl:value-of select ="'sound'"/>
          </xsl:attribute>
          <presentation:sound>
            <xsl:variable name="varMediaFileRelId">
              <xsl:value-of select="a:hlinkClick/a:snd/@r:embed"/>
            </xsl:variable>
            <xsl:variable name="varMediaFileTargetPath">
              <xsl:value-of select="key('Part', $SlideRelationId)/rels:Relationships/rels:Relationship[@Id=$varMediaFileRelId]/@Target"/>
            </xsl:variable>
            <xsl:variable name="varPptMediaFileTargetPath">
              <xsl:value-of select="concat('ppt/',substring-after($varMediaFileTargetPath,'/'))"/>
            </xsl:variable>
            <!--<xsl:variable name="varDocumentModifiedTime">
                    <xsl:value-of select="key('Part', 'docProps/core.xml')/cp:coreProperties/dcterms:modified"/>
                  </xsl:variable>-->
            <!--<xsl:variable name="varDestMediaFileTargetPath">
                    <xsl:value-of select="concat(translate($varDocumentModifiedTime,':','-'),'|',$varMediaFileRelId,'.wav')"/>
                  </xsl:variable>-->
            <!--<xsl:variable name="varMediaFilePathForOdp">
                    <xsl:value-of select="concat('../_MediaFilesForOdp_',translate($varDocumentModifiedTime,':','-'),'/',$varMediaFileRelId,'.wav')"/>
                  </xsl:variable>-->

            <xsl:variable name="FolderNameGUID">
              <xsl:call-template name="GenerateGUIDForFolderName">
                <xsl:with-param name="RootNode" select="." />
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="varDestMediaFileTargetPath">
              <xsl:value-of select="concat($FolderNameGUID,'|',$varMediaFileRelId,'.wav')"/>
            </xsl:variable>
            <xsl:variable name="varMediaFilePathForOdp">
              <xsl:value-of select="concat('../',$FolderNameGUID,'/',$varMediaFileRelId,'.wav')"/>
            </xsl:variable>
            <xsl:attribute name ="xlink:href">
              <xsl:value-of select ="$varMediaFilePathForOdp"/>
            </xsl:attribute>
            <xsl:attribute name ="xlink:type">
              <xsl:value-of select ="'simple'"/>
            </xsl:attribute>
            <xsl:attribute name ="xlink:show">
              <xsl:value-of select ="'new'"/>
            </xsl:attribute>
            <xsl:attribute name ="xlink:actuate">
              <xsl:value-of select ="'onRequest'"/>
            </xsl:attribute>
            <pzip:extract pzip:source="{$varPptMediaFileTargetPath}" pzip:target="{$varDestMediaFileTargetPath}" />
          </presentation:sound>
        </presentation:event-listener>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="a:hlinkClick/@r:id">
          <presentation:event-listener script:event-name="dom:click" presentation:action="show"
                                xlink:type="simple" xlink:show="embed" xlink:actuate="onRequest">
            <xsl:variable name="RelationId">
              <xsl:value-of select="a:hlinkClick/@r:id"/>
            </xsl:variable>
            <xsl:variable name="Target">
              <xsl:value-of select="key('Part', $SlideRelationId)/rels:Relationships/rels:Relationship[@Id=$RelationId]/@Target"/>
            </xsl:variable>
            <xsl:variable name="type">
              <xsl:value-of select="key('Part', $SlideRelationId)/rels:Relationships/rels:Relationship[@Id=$RelationId]/@Type"/>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="contains($Target,'mailto:') or contains($Target,'http:') or contains($Target,'https:')">
                <xsl:attribute name="xlink:href">
                  <xsl:value-of select="$Target"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="contains($Target,'slide')">
                <xsl:attribute name="xlink:href">
                  <xsl:value-of select="concat('#Slide ',substring-before(substring-after($Target,'slide'),'.xml'))"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="contains($Target,'file:///')">
                <xsl:attribute name="xlink:href">
                  <xsl:value-of select="concat('/',translate(substring-after($Target,'file:///'),'\','/'))"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="contains($type,'hyperlink') and not(contains($Target,'http:')) and not(contains($Target,'https:'))">
                <!-- warn if hyperlink Path  -->
                <xsl:message terminate="no">translation.oox2odf.hyperlinkTypeRelativePath</xsl:message>
                <xsl:attribute name="xlink:href">
                  <!--Link Absolute Path-->
                  <xsl:value-of select ="concat('hyperlink-path:',$Target)"/>
                  <!--End-->
                </xsl:attribute>
              </xsl:when>
            </xsl:choose>
          </presentation:event-listener>
        </xsl:if>
      </xsl:otherwise>
      <!-- End => Play sound  -->
    </xsl:choose>
  </xsl:template>
  <!-- Draw Shape reading values from pptx p:spPr-->
  <xsl:template name ="CreateShape">
	  <!--parameter added by yeswanth: ODF1.1 conformance-->
	  <xsl:param name="varHyperLinksForShapes" select="''"/>
    <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
    <xsl:param name ="sldId" />
    <xsl:param name ="grID" />
    <xsl:param name ="prID" />
    <xsl:param name ="TypeId" />
    <xsl:param name ="grpBln" />
    <xsl:param name ="flagTextBox" />
    <xsl:param name ="grpCordinates"/>
    <xsl:param name ="blnTable"/>
    <xsl:param name ="rowPosition"/>
    <!-- parameter added by chhavi:for ODF1.1 conformance-->
    <xsl:param name ="layId"/>
    
    <!-- Addition of a parameter,by Vijayets ,for bullets and numbering in shapes-->
    <xsl:param name="SlideRelationId"/>

    <xsl:attribute name ="draw:style-name">
      <xsl:value-of select ="$grID"/>
    </xsl:attribute>
    <xsl:if test="$blnTable!='true'">
    <xsl:attribute name ="draw:text-style-name">
      <xsl:value-of select ="$prID"/>
    </xsl:attribute>
    </xsl:if>
	  <!-- animation Id-->
    <xsl:choose>
		<xsl:when test="$grpBln='true'">
			<xsl:variable name="varDrawIdGrp">
				<xsl:call-template name="tmpConnected">
					<xsl:with-param name="paramId" select="./p:nvSpPr/p:cNvPr/@id"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="contains($varDrawIdGrp,'true')">
	  <xsl:attribute name ="draw:id">
		  <xsl:value-of select ="concat('sldraw',$sldId,'an',p:nvSpPr/p:cNvPr/@id)"/>
	  </xsl:attribute>
			</xsl:if>
		</xsl:when>
      <xsl:when test="$blnTable='true'"/>
      <!-- added by chhavi:for ODF1.1 conformance-->
      <xsl:when test="$layId='true'"/>
      <xsl:otherwise>
          <xsl:attribute name ="draw:id">
            <xsl:value-of select ="concat('sldraw',$sldId,'an',p:nvSpPr/p:cNvPr/@id)"/>
          </xsl:attribute>
      
      </xsl:otherwise>
    </xsl:choose>
    
    <!-- For the Grouping of Shapes Bug Fixing --><xsl:choose>
      <xsl:when test="$blnTable='true'">
        <xsl:call-template name="tmpTableCordinates">
          <xsl:with-param name="rowPosition" select ="$rowPosition" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
      <xsl:when test="$grpBln ='true'">
        <xsl:call-template name="tmpGropingWriteCordinates">
          <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="tmpWriteCordinates"/>
      </xsl:otherwise>
      </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test ="$flagTextBox='true' or $blnTable='true'">
        <draw:text-box>
          <xsl:call-template name ="AddShapeText">
            <xsl:with-param name ="prID" select ="$prID" />
            <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
            <xsl:with-param name ="sldID" select ="$sldId" />
            <!-- Addition of a parameter,by vijayeta,for bullets and numbering in shapes-->
            <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
            <xsl:with-param name="TypeId" select ="$TypeId" />
            <xsl:with-param name="blnTable" select="$blnTable"/>
          </xsl:call-template>
        </draw:text-box>
			  <!--added by yeswanth:ODF1.1 conformance-->
			  <xsl:if test="exsl:node-set($varHyperLinksForShapes)//presentation:event-listener">
				  <xsl:copy-of select="$varHyperLinksForShapes"/>
			  </xsl:if>
			  <!--end-->
      </xsl:when>
      <xsl:otherwise>
			  <!--added by yeswanth:ODF1.1 conformance-->
			  <xsl:if test="exsl:node-set($varHyperLinksForShapes)//presentation:event-listener">
				  <xsl:copy-of select="$varHyperLinksForShapes"/>
			  </xsl:if>
			  <!--end-->
        <xsl:call-template name ="AddShapeText">
          <xsl:with-param name ="prID" select ="$prID" />
          <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
          <xsl:with-param name ="sldID" select ="$sldId" />
          <!-- Addition of a parameter,by vijayeta,for bullets and numbering in shapes-->
          <xsl:with-param name="SlideRelationId" select ="$SlideRelationId" />
          <xsl:with-param name="TypeId" select ="$TypeId" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name ="tmpTableCordinates">
    <xsl:param name ="rowPosition"/>
    <xsl:variable name="x">
      <xsl:value-of select="./parent::node()/parent::node()/parent::node()/parent::node()/parent::node()/p:xfrm/a:off/@x"/>
    </xsl:variable>
    <xsl:variable name="y">
      <xsl:value-of select="./parent::node()/parent::node()/parent::node()/parent::node()/parent::node()/p:xfrm/a:off/@y"/>
    </xsl:variable>
    <xsl:variable name="cx">
      <xsl:value-of select="./parent::node()/parent::node()/parent::node()/parent::node()/parent::node()/p:xfrm/a:ext/@cx"/>
    </xsl:variable>
    <xsl:variable name="cy">
      <xsl:value-of select="./parent::node()/parent::node()/parent::node()/parent::node()/parent::node()/p:xfrm/a:ext/@cy"/>
    </xsl:variable>
    <xsl:variable name="colPosition">
      <xsl:value-of select="position()"/>
    </xsl:variable>
    <xsl:variable name="colSpan">
      <xsl:value-of select="@gridSpan"/>
    </xsl:variable>
    <xsl:variable name="rowSpan">
      <xsl:value-of select="@rowSpan"/>
    </xsl:variable>

    <xsl:variable name="Height">
      <xsl:choose>
        <xsl:when test="$rowSpan !=''">
          <xsl:variable name="SVGHeight">
            <xsl:for-each select="./parent::node()/parent::node()/a:tr[position() &gt;= $rowPosition  or position() = $rowPosition + $rowSpan -1]">
              <xsl:value-of select="concat(@h,':')"/>
            </xsl:for-each>
          </xsl:variable>
          <xsl:call-template name="tmpCellspan">
            <xsl:with-param name="strVal" select="$SVGHeight"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="./parent::node()/@h"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="Width">
      <xsl:choose>
        <xsl:when test="$colSpan !=''">
          <xsl:variable name="SVGWidth">
          <xsl:for-each select="./parent::node()/parent::node()/a:tblGrid/a:gridCol[position() &gt;= $colPosition  or position() = $colPosition + $colSpan -1]">
            <xsl:value-of select="concat(@w,':')"/>
          </xsl:for-each>
          </xsl:variable>
          <xsl:call-template name="tmpCellspan">
            <xsl:with-param name="strVal" select="$SVGWidth"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="./parent::node()/parent::node()/a:tblGrid/a:gridCol[position()=$colPosition]">
            <xsl:value-of select="@w"/>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="SVGX">
      <xsl:for-each select="./parent::node()/parent::node()/a:tblGrid/a:gridCol[position() &lt;=$colPosition] ">
        <xsl:value-of select="concat(@w,':')"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="SVGY">
      <xsl:for-each select="./parent::node()/parent::node()/a:tr[position() &lt;=$rowPosition] ">
        <xsl:value-of select="concat(@h,':')"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:attribute name ="svg:x">
      <xsl:value-of select="concat('TableCord-X:', $SVGX,'@',$colPosition,':',$x) "/>
    </xsl:attribute>
    <xsl:attribute name ="svg:y">
      <xsl:value-of select="concat('TableCord-Y:', $SVGY,'@',$rowPosition,':',$y) "/>
    </xsl:attribute>
   
    <xsl:attribute name ="svg:width">
      <xsl:call-template name="ConvertEmu">
        <xsl:with-param name="length" select="$Width"/>
        <xsl:with-param name="unit">cm</xsl:with-param>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name ="svg:height">
      <xsl:call-template name="ConvertEmu">
        <xsl:with-param name="length" select="$Height"/>
        <xsl:with-param name="unit">cm</xsl:with-param>
      </xsl:call-template>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="tmpCellspan">
    <xsl:param name="strVal"/>
    <xsl:param name="intSum" select="0"/>
    <xsl:choose>
      <xsl:when test="$strVal != ''">
        <xsl:choose>
          <xsl:when test="substring-before($strVal,':') = ''">
            <xsl:value-of select="number($intSum) + number($strVal) + $var_pos"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="intSubTotal">
              <xsl:value-of select="number($intSum) + number(substring-before($strVal,':'))"/>
            </xsl:variable>
            <xsl:call-template name="tmpCellspan">
              <xsl:with-param name="strVal" select="substring-after($strVal,':')"/>
              <xsl:with-param name="intSum" select="$intSubTotal"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$intSum"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Draw line -->
  <xsl:template name ="DrawLine">
    <xsl:param name="varShapeName"/>
    <xsl:param name ="grID" />
    <xsl:param name ="grpBln" />
    <xsl:param name="sldId" />
    <xsl:param name ="grpCordinates" />
    <!-- parameter added by chhavi:for ODF1.1 conformance-->
    <xsl:param name ="layId"/>
    <xsl:attribute name ="draw:style-name">
      <xsl:value-of select ="$grID"/>
    </xsl:attribute>
    <xsl:choose>
      <xsl:when test="$grpBln='true'"/>
      <!-- added by chhavi:for ODF1.1 conformance-->
      <xsl:when test="$layId='true'"/>
      <xsl:otherwise>
	  <xsl:attribute name ="draw:id">
		  <xsl:choose>
			  <xsl:when test="p:nvCxnSpPr/p:cNvPr/@id">
		  <xsl:value-of select ="concat('sldraw',$sldId,'an',p:nvCxnSpPr/p:cNvPr/@id)"/>
			  </xsl:when>
			  <!--condition added for p:nvSpPr in IT_Character.EN.ppt.pptx file-->
			  <!--Fix for bug#1843967 ,added by yeswanth-->
			  <xsl:when test="p:nvSpPr/p:cNvPr/@id">
				  <xsl:value-of select ="concat('sldraw',$sldId,'an',p:nvSpPr/p:cNvPr/@id)"/>
			  </xsl:when>
			  <!--End-->
		  </xsl:choose>
	  </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>    
     
	
    <xsl:choose>
      <xsl:when test="$grpBln ='true'">
        <xsl:call-template name="tmpGropingWriteCordinates">
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
          <xsl:with-param name ="ShapeType" select ="'Line'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
    <xsl:for-each select ="p:spPr/a:xfrm">
      <xsl:variable name ="xCenter">
        <xsl:value-of select ="a:off/@x + (a:ext/@cx div 2)"/>
      </xsl:variable>
      <xsl:variable name ="yCenter">
        <xsl:value-of select ="a:off/@y + (a:ext/@cy div 2)"/>
      </xsl:variable>
      <xsl:variable name ="angle">
        <xsl:if test ="not(@rot)">
          <xsl:value-of select="0" />
        </xsl:if>
        <xsl:if test ="@rot">
          <xsl:value-of select ="(@rot div 60000) * ((22 div 7) div 180)"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name ="cxBy2">
        <xsl:if test ="(@flipH = 1)">
          <xsl:value-of select ="(-1 * a:ext/@cx) div 2"/>
        </xsl:if>
        <xsl:if test ="not(@flipH) or (@flipH != 1) ">
          <xsl:value-of select ="a:ext/@cx div 2"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name ="cyBy2">
        <xsl:if test ="(@flipV = 1)">
          <xsl:value-of select ="(-1 * a:ext/@cy) div 2"/>
        </xsl:if>
        <xsl:if test ="not(@flipV) or (@flipV != 1)">
          <xsl:value-of select ="a:ext/@cy div 2"/>
        </xsl:if>
      </xsl:variable>
      <xsl:attribute name ="svg:x1">
        <xsl:value-of select ="concat('svg-x1:',$xCenter, ':', $cxBy2, ':', $cyBy2, ':', $angle)"/>
      </xsl:attribute>
      <xsl:attribute name ="svg:y1">
        <xsl:value-of select ="concat('svg-y1:',$yCenter, ':', $cxBy2, ':', $cyBy2, ':', $angle)"/>
      </xsl:attribute>
      <xsl:attribute name ="svg:x2">
        <xsl:value-of select ="concat('svg-x2:',$xCenter, ':', $cxBy2, ':', $cyBy2, ':', $angle)"/>
      </xsl:attribute>
      <xsl:attribute name ="svg:y2">
        <xsl:value-of select ="concat('svg-y2:',$yCenter, ':', $cxBy2, ':', $cyBy2, ':', $angle)"/>
      </xsl:attribute>
         </xsl:for-each>
      </xsl:otherwise>

    </xsl:choose>
    <xsl:variable name="startShapepresetGm">
      <xsl:call-template name="tmpgetpresetgm">
        <xsl:with-param name="nvprId" select="p:nvCxnSpPr/p:cNvCxnSpPr/a:stCxn/@id"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="endShapepresetGm">
      <xsl:call-template name="tmpgetpresetgm">
        <xsl:with-param name="nvprId" select="p:nvCxnSpPr/p:cNvCxnSpPr/a:endCxn/@id"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="maxstartSpgluePointCount">
      <xsl:choose>
        <xsl:when test="$startShapepresetGm='ellipse' or $startShapepresetGm='octagon' or $startShapepresetGm='noSmoking'">
          <xsl:value-of select="'8'"/>
        </xsl:when>
        <xsl:when test="$startShapepresetGm='pentagon' or $startShapepresetGm='hexagon'
                         or $startShapepresetGm='cube' or $startShapepresetGm='parallelogram'">
          <xsl:value-of select="'6'"/>
        </xsl:when>
        <xsl:when test="$startShapepresetGm='triangle' or $startShapepresetGm='rtTriangle' or $startShapepresetGm='can'">
          <xsl:value-of select="'5'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'4'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="maxendSpgluePointCount">
      <xsl:choose>
        <xsl:when test="$endShapepresetGm='ellipse' or $endShapepresetGm='octagon' or $endShapepresetGm='noSmoking'">
          <xsl:value-of select="'8'"/>
        </xsl:when>
        <xsl:when test="$endShapepresetGm='pentagon' or $endShapepresetGm='hexagon'
                         or $endShapepresetGm='cube' or $endShapepresetGm='parallelogram'">
          <xsl:value-of select="'6'"/>
        </xsl:when>
        <xsl:when test="$endShapepresetGm='triangle' or $endShapepresetGm='rtTriangle' or $endShapepresetGm='can'">
          <xsl:value-of select="'5'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'4'"/>
        </xsl:otherwise>
      </xsl:choose>
		  </xsl:variable>
		   <xsl:variable name="stGluePoint">
			  <xsl:value-of select="p:nvCxnSpPr/p:cNvCxnSpPr/a:stCxn/@idx"/>
		  </xsl:variable>
    <xsl:variable name="endGluePoint">
      <xsl:value-of select="p:nvCxnSpPr/p:cNvCxnSpPr/a:endCxn/@idx"/>
    </xsl:variable>
	  <!--<xsl:variable name="varConnectorId" select="p:nvCxnSpPr/p:cNvCxnSpPr/a:stCxn/@id"/>
	  <xsl:variable name="varPresetType">
		  <xsl:for-each select="//p:sp">
			  <xsl:if test="$varConnectorId = p:nvSpPr/p:cNvPr/@id">
				  <xsl:value-of select="p:spPr/a:prstGeom/@prst"/>
			  </xsl:if>
		  </xsl:for-each>
	  </xsl:variable>-->
	  <xsl:variable name="varPossiblePresetStrt">
		  <xsl:call-template name="tmpImpPresetType">
			  <xsl:with-param name="varCxnId" select="p:nvCxnSpPr/p:cNvCxnSpPr/a:stCxn/@id"/>
		  </xsl:call-template>
	  </xsl:variable>
	  <xsl:variable name="varPossiblePresetEnd">
		  <xsl:call-template name="tmpImpPresetType">
			  <xsl:with-param name="varCxnId" select="p:nvCxnSpPr/p:cNvCxnSpPr/a:endCxn/@id"/>
		  </xsl:call-template>
	  </xsl:variable>
    <!--modified  by vipul:for ODF1.1 conformance for draw:start-shape -->
	  <xsl:if test="(p:nvCxnSpPr/p:cNvCxnSpPr/a:stCxn/@id &gt; 2) and contains($varPossiblePresetStrt,'true') and $varShapeName = 'connector'">
		  <xsl:attribute name ="draw:start-shape">
			  <xsl:value-of select ="concat('sldraw',$sldId,'an', p:nvCxnSpPr/p:cNvCxnSpPr/a:stCxn/@id)"/>
		  </xsl:attribute>
      <xsl:if test="$varShapeName = 'connector'">
		  <xsl:attribute name ="draw:start-glue-point">
			  	  <xsl:choose>
          <xsl:when test="$maxstartSpgluePointCount &gt;4 ">
            <xsl:choose>
              <xsl:when test="$stGluePoint = 0">
                <xsl:value-of select="'0'"/>
              </xsl:when>
              <xsl:when test="number($maxstartSpgluePointCount) - number($stGluePoint) &gt;= 4">
                <xsl:value-of select="number($maxstartSpgluePointCount) - ( ( number($maxstartSpgluePointCount) - number($stGluePoint) - 4))"/>
              </xsl:when>
              <xsl:when test="number($maxstartSpgluePointCount) - number($stGluePoint) &lt; 4">
                <xsl:value-of select="number($maxstartSpgluePointCount) + ( 4 -  ( number($maxstartSpgluePointCount) - number($stGluePoint)))"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'0'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
					  <xsl:when test="$stGluePoint = 0">
						  <xsl:value-of select="'0'"/>
					  </xsl:when>
              <xsl:when test="number($maxstartSpgluePointCount) - number($stGluePoint) &gt; 0">
                <xsl:value-of select="number($maxstartSpgluePointCount) - number($stGluePoint)"/>
					  </xsl:when>
              <xsl:when test="number($maxstartSpgluePointCount) - number($stGluePoint) &lt; 0">
                <xsl:value-of select="number($maxstartSpgluePointCount) - number($stGluePoint)"/>
					  </xsl:when>
              <xsl:when test="number($maxstartSpgluePointCount) - number($stGluePoint) = 0">
                <xsl:value-of select="number($stGluePoint)"/>
					  </xsl:when>
					  <xsl:otherwise>
						  <xsl:value-of select="'0'"/>
					  </xsl:otherwise>
				  </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
		  </xsl:attribute>
		  </xsl:if>
		  </xsl:if>
		<xsl:if test="(p:nvCxnSpPr/p:cNvCxnSpPr/a:endCxn/@id &gt; 2)">
      <!--modified  by chhavi:for ODF1.1 conformance for draw:end-glue-point -->
      <xsl:if test="$varShapeName = 'connector'">
			  <xsl:attribute name ="draw:end-glue-point">
			  <xsl:choose>
          <xsl:when test="$maxendSpgluePointCount &gt;4 ">
					  <xsl:choose>
						  <xsl:when test="$endGluePoint = 0">
                <xsl:value-of select="'0'"/>
						  </xsl:when>
              <xsl:when test="number($maxendSpgluePointCount) - number($endGluePoint) &gt;= 4">
                <xsl:value-of select="number($maxendSpgluePointCount) - ( ( number($maxendSpgluePointCount) - number($endGluePoint) - 4))"/>
						  </xsl:when>
              <xsl:when test="number($maxendSpgluePointCount) - number($endGluePoint) &lt; 4">
                <xsl:value-of select="number($maxendSpgluePointCount) + ( 4 -  ( number($maxendSpgluePointCount) - number($endGluePoint)))"/>
						  </xsl:when>
						  <xsl:otherwise>
							  <xsl:value-of select="'0'"/>
						  </xsl:otherwise>
					  </xsl:choose>
				  </xsl:when>
				  <xsl:otherwise>
					  <xsl:choose>
						  <xsl:when test="$endGluePoint = 0">
							  <xsl:value-of select="'0'"/>
						  </xsl:when>
              <xsl:when test="number($maxendSpgluePointCount) - number($endGluePoint) &gt; 0">
                <xsl:value-of select="number($maxendSpgluePointCount) - number($endGluePoint)"/>
						  </xsl:when>
              <xsl:when test="number($maxendSpgluePointCount) - number($stGluePoint) &lt; 0">
                <xsl:value-of select="number($maxendSpgluePointCount) - number($endGluePoint)"/>
						  </xsl:when>
              <xsl:when test="number($maxendSpgluePointCount) - number($endGluePoint) = 0">
                <xsl:value-of select="number($endGluePoint)"/>
						  </xsl:when>
						  <xsl:otherwise>
							  <xsl:value-of select="'0'"/>
						  </xsl:otherwise>
					  </xsl:choose>
				  </xsl:otherwise>
			  </xsl:choose>

		  </xsl:attribute>
      
      <xsl:if test="contains($varPossiblePresetEnd,'true')">
		  <xsl:attribute name ="draw:end-shape">
			  <xsl:value-of select ="concat('sldraw',$sldId,'an', p:nvCxnSpPr/p:cNvCxnSpPr/a:endCxn/@id)"/>
		  </xsl:attribute>
	  </xsl:if>
      </xsl:if>
    
	  </xsl:if>
  </xsl:template>
  <xsl:template name="tmpgetpresetgm">
    <xsl:param name="nvprId"/>
    <xsl:for-each select="parent::node()/p:sp/p:nvSpPr/p:cNvPr[@id=$nvprId] | parent::node()/p:grpSp/p:sp/p:nvSpPr/p:cNvPr[@id=$nvprId]">
      <xsl:value-of select="parent::node()/parent::node()/p:spPr/a:prstGeom/@prst"/>
    </xsl:for-each>
  </xsl:template>
  <!-- Add text to the shape -->

  <xsl:template name ="AddShapeText">
    <xsl:param name ="blnTable"/>
    <!-- Extra parameter "sldId" added by lohith,requierd for template AddTextHyperlinks -->
    <xsl:param name ="sldID" />
    <xsl:param name ="prID" />
    <xsl:param name="SlideRelationId"/>
    <xsl:param name="TypeId"/>
    <xsl:variable name ="SlideNumber" select ="substring-before(substring-after($SlideRelationId,'ppt/slides/_rels/'),'.xml.rels')"/>
    <xsl:choose>
      <xsl:when test="$blnTable='true'">
        <xsl:for-each select ="a:txBody">
          <xsl:call-template name="tmpInsertShapeText">
            <xsl:with-param name="sldID" select="$sldID"/>
            <xsl:with-param name="prID" select="$prID"/>
            <xsl:with-param name="SlideRelationId" select="$SlideRelationId"/>
            <xsl:with-param name="TypeId" select="concat('SLTable',$TypeId)"/>
            <xsl:with-param name="SlideNumber" select="$SlideNumber"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
    <xsl:for-each select ="p:txBody">
          <xsl:call-template name="tmpInsertShapeText">
            <xsl:with-param name="sldID" select="$sldID"/>
            <xsl:with-param name="prID" select="$prID"/>
            <xsl:with-param name="SlideRelationId" select="$SlideRelationId"/>
            <xsl:with-param name="TypeId" select="$TypeId"/>
            <xsl:with-param name="SlideNumber" select="$SlideNumber"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  <xsl:template name="tmpInsertShapeText">
    <xsl:param name ="sldID" />
    <xsl:param name ="prID" />
    <xsl:param name="SlideRelationId"/>
    <xsl:param name="TypeId"/>
    <xsl:param name="SlideNumber"/>
      <xsl:variable name ="textNumber" select ="./parent::node()/p:nvSpPr/p:cNvPr/@id"/>
      <!--code inserted by Vijayeta,InsertStyle For Bullets and Numbering-->
      <xsl:variable name ="listStyleName">
        <xsl:value-of select ="concat($SlideNumber,'textboxshape_List',$textNumber)"/>
      </xsl:variable>
      <xsl:for-each select ="a:p">
        <!--Code Inserted by Vijayeta for Bullets And Numbering
                  check for levels and then depending on the condition,insert bullets,Layout or Master properties-->
        <xsl:if test ="a:pPr/a:buChar or a:pPr/a:buAutoNum or a:pPr/a:buBlip">
          <xsl:call-template name ="insertBulletsNumbersoox2odf">
            <xsl:with-param name ="listStyleName" select ="concat($listStyleName,position())"/>
            <xsl:with-param name ="ParaId" select ="$prID"/>
            <!-- parameters 'slideRelationId' and 'slideId' added by lohith - required to set Hyperlinks for bulleted text -->
            <xsl:with-param name="slideRelationId" select="$SlideRelationId" />
            <xsl:with-param name="slideId" select="$sldID" />
            <xsl:with-param name="TypeId" select="$TypeId" />
          </xsl:call-template>
        </xsl:if>
        <xsl:if test ="not(a:pPr/a:buChar) and not(a:pPr/a:buAutoNum)and not(a:pPr/a:buBlip)">
          <text:p >
			<xsl:attribute name ="text:id">
			   <xsl:value-of select ="concat('slText',$sldID,'an',./parent::node()/parent::node()/p:nvSpPr/p:cNvPr/@id, position())"/>
			</xsl:attribute>
            <xsl:if test="$prID!=''">
            <xsl:attribute name ="text:style-name">
              <xsl:value-of select ="concat($prID,position())"/>
            </xsl:attribute>
            </xsl:if>
            <xsl:for-each select ="node()">
              <xsl:if test ="name()='a:r'">
                <text:span>
                  <xsl:attribute name="text:style-name">
                    <xsl:value-of select="concat($TypeId,generate-id())"/>
                  </xsl:attribute>
                  <!-- varibale 'nodeTextSpan' added by lohith.ar - need to have the text inside <text:a> tag if assigned with hyperlinks -->
                  <xsl:variable name="nodeTextSpan">
                    <xsl:call-template name="tmpTextSpanNode"/>
                  </xsl:variable>
                  <!-- Added by lohith.ar - Code for text Hyperlinks -->
                  <xsl:choose>
                    <xsl:when test="node()/a:hlinkClick and not(node()/a:hlinkClick/a:snd)">
                    <xsl:choose>
                      <xsl:when test="not(node()/a:hlinkClick/@action) and (node()/a:hlinkClick/@r:id = '')">
                        <xsl:copy-of select="$nodeTextSpan"/>
                      </xsl:when>
                      <xsl:otherwise>
                   
                      <xsl:call-template name="AddTextHyperlinks">
                        <xsl:with-param name="nodeAColonR" select="node()" />
                        <xsl:with-param name="slideRelationId" select="$SlideRelationId" />
                        <xsl:with-param name="slideId" select="$sldID" />
                        <xsl:with-param name="nodeTextSpan" select="$nodeTextSpan" />
                      </xsl:call-template>
                     
                      </xsl:otherwise>
                    </xsl:choose>                    
                    </xsl:when>
                    <xsl:when test="node()/a:hlinkClick and (node()/a:hlinkClick/a:snd)">
                    <xsl:choose>
                      <xsl:when test="not(node()/a:hlinkClick/@action) and (node()/a:hlinkClick/@r:id = '')">
                      <xsl:copy-of select="$nodeTextSpan"/>
                      </xsl:when>
                      <xsl:otherwise>
                   
                      <xsl:call-template name="AddTextHyperlinks">
                        <xsl:with-param name="nodeAColonR" select="node()" />
                        <xsl:with-param name="slideRelationId" select="$SlideRelationId" />
                        <xsl:with-param name="slideId" select="$sldID" />
                        <xsl:with-param name="nodeTextSpan" select="$nodeTextSpan" />
                      </xsl:call-template>
                    
                      </xsl:otherwise>
                    </xsl:choose>                    
                    </xsl:when>
                    <xsl:when test="not(node()/a:hlinkClick and not(node()/a:hlinkClick/a:snd))">
                    <xsl:copy-of select="$nodeTextSpan"/>
                    </xsl:when>                    
                  </xsl:choose> 
                  <!-- End - Code for text Hyperlinks -->
                </text:span>
              </xsl:if >
              <xsl:if test ="name()='a:br'">
                <text:line-break/>
              </xsl:if>
              <xsl:if test="name()='a:fld' and @type='slidenum'">
              <!--Added by Sanjay for fix 1956100-->
                            <text:span>
                    <xsl:attribute name="text:style-name">
                      <xsl:value-of select="concat($TypeId,generate-id())"/>
                    </xsl:attribute>
                      <text:page-number/>
                  </text:span>
                  </xsl:if>
              <xsl:if test="name()='a:fld' and contains(@type,'datetime')">
                    <xsl:variable name="pos" select="position()"/>
                  <text:span>
                    <xsl:attribute name="text:style-name">
                      <xsl:value-of select="concat($TypeId,generate-id())"/>
                    </xsl:attribute>
                       <xsl:value-of select="concat(':::','currentDate:::@',@type)" />
                  </text:span>
                  </xsl:if>
              <!--End of 1956100-->
              <!-- Added by lohith.ar for fix 1731885-->
              <xsl:if test="name()='a:endParaRPr' and not(a:endParaRPr/a:hlinkClick)">
                <text:span>
                  <xsl:attribute name="text:style-name">
                    <xsl:value-of select="concat($TypeId,generate-id())"/>
                  </xsl:attribute>
                </text:span>
              </xsl:if>
            </xsl:for-each>
          </text:p>
          <!--Code inserted by vijayeta,for Bullets and Numbering If Bullets are present-->
        </xsl:if >
      </xsl:for-each>
      <!--If no bullets are present or default bullets-->
   </xsl:template>
  <!-- Get fill color for shape-->
  <xsl:template name="Fill">
    <xsl:param name="var_pos"/>
    <xsl:param name="FileType"/>
    <xsl:param name="flagGroup"/>
    <xsl:param name="SMName"/>
    <xsl:choose>
      <!-- No fill -->
      <xsl:when test ="p:spPr/a:noFill">
        <xsl:attribute name ="draw:fill">
          <xsl:value-of select="'none'" />
        </xsl:attribute>
        <xsl:attribute name ="draw:fill-color">
          <xsl:value-of select="'#ffffff'"/>
        </xsl:attribute>
      </xsl:when>
      <!-- Solid fill-->
      <xsl:when test ="p:spPr/a:solidFill">
        <xsl:for-each select="p:spPr/a:solidFill">
          <xsl:call-template name="tmpShapeSolidFillColor">
            <xsl:with-param name="SMName" select="$SMName"/>
                      </xsl:call-template>
                    </xsl:for-each>
                  </xsl:when>
                      <xsl:when test="p:spPr/a:blipFill and p:spPr/a:blipFill/a:blip/@r:embed ">
              <xsl:choose>
          <xsl:when test="$flagGroup='True'">
            <xsl:attribute name="draw:fill-image-name">
              <xsl:value-of select="concat($FileType,'-grpshapeImg',$var_pos)"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="draw:fill-image-name">
              <xsl:value-of select="concat($FileType,'-shapeImg',$var_pos)"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:for-each select="p:spPr">
          <xsl:call-template name="tmpPictureFillProp"/>
        </xsl:for-each>
      </xsl:when>
      <!--added by vipul for gradient fill-->
      <xsl:when test="p:spPr/a:gradFill">
        <xsl:call-template name="tmpGradFillColor">
          <xsl:with-param name="var_pos" select="$var_pos"/>
          <xsl:with-param name="FileType" select="$FileType"/>
          <xsl:with-param name="flagGroup" select="$flagGroup"/>
          <xsl:with-param name="SMName" select="$SMName"/>
        </xsl:call-template>
        </xsl:when>
      <xsl:when test ="p:style/a:fillRef">
        <xsl:for-each select="p:style/a:fillRef">
          <xsl:call-template name="tmpShapeSolidFillColor"/>
        </xsl:for-each>
        </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name ="draw:fill">
          <xsl:value-of select="'none'" />
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Get border color for shape -->
  <xsl:template name ="LineColor">
    <xsl:param name="SMName"/>
    <xsl:choose>
      <!-- No line-->
      <xsl:when test ="p:spPr/a:ln/a:noFill">
        <xsl:attribute name ="draw:stroke">
          <xsl:value-of select="'none'" />
        </xsl:attribute>
      </xsl:when>

      <!-- Solid line color-->
      <xsl:when test ="p:spPr/a:ln/a:solidFill">
        <xsl:attribute name ="draw:stroke">
          <xsl:value-of select="'solid'" />
        </xsl:attribute>
        <!-- Standard color for border-->
        <xsl:if test ="p:spPr/a:ln/a:solidFill/a:srgbClr/@val">
          <xsl:attribute name ="svg:stroke-color">
            <xsl:value-of select="concat('#',p:spPr/a:ln/a:solidFill/a:srgbClr/@val)"/>
          </xsl:attribute>
          <!-- Transparency percentage-->
          <xsl:if test="p:spPr/a:ln/a:solidFill/a:srgbClr/a:alpha/@val">
            <xsl:variable name ="alpha">
              <xsl:value-of select ="p:spPr/a:ln/a:solidFill/a:srgbClr/a:alpha/@val"/>
            </xsl:variable>
            <xsl:if test="($alpha != '') or ($alpha != 0)">
              <xsl:attribute name ="svg:stroke-opacity">
                <xsl:value-of select="concat(($alpha div 1000), '%')"/>
              </xsl:attribute>
            </xsl:if>
          </xsl:if>
        </xsl:if>
        <!-- Theme color for border-->
        <xsl:if test ="p:spPr/a:ln/a:solidFill/a:schemeClr/@val">
          <xsl:variable name="var_schemeClr" select="p:spPr/a:ln/a:solidFill/a:schemeClr/@val"/>
          <xsl:attribute name ="svg:stroke-color">
            <xsl:call-template name ="getColorCode">
              <xsl:with-param name ="color">
                <xsl:choose>
                  <xsl:when test="$SMName!=''">
                    <xsl:for-each select="key('Part', concat('ppt/slideMasters/',$SMName))//p:clrMap">
                      <xsl:call-template name="tmpThemeClr">
                        <xsl:with-param name="ClrMap" select="$var_schemeClr"/>
                      </xsl:call-template>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$var_schemeClr"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
              <xsl:with-param name ="lumMod">
                <xsl:value-of select="p:spPr/a:ln/a:solidFill/a:schemeClr/a:lumMod/@val"/>
              </xsl:with-param>
              <xsl:with-param name ="lumOff">
                <xsl:value-of select="p:spPr/a:ln/a:solidFill/a:schemeClr/a:lumOff/@val"/>
              </xsl:with-param>
              <xsl:with-param name ="shade">
                <xsl:for-each select="p:spPr/a:ln/a:solidFill/a:schemeClr/a:shade/@val">
                  <xsl:value-of select=". div 1000"/>
                </xsl:for-each>
              </xsl:with-param>
              <xsl:with-param name ="SMName" select="$SMName"/>
            </xsl:call-template>
          </xsl:attribute>
          <!-- Transparency percentage-->
          <xsl:if test="p:spPr/a:ln/a:solidFill/a:schemeClr/a:alpha/@val">
            <xsl:variable name ="alpha">
              <xsl:value-of select ="p:spPr/a:ln/a:solidFill/a:schemeClr/a:alpha/@val"/>
            </xsl:variable>
            <xsl:if test="($alpha != '') or ($alpha != 0)">
              <xsl:attribute name ="svg:stroke-opacity">
                <xsl:value-of select="concat(($alpha div 1000), '%')"/>
              </xsl:attribute>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </xsl:when>
	 <xsl:when test ="p:style/a:lnRef/@idx = 0">
			<xsl:attribute name ="draw:stroke">
				<xsl:value-of select ="'none'"/>
			</xsl:attribute>
		</xsl:when>
	  <xsl:when test ="p:style/a:lnRef/@idx &gt; 0">
            <xsl:attribute name ="draw:stroke">
              <xsl:value-of select="'solid'" />
            </xsl:attribute>
            <!--Standard color for border-->
            <xsl:if test ="p:style/a:lnRef/a:srgbClr/@val">
              <xsl:attribute name ="svg:stroke-color">
                <xsl:value-of select="concat('#',p:style/a:lnRef/a:srgbClr/@val)"/>
              </xsl:attribute>
            </xsl:if>
            <!--Theme color for border-->
            <xsl:if test ="p:style/a:lnRef/a:schemeClr/@val">
              <xsl:attribute name ="svg:stroke-color">
                <xsl:call-template name ="getColorCode">
                  <xsl:with-param name ="color">
                    <xsl:value-of select="p:style/a:lnRef/a:schemeClr/@val"/>
                  </xsl:with-param>
                  <xsl:with-param name ="lumMod">
                    <xsl:value-of select="p:style/a:lnRef/a:schemeClr/a:lumMod/@val"/>
                  </xsl:with-param>
                  <xsl:with-param name ="lumOff">
                    <xsl:value-of select="p:style/a:lnRef/a:schemeClr/a:lumOff/@val"/>
                  </xsl:with-param>
                  <xsl:with-param name ="shade">
                    <xsl:for-each select="p:style/a:lnRef/a:schemeClr/a:shade/@val">
                      <xsl:value-of select=". div 1000"/>
                    </xsl:for-each>
                  </xsl:with-param>
                  <xsl:with-param name ="SMName" select="$SMName"/>
                </xsl:call-template>
              </xsl:attribute>
                 </xsl:if>
          </xsl:when>
		<xsl:otherwise>
        <xsl:attribute name ="draw:stroke">
          <xsl:value-of select="'none'" />
        </xsl:attribute>
		</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Get line styles for shape -->
  <xsl:template name ="LineStyle">
    <xsl:param name="ThemeName"/>
    <!-- Line width-->
    <xsl:choose>
      <xsl:when test ="p:spPr/a:ln/@w &gt; 0">
        <xsl:attribute name ="svg:stroke-width">
              <xsl:value-of select="concat(format-number(p:spPr/a:ln/@w div 360000, '#.#####'), 'cm')"/>
        </xsl:attribute>
        </xsl:when>
      <xsl:when test ="p:spPr/a:ln/@w = 0">
		  <xsl:attribute name ="svg:stroke-width">
			  <xsl:value-of select="'0cm'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="p:style/a:lnRef/@idx = 0">
			<xsl:attribute name ="draw:stroke">
				<xsl:value-of select ="'none'"/>
			</xsl:attribute>
      </xsl:when>
      <xsl:when test ="p:style/a:lnRef/@idx &gt; 0">
        <xsl:variable name="idx" select="p:style/a:lnRef/@idx"/>
        <xsl:for-each select ="key('Part', $ThemeName)//a:themeElements/a:fmtScheme/a:lnStyleLst/a:ln">
          <xsl:if test="position()=$idx">
            <xsl:attribute name ="svg:stroke-width">
              <xsl:value-of select="concat(format-number(./@w div 360000, '#.#####'), 'cm')"/>
            </xsl:attribute>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
        </xsl:choose>
    <!-- Line Dash property-->
    <xsl:for-each select ="p:spPr/a:ln">
      <!--Code added by Sanjay for Bug 1953423-->
      <xsl:if test="a:noFill">
        <xsl:attribute name="draw:stroke">
          <xsl:value-of select="'none'"/>
        </xsl:attribute>
      </xsl:if>
      <!--End of 1953423-->
      <xsl:if test ="not(a:noFill)">
        <xsl:choose>
          <xsl:when test="a:custDash/a:ds">
            <xsl:choose>
              <xsl:when test="(a:custDash/a:ds/@d = 0 ) and (a:custDash/a:ds/@sp = 0)">
                <xsl:attribute name ="draw:stroke">
                  <xsl:value-of select="'solid'" />
                </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name ="draw:stroke">
                  <xsl:value-of select ="'dash'"/>
                </xsl:attribute>
                <xsl:attribute name ="draw:stroke-dash">
                  <xsl:value-of select ="'sysDash'"/>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="not(a:prstDash/@val)">
			  <xsl:choose>
				  <xsl:when test ="a:noFill">
					  <xsl:attribute name ="draw:stroke">
						  <xsl:value-of select="'none'" />
					  </xsl:attribute>
				  </xsl:when>
				  <xsl:when test ="a:solidFill">
					  <xsl:attribute name ="draw:stroke">
						  <xsl:value-of select="'solid'" />
					  </xsl:attribute>
				  </xsl:when>
				  <xsl:when test ="./parent::node()/parent::node()/p:style/a:lnRef/@idx = 0">
					  <xsl:attribute name ="draw:stroke">
						  <xsl:value-of select ="'none'"/>
					  </xsl:attribute>
				  </xsl:when>
				  <xsl:when test ="./parent::node()/parent::node()/p:style/a:lnRef/@idx &gt; 0">
					  <xsl:attribute name ="draw:stroke">
						  <xsl:value-of select="'solid'" />
					  </xsl:attribute>
				  </xsl:when>
				  <xsl:otherwise>
            <xsl:attribute name="draw:stroke">
              <xsl:value-of select ="'none'"/>
            </xsl:attribute>
				  </xsl:otherwise>
			  </xsl:choose>
          </xsl:when>
          <xsl:when test ="a:prstDash/@val='solid'">
				<xsl:attribute name ="draw:stroke">
					<xsl:value-of select ="'solid'"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name ="draw:stroke">
					<xsl:value-of select ="'dash'"/>
				</xsl:attribute>
				<xsl:attribute name ="draw:stroke-dash">
              <xsl:choose>
                <xsl:when test="(a:prstDash/@val='sysDot') and (@cap='rnd')">
                  <xsl:value-of select ="'sysDotRound'"/>
                </xsl:when>
                <xsl:when test="a:prstDash/@val='sysDot'">
                  <xsl:value-of select ="'sysDot'"/>
                </xsl:when>
                <xsl:when test ="(a:prstDash/@val='sysDash') and (@cap='rnd')">
                  <xsl:value-of select ="'sysDashRound'"/>
                </xsl:when>
                <xsl:when test ="a:prstDash/@val='sysDash'">
                  <xsl:value-of select ="'sysDash'"/>
                </xsl:when>
                <xsl:when test ="(a:prstDash/@val='dash') and (@cap='rnd')">
                  <xsl:value-of select ="'dashRound'"/>
                </xsl:when>
                <xsl:when test ="a:prstDash/@val='dash'">
                  <xsl:value-of select ="'dash'"/>
                </xsl:when>
                <xsl:when test ="(a:prstDash/@val='dashDot') and (@cap='rnd')">
                  <xsl:value-of select ="'dashDotRound'"/>
                </xsl:when>
                <xsl:when test ="a:prstDash/@val='dashDot'">
                  <xsl:value-of select ="'dashDot'"/>
                </xsl:when>
                <xsl:when test ="(a:prstDash/@val='lgDash') and (@cap='rnd')">
                  <xsl:value-of select ="'lgDashRound'"/>
                </xsl:when>
                <xsl:when test ="a:prstDash/@val='lgDash'">
                  <xsl:value-of select ="'lgDash'"/>
                </xsl:when>
                <xsl:when test ="(a:prstDash/@val='lgDashDot') and (@cap='rnd')">
                  <xsl:value-of select ="'lgDashDotRound'"/>
                </xsl:when>
                <xsl:when test ="a:prstDash/@val='lgDashDot'">
                  <xsl:value-of select ="'lgDashDot'"/>
                </xsl:when>
                <xsl:when test ="(a:prstDash/@val='lgDashDotDot') and (@cap='rnd')">
                  <xsl:value-of select ="'lgDashDotDotRound'"/>
                </xsl:when>
                <xsl:when test ="a:prstDash/@val='lgDashDotDot'">
                  <xsl:value-of select ="'lgDashDotDot'"/>
                </xsl:when>
              </xsl:choose>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:for-each >

    <!-- Line join property -->
    <xsl:choose>
      <xsl:when test ="p:spPr/a:ln/a:miter">
        <xsl:attribute name ="draw:stroke-linejoin">
          <xsl:value-of select ="'miter'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="p:spPr/a:ln/a:bevel">
        <xsl:attribute name ="draw:stroke-linejoin">
          <xsl:value-of select ="'bevel'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="p:spPr/a:ln/a:round">
        <xsl:attribute name ="draw:stroke-linejoin">
          <xsl:value-of select ="'round'"/>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>

	  <!-- Line Arrow -->
	  <!-- Head End-->
	  <xsl:for-each select ="p:spPr/a:ln/a:headEnd">
		  <xsl:if test ="@type">
			  <xsl:attribute name ="draw:marker-start">
				  <xsl:value-of select ="@type"/>
			  </xsl:attribute>
			  <xsl:variable name="lnw">
				  <xsl:call-template name="ConvertEmu">
					  <xsl:with-param name="length" select="parent::node()/parent::node()/a:ln/@w"/>
					  <xsl:with-param name="unit">cm</xsl:with-param>
				  </xsl:call-template>
			  </xsl:variable>
			  <xsl:attribute name ="draw:marker-start-width">
				  <xsl:call-template name ="getArrowSize">
					  <xsl:with-param name ="pptlw" select ="parent::node()/parent::node()/a:ln/@w" />
					  <xsl:with-param name ="lw" select ="substring-before($lnw,'cm')" />
					  <xsl:with-param name ="type" select ="@type" />
					  <xsl:with-param name ="w" select ="@w" />
					  <xsl:with-param name ="len" select ="@len" />
				  </xsl:call-template>
			  </xsl:attribute>
		  </xsl:if>
	  </xsl:for-each>


	  <!-- Tail End-->
	  <xsl:for-each select ="p:spPr/a:ln/a:tailEnd">
		  <xsl:if test ="@type">
			  <xsl:attribute name ="draw:marker-end">
				  <xsl:value-of select ="@type"/>
			  </xsl:attribute>
			  <xsl:variable name="lnw">
				  <xsl:call-template name="ConvertEmu">
					  <xsl:with-param name="length" select="parent::node()/parent::node()/a:ln/@w"/>
					  <xsl:with-param name="unit">cm</xsl:with-param>
				  </xsl:call-template>
			  </xsl:variable>
			  <xsl:attribute name ="draw:marker-end-width">
				  <xsl:call-template name ="getArrowSize">
					  <xsl:with-param name ="pptlw" select ="parent::node()/parent::node()/a:ln/@w" />
					  <xsl:with-param name ="lw" select ="substring-before($lnw,'cm')" />
					  <xsl:with-param name ="type" select ="@type" />
					  <xsl:with-param name ="w" select ="@w" />
					  <xsl:with-param name ="len" select ="@len" />
				  </xsl:call-template>
			  </xsl:attribute>
		  </xsl:if>
	  </xsl:for-each>
  </xsl:template>
	
  <!-- Get arrow size -->
	<xsl:template name ="getArrowSize">
		<xsl:param name ="pptlw" />
		<xsl:param name ="lw" />
		<xsl:param name ="type" />
		<xsl:param name ="w" />
		<xsl:param name ="len" />
    <!-- warn, arrow head and tail size -->
    <xsl:message terminate="no">translation.oox2odf.shapesTypeArrowHeadTailSize</xsl:message>
		<xsl:choose>
			<!-- selection for (top row arrow type) and (arrow size as 'arrow') -->
			<xsl:when test ="(($pptlw &gt; '24765') and ($type = 'arrow') and ($w='sm') and ($len='med')) or (($pptlw &gt; '24765') and ($type = 'arrow') and ($w='sm') and ($len='sm')) or (($pptlw &gt; '24765') and ($type = 'arrow') and ($w='sm') and ($len='lg'))">
				<xsl:value-of select ="concat(($lw) * (3.5),'cm')"/>
			</xsl:when>
			<xsl:when test ="(($pptlw &lt; '24766')  and ($type = 'arrow') and ($w='sm') and ($len='med')) or (($pptlw &lt; '24766')  and ($type = 'arrow') and ($w='sm') and ($len='sm')) or (($pptlw &lt; '24766')  and ($type = 'arrow') and ($w='sm') and ($len='lg'))">
				<xsl:value-of select ="concat($sm-med,'cm')"/>
			</xsl:when>
			<!-- selection for (top row arrow type) and non-selection of (arrow size as 'arrow') -->
			<xsl:when test ="(($pptlw &gt; '25400') and ($w='sm') and ($len='med')) or (($pptlw &gt; '25400') and ($w='sm') and ($len='sm')) or (($pptlw &gt; '25400') and ($w='sm') and ($len='lg'))">
				<xsl:value-of select ="concat(($lw) * (2),'cm')"/>
			</xsl:when>
			<xsl:when test ="(($pptlw &lt; '25401')  and ($w='sm') and ($len='med')) or (($pptlw &lt; '25401')  and ($w='sm') and ($len='sm')) or (($pptlw &lt; '25401')  and ($w='sm') and ($len='lg'))">
				<xsl:value-of select ="concat($sm-sm,'cm')"/>
			</xsl:when>

			<!-- selection for (middle row arrow type) and (arrow size as 'arrow') -->
			<xsl:when test ="(($pptlw &gt; '28575') and ($type = 'arrow')) or (($pptlw &gt; '28575') and ($type = 'arrow') and ($w='med') and ($len='sm')) or (($pptlw &gt; '28575') and ($type = 'arrow') and ($w='med') and ($len='med')) or (($pptlw &gt; '28575') and ($type = 'arrow') and ($w='med') and ($len='lg'))">
				<xsl:value-of select ="concat(($lw) * (4.5),'cm')"/>
			</xsl:when>
			<xsl:when test ="(($pptlw &lt; '28576') and ($type = 'arrow')) or (($pptlw &lt; '28576')  and ($type = 'arrow') and ($w='med') and ($len='sm')) or (($pptlw &lt; '28576')  and ($type = 'arrow') and ($w='med') and ($len='med')) or (($pptlw &lt; '28576')  and ($type = 'arrow') and ($w='med') and ($len='lg'))">
				<xsl:value-of select ="concat($med-med,'cm')"/>
			</xsl:when>
			<!-- selection for (middle row arrow type) and non-selection of (arrow size as 'arrow') -->
			<xsl:when test ="(($pptlw &gt; '28575')) or (($pptlw &gt; '28575') and ($w='med') and ($len='sm')) or (($pptlw &gt; '28575') and ($w='med') and ($len='med')) or (($pptlw &gt; '28575') and ($w='med') and ($len='lg'))">
				<xsl:value-of select ="concat(($lw) * (3),'cm')"/>
			</xsl:when>
			<xsl:when test ="(($pptlw &lt; '28576')) or (($pptlw &lt; '28576') and ($w='med') and ($len='sm')) or (($pptlw &lt; '28576') and ($w='med') and ($len='med')) or (($pptlw &lt; '28576') and ($w='med') and ($len='lg'))">
				<xsl:value-of select ="concat($med-sm,'cm')"/>
			</xsl:when>

			<!-- selection for (bottom row arrow type) and (arrow size as 'arrow') -->
			<xsl:when test ="(($pptlw &gt; '24765') and ($type = 'arrow') and ($w='lg') and ($len='med')) or  (($pptlw &gt; '24765') and ($type = 'arrow') and ($w='lg') and ($len='sm')) or (($pptlw &gt; '24765') and ($type = 'arrow') and ($w='lg') and ($len='lg'))">
				<xsl:value-of select ="concat(($lw) * (6),'cm')"/>
			</xsl:when>
			<xsl:when test ="(($pptlw &lt; '24766')  and ($type = 'arrow') and ($w='lg') and ($len='med')) or (($pptlw &lt; '24766') and ($type = 'arrow') and ($w='lg') and ($len='sm')) or (($pptlw &lt; '24766')  and ($type = 'arrow') and ($w='lg') and ($len='lg'))">
				<xsl:value-of select ="concat($lg-med,'cm')"/>
			</xsl:when>
			<!-- selection for (bottom row arrow type) and non-selection of (arrow size as 'arrow') -->
			<xsl:when test ="(($pptlw &gt; '25400') and ($w='lg') and ($len='med')) or (($pptlw &gt; '25400') and ($w='lg') and ($len='sm')) or (($pptlw &gt; '25400') and ($w='lg') and ($len='lg'))">
				<xsl:value-of select ="concat(($lw) * (5),'cm')"/>
			</xsl:when>
			<xsl:when test ="(($pptlw &lt; '25401')  and ($w='lg') and ($len='med')) or (($pptlw &lt; '25401')  and ($w='lg') and ($len='sm')) or (($pptlw &lt; '25401')  and ($w='lg') and ($len='lg'))">
				<xsl:value-of select ="concat($lg-sm,'cm')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select ="concat($med-med,'cm')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
  <!-- Get text layout for shapes -->
  <xsl:template name ="TextLayout">
    <xsl:for-each select="p:txBody/a:bodyPr">
      <xsl:choose>
        <xsl:when test="contains(@vert,'vert')">
        <xsl:call-template name="tmpShapeVerticalAlign"/>
        </xsl:when>
        <xsl:when test="@vert='horz' or not(@vert) ">
        <xsl:if test ="@anchor">
            <xsl:attribute name ="draw:textarea-vertical-align">
            <xsl:call-template name="tmpVerticalAlign"/>
        </xsl:attribute>
      </xsl:if>
        <xsl:if test ="@anchorCtr" >
          <xsl:attribute name ="draw:textarea-horizontal-align">
            <xsl:call-template name="tmpHorizontalAlign"/>
        </xsl:attribute>
      </xsl:if>
        </xsl:when>
      </xsl:choose>
     
      <xsl:call-template name="tmpInternalMargin"/>
      <xsl:call-template name="tmpWrapSpAutoFit">
        <xsl:with-param name="flagshape" select="'yes'"/>
      </xsl:call-template>
      </xsl:for-each>
  </xsl:template>
 
  <!--Text direction-->
  <xsl:template name ="getTextDirection">
    <xsl:param name ="vert" />
    <xsl:choose>
      <!--Added by Sanjay to get correct Text Direction:Fixed Bug no-1958740-->
      <xsl:when test ="$vert='vert' or $vert='eaVert'">
        <xsl:attribute name ="style:writing-mode">
        <xsl:value-of select ="'tb-rl'"/>
        </xsl:attribute>
      </xsl:when>
      <!--End of Bug no-1958740-->
      <!--<xsl:when test ="$vert = 'vert270'">
					<xsl:value-of select ="'tb-lr'"/>
				</xsl:when>
				<xsl:when test ="$vert = 'wordArtVert'">
					<xsl:value-of select ="'tb'"/>
				</xsl:when>
				<xsl:when test ="$vert = 'eaVert'">
					<xsl:value-of select ="'lr'" />
				</xsl:when>
				<xsl:when test ="$vert = 'mongolianVert'">
					<xsl:value-of select ="'lr'" />
				</xsl:when>
				<xsl:when test ="$vert = 'wordArtVertRtl'">
					<xsl:value-of select ="'lr'" />
				</xsl:when>-->
    </xsl:choose>
  </xsl:template>

	<!-- Shadow Implementation-->
	<xsl:template name ="ShapesShadow">
		<xsl:variable name ="distVal" >
			<xsl:choose>
        <xsl:when test="(@dist != '') or (@dist != 0)">
          <xsl:value-of select ="@dist"/>
				</xsl:when>
				<!-- get center selection value -->
        <xsl:when test="(@sx != '') or (@sx != 0)">
          <xsl:value-of select ="@sx"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select ="'0'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

	    <xsl:variable name ="dirVal" >
		    <xsl:choose>
        <xsl:when test="(@dir != '') or (@dir != 0)">
          <xsl:value-of select ="@dir"/>
				</xsl:when>
				<!-- get center selection value -->
        <xsl:when test="(@sy != '') or (@sy != 0)">
          <xsl:value-of select ="@sy"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select ="'0'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:attribute name ="draw:shadow">
			<xsl:value-of select="'visible'"/>
		</xsl:attribute>
				<xsl:attribute name ="draw:shadow-offset-x">
					<xsl:value-of select ="concat('shadow-offset-y:',$distVal, ':', $dirVal)"/>
				</xsl:attribute>
				<xsl:attribute name ="draw:shadow-offset-y">
					<xsl:value-of select ="concat('shadow-offset-x:',$distVal, ':', $dirVal)"/>
				</xsl:attribute>
			<!-- Theme Color -->
    <xsl:if test ="a:schemeClr/@val">
			<xsl:attribute name ="draw:shadow-color">
				<xsl:call-template name ="getColorCode">
					<xsl:with-param name ="color">
            <xsl:value-of select="a:schemeClr/@val"/>
					</xsl:with-param>
					<xsl:with-param name ="lumMod">
            <xsl:value-of select="a:schemeClr/a:lumMod/@val"/>
					</xsl:with-param>
					<xsl:with-param name ="lumOff">
            <xsl:value-of select="a:schemeClr/a:lumOff/@val"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>
			<!-- Transparency percentage-->
      <xsl:if test="a:schemeClr/a:alpha/@val">
				<xsl:variable name ="alpha">
          <xsl:value-of select ="a:schemeClr/a:alpha/@val"/>
				</xsl:variable>
				<xsl:if test="($alpha != '') or ($alpha != 0)">
					<xsl:attribute name ="draw:shadow-opacity">
						<xsl:value-of select="concat(($alpha div 1000), '%')"/>
					</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>

    <xsl:if test ="a:srgbClr/@val">
			<xsl:attribute name ="draw:shadow-color">
        <xsl:value-of select="concat('#',a:srgbClr/@val)"/>
			</xsl:attribute>
			<!-- Transparency percentage-->
      <xsl:if test="a:srgbClr/a:alpha/@val">
				<xsl:variable name ="alpha">
          <xsl:value-of select ="a:srgbClr/a:alpha/@val"/>
				</xsl:variable>
				<xsl:if test="($alpha != '') or ($alpha != 0)">
					<xsl:attribute name ="draw:shadow-opacity">
						<xsl:value-of select="concat(($alpha div 1000), '%')"/>
					</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
    <xsl:if test ="a:prstClr/@val">
			<xsl:attribute name ="draw:shadow-color">
				<xsl:value-of select="'#000000'"/>
			</xsl:attribute>
			<!-- Transparency percentage-->
      <xsl:if test="a:prstClr/a:alpha/@val">
				<xsl:variable name ="alpha">
          <xsl:value-of select ="a:prstClr/a:alpha/@val"/>
				</xsl:variable>
				<xsl:if test="($alpha != '') or ($alpha != 0)">
					<xsl:attribute name ="draw:shadow-opacity">
						<xsl:value-of select="concat(($alpha div 1000), '%')"/>
					</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>
  <xsl:template name ="PictureBorderColor">
    <xsl:for-each select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:photoAlbum[@bw=1]">
      <xsl:if test="position()=1">
      <xsl:attribute name="draw:color-mode">
        <xsl:value-of select="'greyscale'"/>
      </xsl:attribute>
      </xsl:if>
    </xsl:for-each>
    <xsl:choose>
      <!-- No line-->
      <xsl:when test ="p:spPr/a:ln/a:noFill">
        <xsl:attribute name ="draw:stroke">
          <xsl:value-of select="'none'" />
        </xsl:attribute>
      </xsl:when>
      <!-- Solid line color-->
      <xsl:when test ="p:spPr/a:ln/a:solidFill">
        <!-- Standard color for border-->
        <xsl:if test ="p:spPr/a:ln/a:solidFill/a:srgbClr/@val">
          <xsl:attribute name ="svg:stroke-color">
            <xsl:value-of select="concat('#',p:spPr/a:ln/a:solidFill/a:srgbClr/@val)"/>
          </xsl:attribute>
          <!-- Transparency percentage-->
          <xsl:if test="p:spPr/a:ln/a:solidFill/a:srgbClr/a:alpha/@val">
            <xsl:variable name ="alpha">
              <xsl:value-of select ="p:spPr/a:ln/a:solidFill/a:srgbClr/a:alpha/@val"/>
            </xsl:variable>
            <xsl:if test="($alpha != '') or ($alpha != 0)">
              <xsl:attribute name ="svg:stroke-opacity">
                <xsl:value-of select="concat(($alpha div 1000), '%')"/>
              </xsl:attribute>
            </xsl:if>
          </xsl:if>
        </xsl:if>
        <!-- Theme color for border-->
        <xsl:if test ="p:spPr/a:ln/a:solidFill/a:schemeClr/@val">
          <xsl:attribute name ="svg:stroke-color">
            <xsl:call-template name ="getColorCode">
              <xsl:with-param name ="color">
                <xsl:value-of select="p:spPr/a:ln/a:solidFill/a:schemeClr/@val"/>
              </xsl:with-param>
              <xsl:with-param name ="lumMod">
                <xsl:value-of select="p:spPr/a:ln/a:solidFill/a:schemeClr/a:lumMod/@val"/>
              </xsl:with-param>
              <xsl:with-param name ="lumOff">
                <xsl:value-of select="p:spPr/a:ln/a:solidFill/a:schemeClr/a:lumOff/@val"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <!-- Transparency percentage-->
          <xsl:if test="p:spPr/a:ln/a:solidFill/a:schemeClr/a:alpha/@val">
            <xsl:variable name ="alpha">
              <xsl:value-of select ="p:spPr/a:ln/a:solidFill/a:schemeClr/a:alpha/@val"/>
            </xsl:variable>
            <xsl:if test="($alpha != '') or ($alpha != 0)">
              <xsl:attribute name ="svg:stroke-opacity">
                <xsl:value-of select="concat(($alpha div 1000), '%')"/>
              </xsl:attribute>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </xsl:when>
      
      <xsl:otherwise>
        <!--Line reference-->
        <xsl:if test ="p:style/a:lnRef">
          <xsl:attribute name ="draw:stroke">
            <xsl:value-of select="'solid'" />
          </xsl:attribute>
          <!--Standard color for border-->
          <xsl:if test ="p:style/a:lnRef/a:srgbClr/@val">
            <xsl:attribute name ="svg:stroke-color">
              <xsl:value-of select="concat('#',p:style/a:lnRef/a:srgbClr/@val)"/>
            </xsl:attribute>
          </xsl:if>
          <!--Theme color for border-->
          <xsl:if test ="p:style/a:lnRef/a:schemeClr/@val">
            <xsl:attribute name ="svg:stroke-color">
              <xsl:call-template name ="getColorCode">
                <xsl:with-param name ="color">
                  <xsl:value-of select="p:style/a:lnRef/a:schemeClr/@val"/>
                </xsl:with-param>
                <xsl:with-param name ="lumMod">
                  <xsl:value-of select="p:style/a:lnRef/a:schemeClr/a:lumMod/@val"/>
                </xsl:with-param>
                <xsl:with-param name ="lumOff">
                  <xsl:value-of select="p:style/a:lnRef/a:schemeClr/a:lumOff/@val"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:attribute>
          </xsl:if>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="tmpFlip">
    <xsl:if test="p:spPr/a:xfrm/@flipH='1' and not(p:spPr/a:xfrm/@rot)">
      <xsl:attribute name ="draw:mirror-horizontal">
        <xsl:value-of select="'true'"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="p:spPr/a:xfrm/@flipV='1' and not(p:spPr/a:xfrm/@rot)">
      <xsl:attribute name ="draw:mirror-vertical">
        <xsl:value-of select="'true'"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
	<xsl:template name="tmpConnected">
		<xsl:param name="paramId"/>
		<xsl:for-each select="//p:cxnSp">
			<xsl:if test="($paramId = ./p:nvCxnSpPr/p:cNvCxnSpPr/a:stCxn/@id) or ($paramId = ./p:nvCxnSpPr/p:cNvCxnSpPr/a:endCxn/@id)">
				<xsl:value-of  select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="tmpImpPresetType">
		<xsl:param name="varCxnId"/>
		<xsl:for-each select="//p:sp/p:nvSpPr/p:cNvPr[@id=$varCxnId]">
      <xsl:for-each select="../..">
				<xsl:choose>
					<xsl:when test ="p:spPr/a:prstGeom/@prst='rect'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="(p:nvSpPr/p:cNvPr/@name[contains(., 'Oval')]) and (p:spPr/a:prstGeom/@prst='ellipse')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="(not(p:nvSpPr/p:cNvPr/@name[contains(., 'Ellipse ')]) or (p:nvSpPr/p:cNvPr/@name[contains(., 'Ellipse ')])) and (p:spPr/a:prstGeom/@prst='ellipse')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test = "(p:spPr/a:prstGeom/@prst='rightArrow')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test = "(p:spPr/a:prstGeom/@prst='upArrow')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test = "(p:spPr/a:prstGeom/@prst='leftArrow')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test = "(p:spPr/a:prstGeom/@prst='downArrow')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test = "(p:spPr/a:prstGeom/@prst='leftRightArrow')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test = "(p:spPr/a:prstGeom/@prst='upDownArrow')" >
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='triangle')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='rtTriangle')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='parallelogram')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='trapezoid')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='diamond')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='pentagon')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='hexagon')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='octagon')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="p:spPr/a:prstGeom/@prst='circularArrow' or p:spPr/a:prstGeom/@prst='curvedRightArrow' or p:spPr/a:prstGeom/@prst='curvedLeftArrow' or p:spPr/a:prstGeom/@prst='curvedDownArrow' or p:spPr/a:prstGeom/@prst='curvedUpArrow'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="p:spPr/a:prstGeom/@prst='leftUpArrow'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test="(p:nvSpPr/p:cNvPr/@name[contains(., 'bentUpArrow ')]) and not(p:nvSpPr/p:cNvPr/@name[contains(., 'Bent-Up Arrow ')]) and (p:spPr/a:prstGeom/@prst='bentUpArrow')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="p:spPr/a:prstGeom/@prst='bentUpArrow'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='cube')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='can')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='plus')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='noSmoking')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='foldedCorner')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='lightningBolt')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!--  Explosion 1 (Modified by A.Mathi) -->
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='irregularSeal1')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Chord (Added by A.Mathi as on 20/07/2007)-->
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='chord')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Left Bracket (Added by A.Mathi as on 20/07/2007) -->
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='leftBracket')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Right Bracket (Added by A.Mathi as on 20/07/2007) -->
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='rightBracket')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Left Brace (Added by A.Mathi as on 20/07/2007) -->
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='leftBrace')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Right Brace (Added by A.Mathi as on 23/07/2007) -->
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='rightBrace')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Rectangular Callout (modified by A.Mathi) -->
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='wedgeRectCallout')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Rounded Rectangular Callout (modified by A.Mathi) -->
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='wedgeRoundRectCallout')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Oval Callout (modified by A.Mathi) -->
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='wedgeEllipseCallout')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Cloud Callout (modified by A.Mathi) -->
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='cloudCallout')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Line Callout 1) -->
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='borderCallout1')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Line Callout 2) -->
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='borderCallout2')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Line Callout 3) -->
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='borderCallout3')">
						<xsl:value-of select="'true'"/>
					</xsl:when>

					<!-- Bent Arrow (Added by A.Mathi as on 23/07/2007) -->
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='bentArrow')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- U-Turn Arrow (Added by A.Mathi as on 23/07/2007) -->
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='uturnArrow')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Quad Arrow -->
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='quadArrow')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Block Arc -->
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='blockArc')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Notched Right Arrow -->
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='notchedRightArrow')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Pentagon -->
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='homePlate')">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Chevron -->
					<xsl:when test ="(p:spPr/a:prstGeom/@prst='chevron')">
						<xsl:value-of select="'true'"/>
					</xsl:when>

					<!--Equation Shapes-->
					<!--Equal-->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='mathEqual'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!--Not Equal-->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='mathNotEqual'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!--Plus-->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='mathPlus'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!--Minus-->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='mathMinus'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!--Multiply-->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='mathMultiply'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!--Division-->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='mathDivide'">
						<xsl:value-of select="'true'"/>
					</xsl:when>

					<xsl:when test ="p:spPr/a:prstGeom/@prst = 'line'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Straight Connector-->
					<xsl:when test ="p:spPr/a:prstGeom/@prst[contains(., 'straightConnector')]">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Elbow Connector-->
					<xsl:when test ="p:spPr/a:prstGeom/@prst[contains(., 'bentConnector')]">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!--Curved Connector-->
					<xsl:when test ="p:spPr/a:prstGeom/@prst[contains(., 'curvedConnector')]">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Custom shapes: -->
					<!-- Rounded  Rectangle -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='roundRect'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Snip Single Corner Rectangle -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='snip1Rect'">
						<xsl:value-of select="'true'"/>
					</xsl:when>

					<!-- Snip Same Side Corner Rectangle -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='snip2SameRect'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Snip Diagonal Corner Rectangle -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='snip2DiagRect'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Snip and Round Single Corner Rectangle -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='snipRoundRect'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Round Single Corner Rectangle -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='round1Rect'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Round Same Side Corner Rectangle -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='round2SameRect'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Round Diagonal Corner Rectangle -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='round2DiagRect'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Explosion 2 -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='irregularSeal2'">
						<xsl:value-of select="'true'"/>
					</xsl:when>

					<!-- Heptagon -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='heptagon'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Decagon -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='decagon'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Dodecagon -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='dodecagon'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Pie -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='pie'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Frame -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='frame'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Half Frame -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='halfFrame'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- L-Shape -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='corner'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Diagonal Stripe -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='diagStripe'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Plaque -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='plaque'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Bevel -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='bevel'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Donut -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='donut'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Teardrop -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='teardrop'">
						<xsl:value-of select="'true'"/>
					</xsl:when>

					<!-- Flow chart shapes -->

					<!-- Flowchart: Process -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartProcess'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- Flowchart: Alternate Process -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartAlternateProcess'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Decision -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartDecision'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Data -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartInputOutput'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Predefined Process-->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartPredefinedProcess'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Internal Storage -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartInternalStorage'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Document -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartDocument'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Multi document -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartMultidocument'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Terminator -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartTerminator'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Preparation -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartPreparation'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Manual Input -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartManualInput'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Manual Operation -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartManualOperation'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Connector -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartConnector'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Off-page Connector -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartOffpageConnector'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Card -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartPunchedCard'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Punched Tape -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartPunchedTape'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Summing Junction -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartSummingJunction'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Or -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartOr'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Collate -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartCollate'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Sort -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartSort'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Extract -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartExtract'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Merge-->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartMerge'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Stored Data -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartOnlineStorage'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Delay -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartDelay'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Sequential Access Storage -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartMagneticTape'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Direct Access Storage -->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartMagneticDrum'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Magnetic Disk-->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartMagneticDisk'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<!-- FlowChart: Display-->
					<xsl:when test ="p:spPr/a:prstGeom/@prst='flowChartDisplay'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="p:spPr/a:prstGeom/@prst='actionButtonBackPrevious'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="p:spPr/a:prstGeom/@prst='actionButtonForwardNext'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="p:spPr/a:prstGeom/@prst='actionButtonBeginning'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="p:spPr/a:prstGeom/@prst='actionButtonEnd'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="p:spPr/a:prstGeom/@prst='actionButtonHome'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="p:spPr/a:prstGeom/@prst='actionButtonInformation'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:when test ="p:spPr/a:prstGeom/@prst='actionButtonReturn'">
						<xsl:value-of select="'true'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'false'"/>
					</xsl:otherwise>
				</xsl:choose>
      </xsl:for-each>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet >