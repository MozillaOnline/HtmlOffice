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
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:v="urn:schemas-microsoft-com:vml"
xmlns:o="urn:schemas-microsoft-com:office:office"
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
xmlns:smil="urn:oasis:names:tc:opendocument:xmlns:smil-compatible:1.0" 
xmlns:anim="urn:oasis:names:tc:opendocument:xmlns:animation:1.0"	
xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
xmlns:exsl="http://exslt.org/common"
exclude-result-prefixes="p a r xlink rels">
  <xsl:strip-space elements="*"/>
  <xsl:preserve-space elements="a:t a:r a:p"/>
  <!--main document-->
  <xsl:template name="content">
    <xsl:message terminate="no">progress:a:p</xsl:message>
	<xsl:message terminate="no">progress:p:cSld</xsl:message>
    <office:document-content office:version="1.1">
      <office:automatic-styles>
        <!-- automatic styles for document body -->
         <xsl:call-template name ="DateFormats"/>
        <xsl:call-template name="InsertStyles"/>
        <xsl:call-template name="tmpNotesDrawingPageStyle"/>
          </office:automatic-styles>
      <office:body>
        <office:presentation>
          <xsl:call-template name ="insertTextFromHandoutMaster"/>
          <!--Added by vipul to insert notes header footer-->
          <!--start-->
          <xsl:call-template name="tmpNotesHeaderFtr"/>
          <!--end-->
          <xsl:call-template name="InsertPresentationFooter"/>
          <xsl:call-template name="InsertDrawingPage"/>
          <!-- Added by Lohith A R : Custom Slide Show -->
          <xsl:call-template name="InsertPresentationSettings"/>
        </office:presentation>
      </office:body>
    </office:document-content>
  </xsl:template>

  <!--  generates automatic styles for paragraphs  how does it exactly work ?? -->
  <xsl:variable name ="flgFooter">
    <xsl:for-each select ="key('Part', 'ppt/slides/slide1.xml')/p:sld/p:cSld/p:spTree/p:sp">
      <xsl:if test ="p:nvSpPr/p:nvPr/p:ph/@type[contains(.,'ftr')]" >
        <xsl:value-of select ="p:txBody/a:p/a:r/a:t"/>
      </xsl:if>
      <!--<xsl:value-of select ="."/>-->
    </xsl:for-each >
  </xsl:variable>
	<!--changes made by yeswanth for openoffice2.3-->
	<xsl:variable name="FolderNameGUID">
		<xsl:call-template name="GenerateGUIDForFolderName">
			<xsl:with-param name="RootNode" select="." />
		</xsl:call-template>
	</xsl:variable>
	<!--end-->
  <xsl:template name="InsertStyles">
    <!-- page Properties-->
    <xsl:for-each select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:sldIdLst/p:sldId">
      <xsl:variable name ="pageSlide">
        <xsl:value-of select ="concat(concat('ppt/slides/slide',position()),'.xml')"/>
      </xsl:variable>
      <!--added by vipul to get slide name-->
      <!--Start-->
      <xsl:variable name ="SlideFileName">
        <xsl:value-of select ="concat(concat('slide',position()),'.xml')"/>
      </xsl:variable>
         <xsl:variable name ="slideRel">
        <xsl:value-of select ="concat('ppt/slides/_rels/',$SlideFileName,'.rels')"/>
      </xsl:variable>
    <xsl:variable name ="LayoutFileName" >
        <xsl:for-each select ="key('Part', $slideRel)//node()/@Target[contains(.,'slideLayouts')]">
          <xsl:value-of  select ="substring-after(.,'../slideLayouts/')"/>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name ="LayoutFileNo">
        <xsl:value-of select="concat('ppt/slideLayouts/',$LayoutFileName)"/>
      </xsl:variable>
     
      <xsl:variable name ="LayoutRel" >
        <xsl:value-of select ="concat('ppt/slideLayouts/_rels/',$LayoutFileName,'.rels')"/>
      </xsl:variable>
      <xsl:variable name ="SMName" >
        <xsl:for-each select ="key('Part', $LayoutRel)//node()/@Target[contains(.,'slideMasters')]">
          <xsl:value-of  select ="substring-after(.,'../slideMasters/')"/>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="var_Themefile">
        <xsl:for-each select="key('Part', concat('ppt/slideMasters/_rels/',$SMName,'.rels'))//node()/@Target[contains(.,'theme')]">
          <xsl:value-of select="concat('ppt',substring-after(.,'..'))"/>
        </xsl:for-each>
      </xsl:variable>
      <!--End-->

      <!-- Page settings like footer date slide number visible/Invisible-->
      <style:style  style:family="drawing-page">
		<xsl:message terminate="no">progress:p:cSld</xsl:message>
        <xsl:attribute name ="style:name" >
          <xsl:value-of select ="concat('dp',position())"/>
        </xsl:attribute>
        <style:drawing-page-properties>
			
			<!--added by yeswanth-->
			<xsl:call-template name="SlideTransition">
				<xsl:with-param name="slidenum" select="$pageSlide"/>
			</xsl:call-template>
			<!--end of code added by yeswanth-->
          <xsl:attribute name ="presentation:background-visible" >
            <xsl:value-of select ="'true'"/>
          </xsl:attribute>
          <xsl:attribute name ="presentation:background-objects-visible" >
            <xsl:value-of select ="'true'"/>
          </xsl:attribute>
          <xsl:for-each select="key('Part', $pageSlide)/p:sld/p:cSld/p:spTree">
          <xsl:attribute name ="presentation:display-footer">
            <xsl:choose>
                    <xsl:when test="./p:sp/p:nvSpPr/p:nvPr/p:ph[@type='ftr']">
                <xsl:value-of select ="'true'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select ="'false'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name ="presentation:display-page-number" >
            <xsl:choose>
                <xsl:when test="./p:sp/p:nvSpPr/p:nvPr/p:ph[@type='sldNum']">
                <xsl:value-of select ="'true'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select ="'false'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name ="presentation:display-date-time" >
            <xsl:choose>
                <xsl:when test="./p:sp/p:nvSpPr/p:nvPr/p:ph[@type='dt']">
                <xsl:value-of select ="'true'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select ="'false'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
            <xsl:for-each select="../p:bg">
            <xsl:choose>
              <xsl:when test="p:bgPr/a:solidFill">
                <xsl:for-each select="p:bgPr/a:solidFill">
                  <xsl:call-template name="tmpShapeSolidFillColor">
                    <xsl:with-param name="SMName" select="$SMName"/>
                      </xsl:call-template>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="p:bgPr/a:gradFill">
                <xsl:call-template name="tmpBackGrndGradFillColor">
                  <xsl:with-param name="FileType" select="concat(substring-before($SlideFileName,'.xml'),'-Gradient')"/>
                          </xsl:call-template>
                  </xsl:when>
              <xsl:when test="(p:bgPr/a:blipFill or p:bgRef/a:blipFill) and p:bgPr/a:blipFill/a:blip/@r:embed ">
                  <xsl:for-each select="p:bgPr">
                    <xsl:call-template name="tmpPictureFillProp"/>
                      </xsl:for-each>
                    <xsl:attribute name="draw:fill-image-name">
                  <xsl:value-of select="concat(substring-before($SlideFileName,'.xml'),'BackImg')"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="p:bgRef and p:bgRef/@idx &gt; 1000">
              <xsl:variable name="idx" select="p:bgRef/@idx - 1000"/>
                <xsl:for-each select ="key('Part', $var_Themefile)/a:theme/a:themeElements/a:fmtScheme/a:bgFillStyleLst/child::node()[$idx]">
                      <xsl:if test="name()='a:blipFill'">
                        <xsl:if test="./a:blip/@r:embed">
                          <xsl:for-each select="..">
                          <xsl:call-template name="tmpPictureFillProp"/>
                      </xsl:for-each>
                   <xsl:attribute name="draw:fill-image-name">
                    <xsl:value-of select="concat(substring-before($SlideFileName,'.xml'),'BackImg')"/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:if>
                    </xsl:for-each>
              </xsl:when>
              <xsl:when test="p:bgRef and p:bgRef/@idx &gt; 0  and p:bgRef/@idx &lt; 1000">
                <xsl:choose>
                <xsl:when test="p:bgRef/a:srgbClr/@val">
                  <xsl:attribute name="draw:fill-color">
                    <xsl:value-of select="concat('#',p:bgRef/a:srgbClr/@val)" />
                  </xsl:attribute>
                  <xsl:attribute name="draw:fill">
                    <xsl:value-of select="'solid'"/>
                  </xsl:attribute>
                </xsl:when>
                <xsl:when test="p:bgRef/a:schemeClr/@val">
                  <xsl:attribute name="draw:fill-color">
                    <xsl:call-template name="getColorCode">
                      <xsl:with-param name="color">
                        <xsl:value-of select="p:bgRef/a:schemeClr/@val" />
                      </xsl:with-param>
                      <xsl:with-param name="lumMod">
                        <xsl:value-of select="p:bgRef/a:schemeClr/a:lumMod/@val" />
                      </xsl:with-param>
                      <xsl:with-param name="lumOff">
                        <xsl:value-of select="p:bgRef/a:schemeClr/a:lumOff/@val" />
                      </xsl:with-param>
                    </xsl:call-template>
                   </xsl:attribute>
                   <xsl:attribute name="draw:fill">
                    <xsl:value-of select="'solid'"/>
                  </xsl:attribute>
                </xsl:when>
                </xsl:choose>
              </xsl:when>
          </xsl:choose>
          </xsl:for-each>
          </xsl:for-each>
          <xsl:if test="not(key('Part', $pageSlide)/p:sld/p:cSld/p:bg)">
            <!-- GET COLOR FROM LAYOUT  -->
            <xsl:for-each select="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))//p:cSld/p:bg">
              <xsl:choose>
                <xsl:when test="p:bgPr/a:solidFill">
                  <xsl:for-each select="p:bgPr/a:solidFill">
                    <xsl:call-template name="tmpShapeSolidFillColor">
                      <xsl:with-param name="SMName" select="$SMName"/>
                        </xsl:call-template>
                  </xsl:for-each>
                </xsl:when>
                <xsl:when test="p:bgPr/a:gradFill">
                  <xsl:call-template name="tmpBackGrndGradFillColor">
                    <xsl:with-param name="FileType" select="concat(substring-before($SMName,'.xml'),substring-before($LayoutFileName,'.xml'),'-Gradient')"/>
                            </xsl:call-template>
                   </xsl:when>
                <xsl:when test="p:bgPr/a:blipFill or p:bgRef/a:blipFill and p:bgPr/a:blipFill/a:blip/@r:embed">
                  <xsl:attribute name="draw:fill-color">
                    <xsl:value-of select="'#FFFFFF'"/>
                  </xsl:attribute>
                  <xsl:attribute name="draw:fill">
                    <xsl:value-of select="'bitmap'"/>
                  </xsl:attribute>
                  <xsl:attribute name="draw:fill-image-name">
                    <xsl:value-of select="concat(substring-before($LayoutFileName,'.xml'),'BackImg')"/>
                  </xsl:attribute>
                  <!--Code Added by Sanjay to fixed the  Bug-1877299-->
                  <xsl:choose>
                    <xsl:when test="p:bgPr/a:blipFill/a:stretch/a:fillRect">
                      <xsl:attribute name="style:repeat">
                        <xsl:value-of select="'stretch'"/>
                      </xsl:attribute>
                      <xsl:attribute name="draw:fill-image-width">
                        <xsl:value-of select ="'0cm'"/>
                      </xsl:attribute>
                      <xsl:attribute name="draw:fill-image-height">
                        <xsl:value-of select ="'0cm'"/>
                      </xsl:attribute>
                    </xsl:when>
                  </xsl:choose>
                  <!--End of 1877299-->
                </xsl:when>
                <xsl:when test="p:bgRef/@idx &gt; 1000">
                  <xsl:variable name="idx" select="p:bgRef/@idx - 1000"/>
                 
                  <xsl:variable name="blnImage">
                    <xsl:for-each select ="key('Part', $var_Themefile)/a:theme/a:themeElements/a:fmtScheme/a:bgFillStyleLst/child::node()[$idx]">
                      <xsl:choose>
                        <xsl:when test="name()='a:blipFill'">
                          <xsl:choose>
                          <xsl:when test="./a:blip/@r:embed">
                          <xsl:value-of select="'1'"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="'0'"/>
                        </xsl:otherwise>
                      </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="'0'"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:variable>
                  <xsl:if test="$blnImage='1'">
                    <xsl:attribute name="draw:fill-color">
                      <xsl:value-of select="'#FFFFFF'"/>
                    </xsl:attribute>
                    <xsl:attribute name="draw:fill">
                      <xsl:value-of select="'bitmap'"/>
                    </xsl:attribute>
                    <xsl:attribute name="draw:fill-image-name">
                      <xsl:value-of select="concat(substring-before($LayoutFileName,'.xml'),'BackImg')"/>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="$blnImage='0'">
                    <xsl:if test="p:bgRef/a:schemeClr/@val">
                      <xsl:attribute name="draw:fill-color">
                        <xsl:call-template name="getColorCode">
                          <xsl:with-param name="color">
                            <xsl:variable name="ClrMap">
                              <xsl:value-of select="p:bgRef/a:schemeClr/@val" />
                            </xsl:variable>
                            <xsl:for-each select="parent::node()/parent::node()/p:clrMapOvr/a:overrideClrMapping">
                              <xsl:choose>
                                <xsl:when test="$ClrMap ='tx1'">
                                  <xsl:value-of select="@tx1" />
                                </xsl:when>
                                <xsl:when test="$ClrMap ='tx2'">
                                  <xsl:value-of select="@tx2" />
                                </xsl:when>
                                <xsl:when test="$ClrMap ='bg1'">
                                  <xsl:value-of select="@bg1" />
                                </xsl:when>
                                <xsl:when test="$ClrMap ='bg2'">
                                  <xsl:value-of select="@bg2" />
                                </xsl:when>
                              </xsl:choose>
                            </xsl:for-each>
                          </xsl:with-param>
                          <xsl:with-param name="lumMod">
                            <xsl:value-of select="p:bgRef/a:schemeClr/a:lumMod/@val" />
                          </xsl:with-param>
                          <xsl:with-param name="lumOff">
                            <xsl:value-of select="p:bgRef/a:schemeClr/a:lumOff/@val" />
                          </xsl:with-param>
                        </xsl:call-template>
                      </xsl:attribute>
                      <xsl:attribute name="draw:fill">
                        <xsl:value-of select="'solid'"/>
                      </xsl:attribute>
                    </xsl:if>
                  </xsl:if>
                </xsl:when>
                <xsl:when test="p:bgRef/@idx &gt; 0  and p:bgRef/@idx &lt; 1000">
                  <xsl:choose>
                    <xsl:when test="p:bgRef/a:srgbClr/@val">
                      <xsl:attribute name="draw:fill-color">
                        <xsl:value-of select="concat('#',p:bgRef/a:srgbClr/@val)" />
                      </xsl:attribute>
                      <xsl:attribute name="draw:fill">
                        <xsl:value-of select="'solid'"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="p:bgRef/a:schemeClr/@val">
                      <xsl:attribute name="draw:fill-color">
                        <xsl:call-template name="getColorCode">
                          <xsl:with-param name="color">
                            <xsl:variable name="ClrMap">
                              <xsl:value-of select="p:bgRef/a:schemeClr/@val" />
                            </xsl:variable>
                            <xsl:for-each select="parent::node()/parent::node()/p:clrMapOvr/a:overrideClrMapping">
                              <xsl:choose>
                                <xsl:when test="$ClrMap ='tx1'">
                                  <xsl:value-of select="@tx1" />
                                </xsl:when>
                                <xsl:when test="$ClrMap ='tx2'">
                                  <xsl:value-of select="@tx2" />
                                </xsl:when>
                                <xsl:when test="$ClrMap ='bg1'">
                                  <xsl:value-of select="@bg1" />
                                </xsl:when>
                                <xsl:when test="$ClrMap ='bg2'">
                                  <xsl:value-of select="@bg2" />
                                </xsl:when>
                              </xsl:choose>
                            </xsl:for-each>
                          </xsl:with-param>
                          <xsl:with-param name="lumMod">
                            <xsl:value-of select="p:bgRef/a:schemeClr/a:lumMod/@val" />
                          </xsl:with-param>
                          <xsl:with-param name="lumOff">
                            <xsl:value-of select="p:bgRef/a:schemeClr/a:lumOff/@val" />
                          </xsl:with-param>
                        </xsl:call-template>
                      </xsl:attribute>
                      <xsl:attribute name="draw:fill">
                        <xsl:value-of select="'solid'"/>
                      </xsl:attribute>
                    </xsl:when>
                  </xsl:choose>
                </xsl:when>
              </xsl:choose>
            </xsl:for-each>
          </xsl:if>
          <!--End-->
			<!--added by yeswanth-->
			<!--transition sound-->
			<xsl:variable name ="relSlideNumber">
				<xsl:call-template name="retString">
					<xsl:with-param name="string2rev" select="$pageSlide"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:call-template name="TransSound">
				<xsl:with-param name="slidenum" select="$pageSlide"/>
				<xsl:with-param name="pageSlide" select="concat('ppt/slides/_rels/',$relSlideNumber,'.rels')"/>
				<xsl:with-param name="FolderNameGUID" select="$FolderNameGUID"/>
			</xsl:call-template>
			<!--end of code added by yeswanth-->
			
   </style:drawing-page-properties>
      </style:style>
      <xsl:call-template name ="GetStylesFromSlide">
        <xsl:with-param name="SlidePos" select="position()"/>
        <xsl:with-param  name="LayoutFileName" select="$LayoutFileName"/>
        <xsl:with-param  name="SMName" select="$SMName"/>
        <xsl:with-param  name="ThemeName" select="$var_Themefile"/>
      </xsl:call-template>
         </xsl:for-each >
    <style:style style:name="pr1" style:family="presentation" style:parent-style-name="Default-notes">
      <style:graphic-properties >
        <xsl:attribute name ="draw:fill-color" >
          <xsl:value-of select ="'#ffffff'"/>
        </xsl:attribute>
        <xsl:for-each select="./p:txBody/a:bodyPr">
          <xsl:call-template name="tmpWrapSpAutoFit"/>
        </xsl:for-each>
      </style:graphic-properties>
    </style:style>
  </xsl:template>
  <xsl:template name ="InsertPresentationFooter" >
    <xsl:for-each select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:sldIdLst/p:sldId">
      <xsl:variable name ="footerSlide">
        <xsl:value-of select ="concat(concat('ppt/slides/slide',position()),'.xml')"/>
      </xsl:variable>
      <xsl:variable name ="footerInd">
        <xsl:value-of select ="concat('ftr',position())"/>
      </xsl:variable>
      <xsl:variable name ="dateInd">
        <xsl:value-of select ="concat('dtd',position())"/>
      </xsl:variable>
      <xsl:for-each select ="key('Part', $footerSlide)/p:sld/p:cSld/p:spTree/p:sp">
        <!--concat(concat('slide',position()),'.xml')-->
        <xsl:choose >
          <xsl:when test ="not(p:nvSpPr/p:nvPr/p:ph/@type[contains(.,'dt') or contains(.,'ftr')])">
            <!-- Do nothing-->
          </xsl:when>
          <xsl:when test ="p:nvSpPr/p:nvPr/p:ph/@type[contains(.,'ftr')]">
            <presentation:footer-decl >
              <xsl:attribute name ="presentation:name">
                <xsl:value-of select ="$footerInd"/>
              </xsl:attribute >
              <xsl:variable name="footerText">
                <xsl:for-each select="p:txBody/a:p">
                  <xsl:for-each select="a:r">
                  <xsl:value-of select ="a:t"/>
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:variable>

              <xsl:copy-of select="$footerText"/>

            </presentation:footer-decl>
          </xsl:when>
          <xsl:when test ="p:nvSpPr/p:nvPr/p:ph/@type[contains(.,'dt')]">
            <presentation:date-time-decl >
              <xsl:attribute name ="style:data-style-name">
                <xsl:call-template name ="FooterDateFormat">
                  <xsl:with-param name ="type" select ="p:txBody/a:p/a:fld/@type" />
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name ="presentation:name">
                <xsl:value-of select ="$dateInd"/>
              </xsl:attribute>
              <xsl:attribute name ="presentation:source">
                <xsl:for-each select =".">
                  <xsl:if test ="p:nvSpPr/p:nvPr/p:ph/@type[contains(.,'dt')]" >
                    <xsl:if test ="p:txBody/a:p/a:fld">
                      <xsl:value-of select ="'current-date'"/>
                    </xsl:if>
                    <xsl:if test ="not(p:txBody/a:p/a:fld)">
                      <xsl:value-of select ="'fixed'"/>
                    </xsl:if>
                  </xsl:if>
                </xsl:for-each >
              </xsl:attribute>
              <xsl:for-each select =".">
                <xsl:if test ="p:nvSpPr/p:nvPr/p:ph/@type[contains(.,'dt')]" >
                  <xsl:if test ="p:txBody/a:p/a:fld">
                    <xsl:value-of select ="p:txBody/a:p/a:fld/a:t"/>
                  </xsl:if>
                  <xsl:if test ="not(p:txBody/a:p/a:fld)">
                    <xsl:value-of select ="p:txBody/a:p/a:r/a:t"/>
                  </xsl:if>
                </xsl:if>
              </xsl:for-each >
            </presentation:date-time-decl>
          </xsl:when >
        </xsl:choose>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name ="InsertDrawingPage"  >
    <xsl:param name ="slideId"/>
