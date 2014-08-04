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
 xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" 
exclude-result-prefixes="p a r xlink rels xmlns">
  
  <xsl:template name ="tmpNotesStyle">
    <xsl:param name="slideRel"/>
    <xsl:param name="DefFont"/>
    <xsl:for-each select ="key('Part', $slideRel)//node()/@Target[contains(.,'notesSlides')]">
      <xsl:variable name ="NotesNumber">
        <xsl:value-of  select ="substring-before(substring-after(.,'../notesSlides/'),'.xml')" />
      </xsl:variable>
      <xsl:variable name ="NotesFile">
        <xsl:value-of  select ="concat('ppt',substring-after(.,'..'))" />
      </xsl:variable>
      <xsl:variable name ="NoteMasterFile">
        <xsl:for-each select ="key('Part', concat('ppt/notesSlides/_rels/',$NotesNumber,'.xml','.rels'))//node()/@Target[contains(.,'notesMasters')]">
          <xsl:value-of  select ="concat('ppt',substring-after(.,'..'))" />
        </xsl:for-each>
      </xsl:variable>
      <xsl:for-each select ="key('Part', $NotesFile)/p:notes/p:cSld/p:spTree/p:sp">
        <xsl:variable name="var_TextBoxType">
          <xsl:value-of select="./p:nvSpPr/p:nvPr/p:ph/@type"/>
        </xsl:variable>
        <xsl:variable name="var_index">
          <xsl:choose>
            <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@idx">
              <xsl:value-of select="./p:nvSpPr/p:nvPr/p:ph/@idx"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name ="ParaId">
          <xsl:value-of select ="concat($NotesNumber,concat('PARA',position()))"/>
        </xsl:variable>
        <xsl:variable name ="listStyleName">
          <xsl:value-of select ="concat($NotesNumber,'List',position())"/>
        </xsl:variable>
        <xsl:if test ="./p:nvSpPr/p:nvPr/p:ph[@type='body']">
          <style:style style:family="presentation">
            <xsl:attribute name ="style:name">
              <xsl:value-of  select ="concat($NotesNumber,'pr',position())"/>
            </xsl:attribute>
            <!--modified by chhavi for conformance1.1 info-->
            <style:graphic-properties>
              <xsl:call-template name="tmpSlideGrahicProp"/>
            </style:graphic-properties>
            <style:paragraph-properties>
              <xsl:if test ="p:txBody/a:bodyPr/@vert='vert'">
                <xsl:attribute name ="style:writing-mode">
                  <xsl:value-of select ="'tb-rl'"/>
                </xsl:attribute>
              </xsl:if>
            </style:paragraph-properties>
          </style:style>
          <xsl:for-each select ="./p:txBody">
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
       
                <xsl:if test ="(a:p/a:pPr/a:buChar) or (a:p/a:pPr/a:buAutoNum) or (a:p/a:pPr/a:buBlip) ">
              <xsl:call-template name ="insertBulletStyleforNotes">
                <xsl:with-param name ="ParaId" select ="$ParaId"/>
                <xsl:with-param name ="notesMaster" select ="$NoteMasterFile"/>
                <xsl:with-param name ="listStyleName" select ="$listStyleName"/>
                <xsl:with-param name ="var_TextBoxType" select ="$var_TextBoxType"/>
                <xsl:with-param name ="var_index" select ="$var_index"/>
                <xsl:with-param name ="notesRel" select ="$var_index"/>
                
              </xsl:call-template>
            </xsl:if>
            <xsl:for-each select ="a:p">
              <xsl:variable name ="levelForDefFont">
                <xsl:if test ="a:pPr/@lvl">
                  <xsl:value-of select ="a:pPr/@lvl"/>
                </xsl:if>
                <xsl:if test ="not(a:pPr/@lvl)">
                  <xsl:value-of select ="'0'"/>
                </xsl:if>
              </xsl:variable>
              <style:style style:family="paragraph">
                <xsl:attribute name ="style:name">
                  <xsl:value-of select ="concat($ParaId,position())"/>
                </xsl:attribute >
                <style:paragraph-properties  text:enable-numbering="false" >
                  <xsl:call-template name="tmpSlideParagraphStyle">
                    <xsl:with-param name="lnSpcReduction" select="$var_lnSpcReduction"/>
                  </xsl:call-template>
                  <xsl:if test ="a:pPr/a:buChar or a:pPr/a:buAutoNum or a:pPr/a:buBlip ">
                    <xsl:choose>
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
                  <xsl:if test ="a:pPr/a:tabLst/a:tab">
                    <xsl:call-template name ="paragraphTabstops" />
                  </xsl:if>
                </style:paragraph-properties >
              </style:style>
              <xsl:for-each select ="node()" >
                <xsl:if test ="name()='a:r'">
                  <style:style style:family="text">
                    <xsl:attribute name ="style:name">
                      <xsl:value-of select ="concat($NotesNumber,'-Text-',generate-id())"/>
                    </xsl:attribute>
                    <style:text-properties>
                      <xsl:for-each select ="a:rPr">
                      <xsl:call-template name="tmpSlideTextProperty">
                        <xsl:with-param name="fontscale" select="$var_fontScale"/>
                        <xsl:with-param name="DefFont" select="$DefFont"/>
                      </xsl:call-template>
                      </xsl:for-each>
                    </style:text-properties>
                  </style:style>
                </xsl:if>
                <xsl:if test ="name()='a:endParaRPr'">
                  <style:style style:family="text">
                    <xsl:attribute name ="style:name">
                      <xsl:value-of select ="concat($NotesNumber,'-Text-',generate-id())"/>
                    </xsl:attribute>
                    <style:text-properties>
                      <xsl:attribute name ="fo:font-family">
                        <xsl:choose >
                          <xsl:when test ="a:endParaRPr/a:latin/@typeface">
                            <xsl:variable name ="typeFaceVal" select ="a:rPr/a:latin/@typeface"/>
                            <xsl:for-each select ="a:endParaRPr/a:latin/@typeface">
                              <xsl:if test ="$typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt'">
                                <xsl:value-of select ="$DefFont"/>
                              </xsl:if>
                              <!-- Bug 1711910 Fixed,On date 2-06-07,by Vijayeta-->
                              <xsl:if test ="not($typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt')">
                                <xsl:value-of select ="."/>
                              </xsl:if>
                            </xsl:for-each>
                          </xsl:when>
                          <xsl:when test ="a:latin/@typeface">
                            <xsl:variable name ="typeFaceVal" select ="a:latin/@typeface"/>
                            <xsl:for-each select ="a:latin/@typeface">
                              <xsl:if test ="$typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt'">
                                <xsl:value-of select ="$DefFont"/>
                              </xsl:if>
                              <!-- Bug 1711910 Fixed,On date 2-06-07,by Vijayeta-->
                              <xsl:if test ="not($typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt')">
                                <xsl:value-of select ="."/>
                              </xsl:if>
                            </xsl:for-each>
                          </xsl:when>
                          <xsl:when test ="not(a:endParaRPr/a:latin/@typeface)">
                            <xsl:value-of select ="$DefFont"/>
                          </xsl:when>
                        </xsl:choose>
                      </xsl:attribute>
                      <xsl:attribute name ="style:font-family-generic"	>
                        <xsl:value-of select ="'roman'"/>
                      </xsl:attribute>
                      <xsl:attribute name ="style:font-pitch"	>
                        <xsl:value-of select ="'variable'"/>
                      </xsl:attribute>
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
                    </style:text-properties>
                  </style:style>
                </xsl:if>
              </xsl:for-each >
            </xsl:for-each>
          </xsl:for-each>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name ="tmpNotesDrawingPageStyle"  >
    <xsl:variable name="drawingPageAttributes">
      <xsl:for-each select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:sldIdLst/p:sldId">
        <xsl:variable name="slideRel" select="concat('ppt/slides/_rels/slide',position(),'.xml.rels')"/>
        <xsl:for-each select ="key('Part', $slideRel)//node()/@Target[contains(.,'notesSlides')]">
          <xsl:variable name ="NotesNumber">
            <xsl:value-of  select ="substring-before(substring-after(.,'../notesSlides/'),'.xml')" />
          </xsl:variable>
          <xsl:variable name ="NotesFile">
            <xsl:value-of  select ="concat('ppt',substring-after(.,'..'))" />
          </xsl:variable>
          <xsl:variable name ="NoteMasterFile">
            <xsl:for-each select ="key('Part', concat('ppt/notesSlides/_rels/',$NotesNumber,'.xml','.rels'))//node()/@Target[contains(.,'notesMasters')]">
              <xsl:value-of  select ="concat('ppt',substring-after(.,'..'))" />
            </xsl:for-each>
          </xsl:variable>

          <xsl:if test ="key('Part', $NoteMasterFile)//p:cSld/p:spTree/p:sp
                                          /p:nvSpPr/p:nvPr/p:ph/@type[contains(.,'hdr')]">

            <xsl:value-of select ="'1'"/>
          </xsl:if>
          <xsl:if test ="key('Part', $NoteMasterFile)//p:cSld/p:spTree/p:sp
                                          /p:nvSpPr/p:nvPr/p:ph/@type[contains(.,'ftr')]">

            <xsl:value-of select ="'2'"/>
          </xsl:if>
          <xsl:if test ="key('Part', $NoteMasterFile)//p:cSld/p:spTree/p:sp
                                          /p:nvSpPr/p:nvPr/p:ph/@type[contains(.,'sldNum')]">

            <xsl:value-of select ="'3'"/>
          </xsl:if>
          <xsl:if test ="key('Part', $NoteMasterFile)//p:cSld/p:spTree/p:sp
                                          /p:nvSpPr/p:nvPr/p:ph/@type[contains(.,'dt')]">

            <xsl:value-of select ="'4'"/>
          </xsl:if>

        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>
    <style:style  style:family="drawing-page">
      <xsl:attribute name ="style:name" >
        <xsl:value-of select ="'Notesdp'"/>
      </xsl:attribute>
      <style:drawing-page-properties>
        <xsl:attribute name ="presentation:background-visible" >
          <xsl:value-of select ="'true'"/>
        </xsl:attribute>
        <xsl:attribute name ="presentation:background-objects-visible" >
          <xsl:value-of select ="'true'"/>
        </xsl:attribute>
        <xsl:attribute name ="presentation:display-header">
          <xsl:choose>
            <xsl:when test ="contains($drawingPageAttributes,'1')">

              <xsl:value-of select ="'true'"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select ="'false'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name ="presentation:display-footer">
          <xsl:choose>
            <xsl:when test ="contains($drawingPageAttributes,'2')">

              <xsl:value-of select ="'true'"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select ="'false'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name ="presentation:display-page-number" >
          <xsl:choose>
            <xsl:when test ="contains($drawingPageAttributes,'3')">

              <xsl:value-of select ="'true'"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select ="'false'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name ="presentation:display-date-time" >
          <xsl:choose>
            <xsl:when test ="contains($drawingPageAttributes,'4')">

              <xsl:value-of select ="'true'"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select ="'false'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </style:drawing-page-properties>
    </style:style>
  </xsl:template>
  <xsl:template name ="tmpNotesDrawFrames">
    <xsl:param name ="slideRel"/>
    <xsl:param name ="SlidePos"/>
    <presentation:notes>
      <xsl:attribute name="draw:style-name">
        <xsl:value-of select ="'Notesdp'"/>
      </xsl:attribute>
    <xsl:for-each select ="key('Part', $slideRel)//node()/@Target[contains(.,'notesSlides')]">
      <office:forms form:automatic-focus="false" form:apply-design-mode="false"/>
      <xsl:variable name ="NotesNumber">
        <xsl:value-of  select ="substring-before(substring-after(.,'../notesSlides/'),'.xml')" />
      </xsl:variable>
      <xsl:variable name ="NotesFile">
        <xsl:value-of  select ="concat('ppt',substring-after(.,'..'))" />
      </xsl:variable>
        <!--<xsl:attribute name ="presentation:use-header-name">
          <xsl:value-of select ="concat($NotesNumber,'hdr')"/>
        </xsl:attribute>
        <xsl:attribute name ="presentation:use-footer-name">
          <xsl:value-of select ="concat($NotesNumber,'ftr')"/>
        </xsl:attribute>
        <xsl:attribute name ="presentation:use-date-time-name">
          <xsl:value-of select ="concat($NotesNumber,'dtd')"/>
        </xsl:attribute>-->
        <xsl:for-each select ="key('Part', $NotesFile)/p:notes/p:cSld/p:spTree/p:sp">
          <xsl:variable name ="spType">
            <xsl:for-each select ="p:nvSpPr/p:nvPr/p:ph/@type">
              <xsl:value-of select ="."/>
            </xsl:for-each>
          </xsl:variable>
          <xsl:variable name ="var_index">
            <xsl:for-each select ="p:nvSpPr/p:nvPr/p:ph/@idx">
              <xsl:value-of select ="."/>
            </xsl:for-each>
          </xsl:variable>
          <xsl:variable name ="ParaId">
            <xsl:value-of select ="concat($NotesNumber,concat('PARA',position()))"/>
          </xsl:variable>
          <xsl:variable name ="textLayoutId"  >
            <xsl:value-of  select ="concat($NotesNumber,'pr',position())"/>
          </xsl:variable>
          <xsl:variable name ="listStyleName">
            <xsl:value-of select ="concat($NotesNumber,'List',position())"/>
          </xsl:variable>
          <xsl:variable name ="TextSpanNode">
            <xsl:choose>
              <xsl:when test ="$spType='body'">
                <xsl:for-each select ="./p:txBody/a:p">
                  <xsl:variable name ="levelForDefFont">
                    <xsl:if test ="a:pPr/@lvl">
                      <xsl:value-of select ="a:pPr/@lvl"/>
                    </xsl:if>
                    <xsl:if test ="not(a:pPr/@lvl)">
                      <xsl:value-of select ="'0'"/>
                    </xsl:if>
                  </xsl:variable>

                  <xsl:if test ="a:pPr/a:buChar or a:pPr/a:buAutoNum or a:pPr/a:buBlip">
                    <xsl:call-template name ="insertBulletsNumbersoox2odfforNotes">
                      <xsl:with-param name ="listStyleName" select ="concat($listStyleName,position())"/>
                      <xsl:with-param name ="ParaId" select ="$ParaId"/>
                      <xsl:with-param name="NotesNumber" select="$NotesNumber" />
                      <xsl:with-param name="levelCount" select="$levelForDefFont+1" />
                      <xsl:with-param name="TypeId" select="concat($NotesNumber,'-Text-')" />
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if test ="not(a:pPr/a:buChar) and not(a:pPr/a:buAutoNum) and not(a:pPr/a:buBlip)">
                    <text:p>
                      <xsl:attribute name ="text:style-name">
                        <xsl:value-of select ="concat($ParaId,position())"/>
                      </xsl:attribute >
                      <xsl:for-each select ="node()">
                        <xsl:if test ="name()='a:r'">
                          <text:span>
                            <xsl:attribute name ="text:style-name">
                              <xsl:value-of select ="concat($NotesNumber,'-Text-',generate-id())"/>
                            </xsl:attribute>
                            <xsl:variable name="nodeTextSpan">
                              <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
                              <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
                              <xsl:choose >
                                <xsl:when test ="a:rPr[@cap!='none']">
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
                            <xsl:copy-of select="$nodeTextSpan"/>
                          </text:span>
                        </xsl:if >
                        <xsl:if test ="name()='a:br'">
                          <text:line-break/>
                        </xsl:if>
                        <xsl:if test="name()='a:endParaRPr'">
                          <text:span>
                            <xsl:attribute name ="text:style-name">
                              <xsl:value-of select ="concat($NotesNumber,'-Text-',generate-id())"/>
                            </xsl:attribute>
                          </text:span>
                        </xsl:if>
                      </xsl:for-each>
                    </text:p>
                  </xsl:if>
                </xsl:for-each>
              </xsl:when>
            </xsl:choose >
          </xsl:variable>
          <xsl:choose>
            <xsl:when test ="./p:spPr/a:xfrm/a:off">
              <xsl:choose>
                <xsl:when test ="$spType='body'">
                  <draw:frame draw:layer="layout" presentation:class="notes" presentation:user-transformed="true">
                    <xsl:attribute name ="presentation:style-name">
                      <xsl:value-of select ="$textLayoutId"/>
                    </xsl:attribute>
                    <!--write the cordinates-->
                    <xsl:call-template name="tmpWriteCordinates"/>
                    <draw:text-box>
                      <xsl:copy-of select="$TextSpanNode"/>
                    </draw:text-box >
                  </draw:frame >
                </xsl:when>
                <xsl:when test ="$spType='sldImg'">
                  <draw:page-thumbnail draw:layer="layout">
                    <!--write the cordinates-->
                    <xsl:call-template name="tmpWriteCordinates"/>
                    <xsl:attribute name ="draw:page-number">
                      <xsl:value-of select ="$SlidePos"/>
                    </xsl:attribute>
                  </draw:page-thumbnail>
                </xsl:when>
              </xsl:choose>
            </xsl:when>
            <xsl:when test ="not(p:spPr/a:xfrm/a:off)">
              <xsl:variable name ="NoteMasterFile">
                <xsl:for-each select ="key('Part', concat('ppt/notesSlides/_rels/',$NotesNumber,'.xml','.rels'))//node()/@Target[contains(.,'notesMasters')]">
                  <xsl:value-of  select ="concat('ppt',substring-after(.,'..'))" />
                </xsl:for-each>
              </xsl:variable>
              <xsl:for-each select ="key('Part', $NoteMasterFile)/p:notesMaster/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type=$spType]">
                <xsl:choose>
                  <xsl:when test ="$spType='body'">
                    <draw:frame draw:layer="layout" presentation:class="notes" presentation:user-transformed="true">
                      <xsl:attribute name ="presentation:style-name">
                        <xsl:value-of select ="$textLayoutId"/>
                      </xsl:attribute>
                      <!--write the cordinates-->
                      <xsl:for-each select="./parent::node()/parent::node()/parent::node()">
                        <xsl:call-template name="tmpWriteCordinates"/>
                      </xsl:for-each>
                      <draw:text-box>
                        <xsl:copy-of select="$TextSpanNode"/>
                      </draw:text-box >
                    </draw:frame >
                  </xsl:when>
                  <xsl:when test ="$spType='sldImg'">
                    <draw:page-thumbnail draw:layer="layout">
                      <!--write the cordinates-->
                      <xsl:for-each select="./parent::node()/parent::node()/parent::node()">
                        <xsl:call-template name="tmpWriteCordinates"/>
                      </xsl:for-each>
                      <xsl:attribute name ="draw:page-number">
                        <xsl:value-of select ="$SlidePos"/>
                      </xsl:attribute>
                    </draw:page-thumbnail>
                  </xsl:when>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
       </xsl:for-each>
    </presentation:notes>
  </xsl:template>
  <xsl:template name="tmpNotesHeaderFtr">
    <xsl:for-each select="key('Part', 'ppt/presentation.xml')//p:notesMasterIdLst/p:notesMasterId">
      <xsl:variable name ="NoteMasterIdRelation">
        <xsl:value-of select ="./@r:id"/>
      </xsl:variable>
      <xsl:variable name ="curPos" select ="position()"/>
      <xsl:for-each select="key('Part', 'ppt/_rels/presentation.xml.rels')//node()[@Id=$NoteMasterIdRelation]">
        <xsl:variable name="NotesMasterPath">
          <xsl:value-of select="substring-after(@Target,'/')"/>
        </xsl:variable>
        <xsl:variable name="NotesMasterName">
          <xsl:value-of select="substring-before($NotesMasterPath,'.xml')"/>
        </xsl:variable>
        <xsl:for-each select ="key('Part', concat('ppt/notesMasters/',$NotesMasterPath))//p:sp">
          <xsl:choose>
            <xsl:when test ="p:nvSpPr/p:nvPr/p:ph/@type='hdr'">
              <xsl:variable name ="headerText">
                <xsl:value-of select ="./p:txBody/a:p/a:r/a:t"/>
              </xsl:variable>
              <presentation:header-decl>
                <xsl:attribute name ="presentation:name">
                  <xsl:value-of select ="concat($NotesMasterName,'hdr')"/>
                </xsl:attribute>
                <xsl:value-of select ="$headerText"/>
              </presentation:header-decl>
            </xsl:when>
            <xsl:when test ="p:nvSpPr/p:nvPr/p:ph/@type='dt'">
              <presentation:date-time-decl >
                <xsl:attribute name ="style:data-style-name">
                  <xsl:call-template name ="FooterDateFormat">
                    <xsl:with-param name ="type" select ="p:txBody/a:p/a:fld/@type" />
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name ="presentation:name">
                  <xsl:value-of select ="concat($NotesMasterName,'dtd')"/>
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
                  <xsl:value-of select ="concat($NotesMasterName,'ftr')"/>
                </xsl:attribute>
                <xsl:value-of select ="$footerText"/>
              </presentation:footer-decl>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
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

  <xsl:template name ="insertBulletsNumbersoox2odfforNotes">
    <xsl:param name ="listStyleName" />
    <xsl:param  name ="ParaId"/>
    <xsl:param  name ="TypeId"/>
    <xsl:param name="slideRelationId" />
    <xsl:param name="slideId" />
    <xsl:param name="levelCount" />
    
    <xsl:variable name ="textSpanNode">
      <text:p >
        <xsl:attribute name ="text:style-name">
          <xsl:value-of select ="concat($ParaId,position())"/>
        </xsl:attribute>
        <xsl:for-each select ="node()">
          <xsl:if test ="name()='a:r'">
            <text:span>
              <xsl:attribute name="text:style-name">
                <xsl:value-of select="concat($TypeId,generate-id())"/>
              </xsl:attribute>
              <xsl:variable name="nodeTextSpan">
                <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
                <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
                <xsl:choose >
                  <xsl:when test ="a:rPr[@cap!='none']">
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
                <xsl:copy-of select="$nodeTextSpan"/>
            </text:span>
          </xsl:if >
          <xsl:if test ="name()='a:br'">
            <text:line-break/>
          </xsl:if>
          <xsl:if test ="name()='a:endParaRPr'">
            <text:span>
              <xsl:attribute name="text:style-name">
                <xsl:value-of select="concat($TypeId,generate-id())"/>
              </xsl:attribute>
            </text:span >
          </xsl:if >
        </xsl:for-each>
      </text:p>
    </xsl:variable>
      <xsl:call-template name ="insertMultipleLevelsForNotes">
        <xsl:with-param name ="levelCount" select="$levelCount"/>
        <xsl:with-param name ="ParaId" select ="$ParaId"/>
        <xsl:with-param name ="listStyleName" select ="$listStyleName"/>
        <xsl:with-param name ="TypeId" select ="$TypeId"/>
        <xsl:with-param name ="textSpanNode" select ="$textSpanNode"/>
      </xsl:call-template>
   
  </xsl:template>
  <xsl:template name ="insertBulletStyleforNotes">
    <xsl:param name ="notesRel" />
    <xsl:param name ="ParaId" />
    <xsl:param name ="listStyleName"/>
    <xsl:param name ="notesMaster" />
    <xsl:param name ="var_TextBoxType" />
    <xsl:param name ="var_index" />
      <xsl:for-each select ="./a:p">
        <xsl:variable name="var_level">
          <xsl:choose>
            <xsl:when test="a:pPr/@lvl">
              <xsl:value-of select="a:pPr/@lvl"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'0'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name ="nodeName">
          <xsl:choose>
            <xsl:when test="a:pPr/@lvl">
              <xsl:value-of select ="concat('a:lvl',$var_level+1 ,'pPr')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select ="'a:lvl1pPr'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name ="textColor">
          <xsl:for-each select ="a:r">
            <xsl:if test ="position()= '1'">
              <xsl:if test ="a:rPr">
                <xsl:if test ="./a:rPr/a:solidFill">
                  <xsl:if test ="./a:rPr/a:solidFill/a:srgbClr">
                    <xsl:value-of select ="concat('#',./a:rPr/a:solidFill/a:srgbClr/@val)"/>
                  </xsl:if>
                  <xsl:if test ="./a:rPr/a:solidFill/a:schemeClr">
                    <xsl:call-template name ="getColorCode">
                      <xsl:with-param name ="color">
                        <xsl:value-of select="./a:rPr/a:solidFill/a:schemeClr/@val"/>
                      </xsl:with-param>
                    </xsl:call-template >
                  </xsl:if>
                </xsl:if>
                <xsl:if test ="not(./a:rPr/a:solidFill)">
                  <xsl:value-of select ="'0'"/>
                </xsl:if>
              </xsl:if>
              <xsl:if test ="not(./a:rPr)">
                <xsl:value-of select ="'0'"/>
              </xsl:if>
            </xsl:if >
          </xsl:for-each>
        </xsl:variable>
        <xsl:if test ="not(a:pPr/a:buNone)">
        
            <xsl:variable name ="levelStyle">
              <xsl:value-of select ="concat($listStyleName,position(),'lvl',$var_level+1)"/>
            </xsl:variable>
            <xsl:variable name ="textLevel" select ="a:pPr/@lvl"/>
            <xsl:variable name ="newTextLvl" select ="$textLevel+1"/>
            <xsl:choose >
              <xsl:when test ="a:pPr/a:buChar">
                <text:list-style>
                  <xsl:attribute name ="style:name">
                    <xsl:value-of select ="$levelStyle"/>
                  </xsl:attribute >
                  <text:list-level-style-bullet>
                    <xsl:attribute name ="text:level">
                      <xsl:value-of select ="$var_level + 1"/>
                    </xsl:attribute >
                    <xsl:attribute name ="text:bullet-char">
                      <xsl:call-template name ="insertBulletCharacter">
                        <xsl:with-param name ="character" select ="a:pPr/a:buChar/@char" />
                      </xsl:call-template>



                    </xsl:attribute >
                    <xsl:for-each select ="key('Part', concat('ppt/notesMasters/',$notesMaster))//p:notesMaster/p:notesStyle/child::node()[name()=$nodeName]">
                      <xsl:call-template name="tmBulletListLevelProp"/>
                    </xsl:for-each >
                    <style:text-properties style:font-charset="x-symbol">
                      <xsl:call-template name="tmpBulletFont"/>
                      <xsl:if test ="a:pPr/a:buSzPct">
                        <xsl:attribute name ="fo:font-size">
                          <xsl:value-of select ="concat((a:pPr/a:buSzPct/@val div 1000),'%')"/>
                        </xsl:attribute>
                      </xsl:if>
                      <xsl:if test ="not(a:pPr/a:buSzPct)">
                        <xsl:attribute name ="fo:font-size">
                          <xsl:value-of select ="'100%'"/>
                        </xsl:attribute>
                      </xsl:if>
                      <xsl:if test ="a:pPr/a:buClr">
                        <xsl:if test ="a:pPr/a:buClr/a:srgbClr">
                          <xsl:variable name ="color" select ="a:pPr/a:buClr/a:srgbClr/@val"/>
                          <xsl:attribute name ="fo:color">
                            <xsl:value-of select ="concat('#',$color)"/>
                          </xsl:attribute>
                        </xsl:if>
                        <xsl:if test ="a:pPr/a:buClr/a:schemeClr">
                          <xsl:variable name ="schemeColor" select ="a:pPr/a:buClr/a:schemeClr/@val"/>
                          <xsl:variable name ="levelColor" >
                            <xsl:for-each select ="key('Part', concat('ppt/notesMasters/',$notesMaster))//p:notesMaster/p:notesStyle">
                              <xsl:call-template name ="getColorMap">
                                <xsl:with-param name ="schemeColor" select ="$schemeColor"/>
                              </xsl:call-template>
                            </xsl:for-each >
                          </xsl:variable>
                          <!--added by chhavi for conformance-->
                          <xsl:if test="$levelColor !=''">
                            <xsl:attribute name ="fo:color">
                          <xsl:call-template name ="getColorCode">
                            <xsl:with-param name ="color">
                              <xsl:value-of select="$levelColor"/>
                            </xsl:with-param>
                          </xsl:call-template >
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:if>
                      </xsl:if>
                      <xsl:if test ="not(a:pPr/a:buClr)">
                     
                        <xsl:if test ="$textColor !='0'">
                          <xsl:attribute name ="fo:color">
                            <xsl:value-of select ="$textColor"/>
                          </xsl:attribute>
                        </xsl:if>
                        <xsl:if test ="$textColor='0'">
                          <xsl:for-each select ="key('Part', concat('ppt/notesMasters/',$notesMaster))//p:notesMaster/p:notesStyle">
                            <xsl:variable name ="levelColor" >
                              <xsl:call-template name ="getLevelColor">
                                <xsl:with-param name ="levelNum" select ="$newTextLvl"/>
                                <xsl:with-param name ="textColor" select="$textColor" />
                              </xsl:call-template>
                            </xsl:variable>
                            <xsl:attribute name ="fo:color">
                              <xsl:value-of select ="$levelColor"/>
                            </xsl:attribute>
                          </xsl:for-each>
                        </xsl:if>
                   

                      </xsl:if>
                    </style:text-properties >
                  </text:list-level-style-bullet>
                </text:list-style>
              </xsl:when>
              <xsl:when test ="a:pPr/a:buAutoNum">
                <text:list-style>
                  <xsl:attribute name ="style:name">
                    <xsl:value-of select ="$levelStyle"/>
                  </xsl:attribute >
                  <text:list-level-style-number>
                    <xsl:attribute name ="text:level">
                      <xsl:value-of select ="$var_level + 1"/>
                    </xsl:attribute >
                    <xsl:variable name ="startAt">
                      <xsl:if test ="a:pPr/a:buAutoNum/@startAt">
                        <xsl:value-of select ="a:pPr/a:buAutoNum/@startAt" />
                      </xsl:if>
                      <xsl:if test ="not(a:pPr/a:buAutoNum/@startAt)">
                        <xsl:value-of select ="'1'" />
                      </xsl:if>
                    </xsl:variable>
                    <xsl:call-template name ="insertNumber">
                      <xsl:with-param name ="number" select ="a:pPr/a:buAutoNum/@type"/>
                      <xsl:with-param name ="startAt" select ="$startAt"/>
                    </xsl:call-template>
                    <style:list-level-properties>
                      <xsl:for-each select ="key('Part', concat('ppt/notesMasters/',$notesMaster))//p:notesMaster/p:notesStyle/child::node()[name()=$nodeName]">
                        <xsl:call-template name="tmBulletListLevelProp"/>
                      </xsl:for-each >
                    </style:list-level-properties>
                    <style:text-properties style:font-family-generic="swiss" style:font-pitch="variable">
                      <xsl:if test ="a:pPr/a:buFont/@typeface">
                        <xsl:attribute name ="fo:font-family">
                          <xsl:value-of select ="a:pPr/a:buFont/@typeface"/>
                        </xsl:attribute>
                      </xsl:if>
                      <xsl:if test ="not(a:pPr/a:buFont/@typeface)">
                        <xsl:attribute name ="fo:font-family">
                          <xsl:value-of select ="'Arial'"/>
                        </xsl:attribute>
                      </xsl:if>
                      <xsl:if test ="not(a:pPr/a:buSzPct)">
                        <xsl:attribute name ="fo:font-size">
                          <xsl:value-of select ="'100%'"/>
                        </xsl:attribute>
                      </xsl:if>
                      <xsl:if test ="a:pPr/a:buClr">
                        <xsl:if test ="a:p/a:pPr/a:buClr/a:srgbClr">
                          <xsl:attribute name ="fo:color">
                            <xsl:value-of select ="concat('#',a:p/a:pPr/a:buClr/a:srgbClr/@val)"/>
                          </xsl:attribute>
                        </xsl:if>
                        <xsl:if test ="a:pPr/a:buClr/a:schemeClr">
                          <xsl:variable name ="schemeColor" select ="a:pPr/a:buClr/a:schemeClr/@val"/>
                          <xsl:variable name ="levelColor" >
                            <xsl:for-each select ="key('Part', concat('ppt/notesMasters/',$notesMaster))//p:notesMaster/p:notesStyle">
                              <xsl:call-template name ="getColorMap">
                                <xsl:with-param name ="schemeColor" select ="$schemeColor"/>
                              </xsl:call-template>
                            </xsl:for-each >
                          </xsl:variable>
                          <!--added by chhavi for conformance-->
                          <xsl:if test="$levelColor !=''">
                            <xsl:attribute name ="fo:color">
                          <xsl:call-template name ="getColorCode">
                            <xsl:with-param name ="color">
                              <xsl:value-of select="$levelColor"/>
                            </xsl:with-param>
                          </xsl:call-template >
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:if>
                      </xsl:if>
                      <!-- Code added by vijayeta, bug fix 1746350-->
                      <xsl:if test ="not(a:pPr/a:buClr)">
                        <!-- Vijayeta,Custom Bullet Colour-->
                        <xsl:if test ="$textColor !='0'">
                          <xsl:attribute name ="fo:color">
                            <xsl:value-of select ="$textColor"/>
                          </xsl:attribute>
                        </xsl:if>
                        <xsl:if test ="$textColor='0'">
                          <xsl:for-each select ="key('Part', concat('ppt/notesMasters/',$notesMaster))//p:notesMaster/p:notesStyle">
                            <xsl:variable name ="levelColor" >
                              <xsl:call-template name ="getLevelColor">
                                <xsl:with-param name ="levelNum" select ="$newTextLvl"/>
                                <xsl:with-param name ="textColor" select="$textColor" />
                              </xsl:call-template>
                            </xsl:variable>
                            <xsl:attribute name ="fo:color">
                              <xsl:value-of select ="$levelColor"/>
                            </xsl:attribute>
                          </xsl:for-each>
                        </xsl:if>
                        <!-- Vijayeta,Custom Bullet Colour-->

                      </xsl:if>
                      <!--End of Code added by vijayeta, bug fix 1746350-->
                    </style:text-properties>
                  </text:list-level-style-number>
                </text:list-style>
              </xsl:when>
              <xsl:when test ="a:pPr/a:buBlip">
                <xsl:variable name ="rId" select ="a:pPr/a:buBlip/a:blip/@r:embed"/>
                <xsl:variable name="XlinkHref">
                  <xsl:variable name="pzipsource">
                    <xsl:value-of select="key('Part', $notesRel)//rels:Relationships/rels:Relationship[@Id=$rId]/@Target"/>
                  </xsl:variable>
                  <xsl:value-of select="concat('Pictures/', substring-after($pzipsource,'../media/'))"/>
                </xsl:variable>
                <xsl:call-template name="copyPictures">
                  <xsl:with-param name="document">
                    <xsl:value-of select="$notesRel"/>
                  </xsl:with-param>
                  <xsl:with-param name="rId">
                    <xsl:value-of select ="$rId"/>
                  </xsl:with-param>
                </xsl:call-template>
                <text:list-style>
                  <xsl:attribute name ="style:name">
                    <xsl:value-of select ="$levelStyle"/>
                  </xsl:attribute >
                  <text:list-level-style-image xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad">
                    <xsl:attribute name ="text:level">
                      <xsl:value-of select="$newTextLvl"/>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:href">
                      <xsl:value-of select="$XlinkHref"/>
                    </xsl:attribute>
                    <style:list-level-properties style:vertical-pos="middle" style:vertical-rel="line" fo:width="0.318cm" fo:height="0.318cm" />
                  </text:list-level-style-image>
                </text:list-style>
              </xsl:when>
            </xsl:choose>
          </xsl:if>
        
      </xsl:for-each>
  </xsl:template>
	<xsl:template name ="insertMultipleLevelsForNotes">
		<xsl:param name ="levelCount"/>
		<xsl:param name ="ParaId"/>
		<xsl:param name ="listStyleName"/>
		<xsl:param name ="sldRelId"/>
		<xsl:param name ="sldId"/>
		<xsl:param name ="TypeId"/>
		<xsl:param name ="textSpanNode"/>
		<xsl:choose>
			<xsl:when test ="$levelCount='1'">
				<text:list>
					<xsl:attribute name ="text:style-name">
						<xsl:value-of select ="concat($listStyleName,'lvl',$levelCount)"/>
					</xsl:attribute>
					<!--<text:list-item>
						<text:list>-->
					<text:list-item>
						<xsl:copy-of select ="$textSpanNode"/>
					</text:list-item>
					<!--</text:list>
					</text:list-item>-->
				</text:list>
			</xsl:when>
			<xsl:when test ="$levelCount='2'">
				<text:list>
					<xsl:attribute name ="text:style-name">
						<xsl:value-of select ="concat($listStyleName,'lvl',$levelCount)"/>
					</xsl:attribute>
					<text:list-item>
						<text:list>
							<text:list-item>
								<!--<text:list>
									<text:list-item>-->
								<xsl:copy-of select ="$textSpanNode"/>
							</text:list-item>
						</text:list>
						<!--</text:list-item>
						</text:list>-->
					</text:list-item>
				</text:list>
			</xsl:when>
			<xsl:when test ="$levelCount='3'">
				<text:list>
					<xsl:attribute name ="text:style-name">
						<xsl:value-of select ="concat($listStyleName,'lvl',$levelCount)"/>
					</xsl:attribute>
					<text:list-item>
						<text:list>
							<text:list-item>
								<text:list>
									<text:list-item>
										<!--<text:list>
											<text:list-item>-->
										<xsl:copy-of select ="$textSpanNode"/>
										<!--</text:list-item>
										</text:list>-->
									</text:list-item>
								</text:list>
							</text:list-item>
						</text:list>
					</text:list-item>
				</text:list>
			</xsl:when>
			<xsl:when test ="$levelCount='4'">
				<text:list>
					<xsl:attribute name ="text:style-name">
						<xsl:value-of select ="concat($listStyleName,'lvl',$levelCount)"/>
					</xsl:attribute>
					<text:list-item>
						<text:list>
							<text:list-item>
								<text:list>
									<text:list-item>
										<text:list>
											<text:list-item>
												<!--<text:list>
													<text:list-item>-->
												<xsl:copy-of select ="$textSpanNode"/>
												<!--</text:list-item>
												</text:list>-->
											</text:list-item>
										</text:list>
									</text:list-item>
								</text:list>
							</text:list-item>
						</text:list>
					</text:list-item>
				</text:list>
			</xsl:when>
			<xsl:when test ="$levelCount='5'">
				<text:list>
					<xsl:attribute name ="text:style-name">
						<xsl:value-of select ="concat($listStyleName,'lvl',$levelCount)"/>
					</xsl:attribute>
					<text:list-item>
						<text:list>
							<text:list-item>
								<text:list>
									<text:list-item>
										<text:list>
											<text:list-item>
												<text:list>
													<text:list-item>
														<!--<text:list>
															<text:list-item>-->
														<xsl:copy-of select ="$textSpanNode"/>
														<!--</text:list-item>
														</text:list>-->
													</text:list-item>
												</text:list>
											</text:list-item>
										</text:list>
									</text:list-item>
								</text:list>
							</text:list-item>
						</text:list>
					</text:list-item>
				</text:list>
			</xsl:when>
			<xsl:when test ="$levelCount='6'">
				<text:list>
					<xsl:attribute name ="text:style-name">
						<xsl:value-of select ="concat($listStyleName,'lvl',$levelCount)"/>
					</xsl:attribute>
					<text:list-item>
						<text:list>
							<text:list-item>
								<text:list>
									<text:list-item>
										<text:list>
											<text:list-item>
												<text:list>
													<text:list-item>
														<text:list>
															<text:list-item>
																<!--<text:list>
																	<text:list-item>-->
																<xsl:copy-of select ="$textSpanNode"/>
																<!--</text:list-item>
																</text:list>-->
															</text:list-item>
														</text:list>
													</text:list-item>
												</text:list>
											</text:list-item>
										</text:list>
									</text:list-item>
								</text:list>
							</text:list-item>
						</text:list>
					</text:list-item>
				</text:list>
			</xsl:when>
			<xsl:when test ="$levelCount='7'">
				<text:list>
					<xsl:attribute name ="text:style-name">
						<xsl:value-of select ="concat($listStyleName,'lvl',$levelCount)"/>
					</xsl:attribute>
					<text:list-item>
						<text:list>
							<text:list-item>
								<text:list>
									<text:list-item>
										<text:list>
											<text:list-item>
												<text:list>
													<text:list-item>
														<text:list>
															<text:list-item>
																<text:list>
																	<text:list-item>
																		<!--<text:list>
																			<text:list-item>-->
																		<xsl:copy-of select ="$textSpanNode"/>
																		<!--</text:list-item>
																		</text:list>-->
																	</text:list-item>
																</text:list>
															</text:list-item>
														</text:list>
													</text:list-item>
												</text:list>
											</text:list-item>
										</text:list>
									</text:list-item>
								</text:list>
							</text:list-item>
						</text:list>
					</text:list-item>
				</text:list>
			</xsl:when>
			<xsl:when test ="$levelCount='8'">
				<text:list>
					<xsl:attribute name ="text:style-name">
						<xsl:value-of select ="concat($listStyleName,'lvl',$levelCount)"/>
					</xsl:attribute>
					<text:list-item>
						<text:list>
							<text:list-item>
								<text:list>
									<text:list-item>
										<text:list>
											<text:list-item>
												<text:list>
													<text:list-item>
														<text:list>
															<text:list-item>
																<text:list>
																	<text:list-item>
																		<text:list>
																			<text:list-item>
																				<!--<text:list>
																					<text:list-item>-->
																				<xsl:copy-of select ="$textSpanNode"/>
																				<!--</text:list-item>
																				</text:list>-->
																			</text:list-item>
																		</text:list>
																	</text:list-item>
																</text:list>
															</text:list-item>
														</text:list>
													</text:list-item>
												</text:list>
											</text:list-item>
										</text:list>
									</text:list-item>
								</text:list>
							</text:list-item>
						</text:list>
					</text:list-item>
				</text:list>
			</xsl:when>
			<xsl:when test ="$levelCount='9'">
				<text:list>
					<xsl:attribute name ="text:style-name">
						<xsl:value-of select ="concat($listStyleName,'lvl',$levelCount)"/>
					</xsl:attribute>
					<text:list-item>
						<text:list>
							<text:list-item>
								<text:list>
									<text:list-item>
										<text:list>
											<text:list-item>
												<text:list>
													<text:list-item>
														<text:list>
															<text:list-item>
																<text:list>
																	<text:list-item>
																		<text:list>
																			<text:list-item>
																				<text:list>
																					<text:list-item>
																						<!--<text:list>
																							<text:list-item>-->
																						<xsl:copy-of select ="$textSpanNode"/>
																						<!--</text:list-item>
																						</text:list>-->
																					</text:list-item>
																				</text:list>
																			</text:list-item>
																		</text:list>
																	</text:list-item>
																</text:list>
															</text:list-item>
														</text:list>
													</text:list-item>
												</text:list>
											</text:list-item>
										</text:list>
									</text:list-item>
								</text:list>
							</text:list-item>
						</text:list>
					</text:list-item>
				</text:list>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>