<xsl:param name ="SlideFile"/>
    <xsl:for-each select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:sldIdLst/p:sldId">
      <xsl:variable name="slidePos">
        <xsl:value-of select="position()"/>
      </xsl:variable>
      <draw:page>
        <xsl:message terminate="no">progress:a:p</xsl:message>
        <!--added by vipul to link each slides with slide Master-->
        <!--Start-->
        <xsl:attribute name="draw:master-page-name">
          <xsl:call-template name ="GetMasterFileName">
            <xsl:with-param name="slideId" select ="position()"/>
          </xsl:call-template>
        </xsl:attribute>
        <!--End-->
        <xsl:attribute name ="draw:style-name">
          <xsl:value-of select ="concat('dp',position())"/>
        </xsl:attribute>
        <xsl:attribute name ="draw:name">
          <xsl:value-of select ="concat('page',position())"/>
        </xsl:attribute>
        <!--Office 2007 SP2-->
        <xsl:for-each select ="key('Part', concat('ppt/slides/slide',$slidePos,'.xml'))/p:sld/p:cSld/p:spTree/p:sp">
          <!--<xsl:for-each select ="p:cSld/p:spTree/p:sp">-->
          <xsl:if test ="p:nvSpPr/p:nvPr/p:ph/@type[contains(.,'ftr')]">
        <xsl:attribute name ="presentation:use-footer-name">
              <xsl:value-of select ="concat('ftr',$slidePos)"/>
        </xsl:attribute>
          </xsl:if>
          <xsl:if test ="p:nvSpPr/p:nvPr/p:ph/@type[contains(.,'dt')]">
        <xsl:attribute name ="presentation:use-date-time-name">
              <xsl:value-of select ="concat('dtd',$slidePos)"/>
        </xsl:attribute>
          </xsl:if>
        </xsl:for-each>
        <!--Office 2007 SP2-->

		  <!--code added for draw:id attribute in OpenOffice.org 2.3-->
		  <xsl:variable name="dpageid">
			  <xsl:value-of select="concat('pid',position())"/>
		  </xsl:variable>
		  <xsl:attribute name="draw:id">
			  <xsl:value-of select="$dpageid"/>
		  </xsl:attribute>
		  <!--end-->
        <!--Get SlideLayout type-->
        <xsl:variable name ="lyoutName">
          <xsl:call-template name ="GetLayOutName">
            <xsl:with-param name ="slideName" select ="concat(concat('slide',position()),'.xml')"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test ="$lyoutName!=''">
          <xsl:attribute name ="presentation:presentation-page-layout-name">
            <xsl:value-of select ="$lyoutName"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:call-template name ="DrawFrames">
          <xsl:with-param name ="SlideFile" select ="concat(concat('slide',position()),'.xml')" />
			<xsl:with-param name ="slideId" select ="position()"/>
        </xsl:call-template>
		  <!-- call for cutom animation  start-->
		  <xsl:call-template name ="customAnimation">
			  <xsl:with-param name ="slideId" select ="concat(concat('ppt/slides/slide',position()),'.xml')" />
			  <xsl:with-param name ="slideNo" select ="position()"/>
			  <xsl:with-param name="pageid" select="$dpageid"/>
			  <xsl:with-param name="FolderNameGUID" select="$FolderNameGUID"/>
		  </xsl:call-template >
		  <!-- call for cutom animation  end-->
        <!--End-->
      </draw:page >
    </xsl:for-each>
  </xsl:template>
 
  <xsl:template name ="DrawFrames">
	 <xsl:param name ="SlideFile"/>
	 <xsl:param name ="slideId"/>
    <xsl:message terminate="no">progress:a:p</xsl:message>
      <xsl:for-each  select="key('Part', 'ppt/_rels/presentation.xml.rels')">
        <xsl:message terminate="no">progress:a:p</xsl:message>
      <!-- added by vipul-->
      <!-- start-->
      <xsl:variable name="SlidePos" select="substring-after(substring-before($SlideFile,'.xml'),'slide')"/>
      <!-- End-->
      <xsl:variable name ="slideNo">
        <xsl:value-of select ="concat('slides/',$SlideFile)"/>
      </xsl:variable>
      <xsl:variable name ="slideRel">
        <xsl:value-of select ="concat(concat('ppt/slides/_rels/',$SlideFile),'.rels')"/>
      </xsl:variable>
      
      <xsl:variable name ="SlideID">
        <xsl:value-of select ="concat('slide',$SlidePos)"/>
      </xsl:variable>
      <xsl:variable name ="slideLayotRel">
        <xsl:value-of select ="'ppt/slideMasters/_rels'"/>
      </xsl:variable>
         <!-- added by Vipul to insert shapes and Pictures from Layout-->
      <!--Start-->
      <xsl:variable name ="LayoutFileNoo">
        <xsl:for-each select ="key('Part', $slideRel)//node()/@Target[contains(.,'slideLayouts')]">
          <xsl:value-of select ="concat('ppt',substring(.,3))"/>
        </xsl:for-each>
      </xsl:variable>
        <xsl:variable name ="var_LayoutName">
            <xsl:value-of select ="substring-after($LayoutFileNoo,'slideLayouts/')"/>
        </xsl:variable>
      <xsl:variable name="lytFileName">
        <xsl:value-of select="substring-after(substring-after($LayoutFileNoo,'/'),'/')"/>
      </xsl:variable>
      <xsl:for-each select="key('Part', $LayoutFileNoo)/p:sldLayout/p:cSld/p:spTree">
         <xsl:for-each select="node()">
           <xsl:message terminate="no">progress:a:p</xsl:message>
          <xsl:choose>
            <xsl:when test="name()='p:pic'">
              <!-- warn, layouts to slide mapping-->
              <xsl:message terminate="no">translation.oox2odf.layoutsToSlideMappingTypePicture</xsl:message>
              <!--Added by sanjay -->
              <xsl:for-each select=".">            
                <xsl:if test="not(p:nvPicPr/p:nvPr/a:audioFile or p:nvPicPr/p:nvPr/a:wavAudioFile or p:nvPicPr/p:nvPr/a:videoFile)">
                <xsl:call-template name="InsertPicture">
                  <xsl:with-param name ="slideRel" select ="concat('ppt/slideLayouts/_rels/',$var_LayoutName,'.rels')"/>
                    <xsl:with-param name="sourceName" select="'content'"/>
                    <xsl:with-param name ="slideId" select ="$slideId"/>
					<xsl:with-param name ="source" select ="'Layout'"/>
                </xsl:call-template>
                </xsl:if>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="name()='p:sp'">
              <!-- warn, layouts to slide mapping-->
              <xsl:message terminate="no">translation.oox2odf.layoutsToSlideMappingTypeShapes</xsl:message>
              <xsl:message terminate="no">progress:a:p</xsl:message>
              <xsl:variable name="var_pos" select="position()"/>
              <xsl:for-each select=".">
                <xsl:if test="not(p:nvSpPr/p:nvPr/p:ph)">
                  <xsl:variable  name ="GraphicId">
                    <xsl:value-of select ="concat('SL',$SlidePos,'LYT','gr',$var_pos)"/>
                  </xsl:variable>
                  <xsl:variable name ="ParaId">
                    <xsl:value-of select ="concat('SL',$SlidePos,'LYT','PARA',$var_pos)"/>
                 </xsl:variable>
                 <xsl:call-template name ="shapes">
                   <!-- parameter added by chhavi:for ODF1.1 conformance-->
                   <xsl:with-param name ="layId" select="'true'"/>
                <xsl:with-param name="GraphicId" select ="$GraphicId"/>
                <xsl:with-param name ="ParaId" select="$ParaId" />
                 <xsl:with-param name ="TypeId" select="concat('SL',$SlidePos)" />
                   <xsl:with-param name ="slideId"  select ="$SlideID"/>
                   <xsl:with-param name="SlideRelationId" select ="concat('ppt/slideLayouts/_rels/',$var_LayoutName,'.rels')"/>
                 </xsl:call-template>
             </xsl:if>
          </xsl:for-each>
            </xsl:when>
            <xsl:when test="name()='p:cxnSp'">
              <!-- warn, layouts to slide mapping-->
              <xsl:message terminate="no">translation.oox2odf.layoutsToSlideMappingTypeLines</xsl:message>
              <xsl:variable name="var_pos" select="position()"/>
              <xsl:for-each select=".">
                <xsl:variable  name ="GraphicId">
                  <xsl:value-of select ="concat('SL',$SlidePos,'LYT','grLine',$var_pos)"/>
                </xsl:variable>
                <xsl:variable name ="ParaId">
                  <xsl:value-of select ="concat('SL',$SlidePos,'LYT','PARA',$var_pos)"/>
                </xsl:variable>
                <xsl:call-template name ="shapes">
                  <xsl:with-param name ="layId" select="'true'"/>
                  <xsl:with-param name="GraphicId" select ="$GraphicId"/>
                  <xsl:with-param name ="ParaId" select="$ParaId" />
                  <xsl:with-param name ="TypeId" select="concat('SL',$SlidePos)" />
                  <xsl:with-param name ="slideId"  select ="$SlideID"/>
                  <xsl:with-param name="SlideRelationId" select ="concat('ppt/slideLayouts/_rels/',$var_LayoutName,'.rels')"/>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="name()='p:grpSp'">
              <xsl:variable name ="drawAnimId">
				  <!--changes made by yeswanth on 29/April/08-->
				  <!--<xsl:value-of select ="concat('sldraw',$slideId,'an',p:nvSpPr/p:cNvPr/@id)"/>-->
				  <xsl:value-of select ="concat('sldraw',$slideId,'an',p:nvGrpSpPr/p:cNvPr/@id)"/>
              </xsl:variable>
              <xsl:variable name="var_pos" select="position()"/>
              <xsl:variable name="TopLevelgrpCordinates">
                <xsl:call-template name="tmpGetgroupTransformValues"/>
              </xsl:variable>
              <xsl:call-template name ="tmpGroupedShapes">
                <xsl:with-param name ="SlidePos" select="concat('SL',$SlidePos)" />
                <xsl:with-param name ="SlideID"  select ="$SlideID" />
                <xsl:with-param name ="pos"  select ="$var_pos" />
                <xsl:with-param name ="drawAnimId"  select ="$drawAnimId" />
                <xsl:with-param name ="SlideRelationId" select ="concat('ppt/slideLayouts/_rels/',$var_LayoutName,'.rels')"/>
                <xsl:with-param name ="grpCordinates" select ="$TopLevelgrpCordinates" />
                <!-- parameter added by chhavi:for ODF1.1 conformance-->
                <xsl:with-param name ="layId" select="'true'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="name()='p:graphicFrame'">
				<!--
			  Defect: 2948303,PPTX:Loss of OLE Object(Office2010)
			  By:Vijayeta
			  Desc: Changed xpath to accomodate other nodes that appear in Office 2010 viz. mc:AlternateContent
			  -->
     <xsl:if test="./a:graphic/a:graphicData//child::node()[name()='p:oleObj']">
	<!--<xsl:if test="./a:graphic/a:graphicData/p:oleObj or ./a:graphic/a:graphicData/mc:AlternateContent/mc:Fallback/p:oleObj">-->
                <xsl:call-template name="tmpOLEObjects">
                  <xsl:with-param name ="SlideRelationId" select ="concat('ppt/slideLayouts/_rels/',$var_LayoutName,'.rels')"/>
                </xsl:call-template>
              </xsl:if>

              <xsl:if test="./a:graphic/a:graphicData/a:tbl">
                <xsl:call-template name="tmpCreateTable">
                  <xsl:with-param name ="TypeId" select="$SlideID" />
                  <!--parameter added by yeswanth.s : for getting hyperlink from the .rels file using rId-->
                  <xsl:with-param name ="slideRel" select ="concat('ppt/slideLayouts/_rels/',$var_LayoutName,'.rels')"/>
                </xsl:call-template>
              </xsl:if>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>

      </xsl:for-each>
      <!--End-->
      <xsl:for-each select="key('Part', concat('ppt/',$slideNo))/p:sld/p:cSld/p:spTree">
       
        <xsl:for-each select="node()">
          <xsl:message terminate="no">progress:a:p</xsl:message>
          <xsl:choose>
            <xsl:when test="name()='p:pic'">
              <xsl:for-each select=".">
                <xsl:if test="p:nvPicPr/p:nvPr/a:audioFile or p:nvPicPr/p:nvPr/a:wavAudioFile or p:nvPicPr/p:nvPr/a:videoFile">
                  <xsl:call-template name="InsertPicture">
                    <xsl:with-param name ="slideRel" select ="$slideRel"/>
                    <xsl:with-param name="audio" select="'audio'"/>                   
					<xsl:with-param name ="slideId" select ="$slideId"/>
                  </xsl:call-template>
                </xsl:if>
                <xsl:if test="not(p:nvPicPr/p:nvPr/a:audioFile or p:nvPicPr/p:nvPr/a:wavAudioFile or p:nvPicPr/p:nvPr/a:videoFile)">
                  <xsl:call-template name="InsertPicture">
                    <xsl:with-param name ="slideRel" select ="$slideRel"/>
                    <xsl:with-param name="sourceName" select="'content'"/>
				    <xsl:with-param name ="slideId" select ="$slideId"/>
                  </xsl:call-template>
                </xsl:if>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="name()='p:sp'">
              <xsl:variable name="var_pos" select="position()"/>
              <!--<xsl:for-each select=".">-->
                <xsl:choose>
                  <xsl:when test="not(p:nvSpPr/p:nvPr/p:ph)">
                      <xsl:variable  name ="GraphicId">
                        <xsl:value-of select ="concat('SL',$SlidePos,'gr',$var_pos)"/>
                      </xsl:variable>
                      <xsl:variable name ="ParaId">
                        <xsl:value-of select ="concat('SL',$SlidePos,'PARA',$var_pos)"/>
                      </xsl:variable>
                      <xsl:call-template name ="shapes">
                        <xsl:with-param name="GraphicId" select ="$GraphicId"/>
                        <xsl:with-param name ="ParaId" select="$ParaId" />
                        <xsl:with-param name ="TypeId" select="$SlideID" />
                        <xsl:with-param name="SlideRelationId" select="$slideRel"/>
                        <xsl:with-param name="var_pos" select="$var_pos"/>
						<xsl:with-param name ="slideId" select ="$slideId"/>
                      </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <!-- Code for getting caps attribute from Layout-->
                    <xsl:variable name ="layoutCap">
                      <xsl:call-template name ="getAllCapsFromLayout">
                        <xsl:with-param name ="layOutRelId" select ="$slideRel"/>
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name ="bulletTypeBool">
                      <xsl:for-each select ="key('Part', $slideRel)//rels:Relationships/rels:Relationship">
                      <!--<xsl:if test ="key('Part', $slideRel)//rels:Relationships/rels:Relationship/@Target[contains(.,'slideLayouts')]">-->
                      <xsl:if test ="@Target[contains(.,'slideLayouts')]">
                          <xsl:variable name ="layout" select ="substring-after((@Target),'../slideLayouts/')"/>
                          <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$layout))//p:sldLayout">
                            <xsl:choose >
                              <!-- Changes made by vijayeta, bug fix, 1739703, date:10-7-07-->
                              <!-- Fix for the bug, number 45,Internal Defects.xls date 8th aug '07-->
                              <xsl:when test ="p:cSld/@name[contains(.,'Content')] or p:cSld/@name[contains(.,'Title,')] or p:cSld/@name[contains(.,'Title and')] or p:cSld/@name[contains(.,'Two Content')] or  p:cSld/@name[contains(.,'Comparison')]">
                                <xsl:value-of select ="'true'"/>
                              </xsl:when>
                              <xsl:otherwise >
                                <xsl:value-of select ="'false'"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:for-each>
                        </xsl:if>
                      </xsl:for-each>
                    </xsl:variable >
                    <!--End of code Inserted by Vijayeta for Bullets and Numbering,in case of default bullets-->
                    <xsl:variable name ="LayoutName">
                      <xsl:for-each select ="p:nvSpPr/p:nvPr/p:ph/@type">
                        <xsl:value-of select ="."/>
                      </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name ="var_index">
                      <xsl:for-each select ="p:nvSpPr/p:nvPr/p:ph/@idx">
                        <xsl:value-of select ="."/>
                      </xsl:for-each>
                    </xsl:variable>
                    <!--Fix for bug 1, internal defects.xls, date : 13th aug'07-->
                    <xsl:variable name="var_TextBoxType">
                      <xsl:choose>
                        <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='body' and p:nvSpPr/p:nvPr/p:ph/@idx ">
                          <xsl:value-of select="'outline'"/>
                        </xsl:when>
                        <xsl:when test="not(p:nvSpPr/p:nvPr/p:ph/@type) and p:nvSpPr/p:nvPr/p:ph/@idx ">
                          <xsl:value-of select="'outline'"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="''"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>
                    <!--End of Fix for bug 1, internal defects.xls, date : 13th aug'07-->
                    <xsl:variable name ="ParaId">
                      <xsl:value-of select ="concat(substring($SlideFile,1,string-length($SlideFile)-4),concat('PARA',$var_pos))"/>
                    </xsl:variable>
                    <xsl:variable name ="textLayoutId"  >
                      <xsl:value-of  select ="concat(substring-before($SlideFile,'.xml'),'pr',$var_pos)"/>
                    </xsl:variable>
                    <!--code Inserted by Vijayeta for Bullets and Numbering,Assign a style name-->
                    <xsl:variable name ="listStyleName">
                      <xsl:value-of select ="concat(substring-before($SlideFile,'.xml'),'List',$var_pos)"/>
                    </xsl:variable>
					          <xsl:variable name ="drawAnimId">
						  <xsl:value-of select ="concat('sldraw',$slideId,'an',p:nvSpPr/p:cNvPr/@id)"/>
					</xsl:variable>
                    <xsl:variable name="var_textNode">
                      <draw:text-box>
                        <xsl:for-each select ="p:txBody/a:p">
                          <xsl:variable name ="level">
                            <xsl:choose>
                              <xsl:when test="a:pPr/@lvl">
                                <xsl:value-of select ="a:pPr/@lvl + 1 "/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select ="'1'"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:variable>
                          <xsl:variable name ="buFlag">
                            <xsl:choose>
                              <xsl:when test="$LayoutName='body'">
                                <xsl:choose>
                                  <xsl:when test="$var_index != ''">
                                    <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$lytFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type=$LayoutName and @idx=$var_index]">
                                      <xsl:call-template name="tmpcheckbulletFlage">
                                        <xsl:with-param name="level" select="$level"/>
                                      </xsl:call-template>
                                    </xsl:for-each>
                                  </xsl:when>
                                  <xsl:when test="$var_index = ''">
                                    <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$lytFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type=$LayoutName and not(@idx)]">
                                      <xsl:call-template name="tmpcheckbulletFlage">
                                        <xsl:with-param name="level" select="$level"/>
                                      </xsl:call-template>
                                    </xsl:for-each>
                                  </xsl:when>
                                </xsl:choose>
                              </xsl:when>
                              <xsl:when test="$LayoutName='' and $var_index != ''">
                                <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$lytFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[not(@type) and @idx=$var_index]">
                                  <xsl:call-template name="tmpcheckbulletFlage">
                                    <xsl:with-param name="level" select="$level"/>
                                  </xsl:call-template>
                                </xsl:for-each>
                              </xsl:when>
                              <xsl:when test="$LayoutName='subTitle' and $var_index != ''">
                                <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$lytFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type=$LayoutName and @idx=$var_index]">
                                  <xsl:call-template name="tmpcheckbulletFlage">
                                    <xsl:with-param name="level" select="$level"/>
                                  </xsl:call-template>
                                </xsl:for-each>
                              </xsl:when>
                              <xsl:when test="$LayoutName='subTitle' and $var_index = ''">
                                <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$lytFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type=$LayoutName and not(@idx)]">
                                  <xsl:call-template name="tmpcheckbulletFlage">
                                    <xsl:with-param name="level" select="$level"/>
                                  </xsl:call-template>
                                </xsl:for-each>
                              </xsl:when>
                            </xsl:choose>
                          </xsl:variable>
                          <xsl:if test ="$LayoutName != 'title' and $LayoutName !='ctrTitle'">
                            <!--Code Inserted by Vijayeta for Bullets And Numbering
                                      check for levels and then depending on the condition,insert bullets,Layout or Master properties-->
                            <xsl:if test ="a:pPr/a:buChar or a:pPr/a:buAutoNum or a:pPr/a:buBlip">
                              <xsl:call-template name ="insertBulletsNumbersoox2odf">
                                <xsl:with-param name ="listStyleName" select ="concat($listStyleName,position())"/>
                                <xsl:with-param name ="ParaId" select ="$ParaId"/>
                                <!-- parameters 'slideRelationId' and 'slideId' added by lohith - required to set Hyperlinks for bulleted text -->
                                <xsl:with-param name="slideRelationId" select="$slideRel" />
                                <xsl:with-param name="slideId" select="substring-before($SlideFile,'.xml')" />
                                <xsl:with-param name="TypeId" select="$SlideID" />
                              </xsl:call-template>
                            </xsl:if>
                            <!-- If no bullets are present or default bullets-->
                            <xsl:if test ="not(a:pPr/a:buChar) and not(a:pPr/a:buAutoNum)and not(a:pPr/a:buBlip)">

                              <xsl:if test="$buFlag='true'">
                                <xsl:if test ="$var_index!=''">
                                  <!--<xsl:if test="not(./@type) or ./@type='body'">-->
                                  <xsl:call-template name ="insertBulletsNumbersoox2odf">
                                    <xsl:with-param name ="listStyleName" select ="concat($listStyleName,position())"/>
                                    <xsl:with-param name ="ParaId" select ="$ParaId"/>
                                    <xsl:with-param name="TypeId" select="$SlideID" />
                                    <!-- parameters 'slideRelationId' and 'slideId' added by lohith - required to set Hyperlinks for bulleted text -->
                                    <xsl:with-param name="slideRelationId" select="$slideRel" />
                                    <xsl:with-param name="slideId" select="substring-before($SlideFile,'.xml')" />
                                  </xsl:call-template>
                                </xsl:if>
                                <xsl:if test ="$var_index ='' ">
                                  <text:p>
                                    <xsl:attribute name ="text:style-name">
                                      <xsl:value-of select ="concat($ParaId,position())"/>
                                    </xsl:attribute>
                                    <xsl:attribute name ="text:id" >
                                      <xsl:value-of  select ="concat('slText',$slideId,'an',parent::node()/parent::node()/p:nvSpPr/p:cNvPr/@id,position())"/>
                                    </xsl:attribute>
                                    <xsl:for-each select ="node()">
                                      <xsl:if test ="name()='a:r'">
                                        <text:span>
                                          <xsl:attribute name="text:style-name">
                                            <xsl:value-of select="concat($SlideID,generate-id())"/>
                                          </xsl:attribute>
                                          <!-- varibale 'nodeTextSpan' added by lohith.ar - need to have the text inside <text:a> tag if assigned with hyperlinks -->
                                          <xsl:variable name="nodeTextSpan">
                                            <!--<xsl:value-of select ="a:t"/>-->
                                            <!--converts whitespaces sequence to text:s-->
                                            <!-- 1699083 bug fix  -->
                                            <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
                                            <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
                                            <xsl:choose >
                                              <xsl:when test ="a:rPr[@cap!='none'] or ($layoutCap !='none' and $layoutCap!='')">
                                                <xsl:choose >
                                                  <xsl:when test =".=''">
                                                    <text:s/>
                                                  </xsl:when>
                                                  <xsl:when test ="not(contains(.,'  '))">
                                                    <xsl:value-of select ="translate(.,$lcletters,$ucletters)"/>
                                                  </xsl:when>
                                                  <xsl:when test =". =' '">
                                                    <text:s/>
                                                  </xsl:when>
                                                  <xsl:otherwise >
                                                    <xsl:call-template name ="InsertWhiteSpaces">
                                                      <xsl:with-param name ="string" select ="translate(.,$lcletters,$ucletters)"/>
                                                    </xsl:call-template>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                              </xsl:when>
                                              <xsl:otherwise >
                                                <xsl:choose >
                                                  <xsl:when test =".=''">
                                                    <text:s/>
                                                  </xsl:when>
                                                  <xsl:when test ="not(contains(.,'  '))">
                                                    <xsl:value-of select ="."/>
                                                  </xsl:when>
                                                  <xsl:otherwise >
                                                    <xsl:call-template name ="InsertWhiteSpaces">
                                                      <xsl:with-param name ="string" select ="."/>
                                                    </xsl:call-template>
                                                  </xsl:otherwise >
                                                </xsl:choose>
                                              </xsl:otherwise>
                                            </xsl:choose>
                                          </xsl:variable>
                                          <!-- Added by lohith.ar - Code for text Hyperlinks -->
                                          <xsl:if test="node()/a:hlinkClick">                                            
                                              <xsl:call-template name="AddTextHyperlinks">
                                                <xsl:with-param name="nodeAColonR" select="node()" />
                                                <xsl:with-param name="slideRelationId" select="$slideRel" />
                                                <xsl:with-param name="slideId" select="substring-before($SlideFile,'.xml')" />
                                                <xsl:with-param name="nodeTextSpan" select="$nodeTextSpan" />
                                              </xsl:call-template>
                                             
                                          </xsl:if>
                                          <xsl:if test="not(node()/a:hlinkClick)">
                                            <xsl:copy-of select="$nodeTextSpan"/>
                                          </xsl:if>
                                        </text:span>
                                      </xsl:if >
                                      <xsl:if test ="name()='a:br'">
                                        <text:line-break/>
                                      </xsl:if>
                                      <!-- Added by lohith.ar for fix 1731885-->
                                      <xsl:if test="name()='a:endParaRPr' and not(a:endParaRPr/a:hlinkClick)">
                                        <text:span>
                                          <xsl:attribute name="text:style-name">
                                            <xsl:value-of select="concat($SlideID,generate-id())"/>
                                          </xsl:attribute>
                                        </text:span>
                                      </xsl:if>
                                    </xsl:for-each>
                                  </text:p>
                                </xsl:if>
                              </xsl:if>
                            </xsl:if>
                            <!-- If no bullets present at all-->
                            <xsl:if test ="not($buFlag='true') and not(a:pPr/a:buChar) and not(a:pPr/a:buAutoNum)and not(a:pPr/a:buBlip)">
                              <xsl:if test ="$var_TextBoxType='outline'">
                                <xsl:call-template name ="insertBulletsNumbersoox2odf">
                                  <xsl:with-param name ="listStyleName" select ="concat($listStyleName,position())"/>
                                  <xsl:with-param name ="ParaId" select ="$ParaId"/>
                                  <xsl:with-param name="TypeId" select="$SlideID" />
                                  <!-- parameters 'slideRelationId' and 'slideId' added by lohith - required to set Hyperlinks for bulleted text -->
                                  <xsl:with-param name="slideRelationId" select="$slideRel" />
                                  <xsl:with-param name="slideId" select="substring-before($SlideFile,'.xml')" />
                                </xsl:call-template>
                              </xsl:if>
                              <xsl:if test ="$var_TextBoxType=''">
                                <text:p >
                                  <xsl:attribute name ="text:style-name">
                                    <xsl:value-of select ="concat($ParaId,position())"/>
                                  </xsl:attribute>
                                  <xsl:attribute name ="text:id" >
                                    <xsl:value-of  select ="concat('slText',$slideId,'an',parent::node()/parent::node()/p:nvSpPr/p:cNvPr/@id,position())"/>
                                  </xsl:attribute>
                                  <xsl:for-each select ="node()">
                                    <xsl:if test ="name()='a:r'">
                                      <text:span>
                                        <xsl:attribute name="text:style-name">
                                          <xsl:value-of select="concat($SlideID,generate-id())"/>
                                        </xsl:attribute>
                                        <!-- varibale 'nodeTextSpan' added by lohith.ar - need to have the text inside <text:a> tag if assigned with hyperlinks -->
                                        <xsl:variable name="nodeTextSpan">
                                        <xsl:call-template name="tmpTextSpanNode"/>
                                        </xsl:variable>
                                        <!-- Added by lohith.ar - Code for text Hyperlinks -->
                                        <xsl:if test="node()/a:hlinkClick">
                                         
                                            <xsl:call-template name="AddTextHyperlinks">
                                              <xsl:with-param name="nodeAColonR" select="node()" />
                                              <xsl:with-param name="slideRelationId" select="$slideRel" />
                                              <xsl:with-param name="slideId" select="substring-before($SlideFile,'.xml')" />
                                              <xsl:with-param name="nodeTextSpan" select="$nodeTextSpan" />
                                            </xsl:call-template>
                                          
                                        </xsl:if>
                                        <xsl:if test="not(node()/a:hlinkClick)">
                                          <xsl:copy-of select="$nodeTextSpan"/>
                                        </xsl:if>
                                      </text:span>

                                    </xsl:if >
                                    <xsl:if test ="name()='a:br'">
                                      <text:line-break/>
                                    </xsl:if>
                                    <!-- Added by lohith.ar for fix 1731885-->
                                    <xsl:if test="name()='a:endParaRPr' and not(a:endParaRPr/a:hlinkClick)">
                                      <text:span>
                                        <xsl:attribute name="text:style-name">
                                          <xsl:value-of select="concat($SlideID,generate-id())"/>
                                        </xsl:attribute>
                                      </text:span>
                                    </xsl:if>
                                  </xsl:for-each>
                                </text:p>
                              </xsl:if>
                            </xsl:if>
                          </xsl:if >
                          <xsl:if test ="$LayoutName = 'title' or $LayoutName ='ctrTitle'">
                            <xsl:choose>
                              <xsl:when test ="a:pPr/a:buChar or a:pPr/a:buAutoNum or a:pPr/a:buBlip">
                                <xsl:call-template name ="insertBulletsNumbersoox2odf">
                                  <xsl:with-param name ="listStyleName" select ="concat($listStyleName,position())"/>
                                  <xsl:with-param name ="ParaId" select ="$ParaId"/>
                                  <!-- parameters 'slideRelationId' and 'slideId' added by lohith - required to set Hyperlinks for bulleted text -->
                                  <xsl:with-param name="slideRelationId" select="$slideRel" />
                                  <xsl:with-param name="slideId" select="substring-before($SlideFile,'.xml')" />
                                  <xsl:with-param name="TypeId" select="$SlideID" />
                                </xsl:call-template>
                              </xsl:when>
                              <xsl:otherwise>
                            <text:p >
                              <xsl:attribute name ="text:style-name">
                                <xsl:value-of select ="concat($ParaId,position())"/>
                              </xsl:attribute>
                              <xsl:attribute name ="text:id" >
                                    <xsl:value-of  select ="concat('slText',$slideId,'an',parent::node()/parent::node()/p:nvSpPr/p:cNvPr/@id,position())"/>
                              </xsl:attribute>
                              <xsl:for-each select ="node()">
                                <xsl:if test ="name()='a:r'">
                                  <text:span>
                                    <xsl:attribute name="text:style-name">
                                      <xsl:value-of select="concat($SlideID,generate-id())"/>
                                    </xsl:attribute>
                                    <!-- varibale 'nodeTextSpan' added by lohith.ar - need to have the text inside <text:a> tag if assigned with hyperlinks -->
                                    <xsl:variable name="nodeTextSpan">
                                      <!--<xsl:value-of select ="a:t"/>-->
                                      <!--converts whitespaces sequence to text:s-->
                                      <!-- 1699083 bug fix  -->
                                      <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
                                      <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
                                      <xsl:choose >
                                        <xsl:when test ="a:rPr[@cap!='none'] or ($layoutCap !='none' and $layoutCap!='')">
                                          <xsl:choose >
                                            <xsl:when test =".=''">
                                              <text:s/>
                                            </xsl:when>
                                            <xsl:when test ="not(contains(.,'  '))">
                                              <xsl:value-of select ="translate(.,$lcletters,$ucletters)"/>
                                            </xsl:when>
                                            <xsl:when test =". =' '">
                                              <text:s/>
                                            </xsl:when>
                                            <xsl:otherwise >
                                              <xsl:call-template name ="InsertWhiteSpaces">
                                                <xsl:with-param name ="string" select ="translate(.,$lcletters,$ucletters)"/>
                                              </xsl:call-template>
                                            </xsl:otherwise>
                                          </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise >
                                          <xsl:choose >
                                            <xsl:when test =".=''">
                                              <text:s/>
                                            </xsl:when>
                                            <xsl:when test ="not(contains(.,'  '))">
                                              <xsl:value-of select ="."/>
                                            </xsl:when>
                                            <xsl:otherwise >
                                              <xsl:call-template name ="InsertWhiteSpaces">
                                                <xsl:with-param name ="string" select ="."/>
                                              </xsl:call-template>
                                            </xsl:otherwise >
                                          </xsl:choose>
                                        </xsl:otherwise>
                                      </xsl:choose>
                                    </xsl:variable>
                                    <!-- Added by lohith.ar - Code for text Hyperlinks -->
                                    <xsl:if test="node()/a:hlinkClick">
                                     
                                        <xsl:call-template name="AddTextHyperlinks">
                                          <xsl:with-param name="nodeAColonR" select="node()" />
                                          <xsl:with-param name="slideRelationId" select="$slideRel" />
                                          <xsl:with-param name="slideId" select="substring-before($SlideFile,'.xml')" />
                                          <xsl:with-param name="nodeTextSpan" select="$nodeTextSpan" />
                                        </xsl:call-template>
                                      
                                     
                                    </xsl:if>
                                    <xsl:if test="not(node()/a:hlinkClick)">
                                      <xsl:copy-of select="$nodeTextSpan"/>
                                    </xsl:if>
                                  </text:span>
                                </xsl:if >
                                <xsl:if test ="name()='a:br'">
                                  <text:line-break/>
                                </xsl:if>
                                <!-- Added by lohith.ar for fix 1731885-->
                                <xsl:if test="name()='a:endParaRPr' and not(a:endParaRPr/a:hlinkClick)">
                                  <text:span>
                                    <xsl:attribute name="text:style-name">
                                      <xsl:value-of select="concat($SlideID,generate-id())"/>
                                    </xsl:attribute>
                                  </text:span>
                                </xsl:if>
                              </xsl:for-each>
                            </text:p>
                              </xsl:otherwise>
                            </xsl:choose>
                            </xsl:if>
                        </xsl:for-each>
                      </draw:text-box >
                    </xsl:variable>
                    <xsl:choose >
                      <!--<xsl:when test ="not(contains(p:nvSpPr/p:cNvPr/@name,'Title')
						   or contains(p:nvSpPr/p:cNvPr/@name,'Content')
						   or contains(p:nvSpPr/p:cNvPr/@name,'Subtitle')
						  or contains(p:nvSpPr/p:cNvPr/@name,'Placeholder')
              or contains(p:nvSpPr/p:nvPr/p:ph/@type,'ctrTitle')
              or contains(p:nvSpPr/p:nvPr/p:ph/@type,'subTitle')
              or contains(p:nvSpPr/p:nvPr/p:ph/@type,'outline')
              or contains(p:nvSpPr/p:nvPr/p:ph/@type,'title')
              or contains(p:nvSpPr/p:nvPr/p:ph/@type,'body')
						  or p:nvSpPr/p:nvPr/p:ph/@idx)">
                      </xsl:when>-->
                      <xsl:when test ="p:nvSpPr/p:nvPr/p:ph/@type[contains(.,'dt') 
							or contains(.,'ftr') or contains(.,'sldNum')]">
                        <!-- Do nothing-->
                        <!-- These will be covered in footer and date time -->
                      </xsl:when>
                      <xsl:when test ="p:spPr/a:xfrm/a:off">
                        <draw:frame draw:layer="layout" 																
                                presentation:user-transformed="true">
                          <xsl:attribute name ="presentation:style-name">
                            <xsl:value-of select ="$textLayoutId"/>
                          </xsl:attribute>
                          <xsl:attribute name ="presentation:class">
                            <xsl:call-template name ="LayoutType">
                              <xsl:with-param name ="LayoutStyle">
                                <xsl:value-of select ="$LayoutName"/>
                              </xsl:with-param>
                            </xsl:call-template >
                          </xsl:attribute>
			                    <xsl:attribute name ="draw:id" >
				<xsl:value-of  select ="$drawAnimId"/>
			  </xsl:attribute>
                          <!--Added by Vipul for rotation-->
                          <!--Start-->
                          <xsl:call-template name="tmpWriteCordinates"/>
                          <xsl:copy-of select ="$var_textNode"/>
                          <!--End-->
                          
                          <!-- Added by lohith.ar - Start - Mouse click hyperlinks -->
							<xsl:variable name="varEventListener">
                          <office:event-listeners>
                            <xsl:for-each select ="p:txBody/a:p">
                              <xsl:choose>
                                <!-- Start => Go to previous slide-->
                                <xsl:when test="a:endParaRPr/a:hlinkClick/@action[contains(.,'jump=previousslide')]">
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
                                <xsl:when test="a:endParaRPr/a:hlinkClick/@action[contains(.,'jump=nextslide')]">
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
                                <xsl:when test="a:endParaRPr/a:hlinkClick/@action[contains(.,'jump=firstslide')]">
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
                                <xsl:when test="a:endParaRPr/a:hlinkClick/@action[contains(.,'jump=lastslide')]">
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
                                <xsl:when test="a:endParaRPr/a:hlinkClick/@action[contains(.,'jump=endshow')]">
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
                                <xsl:when test="a:endParaRPr/a:hlinkClick/@action[contains(.,'ppaction://hlinksldjump') or contains(.,'ppaction://hlinkfile') or contains(.,'ppaction://program') ]">
                                  <presentation:event-listener>
                                    <xsl:attribute name ="script:event-name">
                                      <xsl:value-of select ="'dom:click'"/>
                                    </xsl:attribute>
                                    <xsl:variable name="RelationId">
                                      <xsl:value-of select="a:endParaRPr/a:hlinkClick/@r:id"/>
                                    </xsl:variable>
                                    <xsl:variable name="SlideVal">
                                      <xsl:value-of select="key('Part', $slideRel)/rels:Relationships/rels:Relationship[@Id=$RelationId]/@Target"/>
                                    </xsl:variable>
                                    <!-- Condn Go to Other page/slide-->
                                    <xsl:if test="a:endParaRPr/a:hlinkClick/@action[contains(.,'ppaction://hlinksldjump')]">
                                      <xsl:attribute name ="presentation:action">
                                        <xsl:value-of select ="'show'"/>
                                      </xsl:attribute>
                                      <xsl:attribute name ="xlink:href">
                                        <xsl:value-of select ="concat('#page',substring-before(substring-after($SlideVal,'slide'),'.xml'))"/>
                                      </xsl:attribute>
                                    </xsl:if>
                                    <!-- Condn Go to Other document-->
                                    <xsl:if test="a:endParaRPr/a:hlinkClick/@action[contains(.,'ppaction://hlinkfile')]">
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
                                    <xsl:if test="a:endParaRPr/a:hlinkClick/@action[contains(.,'ppaction://program') ]">
                                      <xsl:attribute name ="presentation:action">
                                        <xsl:value-of select ="'execute'"/>
                                      </xsl:attribute>
                                      <xsl:attribute name ="xlink:href">
                                        <xsl:if test="string-length(substring-after($SlideVal,'file:///')) > 0">
                                          <xsl:value-of select ="concat('/',translate(substring-after($SlideVal,'file:///'),'\','/'))"/>
                                        </xsl:if>
                                        <xsl:if test="string-length(substring-after($SlideVal,'file:///')) = 0">
                                          <xsl:value-of select ="concat('../',$SlideVal)"/>
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
                                <!-- Start => Paly sound  -->
                                <xsl:when test="a:endParaRPr/a:hlinkClick/a:snd">
                                  <presentation:event-listener>
                                    <xsl:attribute name ="script:event-name">
                                      <xsl:value-of select ="'dom:click'"/>
                                    </xsl:attribute>
                                    <xsl:attribute name ="presentation:action">
                                      <xsl:value-of select ="'sound'"/>
                                    </xsl:attribute>
                                    <presentation:sound>
                                      <xsl:variable name="varMediaFileRelId">
                                        <xsl:value-of select="a:endParaRPr/a:hlinkClick/a:snd/@r:embed"/>
                                      </xsl:variable>
                                      <xsl:variable name="varMediaFileTargetPath">
                                        <xsl:value-of select="key('Part', $slideRel)/rels:Relationships/rels:Relationship[@Id=$varMediaFileRelId]/@Target"/>
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

                                      <xsl:variable name="FolderNameGUID">
                                        <xsl:call-template name="GenerateGUIDForFolderName">
                                          <xsl:with-param name="RootNode" select="." />
                                        </xsl:call-template>
                                      </xsl:variable>

                                      <xsl:variable name="varDestMediaFileTargetPath">
                                        <xsl:value-of select="concat($FolderNameGUID,'|',$varMediaFileRelId,'.wav')"/>
                                      </xsl:variable>

                                      <!--<xsl:variable name="varMediaFilePathForOdp">
                            <xsl:value-of select="concat('../_MediaFilesForOdp_',translate($varDocumentModifiedTime,':','-'),'/',$varMediaFileRelId,'.wav')"/>
                          </xsl:variable>-->

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
                                <!-- End => Paly sound  -->
                              </xsl:choose>
                            </xsl:for-each>
                          </office:event-listeners>
							</xsl:variable>
							<xsl:if test="exsl:node-set($varEventListener)//presentation:event-listener">
								<xsl:copy-of select="$varEventListener"/>
							</xsl:if>
                          
                          <!-- End - Mouse click hyperlinks-->
                        </draw:frame >
                      </xsl:when>
                      <!-- If Slide layout files have the frame properties-->
                      <xsl:when test ="not(p:nvSpPr/p:nvPr/p:ph/@type[contains(.,$LayoutName)]
								and p:spPr/a:xfrm/a:off)" >
                        <xsl:variable name ="frameName">
                          <xsl:choose>
                            <xsl:when test ="p:nvSpPr/p:nvPr/p:ph/@type">
                            <xsl:for-each select ="p:nvSpPr/p:nvPr/p:ph/@type">
                              
                                <xsl:choose>
                                  <xsl:when test=".='ctrTitle'">
                                    <xsl:value-of select ="'Title'"/>
                                  </xsl:when>
                                  <xsl:otherwise>
                              <xsl:value-of select ="."/>
                                  </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="not(p:nvSpPr/p:nvPr/p:ph/@type)">
                            <xsl:for-each select ="p:nvSpPr/p:nvPr/p:ph/@idx">
                              <xsl:value-of select ="."/>
                            </xsl:for-each>
                            </xsl:when >
                          </xsl:choose>
                        
                        </xsl:variable>
                        <xsl:variable name ="FrameIdx">
                          <xsl:if test ="p:nvSpPr/p:nvPr/p:ph/@idx">
                            <xsl:for-each select ="p:nvSpPr/p:nvPr/p:ph[@idx]">
                              <xsl:value-of select ="@idx"/>
                            </xsl:for-each>
                          </xsl:if>
                        </xsl:variable>
                       
                        <!-- Added by lohith.ar - Start - Variable for Mouse click hyperlinks -->
                        <xsl:variable name="EventListnerNode">
                          <!-- Link Action-->
                          <office:event-listeners>
                            <xsl:for-each select ="p:txBody/a:p">
                              <xsl:choose>
                                <!-- Start => Go to previous slide-->
                                <xsl:when test="a:endParaRPr/a:hlinkClick/@action[contains(.,'jump=previousslide')]">
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
                                <xsl:when test="a:endParaRPr/a:hlinkClick/@action[contains(.,'jump=nextslide')]">
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
                                <xsl:when test="a:endParaRPr/a:hlinkClick/@action[contains(.,'jump=firstslide')]">
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
                                <xsl:when test="a:endParaRPr/a:hlinkClick/@action[contains(.,'jump=lastslide')]">
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
                                <xsl:when test="a:endParaRPr/a:hlinkClick/@action[contains(.,'jump=endshow')]">
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
                                <!-- Start => Go to Page or Object && Go to Other document && Run program-->
                                <xsl:when test="a:endParaRPr/a:hlinkClick/@action[contains(.,'ppaction://hlinksldjump') or contains(.,'ppaction://hlinkfile') or contains(.,'ppaction://program') ]">
                                  <presentation:event-listener>
                                    <xsl:attribute name ="script:event-name">
                                      <xsl:value-of select ="'dom:click'"/>
                                    </xsl:attribute>
                                    <xsl:variable name="RelationId">
                                      <xsl:value-of select="a:endParaRPr/a:hlinkClick/@r:id"/>
                                    </xsl:variable>
                                    <xsl:variable name="SlideVal">
                                      <xsl:value-of select="key('Part', $slideRel)/rels:Relationships/rels:Relationship[@Id=$RelationId]/@Target"/>
                                    </xsl:variable>
                                    <!-- Condn Go to Other page/slide-->
                                    <xsl:if test="a:endParaRPr/a:hlinkClick/@action[contains(.,'ppaction://hlinksldjump')]">
                                      <xsl:attribute name ="presentation:action">
                                        <xsl:value-of select ="'show'"/>
                                      </xsl:attribute>
                                      <xsl:attribute name ="xlink:href">
                                        <xsl:value-of select ="concat('#page',substring-before(substring-after($SlideVal,'slide'),'.xml'))"/>
                                      </xsl:attribute>
                                    </xsl:if>
                                    <!-- Condn Go to Other document-->
                                    <xsl:if test="a:endParaRPr/a:hlinkClick/@action[contains(.,'ppaction://hlinkfile')]">
                                      <xsl:attribute name ="presentation:action">
                                        <xsl:value-of select ="'show'"/>
                                      </xsl:attribute>
                                      <xsl:attribute name ="xlink:href">
                                        <xsl:if test="string-length(substring-after($SlideVal,'file:///')) > 0">
                                          <xsl:value-of select ="concat('/',translate(substring-after($SlideVal,'file:///'),'\','/'))"/>
                                        </xsl:if>
                                        <xsl:if test="string-length(substring-after($SlideVal,'file:///')) = 0">
                                          <xsl:value-of select ="concat('../',$SlideVal)"/>
                                        </xsl:if>
                                      </xsl:attribute>
                                    </xsl:if>
                                    <!-- Condn Go to Run program-->
                                    <xsl:if test="a:endParaRPr/a:hlinkClick/@action[contains(.,'ppaction://program') ]">
                                      <xsl:attribute name ="presentation:action">
                                        <xsl:value-of select ="'execute'"/>
                                      </xsl:attribute>
                                      <xsl:attribute name ="xlink:href">
                                        <xsl:if test="string-length(substring-after($SlideVal,'file:///')) > 0">
                                          <xsl:value-of select ="concat('/',translate(substring-after($SlideVal,'file:///'),'\','/'))"/>
                                        </xsl:if>
                                        <xsl:if test="string-length(substring-after($SlideVal,'file:///')) = 0">
                                          <xsl:value-of select ="concat('../',$SlideVal)"/>
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
                                <!-- End => Go to Page or Object && Go to Other document && Run program  -->
                                <!-- Start => Paly sound  -->
                                <xsl:when test="a:endParaRPr/a:hlinkClick/a:snd">
                                  <presentation:event-listener>
                                    <xsl:attribute name ="script:event-name">
                                      <xsl:value-of select ="'dom:click'"/>
                                    </xsl:attribute>
                                    <xsl:attribute name ="presentation:action">
                                      <xsl:value-of select ="'sound'"/>
                                    </xsl:attribute>
                                    <presentation:sound>
                                      <xsl:variable name="varMediaFileRelId">
                                        <xsl:value-of select="a:endParaRPr/a:hlinkClick/a:snd/@r:embed"/>
                                      </xsl:variable>
                                      <xsl:variable name="varMediaFileTargetPath">
                                        <xsl:value-of select="key('Part', $slideRel)/rels:Relationships/rels:Relationship[@Id=$varMediaFileRelId]/@Target"/>
                                      </xsl:variable>
                                      <xsl:variable name="varPptMediaFileTargetPath">
                                        <xsl:value-of select="concat('ppt/',substring-after($varMediaFileTargetPath,'/'))"/>
                                      </xsl:variable>

                                      <xsl:variable name="FolderNameGUID">
                                        <xsl:call-template name="GenerateGUIDForFolderName">
                                          <xsl:with-param name="RootNode" select="." />
                                        </xsl:call-template>
                                      </xsl:variable>

                                      <xsl:variable name="varDestMediaFileTargetPath">
                                        <xsl:value-of select="concat($FolderNameGUID,'|',$varMediaFileRelId,'.wav')"/>
                                      </xsl:variable>

                                      <!--<xsl:variable name="varMediaFilePathForOdp">
                            <xsl:value-of select="concat('../_MediaFilesForOdp_',translate($varDocumentModifiedTime,':','-'),'/',$varMediaFileRelId,'.wav')"/>
                          </xsl:variable>-->
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
                                <!-- End => Paly sound  -->
                              </xsl:choose>
                            </xsl:for-each>
                          </office:event-listeners>
                          <!--<pzip:copy pzip:source="ppt/media/audio1.wav" pzip:target="media/audio1.wav"/>-->
                        </xsl:variable>
                        <!-- End - Variable for Mouse click hyperlinks-->
                        <xsl:variable name ="LayoutFileNo">
                          <xsl:for-each select ="key('Part', $slideRel)//node()/@Target[contains(.,'slideLayouts')]">
                            <xsl:value-of select ="concat('ppt',substring(.,3))"/>
                          </xsl:for-each>
                        </xsl:variable>
                        <!-- Slide Layout Files Loop Second Loop-->
                        <xsl:choose>
                          <xsl:when test="count(key('Part', $LayoutFileNo)/p:sldLayout/p:cSld/p:spTree/p:sp) >0">
                            <xsl:choose>
                              <xsl:when test="key('Part', $LayoutFileNo)/p:sldLayout/p:cSld/p:spTree/p:sp/
                                                p:nvSpPr/p:nvPr/p:ph[( contains(@type,$frameName) and $frameName!='') or ( @idx=$FrameIdx and $FrameIdx !='')] ">
                                <xsl:for-each select ="key('Part', $LayoutFileNo)/p:sldLayout/p:cSld/p:spTree/p:sp/
                                                p:nvSpPr/p:nvPr/p:ph[ ( contains(@type,$frameName) and $frameName!='') or ( @idx=$FrameIdx and $FrameIdx !='')]">
                                  <xsl:for-each select="../../..">
                          <xsl:variable name ="SlFrameName">
                            <xsl:for-each select ="p:nvSpPr/p:nvPr/p:ph/@type">
                              <xsl:value-of select ="."/>
                            </xsl:for-each>
                            <xsl:if test="not(p:nvSpPr/p:nvPr/p:ph/@type)">
                              <xsl:for-each select ="p:nvSpPr/p:nvPr/p:ph/@idx">
                                <xsl:value-of select ="."/>
                              </xsl:for-each>
                            </xsl:if >
                          </xsl:variable>
                          <xsl:variable name ="SlFrameNameInd">
                            <xsl:for-each select ="p:nvSpPr/p:nvPr/p:ph/@idx">
                              <xsl:value-of select ="."/>
                            </xsl:for-each>
                          </xsl:variable>
                          <xsl:choose >
                                    <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='subTitle' and 
                                                     ( $frameName='title' or $frameName='ctrTitle') "/>
                            <xsl:when test ="(p:nvSpPr/p:nvPr/p:ph[( contains(@type,$frameName) and $frameName!='')] or 
                                                          ( $SlFrameNameInd=$FrameIdx and $FrameIdx !=''))
												and p:spPr/a:xfrm/a:off" >
                              <xsl:choose >
                                <xsl:when test ="$SlFrameNameInd != $FrameIdx and
												  string-length($SlFrameName) &gt; 0 
												  and string-length($frameName) &gt; 0">
                                  <!--do nothing -->
                                </xsl:when >
                                <xsl:otherwise >
                                  <draw:frame draw:layer="layout" 																			
                                              presentation:user-transformed="true">
                                    <xsl:attribute name ="presentation:style-name">
                                      <xsl:value-of select ="$textLayoutId"/>
                                    </xsl:attribute>
                                    <xsl:attribute name ="presentation:class">
                                      <xsl:call-template name ="LayoutType">
                                        <xsl:with-param name ="LayoutStyle">
                                          <xsl:value-of select ="$LayoutName"/>
                                        </xsl:with-param>
                                      </xsl:call-template >
                                    </xsl:attribute>
						  <xsl:attribute name ="draw:id" >
							  <xsl:value-of  select ="$drawAnimId"/>
						  </xsl:attribute>
                                    <!--Added by Vipul for rotation-->
                                    <!--Start-->
                                    <xsl:call-template name="tmpWriteCordinates"/>
                                    <xsl:copy-of select ="$var_textNode"/>
                                    <!--End-->
                                    <!-- Added by lohith.ar -->
									  <xsl:if test="exsl:node-set($EventListnerNode)//presentation:event-listener">
                                    <xsl:copy-of select ="$EventListnerNode"/>
									  </xsl:if>
                                  </draw:frame >
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:when >

                                    <!-- Modified by lohith to fix the bug 1719280-->
                            <!--  modified by vipul:for ODF1.1 conformance-->
                                    <xsl:when test =" ( p:nvSpPr/p:nvPr/p:ph[( ( contains(@type,$frameName) and $frameName!='') and $frameName!='')]  or 
                                                          ( $SlFrameNameInd=$FrameIdx and $FrameIdx !='' ))
											and not(p:spPr/a:xfrm/a:off)">
                                      <xsl:call-template name="tmpSMFrameProperties">
                                        <xsl:with-param name="LayoutFileNo" select="$LayoutFileNo"/>
                                        <xsl:with-param name="frameName" select="$frameName"/>
                                        <xsl:with-param name="FrameIdx" select="$FrameIdx"/>
                                        <xsl:with-param name="textLayoutId" select="$textLayoutId"/>
                                        <xsl:with-param name="LayoutName" select="$LayoutName"/>
                                        <xsl:with-param name="drawAnimId" select="$drawAnimId"/>
                                        <xsl:with-param name="var_textNode" select="$var_textNode"/>
                                        <xsl:with-param name="EventListnerNode" select="$EventListnerNode"/>
                                        </xsl:call-template >
                                      </xsl:when>
                                </xsl:choose>
                              </xsl:for-each >
                               </xsl:for-each>
                                    </xsl:when>
                              <xsl:when test="not(key('Part', $LayoutFileNo)/p:sldLayout/p:cSld/p:spTree/p:sp/
                                                p:nvSpPr/p:nvPr/p:ph[( contains(@type,$frameName) and $frameName!='') or ( @idx=$FrameIdx and $FrameIdx !='')]) ">
                                <xsl:call-template name="tmpSMFrameProperties">
                                  <xsl:with-param name="LayoutFileNo" select="$LayoutFileNo"/>
                                  <xsl:with-param name="frameName" select="$frameName"/>
                                  <xsl:with-param name="FrameIdx" select="$FrameIdx"/>
                                  <xsl:with-param name="textLayoutId" select="$textLayoutId"/>
                                  <xsl:with-param name="LayoutName" select="$LayoutName"/>
                                  <xsl:with-param name="drawAnimId" select="$drawAnimId"/>
                                  <xsl:with-param name="var_textNode" select="$var_textNode"/>
                                  <xsl:with-param name="EventListnerNode" select="$EventListnerNode"/>
                                      </xsl:call-template >
                                   </xsl:when>
                              </xsl:choose>
                          </xsl:when>
                          <xsl:when test="count(key('Part', $LayoutFileNo)/p:sldLayout/p:cSld/p:spTree/p:sp) =0">
                            <xsl:call-template name="tmpSMFrameProperties">
                              <xsl:with-param name="LayoutFileNo" select="$LayoutFileNo"/>
                              <xsl:with-param name="frameName" select="$frameName"/>
                              <xsl:with-param name="FrameIdx" select="$FrameIdx"/>
                              <xsl:with-param name="textLayoutId" select="$textLayoutId"/>
                              <xsl:with-param name="LayoutName" select="$LayoutName"/>
                              <xsl:with-param name="drawAnimId" select="$drawAnimId"/>
                              <xsl:with-param name="var_textNode" select="$var_textNode"/>
                              <xsl:with-param name="EventListnerNode" select="$EventListnerNode"/>
                            </xsl:call-template>
                         </xsl:when>
                        </xsl:choose>

                        <!-- exit Slide layout loop second Loop-->
                      </xsl:when>
                    </xsl:choose >
                  </xsl:otherwise>
                </xsl:choose>
              <!--</xsl:for-each>-->
            </xsl:when>
            <xsl:when test="name()='p:cxnSp'">
              <xsl:variable name="var_pos" select="position()"/>
              <xsl:for-each select=".">
                <xsl:variable  name ="GraphicId">
                  <xsl:value-of select ="concat('SL',$SlidePos,'grLine',$var_pos)"/>
                </xsl:variable>
                <xsl:variable name ="ParaId">
                  <xsl:value-of select ="concat('SL',$SlidePos,'PARA',$var_pos)"/>
                </xsl:variable>
                <xsl:call-template name ="shapes">
                  <xsl:with-param name="GraphicId" select ="$GraphicId"/>
                  <xsl:with-param name ="ParaId" select="$ParaId" />
                  <xsl:with-param name ="TypeId" select="$SlideID" />
				  <xsl:with-param name ="slideId" select ="$slideId"/>
                  <xsl:with-param name ="SlideRelationId" select ="$slideRel" />
                </xsl:call-template>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="name()='p:grpSp'">
              <xsl:variable name ="drawAnimIdGrp">
			 <xsl:value-of select ="concat('sldraw',$slideId,'an',./p:nvGrpSpPr/p:cNvPr/@id)"/>
			 <!--<xsl:value-of select ="concat('sldraw',$slideId,'an',p:nvSpPr/p:cNvPr/@id)"/>-->
					    </xsl:variable>
               <xsl:variable name="var_pos" select="position()"/>
              <xsl:variable name="TopLevelgrpCordinates">
                  <xsl:call-template name="tmpGetgroupTransformValues"/>
              </xsl:variable>
              <xsl:call-template name ="tmpGroupedShapes">
                <xsl:with-param name ="SlidePos"  select ="$SlidePos" />
                <xsl:with-param name ="SlideID"  select ="$SlideID" />
                <xsl:with-param name ="pos"  select ="$var_pos" />
              <xsl:with-param name ="drawAnimId"  select ="$drawAnimIdGrp" />
                <xsl:with-param name ="SlideRelationId" select="$slideRel" />
                <xsl:with-param name ="grpCordinates" select ="$TopLevelgrpCordinates" />
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="name()='p:graphicFrame'">
				<!--
			  Defect: 2948303,PPTX:Loss of OLE Object(Office2010)
			  By:Vijayeta
			  Desc: Changed xpath to accomodate other nodes that appear in Office 2010 viz. mc:AlternateContent
			  -->
			<xsl:if test="./a:graphic/a:graphicData//child::node()[name()='p:oleObj']">
				<!--<xsl:if test="./a:graphic/a:graphicData/p:oleObj or  ./a:graphic/a:graphicData/mc:AlternateContent/mc:Fallback/p:oleObj">-->
                  <xsl:call-template name="tmpOLEObjects">
                    <xsl:with-param name ="SlideRelationId" select="$slideRel" />
                  </xsl:call-template>
              </xsl:if>
           
              <xsl:if test="./a:graphic/a:graphicData/a:tbl">
                <xsl:call-template name="tmpCreateTable">
                  <xsl:with-param name ="TypeId" select="$SlideID" />
                  <!--parameter added by yeswanth.s : for getting hyperlink from the .rels file using rId-->
                  <xsl:with-param name ="slideRel" select="$slideRel"/>
                </xsl:call-template>
              </xsl:if>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:for-each>
        <!--Conformance Test-->
        <!-- added by vipul to draw Frame for notes-->
        <!--start-->
        <xsl:call-template name="tmpNotesDrawFrames">
          <xsl:with-param name="slideRel" select="$slideRel"/>
          <xsl:with-param name="SlidePos" select="$SlidePos"/>
        </xsl:call-template>
        <!--End-->
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="tmpSMFrameProperties">
    <xsl:param name="LayoutFileNo"/>
    <xsl:param name="frameName"/>
    <xsl:param name="FrameIdx"/>
    <xsl:param name="textLayoutId"/>
    <xsl:param name="LayoutName"/>
    <xsl:param name="drawAnimId"/>
    <xsl:param name="var_textNode"/>
    <xsl:param name="EventListnerNode"/>

    <xsl:variable name ="LayoutRels">
      <xsl:for-each select ="key('Part', concat(concat('ppt/slideLayouts/_rels',substring($LayoutFileNo,17)),'.rels'))
													//node()/@Target[contains(.,'slideMasters')]">
        <xsl:value-of select ="."/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name ="MasterFileName">
      <xsl:value-of select ="concat('ppt/slideMasters',substring($LayoutRels,16))"/>
    </xsl:variable>
    <xsl:if test="key('Part', $MasterFileName)/p:sldMaster/p:cSld/p:spTree/p:sp/
                                                p:nvSpPr/p:nvPr/p:ph[( contains(@type,$frameName) and $frameName!='') or (@idx=$FrameIdx and $FrameIdx!='')] ">
      <xsl:for-each select ="key('Part', $MasterFileName)/p:sldMaster/p:cSld/p:spTree/p:sp/
                                                p:nvSpPr/p:nvPr/p:ph[( contains(@type,$frameName) and $frameName!='') or (@idx=$FrameIdx and $FrameIdx!='')] ">
        <xsl:for-each select="../../..">
          <xsl:variable name ="MstrFrameName">
            <xsl:for-each select ="p:nvSpPr/p:nvPr/p:ph/@type">
              <xsl:value-of select ="."/>
            </xsl:for-each>
            <xsl:if test="not(p:nvSpPr/p:nvPr/p:ph/@type)">
              <xsl:for-each select ="p:nvSpPr/p:nvPr/p:ph/@idx">
                <xsl:value-of select ="."/>
              </xsl:for-each>
            </xsl:if>
          </xsl:variable>
          <xsl:variable name ="MstrFrameInd">
            <xsl:for-each select ="p:nvSpPr/p:nvPr/p:ph/@idx">
              <xsl:value-of select ="."/>
            </xsl:for-each>
          </xsl:variable>
          
          <xsl:choose>
            <xsl:when test ="not($MstrFrameName = $frameName
										                		or $MstrFrameInd =$FrameIdx)">
              <!-- Do nothing-->
              <!-- These will be covered in footer and date time -->
            </xsl:when>
            <xsl:when test ="p:nvSpPr/p:nvPr/p:ph/@type[contains(.,'dt') or 
																 contains(.,'ftr') or contains(.,'sldNum')]">
              <!-- Do nothing-->
              <!-- These will be covered in footer and date time -->
            </xsl:when>
            <xsl:when test =" ( p:nvSpPr/p:nvPr/p:ph[( ( contains(@type,$frameName) or contains($frameName,@type) ) and $frameName!='')]  or 
                                                          ( $MstrFrameInd=$FrameIdx and $FrameIdx !=''))
                                                            and p:spPr/a:xfrm/a:off" >
              <draw:frame draw:layer="layout"
                          presentation:user-transformed="true">
                <xsl:attribute name ="presentation:style-name">
                  <xsl:value-of select ="$textLayoutId"/>
                </xsl:attribute>
                <xsl:attribute name ="presentation:class">
                  <xsl:call-template name ="LayoutType">
                    <xsl:with-param name ="LayoutStyle">
                      <xsl:value-of select ="$LayoutName"/>
                    </xsl:with-param>
                  </xsl:call-template >
                </xsl:attribute>
                <xsl:attribute name ="draw:id" >
                  <xsl:value-of  select ="$drawAnimId"/>
                </xsl:attribute>
                <!--Added by Vipul for rotation-->
                <!--Start-->
                <xsl:call-template name="tmpWriteCordinates"/>
                <xsl:copy-of select ="$var_textNode"/>
                <!--End-->
                <!-- Added by lohith.ar -->
                <xsl:if test="exsl:node-set($EventListnerNode)//presentation:event-listener">
                  <xsl:copy-of select ="$EventListnerNode"/>
                </xsl:if>
              </draw:frame >
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <xsl:template name ="tmpOLEObjects">
    <xsl:param name ="SlideRelationId"/>
    <xsl:param name ="grpBln"/>
    <xsl:param name ="grpCordinates"/>
	  <!--
			  Defect: 2948303,PPTX:Loss of OLE Object(Office2010)
			  By:Vijayeta
			  Desc: Changed xpath to accomodate other nodes that appear in Office 2010 viz. mc:AlternateContent
			  -->
    <xsl:variable name="RelationId">
      <xsl:value-of select="./a:graphic/a:graphicData//child::node()[name()='p:oleObj']/@r:id[1]"/>
    </xsl:variable>
    <xsl:variable name="vmldrawing">
      <xsl:value-of select="key('Part', $SlideRelationId)/rels:Relationships/rels:Relationship[@Type='http://schemas.openxmlformats.org/officeDocument/2006/relationships/vmlDrawing']/@Target"/>
    </xsl:variable>
    <xsl:variable name="Target">
      <xsl:value-of select="key('Part', $SlideRelationId)/rels:Relationships/rels:Relationship[@Id=$RelationId]/@Target"/>
    </xsl:variable>
    <xsl:variable name="type">
      <xsl:value-of select="key('Part', $SlideRelationId)/rels:Relationships/rels:Relationship[@Id=$RelationId]/@Type"/>
    </xsl:variable>
	  <!--
			  Defect: 2948303,PPTX:Loss of OLE Object(Office2010)
			  By:Vijayeta
			  Desc: Changed xpath to accomodate other nodes that appear in Office 2010 viz. mc:AlternateContent
			  -->
    <xsl:variable name="spid">
      <!--<xsl:value-of select="./a:graphic/a:graphicData/p:oleObj/@spid"/>-->
		<xsl:value-of select="./a:graphic/a:graphicData//child::node()[name()='p:oleObj']/@spid"/>
    </xsl:variable>
    <xsl:variable name="OleImageRel">
      <!-- Defect Fix:1992999	 PPTX - Roundtrip: OLE files/links lost -->
      <xsl:for-each select="key('Part', concat('ppt',substring-after($vmldrawing,'..')))/node()/v:shape[@id=$spid or @o:spid=$spid]/v:imagedata">
        <xsl:value-of  select="@o:relid"/>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="OleImage">
        <xsl:value-of select="key('Part', concat('ppt/drawings/_rels/',substring-after($vmldrawing,'../drawings/'),'.rels'))/rels:Relationships/rels:Relationship[@Id=$OleImageRel]/@Target"/>
    </xsl:variable>
    <xsl:variable name="extensionType">
      <xsl:value-of select="concat('.',substring-after(substring-after($Target,'../embeddings/'),'.'))"/>
    </xsl:variable>
    <xsl:variable name="targetOLE">
      <xsl:choose>
        <xsl:when test="contains($Target,'.pptx')">
          <xsl:value-of select="substring-after($Target,'../embeddings/')"/>
        </xsl:when>
        <xsl:when test="contains($Target,'.docx')">
          <xsl:value-of select="substring-after($Target,'../embeddings/')"/>
        </xsl:when>
        <xsl:when test="contains($Target,'.xslx')">
          <xsl:value-of select="substring-after($Target,'../embeddings/')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('Oleobject',generate-id())"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="targetImage">
      <xsl:choose>
        <xsl:when test="contains($Target,'.pptx')">
          <xsl:value-of select="substring-after($OleImage,'../media/')"/>
        </xsl:when>
        <xsl:when test="contains($Target,'.docx')">
          <xsl:value-of select="substring-after($OleImage,'../media/')"/>
        </xsl:when>
        <xsl:when test="contains($Target,'.xslx')">
          <xsl:value-of select="substring-after($OleImage,'../media/')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('Oleobject',generate-id())"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <draw:frame draw:layer="layout">
      <xsl:choose>
        <xsl:when test="$grpBln='true'">
          <xsl:call-template name="tmpGropingWriteCordinates">
            <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
            <xsl:with-param name ="isOLE" select ="'true'" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name ="svg:x">
            <xsl:call-template name="ConvertEmu">
              <xsl:with-param name="length" select="p:xfrm/a:off/@x"/>
              <xsl:with-param name="unit">cm</xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name ="svg:y">
            <xsl:call-template name="ConvertEmu">
              <xsl:with-param name="length" select="p:xfrm/a:off/@y"/>
              <xsl:with-param name="unit">cm</xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name ="svg:width">
            <xsl:call-template name="ConvertEmu">
              <xsl:with-param name="length" select="p:xfrm/a:ext/@cx"/>
              <xsl:with-param name="unit">cm</xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name ="svg:height">
            <xsl:call-template name="ConvertEmu">
              <xsl:with-param name="length" select="p:xfrm/a:ext/@cy"/>
              <xsl:with-param name="unit">cm</xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <draw:object xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad">
   <xsl:choose>
		<!--
			  Defect: 2948303,PPTX:Loss of OLE Object(Office2010)
			  By:Vijayeta
			  Desc: Changed xpath to accomodate other nodes that appear in Office 2010 viz. mc:AlternateContent
			  -->
          <xsl:when test="./a:graphic/a:graphicData//child::node()[name()='p:oleObj']/p:link">
			  <!--<xsl:when test="./a:graphic/a:graphicData/p:oleObj/p:link 
					     or ./a:graphic/a:graphicData/mc:AlternateContent/mc:Fallback/p:oleObj/p:link">--> 
            <xsl:choose>
              <xsl:when test="contains($Target,'file:///\\')">
                <xsl:attribute name="xlink:href">
                  <xsl:value-of select="concat('//',translate(substring-after($Target, 'file:///\\'),'\','/'))"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="contains($Target,'file:///')">
                <xsl:attribute name="xlink:href">
                  <xsl:value-of select="concat('/',translate(substring-after($Target,'file:///'),'\','/'))"/>
                </xsl:attribute>
              </xsl:when>
              <!--added by vipul for conf 1.1-->
              <xsl:when test="starts-with($Target,'Files/')">
                <xsl:attribute name="xlink:href">
                  <xsl:value-of select="concat('/',translate($Target,'\','/'))"/>
                </xsl:attribute>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
		<!--
			  Defect: 2948303,PPTX:Loss of OLE Object(Office2010)
			  By:Vijayeta
			  Desc: Changed xpath to accomodate other nodes that appear in Office 2010 viz. mc:AlternateContent
			  -->
		<xsl:when test="./a:graphic/a:graphicData//child::node()[name()='p:oleObj']/p:embed">
		<!--<xsl:when test="./a:graphic/a:graphicData/p:oleObj/p:embed or ./a:graphic/a:graphicData/mc:AlternateContent/mc:Fallback/p:oleObj/p:embed">-->		
                <xsl:attribute name="xlink:href">
              <xsl:value-of select="concat('./',$targetOLE)"/>
            </xsl:attribute>
               </xsl:when>
        </xsl:choose>
      </draw:object>
      <draw:image xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad">
        <xsl:attribute name="xlink:href">
          <xsl:value-of select="concat('./ObjectReplacements/',$targetImage)"/>
        </xsl:attribute>
      </draw:image>
    </draw:frame>
	  <!--
			  Defect: 2948303,PPTX:Loss of OLE Object(Office2010)
			  By:Vijayeta
			  Desc: Changed xpath to accomodate other nodes that appear in Office 2010 viz. mc:AlternateContent
			  -->
<xsl:if test="./a:graphic/a:graphicData//child::node()[name()='p:oleObj']/p:embed">
	<!--<xsl:if test="./a:graphic/a:graphicData/p:oleObj/p:embed or ./a:graphic/a:graphicData/mc:AlternateContent/mc:Fallback/p:oleObj/p:embed">-->
      <pzip:copy pzip:source="{concat('ppt',substring-after($Target,'..'))}"
                  pzip:target="{$targetOLE}"/>
    </xsl:if>
    <xsl:if test="$OleImage!=''">
      <pzip:copy pzip:source="{concat('ppt',substring-after($OleImage,'..'))}"
                pzip:target="{concat('ObjectReplacements/',$targetImage)}"/>
    </xsl:if>
  </xsl:template>
  <xsl:template name ="tmpCreateTable">
    <xsl:param name ="TypeId" />
    <xsl:param name ="slideRel"/>
    <draw:g>
      <xsl:for-each select="./a:graphic/a:graphicData/a:tbl/a:tr">
        <xsl:variable name="rowPosition" select="position()"/>
        <xsl:for-each select="./a:tc">
          <xsl:choose>
            <xsl:when test="@vMerge =1"/>
            <xsl:when test="@hMerge =1"/>
            <xsl:otherwise>
              <xsl:variable  name ="GraphicId">
                <xsl:value-of select ="concat('SLTableGr',$TypeId,generate-id())"/>
              </xsl:variable>
              <draw:frame draw:layer="layout">
                <xsl:call-template name ="CreateShape">
                  <xsl:with-param name="blnTable" select ="'true'" />
                  <xsl:with-param name="rowPosition" select ="$rowPosition" />
                  <xsl:with-param name="grID" select ="$GraphicId" />
                  <xsl:with-param name="TypeId" select ="$TypeId" />
                  <xsl:with-param name="prID" select ="concat('SLTableGr',$TypeId,'PARA',position(),generate-id(./child::node()/a:p))" />
                  <xsl:with-param name="sldId" select ="$TypeId" />
                  <xsl:with-param name ="SlideRelationId" select="$slideRel"/>
                </xsl:call-template>
              </draw:frame>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:for-each> 
      </draw:g>
  </xsl:template>
  <!-- Gets all caps attribute from Layout -->
  <xsl:template name ="getAllCapsFromLayout">
    <xsl:param name ="phType" select="p:nvSpPr/p:nvPr/p:ph/@type"/>
    <xsl:param name ="phIdx" select ="p:nvSpPr/p:nvPr/p:ph/@idx"/>
    <xsl:param name ="layOutRelId"/>
    <xsl:variable name ="LayoutFileNo">
      <xsl:for-each select ="key('Part', $layOutRelId)//node()/@Target[contains(.,'slideLayouts')]">
        <xsl:value-of select ="concat('ppt',substring(.,3))"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:for-each select ="key('Part', $LayoutFileNo)/p:sldLayout/p:cSld/p:spTree/p:sp">
      <xsl:if test ="p:nvSpPr/p:nvPr/p:ph/@type = $phType">
        <xsl:value-of select ="p:txBody/a:lstStyle/a:lvl1pPr/a:defRPr/@cap"/>
      </xsl:if>
      <xsl:if test ="p:nvSpPr/p:nvPr/p:ph/@idx = $phIdx">
        <xsl:value-of select ="p:txBody/a:lstStyle/a:lvl1pPr/a:defRPr/@cap"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
 <xsl:template name ="tmpGroupedShapes">
    <xsl:param name ="SlideID" />
    <xsl:param name ="SlideRelationId" />
    <xsl:param name ="grID" />
    <xsl:param name ="prID" />
    <xsl:param name ="pos" />
   <xsl:param name ="SlidePos" />
   <xsl:param name ="drawAnimId" />
   <xsl:param name ="grpCordinates"/>
   <xsl:param name ="multiple" select="'0'"/>
   <!-- parameter added by chhavi:for ODF1.1 conformance-->
   <xsl:param name ="layId"/>
   <draw:g>
     <!-- condition added by chhavi:for ODF1.1 conformance-->
     <xsl:if test="$multiple='0' and $layId!='true'">
          <xsl:attribute name ="draw:id" >
				<xsl:value-of  select ="$drawAnimId"/>
			  </xsl:attribute>
            </xsl:if>
        
          <xsl:for-each select="node()">
            <xsl:message terminate="no">progress:a:p</xsl:message>
           <xsl:choose>
            <xsl:when test="name()='p:pic'">
              <xsl:variable name="var_pos" select="position()"/>
              <xsl:variable  name ="GraphicId">
                <xsl:value-of select ="concat('SLgrp','SLPicture',$SlidePos,'gr',$pos,'-', $var_pos,'-',./p:nvPicPr/p:cNvPr/@id)"/>
              </xsl:variable>
              <xsl:for-each select=".">
                <xsl:if test="not(p:nvPicPr/p:nvPr/a:audioFile or p:nvPicPr/p:nvPr/a:wavAudioFile or p:nvPicPr/p:nvPr/a:videoFile)">
                <xsl:call-template name="InsertPicture">
                  <xsl:with-param name ="slideRel" select ="$SlideRelationId"/>
                <xsl:with-param name="grpBln" select="'true'"/>
                    <xsl:with-param name="grpGraphicID" select="$GraphicId"/>
               <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
                </xsl:call-template>
                </xsl:if>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="name()='p:sp'">
              <xsl:variable name="var_pos" select="position()"/>
              <xsl:for-each select=".">
                <xsl:choose>
                  <xsl:when test="not(p:nvSpPr/p:nvPr/p:ph)">
                      <xsl:variable  name ="GraphicId">
                       <xsl:value-of select ="concat('SLgrp',$SlidePos,'gr',$pos,'-', $var_pos)"/>
                      </xsl:variable>
                      <xsl:variable name ="ParaId">
                      <xsl:value-of select ="concat('SLgrp',$SlidePos,'PARA',$pos,'-', $var_pos)"/>
                      </xsl:variable>
                      <xsl:call-template name ="shapes">
                        <xsl:with-param name="GraphicId" select ="$GraphicId"/>
                        <xsl:with-param name ="ParaId" select="$ParaId" />
                        <xsl:with-param name ="TypeId" select="$SlideID" />
                        <xsl:with-param name="SlideRelationId" select="$SlideRelationId"/>
                        <xsl:with-param name="var_pos" select ="concat($pos,'-',$var_pos)" />
                       <xsl:with-param name="grpBln" select="'true'"/>
                    <xsl:with-param name="groupPrefix" select="'Slidegroup'"/>
                   <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
                        <!-- parameter added by chhavi:for ODF1.1 conformance-->
                        <xsl:with-param name ="layId" select="$layId"/>
<xsl:with-param name ="slideId"  select ="$SlidePos"/>
                      </xsl:call-template>
                  </xsl:when>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="name()='p:cxnSp'">
              <xsl:variable name="var_pos" select="position()"/>
              <xsl:for-each select=".">
              <xsl:variable  name ="GraphicId">
                <xsl:value-of select ="concat('SLgrp',$SlidePos,'grLine',$pos,'-', $var_pos)"/>
              </xsl:variable>
              <xsl:variable name ="ParaId">
                <xsl:value-of select ="concat('SLgrp',$SlidePos,'PARA',$pos,'-', $var_pos)"/>
              </xsl:variable>
              <xsl:call-template name ="shapes">
                <xsl:with-param name="GraphicId" select ="$GraphicId"/>
                <xsl:with-param name ="ParaId" select="$ParaId" />
                <xsl:with-param name ="TypeId" select="$SlideID" />
                  <xsl:with-param name ="SlideRelationId" select ="$SlideRelationId" />
                <xsl:with-param name="grpBln" select="'true'"/>
                <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
				  <xsl:with-param name ="slideId"  select ="$SlidePos"/>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:when>
			   <!--
			  Defect: 2948303,PPTX:Loss of OLE Object(Office2010)
			  By:Vijayeta
			  Desc: Changed xpath to accomodate other nodes that appear in Office 2010 viz. mc:AlternateContent
			  -->
             <xsl:when test="name()='p:graphicFrame'">
				 <xsl:if test="./a:graphic/a:graphicData//child::node()[name()='p:oleObj']">
					 <!--<xsl:if test="./a:graphic/a:graphicData/p:oleObj or ./a:graphic/a:graphicData/mc:AlternateContent/mc:Fallback/p:oleObj">-->
                 <xsl:call-template name="tmpOLEObjects">
                   <xsl:with-param name ="SlideRelationId" select="$SlideRelationId" />
                   <xsl:with-param name ="grpBln" select="'true'" />
                   <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
                 </xsl:call-template>
               </xsl:if>
             </xsl:when>
            <xsl:when test="name()='p:grpSp'">
              <xsl:variable name="var_pos" select="position()"/>
              <xsl:variable name="InnerLevelgrpCordinates">
                <xsl:call-template name="tmpGetgroupTransformValues"/>
              </xsl:variable>
	       <xsl:call-template name ="tmpGroupedShapes">
                <xsl:with-param name ="SlidePos"  select ="$SlidePos" />
                <xsl:with-param name ="SlideID"  select ="$SlideID" />
                <xsl:with-param name ="pos"  select ="concat($pos,'-',$var_pos)" />
                <xsl:with-param name ="drawAnimId"  select ="$drawAnimId" />
                <xsl:with-param name ="SlideRelationId" select="$SlideRelationId" />
                <xsl:with-param name ="grpCordinates" select ="concat($grpCordinates,$InnerLevelgrpCordinates)" />
                  <xsl:with-param name ="multiple" select ="'1'" />
            <xsl:with-param name ="layId" select="'true'"/>
              </xsl:call-template>
            </xsl:when>
          </xsl:choose>
      </xsl:for-each>
     </draw:g>
  </xsl:template>
    <xsl:template name ="GetStylesFromSlide" >
    <xsl:param name="SlidePos"/>
    <xsl:param name="LayoutFileName"/>
    <xsl:param name="SMName"/>
    <xsl:param name="ThemeName"/>

      <xsl:variable name ="SlideNumber">
        <xsl:value-of  select ="concat('slide',position())" />
      </xsl:variable>
      <xsl:variable name ="SlideId">
        <xsl:value-of  select ="concat($SlideNumber,'.xml')" />
      </xsl:variable>
        <xsl:variable name ="slideRel">
        <xsl:value-of select ="concat(concat('ppt/slides/_rels/',$SlideNumber,'.xml'),'.rels')"/>
      </xsl:variable>
           <xsl:variable name ="DefFont">
        <xsl:for-each select ="key('Part', $ThemeName)/a:theme/a:themeElements/a:fontScheme/a:majorFont/a:latin/@typeface">
          <xsl:value-of select ="."/>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name ="DefFontMinor">
        <xsl:for-each select ="key('Part', $ThemeName)/a:theme/a:themeElements/a:fontScheme/a:minorFont/a:latin/@typeface">
          <xsl:value-of select ="."/>
        </xsl:for-each>
      </xsl:variable>
         <xsl:call-template name="tmpNotesStyle">
           <xsl:with-param name="slideRel" select="$slideRel"/>
           <xsl:with-param name="DefFont" select="$DefFont"/>
         </xsl:call-template>


    <xsl:variable name ="LayoutRel" >
      <xsl:value-of select ="concat('ppt/slideLayouts/_rels/',$LayoutFileName,'.rels')"/>
    </xsl:variable>


      <xsl:variable name ="bulletTypeBool">
        <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))//p:sldLayout">
          <xsl:choose >
            <!-- Changes made by vijayeta, bug fix, 1739703, date:10-7-07-->
            <!-- Fix for the bug, number 45,Internal Defects.xls date 8th aug '07-->
            <xsl:when test ="p:cSld/@name[contains(.,'Content')] or p:cSld/@name[contains(.,'Title,')] or p:cSld/@name[contains(.,'Title and')] or p:cSld/@name[contains(.,'Two Content')] or  p:cSld/@name[contains(.,'Comparison')]">
              <xsl:value-of select ="'true'"/>
            </xsl:when>
            <xsl:otherwise >
              <xsl:value-of select ="'false'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <!--</xsl:if>-->
        <!--</xsl:for-each>-->
      </xsl:variable >
      <xsl:for-each select ="key('Part', concat('ppt/slides/',$SlideId))/p:sld/p:cSld/p:spTree">
        <xsl:for-each select="node()">
          <xsl:choose>
            <xsl:when test="name()='p:sp'">
              <xsl:variable name="var_pos" select="position()"/>
              <xsl:choose>
                <xsl:when test="not(p:nvSpPr/p:nvPr/p:ph)">
                  <xsl:variable  name ="GraphicId">
                    <xsl:value-of select ="concat('SL',$SlidePos,'gr',$var_pos)"/>
                  </xsl:variable>
                <xsl:variable name ="ParaId">
                    <xsl:value-of select ="concat('SL',$SlidePos,'PARA',$var_pos)"/>
                </xsl:variable>
                  <style:style style:family="graphic" style:parent-style-name="standard">
                    <xsl:attribute name ="style:name">
                      <xsl:value-of select ="$GraphicId"/>
                    </xsl:attribute >
                    <style:graphic-properties>
                      <!--FILL-->
                      <xsl:call-template name ="Fill">
                        <xsl:with-param name="var_pos" select="$var_pos"/>
                        <xsl:with-param name="FileType" select="concat('slide',$SlidePos)"/>
                        <xsl:with-param name="SMName" select="$SMName"/>
                      </xsl:call-template>
                      <!--LINE COLOR-->
                      <xsl:call-template name ="LineColor" >
                        <xsl:with-param name="SMName" select="$SMName"/>
                      </xsl:call-template>
                      <!--LINE STYLE-->
                      <xsl:call-template name ="LineStyle">
                        <xsl:with-param name="ThemeName" select="$ThemeName"/>
                      </xsl:call-template>
                      <!--TEXT ALIGNMENT-->
         
                      <xsl:call-template name ="TextLayout" />
                      <!-- SHADOW IMPLEMENTATION -->
                      <xsl:call-template name="tmpShapeShadow"/>
                    </style:graphic-properties >
                    <xsl:if test ="p:txBody/a:bodyPr/@vert">
                      <style:paragraph-properties>
                        <!--Commented for Bug no1958740-->
                        <xsl:call-template name ="getTextDirection">
                          <xsl:with-param name ="vert" select ="p:txBody/a:bodyPr/@vert" />
                        </xsl:call-template>
                        <!--Added by Sanjay-->
                        <xsl:if test="p:blipFill/a:blip/a:lum">
                          <xsl:for-each select="p:blipFill/a:blip/a:lum">
                            <xsl:call-template name="BrightContrast"/>
                          </xsl:for-each>
                  </xsl:if>
                      </style:paragraph-properties>
                  </xsl:if>
                  </style:style>
                  <xsl:call-template name="tmpShapeTextProcess">
                    <xsl:with-param name="ParaId" select="$ParaId"/>
                    <xsl:with-param name="TypeId" select="$SlideNumber"/>
                    <xsl:with-param name="DefFont" select="$DefFont"/>
                    <xsl:with-param name="DefFontMinor" select="$DefFontMinor"/>
                    <xsl:with-param name="SMName" select="$SMName"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                <xsl:variable name="var_TextBoxType">
                  <xsl:choose>
                      <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='ctrTitle' or p:nvSpPr/p:nvPr/p:ph/@type='title'">
                      <xsl:value-of select="'title'"/>
                    </xsl:when>
                      <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='subTitle'">
                      <xsl:value-of select="'subtitle'"/>
                    </xsl:when>

                      <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='body' and p:nvSpPr/p:nvPr/p:ph/@idx ">
                      <xsl:value-of select="'outline'"/>
                    </xsl:when>
                      <xsl:when test="not(p:nvSpPr/p:nvPr/p:ph/@type) and ./p:nvSpPr/p:nvPr/p:ph/@idx ">
                      <xsl:value-of select="'outline'"/>
                    </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="p:nvSpPr/p:nvPr/p:ph/@type"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:variable name="var_index">
                  <xsl:choose>
                      <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@idx">
                        <xsl:value-of select="p:nvSpPr/p:nvPr/p:ph/@idx"/>
                    </xsl:when>
                  </xsl:choose>
                </xsl:variable>
                  <style:style style:family="presentation" >
                    <xsl:attribute name ="style:name">
                      <xsl:value-of  select ="concat(substring-before($SlideId,'.xml'),'pr',$var_pos)"/>
                    </xsl:attribute>
                    <style:graphic-properties>
                      <!--Added by sanjay-->
                      <xsl:if test="p:blipFill/a:blip/a:lum">
                        <xsl:for-each select="p:blipFill/a:blip/a:lum">
                          <xsl:call-template name="BrightContrast"/>
                        </xsl:for-each>
                      </xsl:if>
                      <xsl:call-template name="tmpCommanGraphicProperty">
                        <xsl:with-param name="spType" select="$var_TextBoxType"/>
                        <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                        <xsl:with-param name="index" select="$var_index"/>
                        <xsl:with-param name="ThemeName" select="$ThemeName"/>
                        <xsl:with-param name="SMName" select="$SMName"/>
                        <xsl:with-param name="var_pos" select="$var_pos"/>
                        <xsl:with-param name="FileType" select="'slide'"/>
                        <xsl:with-param name="slideNo" select="$SlidePos"/>
                      </xsl:call-template>
                    </style:graphic-properties>
                    <style:paragraph-properties>
                      <xsl:if test="p:txBody/a:bodyPr/@vert">
                        <xsl:call-template name="getTextDirection">
                          <xsl:with-param name="vert" select="p:txBody/a:bodyPr/@vert"/>
                        </xsl:call-template>
                      </xsl:if>
                    </style:paragraph-properties>
                  </style:style>
                  <xsl:for-each select="./p:txBody">
                    <xsl:variable name ="ParaId">
                      <xsl:value-of select ="concat($SlideNumber,concat('PARA',$var_pos))"/>
                    </xsl:variable>
                    <!-- ADDED by Vipul to decide text box type i.e. Title, subtitle, outline, textbox-->
                    <!--Start-->
                    <xsl:variable name="var_fontScale">
                      <xsl:if test="./a:bodyPr/a:normAutofit/@fontScale">
                        <xsl:value-of select="./a:bodyPr/a:normAutofit/@fontScale"/>
                      </xsl:if>
                      <xsl:if test="not(./a:bodyPr/a:normAutofit/@fontScale)">
                        <xsl:value-of select="'100000'"/>
                      </xsl:if>
                    </xsl:variable>
                    <xsl:variable name="var_lnSpcReduction">
                      <xsl:if test="./a:bodyPr/a:normAutofit/@lnSpcReduction">
                        <xsl:value-of select="./a:bodyPr/a:normAutofit/@lnSpcReduction"/>
                      </xsl:if>
                      <xsl:if test="not(./a:bodyPr/a:normAutofit/@lnSpcReduction)">
                        <xsl:value-of select="'0'"/>
                      </xsl:if>
                    </xsl:variable>
                <!--End-->
                <!--  by vijayeta,to get linespacing from layouts-->
                <xsl:variable name ="layoutName">
                  <xsl:value-of select ="./parent::node()/p:nvSpPr/p:nvPr/p:ph/@type"/>
                </xsl:variable>
                <!--Code by Vijayeta for Bullets,set style name in case of default bullets-->
                <xsl:variable name ="listStyleName">

                  <!-- Added by vijayeta, to get the text box number-->
                  <xsl:variable name ="textNumber" select ="./parent::node()/p:nvSpPr/p:cNvPr/@id"/>
                  <!-- Added by vijayeta, to get the text box number-->
                  <xsl:value-of select ="concat($SlideNumber,'List',$var_pos)"/>
                  
                </xsl:variable>
                <!-- Added by vijayeta, on 16th july-->
                 
                <xsl:variable name="lytFileName">
                      <xsl:value-of select="substring-after($LayoutFileName,'ppt/slideLayouts/_rels/')"/>
                </xsl:variable>
                <!-- aDDED BY VIJAYEA, TO GET SLIDE MASTER, ON 15TH JULY-->
              
                <!-- aDDED BY VIJAYEA, TO GET SLIDE MASTER, ON 15TH JULY-->
                <!--If bullets present-->
                <xsl:if test ="(a:p/a:pPr/a:buChar) or (a:p/a:pPr/a:buAutoNum) or (a:p/a:pPr/a:buBlip) ">
                  <xsl:call-template name ="insertBulletStyle">
                    <xsl:with-param name ="slideRel" select ="$slideRel"/>
                    <xsl:with-param name ="ParaId" select ="$ParaId"/>
                    <xsl:with-param name ="listStyleName" select ="$listStyleName"/>
                        <xsl:with-param name ="slideMaster" select ="$SMName"/>
                    <xsl:with-param name ="var_TextBoxType" select ="$var_TextBoxType"/>
                    <xsl:with-param name ="var_index" select ="$var_index"/>
                        <xsl:with-param name ="slideLayout" select ="$LayoutFileName"/>
                  </xsl:call-template>
                </xsl:if>
                <!-- bullets are default-->
                <xsl:if test ="not(a:p/a:pPr/a:buChar or a:p/a:pPr/a:buAutoNum or a:p/a:pPr/a:buBlip)">
                  <!--<xsl:if test ="$bulletTypeBool='true'">-->
                  <!-- Added by  vijayeta ,on 19th june-->
                  <!--Bug fix 1739611,by vijayeta,June 21st-->
                  <xsl:if test="$var_TextBoxType='outline' or $var_TextBoxType='subtitle'">
                                       <!-- Added by  vijayeta ,on 19th june-->
                    <xsl:call-template name ="insertDefaultBulletNumberStyle">
                      <xsl:with-param name ="listStyleName" select ="$listStyleName"/>
                          <xsl:with-param name ="slideLayout" select ="$LayoutFileName"/>
                          <xsl:with-param name ="slideMaster" select ="$SMName"/>
                      <xsl:with-param name ="var_TextBoxType" select ="$var_TextBoxType"/>
                      <xsl:with-param name ="var_index" select ="$var_index"/>
                    </xsl:call-template>
                  </xsl:if>
                  <!--</xsl:if>-->
                </xsl:if>
                <!--End of code if bullets are default-->
                <!--End of code inserted by Vijayeta,InsertStyle For Bullets and Numbering-->
                <xsl:for-each select ="a:p">
                  <!-- Code by vijayeta,to set default font size for inner levels,in case of multiple levels-->
                  <xsl:variable name ="levelForDefFont">
                    <xsl:if test ="a:pPr/@lvl">
                      <xsl:value-of select ="a:pPr/@lvl"/>
                    </xsl:if>
                    <xsl:if test ="not(a:pPr/@lvl)">
                      <xsl:value-of select ="'0'"/>
                    </xsl:if>
                  </xsl:variable>
                  <!--End of Code by vijayeta,to set default font size for inner levels,in case of multiple levels-->
                  <style:style style:family="paragraph">
                    <xsl:attribute name ="style:name">
                      <xsl:value-of select ="concat($ParaId,position())"/>
                    </xsl:attribute >
                    <style:paragraph-properties  text:enable-numbering="false" >
                      <xsl:call-template name="tmpCommanParaProperty">
                            <xsl:with-param name="spType" select="$var_TextBoxType"/>
                            <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                            <xsl:with-param name="index" select="$var_index"/>
                            <xsl:with-param name="lnSpcReduction" select="$var_lnSpcReduction"/>
                            <xsl:with-param name="level" select="$levelForDefFont"/>
                            <xsl:with-param name="SMName" select="$SMName"/>
                          </xsl:call-template>
                       <!-- Code inserted by VijayetaFor Bullets, Enable Numbering-->
                      <xsl:if test ="a:pPr/a:buChar or a:pPr/a:buAutoNum or a:pPr/a:buBlip ">
                        <xsl:choose >
                          <xsl:when test ="not(a:r/a:t)">
                            <xsl:attribute name="text:enable-numbering">
                              <xsl:value-of select ="'false'"/>
                            </xsl:attribute>
                          </xsl:when>
                          <xsl:otherwise >
                            <xsl:attribute name="text:enable-numbering">
                              <xsl:value-of select ="'true'"/>
                            </xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:if>
					  <!--code  added by yeswanth for bug# 1877445-->
						<xsl:if test ="a:pPr/a:buNone">
							<xsl:attribute name="text:enable-numbering">
								<xsl:value-of select ="'false'"/>
							</xsl:attribute>							
						</xsl:if>
					  <!--end-->
                      <!--</xsl:if>-->
						<!--extra condition not(a:pPr/a:buNone) added by yeswanth for bug# 1877445-->
                      <xsl:if test ="not(a:pPr/a:buChar) and not(a:pPr/a:buAutoNum) and not(a:pPr/a:buBlip) and not(a:pPr/a:buNone)">
                        <xsl:choose >
                          <xsl:when test="$var_TextBoxType='outline' or $var_TextBoxType='subtitle'">
                            <xsl:variable name ="buFlag">
                              <xsl:choose>
                                <xsl:when test="$layoutName='body'">
                                  <xsl:choose>
                                    <xsl:when test="$var_index != ''">
                                          <xsl:if test="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type=$layoutName and @idx=$var_index]">
                                            <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type=$layoutName and @idx=$var_index]">
                                          <xsl:call-template name="tmpcheckbulletFlage">
                                            <xsl:with-param name="level" select="$levelForDefFont + 1"/>
                                          </xsl:call-template>
                                        </xsl:for-each>
                                      </xsl:if>
                                          <xsl:if test="not(key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type=$layoutName and @idx=$var_index])">
                                            <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[not(@type) and @idx=$var_index]">
                                          <xsl:call-template name="tmpcheckbulletFlage">
                                            <xsl:with-param name="level" select="$levelForDefFont + 1"/>
                                          </xsl:call-template>
                                        </xsl:for-each>
                                      </xsl:if>
                                    </xsl:when>
                                    <xsl:when test="$var_index = ''">
                                          <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type=$layoutName and not(@idx)]">
                                        <xsl:call-template name="tmpcheckbulletFlage">
                                          <xsl:with-param name="level" select="$levelForDefFont + 1"/>
                                        </xsl:call-template>
                                      </xsl:for-each>
                                    </xsl:when>
                                  </xsl:choose>
                                </xsl:when>
                                <xsl:when test="$layoutName='' and $var_index != ''">
                                      <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[not(@type) and @idx=$var_index]">
                                    <xsl:call-template name="tmpcheckbulletFlage">
                                      <xsl:with-param name="level" select="$levelForDefFont + 1"/>
                                    </xsl:call-template>
                                  </xsl:for-each>
                                </xsl:when>
                                <xsl:when test="$layoutName='subTitle' and $var_index != ''">
                                      <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type=$layoutName and @idx=$var_index]">
                                    <xsl:call-template name="tmpcheckbulletFlage">
                                      <xsl:with-param name="level" select="$levelForDefFont + 1"/>
                                    </xsl:call-template>
                                  </xsl:for-each>
                                </xsl:when>
                                <xsl:when test="$layoutName='subTitle' and $var_index = ''">
                                      <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type=$layoutName and not(@idx)]">
                                    <xsl:call-template name="tmpcheckbulletFlage">
                                      <xsl:with-param name="level" select="$levelForDefFont + 1" />
                                    </xsl:call-template>
                                  </xsl:for-each>
                                </xsl:when>
                              </xsl:choose>
                            </xsl:variable>
                            <xsl:choose>
                              <xsl:when test="$buFlag='true'">
                                <xsl:if test ="a:r/a:t">
                                  <xsl:if test ="a:pPr/a:buNone">
                                    <xsl:attribute name="text:enable-numbering">
                                      <xsl:value-of select ="'false'"/>
                                    </xsl:attribute>
                                  </xsl:if>
                                  <xsl:if test ="not(a:pPr/a:buNone)">
                                    <xsl:attribute name="text:enable-numbering">
                                      <xsl:value-of select ="'true'"/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:if>
                                <xsl:if test ="not(a:r/a:t)">
                                  <xsl:attribute name="text:enable-numbering">
                                    <xsl:value-of select ="'false'"/>
                                  </xsl:attribute>
                                </xsl:if>
                              </xsl:when>
                              <xsl:when test="$buFlag='false'">
                                <xsl:attribute name="text:enable-numbering">
                                  <xsl:value-of select ="'false'"/>
                                </xsl:attribute>
                              </xsl:when>
                              <xsl:when test="$buFlag=''">
                                <xsl:attribute name="text:enable-numbering">
                                  <xsl:value-of select ="'true'"/>
                                </xsl:attribute>
                              </xsl:when>
                            </xsl:choose>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="text:enable-numbering">
                              <xsl:value-of select ="'false'"/>
                            </xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test ="a:pPr/a:tabLst/a:tab">
                          <xsl:call-template name ="paragraphTabstops">
                            <xsl:with-param name="spType" select="$var_TextBoxType"/>
                            <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                            <xsl:with-param name="index" select="$var_index"/>
                            <xsl:with-param name ="slideMasterName" select ="$SMName"/>
                            <xsl:with-param name="level" select="$levelForDefFont + 1"/>
                          </xsl:call-template>
                        </xsl:when>
                        <xsl:when test ="a:pPr/@defTabSz">
                        <xsl:call-template name ="paragraphTabstops">
                            <xsl:with-param name ="defaultPos" select ="a:pPr/@defTabSz"/>
                            <xsl:with-param name="spType" select="$var_TextBoxType"/>
                            <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                            <xsl:with-param name="index" select="$var_index"/>
                            <xsl:with-param name ="slideMasterName" select ="$SMName"/>
                            <xsl:with-param name="level" select="$levelForDefFont + 1"/>
                        </xsl:call-template >
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:variable name="tabStopValue">
                            <xsl:call-template name="tmpLayoutTabStop">
                              <xsl:with-param name="spType" select="$var_TextBoxType"/>
                              <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                              <xsl:with-param name="index" select="$var_index"/>
                              <xsl:with-param name ="SMName" select ="$SMName"/>
                              <xsl:with-param name="level" select="$levelForDefFont + 1"/>
                            </xsl:call-template>
                          </xsl:variable>
                          <xsl:call-template name ="paragraphTabstops">
                            <xsl:with-param name ="defaultPos" select ="$tabStopValue"/>
                            <xsl:with-param name="spType" select="$var_TextBoxType"/>
                            <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                            <xsl:with-param name="index" select="$var_index"/>
                            <xsl:with-param name ="slideMasterName" select ="$SMName"/>
                            <xsl:with-param name="level" select="$levelForDefFont + 1"/>
                          </xsl:call-template >
                        </xsl:otherwise>
                      </xsl:choose>
                    </style:paragraph-properties >
                  </style:style>
                  <!-- Modified by pradeep for fix 1731885-->
                  <xsl:for-each select ="node()" >
                    <!-- Add here-->
                    <xsl:if test ="name()='a:r'">
                      <style:style style:family="text">
                        <xsl:attribute name="style:name">
                          <xsl:value-of select="concat($SlideNumber,generate-id())"/>
                        </xsl:attribute>
                        <style:text-properties style:font-charset="x-symbol">
                           <xsl:call-template name="tmpCommanTextProperty">
                                <xsl:with-param name="spType" select="$var_TextBoxType"/>
                                <xsl:with-param name="DefFont" select="$DefFont"/>
                                <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                                <xsl:with-param name="index" select="$var_index"/>
                                <xsl:with-param name="fontscale" select="$var_fontScale"/>
                                <xsl:with-param name="level" select="$levelForDefFont"/>
                                <xsl:with-param name="SMName" select="$SMName"/>
                                <xsl:with-param name="var_lnSpcReduction" select="$var_lnSpcReduction"/>
                              </xsl:call-template>
                         </style:text-properties>
                      </style:style>
                    </xsl:if>
                    <!-- Added by lohith.ar for fix 1731885-->
                    <xsl:if test ="name()='a:endParaRPr'">
                      <style:style style:family="text">
                        <xsl:attribute name="style:name">
                          <xsl:value-of select="concat($SlideNumber,generate-id())"/>
                        </xsl:attribute>
                        <style:text-properties style:font-charset="x-symbol">
                          <!-- Bug 1711910 Fixed,On date 2-06-07,by Vijayeta-->
                          <!-- Bug 1744106 fixed by vijayeta, date 16th Aug '07, font size and family from endPara-->
                              <xsl:call-template name="tmpFontName">
                                <xsl:with-param name="DefFont" select="$DefFont"/>
                              </xsl:call-template>
                          <xsl:attribute name ="style:font-family-generic"	>
                            <xsl:value-of select ="'roman'"/>
                          </xsl:attribute>
                          <xsl:attribute name ="style:font-pitch"	>
                            <xsl:value-of select ="'variable'"/>
                          </xsl:attribute>
                          <xsl:if test ="./@sz">
                            <xsl:attribute name ="fo:font-size"	>
                              <xsl:for-each select ="./@sz">
                                <xsl:value-of select ="concat(format-number(. div 100,'#.##'), 'pt')"/>
                              </xsl:for-each>
                            </xsl:attribute>
                          </xsl:if>
                           <xsl:if test ="not(./@sz)">
                                <xsl:call-template name ="tmpTextProperty">
                                  <xsl:with-param name ="AttrType" select ="'Fontsize'"/>
                                  <xsl:with-param name ="level" select ="$levelForDefFont + 1"/>
                                  <xsl:with-param name="SMName" select="$SMName"/>
                                  <xsl:with-param name ="fs" select ="$var_fontScale"/>
                                  <xsl:with-param name ="DefFont" select ="$DefFont" />
                                  <xsl:with-param name="spType" select="$var_TextBoxType"/>
                                  <xsl:with-param name="index" select="$var_index"/>
                                </xsl:call-template>
                              </xsl:if>
                            </style:text-properties>
                          </style:style>
                        </xsl:if>
                      </xsl:for-each >
                    </xsl:for-each>
                      </xsl:for-each>
               </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="name()='p:grpSp'">
              <xsl:variable name="var_pos" select="position()"/>
              <xsl:for-each select=".">
                <xsl:call-template name="tmpSlideGroupStyle">
                  <xsl:with-param name="var_pos" select="$var_pos"/>
                  <xsl:with-param name="SlidePos" select="$SlidePos"/>
                  <xsl:with-param name="DefFont" select="$DefFont"/>
                  <xsl:with-param name="SMName" select="$SMName"/>
                  <xsl:with-param name="flagGroup" select="'True'"/>
                  <xsl:with-param name="SlideId" select="$SlideId"/>
                  <xsl:with-param name="SlideNumber" select="$SlideNumber"/>
                  <xsl:with-param name="slideRel" select="$slideRel"/>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="name()='p:cxnSp'">
              <xsl:variable name="var_pos" select="position()"/>
              <xsl:for-each select=".">
                <xsl:variable  name ="GraphicId">
                  <xsl:value-of select ="concat('SL',$SlidePos,'grLine',$var_pos)"/>
                </xsl:variable>
                <xsl:variable name ="ParaId">
                  <xsl:value-of select ="concat('SL',$SlidePos,'PARA',$var_pos)"/>
                </xsl:variable>
                <xsl:variable name="flagTextBox">
                  <xsl:if test="p:nvSpPr/p:cNvSpPr/@txBox='1'">
                    <xsl:value-of select ="'True'"/>
                  </xsl:if>
                </xsl:variable>
                <style:style style:family="graphic" style:parent-style-name="standard">
                  <xsl:attribute name ="style:name">
                    <xsl:value-of select ="$GraphicId"/>
                                    </xsl:attribute>
                  <style:graphic-properties>
                    <!--FILL-->
                    <xsl:call-template name ="Fill">
                      <xsl:with-param name="SMName" select="$SMName"/>
                    </xsl:call-template>
                    <!--LINE COLOR-->
                    <xsl:call-template name ="LineColor">
                      <xsl:with-param name="SMName" select="$SMName"/>
                    </xsl:call-template>
                    <!--LINE STYLE-->
                    <xsl:call-template name ="LineStyle">
                      <xsl:with-param name="ThemeName" select="$ThemeName"/>
                    </xsl:call-template>
                    <!--TEXT ALIGNMENT-->
                    <xsl:call-template name ="TextLayout" />
                    <!-- SHADOW IMPLEMENTATION -->
                    <xsl:call-template name="tmpShapeShadow"/>
                    <!--Added by sanjay-->
                    <xsl:if test="p:blipFill/a:blip/a:lum">
                      <xsl:for-each select="p:blipFill/a:blip/a:lum">
                        <xsl:call-template name="BrightContrast"/>
                      </xsl:for-each>
                    </xsl:if>
                  </style:graphic-properties >
                  <xsl:if test ="p:txBody/a:bodyPr/@vert">
                    <style:paragraph-properties>
                      <!--Commented for Bug no1958740-->

                      <xsl:call-template name ="getTextDirection">
                        <xsl:with-param name ="vert" select ="p:txBody/a:bodyPr/@vert" />
                      </xsl:call-template>

                    </style:paragraph-properties>
                  </xsl:if>
                </style:style>
                <xsl:call-template name="tmpShapeTextProcess">
                  <xsl:with-param name="ParaId" select="$ParaId"/>
                  <xsl:with-param name="TypeId" select="$SlideNumber"/>
                  <xsl:with-param name="SMName" select="$SMName"/>
                </xsl:call-template>
                 </xsl:for-each>
                 </xsl:when>
            <!--Picture Border-->
            <xsl:when test="name()='p:pic'">
              <xsl:for-each select=".">
                <xsl:variable  name ="GraphicId">
                  <xsl:value-of select ="concat('SLPicture',$SlidePos,'gr',./p:nvPicPr/p:cNvPr/@id)"/>
                </xsl:variable>
                <style:style style:family="graphic" style:parent-style-name="standard">
                  <xsl:attribute name ="style:name">
                    <xsl:value-of select ="$GraphicId"/>
                                    </xsl:attribute>
                  <style:graphic-properties>
                    <!--LINE STYLE-->
                    <xsl:if test="p:spPr/a:ln">
                      <xsl:call-template name ="LineStyle"/>
                      <xsl:call-template name ="PictureBorderColor" />
                                  </xsl:if>
                    <!--End-->
                    <!--Image Cropping-->
                    <xsl:call-template name="tmpImageCropping">
                      <xsl:with-param name="slideRel" select="$slideRel"/>
                    </xsl:call-template>
                    <!--Added by Sanjay to Fixed the Bug No-1877163  Luminance-->
                    <xsl:if test="p:blipFill/a:blip/a:lum">
                      <xsl:for-each select="p:blipFill/a:blip/a:lum">
                        <xsl:call-template name="BrightContrast"/>
                                </xsl:for-each>
                    </xsl:if>
                    <!--End of Bug No-1877163-->
                  </style:graphic-properties >
                </style:style>

                <xsl:if test="not(p:spPr/a:ln)">
                  <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp">
                    <xsl:if test="p:nvSpPr/p:nvPr/p:ph[@type='pic']">
                      <xsl:if test="p:spPr/a:ln">
                        <style:style style:family="graphic" style:parent-style-name="standard">
                          <xsl:attribute name ="style:name">
                            <xsl:value-of select ="$GraphicId"/>
                                    </xsl:attribute>
                          <style:graphic-properties>
                            <!--LINE STYLE-->
                            <xsl:call-template name ="LineStyle"/>
                            <xsl:call-template name ="PictureBorderColor" />
                          </style:graphic-properties >
                        </style:style>
                      </xsl:if>
                                  </xsl:if>
                           </xsl:for-each>

                             </xsl:if>
                                </xsl:for-each>
                              </xsl:when>
            <xsl:when test="name()='p:graphicFrame'">
              <xsl:if test="./a:graphic/a:graphicData/a:tbl">
                <xsl:call-template name="tmpTableStyle">
                  <xsl:with-param name="TypeId" select="$SlideNumber"/>
                  <xsl:with-param name="DefFont" select="$DefFont"/>
                  <xsl:with-param name="SMName" select="$SMName"/>
                                          </xsl:call-template>
              </xsl:if>
                                        </xsl:when>
           </xsl:choose>
        </xsl:for-each>
      </xsl:for-each>
       <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree">
           <xsl:for-each select="node()">
             <xsl:choose>
               <!--Picture Border-->
               <xsl:when test="name()='p:pic'">
                 <xsl:for-each select=".">
                   <xsl:variable  name ="GraphicId">
                     <xsl:value-of select ="concat('SLPicture',$SlidePos,'gr',./p:nvPicPr/p:cNvPr/@id)"/>
                   </xsl:variable>
                   <style:style style:family="graphic" style:parent-style-name="standard">
                     <xsl:attribute name ="style:name">
                       <xsl:value-of select ="$GraphicId"/>
                     </xsl:attribute >
                     <style:graphic-properties>
                       <!--LINE STYLE-->
                       <xsl:if test="p:spPr/a:ln">
                         <xsl:call-template name ="LineStyle"/>
                         <xsl:call-template name ="PictureBorderColor" />
                       </xsl:if>
                       <!--End-->
                       <!--Image Cropping-->
                       <xsl:call-template name="tmpImageCropping">
                         <xsl:with-param name="slideRel" select="$LayoutRel"/>
                                          </xsl:call-template>
                       <xsl:if test="p:blipFill/a:blip/a:lum">
                         <xsl:for-each select="p:blipFill/a:blip/a:lum">
                           <xsl:call-template name="BrightContrast"/>
                         </xsl:for-each>
                       </xsl:if>
                     </style:graphic-properties >
                   </style:style>
                 </xsl:for-each>
                                        </xsl:when>
               <xsl:when test="name()='p:sp'">
                 <xsl:variable name="var_pos" select="position()"/>
                 <xsl:for-each select=".">
                   <xsl:if test="not(p:nvSpPr/p:nvPr/p:ph)">
                     <xsl:variable  name ="GraphicId">
                       <xsl:value-of select ="concat('SL',$SlidePos,'LYT','gr',$var_pos)"/>
                     </xsl:variable>
                     <xsl:variable name ="ParaId">
                       <xsl:value-of select ="concat('SL',$SlidePos,'LYT','PARA',$var_pos)"/>
                     </xsl:variable>
                     <xsl:variable name="flagTextBox">
                       <xsl:if test="p:nvSpPr/p:cNvSpPr/@txBox='1'">
                         <xsl:value-of select ="'True'"/>
                       </xsl:if>
                     </xsl:variable>
                     <style:style style:family="graphic" style:parent-style-name="standard">
                       <xsl:attribute name ="style:name">
                         <xsl:value-of select ="$GraphicId"/>
                       </xsl:attribute >
                       <style:graphic-properties>
                         <!--FILL-->
                         <xsl:call-template name ="Fill">
                           <xsl:with-param name="var_pos" select="$var_pos"/>
                           <xsl:with-param name="FileType" select="substring-before($LayoutFileName,'.xml')"/>
                           <xsl:with-param name="SMName" select="$SMName"/>
                                          </xsl:call-template>
                         <!--LINE COLOR-->
                         <xsl:call-template name ="LineColor">
                           <xsl:with-param name="SMName" select="$SMName"/>
                                          </xsl:call-template>
                         <!--LINE STYLE-->
                         <xsl:call-template name ="LineStyle"/>
                         <!--TEXT ALIGNMENT-->
                         <xsl:call-template name ="TextLayout" />
                         <!-- SHADOW IMPLEMENTATION -->
                         <xsl:call-template name="tmpShapeShadow"/>
                       </style:graphic-properties >
                       <xsl:if test ="p:txBody/a:bodyPr/@vert">
                         <style:paragraph-properties>
                           <!--Commented for Bug no1958740-->

                           <xsl:call-template name ="getTextDirection">
                             <xsl:with-param name ="vert" select ="p:txBody/a:bodyPr/@vert" />
                                          </xsl:call-template>

                         </style:paragraph-properties>
                       </xsl:if>
                     </style:style>
                     <xsl:call-template name="tmpShapeTextProcess">
                       <xsl:with-param name="ParaId" select="$ParaId"/>
                       <xsl:with-param name="TypeId" select="concat('SL',$SlidePos)"/>
                       <xsl:with-param name="flagTextBox" select="$flagTextBox"/>
                       <xsl:with-param name="SMName" select="$SMName"/>
                       <xsl:with-param name="DefFont" select="$DefFont"/>
                        <xsl:with-param name="DefFontMinor" select="$DefFontMinor"/>
                       
                                          </xsl:call-template>
                   </xsl:if>
                 </xsl:for-each>
                                        </xsl:when>
               <xsl:when test="name()='p:graphicFrame'">
                 <xsl:if test="./a:graphic/a:graphicData/a:tbl">
                   <xsl:call-template name="tmpTableStyle">
                     <xsl:with-param name="TypeId" select="substring-before($SlideId,'.xml')"/>
                     <xsl:with-param name="DefFont" select="$DefFont"/>
                     <xsl:with-param name="SMName" select="$SMName"/>
                   </xsl:call-template>
                 </xsl:if>
               </xsl:when>
               <xsl:when test="name()='p:cxnSp'">
                 <xsl:variable name="var_pos" select="position()"/>
                 <xsl:for-each select=".">
                   <xsl:variable  name ="GraphicId">
                     <xsl:value-of select ="concat('SL',$SlidePos,'LYT','grLine',$var_pos)"/>
                   </xsl:variable>
                   <xsl:variable name ="ParaId">
                     <xsl:value-of select ="concat('SL',$SlidePos,'LYT','PARA',$var_pos)"/>
                   </xsl:variable>
                   <xsl:variable name="flagTextBox">
                     <xsl:if test="p:nvSpPr/p:cNvSpPr/@txBox='1'">
                       <xsl:value-of select ="'True'"/>
                     </xsl:if>
                   </xsl:variable>
                   <style:style style:family="graphic" style:parent-style-name="standard">
                     <xsl:attribute name ="style:name">
                       <xsl:value-of select ="$GraphicId"/>
                     </xsl:attribute >
                     <style:graphic-properties>
                       <!--FILL-->
                       <xsl:call-template name ="Fill">
                         <xsl:with-param name="SMName" select="$SMName"/>
                                          </xsl:call-template>
                       <!--LINE COLOR-->
                       <xsl:call-template name ="LineColor">
                         <xsl:with-param name="SMName" select="$SMName"/>
                                          </xsl:call-template>
                       <!--LINE STYLE-->
                       <xsl:call-template name ="LineStyle"/>
                       <!--TEXT ALIGNMENT-->
                       <xsl:call-template name ="TextLayout" />
                       <!-- SHADOW IMPLEMENTATION -->
                       <xsl:call-template name="tmpShapeShadow"/>
                     </style:graphic-properties >
                     <xsl:if test ="p:txBody/a:bodyPr/@vert">
                       <style:paragraph-properties>
                         <xsl:call-template name ="getTextDirection">
                           <xsl:with-param name ="vert" select ="p:txBody/a:bodyPr/@vert" />
                         </xsl:call-template>
                       </style:paragraph-properties>
                          </xsl:if>
                        </style:style>
                   <xsl:call-template name="tmpShapeTextProcess">
                     <xsl:with-param name="ParaId" select="$ParaId"/>
                     <xsl:with-param name="TypeId" select="concat('SL',$SlidePos)"/>
                   </xsl:call-template>
              </xsl:for-each>
               </xsl:when>
            <xsl:when test="name()='p:grpSp'">
            <xsl:variable name="var_pos" select="position()"/>
              <xsl:for-each select=".">
                <xsl:call-template name="tmpSlideGroupStyle">
                  <xsl:with-param name="var_pos" select="$var_pos"/>
                     <xsl:with-param name="SlidePos" select="concat('SL',$SlidePos)"/>
                  <xsl:with-param name="DefFont" select="$DefFont"/>
                  <xsl:with-param name="DefFontMinor" select="$DefFontMinor"/>
                  <xsl:with-param name="SMName" select="$SMName"/>
                  <xsl:with-param name="flagGroup" select="'True'"/>
                  <xsl:with-param name="SlideId" select="$SlideId"/>
                   <xsl:with-param name="slideRel" select="$slideRel"/>
                     <xsl:with-param name="SlideNumber" select="substring-before($LayoutFileName,'.xml')"/>
                </xsl:call-template>
            </xsl:for-each>
          </xsl:when>
           </xsl:choose>
        </xsl:for-each>
           <!--End-->
      </xsl:for-each>
  
  </xsl:template>
  <xsl:template name="tmpSlideGroupStyle">
    <xsl:param name="SlideId"/>
    <xsl:param name="SlidePos"/>
    <xsl:param name="SlideNumber"/>
    <xsl:param name="SMName"/>
    <xsl:param name="DefFont"/>
    <xsl:param name="DefFontMinor"/>
    <xsl:param name="var_pos"/>
    <xsl:param name="slideRel"/>
              <xsl:for-each select="node()">
                <xsl:choose>
                  <xsl:when test="name()='p:pic'">
                    <xsl:variable name="pos" select="position()"/>
                    <xsl:for-each select=".">
                      <xsl:variable  name ="GraphicId">
                        <xsl:value-of select ="concat('SLgrp','SLPicture',$SlidePos,'gr',$var_pos,'-', $pos,'-',./p:nvPicPr/p:cNvPr/@id)"/>
                      </xsl:variable>
                      <style:style style:family="graphic" style:parent-style-name="standard">
                        <xsl:attribute name ="style:name">
                          <xsl:value-of select ="$GraphicId"/>
                        </xsl:attribute >
                        <style:graphic-properties>
                          <!--LINE STYLE-->
                          <xsl:if test="p:spPr/a:ln">
                            <xsl:call-template name ="LineStyle"/>
                            <xsl:call-template name ="PictureBorderColor" />
                          </xsl:if>
                          <!--End-->
                          <!--Image Cropping-->
                          <xsl:call-template name="tmpImageCropping">
                            <xsl:with-param name="slideRel" select="$slideRel"/>
                          </xsl:call-template>
                          <!--TEXT ALIGNMENT-->
                          <xsl:call-template name ="TextLayout" />
                <!--Added by sanjay for Bright & Contrast-->
                          <xsl:if test="p:blipFill/a:blip/a:lum">
                            <xsl:for-each select="p:blipFill/a:blip/a:lum">
                              <xsl:call-template name="BrightContrast"/>
                            </xsl:for-each>
                          </xsl:if>
                        </style:graphic-properties >
                      </style:style>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:when test="name()='p:sp'">
                     <xsl:variable name="pos" select="position()"/>
                    <xsl:if test="not(p:nvSpPr/p:nvPr/p:ph)">
                    <xsl:variable  name ="GraphicId">
                      <xsl:value-of select ="concat('SLgrp',$SlidePos,'gr',$var_pos,'-', $pos)"/>
                    </xsl:variable>
                    <xsl:variable name ="ParaId">
                      <xsl:value-of select ="concat('SLgrp',$SlidePos,'PARA',$var_pos,'-', $pos)"/>
                    </xsl:variable>
                      <xsl:variable name="flagTextBox">
                        <xsl:if test="p:nvSpPr/p:cNvSpPr/@txBox='1'">
                          <xsl:value-of select ="'True'"/>
                        </xsl:if>
                      </xsl:variable>
                    <style:style style:family="graphic" style:parent-style-name="standard">
                      <xsl:attribute name ="style:name">
                        <xsl:value-of select ="$GraphicId"/>
                      </xsl:attribute >
                      <style:graphic-properties draw:stroke="none">
                        <!--FILL-->
                    <xsl:call-template name ="Fill">
                         <xsl:with-param name="var_pos" select="concat($var_pos,'-',$pos)"/>
                         <xsl:with-param name="FileType" select="$SlideNumber"/>
                         <xsl:with-param name="flagGroup" select="'True'"/>
                      <xsl:with-param name="SMName" select="$SMName"/>
                    </xsl:call-template>
                        <!--LINE COLOR-->
                        <xsl:call-template name ="LineColor">
                          <xsl:with-param name="SMName" select="$SMName"/>
                        </xsl:call-template>
                        <!--LINE STYLE-->
                        <xsl:call-template name ="LineStyle"/>
                        <!--TEXT ALIGNMENT-->
                        <xsl:call-template name ="TextLayout" />
                        <!-- SHADOW IMPLEMENTATION -->
                        <xsl:call-template name="tmpShapeShadow"/>

                      </style:graphic-properties >
                      <xsl:if test ="p:txBody/a:bodyPr/@vert">
                        <style:paragraph-properties>
                            <xsl:call-template name ="getTextDirection">
                              <xsl:with-param name ="vert" select ="p:txBody/a:bodyPr/@vert" />
                            </xsl:call-template>
                          </style:paragraph-properties>
                      </xsl:if>
                    </style:style>
                    <xsl:call-template name="tmpShapeTextProcess">
                      <xsl:with-param name="ParaId" select="$ParaId"/>
                      <xsl:with-param name="TypeId" select="substring-before($SlideId,'.xml')"/>
                      <xsl:with-param name="flagTextBox" select="$flagTextBox"/>
                      <xsl:with-param name="SMName" select="$SMName"/>
                      <xsl:with-param name="DefFont" select="$DefFont"/>
                      <xsl:with-param name="DefFontMinor" select="$DefFontMinor"/>
                    </xsl:call-template>
                  </xsl:if>
                </xsl:when>
                  <xsl:when test="name()='p:cxnSp'">
                      <xsl:variable name="pos" select="position()"/>
                    <xsl:for-each select=".">
                      <xsl:variable  name ="GraphicId">
                        <xsl:value-of select ="concat('SLgrp',$SlidePos,'grLine',$var_pos,'-', $pos)"/>
                      </xsl:variable>
                      <xsl:variable name ="ParaId">
                        <xsl:value-of select ="concat('SLgrp',$SlidePos,'PARA',$var_pos,'-', $pos)"/>
                      </xsl:variable>
                      <xsl:variable name="flagTextBox">
                        <xsl:if test="p:nvSpPr/p:cNvSpPr/@txBox='1'">
                          <xsl:value-of select ="'True'"/>
                        </xsl:if>
                      </xsl:variable>
                      <style:style style:family="graphic" style:parent-style-name="standard">
                        <xsl:attribute name ="style:name">
                          <xsl:value-of select ="$GraphicId"/>
                        </xsl:attribute >
                        <style:graphic-properties draw:stroke="none">
                          <!--FILL-->
                          <xsl:call-template name ="Fill">
                            <xsl:with-param name="SMName" select="$SMName"/>
                          </xsl:call-template>
                          <!--LINE COLOR-->
                          <xsl:call-template name ="LineColor">
                            <xsl:with-param name="SMName" select="$SMName"/>
                          </xsl:call-template>
                          <!--LINE STYLE-->
                          <xsl:call-template name ="LineStyle"/>
                          <!--TEXT ALIGNMENT-->
                          <xsl:call-template name ="TextLayout" />
                          <!-- SHADOW IMPLEMENTATION -->
                          <xsl:call-template name="tmpShapeShadow"/>
                        </style:graphic-properties >
                        <xsl:if test ="p:txBody/a:bodyPr/@vert">
                          <style:paragraph-properties>
                            <!--Commented for Bug no1958740-->
                               <xsl:call-template name ="getTextDirection">
                                <xsl:with-param name ="vert" select ="p:txBody/a:bodyPr/@vert" />
                              </xsl:call-template>
                           </style:paragraph-properties>
                        </xsl:if>
                      </style:style>
                      <xsl:call-template name="tmpShapeTextProcess">
                        <xsl:with-param name="ParaId" select="$ParaId"/>
                        <xsl:with-param name="TypeId" select="substring-before($SlideId,'.xml')"/>
                        <xsl:with-param name="SMName" select="$SMName"/>
                        <xsl:with-param name="DefFont" select="$DefFont"/>
                      </xsl:call-template>
                    </xsl:for-each>
                  </xsl:when>
        <xsl:when test="name()='p:grpSp'">
          <xsl:variable name="pos" select="position()"/>
          <xsl:call-template name="tmpSlideGroupStyle">
            <xsl:with-param name="SlidePos" select="$SlidePos"/>
            <xsl:with-param name="DefFont" select="$DefFont"/>
            <xsl:with-param name="DefFontMinor" select="$DefFontMinor"/>
            <xsl:with-param name="SMName" select="$SMName"/>
            <xsl:with-param name="flagGroup" select="'True'"/>
            <xsl:with-param name="SlideId" select="$SlideId"/>
            <xsl:with-param name="SlideNumber" select="$SlideNumber"/>
            <xsl:with-param name="var_pos" select="concat($var_pos,'-',$pos)"/>
            <xsl:with-param name="slideRel" select="$slideRel"/>
          </xsl:call-template>
          </xsl:when>
           </xsl:choose>
        </xsl:for-each>
        </xsl:template>
   <xsl:template name ="LayoutType">
    <xsl:param name ="LayoutStyle"/>
    <xsl:choose >
      <xsl:when test ="$LayoutStyle='ctrTitle'">
        <xsl:value-of select ="'title'"/>
      </xsl:when>
      <xsl:when test ="$LayoutStyle='subTitle'">
        <xsl:value-of select ="'subtitle'"/>
        <!--Edited by vipul for case sensitive-->
      </xsl:when>
      <xsl:when test ="$LayoutStyle=''">
        <xsl:value-of select ="'outline'"/>
      </xsl:when>
      <xsl:when test ="$LayoutStyle='title'">
        <xsl:value-of select ="'title'"/>
      </xsl:when>
      <xsl:otherwise >
        <xsl:value-of select ="'outline'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Added by Lohith A R : Custom Slide Show -->
  <xsl:template name="InsertPresentationSettings">
    <presentation:settings>
      <!-- Added by vijayeta
           Slide Show settings
           Date:3rd Aug '07-->
      <xsl:for-each select ="key('Part', 'ppt/presProps.xml')//p:showPr">
        <!-- Presentation type-->
        <xsl:choose >
          <xsl:when test ="./p:present">
            <!-- Do nothing, no attribute to be added-->
            <xsl:attribute name ="presentation:full-screen">
              <xsl:value-of select ="'true'"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:when test ="./p:browse">
            <xsl:attribute name ="presentation:full-screen">
              <xsl:value-of select ="'false'"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <!-- Do nothing, no attribute to be added-->
            <!-- warn if 'kiosk' -->
            <xsl:message terminate="no">translation.oox2odf.slideShowSettingsKiosk</xsl:message>
            <xsl:attribute name ="presentation:full-screen">
              <xsl:value-of select ="'true'"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <!-- Show Slides-->
        <xsl:choose >
          <xsl:when test ="./p:sldAll">
            <!-- Do nothing, As no attribute must be included-->
          </xsl:when>
          <xsl:when test ="./p:sldRg">
            <!-- warn, feature Start and End Slide Show -->
            <xsl:message terminate="no">translation.oox2odf.slideShowSettingsSlideStartEnd</xsl:message>
            <xsl:variable name ="pageName">
              <xsl:value-of select ="concat('page',./p:sldRg/@st)"/>
            </xsl:variable>
            <xsl:attribute name ="presentation:start-page">
              <xsl:value-of select ="$pageName"/>
            </xsl:attribute>
          </xsl:when>
        </xsl:choose>
        <!-- Show options-->
        <!--turn animation onn or off-->
        <xsl:if test ="./@showAnimation='0'">
          <xsl:attribute name ="presentation:animations">
            <xsl:value-of select ="'disabled'"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test ="./@showAnimation='1' or not(./@showAnimation)">
          <!-- Do nothing, no attribute to be added-->
        </xsl:if>
        <!--<xsl:if test ="/@useTimings='0'">
          <xsl:attribute name ="presentation:force-manual">
            <xsl:value-of select ="'true'"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test ="/@useTimings='1' or not(/@useTimings)">
          <xsl:attribute name ="presentation:transition-on-click">
            <xsl:value-of select ="'disabled'"/>
          </xsl:attribute>
        </xsl:if>-->
        <xsl:if test ="./@loop='1'">
          <xsl:attribute name ="presentation:endless">
            <xsl:value-of select ="'true'"/>
          </xsl:attribute>
          <xsl:attribute name ="presentation:pause">
            <xsl:value-of select ="'PT00H00M00S'"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test ="not(./@showNarration)">
          <!-- warn if option Narration set -->
          <xsl:message terminate="no">translation.oox2odf.slideShowSettingsNarration</xsl:message>
        </xsl:if>
        <xsl:if test ="p:penClr">
          <!-- warn if Pen colour can be set -->
          <xsl:message terminate="no">translation.oox2odf.slideShowSettingsPenColor</xsl:message>
        </xsl:if>
        <xsl:if test ="./p:custShow">
          <xsl:variable name ="custId">
            <xsl:value-of select ="./p:custShow/@id"/>
          </xsl:variable>
          <xsl:variable name ="custShowInPresProps">
            <xsl:for-each select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:custShowLst/p:custShow[@id=$custId]">
              <xsl:value-of select="./@name"/>
            </xsl:for-each>
          </xsl:variable>
          <xsl:attribute name ="presentation:show">
            <xsl:value-of select="$custShowInPresProps"/>
          </xsl:attribute>          
        </xsl:if>
      </xsl:for-each>
      <!-- End of code Added by vijayeta for Slide Show settings-->
      
      <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:custShowLst/p:custShow">
        <presentation:show>
          <xsl:attribute name ="presentation:name"	>
            <xsl:value-of select ="@name"/>
          </xsl:attribute>
          <xsl:attribute name ="presentation:pages"	>
            <xsl:for-each select ="p:sldLst/p:sld">
              <xsl:variable name="SlideIdVal">
                <xsl:value-of select ="@r:id"/>
              </xsl:variable>
              <xsl:variable name="SlideVal">
                <xsl:value-of select="key('Part', 'ppt/_rels/presentation.xml.rels')/rels:Relationships/rels:Relationship[@Id=$SlideIdVal]/@Target"/>
              </xsl:variable>
              <xsl:variable name="CoustomSlideList">
                <xsl:value-of select="concat('page',substring-before(substring-after($SlideVal,'slides/slide'),'.xml'),',')"/>
              </xsl:variable>
              <!--<xsl:variable name="CoustomSlideListForOdp">
                  <xsl:value-of select="substring($CoustomSlideList,1,string-length($CoustomSlideList)-1)"/>
                </xsl:variable>-->
              <xsl:value-of select="$CoustomSlideList"/>
            </xsl:for-each>
          </xsl:attribute>
        </presentation:show>
      </xsl:for-each>
         </presentation:settings>
  </xsl:template>
  <!-- Added by Lohith A R : Custom Slide Show -->
  <xsl:template name="ConvertPoints">
    <xsl:param name="length"/>
    <xsl:param name="unit"/>
    <xsl:variable name="lengthVal">
      <xsl:choose>
        <xsl:when test="contains($length,'pt')">
          <xsl:value-of select="substring-before($length,'pt')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$length"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$lengthVal='0' or $lengthVal=''">
        <xsl:value-of select="concat(0, $unit)"/>
      </xsl:when>
      <xsl:when test="$unit = 'cm'">
        <xsl:value-of select="concat(format-number($lengthVal * 2.54 div 72,'#.###'),'cm')"/>
      </xsl:when>
      <xsl:when test="$unit = 'mm'">
        <xsl:value-of select="concat(format-number($lengthVal * 25.4 div 72,'#.###'),'mm')"/>
      </xsl:when>
      <xsl:when test="$unit = 'in'">
        <xsl:value-of select="concat(format-number($lengthVal div 72,'#.###'),'in')"/>
      </xsl:when>
      <xsl:when test="$unit = 'pt'">
        <xsl:value-of select="concat($lengthVal,'pt')"/>
      </xsl:when>
      <xsl:when test="$unit = 'pica'">
        <xsl:value-of select="concat(format-number($lengthVal div 12,'#.###'),'pica')"/>
      </xsl:when>
      <xsl:when test="$unit = 'dpt'">
        <xsl:value-of select="concat($lengthVal,'dpt')"/>
      </xsl:when>
      <xsl:when test="$unit = 'px'">
        <xsl:value-of select="concat(format-number($lengthVal * 96.19 div 72,'#.###'),'px')"/>
      </xsl:when>
      <xsl:when test="not($lengthVal)">
        <xsl:value-of select="concat(0,'cm')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$lengthVal"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="tmpTableStyle">
    <xsl:param name="TypeId"/>
    <xsl:param name="DefFont"/>
    <xsl:param name="SMName"/>
    <xsl:for-each select="./a:graphic/a:graphicData/a:tbl/a:tr">
      <xsl:variable name="rowPos" select="position()"/>
      <xsl:variable name="lastPos">
        <xsl:if test="position()=last()">
          <xsl:value-of select="'1'"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="firstRow" select="./parent::node()/a:tblPr/@firstRow"/>
      <xsl:variable name="lastRow" select="./parent::node()/a:tblPr/@lastRow"/>
      <xsl:variable name="bandRow" select="./parent::node()/a:tblPr/@bandRow"/>
      <xsl:variable name="tblStyleName">
        <xsl:value-of select="./parent::node()/a:tblPr/a:tableStyleId"/>
    </xsl:variable>
      <xsl:for-each select="a:tc">
          <xsl:choose>
          <xsl:when test="@hMerge =1"/>
          <xsl:when test="@vMerge =1"/>
          <xsl:otherwise>
                    <xsl:variable name ="ParaId">
              <xsl:value-of select ="concat('SLTableGr',$TypeId,'PARA',position())"/>
                    </xsl:variable>
            <style:style style:family="graphic" >
                      <xsl:attribute name ="style:name">
                <xsl:value-of select ="concat('SLTableGr',$TypeId,generate-id())"/>
                      </xsl:attribute >
              <style:graphic-properties draw:auto-grow-height="false" fo:wrap-option="no-wrap" draw:stroke="solid" svg:stroke-width="0.01cm" svg:stroke-color="#000000" draw:fill="none">
                <xsl:choose>
                  <!-- No fill -->
                  <xsl:when test ="a:tcPr/a:noFill">
                    <xsl:attribute name ="draw:fill">
                      <xsl:value-of select="'none'" />
                    </xsl:attribute>
                    <xsl:attribute name ="draw:fill-color">
                      <xsl:value-of select="'#ffffff'"/>
                    </xsl:attribute>
                  </xsl:when>
                  <!-- Solid fill-->
                  <xsl:when test ="a:tcPr/a:solidFill">
                    <xsl:for-each select="a:tcPr/a:solidFill">
                      <xsl:call-template name="tmpShapeSolidFillColor">
                          <xsl:with-param name="SMName" select="$SMName"/>
                        </xsl:call-template>
                       </xsl:for-each>
                     </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each select="key('Part', 'ppt/tableStyles.xml')/a:tblStyleLst/a:tblStyle[@styleId=$tblStyleName]">
                      <xsl:choose>
                        <xsl:when test="$rowPos=1 and $firstRow=1">
                          <xsl:choose>
                            <!-- No fill -->
                            <xsl:when test ="a:firstRow/a:tcStyle/a:noFill">
                              <xsl:attribute name ="draw:fill">
                                <xsl:value-of select="'none'" />
                              </xsl:attribute>
                              <xsl:attribute name ="draw:fill-color">
                                <xsl:value-of select="'#ffffff'"/>
                              </xsl:attribute>
                            </xsl:when>
                            <!-- Solid fill-->
                            <xsl:when test ="a:firstRow/a:tcStyle/a:fill/a:solidFill">
                              <xsl:for-each select="a:firstRow/a:tcStyle/a:fill/a:solidFill">
                                <xsl:call-template name="tmpShapeSolidFillColor"/>
                              </xsl:for-each>
                             </xsl:when>
                              </xsl:choose>
                        </xsl:when>
                        <xsl:when test="$lastPos !='' and $lastRow=1">
                      <xsl:choose >
                            <!-- No fill -->
                            <xsl:when test ="a:lastRow/a:tcStyle/a:noFill">
                              <xsl:attribute name ="draw:fill">
                                <xsl:value-of select="'none'" />
                              </xsl:attribute>
                              <xsl:attribute name ="draw:fill-color">
                                <xsl:value-of select="'#ffffff'"/>
                              </xsl:attribute>
                            </xsl:when>
                            <!-- Solid fill-->
                            <xsl:when test ="a:lastRow/a:tcStyle/a:fill/a:solidFill">
                              <xsl:for-each select="a:lastRow/a:tcStyle/a:fill/a:solidFill">
                                <xsl:call-template name="tmpShapeSolidFillColor"/>
                              </xsl:for-each>
                            </xsl:when>
                      </xsl:choose>
                        </xsl:when>
                        <xsl:when test="$rowPos mod 2 != 0 and $bandRow=1">
                          <xsl:choose>
                            <!-- No fill -->
                            <xsl:when test ="a:band1H/a:tcStyle/a:noFill">
                              <xsl:attribute name ="draw:fill">
                                <xsl:value-of select="'none'" />
                              </xsl:attribute>
                              <xsl:attribute name ="draw:fill-color">
                                <xsl:value-of select="'#ffffff'"/>
                              </xsl:attribute>
                            </xsl:when>
                            <!-- Solid fill-->
                            <xsl:when test ="a:band1H/a:tcStyle/a:fill/a:solidFill">
                              <xsl:for-each select="a:band1H/a:tcStyle/a:fill/a:solidFill">
                                <xsl:call-template name="tmpShapeSolidFillColor"/>
                              </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:if test ="a:wholeTbl/a:tcStyle/a:fill/a:solidFill">
                                <xsl:for-each select="a:wholeTbl/a:tcStyle/a:fill/a:solidFill">
                                  <xsl:call-template name="tmpShapeSolidFillColor">
                                    <xsl:with-param name="SMName" select="$SMName"/>
                                   </xsl:call-template>
                                </xsl:for-each>
                              </xsl:if>
                            </xsl:otherwise>
                    </xsl:choose>
                   </xsl:when>
                        <xsl:when test="$rowPos mod 2 = 0 and $bandRow=1">
                          <xsl:choose>
                            <!-- No fill -->
                            <xsl:when test ="a:band2H/a:tcStyle/a:noFill">
                              <xsl:attribute name ="draw:fill">
                                <xsl:value-of select="'none'" />
                  </xsl:attribute >
                              <xsl:attribute name ="draw:fill-color">
                                <xsl:value-of select="'#ffffff'"/>
                              </xsl:attribute>
                            </xsl:when>
                            <!-- Solid fill-->
                            <xsl:when test ="a:band2H/a:tcStyle/a:fill/a:solidFill">
                              <xsl:for-each select="a:band2H/a:tcStyle/a:fill/a:solidFill">
                                <xsl:call-template name="tmpShapeSolidFillColor"/>
                              </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:if test ="a:wholeTbl/a:tcStyle/a:fill/a:solidFill">
                                <xsl:for-each select="a:wholeTbl/a:tcStyle/a:fill/a:solidFill">
                                  <xsl:call-template name="tmpShapeSolidFillColor"/>
                              </xsl:for-each>
                            </xsl:if>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:attribute name ="draw:fill">
                            <xsl:value-of select="'none'" />
                          </xsl:attribute>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:otherwise>
                </xsl:choose>
                  </style:graphic-properties >
               </style:style>
            <xsl:call-template name="tmpTableTextParaProp">
                  <xsl:with-param name="ParaId" select="$ParaId"/>
              <xsl:with-param name="TypeId" select="concat('SLTable',$TypeId)"/>
              <xsl:with-param name="DefFont" select="$DefFont"/>
                  <xsl:with-param name="SMName" select="$SMName"/>
                </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
              </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="tmpShapeSolidFillColor">
    <xsl:param name="SMName"/>
    <xsl:param name="fillName"/>
    
     <xsl:attribute name ="draw:fill">
       <xsl:choose>
         <xsl:when test="$fillName='gradient'">
           <xsl:value-of select="'gradient'"/>
            </xsl:when>
         <xsl:otherwise>
           <xsl:value-of select="'solid'" />
         </xsl:otherwise>
       </xsl:choose>
                    </xsl:attribute >
     <xsl:attribute name ="draw:fill-color">
     <xsl:call-template name="tmpSolidColor">
       <xsl:with-param name="SMName" select="$SMName"/>
      </xsl:call-template>
      </xsl:attribute>
    <xsl:if test="a:srgbClr/a:alpha/@val or a:schemeClr/a:alpha/@val">
       <xsl:call-template name="tmpFillTransperancy">
        <xsl:with-param name="SMName" select="$SMName"/>
                      </xsl:call-template>                        
                     </xsl:if>
  </xsl:template>
  <xsl:template name="tmpFillTransperancy">
    <xsl:param name="SMName"/>
    <xsl:choose>
      <!-- solid color -->
      <xsl:when test="a:srgbClr/a:alpha/@val">
        <xsl:variable name ="alpha">
          <xsl:value-of select ="a:srgbClr/a:alpha/@val"/>
        </xsl:variable>
        <xsl:if test="$alpha != '' or $alpha != 0">
          <xsl:attribute name ="draw:opacity">
            <xsl:value-of select="concat($alpha div 1000, '%')"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:when>
      <!--Theme color-->
      <xsl:when test ="a:schemeClr/a:alpha/@val">
        <xsl:variable name ="alpha">
          <xsl:value-of select ="a:schemeClr/a:alpha/@val"/>
        </xsl:variable>
        <xsl:if test="($alpha != '') or ($alpha != 0)">
          <xsl:attribute name ="draw:opacity">
            <xsl:value-of select="concat($alpha div 1000, '%')"/>
          </xsl:attribute>
                </xsl:if>
             </xsl:when>
          </xsl:choose>
  </xsl:template>
  <xsl:template name="tmpLineFillTransperancy">
    <xsl:param name="SMName"/>
    <xsl:choose>
      <!-- solid color -->
      <xsl:when test="a:srgbClr/a:alpha/@val">
        <xsl:variable name ="alpha">
          <xsl:value-of select ="a:srgbClr/a:alpha/@val"/>
        </xsl:variable>
        <xsl:if test="$alpha != '' or $alpha != 0">
          <xsl:attribute name ="svg:stroke-opacity">
            <xsl:value-of select="concat($alpha div 1000, '%')"/>
          </xsl:attribute>
       </xsl:if>
      </xsl:when>
      <!--Theme color-->
      <xsl:when test ="a:schemeClr/a:alpha/@val">
          <xsl:variable name ="alpha">
            <xsl:value-of select ="a:schemeClr/a:alpha/@val"/>
          </xsl:variable>
          <xsl:if test="($alpha != '') or ($alpha != 0)">
          <xsl:attribute name ="svg:stroke-opacity">
              <xsl:value-of select="concat($alpha div 1000, '%')"/>
          </xsl:attribute>
              </xsl:if>
             </xsl:when>
          </xsl:choose>
  </xsl:template>
  <xsl:template name="tmpSolidColor">
    <xsl:param name="SMName"/>
          <xsl:choose>
      <xsl:when test="a:srgbClr/@val">
        <xsl:value-of select="concat('#',a:srgbClr/@val)"/>
      </xsl:when>
      <!--Theme color-->
      <xsl:when test ="a:schemeClr/@val">
        <xsl:variable name="var_schemeClr" select="a:schemeClr/@val"/>
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
            <xsl:value-of select="a:schemeClr/a:lumMod/@val"/>
          </xsl:with-param>
          <xsl:with-param name ="lumOff">
            <xsl:value-of select="a:schemeClr/a:lumOff/@val"/>
          </xsl:with-param>
          <xsl:with-param name ="shade">
            <xsl:choose>
              <xsl:when test="a:schemeClr/a:shade/@val">
                <xsl:for-each select="a:schemeClr/a:shade/@val">
                  <xsl:value-of select=". div 1000"/>
              </xsl:for-each>
            </xsl:when>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name ="tint">
            <xsl:choose>
              <xsl:when test="a:schemeClr/a:tint/@val">
                <xsl:for-each select="a:schemeClr/a:tint/@val">
                  <xsl:value-of select=". div 100000"/>
                </xsl:for-each>
                </xsl:when>
              </xsl:choose>
            </xsl:with-param>
          <xsl:with-param name ="SMName" select="$SMName"/>
                          </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="tmpFontColor">
    <xsl:param name="SMName"/>
    <xsl:param name="varCurrentNode" select="."/>
    <xsl:choose>
      <xsl:when test ="a:solidFill">
        <xsl:for-each  select="a:solidFill">
        <xsl:attribute name="fo:color">
          <xsl:call-template name="tmpSolidColor">
                    <xsl:with-param name="SMName" select="$SMName"/>
                  </xsl:call-template>
        </xsl:attribute>
              </xsl:for-each>
            </xsl:when>
      <xsl:when test ="a:gradFill">
        <xsl:for-each select="a:gradFill/a:gsLst/child::node()[1]">
          <xsl:if test="name()='a:gs'">
            <xsl:attribute name="fo:color">
              <xsl:call-template name="tmpSolidColor">
                      <xsl:with-param name="SMName" select="$SMName"/>
                    </xsl:call-template>
            </xsl:attribute>
                  </xsl:if>
               </xsl:for-each>
            </xsl:when>
      <xsl:when test ="./parent::node()/parent::node()/parent::node()/parent::node()/p:style/a:fontRef">
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/parent::node()/p:style/a:fontRef">
          <xsl:attribute name="fo:color">
            <xsl:call-template name="tmpSolidColor"/>
          </xsl:attribute>
              </xsl:for-each>
            </xsl:when>
      <xsl:when test ="$varCurrentNode/a:solidFill">
        <xsl:for-each  select="$varCurrentNode/a:solidFill">
          <xsl:attribute name="fo:color">
            <xsl:call-template name="tmpSolidColor">
              <xsl:with-param name="SMName" select="$SMName"/>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test ="$varCurrentNode/a:gradFill">
        <xsl:for-each select="$varCurrentNode/a:gradFill/a:gsLst/child::node()[1]">
          <xsl:if test="name()='a:gs'">
            <xsl:attribute name="fo:color">
              <xsl:call-template name="tmpSolidColor">
                <xsl:with-param name="SMName" select="$SMName"/>
              </xsl:call-template>
            </xsl:attribute>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>      
          </xsl:choose>
       </xsl:template>
  <!--Template for set brightness & contrast-->
  <xsl:template name="BrightContrast">
    <xsl:if test="@bright">
      <xsl:choose>
        <xsl:when test="@bright">
          <xsl:variable name="brightVal">
            <xsl:value-of select="@bright"/>
          </xsl:variable>
          <xsl:attribute name="draw:luminance">
            <xsl:value-of select="concat($brightVal div 1000,'%')"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
    </xsl:if >
    <xsl:if test="@contrast">
      <xsl:choose>
        <xsl:when test="@contrast">
          <xsl:variable name="contrastVal">
            <xsl:value-of select="@contrast"/>
          </xsl:variable>
          <xsl:attribute name="draw:contrast">
            <xsl:value-of select="concat($contrastVal div 1000,'%')"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
    </xsl:if >
  </xsl:template>
  <!--Maps the footer date format with pptx to odp -->
  <xsl:template name ="FooterDateFormat">
    <xsl:param name ="type" />
    <xsl:choose>
      <xsl:when test ="$type ='datetime1'">
        <xsl:value-of select ="'D3'"/>
      </xsl:when>
      <xsl:when test ="$type ='datetime2'">
        <xsl:value-of select ="'D8'"/>
      </xsl:when>
      <xsl:when test ="$type ='datetime4'">
        <xsl:value-of select ="'D6'"/>
      </xsl:when>
      <xsl:when test ="$type ='datetime4'">
        <xsl:value-of select ="'D5'"/>
      </xsl:when>
      <xsl:when test ="$type ='datetime8'">
        <xsl:value-of select ="'D3T2'"/>
      </xsl:when>
      <xsl:when test ="$type ='datetime8'">
        <xsl:value-of select ="'D3T5'"/>
      </xsl:when>
      <xsl:when test ="$type ='datetime10'">
        <xsl:value-of select ="'T2'"/>
      </xsl:when>
      <xsl:when test ="$type ='datetime11'">
        <xsl:value-of select ="'T3'"/>
      </xsl:when>
      <xsl:when test ="$type ='datetime12'">
        <xsl:value-of select ="'T5'"/>
      </xsl:when>
      <xsl:when test ="$type ='datetime13'">
        <xsl:value-of select ="'T6'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select ="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name ="DateFormats">
    <number:date-style style:name="D8">
      <number:day-of-week number:style="long" />
      <number:text>,</number:text>
      <number:day />
      <number:text>.</number:text>
      <number:month number:style="long" number:textual="true" />
      <number:text />
      <number:year number:style="long" />
    </number:date-style>
    <number:date-style style:name="D6">
      <number:day />
      <number:text>.</number:text>
      <number:month number:style="long" number:textual="true" />
      <number:text />
      <number:year number:style="long" />
    </number:date-style>
    <number:date-style style:name="D5">
      <number:day />
      <number:text>.</number:text>
      <number:month number:textual="true" />
      <number:text />
      <number:year number:style="long" />
    </number:date-style>
    <number:date-style style:name="D3T2">
      <number:day number:style="long" />
      <number:text>.</number:text>
      <number:month number:style="long" />
      <number:text>.</number:text>
      <number:year />
      <number:text />
      <number:hours />
      <number:text>:</number:text>
      <number:minutes />
    </number:date-style>
    <number:date-style style:name="D3T5">
      <number:day number:style="long" />
      <number:text>.</number:text>
      <number:month number:style="long" />
      <number:text>.</number:text>
      <number:year />
      <number:text />
      <number:hours />
      <number:text>:</number:text>
      <number:minutes />
      <number:am-pm />
    </number:date-style>
    <number:time-style style:name="T2">
      <number:hours />
      <number:text>:</number:text>
      <number:minutes />
    </number:time-style>
    <number:time-style style:name="T3">
      <number:hours />
      <number:text>:</number:text>
      <number:minutes />
      <number:text>:</number:text>
      <number:seconds />
    </number:time-style>
    <number:time-style style:name="T5">
      <number:hours />
      <number:text>:</number:text>
      <number:minutes />
      <number:am-pm />
    </number:time-style>
    <number:time-style style:name="T6">
      <number:hours />
      <number:text>:</number:text>
      <number:minutes />
      <number:text>:</number:text>
      <number:seconds />
      <number:am-pm />
    </number:time-style>
    <number:date-style style:name="D3">
      <number:day number:style="long" />
      <number:text>.</number:text>
      <number:month number:style="long" />
      <number:text>.</number:text>
      <number:year />
    </number:date-style>
  </xsl:template>
    <!-- Template added by vijayeta to fix bug 1739076,get font family from slide layout-->
  <!--Get SlideLayout type-->
   <xsl:template name ="GetLayOutName">
    <xsl:param name ="slideName"/>
    <xsl:variable name ="SlideRelation">
      <xsl:value-of select ="concat('ppt/slides/_rels/',$slideName,'.rels')"/>
    </xsl:variable >
    <xsl:variable name ="LayoutName">
      <xsl:for-each select ="key('Part', $SlideRelation)//node()/@Target[contains(.,'slideLayouts')]">
        <xsl:value-of select="substring-after(.,'..')"/>
      </xsl:for-each>
    </xsl:variable >
    <xsl:for-each select ="key('Part', concat('ppt',$LayoutName))/p:sldLayout/@type">
      <xsl:variable name ="SlideLayoutType">
        <xsl:value-of select="."/>
      </xsl:variable>
      <xsl:choose >
        <!--Title and chart-->
        <xsl:when test="$SlideLayoutType='chart'">
          <xsl:value-of select="'AL6T2'"/>
        </xsl:when>
        <!--Title, chart on left and text on right-->
        <xsl:when test="$SlideLayoutType='txAndChart'">
          <xsl:value-of select="'AL9T4'"/>
        </xsl:when>
        <xsl:when test="$SlideLayoutType='chartAndTx'">
          <xsl:value-of select="'AL11T7'"/>
        </xsl:when>
        <!--Title, clipart on left, text on right-->
        <xsl:when test="$SlideLayoutType='clipArtAndTx'">
          <xsl:value-of select="'AL8T9'"/>
        </xsl:when>
        <!--Title and four objects-->
        <xsl:when test="$SlideLayoutType='fourObj'">
          <xsl:value-of select="'AL19T18'"/>
        </xsl:when>
        <!--Title, object on left, text on right-->
        <xsl:when test="$SlideLayoutType='objAndTx'">
          <xsl:value-of select="'AL14T13'"/>
        </xsl:when>
        <!--Title, object on top, text on bottom-->
        <xsl:when test="$SlideLayoutType='objOverTx'">
          <xsl:value-of select="'AL15T14'"/>
        </xsl:when>
        <!--Title and table-->
        <xsl:when test="$SlideLayoutType='tbl'">
          <xsl:value-of select="'AL7T8'"/>
        </xsl:when>
        <!--Title only-->
        <xsl:when test="$SlideLayoutType='titleOnly'">
          <xsl:value-of  select ="'AL4T19'"/>
        </xsl:when>
        <!--Title layout with centered title and subtitle placeholders-->
        <xsl:when test="$SlideLayoutType='title' or $SlideLayoutType='secHead'">
          <xsl:value-of  select ="'AL1T0'"/>
        </xsl:when>
        <!--Title, text on left, text on right-->
        <xsl:when test="$SlideLayoutType='twoColTx' or $SlideLayoutType='twoObj' or $SlideLayoutType='twoTxTwoObj'">
          <xsl:value-of select="'AL3T3'"/>
        </xsl:when>
        <!--Title, two objects on left, text on right-->
        <xsl:when test="$SlideLayoutType='twoObjAndTx'">
          <xsl:value-of select="'AL16T15'"/>
        </xsl:when>
        <!--Title, two objects on top, text on bottom-->
        <xsl:when test="$SlideLayoutType='twoObjOverTx'">
          <xsl:value-of select="'AL17T16'"/>
        </xsl:when>
        <!--Title and text-->
        <xsl:when test="$SlideLayoutType='tx' or $SlideLayoutType='obj'">
          <xsl:value-of  select ="'AL2T1'"/>
        </xsl:when>
        <!--Title, text on left and chart on right-->
        <xsl:when test="$SlideLayoutType='txAndChart'">
          <xsl:value-of select="'AL9T4'"/>
        </xsl:when>
        <!--Title, text on left, clip art on right-->
        <xsl:when test="$SlideLayoutType='txAndClipArt'">
          <xsl:value-of select="'AL10T6'"/>
        </xsl:when>
        <!--Title, text on left, object on right-->
        <xsl:when test="$SlideLayoutType='txAndObj'">
          <xsl:value-of select="'AL12T10'"/>
        </xsl:when>
        <!--Title, text on left, two objects on right-->
        <xsl:when test="$SlideLayoutType='txAndTwoObj'">
          <xsl:value-of select="'AL13T12'"/>
        </xsl:when>
        <!--Title, text on top, object on bottom-->
        <xsl:when test="$SlideLayoutType='txOverObj'">
          <xsl:value-of select="'AL18T17'"/>
        </xsl:when>      
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
 	<!-- aDDED BY VIJAYEA, TO GET SLIDE MASTER, ON 15TH JULY-->
	<xsl:template name ="getmasterFromLayout">
		<xsl:param name ="layoutFile"/>
		<xsl:variable name="slideMasterName">
			<xsl:for-each select ="key('Part', concat($layoutFile,'.rels'))//node()/@Target[contains(.,'slideMasters')]">
				<xsl:value-of  select ="substring-after(.,'../slideMasters/')"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select ="$slideMasterName"/>
	</xsl:template>
	<!-- aDDED BY VIJAYEA, TO GET SLIDE MASTER, ON 15TH JULY-->
  <xsl:template name ="GetMasterFileName">
    <xsl:param name ="slideId"/>
    <xsl:variable name ="layoutName">
      <xsl:value-of select ="key('Part', concat('ppt/slides/_rels/','slide',$slideId,'.xml.rels'))//node()/@Target[ contains(.,'Layout')]"/>
    </xsl:variable>
    <xsl:variable name ="lauoutReln">
      <xsl:value-of select ="concat('ppt/slideLayouts/_rels/', substring($layoutName,17),'.rels')"/>
    </xsl:variable>
    <xsl:variable name ="slideMaster">
      <xsl:value-of select ="key('Part', $lauoutReln)//node()/@Target[ contains(.,'slideMaster')]"/>
    </xsl:variable>
    <xsl:value-of select ="substring-before(substring($slideMaster,17),'.xml')"/>
  </xsl:template>
  <!-- added by Vipul to get back color of title, sub title, outline from slide layout-->
  <!-- start-->
    <xsl:template name="tmpCommanTextProperty">
    <xsl:param name="LayoutFileName"/>
    <xsl:param name="spType"/>
    <xsl:param name="index"/>
    <xsl:param name ="DefFont" />
    <xsl:param name ="fontscale"/>
    <xsl:param name ="level"/>
    <xsl:param name ="SMName"/>
        <!--Code changes done by yeswanth.s : 5-Feb-09 : font size & font name into outline-->        
        <xsl:variable name="varNodeLevel" select="concat('a:lvl',$level + 1,'pPr')"/>      
    <xsl:for-each select ="a:rPr">
    <xsl:call-template name="tmpSlideTextProperty">
      <xsl:with-param name="DefFont" select="$DefFont"/>
      <xsl:with-param name="fontscale" select="$fontscale"/>
      <xsl:with-param name="index" select ="$index"/>
      <xsl:with-param name="SMName" select ="$SMName"/>
        <xsl:with-param name="varCurrentNode" select="./parent::node()/parent::node()/parent::node()/a:lstStyle/child::node()[name() = $varNodeLevel]/a:defRPr"/>
    </xsl:call-template>
        </xsl:for-each>

      <xsl:call-template name="tmpSlideTextPrFromLayout">
        <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
        <xsl:with-param name="spType" select="$spType"/>
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name ="DefFont" select="$DefFont"/>
        <xsl:with-param name ="fontscale" select="$fontscale"/>
        <xsl:with-param name ="level" select="$level"/>
        <xsl:with-param name ="SMName" select="$SMName"/>
      </xsl:call-template>
        
  </xsl:template>
  
  <!--template added by yeswanth.s : 11-Feb-09-->
  <xsl:template name="tmpSlideTextPrFromLayout">
    <xsl:param name="LayoutFileName"/>
    <xsl:param name="spType"/>
    <xsl:param name="index"/>
    <xsl:param name ="DefFont" />
    <xsl:param name ="fontscale"/>
    <xsl:param name ="level"/>
    <xsl:param name ="SMName"/>
    <xsl:if test ="not(a:rPr/@sz or ./parent::node()/parent::node()/parent::node()/a:lstStyle/a:defPPr/a:defRPr/@sz)">
            <xsl:call-template name ="tmpTextProperty">
            <xsl:with-param name ="AttrType" select ="'Fontsize'"/>
            <xsl:with-param name ="level" select ="$level+1"/>
            <xsl:with-param name="SMName" select="$SMName"/>
            <xsl:with-param name ="fs" select ="$fontscale"/>
              <xsl:with-param name ="DefFont" select ="$DefFont"/>
            <xsl:with-param name="spType" select="$spType"/>
            <xsl:with-param name="index" select="$index"/>
            <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
            </xsl:call-template>
           </xsl:if>
    <xsl:if test="not(a:rPr/a:latin/@typeface or ./parent::node()/parent::node()/parent::node()/a:lstStyle/a:defPPr/a:defRPr/@typeface)">
         <xsl:call-template name ="tmpTextProperty">
           <xsl:with-param name ="AttrType" select ="'Fontname'"/>
            <xsl:with-param name ="level" select ="$level+1"/>
            <xsl:with-param name="SMName" select="$SMName"/>
            <xsl:with-param name ="fs" select ="$fontscale"/>
            <xsl:with-param name ="DefFont" select ="$DefFont" />
            <xsl:with-param name="spType" select="$spType"/>
            <xsl:with-param name="index" select="$index"/>
            <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
            </xsl:call-template>
           </xsl:if>
    <!-- strike style:text-line-through-style-->
    <xsl:if test ="not(a:rPr/@strike  or ./parent::node()/parent::node()/parent::node()/a:lstStyle/a:defPPr/a:defRPr/@strike)">
        <xsl:call-template name ="tmpTextProperty">
              <xsl:with-param name ="AttrType" select ="'strike'"/>
            <xsl:with-param name ="level" select ="$level+1"/>
                  <xsl:with-param name ="SMName" select ="$SMName"/>
            <xsl:with-param name ="fs" select ="$fontscale"/>
            <xsl:with-param name ="DefFont" select ="$DefFont" />
            <xsl:with-param name="spType" select="$spType"/>
            <xsl:with-param name="index" select="$index"/>
            <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                </xsl:call-template>
               </xsl:if>
	  <!-- Superscript and Subscript style:text-properties (added by Mathi on 1st Aug 2007)-->
	<xsl:if test ="not(a:rPr/@baseline)">
	 <xsl:call-template name ="tmpTextProperty">
						  <xsl:with-param name ="AttrType" select ="'SubSuperScript'"/>
                  <xsl:with-param name ="level" select ="$level+1"/>
            <xsl:with-param name="SMName" select="$SMName"/>
            <xsl:with-param name ="fs" select ="$fontscale"/>
            <xsl:with-param name ="DefFont" select ="$DefFont" />
            <xsl:with-param name="spType" select="$spType"/>
            <xsl:with-param name="index" select="$index"/>
            <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                </xsl:call-template>
             		  </xsl:if>
	   <!-- Kening Property-->
    <xsl:if test ="not(a:rPr/@kern or ./parent::node()/parent::node()/parent::node()/a:lstStyle/a:defPPr/a:defRPr/@kern)">
          <xsl:call-template name ="tmpTextProperty">
                  <xsl:with-param name ="AttrType" select ="'Kerning'"/>
                  <xsl:with-param name ="level" select ="$level+1"/>
            <xsl:with-param name="SMName" select="$SMName"/>
            <xsl:with-param name ="fs" select ="$fontscale"/>
            <xsl:with-param name ="DefFont" select ="$DefFont" />
            <xsl:with-param name="spType" select="$spType"/>
            <xsl:with-param name="index" select="$index"/>
            <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                </xsl:call-template>
            </xsl:if >
    <!-- Bold Property-->
    <xsl:if test ="not(a:rPr/@b  or ./parent::node()/parent::node()/parent::node()/a:lstStyle/a:defPPr/a:defRPr/@b)">
          <xsl:call-template name ="tmpTextProperty">
                  <xsl:with-param name ="AttrType" select ="'Fontweight'"/>
                  <xsl:with-param name ="level" select ="$level+1"/>
            <xsl:with-param name="SMName" select="$SMName"/>
            <xsl:with-param name ="fs" select ="$fontscale"/>
            <xsl:with-param name ="DefFont" select ="$DefFont" />
            <xsl:with-param name="spType" select="$spType"/>
            <xsl:with-param name="index" select="$index"/>
            <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                </xsl:call-template>

    </xsl:if >
    <!--UnderLine-->
    <xsl:if test ="not(a:rPr/@u  or ./parent::node()/parent::node()/parent::node()/a:lstStyle/a:defPPr/a:defRPr/@u)">
          <xsl:call-template name ="tmpTextProperty">
                  <xsl:with-param name ="AttrType" select ="'Underline'"/>
                  <xsl:with-param name ="level" select ="$level+1"/>
            <xsl:with-param name="SMName" select="$SMName"/>
            <xsl:with-param name ="fs" select ="$fontscale"/>
            <xsl:with-param name ="DefFont" select ="$DefFont" />
            <xsl:with-param name="spType" select="$spType"/>
            <xsl:with-param name="index" select="$index"/>
            <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                </xsl:call-template>
             </xsl:if >
    <!-- Italic-->
    <xsl:if test ="not(a:rPr/@i  or ./parent::node()/parent::node()/parent::node()/a:lstStyle/a:defPPr/a:defRPr/@i)">
          <xsl:call-template name ="tmpTextProperty">
                  <xsl:with-param name ="AttrType" select ="'italic'"/>
                  <xsl:with-param name ="level" select ="$level+1"/>
            <xsl:with-param name="SMName" select="$SMName"/>
            <xsl:with-param name ="fs" select ="$fontscale"/>
            <xsl:with-param name ="DefFont" select ="$DefFont" />
            <xsl:with-param name="spType" select="$spType"/>
            <xsl:with-param name="index" select="$index"/>
            <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                </xsl:call-template>

    </xsl:if >
    <!-- Character Spacing -->
    <xsl:if test ="not(a:rPr/@spc  or ./parent::node()/parent::node()/parent::node()/a:lstStyle/a:defPPr/a:defRPr/@spc)">
          <xsl:call-template name ="tmpTextProperty">
             <xsl:with-param name ="AttrType" select ="'charspacing'"/>
             <xsl:with-param name ="level" select ="$level+1"/>
             <xsl:with-param name="SMName" select="$SMName"/>
            <xsl:with-param name ="fs" select ="$fontscale"/>
            <xsl:with-param name ="DefFont" select ="$DefFont" />
            <xsl:with-param name="spType" select="$spType"/>
            <xsl:with-param name="index" select="$index"/>
            <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                      </xsl:call-template>
        </xsl:if>
        <xsl:if test ="not(a:rPr/a:solidFill/a:srgbClr/@val) and not(a:rPr/a:solidFill/a:schemeClr/@val) and 
                    not(parent::node()/parent::node()/parent::node()/p:style/a:fontRef)">
          <xsl:call-template name ="tmpTextProperty">
                        <xsl:with-param name ="AttrType" select ="'Fontcolor'"/>
                        <xsl:with-param name ="level" select ="$level+1"/>
                        <xsl:with-param name="SMName" select="$SMName"/>
            <xsl:with-param name ="fs" select ="$fontscale"/>
            <xsl:with-param name ="DefFont" select ="$DefFont" />
            <xsl:with-param name="spType" select="$spType"/>
            <xsl:with-param name="index" select="$index"/>
            <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                      </xsl:call-template>
              </xsl:if>
    <xsl:if test ="a:rPr/a:effectLst/a:outerShdw">
      <xsl:attribute name ="fo:text-shadow">
        <xsl:value-of select ="'1pt 1pt'"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test ="not(a:rPr/a:effectLst/a:outerShdw)">
          <xsl:call-template name ="tmpTextProperty">
                  <xsl:with-param name ="AttrType" select ="'Textshadow'"/>
                  <xsl:with-param name ="level" select ="$level+1"/>
            <xsl:with-param name="SMName" select="$SMName"/>
            <xsl:with-param name ="fs" select ="$fontscale"/>
            <xsl:with-param name ="DefFont" select ="$DefFont" />
            <xsl:with-param name="spType" select="$spType"/>
            <xsl:with-param name="index" select="$index"/>
            <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                </xsl:call-template>
              </xsl:if>
  </xsl:template>
  <xsl:template name="tmpTextProperty">
    <xsl:param name ="DefFont" />
    <xsl:param name ="AttrType" />
    <xsl:param name ="fs" />
    <xsl:param name="level"/>
    <xsl:param name="SMName"/>
    <xsl:param name="LayoutFileName"/>
    <xsl:param name="spType"/>
    <xsl:param name="index"/>
    <xsl:variable name="nodeName" select="concat('a:lvl',$level ,'pPr')"/>
    <xsl:choose>
      <xsl:when  test="$spType='outline'">
        <xsl:for-each select="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@idx=$index and ( not(@type) or @type='body')]">
          <xsl:for-each select="parent::node()/parent::node()/parent::node()/p:txBody">
            <xsl:call-template name="tmpLayoutTextProp">
              <xsl:with-param name="AttrType" select="$AttrType"/>
              <xsl:with-param name="SMName" select="$SMName"/>
              <xsl:with-param name="spType" select="$spType"/>
              <xsl:with-param name="fs" select="$fs"/>
              <xsl:with-param name="DefFont" select="$DefFont"/>
              <xsl:with-param name="nodeName" select="$nodeName"/>
          </xsl:call-template>
	 </xsl:for-each>
        </xsl:for-each>
      </xsl:when>
      <xsl:when  test="$spType='title'">
        <xsl:for-each select="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='title' or @type='ctrTitle']">
          <xsl:for-each select="parent::node()/parent::node()/parent::node()/p:txBody">
            <xsl:call-template name="tmpLayoutTextProp">
              <xsl:with-param name="AttrType" select="$AttrType"/>
              <xsl:with-param name="SMName" select="$SMName"/>
              <xsl:with-param name="spType" select="$spType"/>
              <xsl:with-param name="fs" select="$fs"/>
              <xsl:with-param name="DefFont" select="$DefFont"/>
              <xsl:with-param name="nodeName" select="$nodeName"/>
          </xsl:call-template>
	    </xsl:for-each>
        </xsl:for-each>
          </xsl:when>
      <xsl:when  test="$spType='subtitle'">
        <xsl:for-each select="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='subTitle']">
          <xsl:for-each select="parent::node()/parent::node()/parent::node()/p:txBody">
            <xsl:call-template name="tmpLayoutTextProp">
              <xsl:with-param name="AttrType" select="$AttrType"/>
              <xsl:with-param name="SMName" select="$SMName"/>
              <xsl:with-param name="spType" select="$spType"/>
              <xsl:with-param name="fs" select="$fs"/>
              <xsl:with-param name="DefFont" select="$DefFont"/>
              <xsl:with-param name="nodeName" select="$nodeName"/>
          </xsl:call-template>
	   </xsl:for-each>
             </xsl:for-each>
           </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="tmpLayoutTextProp">
    <xsl:param name ="AttrType" />
      <xsl:param name="SMName"/>
    <xsl:param name="spType"/>
    <xsl:param name="nodeName"/>
    <xsl:param name ="fs" />
    <xsl:param name ="DefFont" />
      <xsl:choose>
          <xsl:when test="$AttrType='Fontname'">
            <xsl:for-each select="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr">
        <xsl:call-template name="tmpFontName">
          <xsl:with-param name="DefFont" select="$DefFont"/>
          </xsl:call-template>
              </xsl:for-each>
          </xsl:when>
          <xsl:when test="$AttrType='Fontsize'">
        <xsl:if test="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@sz">
          <xsl:call-template name="tmpFontSize">
            <xsl:with-param name="fontscale" select="$fs"/>
            <xsl:with-param name="sz" select="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@sz"/>
          </xsl:call-template>
            </xsl:if>
        <xsl:if test="not(a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@sz)">
              <xsl:variable name="var_SMFontSize">
            <xsl:choose>
              <xsl:when test="$spType='title'">
                <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:titleStyle/child::node()[name()=$nodeName]/a:defRPr/@sz">
                  <xsl:value-of select ="."/>
                </xsl:for-each>
              </xsl:when>
                  <xsl:otherwise>
                <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]/a:defRPr/@sz">
                  <xsl:value-of select ="."/>
                        </xsl:for-each>
                  </xsl:otherwise>
                    </xsl:choose>
                 </xsl:variable>
          <xsl:call-template name="tmpFontSize">
            <xsl:with-param name="fontscale" select="$fs"/>
            <xsl:with-param name="sz" select="$var_SMFontSize"/>
          </xsl:call-template>
				</xsl:if>
			</xsl:when>
          <xsl:when test="$AttrType='Fontweight'">
        <xsl:if test ="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@b">
          <xsl:for-each select="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr">
            <xsl:call-template name="tmpFontWeight">
              <xsl:with-param name="b" select="@b"/>
            </xsl:call-template>
          </xsl:for-each>
            </xsl:if>
          </xsl:when>
          <xsl:when test="$AttrType='Kerning'">
        <xsl:if test="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@kern">
          <xsl:for-each select="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr">
            <xsl:call-template name="tmpKerning">
              <xsl:with-param name="kern" select="@kern"/>
            </xsl:call-template>
          </xsl:for-each>
            </xsl:if>
          </xsl:when>
          <xsl:when test="$AttrType='Underline'">
        <xsl:if test="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@u">
          <xsl:for-each select="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr">
          <xsl:call-template name="tmpUnderLine">
            <xsl:with-param name="SMName" select="$SMName"/>
              <xsl:with-param name="u" select="@u"/>
          </xsl:call-template>
          </xsl:for-each>
            </xsl:if>
          </xsl:when>
          <xsl:when test="$AttrType='italic'">
        <xsl:if test ="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@i">
          <xsl:for-each select="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr">
            <xsl:call-template name="tmpFontItalic">
              <xsl:with-param name="i" select="@i"/>
            </xsl:call-template>
          </xsl:for-each>
            </xsl:if>
          </xsl:when>
          <xsl:when test="$AttrType='charspacing'">
        <xsl:if test ="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@spc">
          <xsl:for-each select="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr">
            <xsl:call-template name="tmpletterSpacing">
              <xsl:with-param name="spc" select="@spc"/>
            </xsl:call-template>
          </xsl:for-each>
            </xsl:if>
          </xsl:when>
          <xsl:when test="$AttrType='Fontcolor'">
            <xsl:for-each select="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr">
        <xsl:call-template name="tmpFontColor">
          <xsl:with-param name="SMName" select="$SMName"/>
                <xsl:with-param name="varCurrentNode" select="."/>
                    </xsl:call-template>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="$AttrType='strike'">
        <xsl:if test ="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@strike">
          <xsl:for-each select="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr">
            <xsl:call-template name="tmpstrike">
              <xsl:with-param name="strike" select="@strike"/>
            </xsl:call-template>
          </xsl:for-each>
            </xsl:if>
          </xsl:when>
          <xsl:when test="$AttrType='Textshadow'">
        <xsl:if test ="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/a:effectLst/a:outerShdw">
          <xsl:call-template name="tmpTextOuterShdw"/>
            </xsl:if>
          </xsl:when>
	<!-- Superscript and Subscript added by Mathi on 1st Aug 2007 -->
			<xsl:when test="$AttrType='SubSuperScript'">
        <xsl:if test="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@baseline">
          <xsl:variable name="subSuperScriptValue">
            <xsl:value-of select="number(format-number(a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@baseline div 1000,'#'))"/>
							</xsl:variable>
          <xsl:call-template name="tmpSubSuperScript">
            <xsl:with-param name="baseline" select="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@baseline"/>
            <xsl:with-param name="subSuperScriptValue" select="$subSuperScriptValue"/>
          </xsl:call-template>
				</xsl:if>
			</xsl:when>
    </xsl:choose>
  </xsl:template>
  
       <xsl:template name="tmpCommanParaProperty">
    <xsl:param name="LayoutFileName"/>
    <xsl:param name="spType"/>
    <xsl:param name="index"/>
    <xsl:param name ="lnSpcReduction"/>
    <xsl:param name ="level"/>
    <xsl:param name ="SMName"/>
    
    <xsl:call-template name="tmpSlideParagraphStyle">
      <xsl:with-param name="lnSpcReduction" select="$lnSpcReduction"/>
      <xsl:with-param name ="SMName" select ="$SMName"/>
    </xsl:call-template>
    <xsl:if test ="not(a:pPr/@algn)">
      <xsl:call-template name ="tmpParaProperty">
                  <xsl:with-param name ="AttrType" select ="'TextAlignment'"/>
                  <xsl:with-param name ="level" select ="$level+1"/>
        <xsl:with-param name="SMName" select="$SMName"/>
         <xsl:with-param name="lnSpaceRed" select="$lnSpcReduction"/>
                  <xsl:with-param name ="spType" select ="$spType"/>
                  <xsl:with-param name ="index" select ="$index"/>
        <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                </xsl:call-template>
    </xsl:if>
    <xsl:if test ="not(a:pPr/@marL)">
      <xsl:call-template name ="tmpParaProperty">
                  <xsl:with-param name ="AttrType" select ="'marginLeft'"/>
                       <xsl:with-param name ="level" select ="$level+1"/>
        <xsl:with-param name="SMName" select="$SMName"/>
        <xsl:with-param name="lnSpaceRed" select="$lnSpcReduction"/>
                  <xsl:with-param name ="spType" select ="$spType"/>
                  <xsl:with-param name ="index" select ="$index"/>
        <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                </xsl:call-template>
             </xsl:if>
       <xsl:if test ="not(a:pPr/@indent)">
      <xsl:call-template name ="tmpParaProperty">
                  <xsl:with-param name ="AttrType" select ="'indent'"/>
                  <xsl:with-param name ="level" select ="$level+1"/>
        <xsl:with-param name="SMName" select="$SMName"/>
        <xsl:with-param name="lnSpaceRed" select="$lnSpcReduction"/>
        <xsl:with-param name="spType" select="$spType"/>
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                </xsl:call-template>
             </xsl:if>
    <xsl:choose>
      <xsl:when test ="not(a:pPr/a:spcBef/a:spcPct/@val) and not(a:pPr/a:spcBef/a:spcPts/@val)">
        <xsl:variable name="var_MaxFntSize">
          <xsl:choose>
            <xsl:when test="./a:r/a:rPr/@sz">
          <xsl:for-each select="./a:r/a:rPr/@sz">
            <xsl:sort data-type="number" order="descending"/>
            <xsl:if test="position()=1">
              <xsl:value-of select="."/>
            </xsl:if>
          </xsl:for-each>
            </xsl:when>
            <xsl:when test="./a:endParaRPr/@sz">
              <xsl:for-each select="./a:endParaRPr/@sz">
                <xsl:sort data-type="number" order="descending"/>
                <xsl:if test="position()=1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:call-template name ="tmpParaProperty">
           <xsl:with-param name ="AttrType" select ="'marginTop'"/>
           <xsl:with-param name ="level" select ="$level+1"/>
          <xsl:with-param name="SMName" select="$SMName"/>
          <xsl:with-param name="lnSpaceRed" select="$lnSpcReduction"/>
          <xsl:with-param name="spType" select="$spType"/>
          <xsl:with-param name="index" select="$index"/>
          <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
           <xsl:with-param name ="MaxFontSz" select ="$var_MaxFntSize"/>
       </xsl:call-template>
       </xsl:when>
       <xsl:when test ="not(a:pPr/a:spcAft/a:spcPct/@val) and not(a:pPr/a:spcAft/a:spcPts/@val)">
        <xsl:variable name="var_MaxFntSize">
          <xsl:choose>
            <xsl:when test="./a:r/a:rPr/@sz">
          <xsl:for-each select="./a:r/a:rPr/@sz">
            <xsl:sort data-type="number" order="descending"/>
            <xsl:if test="position()=1">
              <xsl:value-of select="."/>
            </xsl:if>
          </xsl:for-each>
            </xsl:when>
            <xsl:when test="./a:endParaRPr/@sz">
              <xsl:for-each select="./a:endParaRPr/@sz">
                <xsl:sort data-type="number" order="descending"/>
                <xsl:if test="position()=1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:call-template name ="tmpParaProperty">
          <xsl:with-param name ="AttrType" select ="'marginBottom'"/>
          <xsl:with-param name ="level" select ="$level+1"/>
          <xsl:with-param name="SMName" select="$SMName"/>
          <xsl:with-param name="lnSpaceRed" select="$lnSpcReduction"/>
          <xsl:with-param name="spType" select="$spType"/>
          <xsl:with-param name="index" select="$index"/>
          <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                      <xsl:with-param name ="MaxFontSz" select ="$var_MaxFntSize"/>
                    </xsl:call-template>
                  </xsl:when>
                </xsl:choose>
      <!-- If the line space is in Percentage-->
    <xsl:if test ="not(a:pPr/a:lnSpc/a:spcPct/@val) and not(a:pPr/a:lnSpc/a:spcPts/@val)">
      <xsl:call-template name ="tmpParaProperty">
        <xsl:with-param name ="AttrType" select ="'lineSpacing'"/>
        <xsl:with-param name ="level" select ="$level+1"/>
        <xsl:with-param name="SMName" select="$SMName"/>
                  <xsl:with-param name ="lnSpaceRed" select ="$lnSpcReduction"/>
        <xsl:with-param name="spType" select="$spType"/>
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                </xsl:call-template>
                </xsl:if>
<!--Added by sanjay to fixed the bug no1958740-->
    <xsl:if test="not(./parent::node()/p:txBody/a:bodyPr/@vert)">
      <xsl:call-template name ="tmpParaProperty">
                  <xsl:with-param name ="AttrType" select ="'Textdirection'"/>
                  <xsl:with-param name ="level" select ="$level+1"/>
        <xsl:with-param name="SMName" select="$SMName"/>
        <xsl:with-param name="lnSpaceRed" select="$lnSpcReduction"/>
        <xsl:with-param name="spType" select="$spType"/>
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="LayoutFileName" select="$LayoutFileName"/>
                </xsl:call-template>
             </xsl:if>
  </xsl:template>
  <xsl:template name="tmpParaProperty">
    <xsl:param name ="AttrType" />
    <xsl:param name="spType"/>
    <xsl:param name ="lnSpaceRed" />
    <xsl:param name="level"/>
    <xsl:param name="MaxFontSz"/>
    <xsl:param name="SMName"/>
    <xsl:param name="LayoutFileName"/>
    <xsl:param name="index"/>
    <xsl:variable name="nodeName" select="concat('a:lvl',$level ,'pPr')"/>
    <xsl:choose>
      <xsl:when  test="$spType='outline'">
        <xsl:for-each select="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@idx=$index and ( not(@type) or @type='body')]">
          <xsl:for-each select="parent::node()/parent::node()/parent::node()/p:txBody">
            <xsl:call-template name="tmpLayoutParaProp">
              <xsl:with-param name="AttrType" select="$AttrType"/>
              <xsl:with-param name="SMName" select="$SMName"/>
              <xsl:with-param name="spType" select="$spType"/>
              <xsl:with-param name="lnSpaceRed" select="$lnSpaceRed"/>
              <xsl:with-param name="nodeName" select="$nodeName"/>
              <xsl:with-param name="index" select="$index"/>
              <xsl:with-param name="MaxFontSz" select="$MaxFontSz"/>
            </xsl:call-template>
              </xsl:for-each>
           </xsl:for-each>
         </xsl:when>
      <xsl:when  test="$spType='title'">
        <xsl:for-each select="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='title' or @type='ctrTitle']">
          <xsl:for-each select="parent::node()/parent::node()/parent::node()/p:txBody">
            <xsl:call-template name="tmpLayoutParaProp">
              <xsl:with-param name="AttrType" select="$AttrType"/>
              <xsl:with-param name="SMName" select="$SMName"/>
              <xsl:with-param name="spType" select="$spType"/>
              <xsl:with-param name="lnSpaceRed" select="$lnSpaceRed"/>
              <xsl:with-param name="nodeName" select="$nodeName"/>
              <xsl:with-param name="index" select="$index"/>
              <xsl:with-param name="MaxFontSz" select="$MaxFontSz"/>
            </xsl:call-template>
              </xsl:for-each>
            </xsl:for-each>
         </xsl:when>
      <xsl:when  test="$spType='subtitle'">
        <xsl:for-each select="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='subTitle']">
          <xsl:for-each select="parent::node()/parent::node()/parent::node()/p:txBody">
            <xsl:call-template name="tmpLayoutParaProp">
              <xsl:with-param name="AttrType" select="$AttrType"/>
              <xsl:with-param name="SMName" select="$SMName"/>
              <xsl:with-param name="spType" select="$spType"/>
              <xsl:with-param name="lnSpaceRed" select="$lnSpaceRed"/>
              <xsl:with-param name="nodeName" select="$nodeName"/>
              <xsl:with-param name="index" select="$index"/>
              <xsl:with-param name="MaxFontSz" select="$MaxFontSz"/>
            </xsl:call-template>
              </xsl:for-each>
            </xsl:for-each>
               </xsl:when>
        </xsl:choose>
  </xsl:template>
  <xsl:template name="tmpLayoutParaProp">
    <xsl:param name ="AttrType" />
    <xsl:param name="SMName"/>
    <xsl:param name="spType"/>
    <xsl:param name="nodeName"/>
   <xsl:param name ="lnSpaceRed" />
   <xsl:param name="MaxFontSz"/>
    
    <xsl:choose>
         <xsl:when test="$AttrType='TextAlignment'">
        <xsl:if test ="a:lstStyle/child::node()[name()=$nodeName]/@algn">
          <xsl:for-each select="a:lstStyle/child::node()[name()=$nodeName]">
          <xsl:call-template name="tmpTextAlignMent"/>
          </xsl:for-each>
            </xsl:if>
          </xsl:when>
          <xsl:when test="$AttrType='marginLeft'">
        <xsl:if test ="a:lstStyle/child::node()[name()=$nodeName]/@marL">
          <xsl:for-each select="a:lstStyle/child::node()[name()=$nodeName]">
          <xsl:call-template name="tmpMarginLet"/>
          </xsl:for-each>
                </xsl:if>
        <xsl:if test ="not(a:lstStyle/child::node()[name()=$nodeName]/@marL)">
          <xsl:choose>
            <xsl:when test="$spType='title'">
              <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:titleStyle/child::node()[name()=$nodeName]">
				  <xsl:choose>
					  <xsl:when test="@marL">
                <xsl:call-template name="tmpMarginLet"/>
					  </xsl:when>
					  <xsl:otherwise>
						  <xsl:attribute name ="fo:margin-left">
							  <xsl:value-of select="'0cm'"/>
						  </xsl:attribute >
					  </xsl:otherwise>
				  </xsl:choose>
              </xsl:for-each>
              </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]">
				  <xsl:choose>
					  <xsl:when test="@marL">
                <xsl:call-template name="tmpMarginLet"/>
					  </xsl:when>
					  <xsl:otherwise>
						  <xsl:attribute name ="fo:margin-left">
							  <xsl:value-of select="'0cm'"/>
						  </xsl:attribute >
					  </xsl:otherwise>
				  </xsl:choose>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
            </xsl:if>
          </xsl:when>
          <xsl:when test="$AttrType='marginTop'">
        <xsl:choose>
          <xsl:when test ="a:lstStyle/child::node()[name()=$nodeName]/a:spcBef/a:spcPts">
                  <xsl:attribute name ="fo:margin-top">
                <xsl:call-template  name="tmpMarginTopBottom">
                  <xsl:with-param name="type" select="'point'" />
                  <xsl:with-param name="spaceVal" select="a:lstStyle/child::node()[name()=$nodeName]/a:spcBef/a:spcPts/@val"/>
                </xsl:call-template>
                  </xsl:attribute>
              </xsl:when>
          <xsl:when test ="a:lstStyle/child::node()[name()=$nodeName]/a:spcBef/a:spcPct">
              <xsl:choose>
              <xsl:when test ="$MaxFontSz !=''">
                <xsl:attribute name ="fo:margin-top">
                  <xsl:call-template  name="tmpMarginTopBottom">
                    <xsl:with-param name="type" select="'percentage'" />
                    <xsl:with-param name="spaceVal" select="a:lstStyle/child::node()[name()=$nodeName]/a:spcBef/a:spcPct/@val"/>
                    <xsl:with-param name="fontSz" select="$MaxFontSz"/>
                  </xsl:call-template>
                    </xsl:attribute>
                </xsl:when>
              <xsl:when test ="MaxFontSz ='' and a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@sz">
                <xsl:attribute name ="fo:margin-top">
                  <xsl:call-template  name="tmpMarginTopBottom">
                    <xsl:with-param name="type" select="'percentage'" />
                    <xsl:with-param name="spaceVal" select="a:lstStyle/child::node()[name()=$nodeName]/a:spcBef/a:spcPct/@val"/>
                    <xsl:with-param name="fontSz" select="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@sz"/>
                  </xsl:call-template>
                            </xsl:attribute>
              </xsl:when>
              <xsl:when test ="MaxFontSz ='' and not(a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@sz)">
                <xsl:variable name="SMTextsz">
                  <xsl:choose>
                    <xsl:when test="$spType='title'">
                      <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:titleStyle/child::node()[name()=$nodeName]/a:defRPr/@sz">
                        <xsl:value-of select="."/>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                      <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]/a:defRPr/@sz">
                        <xsl:value-of select="."/>
                      </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
                </xsl:variable>
                <xsl:attribute name ="fo:margin-top">
                  <xsl:call-template  name="tmpMarginTopBottom">
                    <xsl:with-param name="type" select="'percentage'" />
                    <xsl:with-param name="spaceVal" select="a:lstStyle/child::node()[name()=$nodeName]/a:spcBef/a:spcPct/@val"/>
                    <xsl:with-param name="fontSz" select="$SMTextsz"/>
                  </xsl:call-template>
                </xsl:attribute>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
          <xsl:when test ="not(a:lstStyle/child::node()[name()=$nodeName]/a:spcBef)">
        <xsl:choose>
              <xsl:when test ="$MaxFontSz !=''">
                <xsl:choose>
                  <xsl:when test="$spType='title'">
                    <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:titleStyle/child::node()[name()=$nodeName]/a:spcBef">
                <xsl:if test="a:spcPts/@val">
                  <xsl:attribute name ="fo:margin-top">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'point'" />
                            <xsl:with-param name="spaceVal" select="a:spcPts/@val"/>
                          </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>
                <xsl:if test="a:spcPct/@val">
                  <xsl:attribute name ="fo:margin-top">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'percentage'" />
                            <xsl:with-param name="spaceVal" select="a:spcPct/@val"/>
                            <xsl:with-param name="fontSz" select="$MaxFontSz"/>
                          </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
             </xsl:when>
              <xsl:otherwise>
                    <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]/a:spcBef">
                      <xsl:if test="a:spcPts/@val">
                        <xsl:attribute name ="fo:margin-top">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'point'" />
                            <xsl:with-param name="spaceVal" select="a:spcPts/@val"/>
                          </xsl:call-template>
                            </xsl:attribute>
                          </xsl:if>
                      <xsl:if test ="a:spcPct/@val">
                        <xsl:attribute name ="fo:margin-top">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'percentage'" />
                            <xsl:with-param name="spaceVal" select="a:spcPct/@val"/>
                            <xsl:with-param name="fontSz" select="$MaxFontSz"/>
                          </xsl:call-template>
                      </xsl:attribute>
                    </xsl:if>
                  </xsl:for-each>
               </xsl:otherwise>
              </xsl:choose>
             </xsl:when>
              <xsl:when test ="MaxFontSz ='' and a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@sz">
                <xsl:variable name="fontSize" select="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@sz"/>
                <xsl:choose>
                  <xsl:when test="$spType='title'">
                    <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:titleStyle/child::node()[name()=$nodeName]/a:spcBef">
                <xsl:if test="a:spcPts/@val">
                  <xsl:attribute name ="fo:margin-top">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'point'" />
                            <xsl:with-param name="spaceVal" select="a:spcPts/@val"/>
                          </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>
                <xsl:if test="a:spcPct/@val">
                  <xsl:attribute name ="fo:margin-top">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'percentage'" />
                            <xsl:with-param name="spaceVal" select="a:spcPct/@val"/>
                            <xsl:with-param name="fontSz" select="$fontSize"/>
                          </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
             </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]/a:spcBef">
                      <xsl:if test="a:spcPts/@val">
                        <xsl:attribute name ="fo:margin-top">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'point'" />
                            <xsl:with-param name="spaceVal" select="a:spcPts/@val"/>
                          </xsl:call-template>
                            </xsl:attribute>
                          </xsl:if>
                      <xsl:if test ="a:spcPct/@val">
                        <xsl:attribute name ="fo:margin-top">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'percentage'" />
                            <xsl:with-param name="spaceVal" select="a:spcPct/@val"/>
                            <xsl:with-param name="fontSz" select="$fontSize"/>
                          </xsl:call-template>
                      </xsl:attribute>
                    </xsl:if>
                  </xsl:for-each>
              </xsl:otherwise>
              </xsl:choose>
              </xsl:when>
              <xsl:when test ="MaxFontSz ='' and not(a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@sz)">
                <xsl:choose>
                  <xsl:when test="$spType='title'">
                    <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:titleStyle/child::node()[name()=$nodeName]/a:spcBef">
                <xsl:if test="a:spcPts/@val">
                  <xsl:attribute name ="fo:margin-top">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'point'" />
                            <xsl:with-param name="spaceVal" select="a:spcPts/@val"/>
                          </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>
                <xsl:if test="a:spcPct/@val">
                  <xsl:attribute name ="fo:margin-top">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'percentage'" />
                            <xsl:with-param name="spaceVal" select="a:spcPct/@val"/>
                            <xsl:with-param name="fontSz" select="a:defRPr/@sz"/>
                          </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
             </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]/a:spcBef">
                <xsl:if test="a:spcPts/@val">
                        <xsl:attribute name ="fo:margin-top">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'point'" />
                            <xsl:with-param name="spaceVal" select="a:spcPts/@val"/>
                          </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>
                <xsl:if test="a:spcPct/@val">
                        <xsl:attribute name ="fo:margin-top">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'percentage'" />
                            <xsl:with-param name="spaceVal" select="a:spcPct/@val"/>
                            <xsl:with-param name="fontSz" select="a:defRPr/@sz"/>
                          </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
             </xsl:otherwise>
            </xsl:choose>
            </xsl:when>
            </xsl:choose>
         </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$AttrType='marginBottom'">
        <xsl:choose>
          <xsl:when test ="a:lstStyle/child::node()[name()=$nodeName]/a:spcAft/a:spcPts">
            <xsl:attribute name ="fo:margin-bottom">
              <xsl:call-template  name="tmpMarginTopBottom">
                <xsl:with-param name="type" select="'point'" />
                <xsl:with-param name="spaceVal" select="a:lstStyle/child::node()[name()=$nodeName]/a:spcAft/a:spcPts/@val"/>
              </xsl:call-template>
             </xsl:attribute>
            </xsl:when>
          <xsl:when test ="a:lstStyle/child::node()[name()=$nodeName]/a:spcAft/a:spcPct">
            <xsl:choose>
              <xsl:when test ="$MaxFontSz !=''">
                  <xsl:attribute name ="fo:margin-bottom">
                  <xsl:call-template  name="tmpMarginTopBottom">
                    <xsl:with-param name="type" select="'percentage'" />
                    <xsl:with-param name="spaceVal" select="a:lstStyle/child::node()[name()=$nodeName]/a:spcAft/a:spcPct/@val"/>
                    <xsl:with-param name="fontSz" select="$MaxFontSz"/>
                  </xsl:call-template>
                  </xsl:attribute>
             </xsl:when>
              <xsl:when test ="MaxFontSz ='' and a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@sz">
                <xsl:attribute name ="fo:margin-bottom">
                  <xsl:call-template  name="tmpMarginTopBottom">
                    <xsl:with-param name="type" select="'percentage'" />
                    <xsl:with-param name="spaceVal" select="a:lstStyle/child::node()[name()=$nodeName]/a:spcAft/a:spcPct/@val"/>
                    <xsl:with-param name="fontSz" select="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@sz"/>
                  </xsl:call-template>
                    </xsl:attribute>
               </xsl:when>
              <xsl:when test ="MaxFontSz ='' and not(a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@sz)">
                <xsl:variable name="SMTextsz">
                      <xsl:choose>
                    <xsl:when test="$spType='title'">
                      <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:titleStyle/child::node()[name()=$nodeName]/a:defRPr/@sz">
                        <xsl:value-of select="."/>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                      <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]/a:defRPr/@sz">
                        <xsl:value-of select="."/>
                      </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
                </xsl:variable>
                <xsl:attribute name ="fo:margin-bottom">
                  <xsl:call-template  name="tmpMarginTopBottom">
                    <xsl:with-param name="type" select="'percentage'" />
                    <xsl:with-param name="spaceVal" select="a:lstStyle/child::node()[name()=$nodeName]/a:spcAft/a:spcPct/@val"/>
                    <xsl:with-param name="fontSz" select="$SMTextsz"/>
                  </xsl:call-template>
                </xsl:attribute>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
          <xsl:when test ="not(a:lstStyle/child::node()[name()=$nodeName]/a:spcAft)">
        <xsl:choose>
              <xsl:when test ="$MaxFontSz !=''">
                <xsl:choose>
                  <xsl:when test="$spType='title'">
                    <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:titleStyle/child::node()[name()=$nodeName]/a:spcAft">
                <xsl:if test="a:spcPts/@val">
                        <xsl:attribute name ="fo:margin-bottom">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'point'" />
                            <xsl:with-param name="spaceVal" select="a:spcPts/@val"/>
                          </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>
                <xsl:if test="a:spcPct/@val">
                        <xsl:attribute name ="fo:margin-bottom">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'percentage'" />
                            <xsl:with-param name="spaceVal" select="a:spcPct/@val"/>
                            <xsl:with-param name="fontSz" select="$MaxFontSz"/>
                          </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]/a:spcAft">
                <xsl:if test="a:spcPts/@val">
                  <xsl:attribute name ="fo:margin-bottom">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'point'" />
                            <xsl:with-param name="spaceVal" select="a:spcPts/@val"/>
                          </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>
                <xsl:if test="a:spcPct/@val">
                  <xsl:attribute name ="fo:margin-bottom">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'percentage'" />
                            <xsl:with-param name="spaceVal" select="a:spcPct/@val"/>
                            <xsl:with-param name="fontSz" select="$MaxFontSz"/>
                          </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test ="MaxFontSz ='' and a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@sz">
                <xsl:variable name="fontSize" select="a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@sz"/>
                <xsl:choose>
                  <xsl:when test="$spType='title'">
                    <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:titleStyle/child::node()[name()=$nodeName]/a:spcAft">
                <xsl:if test="a:spcPts/@val">
                  <xsl:attribute name ="fo:margin-bottom">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'point'" />
                            <xsl:with-param name="spaceVal" select="a:spcPts/@val"/>
                          </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>
                      <xsl:if test="a:spcPct/@val">
                  <xsl:attribute name ="fo:margin-bottom">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'percentage'" />
                            <xsl:with-param name="spaceVal" select="a:spcPct/@val"/>
                            <xsl:with-param name="fontSz" select="$fontSize"/>
                          </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
             </xsl:when>
              <xsl:otherwise>
                    <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]/a:spcAft">
                      <xsl:if test="a:spcPts/@val">
                        <xsl:attribute name ="fo:margin-bottom">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'point'" />
                            <xsl:with-param name="spaceVal" select="a:spcPts/@val"/>
                          </xsl:call-template>
                            </xsl:attribute>
                          </xsl:if>
                    <xsl:if test ="a:spcPct/@val">
                        <xsl:attribute name ="fo:margin-bottom">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'percentage'" />
                            <xsl:with-param name="spaceVal" select="a:spcPct/@val"/>
                            <xsl:with-param name="fontSz" select="$fontSize"/>
                          </xsl:call-template>
                      </xsl:attribute>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
             </xsl:when>
              <xsl:when test ="MaxFontSz ='' and not(a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/@sz)">
                <xsl:choose>
                  <xsl:when test="$spType='title'">
                    <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:titleStyle/child::node()[name()=$nodeName]/a:spcAft">
                <xsl:if test="a:spcPts/@val">
                        <xsl:attribute name ="fo:margin-bottom">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'point'" />
                            <xsl:with-param name="spaceVal" select="a:spcPts/@val"/>
                          </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>
                <xsl:if test="a:spcPct/@val">
                        <xsl:attribute name ="fo:margin-bottom">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'percentage'" />
                            <xsl:with-param name="spaceVal" select="a:spcPct/@val"/>
                            <xsl:with-param name="fontSz" select="a:defRPr/@sz"/>
                          </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
               </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]/a:spcAft">
                <xsl:if test="a:spcPts/@val">
                  <xsl:attribute name ="fo:margin-bottom">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'point'" />
                            <xsl:with-param name="spaceVal" select="a:spcPts/@val"/>
                          </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>
                <xsl:if test="a:spcPct/@val">
                  <xsl:attribute name ="fo:margin-bottom">
                          <xsl:call-template  name="tmpMarginTopBottom">
                            <xsl:with-param name="type" select="'percentage'" />
                            <xsl:with-param name="spaceVal" select="a:spcPct/@val"/>
                            <xsl:with-param name="fontSz" select="a:defRPr/@sz"/>
                          </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
          </xsl:when>
          <xsl:when test="$AttrType='indent'">
        <xsl:if test ="a:lstStyle/child::node()[name()=$nodeName]/@indent">
              <xsl:attribute name ="fo:text-indent">
            <xsl:value-of select="concat(format-number(a:lstStyle/child::node()[name()=$nodeName]/@indent div 360000, '#.##'), 'cm')"/>
              </xsl:attribute>
            </xsl:if>
        <xsl:if test ="not(a:lstStyle/child::node()[name()=$nodeName]/@indent)">
          <xsl:choose>
            <xsl:when test="$spType='title'">
              <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:titleStyle/child::node()[name()=$nodeName]">
                <xsl:choose>
                  <xsl:when test="@indent">
                    <xsl:attribute name ="fo:text-indent">
                      <xsl:value-of select="concat(format-number(@indent div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="fo:text-indent">
                      <xsl:value-of select="'0cm'"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
          <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]">
			  <xsl:choose>
				  <xsl:when test="@indent">
                  <xsl:attribute name ="fo:text-indent">
                    <xsl:value-of select="concat(format-number(@indent div 360000, '#.##'), 'cm')"/>
                  </xsl:attribute>
				  </xsl:when>
				  <xsl:otherwise>
					  <xsl:attribute name ="fo:text-indent">
						  <xsl:value-of select="'0cm'"/>
					  </xsl:attribute>
				  </xsl:otherwise>
			  </xsl:choose>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        
            </xsl:if>
          </xsl:when>
          <xsl:when test="$AttrType='lineSpacing'">
        <xsl:if test ="a:lstStyle/child::node()[name()=$nodeName]/a:lnSpc">
              <xsl:choose>
                <xsl:when test="$lnSpaceRed='0'">
              <xsl:if test ="a:lstStyle/child::node()[name()=$nodeName]/a:lnSpc/a:spcPct/@val">
                    <xsl:attribute name="fo:line-height">
                  <xsl:value-of select="concat(format-number(a:lstStyle/child::node()[name()=$nodeName]/a:lnSpc/a:spcPct/@val div 1000,'###'), '%')"/>
                    </xsl:attribute>
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
              <xsl:if test ="a:lstStyle/child::node()[name()=$nodeName]/a:lnSpc/a:spcPct/@val">
                    <xsl:attribute name="fo:line-height">
                  <xsl:value-of select="concat(format-number((a:lstStyle/child::node()[name()=$nodeName]/a:lnSpc/a:spcPct/@val - number($lnSpaceRed)) div 1000,'###'), '%')"/>
                    </xsl:attribute>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
          <xsl:if test ="a:lstStyle/child::node()[name()=$nodeName]/a:lnSpc/a:spcPts/@val">
                <xsl:attribute name="style:line-height-at-least">
              <xsl:value-of select="concat(format-number(a:lstStyle/child::node()[name()=$nodeName]/a:lnSpc/a:spcPts/@val div 2835, '#.##'), 'cm')"/>
                </xsl:attribute>
              </xsl:if>
            </xsl:if>
        <xsl:if test ="not(a:lstStyle/child::node()[name()=$nodeName]/a:lnSpc)">
              <xsl:choose>
            <xsl:when test="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]/a:lnSpc">
              <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]/a:lnSpc">
                    <xsl:if test ="a:spcPct">
                      <xsl:choose>
                        <xsl:when test="$lnSpaceRed='0'">
                          <xsl:if test ="./@val">
                            <xsl:attribute name="fo:line-height">
                              <xsl:value-of select="concat(format-number(./@val div 1000,'###'), '%')"/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test ="a:spcPct/@val">
                            <xsl:attribute name="fo:line-height">
                              <xsl:value-of select="concat(format-number((./@val - number($lnSpaceRed)) div 1000,'###'), '%')"/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                    <xsl:if test ="a:spcPts/@val">
                      <xsl:attribute name="style:line-height-at-least">
                        <xsl:value-of select="concat(format-number(./@val div 2835, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                 <xsl:attribute name="fo:line-height">
                    <xsl:value-of select="concat(format-number((100000 - number($lnSpaceRed)) div 1000,'###'), '%')" />
                  </xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              </xsl:if>
        <!-- End of snippet Added by vijayeta, Fix for the bug 1780902 , date:24th Aug '07 -->
          </xsl:when>
      <!--Added by sanjay to fixed the bug no1958740-->
          <xsl:when test="$AttrType='Textdirection'">
            <xsl:if test="a:bodyPr/@vert">
              <xsl:call-template name="getTextDirection">
                <xsl:with-param name="vert" select="a:bodyPr/@vert"/>
              </xsl:call-template>
          <!--End of bug no1958740-->
            </xsl:if>
          </xsl:when>
          </xsl:choose>
  </xsl:template>
  
  <xsl:template name="tmpCommanGraphicProperty">
    <xsl:param name="LayoutFileName"/>
    <xsl:param name="spType"/>
    <xsl:param name="index"/>
    <xsl:param name="ThemeName"/>
    <xsl:param name="SMName"/>
    <xsl:param name="var_pos"/>
    <xsl:param name="FileType"/>
    <xsl:param name="slideNo"/>
    <xsl:call-template name="tmpSlideGrahicProp">
      <xsl:with-param name="ThemeName" select="$ThemeName"/>
      <xsl:with-param name="var_pos" select="$var_pos"/>
      <xsl:with-param name="FileType" select="$FileType"/>
      <xsl:with-param name="slideNo" select="$slideNo"/>
      <xsl:with-param name="SMName" select="$SMName"/>
      <xsl:with-param name="flagShape" select="'No'"/>
<xsl:with-param name="shapePhType" select="$spType"/>
    </xsl:call-template>
    <xsl:if test ="not(p:spPr/a:noFill) and not(p:spPr/a:solidFill) and not(p:style/a:fillRef) and not(p:spPr/a:gradFill) and not(p:spPr/a:blipFill)">
                
      <xsl:call-template name ="tmpGraphicProperty">
              <xsl:with-param name ="AttrType" select ="'Backcolor'"/>
        <xsl:with-param name ="spType" select ="$spType"/>
        <xsl:with-param name ="LayoutFileName" select ="$LayoutFileName"/>
        <xsl:with-param name ="SMName" select ="$SMName"/>
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="var_pos" select="$var_pos"/>
              </xsl:call-template>

    </xsl:if>
    <xsl:if test ="not(p:spPr/a:ln/a:noFill) and not(p:spPr/a:ln/a:solidFill) and not(p:style/a:lnRef)">
      <xsl:call-template name ="tmpGraphicProperty">
                <xsl:with-param name ="AttrType" select ="'Linecolor'"/>
        <xsl:with-param name ="spType" select ="$spType"/>
        <xsl:with-param name ="LayoutFileName" select ="$LayoutFileName"/>
        <xsl:with-param name ="SMName" select ="$SMName"/>
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="var_pos" select="$var_pos"/>
              </xsl:call-template>
            </xsl:if>
      <xsl:if test ="not(p:txBody/a:bodyPr/@tIns)">
      <xsl:call-template name ="tmpGraphicProperty">
                <xsl:with-param name ="AttrType" select ="'IntMargTop'"/>
        <xsl:with-param name ="spType" select ="$spType"/>
        <xsl:with-param name ="LayoutFileName" select ="$LayoutFileName"/>
        <xsl:with-param name ="SMName" select ="$SMName"/>
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="var_pos" select="$var_pos"/>
              </xsl:call-template>
            </xsl:if>
       <xsl:if test ="not(p:txBody/a:bodyPr/@lIns)">
      <xsl:call-template name ="tmpGraphicProperty">
                <xsl:with-param name ="AttrType" select ="'IntMargLeft'"/>
        <xsl:with-param name ="spType" select ="$spType"/>
        <xsl:with-param name ="LayoutFileName" select ="$LayoutFileName"/>
        <xsl:with-param name ="SMName" select ="$SMName"/>
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="var_pos" select="$var_pos"/>
              </xsl:call-template>
            </xsl:if>
       <xsl:if test ="not(p:txBody/a:bodyPr/@bIns)">
      <xsl:call-template name ="tmpGraphicProperty">
                <xsl:with-param name ="AttrType" select ="'IntMargBottom'"/>
        <xsl:with-param name ="spType" select ="$spType"/>
        <xsl:with-param name ="LayoutFileName" select ="$LayoutFileName"/>
        <xsl:with-param name ="SMName" select ="$SMName"/>
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="var_pos" select="$var_pos"/>
              </xsl:call-template>
            </xsl:if>
       <xsl:if test ="not(p:txBody/a:bodyPr/@rIns)">
      <xsl:call-template name ="tmpGraphicProperty">
                <xsl:with-param name ="AttrType" select ="'IntMargRight'"/>
        <xsl:with-param name ="spType" select ="$spType"/>
        <xsl:with-param name ="LayoutFileName" select ="$LayoutFileName"/>
        <xsl:with-param name ="SMName" select ="$SMName"/>
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="var_pos" select="$var_pos"/>
              </xsl:call-template>
            </xsl:if>
    <xsl:if test ="not(p:txBody/a:bodyPr/@anchor)">
      <xsl:call-template name ="tmpGraphicProperty">
                <xsl:with-param name ="AttrType" select ="'VertAlign'"/>
        <xsl:with-param name ="spType" select ="$spType"/>
        <xsl:with-param name ="LayoutFileName" select ="$LayoutFileName"/>
        <xsl:with-param name ="SMName" select ="$SMName"/>
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="var_pos" select="$var_pos"/>
              </xsl:call-template>
            </xsl:if>
      <xsl:if test ="not(p:txBody/a:bodyPr/@wrap)">
      <xsl:call-template name ="tmpGraphicProperty">
                <xsl:with-param name ="AttrType" select ="'Wrap'"/>
        <xsl:with-param name ="spType" select ="$spType"/>
        <xsl:with-param name ="LayoutFileName" select ="$LayoutFileName"/>
        <xsl:with-param name ="SMName" select ="$SMName"/>
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="var_pos" select="$var_pos"/>
              </xsl:call-template>
            </xsl:if>
       <xsl:if test ="not(p:txBody/a:bodyPr/spAutoFit)">
      <xsl:call-template name ="tmpGraphicProperty">
              <xsl:with-param name ="AttrType" select ="'spAutoFit'"/>
        <xsl:with-param name ="spType" select ="$spType"/>
        <xsl:with-param name ="LayoutFileName" select ="$LayoutFileName"/>
        <xsl:with-param name ="SMName" select ="$SMName"/>
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="var_pos" select="$var_pos"/>
            </xsl:call-template>
    </xsl:if>
    <!--Added by sanjay to fixed the bug no1958740-->
    <xsl:if test ="not(p:txBody/a:bodyPr/@vert)">
      <xsl:call-template name ="tmpGraphicProperty">
        <xsl:with-param name ="AttrType" select ="'Textdirection'"/>
        <xsl:with-param name ="spType" select ="$spType"/>
        <xsl:with-param name ="LayoutFileName" select ="$LayoutFileName"/>
        <xsl:with-param name ="SMName" select ="$SMName"/>
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="var_pos" select="$var_pos"/>
            </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <xsl:template name="tmpGraphicProperty">
    <xsl:param name ="AttrType" />
    <xsl:param name="SMName"/>
    <xsl:param name="spType"/>
    <xsl:param name="LayoutFileName"/>
    <xsl:param name="index"/>
    <xsl:param name="var_pos"/>
    <xsl:choose>
        <xsl:when test="$spType='outline'">
        <xsl:for-each select="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@idx=$index and ( not(@type) or @type='body')]">
          <xsl:for-each select="parent::node()/parent::node()/parent::node()/p:spPr">
              <xsl:call-template name ="tmpLayoutGraphicProperty">
              <xsl:with-param name ="AttrType" select ="$AttrType"/>
              <xsl:with-param name="FileType" select="concat(substring-before($LayoutFileName,'.xml'),'-',$spType,$index)"/>
              <xsl:with-param name ="var_pos" select ="$var_pos"/>
              </xsl:call-template>
          </xsl:for-each>
          </xsl:for-each>
        </xsl:when>
      <xsl:when test="$spType='title'">
        <xsl:for-each select="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='title' or @type='ctrTitle']">
          <xsl:for-each select="parent::node()/parent::node()/parent::node()/p:spPr">
            <xsl:call-template name ="tmpLayoutGraphicProperty">
              <xsl:with-param name ="AttrType" select ="$AttrType"/>
              <xsl:with-param name="FileType" select="concat(substring-before($LayoutFileName,'.xml'),'-',$spType)"/>
              <xsl:with-param name ="var_pos" select ="$var_pos"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:for-each>
        </xsl:when>
       <xsl:when test="$spType='subtitle'">
          <xsl:for-each select="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='subTitle']">
          <xsl:for-each select="parent::node()/parent::node()/parent::node()/p:spPr">
            <xsl:call-template name ="tmpLayoutGraphicProperty">
              <xsl:with-param name ="AttrType" select ="$AttrType"/>
              <xsl:with-param name="FileType" select="concat(substring-before($LayoutFileName,'.xml'),'-',$spType)"/>
              <xsl:with-param name ="var_pos" select ="$var_pos"/>
            </xsl:call-template>
          </xsl:for-each>
         </xsl:for-each>
        </xsl:when>
      </xsl:choose>
    </xsl:template>
  <xsl:template name="tmpLayoutGraphicProperty">
    <xsl:param name ="AttrType" />
    <xsl:param name="var_pos"/>
    <xsl:param name="slideNo"/>
    <xsl:param name="FileType"/>
    <xsl:param name="flagGroup"/>
    <xsl:param name="SMName"/>
 
    <xsl:choose>
      <xsl:when test="$AttrType='Backcolor'">
        <xsl:choose>
          <!-- No fill -->
          <xsl:when test ="a:noFill">
            <xsl:attribute name ="draw:fill">
              <xsl:value-of select="'none'" />
            </xsl:attribute>
          </xsl:when>
          <!-- Solid fill-->
          <!-- Standard color-->
          <xsl:when test ="a:solidFill">
            <xsl:for-each select="./a:solidFill">
              <xsl:call-template name="tmpShapeSolidFillColor">
                <xsl:with-param name="SMName" select="$SMName"/>
                </xsl:call-template>
            </xsl:for-each>
          </xsl:when>
          <!-- gradient color-->
          <xsl:when test="a:gradFill">
            <xsl:attribute name="draw:fill-gradient-name">
              <xsl:value-of select="concat($FileType,'Gradient')" />
            </xsl:attribute>
            <xsl:for-each select="a:gradFill/a:gsLst/child::node()[1]">
              <xsl:if test="name()='a:gs'">
                <xsl:call-template name="tmpShapeSolidFillColor">
                  <xsl:with-param name="SMName" select="$SMName"/>
                  <xsl:with-param name="fillName" select="'gradient'"/>
                      </xsl:call-template>
             </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <!--Fill refernce-->
          <xsl:when test ="../p:style/a:fillRef">
            <xsl:for-each select="../p:style/a:fillRef">
              <xsl:call-template name="tmpShapeSolidFillColor"/>
              </xsl:for-each>
              </xsl:when>
          <xsl:when test="a:blipFill and 
                          a:blipFill/a:blip/@r:embed ">
            <xsl:choose>
              <xsl:when test="$flagGroup='True'">
                <xsl:attribute name="draw:fill-image-name">
                  <xsl:value-of select="concat($FileType,'grpImg',$var_pos)"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="draw:fill-image-name">
                  <xsl:value-of select="concat($FileType,'Img',$var_pos)"/>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="tmpPictureFillProp"/>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$AttrType='Linecolor'">
        <xsl:choose>
          <!-- No line-->
          <xsl:when test ="a:ln/a:noFill">
            <xsl:attribute name ="draw:stroke">
              <xsl:value-of select="'none'" />
            </xsl:attribute>
          </xsl:when>
          <!-- Solid line color-->
          <xsl:when test ="a:ln/a:solidFill">
            <xsl:for-each select="a:ln/a:solidFill">
            <xsl:attribute name ="draw:stroke">
              <xsl:value-of select="'solid'" />
            </xsl:attribute>
            <xsl:attribute name ="svg:stroke-color">
                <xsl:call-template name="tmpSolidColor">
                  <xsl:with-param name="SMName" select="$SMName"/>
                </xsl:call-template>
              </xsl:attribute>             
               <xsl:call-template name="tmpLineFillTransperancy">
                  <xsl:with-param name="SMName" select="$SMName"/>
                </xsl:call-template>           
            </xsl:for-each>
          </xsl:when>
          <xsl:when test ="../p:style/a:lnRef[@idx=0]">
            <xsl:attribute name ="draw:stroke">
              <xsl:value-of select="'none'" />
                  </xsl:attribute>
                      </xsl:when>
          <xsl:when test ="../p:style/a:lnRef[@idx &gt;0]">
            <xsl:for-each select="../p:style/a:lnRef">
            <xsl:attribute name ="draw:stroke">
              <xsl:value-of select="'solid'" />
            </xsl:attribute>
            <xsl:attribute name ="svg:stroke-color">
                <xsl:call-template name="tmpSolidColor">
                  <xsl:with-param name="SMName" select="$SMName"/>
                </xsl:call-template>
              </xsl:attribute>             
                <xsl:call-template name="tmpLineFillTransperancy">
                  <xsl:with-param name="SMName" select="$SMName"/>
                </xsl:call-template>            
            </xsl:for-each>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$AttrType='IntMargRight'">
        <xsl:if test ="../p:txBody/a:bodyPr/@rIns">
          <xsl:attribute name ="fo:padding-right">
            <xsl:value-of select ="concat(format-number(../p:txBody/a:bodyPr/@rIns div 360000, '#.##'), 'cm')"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$AttrType='IntMargLeft'">
        <xsl:if test ="../p:txBody/a:bodyPr/@lIns">
          <xsl:attribute name ="fo:padding-left">
            <xsl:value-of select ="concat(format-number(../p:txBody/a:bodyPr/@lIns div 360000, '#.##'), 'cm')"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$AttrType='IntMargTop'">
        <xsl:if test ="../p:txBody/a:bodyPr/@tIns">
          <xsl:attribute name ="fo:padding-top">
            <xsl:value-of select ="concat(format-number(../p:txBody/a:bodyPr/@tIns div 360000, '#.##'), 'cm')"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$AttrType='IntMargBottom'">
        <xsl:if test ="../p:txBody/a:bodyPr/@bIns">
          <xsl:attribute name ="fo:padding-bottom">
            <xsl:value-of select ="concat(format-number(../p:txBody/a:bodyPr/@bIns div 360000, '#.##'), 'cm')"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$AttrType='spAutoFit' or $AttrType='Wrap'">
        <xsl:for-each select="../p:txBody/a:bodyPr">
          <xsl:call-template name="tmpWrapSpAutoFit"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="$AttrType='VertAlign'">
        <xsl:if test ="../p:txBody/a:bodyPr/@anchor">
          <xsl:for-each select="../p:txBody/a:bodyPr">
          <xsl:attribute name ="draw:textarea-vertical-align">
              <xsl:call-template name="tmpVerticalAlign"/>
          </xsl:attribute>
          </xsl:for-each>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$AttrType='HorzAlign'">
        <xsl:if test ="../p:txBody/a:bodyPr/@anchorCtr">
          <xsl:for-each select="../p:txBody/a:bodyPr">
          <xsl:attribute name ="draw:textarea-horizontal-align">
            <xsl:call-template name="tmpHorizontalAlign"/>
          </xsl:attribute>
          </xsl:for-each>
        </xsl:if>
      </xsl:when>
      <!--Added by Sanjay to get correct Text Direction:Fixed Bug no-1958740-->
      <xsl:when test="$AttrType='Textdirection'">
        <xsl:if test="../p:txBody/a:bodyPr/@vert">
          <xsl:call-template name="getTextDirection">
            <xsl:with-param name="vert" select="../p:txBody/a:bodyPr/@vert"/>
          </xsl:call-template>
        </xsl:if>
        <!--End of Bug no-1958740-->
      </xsl:when>
    </xsl:choose>
  </xsl:template>
 
  <!-- Added By Vijayeta
       HandOut text for header footer and date in content.xml
       date: 30th July '07-->
  <xsl:template name="insertTextFromHandoutMaster">
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
        <xsl:for-each select ="key('Part', concat('ppt/handoutMasters/',$handoutMasterPath))//p:sp">
          <xsl:choose>
            <xsl:when test ="p:nvSpPr/p:nvPr/p:ph/@type='hdr'">
              <xsl:variable name ="headerText">
                <xsl:value-of select ="./p:txBody/a:p/a:r/a:t"/>
              </xsl:variable>
              <presentation:header-decl>
                <xsl:attribute name ="presentation:name">
                  <xsl:value-of select ="concat('hdr',$curPos)"/>
                </xsl:attribute>
                <xsl:value-of select ="$headerText"/>
              </presentation:header-decl>
            </xsl:when>
            <xsl:when test ="p:nvSpPr/p:nvPr/p:ph/@type='dt'">
              <presentation:date-time-decl >
                <xsl:attribute name ="style:data-style-name">
                  <xsl:call-template name ="FooterDateFormat">
                    <xsl:with-param name ="type" select ="./p:txBody/a:p/a:fld/@type" />
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name ="presentation:name">
                  <xsl:value-of select ="concat($handoutMasterName,'dtd',$curPos)"/>
                </xsl:attribute>
                <xsl:attribute name ="presentation:source">
                  <xsl:for-each select =".">
                    <xsl:if test ="p:nvSpPr/p:nvPr/p:ph/@type[contains(.,'dt')]" >
                      <xsl:if test ="p:txBody/a:p/a:fld">
                        <xsl:value-of select ="'current-date'"/>
                      </xsl:if>
                      <xsl:if test ="not(p:txBody/a:p/a:fld)">
                        <xsl:value-of select ="'fixed'"/>
                      </xsl:if>
                    </xsl:if>
                  </xsl:for-each >
                </xsl:attribute>
                <xsl:for-each select =".">
                  <xsl:if test ="p:nvSpPr/p:nvPr/p:ph/@type[contains(.,'dt')]" >
                    <xsl:if test ="p:txBody/a:p/a:fld">
                      <xsl:value-of select ="p:txBody/a:p/a:fld/a:t"/>
                    </xsl:if>
                    <xsl:if test ="not(p:txBody/a:p/a:fld)">
                      <xsl:value-of select ="p:txBody/a:p/a:r/a:t"/>
                    </xsl:if>
                  </xsl:if>
                </xsl:for-each >
              </presentation:date-time-decl>
            </xsl:when>
            <xsl:when test ="p:nvSpPr/p:nvPr/p:ph/@type='ftr'">
              <xsl:variable name ="footerText">
                <xsl:value-of select ="./p:txBody/a:p/a:r/a:t"/>
              </xsl:variable>
              <presentation:footer-decl>
                <xsl:attribute name ="presentation:name">
                  <xsl:value-of select ="concat($handoutMasterName,'ftr',$curPos)"/>
                </xsl:attribute>
                <xsl:value-of select ="$footerText"/>
              </presentation:footer-decl>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="tmpcheckbulletFlage">
    <xsl:param name="level"/>
    <xsl:choose>
      <xsl:when test="$level='1'">
        <xsl:choose>
          <xsl:when test="parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/a:lvl1pPr/a:buNone">
            <xsl:value-of select ="'false'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select ="'true'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$level='2'">
        <xsl:choose>
          <xsl:when test="parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/a:lvl2pPr/a:buNone">
            <xsl:value-of select ="'false'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select ="'true'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$level='3'">
        <xsl:choose>
          <xsl:when test="parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/a:lvl3pPr/a:buNone">
            <xsl:value-of select ="'false'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select ="'true'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$level='4'">
        <xsl:choose>
          <xsl:when test="parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/a:lvl4pPr/a:buNone">
            <xsl:value-of select ="'false'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select ="'true'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$level='5'">
        <xsl:choose>
          <xsl:when test="parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/a:lvl5pPr/a:buNone">
            <xsl:value-of select ="'false'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select ="'true'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$level='6'">
        <xsl:choose>
          <xsl:when test="parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/a:lvl6pPr/a:buNone">
            <xsl:value-of select ="'false'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select ="'true'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$level='7'">
        <xsl:choose>
          <xsl:when test="parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/a:lvl7pPr/a:buNone">
            <xsl:value-of select ="'false'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select ="'true'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$level='8'">
        <xsl:choose>
          <xsl:when test="parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/a:lvl8pPr/a:buNone">
            <xsl:value-of select ="'false'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select ="'true'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$level='9'">
        <xsl:choose>
          <xsl:when test="parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/a:lvl9pPr/a:buNone">
            <xsl:value-of select ="'false'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select ="'true'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select ="'false'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--End of Snippet Added By Vijayeta HandOut text for header footer and date in content.xml-->
   <!--End-->

 
	<!--template added by yeswanth-->	
	<xsl:template name="SlideTransition">
		<xsl:param name="slidenum"/>
		<xsl:choose>
			<xsl:when test="key('Part', $slidenum)/p:sld/p:transition[@advClick and not(@advTm)]">
				<xsl:attribute name ="presentation:transition-type">
					<xsl:value-of select="'semi-automatic'"/>
				</xsl:attribute>
			</xsl:when>
      <xsl:when test="key('Part', $slidenum)/p:sld/p:transition[@advClick and @advTm]">
				<xsl:attribute name ="presentation:transition-type">
					<xsl:value-of select="'automatic'"/>
				</xsl:attribute>
			</xsl:when>
      <xsl:when test="key('Part', $slidenum)/p:sld/p:transition[not(@advClick) and @advTm]">
				<xsl:attribute name ="presentation:transition-type">
					<xsl:value-of select="'automatic'"/>
				</xsl:attribute>				
			</xsl:when>
			<xsl:otherwise>
				<!--don't add the attribute  presentation:transition-type-->				
			</xsl:otherwise>
		</xsl:choose>

		<xsl:if test="key('Part', $slidenum)/p:sld/p:transition/@advTm">
			<xsl:call-template name="PresDuration">
				<xsl:with-param name="TmVal" select="key('Part', $slidenum)/p:sld/p:transition/@advTm div 1000"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:attribute name ="presentation:transition-speed">
			<xsl:choose>
				<xsl:when test="key('Part', $slidenum)/p:sld/p:transition/@spd='slow'">
					<xsl:value-of select="'slow'"/>
				</xsl:when>
				<xsl:when test="key('Part', $slidenum)/p:sld/p:transition/@spd='med'">
					
					<xsl:value-of select="'medium'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'fast'"/>
				</xsl:otherwise>
			</xsl:choose>			
		</xsl:attribute>
		
		<xsl:call-template name="SlideTransSmilType">
			<xsl:with-param name="slidenum" select="key('Part', $slidenum)/p:sld//p:transition/child::node()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="SlideTransSmilType">
		<xsl:param name="slidenum"/>
		<xsl:choose>
			<!--dissolve-->
			<xsl:when test="name($slidenum)='p:dissolve'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'dissolve'"/>
				</xsl:attribute>
			</xsl:when>

			<!--wipe-->
			<xsl:when test="name($slidenum)='p:wipe'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'barWipe'"/>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$slidenum/@dir='u'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'topToBottom'"/>
						</xsl:attribute>
						<xsl:attribute name ="smil:direction">
							<xsl:value-of select="'reverse'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$slidenum/@dir='r'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'leftToRight'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$slidenum/@dir='d'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'topToBottom'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'leftToRight'"/>
						</xsl:attribute>
						<xsl:attribute name ="smil:direction">
							<xsl:value-of select="'reverse'"/>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>				
			</xsl:when>

			<!--wheel-->
			<xsl:when test="name($slidenum)='p:wheel'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'pinWheelWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:choose>
						<xsl:when test="$slidenum/@spokes='1'">
							<xsl:value-of select="'oneBlade'"/>							
						</xsl:when>
						<xsl:when test="$slidenum/@spokes='2'">
							<xsl:value-of select="'twoBladeVertical'"/>
						</xsl:when>
						<xsl:when test="$slidenum/@spokes='3'">
							<xsl:value-of select="'threeBlade'"/>
						</xsl:when>
						<xsl:when test="$slidenum/@spokes='8'">
							<xsl:value-of select="'eightBlade'"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'fourBlade'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:when>

			<!--pull-->
			<xsl:when test="name($slidenum)='p:pull'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'slideWipe'"/>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$slidenum/@dir='d'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fromTop'"/>
						</xsl:attribute>
						<xsl:attribute name ="smil:direction">
							<xsl:value-of select="'reverse'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$slidenum/@dir='r'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fromLeft'"/>
						</xsl:attribute>
						<xsl:attribute name ="smil:direction">
							<xsl:value-of select="'reverse'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$slidenum/@dir='u'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fromBottom'"/>
						</xsl:attribute>
						<xsl:attribute name ="smil:direction">
							<xsl:value-of select="'reverse'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$slidenum/@dir='ld'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fromTopRight'"/>
						</xsl:attribute>
						<xsl:attribute name ="smil:direction">
							<xsl:value-of select="'reverse'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$slidenum/@dir='lu'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fromBottomRight'"/>
						</xsl:attribute>
						<xsl:attribute name ="smil:direction">
							<xsl:value-of select="'reverse'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$slidenum/@dir='rd'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fromTopLeft'"/>
						</xsl:attribute>
						<xsl:attribute name ="smil:direction">
							<xsl:value-of select="'reverse'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$slidenum/@dir='ru'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fromBottomLeft'"/>
						</xsl:attribute>
						<xsl:attribute name ="smil:direction">
							<xsl:value-of select="'reverse'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fromRight'"/>
						</xsl:attribute>
						<xsl:attribute name ="smil:direction">
							<xsl:value-of select="'reverse'"/>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>

			<!--randombar-->
			<xsl:when test="name($slidenum)='p:randomBar'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'randomBarWipe'"/>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$slidenum/@dir='vert'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'vertical'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'horizontal'"/>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>

			<!--checker-->
			<xsl:when test="name($slidenum)='p:checker'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'checkerBoardWipe'"/>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$slidenum/@dir='vert'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'down'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'across'"/>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>

			<!--plus-->
			<xsl:when test="name($slidenum)='p:plus'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'fourBoxWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select="'cornersOut'"/>
				</xsl:attribute>
			</xsl:when>

			<!--circle-->
			<xsl:when test="name($slidenum)='p:circle'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'ellipseWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select="'circle'"/>
				</xsl:attribute>
			</xsl:when>
			<!--Vijayeta 2010-->
			<!--Ripple-->
			<xsl:when test="name($slidenum)='p14:ripple'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'ellipseWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select="'circle'"/>
				</xsl:attribute>
			</xsl:when>
			<!--Gallery-->
			<xsl:when test="name($slidenum)='p14:gallery'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'fade'"/>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$slidenum[2]/@thruBlk='1'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fadeOverColor'"/>
						</xsl:attribute>
						<xsl:attribute name ="smil:fadeColor">
							<xsl:value-of select="'#000000'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'crossfade'"/>
						</xsl:attribute>
						<xsl:attribute name ="smil:fadeColor">
							<xsl:value-of select="'#000000'"/>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!--diamond-->
			<xsl:when test="name($slidenum)='p:diamond'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'irisWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select="'diamond'"/>
				</xsl:attribute>
			</xsl:when>

			<!--wedge-->
			<xsl:when test="name($slidenum)='p:wedge'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'fanWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select="'centerTop'"/>
				</xsl:attribute>
			</xsl:when>

			<!--blinds-->
			<xsl:when test="name($slidenum)='p:blinds'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'blindsWipe'"/>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$slidenum/@dir='vert'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'vertical'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'horizontal'"/>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>

			<!--fade-->
			<xsl:when test="name($slidenum)='p:fade'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'fade'"/>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$slidenum/@thruBlk='1'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fadeOverColor'"/>
						</xsl:attribute>
						<xsl:attribute name ="smil:fadeColor">
							<xsl:value-of select="'#000000'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'crossfade'"/>
						</xsl:attribute>
						<xsl:attribute name ="smil:fadeColor">
							<xsl:value-of select="'#000000'"/>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:when>

			<!--cover-->
			<xsl:when test="name($slidenum)='p:cover'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'slideWipe'"/>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$slidenum/@dir='d'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fromTop'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$slidenum/@dir='r'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fromLeft'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$slidenum/@dir='u'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fromBottom'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$slidenum/@dir='ld'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fromTopRight'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$slidenum/@dir='lu'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fromBottomRight'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$slidenum/@dir='rd'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fromTopLeft'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$slidenum/@dir='ru'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fromBottomLeft'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fromRight'"/>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>

			<!--random-->
			<xsl:when test="name($slidenum)='p:random'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'random'"/>
				</xsl:attribute>
			</xsl:when>

			<!--push-->
			<xsl:when test="name($slidenum)='p:push'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'pushWipe'"/>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$slidenum/@dir='u'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fromBottom'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$slidenum/@dir='r'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fromLeft'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$slidenum/@dir='d'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fromTop'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'fromRight'"/>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>

			<!--split-->
			<xsl:when test="name($slidenum)='p:split'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'barnDoorWipe'"/>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$slidenum/@orient='vert'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'vertical'"/>
						</xsl:attribute>
						<xsl:if test="$slidenum/@dir='in'">
							<xsl:attribute name ="smil:direction">
								<xsl:value-of select="'reverse'"/>
							</xsl:attribute>
						</xsl:if>
					</xsl:when>
					<xsl:when test="$slidenum/@dir='in' and not($slidenum/@orient)">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'horizontal'"/>
						</xsl:attribute>
						<xsl:attribute name ="smil:direction">
							<xsl:value-of select="'reverse'"/>
						</xsl:attribute>
					</xsl:when>					
					<xsl:otherwise>
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'horizontal'"/>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>

			<!--strips-->
			<xsl:when test="name($slidenum)='p:strips'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'waterfallWipe'"/>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$slidenum/@dir='ld'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'horizontalRight'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$slidenum/@dir='rd'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'horizontalLeft'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$slidenum/@dir='ru'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'horizontalRight'"/>
						</xsl:attribute>
						<xsl:attribute name ="smil:direction">
							<xsl:value-of select="'reverse'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'horizontalLeft'"/>
						</xsl:attribute>
						<xsl:attribute name ="smil:direction">
							<xsl:value-of select="'reverse'"/>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>

			<!--zoom-->
			<xsl:when test="name($slidenum)='p:zoom'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'irisWipe'"/>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$slidenum/@dir='in'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'rectangle'"/>
						</xsl:attribute>
						<xsl:attribute name ="smil:direction">
							<xsl:value-of select="'reverse'"/>
						</xsl:attribute>						
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'rectangle'"/>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>

			<!--newsflash-->
			<xsl:when test="name($slidenum)='p:newsflash'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'fourBoxWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select="'cornersOut'"/>
				</xsl:attribute>				
			</xsl:when>

			<!--comb-->
			<xsl:when test="name($slidenum)='p:comb'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select="'pushWipe'"/>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$slidenum/@dir='vert'">
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'combVertical'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name ="smil:subtype">
							<xsl:value-of select="'combHorizontal'"/>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>			

		</xsl:choose>
	</xsl:template>

	<!--For only sound in slide transition : added by yeswanth.s-->
	<xsl:template name="SmilTypeForOnlySound">
		<xsl:param name="slidenum"/>
		<xsl:for-each select="$slidenum/child::node()">
			<xsl:choose>
				<xsl:when test="name()='p:dissolve'">
					<xsl:value-of select="'dissolve'"/>
				</xsl:when>
				<xsl:when test="name()='p:wipe'">
					<xsl:value-of select="'barWipe'"/>
				</xsl:when>
				<xsl:when test="name()='p:wheel'">
					<xsl:value-of select="'pinWheelWipe'"/>
				</xsl:when>
				<xsl:when test="name()='p:pull'">
					<xsl:value-of select="'slideWipe'"/>
				</xsl:when>
				<xsl:when test="name()='p:randomBar'">
					<xsl:value-of select="'randomBarWipe'"/>
				</xsl:when>
				<xsl:when test="name()='p:checker'">
					<xsl:value-of select="'checkerBoardWipe'"/>
				</xsl:when>
				<xsl:when test="name()='p:plus'">
					<xsl:value-of select="'fourBoxWipe'"/>
				</xsl:when>
				<xsl:when test="name()='p:circle'">
					<xsl:value-of select="'ellipseWipe'"/>
				</xsl:when>
				<xsl:when test="name()='p:diamond'">
					<xsl:value-of select="'irisWipe'"/>
				</xsl:when>
				<xsl:when test="name()='p:wedge'">
					<xsl:value-of select="'fanWipe'"/>
				</xsl:when>
				<xsl:when test="name()='p:blinds'">
					<xsl:value-of select="'blindsWipe'"/>
				</xsl:when>
				<xsl:when test="name()='p:fade'">
					<xsl:value-of select="'fade'"/>
				</xsl:when>
				<xsl:when test="name()='p:cover'">
					<xsl:value-of select="'slideWipe'"/>
				</xsl:when>
				<xsl:when test="name()='p:random'">
					<xsl:value-of select="'random'"/>
				</xsl:when>
				<xsl:when test="name()='p:push'">
					<xsl:value-of select="'pushWipe'"/>
				</xsl:when>
				<xsl:when test="name()='p:split'">
					<xsl:value-of select="'barnDoorWipe'"/>
				</xsl:when>
				<xsl:when test="name()='p:strips'">
					<xsl:value-of select="'waterfallWipe'"/>
				</xsl:when>
				<xsl:when test="name()='p:zoom'">
					<xsl:value-of select="'irisWipe'"/>
				</xsl:when>
				<xsl:when test="name()='p:newsflash'">
					<xsl:value-of select="'fourBoxWipe'"/>
				</xsl:when>
				<xsl:when test="name()='p:comb'">
					<xsl:value-of select="'pushWipe'"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<!--end-->

	<xsl:template name="PresDuration">
		<xsl:param name="TmVal"/>
		<xsl:variable name="Hours">
			<xsl:value-of select="floor($TmVal div 3600)"/>
		</xsl:variable>
		<xsl:variable name="Hr2Min">
			<xsl:value-of select="$TmVal mod 3600"/>
		</xsl:variable>
		<xsl:variable name="Minutes">
			<xsl:value-of select="floor($Hr2Min div 60)"/>
		</xsl:variable>
		<!--<xsl:variable name="Min2Sec">
			<xsl:value-of select="$Hr2Min mod 60"/>
		</xsl:variable>-->
		<xsl:variable name="Seconds">
			<xsl:value-of select="floor($Hr2Min mod 60)"/>
		</xsl:variable>
				
		<xsl:attribute name="presentation:duration">
			<xsl:choose>
				<xsl:when test="($Minutes &gt; 16) or ($Hours &gt; 0)">
					<xsl:value-of select="concat('PT00H','16M39S')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('PT00H',concat($Minutes,concat('M',concat($Seconds,'S'))))"/>
				</xsl:otherwise>
			</xsl:choose>

		</xsl:attribute>
		
	</xsl:template>

	<!--template added by yeswanth.s-->
	<!--transition sound-->
	<xsl:template name="TransSound">
		<xsl:param name="slidenum"/>
		<xsl:param name="pageSlide"/>
		<xsl:param name="FolderNameGUID"/>
		<xsl:if test="key('Part', $slidenum)/p:sld/p:transition/p:sndAc/p:stSnd">			
			<presentation:sound xlink:type="simple" xlink:show="new" xlink:actuate="onRequest">
				<xsl:variable name="hyperlinkrid">
					<xsl:value-of select="key('Part', $slidenum)/p:sld/p:transition/p:sndAc/p:stSnd/p:snd/@r:embed"/>
				</xsl:variable>				
				
				<xsl:variable name="soundfilename">
					<xsl:for-each select="key('Part', $pageSlide)/rels:Relationships/rels:Relationship">
						<xsl:if test="$hyperlinkrid=@Id">
							<xsl:call-template name="retString">
								<xsl:with-param name="string2rev" select="./@Target"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="extractfilename">
					<xsl:choose>
						<xsl:when test="contains($soundfilename,'%20')">
							<xsl:value-of select="translate($soundfilename,'%20',' ')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$soundfilename"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>	
							
				<!--comment added by yeswanth.s , 18 July 2008-->
				<!--Here for this attribute, TransFOlderName should be in seperate value-of. so 3 value-of has been used-->
				<xsl:attribute name ="xlink:href">
          <xsl:value-of select="'../'"/>
          <xsl:value-of select="concat('ooc-transFileName-oop-',concat($FolderNameGUID,'-'),'-oop-',concat('/',$extractfilename), '-ooe')" />
				</xsl:attribute>
				<!--some code here-->
				<!--comment added by yeswanth.s , 18 July 2008-->
				<!--Here for this 'pzip:target' attribute, TransFOlderName should be in seperate value-of. so 3 value-of has been used-->
				<pzip:extract pzip:source="{concat('ppt/media/',$soundfilename)}">
					<xsl:attribute name ="pzip:target">
            <xsl:value-of select="concat('ooc-transFileName-oop-',concat($FolderNameGUID,'-'),'-oop-',concat('|',$extractfilename), '-ooe')" />					
				</xsl:attribute>
				</pzip:extract> 
				<!--end-->
				
			</presentation:sound>			
		</xsl:if>
	</xsl:template>

	<!--template added by yeswanth.s-->
	<xsl:template name="retString">
		<xsl:param name="string2rev"/>
		<xsl:choose>
			<xsl:when test="contains($string2rev,'/')">
				<xsl:call-template name="retString">
					<xsl:with-param name="string2rev" select="substring-after($string2rev,'/')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string2rev"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>