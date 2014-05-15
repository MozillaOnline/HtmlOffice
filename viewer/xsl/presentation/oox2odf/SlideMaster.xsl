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
  xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
  exclude-result-prefixes="p a style fo r rels xlink">  
  <xsl:template name="SlideMaster" >
    <xsl:call-template name="InsertContentStyle"/>
  </xsl:template>
  <xsl:template name="InsertContentStyle">
    <xsl:for-each select="key('Part', 'ppt/presentation.xml')//p:sldMasterIdLst/p:sldMasterId">
      <xsl:variable name="sldMasterIdRelation">
        <xsl:value-of select="@r:id"></xsl:value-of>
      </xsl:variable>
      <!-- Loop thru each slide master.xml-->
      <xsl:for-each select="key('Part', 'ppt/_rels/presentation.xml.rels')//node()[@Id=$sldMasterIdRelation]">
        <xsl:variable name="slideMasterPath">
          <xsl:value-of select="substring-after(@Target,'/')"/>
        </xsl:variable>
        <xsl:variable name="slideMasterName">
          <xsl:value-of select="substring-before($slideMasterPath,'.xml')"/>
        </xsl:variable>
        <xsl:call-template name="tmpgetBackImage">
          <xsl:with-param name="FilePath" select="concat('ppt/slideMasters/',$slideMasterPath)"/>
          <xsl:with-param name="FileName" select="$slideMasterPath"/>
          <xsl:with-param name="FileType" select="'SM'"/>
        </xsl:call-template>
        <xsl:call-template name="tmpBackImageStyle"/>
        
        <xsl:call-template name="tmpGradientFillStyle">
          <xsl:with-param name="FilePath" select="concat('ppt/slideMasters/',$slideMasterPath)"/>
          <xsl:with-param name="FileName" select="$slideMasterPath"/>
          <xsl:with-param name="FileType" select="$slideMasterName"/>
          <xsl:with-param name="SMName" select="$slideMasterPath"/>
        </xsl:call-template>
        <xsl:call-template name="tmpBGgradientFillStyle">
          <xsl:with-param name="FilePath" select="concat('ppt/slideMasters/',$slideMasterPath)"/>
          <xsl:with-param name="FileName" select="$slideMasterPath"/>
          <xsl:with-param name="FileType" select="$slideMasterName"/>
          <xsl:with-param name="SMName" select="$slideMasterPath"/>
        </xsl:call-template>
        
        <xsl:for-each select="key('Part', concat('ppt/slideMasters/_rels/',$slideMasterPath,'.rels'))//node()/@Target[contains(.,'slideLayouts')]">
          
          <xsl:variable name="var_layoutName" select="substring-after(.,'../slideLayouts/')"/>
          <xsl:call-template name="tmpGradientFillStyle">
            <xsl:with-param name="FilePath" select="concat('ppt/slideLayouts/',$var_layoutName)"/>
            <xsl:with-param name="FileName" select="$var_layoutName"/>
            <xsl:with-param name="FileType" select="substring-before($var_layoutName,'.xml')"/>
            <xsl:with-param name="SMName" select="$slideMasterPath"/>
          </xsl:call-template>
          <xsl:call-template name="tmpBGgradientFillStyle">
            <xsl:with-param name="FilePath" select="concat('ppt/slideLayouts/',$var_layoutName)"/>
            <xsl:with-param name="FileName" select="$var_layoutName"/>
            <xsl:with-param name="FileType" select="concat($slideMasterName,substring-before($var_layoutName,'.xml'))"/>
            <xsl:with-param name="SMName" select="$slideMasterPath"/>
          </xsl:call-template>
          <xsl:call-template name="tmpgetBackImage">
            <xsl:with-param name="FilePath" select="concat('ppt/slideLayouts/',$var_layoutName)"/>
            <xsl:with-param name="FileName" select="$var_layoutName"/>
            <xsl:with-param name="FileType" select="'SL'"/>
          </xsl:call-template>
        </xsl:for-each>
        <style:style>
          <xsl:attribute name="style:name">
            <xsl:value-of select="concat($slideMasterName,'-backgroundobjects')"/>
          </xsl:attribute>
          <xsl:attribute name="style:family">
            <xsl:value-of select="'presentation'"/>
          </xsl:attribute>
          <style:graphic-properties draw:shadow="hidden" draw:shadow-offset-x="0.3cm" draw:shadow-offset-y="0.3cm" draw:shadow-color="#808080"/>
        </style:style>
          <style:style>
          <xsl:attribute name="style:name">
            <xsl:value-of select="concat($slideMasterName,'-background')"/>
          </xsl:attribute>
          <xsl:attribute name ="style:family">
            <xsl:value-of select ="'presentation'"/>
          </xsl:attribute>
          <style:graphic-properties>
            <xsl:attribute name ="draw:stroke">
              <xsl:value-of select ="'none'"/>
            </xsl:attribute>
            <xsl:call-template name="getSlideMasterBGColor">
              <xsl:with-param name="slideMasterFile">
                <xsl:value-of select="$slideMasterPath"/>
              </xsl:with-param>
            </xsl:call-template>
            </style:graphic-properties>
        </style:style>
        <xsl:for-each select="key('Part', concat('ppt/slideMasters/',$slideMasterPath))//p:cSld/p:spTree/p:sp">
          <xsl:choose>
            <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='title' or p:nvSpPr/p:nvPr/p:ph/@type='ctrTitle'">
              <!-- style for Title-->
              <style:style>
                <xsl:attribute name="style:name">
                  <xsl:value-of select="concat($slideMasterName,'-title')"/>
                </xsl:attribute>
                <xsl:attribute name ="style:family">
                  <xsl:value-of select ="'presentation'"/>
                </xsl:attribute>
                <xsl:call-template name="TitleStyle">
                  <xsl:with-param name="SlideMasterFile">
                    <xsl:value-of select="$slideMasterPath"/>
                  </xsl:with-param>
                  <xsl:with-param name="SMName" select="concat($slideMasterName,'-title')"/>
                </xsl:call-template>
              </style:style>
            </xsl:when>
            <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='body'">
              <xsl:call-template name="tmpSubtitleOutlineStyle">
                <xsl:with-param name="slideMasterPath" select="$slideMasterPath"/>
                <xsl:with-param name="slideMasterName" select="$slideMasterName"/>
              </xsl:call-template>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
        <xsl:if test="not(key('Part', concat('ppt/slideMasters/',$slideMasterPath))//p:sp)">
          <!-- style for Title-->
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-title')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:call-template name="TitleStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$slideMasterPath"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="concat($slideMasterName,'-title')"/>
            </xsl:call-template>
          </style:style>
          <!-- style for sub-Title-->
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-subtitle')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:call-template name="SubtitleStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$slideMasterPath"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterName"/>
            </xsl:call-template>
          </style:style>
          <!-- style for Outline 1-->
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline1')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <style:graphic-properties draw:stroke="none" draw:fill="none">
              <text:list-style>
                <xsl:call-template name="tmpSMListLevelStyle">
                  <xsl:with-param name="SlideMasterFile">
                    <xsl:value-of select="$slideMasterPath"/>
                  </xsl:with-param>
                  <xsl:with-param name="levelNo">
                    <xsl:value-of select="'0'"/>
                  </xsl:with-param>
                  <xsl:with-param name="pos">
                    <xsl:value-of select="'1'"/>
                  </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="tmpSMListLevelStyle">
                  <xsl:with-param name="SlideMasterFile">
                    <xsl:value-of select="$slideMasterPath"/>
                  </xsl:with-param>
                  <xsl:with-param name="levelNo">
                    <xsl:value-of select="'1'"/>
                  </xsl:with-param>
                  <xsl:with-param name="pos">
                    <xsl:value-of select="'2'"/>
                  </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="tmpSMListLevelStyle">
                  <xsl:with-param name="SlideMasterFile">
                    <xsl:value-of select="$slideMasterPath"/>
                  </xsl:with-param>
                  <xsl:with-param name="levelNo">
                    <xsl:value-of select="'2'"/>
                  </xsl:with-param>
                  <xsl:with-param name="pos">
                    <xsl:value-of select="'3'"/>
                  </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="tmpSMListLevelStyle">
                  <xsl:with-param name="SlideMasterFile">
                    <xsl:value-of select="$slideMasterPath"/>
                  </xsl:with-param>
                  <xsl:with-param name="levelNo">
                    <xsl:value-of select="'3'"/>
                  </xsl:with-param>
                  <xsl:with-param name="pos">
                    <xsl:value-of select="'4'"/>
                  </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="tmpSMListLevelStyle">
                  <xsl:with-param name="SlideMasterFile">
                    <xsl:value-of select="$slideMasterPath"/>
                  </xsl:with-param>
                  <xsl:with-param name="levelNo">
                    <xsl:value-of select="'4'"/>
                  </xsl:with-param>
                  <xsl:with-param name="pos">
                    <xsl:value-of select="'5'"/>
                  </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="tmpSMListLevelStyle">
                  <xsl:with-param name="SlideMasterFile">
                    <xsl:value-of select="$slideMasterPath"/>
                  </xsl:with-param>
                  <xsl:with-param name="levelNo">
                    <xsl:value-of select="'5'"/>
                  </xsl:with-param>
                  <xsl:with-param name="pos">
                    <xsl:value-of select="'6'"/>
                  </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="tmpSMListLevelStyle">
                  <xsl:with-param name="SlideMasterFile">
                    <xsl:value-of select="$slideMasterPath"/>
                  </xsl:with-param>
                  <xsl:with-param name="levelNo">
                    <xsl:value-of select="'6'"/>
                  </xsl:with-param>
                  <xsl:with-param name="pos">
                    <xsl:value-of select="'7'"/>
                  </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="tmpSMListLevelStyle">
                  <xsl:with-param name="SlideMasterFile">
                    <xsl:value-of select="$slideMasterPath"/>
                  </xsl:with-param>
                  <xsl:with-param name="levelNo">
                    <xsl:value-of select="'7'"/>
                  </xsl:with-param>
                  <xsl:with-param name="pos">
                    <xsl:value-of select="'8'"/>
                  </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="tmpSMListLevelStyle">
                  <xsl:with-param name="SlideMasterFile">
                    <xsl:value-of select="$slideMasterPath"/>
                  </xsl:with-param>
                  <xsl:with-param name="levelNo">
                    <xsl:value-of select="'8'"/>
                  </xsl:with-param>
                  <xsl:with-param name="pos">
                    <xsl:value-of select="'9'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </text:list-style>
            </style:graphic-properties>
            <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMasterPath))//p:txStyles/p:bodyStyle/a:lvl1pPr">
              <xsl:call-template name="Outlines">
                <xsl:with-param name="level">
                  <xsl:value-of select="'1'"/>
                </xsl:with-param>
                <xsl:with-param name="SMName" select="$slideMasterPath"/>
              </xsl:call-template>
            </xsl:for-each>
          </style:style>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="tmBulletListLevelProp">
    <xsl:if test ="@indent">
                  <xsl:choose>
        <xsl:when test="@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
            <xsl:value-of select="concat(format-number((0 - @indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
            <xsl:value-of select="concat(format-number(@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
    <xsl:if test ="@marL">
      <!--added by chhvai for conformance 1.1-->
      <xsl:choose>
        <xsl:when test ="@indent">
                  <xsl:attribute name ="text:space-before">
        <xsl:value-of select="concat(format-number( (@marL + @indent) div 360000, '#.##'), 'cm')"/>
                  </xsl:attribute>
      </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name ="text:space-before">
            <xsl:value-of select="concat(format-number( @marL  div 360000, '#.##'), 'cm')"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
                 
                </xsl:if>
  </xsl:template>
  <xsl:template name ="tmpSMListLevelStyle">
    <xsl:param name="SlideMasterFile" />
    <xsl:param name="levelNo"/>
    <xsl:param name="pos"/>
    <xsl:variable name="nodeName">
      <xsl:value-of select="concat('a:lvl',$levelNo + 1,'pPr')"/>
    </xsl:variable>
    <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SlideMasterFile))//p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]">
      <xsl:if test ="a:buChar">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:call-template name ="insertBulletCharacter">
              <xsl:with-param name ="character" select ="a:buChar/@char" />
                </xsl:call-template>
              </xsl:attribute >
              <style:list-level-properties>
            <xsl:call-template name="tmBulletListLevelProp"/>
              </style:list-level-properties>
          <xsl:call-template name="Outlines">
                  <xsl:with-param name="level">
              <xsl:value-of select="$levelNo + 1"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                <xsl:with-param name="SMName" select="$SlideMasterFile"/>
                </xsl:call-template>
           </text:list-level-style-bullet>
          </xsl:if>
      <xsl:if test ="a:buAutoNum">
            <text:list-level-style-number>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
          <xsl:call-template name="OutlineNumbering"/>
              <style:list-level-properties>
            <xsl:call-template name="tmBulletListLevelProp"/>
              </style:list-level-properties>
              <xsl:call-template name="Outlines">
                  <xsl:with-param name="level">
              <xsl:value-of select="$levelNo + 1"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                  <xsl:with-param name="SMName" select="$SlideMasterFile"/>
                </xsl:call-template>

            </text:list-level-style-number>
          </xsl:if>
      <xsl:if test ="a:buBlip">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:value-of select="'●'"/>
              </xsl:attribute >
              <style:list-level-properties>
            <xsl:call-template name="tmBulletListLevelProp"/>
              </style:list-level-properties>
              <xsl:call-template name="Outlines">
                  <xsl:with-param name="level">
                <xsl:value-of select="$levelNo + 1"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                <xsl:with-param name="SMName" select="$SlideMasterFile"/>
                </xsl:call-template>
            </text:list-level-style-bullet>
          </xsl:if>
      <xsl:if test="not(a:buAutoNum) and not(a:buChar) and not(a:buBlip)">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:call-template name ="insertBulletCharacter">
              <xsl:with-param name ="character" select ="a:buChar/@char" />
                </xsl:call-template>
              </xsl:attribute >
              <style:list-level-properties>
            <xsl:call-template name="tmBulletListLevelProp"/>
              </style:list-level-properties>
            <xsl:call-template name="Outlines">
                  <xsl:with-param name="level">
              <xsl:value-of select="$levelNo + 1"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                <xsl:with-param name="SMName" select="$SlideMasterFile"/>
                </xsl:call-template>

            </text:list-level-style-bullet>
          </xsl:if>
  </xsl:for-each>
  </xsl:template>
  <xsl:template name="TitleStyle">
    <xsl:param name="SlideMasterFile"></xsl:param>
    <xsl:param name="SMName"/>
    <style:graphic-properties draw:stroke="none" draw:fill="none">
      <xsl:call-template name="tmpSMGraphicProperty">
        <xsl:with-param name="SMName" select="$SlideMasterFile"/>
        <xsl:with-param name="shapePhType" select="'title'"/>
      </xsl:call-template>
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
      </text:list-style>
    </style:graphic-properties>
    <style:paragraph-properties>
      <xsl:for-each select="key('Part', concat('ppt/slideMasters/',$SlideMasterFile))//p:txStyles/p:titleStyle/a:lvl1pPr">
        <xsl:call-template name="tmpSMParagraphStyle"/>
      </xsl:for-each>
      <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='title']">
        <xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:bodyPr/@vert='vert'">
          <xsl:attribute name ="style:writing-mode">
            <xsl:value-of select ="'tb-rl'"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:for-each>
    </style:paragraph-properties>
         <style:text-properties>
           <xsl:for-each select="p:txBody/a:p/a:pPr[@lvl = 0 or not(@lvl)]">
             <xsl:choose>
               <xsl:when test="../a:r[1]/a:rPr/@lang">
                 <xsl:for-each select="../a:r[1]/a:rPr">
                   <xsl:call-template name="tmpTextLanguage">
                     <xsl:with-param name="lang" select="@lang"/>
                   </xsl:call-template>
                 </xsl:for-each>
               </xsl:when>
               <xsl:when test="../a:endParaRPr/@lang">
                 <xsl:for-each select="../a:endParaRPr">
                   <xsl:call-template name="tmpTextLanguage">
                     <xsl:with-param name="lang" select="@lang"/>
                   </xsl:call-template>
                 </xsl:for-each>
               </xsl:when>
               <xsl:otherwise>
                 <xsl:attribute name="style:language-asian">
                   <xsl:value-of select="'en'"/>
                 </xsl:attribute>
                 <xsl:attribute name="style:country-asian">
                   <xsl:value-of select="'US'"/>
                 </xsl:attribute>
               </xsl:otherwise>
             </xsl:choose>

           </xsl:for-each>
           
           <!--code changed by yeswanth : For Font name in Title : 4-Feb-09-->
           <xsl:choose>
             <xsl:when test="./p:txBody/a:p/a:r">
        <xsl:for-each select="./p:txBody/a:p/a:r">
          <xsl:if test="position()=1">
            <xsl:call-template name="tmpTitleCommonTextProp">
          <xsl:with-param name="fontType" select="'major'"/>
              <xsl:with-param name="SlideMasterFile" select="$SlideMasterFile"/>
        </xsl:call-template>
          </xsl:if>
        </xsl:for-each>
             </xsl:when>
             <xsl:otherwise>
               <xsl:call-template name="tmpTitleCommonTextProp">
                 <xsl:with-param name="fontType" select="'major'"/>
                 <xsl:with-param name="SlideMasterFile" select="$SlideMasterFile"/>
               </xsl:call-template>
             </xsl:otherwise>             
           </xsl:choose>
        
      </style:text-properties>
  </xsl:template>
   <xsl:template name="tmpTitleCommonTextProp">
    <xsl:param name ="SlideMasterFile" />
    <xsl:param name ="fontType" />
    <xsl:for-each select ="a:rPr">
    <xsl:call-template name="tmpSlideTextProperty">
      <xsl:with-param name="fontscale" select="'100000'"/>
      <xsl:with-param name="SMName" select="$SlideMasterFile"/>
          </xsl:call-template>
    </xsl:for-each>
    <xsl:if test ="not(@lang)">
      <xsl:if test="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr/@lang">
        <xsl:for-each select="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr">
          <xsl:call-template name="tmpTextLanguage">
            <xsl:with-param name="lang" select="@lang"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:if>
    </xsl:if>
      <xsl:if test ="not(a:rPr/@sz)">
        <xsl:if test="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr/@sz">
          <xsl:for-each select="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr">
          <xsl:call-template name="tmpFontSize">
            <xsl:with-param name="fontscale" select="'100000'"/>
            <xsl:with-param name="sz" select="@sz"/>
        </xsl:call-template>
        </xsl:for-each>
      </xsl:if>
      </xsl:if>
      <xsl:if test ="not(a:rPr/a:latin/@typeface) and not(a:rPr/a:cs/@typeface) and not(a:rPr/a:sym/@typeface)">
        <xsl:for-each select="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr">
          <xsl:call-template name="tmpFontName">
            <xsl:with-param name="DefFont">
              <xsl:call-template name="slideMasterFontName">
                <xsl:with-param name="fontType" select="'major'"/>
                <xsl:with-param name="SMName" select="$SlideMasterFile"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:if>
      <!-- strike style:text-line-through-style-->
      <xsl:if test ="not(a:rPr/@strike)">
      <xsl:if test="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr/@strike">
        <xsl:for-each select="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr">
          <xsl:call-template name="tmpstrike">
            <xsl:with-param name="strike" select="@strike"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:if>
    </xsl:if>
      <!-- Kening Property-->
      <xsl:if test ="not(a:rPr/@kern)">
      <xsl:if test="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr/@kern">
        <xsl:for-each select="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr">
          <xsl:call-template name="tmpKerning">
            <xsl:with-param name="kern" select="@kern"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:if >
    </xsl:if>
      <!-- Bold Property-->
      <xsl:if test ="not(a:rPr/@b)">
        <xsl:if test="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr/@b">
          <xsl:for-each select="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr">
            <xsl:call-template name="tmpFontWeight">
          <xsl:with-param name="b" select="@b"/>
        </xsl:call-template>
        </xsl:for-each>
      </xsl:if >
      </xsl:if >
      <!--UnderLine-->
      <xsl:if test ="not(a:rPr/@u)">
      <xsl:if test="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr/@u">
        <xsl:for-each select="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr">
          <xsl:call-template name="tmpUnderLine">
            <xsl:with-param name="u" select="@u"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:if >
    </xsl:if>
      <!-- Italic-->
      <xsl:if test ="not(a:rPr/@i)">
      <xsl:if test="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr/@i">
        <xsl:for-each select="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr">
          <xsl:call-template name="tmpFontItalic">
            <xsl:with-param name="i" select="@i"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:if >
    </xsl:if>
      <!-- Character Spacing -->
      <xsl:if test ="not(a:rPr/@spc)">
      <xsl:if test="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr/@spc">
        <xsl:for-each select="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr">
          <xsl:call-template name="tmpletterSpacing">
            <xsl:with-param name="spc" select="@spc"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:if>
    </xsl:if>
      <xsl:if test ="not(a:rPr/a:solidFill/a:srgbClr/@val) and not(a:rPr/a:solidFill/a:schemeClr/@val) and not(a:rPr/a:gradFill)">
        <xsl:for-each select="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr">
          <xsl:call-template name="tmpFontColor">
            <xsl:with-param name="SMName" select="$SlideMasterFile"/>
            <xsl:with-param name="varCurrentNode" select="."/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:if>
      <!--Shadow fo:text-shadow-->
      <xsl:if test ="not(a:rPr/a:effectLst/a:outerShdw)">
      <xsl:if test="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr/a:effectLst/a:outerShdw">
        <xsl:call-template name="tmpTextOuterShdw"/>
      </xsl:if>
      </xsl:if>
      <!-- Superscript and Subscript style:text-properties (added by Mathi on 1st Aug 2007)-->
      <xsl:if test ="not(a:rPr/@baseline)">
      <xsl:if test="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr/@baseline">
        <xsl:for-each select="/.//p:txStyles/p:titleStyle/a:lvl1pPr/a:defRPr">
          <xsl:variable name="subSuperScriptValue">
            <xsl:value-of select="number(format-number(@baseline div 1000,'#'))"/>
          </xsl:variable>
          <xsl:call-template name="tmpSubSuperScript">
            <xsl:with-param name="baseline" select="@baseline"/>
            <xsl:with-param name="subSuperScriptValue" select="$subSuperScriptValue"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:if >
    </xsl:if>
  </xsl:template>
  <xsl:template name="tmpSMDatePageNoFooterStyle">
    <xsl:param name="SMName"/>
      <xsl:param name="spType"/>
      <xsl:param name="shapePhType"/>
    <style:graphic-properties draw:stroke="none" draw:fill="none">
        <xsl:call-template name="tmpSMGraphicProperty">
          <xsl:with-param name="SMName" select="$SMName"/>
          <xsl:with-param name="shapePhType" select="$shapePhType"/>
        </xsl:call-template>
     </style:graphic-properties>
    <style:paragraph-properties>
      <xsl:for-each select="p:txBody//a:lvl1pPr">
        <xsl:call-template name="tmpSMParagraphStyle"/>
      </xsl:for-each>
      <xsl:if test ="p:txBody/a:bodyPr/@vert='vert'">
          <xsl:attribute name ="style:writing-mode">
            <xsl:value-of select ="'tb-rl'"/>
          </xsl:attribute>
      </xsl:if>
    </style:paragraph-properties>
        <style:text-properties>
    <xsl:for-each select="p:txBody/a:p/a:r/a:rPr | p:txBody/a:p/a:fld/a:rPr">
      <xsl:if test="position()=1">
        <xsl:call-template name="tmpTextLanguage">
          <xsl:with-param name="lang" select="@lang"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="p:txBody/a:lstStyle/a:lvl1pPr">
        <xsl:call-template name="tmpShapeTextProperty">
          <xsl:with-param name="fontType" select="'minor'"/>
          <xsl:with-param name="SLMName" select="$SMName"/>
            <xsl:with-param name="shapeType" select="$spType"/>
        </xsl:call-template>
       </xsl:for-each>
  </style:text-properties>
  </xsl:template>
  <xsl:template name="InsertBulletChar">
    <xsl:param name="character" />
    <xsl:choose>
      <xsl:when test="$character= '•'">
        <!--<xsl:value-of select ="'•'"/>-->
        <xsl:value-of select ="'•'"/>
      </xsl:when>
      <xsl:when test="$character= 'Ø'">
        <!--<xsl:value-of select ="'➢'"/>-->
        <xsl:value-of select ="''"/>
      </xsl:when>
      <xsl:when test="$character= 'o'">
        <xsl:value-of select ="'○'"/>
      </xsl:when>
      <!--<xsl:when test="a:pPr/a:buChar/@char= '§'">
        <xsl:value-of select ="'•'"/>
      </xsl:when>-->
      <!--<xsl:when test="a:pPr/a:buChar/@char= '§'">
        <xsl:value-of select ="''"/>
      </xsl:when>-->
      <!--<xsl:when test="a:pPr/a:buChar/@char= '§'">
              <xsl:value-of select ="'■'"/>
          </xsl:when>
      <xsl:when test="a:pPr/a:buChar/@char= 'q'">
              <xsl:value-of select ="''"/>
          </xsl:when>-->
      <xsl:when test="$character= 'q'">
        <xsl:value-of select ="''"/>
      </xsl:when>
      <xsl:when test="$character= 'ü'">
        <!--<xsl:value-of select ="'✔'"/>-->
        <xsl:value-of select ="''"/>
      </xsl:when>
      <xsl:when test="$character = '–'">
        <xsl:value-of select ="'–'"/>
      </xsl:when>
      <xsl:when test="$character = '»'">
        <xsl:value-of select ="'»'"/>
      </xsl:when>
      <xsl:when test="$character = 'è'">
        <xsl:value-of select ="'➔'"/>
      </xsl:when>     
      <xsl:when test ="$character=''">
        <xsl:value-of select ="'●'"/>
      </xsl:when>

      <!--<xsl:when test="$character = 'à'">➔</xsl:when>
      <xsl:when test="$character = '§'">■</xsl:when>
      <xsl:when test="$character = 'q'">•</xsl:when>
      <xsl:when test="$character = '•'">•</xsl:when>
      <xsl:when test="$character = 'v'">●</xsl:when>
      <xsl:when test="$character = 'Ø'">➢</xsl:when>
      <xsl:when test="$character = 'ü'">✔</xsl:when>
      <xsl:when test="$character = 'o'">○</xsl:when>
      <xsl:when test="$character = '-'">–</xsl:when>
      <xsl:when test="$character = '»'">»</xsl:when>-->
      <xsl:otherwise>
        <!-- warn if Custom Bullet -->
        <xsl:message terminate="no">translation.oox2odf.bulletTypeSlideMasterCustomBullet</xsl:message>
        <xsl:value-of select ="'•'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="tmpSMDrawingPageStyle">
    <xsl:for-each select="key('Part', 'ppt/presentation.xml')//p:sldMasterIdLst/p:sldMasterId">
      <xsl:variable name="sldMasterIdRelation">
        <xsl:value-of select="@r:id"></xsl:value-of>
      </xsl:variable>
      <xsl:variable name="currentPos">
        <xsl:value-of select="position()"/>
      </xsl:variable>
      <!-- Loop thru each slide master.xml-->
      <xsl:for-each select="key('Part', 'ppt/_rels/presentation.xml.rels')//node()[@Id=$sldMasterIdRelation]">

        <xsl:variable name="slideMasterPath">
          <xsl:value-of select="substring-after(@Target,'/')"/>
        </xsl:variable>
        <style:style style:family="drawing-page">
          <xsl:attribute name="style:name">
            <xsl:value-of select="concat('dp',$currentPos)"/>
          </xsl:attribute>
          <style:drawing-page-properties presentation:background-visible="true" presentation:background-objects-visible="true" presentation:display-footer="true" presentation:display-page-number="true" presentation:display-date-time="true">
            <xsl:call-template name="getSlideMasterBGColor">
              <xsl:with-param name="slideMasterFile">
                <xsl:value-of select="$slideMasterPath"/>
              </xsl:with-param>
            </xsl:call-template>
          </style:drawing-page-properties>
        </style:style>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <!-- Template Added by Vijayeta
           Insert Handout styles
           Date:30th July-->
  <xsl:template name="tmpHandoutDrawingPageStyle">
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
        <style:style>
          <xsl:attribute name ="style:name">
            <xsl:value-of select ="concat('dpHandout',$curPos)"/>
          </xsl:attribute>
          <xsl:attribute name ="style:family">
            <xsl:value-of select ="'drawing-page'"/>
          </xsl:attribute>
          <style:drawing-page-properties>
            <xsl:for-each select="key('Part', concat('ppt/handoutMasters/',$handoutMasterPath))//p:sp/p:nvSpPr/p:nvPr/p:ph">
              <xsl:if test ="./@type='hdr'">
                <xsl:attribute name ="presentation:display-header">
                  <xsl:value-of select ="'true'"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test ="./@type='ftr'">
                <xsl:attribute name ="presentation:display-footer">
                  <xsl:value-of select ="'true'"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test ="./@type='sldNum'">
                <xsl:attribute name ="presentation:display-page-number">
                  <xsl:value-of select ="'true'"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test ="./@type='dt'">
                <xsl:attribute name ="presentation:display-date-time">
                  <xsl:value-of select ="'true'"/>
                </xsl:attribute>
              </xsl:if>
            </xsl:for-each>
          </style:drawing-page-properties>
        </style:style>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <!-- End of Template Added by Vijayeta to Insert Handout styles-->
  <xsl:template name="slideMasterStylePage">
    <office:master-styles>
      <draw:layer-set>
        <draw:layer draw:name="layout"/>
        <draw:layer draw:name="background"/>
        <draw:layer draw:name="backgroundobjects"/>
        <draw:layer draw:name="controls"/>
        <draw:layer draw:name="measurelines"/>
      </draw:layer-set>
      <xsl:for-each select="key('Part', 'ppt/presentation.xml')//p:sldMasterIdLst/p:sldMasterId">
        <xsl:variable name="sldMasterIdRelation">
          <xsl:value-of select="@r:id"></xsl:value-of>
        </xsl:variable>
        <xsl:variable name="currentPos">
          <xsl:value-of select="position()"/>
        </xsl:variable>
        <!-- Loop thru each slide master.xml-->
        <xsl:for-each select="key('Part', 'ppt/_rels/presentation.xml.rels')//node()[@Id=$sldMasterIdRelation]">
          <style:master-page>
            <xsl:variable name="slideMasterPath">
              <xsl:value-of select="substring-after(@Target,'/')"/>
            </xsl:variable>
            <xsl:variable name="slideMasterName">
              <xsl:value-of select="substring-before($slideMasterPath,'.xml')"/>
            </xsl:variable>
            <xsl:attribute name="style:name">
              <xsl:value-of select="$slideMasterName"/>
            </xsl:attribute>
            <xsl:attribute name="style:page-layout-name">
              <xsl:value-of select="'PM1'"/>
            </xsl:attribute>
            <xsl:attribute name="draw:style-name">
              <xsl:value-of select="concat('dp',$currentPos)"/>
            </xsl:attribute>
            <xsl:for-each select="key('Part', concat('ppt/slideMasters/',$slideMasterPath))//p:cSld/p:spTree">
            <xsl:for-each select="node()">
              <xsl:choose>
                <xsl:when test="name()='p:pic'">
                    <xsl:variable name="var_pos" select="position()"/>
                   <xsl:for-each select=".">
                     <xsl:if test="p:nvPicPr/p:nvPr/a:audioFile or p:nvPicPr/p:nvPr/a:wavAudioFile or p:nvPicPr/p:nvPr/a:videoFile">
                       <xsl:call-template name="InsertPicture">
                         <xsl:with-param name ="slideRel" select ="concat('ppt/slideMasters/_rels/',$slideMasterPath,'.rels')"/>
                         <xsl:with-param name="audio" select="'audio'"/>
                           <!--Conformance Test-->
                         <xsl:with-param name="slideId" select="$slideMasterName"/>
                       </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="not(p:nvPicPr/p:nvPr/a:audioFile or p:nvPicPr/p:nvPr/a:wavAudioFile or p:nvPicPr/p:nvPr/a:videoFile)">
                       <xsl:call-template name="InsertPicture">
                         <xsl:with-param name ="slideRel" select ="concat('ppt/slideMasters/_rels/',$slideMasterPath,'.rels')"/>
                          <xsl:with-param name="PicPosition" select="$var_pos"/>
                          <xsl:with-param name="MasterId" select="$slideMasterName"/>
                         <xsl:with-param name="srcName" select="'styles'"/>
                         <!--Conformance Test-->
                         <xsl:with-param name="slideId" select="$slideMasterName"/>
                       </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
                </xsl:when>
                <xsl:when test="name()='p:sp'">
                   <xsl:variable name="var_pos" select="position()"/>
                   <!--<xsl:for-each select=".">-->
                       <xsl:choose>
                <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='title' or p:nvSpPr/p:nvPr/p:ph/@type='ctrTitle'">
                  <draw:frame>
                    <xsl:call-template name="tmp_drawFrame">
                      <xsl:with-param name="slideMasterName" select="$slideMasterName"/>
                      <xsl:with-param name="presentationCls" select="'title'"/>
                      <xsl:with-param name="styleName" select="'-title'"/>
                    </xsl:call-template>
                    <draw:text-box />
                  </draw:frame>
                </xsl:when>
                <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='body'">
                  <draw:frame>
                    <xsl:call-template name="tmp_drawFrame">
                      <xsl:with-param name="slideMasterName" select="$slideMasterName"/>
                      <xsl:with-param name="presentationCls" select="'outline'"/>
                      <xsl:with-param name="styleName" select="'-outline1'"/>
                    </xsl:call-template>
                    <draw:text-box/>
                  </draw:frame>
                </xsl:when>
                <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='dt'">
                  <draw:frame>
                    <xsl:call-template name="tmp_drawFrame">
                      <xsl:with-param name="slideMasterName" select="$slideMasterName"/>
                      <xsl:with-param name="presentationCls" select="'date-time'"/>
                      <xsl:with-param name="styleName" select="'-DateTime'"/>
                    </xsl:call-template>
                    <draw:text-box>
                      <text:p>
                        <presentation:date-time/>
                      </text:p>
                    </draw:text-box>
                  </draw:frame>
                </xsl:when>
                <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='ftr'">
                  <xsl:variable name ="ParaId">
                    <xsl:value-of select ="concat($slideMasterName,'PARA',$var_pos)"/>
                  </xsl:variable>
                  <draw:frame>
                    <xsl:call-template name="tmp_drawFrame">
                      <xsl:with-param name="slideMasterName" select="$slideMasterName"/>
                      <xsl:with-param name="presentationCls" select="'footer'"/>
                      <xsl:with-param name="styleName" select="'-footer'"/>
                    </xsl:call-template>
                       <draw:text-box>
                            <xsl:for-each select ="p:txBody/a:p">
                              <xsl:variable name="flagFooter">
                                <!--condition changed by yeswanth.s : 9-Feb-09 : to retain footer in slide master-->
                                <xsl:if test="count(a:r) &gt; 1">
                                  <xsl:value-of select="'1'"/>
                                </xsl:if>
                              </xsl:variable>
                                    <text:p >
                                      <xsl:attribute name ="text:style-name">
                                        <xsl:value-of select ="concat($ParaId,position())"/>
                                      </xsl:attribute>
                                <!--changes made by yeswanth.s : 10-Feb-09 : For footer-->
                                      <xsl:for-each select ="node()">                                        
                                          <xsl:choose>
                                      <xsl:when test ="name()='a:br'">
                                        <text:line-break/>
                                                    </xsl:when>
                                      <xsl:when test="$flagFooter = '1' and ./a:t/child::node() != ''">
                                              <text:span>
                                                <xsl:attribute name="text:style-name">
                                                  <xsl:value-of select="concat($slideMasterName,generate-id())"/>
                                                </xsl:attribute>
                                                <xsl:call-template name="tmpFooterText"/>
                                                </text:span>
                                                    </xsl:when>
                                      <xsl:otherwise>
                                        <xsl:if test="$flagFooter !='1' and (position() = last())">
                                          <presentation:footer/>
                                        </xsl:if>
                                      </xsl:otherwise>
                                    </xsl:choose>
                                      </xsl:for-each>
                                    </text:p>
                            </xsl:for-each>
                          </draw:text-box >                  
                  </draw:frame>
                </xsl:when>
                <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='sldNum'">
                  <xsl:variable name ="ParaId">
                    <xsl:value-of select ="concat($slideMasterName,'PARA',$var_pos)"/>
                  </xsl:variable>
                  <draw:frame>
                    <xsl:call-template name="tmp_drawFrame">
                      <xsl:with-param name="slideMasterName" select="$slideMasterName"/>
                      <xsl:with-param name="presentationCls" select="'page-number'"/>
                      <xsl:with-param name="styleName" select="'-pageno'"/>
                    </xsl:call-template>
                    <draw:text-box>
                      <xsl:for-each select ="p:txBody/a:p">
                      <text:p>
                          <xsl:attribute name ="text:style-name">
                            <xsl:value-of select ="concat($ParaId,position())"/>
                          </xsl:attribute>
                          <xsl:variable name="PageText">
                            <xsl:if test ="a:r//a:t">
                              <xsl:value-of select="'1'"/>
                            </xsl:if>
                          </xsl:variable>
                          <xsl:for-each select ="node()">

                            <xsl:if test ="name()='a:r'">
                        <text:span>
                                <xsl:attribute name="text:style-name">
                                  <xsl:value-of select="concat($slideMasterName,generate-id())"/>
                                </xsl:attribute>
                                <xsl:variable name="nodeTextSpan">
                                  <xsl:call-template name="tmpTextSpanNode"/>
                                </xsl:variable>
                                <xsl:if test="not(node()/a:hlinkClick)">
                                  <xsl:copy-of select="$nodeTextSpan"/>
                                </xsl:if>
                              </text:span>
                            </xsl:if >
                            <xsl:if test ="name()='a:br'">
                              <text:line-break/>
                            </xsl:if>
                            <xsl:if test="name()='a:fld' and contains(@type,'datetime')">
                              <xsl:variable name="curSysDate">
                                <xsl:value-of select="concat(':::','current:::')" />                                
                              </xsl:variable>
                              <text:span>
                                <xsl:attribute name="text:style-name">
                                  <xsl:value-of select="concat($slideMasterName,generate-id())"/>
                                </xsl:attribute>
                              <xsl:copy-of select="$curSysDate"/>                                
                        </text:span>
                            </xsl:if>
                            <xsl:if test="name()='a:fld' and contains(@type,'slidenum')">
                              <text:page-number/>
                            </xsl:if>
                          </xsl:for-each>
                      </text:p>
                      </xsl:for-each>
                      <!--<text:p>
                        <text:span>
                          <text:page-number/>
                        </text:span>
                      </text:p>-->
                    </draw:text-box>
                  </draw:frame>
                </xsl:when>
                <xsl:when test="not(p:nvSpPr/p:nvPr/p:ph)">
                  <xsl:variable  name ="GraphicId">
                    <xsl:value-of select ="concat($slideMasterName,'gr',$var_pos,generate-id())"/>
                  </xsl:variable>
                  <xsl:variable name ="ParaId">
                    <xsl:value-of select ="concat($slideMasterName,'PARA',$var_pos,generate-id())"/>
                  </xsl:variable>
                  <xsl:call-template name ="shapes">
                    <!-- parameter added by chhavi:for ODF1.1 conformance-->
                    <xsl:with-param name ="layId" select="'true'"/>
                    <xsl:with-param name="GraphicId" select ="$GraphicId"/>
                    <xsl:with-param name ="ParaId" select="$ParaId" />
                    <xsl:with-param name ="TypeId" select="$slideMasterName" />
                    <xsl:with-param name ="SlideRelationId" select="concat('ppt/slideMasters/_rels/',$slideMasterPath,'.rels')" />                    
                  </xsl:call-template>
                </xsl:when>
              </xsl:choose>
                   <!--</xsl:for-each>-->
                </xsl:when>
                <xsl:when test="name()='p:cxnSp'">
              <xsl:variable name="var_pos" select="position()"/>
              <xsl:for-each select=".">
                <xsl:variable  name ="GraphicId">
                  <xsl:value-of select ="concat($slideMasterName,concat('grLine',$var_pos))"/>
                </xsl:variable>
                <xsl:variable name ="ParaId">
                  <xsl:value-of select ="concat($slideMasterName,concat('PARA',$var_pos))"/>
                </xsl:variable>
                <xsl:call-template name ="shapes">
                  <xsl:with-param name ="layId" select="'true'"/>
                  <xsl:with-param name="GraphicId" select ="$GraphicId"/>
                  <xsl:with-param name ="ParaId" select="$ParaId" />
                  <xsl:with-param name ="TypeId" select="$slideMasterName" />
                  <xsl:with-param name ="SlideRelationId" select="concat('ppt/slideMasters/_rels/',$slideMasterPath,'.rels')" />                 
                </xsl:call-template>
              </xsl:for-each>
            </xsl:when>
                <xsl:when test="name()='p:graphicFrame'">
                  <xsl:if test="./a:graphic/a:graphicData/p:oleObj or ./a:graphic/a:graphicData/mc:AlternateContent/mc:Fallback/p:oleObj">
                    <xsl:call-template name="tmpOLEObjects">
                      <xsl:with-param name ="SlideRelationId" select ="concat('ppt/slideMasters/_rels/',$slideMasterPath,'.rels')"/>
                    </xsl:call-template>
                  </xsl:if>
                
                </xsl:when>
                <xsl:when test="name()='p:grpSp'">
               <xsl:variable name="var_pos" select="position()"/>
                  <xsl:variable name="TopLevelgrpCordinates">
                    <xsl:call-template name="tmpGetgroupTransformValues"/>
                  </xsl:variable>
              <xsl:call-template name ="tmpSMGroupedShapes">
                <xsl:with-param name ="SlidePos"  select ="$slideMasterName" />
                <xsl:with-param name ="SlideID"  select ="$slideMasterName" />
                <xsl:with-param name ="pos"  select ="$var_pos" />
                <xsl:with-param name ="SlideRelationId" select ="concat('ppt/slideMasters/_rels/',$slideMasterPath,'.rels')"/>
                <xsl:with-param name ="grpCordinates" select ="$TopLevelgrpCordinates" />
              </xsl:call-template>
            </xsl:when>
              </xsl:choose>
            </xsl:for-each>
           </xsl:for-each>
            <!--NotesMaster-->
            <xsl:if test="key('Part', 'ppt/presentation.xml')//p:notesMasterIdLst/p:notesMasterId">
            
              <xsl:call-template name="NotesMaster">
                <xsl:with-param name="smName" select="$slideMasterName"/>
              </xsl:call-template>
            </xsl:if>
            <!--End-->
          </style:master-page>
        </xsl:for-each>
      </xsl:for-each>
      <!-- Code By Vijayeta
           Feature: HandoutMaster
           Date: 30th July '07-->
<!--Conformance Test-->
      <style:handout-master style:page-layout-name="PMhandOut">
        <!-- warn orientation in Handout -->
        <xsl:message terminate="no">translation.oox2odf.handOutMasterTypeOrientation</xsl:message>
        <xsl:for-each select="key('Part', 'ppt/presentation.xml')//p:handoutMasterIdLst/p:handoutMasterId">
          <xsl:variable name ="handoutMasterIdRelation">
            <xsl:value-of select ="./@r:id"/>
          </xsl:variable>
          <xsl:variable name ="curPos" select ="position()"/>
          <xsl:variable name ="noOfSlides">
            <xsl:value-of select ="count(./parent::node()/parent::node()/p:sldIdLst/p:sldId) "/>
          </xsl:variable>
          <xsl:attribute name ="presentation:presentation-page-layout-name">
            <xsl:value-of select ="'AL0T26'"/>
          </xsl:attribute>          
          <xsl:attribute name ="draw:style-name">
            <xsl:value-of select ="concat('dpHandout',$curPos)"/>
          </xsl:attribute>
          <!--<xsl:attribute name ="presentation:use-header-name">
            <xsl:value-of select ="concat('hdr',$curPos)"/>
          </xsl:attribute>
          <xsl:attribute name ="presentation:use-footer-name">
            <xsl:value-of select ="concat('ftr',$curPos)"/>
          </xsl:attribute>
          <xsl:attribute name ="presentation:use-date-time-name">
            <xsl:value-of select ="concat('dtd',$curPos)"/>
          </xsl:attribute>-->
          <xsl:for-each select="key('Part', 'ppt/_rels/presentation.xml.rels')//node()[@Id=$handoutMasterIdRelation]">
            <xsl:variable name="handoutMasterPath">
              <xsl:value-of select="substring-after(@Target,'/')"/>
            </xsl:variable>
            <xsl:variable name="handoutMasterName">
              <xsl:value-of select="substring-before($handoutMasterPath,'.xml')"/>
            </xsl:variable>
            <xsl:for-each select="key('Part', concat('ppt/handoutMasters/',$handoutMasterPath))//p:sp">
              <xsl:variable name ="pos" select ="position()"/>
              <xsl:choose>
                <xsl:when test ="p:nvSpPr/p:nvPr/p:ph/@type='hdr'">
                  <draw:frame svg:width="12.124cm" svg:height="1.078cm" svg:x="0.576cm" svg:y="0.635cm" >
                    <!--svg:x="0cm" svg:y="0cm"-->
                    <xsl:call-template name="tmp_handoutDrawFrame">
                      <xsl:with-param name="handoutMasterName" select="$handoutMasterName"/>
                      <xsl:with-param name="presentationCls" select="'header'"/>
                      <xsl:with-param name="styleName" select="concat('grHeaderDateTime',$pos)"/>
                      <xsl:with-param name="textStyleName" select="concat('paraHeaderFooter',$pos)"/>
                    </xsl:call-template>
                    <draw:text-box>
                      <text:p>
                        <xsl:attribute name ="text:style-name">
                          <xsl:value-of select ="concat('paraHeaderFooter',$pos)"/>
                        </xsl:attribute>
                        <xsl:if test ="./p:txBody/a:p/a:r">
                          <text:span text:style-name="{generate-id()}">
                            <xsl:value-of select ="./p:txBody/a:p/a:r/a:t"/>
                          </text:span>

                        </xsl:if>
                        <!--<presentation:header/>-->
                      </text:p>
                    </draw:text-box>
                  </draw:frame>
                </xsl:when>
                <xsl:when test ="p:nvSpPr/p:nvPr/p:ph/@type='dt'">
                  <draw:frame svg:width="12.124cm" svg:height="1.078cm" svg:x="15.24cm" svg:y="0.635cm">
                    <!--svg:x="15.815cm" svg:y="0cm"-->
                    <xsl:call-template name="tmp_handoutDrawFrame">
                      <xsl:with-param name="handoutMasterName" select="$handoutMasterName"/>
                      <xsl:with-param name="presentationCls" select="'date-time'"/>
                      <xsl:with-param name="styleName" select="concat('grHeaderDateTime',$pos)"/>
                      <xsl:with-param name="textStyleName" select="concat('paraDateTimePageNum',$pos)"/>
                    </xsl:call-template>
                    <draw:text-box>
                      <text:p>
                        <xsl:attribute name ="text:style-name">
                          <xsl:value-of select ="concat('paraDateTimePageNum',$pos)"/>
                        </xsl:attribute>
                        <!--<xsl:if test ="./p:txBody/a:p/a:r">-->
                        <text:span text:style-name="{generate-id()}">
                          <xsl:value-of select ="./p:txBody/a:p/a:fld/a:t"/>
                          <presentation:date-time/>
                        </text:span>
                        <!--</xsl:if>-->
                        <!--<presentation:date-time />-->
                      </text:p>
                    </draw:text-box>
                  </draw:frame>
                </xsl:when>
                <xsl:when test ="p:nvSpPr/p:nvPr/p:ph/@type='ftr'">
                  <draw:frame svg:width="12.124cm" svg:height="1.078cm" svg:x="0.576cm" svg:y="19.877cm" >
                    <!--svg:x="0cm" svg:y="20.511cm"-->
                    <xsl:call-template name="tmp_handoutDrawFrame">
                      <xsl:with-param name="handoutMasterName" select="$handoutMasterName"/>
                      <xsl:with-param name="presentationCls" select="'footer'"/>
                      <xsl:with-param name="styleName" select="concat('grFooterPageNum',$pos)"/>
                      <xsl:with-param name="textStyleName" select="concat('paraHeaderFooter',$pos)"/>
                    </xsl:call-template>
                    <draw:text-box>
                      <text:p>
                        <xsl:attribute name ="text:style-name">
                          <xsl:value-of select ="concat('paraHeaderFooter',$pos)"/>
                        </xsl:attribute>
                        <xsl:if test ="./p:txBody/a:p/a:r">
                          <text:span text:style-name="{generate-id()}">
                            <xsl:value-of select ="./p:txBody/a:p/a:r/a:t"/>
                          </text:span>
                        </xsl:if>
                        <!--<presentation:footer />-->
                      </text:p>
                    </draw:text-box>
                  </draw:frame>
                </xsl:when>
                <xsl:when test ="p:nvSpPr/p:nvPr/p:ph/@type='sldNum'">
                  <draw:frame svg:width="12.124cm" svg:height="1.078cm" svg:x="15.24cm" svg:y="19.877cm">
                    <!--svg:x="15.815cm" svg:y="20.511cm"-->
                    <xsl:call-template name="tmp_handoutDrawFrame">
                      <xsl:with-param name="handoutMasterName" select="$handoutMasterName"/>
                      <xsl:with-param name="presentationCls" select="'page-number'"/>
                      <xsl:with-param name="styleName" select="concat('grFooterPageNum',$pos)"/>
                      <xsl:with-param name="textStyleName" select="concat('paraDateTimePageNum',$pos)"/>
                    </xsl:call-template>
                    <draw:text-box>
                      <text:p>
                        <xsl:attribute name ="text:style-name">
                          <xsl:value-of select ="concat('paraDateTimePageNum',$pos)"/>
                        </xsl:attribute>
                        <text:page-number>
                          &lt;#&gt;
                        </text:page-number>
                      </text:p>
                    </draw:text-box>
                  </draw:frame>
                </xsl:when>
                <xsl:when test="not(p:nvSpPr/p:nvPr/p:ph/@type) and not(p:nvSpPr/p:nvPr/p:ph/@idx)">
                  <xsl:variable  name ="GraphicId">
                    <xsl:value-of select ="concat($handoutMasterName,concat('gr',position()))"/>
                  </xsl:variable>
                  <xsl:variable name ="ParaId">
                    <xsl:value-of select ="concat($handoutMasterName,concat('PARA',position()))"/>
                  </xsl:variable>
                  <xsl:call-template name ="shapes">
                    <xsl:with-param name="GraphicId" select ="$GraphicId"/>
                    <xsl:with-param name ="ParaId" select="$ParaId" />
                  </xsl:call-template>
                </xsl:when>
              </xsl:choose>
            </xsl:for-each>
          </xsl:for-each>
          <xsl:call-template name ="insertPageThumbnail">
            <xsl:with-param name ="noOfSlides" select ="$noOfSlides"/>
          </xsl:call-template>
        </xsl:for-each>
      </style:handout-master>
      <!-- End of Code By Vijayeta
           Feature: HandoutMaster
           Date: 30th July '07-->
    </office:master-styles>
  </xsl:template>
  <xsl:template name="tmpFooterText">
   <xsl:variable name="nodeTextSpan">
      <xsl:call-template name="tmpTextSpanNode"/>
    </xsl:variable>
    <xsl:if test="not(node()/a:hlinkClick)">
      <xsl:copy-of select="$nodeTextSpan"/>
    </xsl:if>
  </xsl:template>
   <xsl:template name ="slideMasterFontName">
    <xsl:param name ="fontType" />
    <xsl:param name ="SMName" />
    <xsl:for-each select="key('Part', concat('ppt/slideMasters/_rels/',$SMName,'.rels'))//node()/@Target[contains(.,'theme')]">
      <xsl:variable name="var_Themefile" select="concat('ppt',substring-after(.,'..'))"/>
      <xsl:choose >
        <xsl:when test ="$fontType ='major'">
          <xsl:value-of select ="key('Part', $var_Themefile)/a:theme/a:themeElements/a:fontScheme/a:majorFont/a:latin/@typeface"/>
        </xsl:when>
        <xsl:when test ="$fontType ='minor'">
          <xsl:value-of select ="key('Part', $var_Themefile)/a:theme/a:themeElements/a:fontScheme/a:minorFont/a:latin/@typeface"/>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="SubtitleStyle">
    <xsl:param name="SlideMasterFile"></xsl:param>
    <xsl:param name="SMName"/>
    <style:graphic-properties>
      <xsl:call-template name="tmpSMGraphicProperty">
        <xsl:with-param name="blnSubTitle">
          <xsl:value-of select="'true'"/>
        </xsl:with-param>
        <xsl:with-param name="SMName" select="$SMName"/>
        <xsl:with-param name="shapePhType" select="'subtitle'"/>
      </xsl:call-template>
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
      </text:list-style>
    </style:graphic-properties>
    <style:paragraph-properties>
      <xsl:for-each select="key('Part', concat('ppt/slideMasters/',$SlideMasterFile))//p:txStyles/p:bodyStyle/a:lvl1pPr">
        <xsl:call-template name="tmpSMParagraphStyle"/>
       </xsl:for-each>
    </style:paragraph-properties>
    <xsl:for-each select="key('Part', concat('ppt/slideMasters/',$SlideMasterFile))//p:txStyles/p:bodyStyle/a:lvl1pPr">
      <style:text-properties>
        <xsl:call-template name="tmpShapeTextProperty">
          <xsl:with-param name="fontType" select="'minor'"/>
          <xsl:with-param name="SLMName" select="$SlideMasterFile"/>
        </xsl:call-template>
      </style:text-properties>
    </xsl:for-each>
  </xsl:template>
    <xsl:template name="getSlideMasterBGColor">
    <xsl:param name="slideMasterFile"/>
    <xsl:for-each select="key('Part', concat('ppt/slideMasters/',$slideMasterFile))//p:cSld/p:bg">
      <xsl:choose>
        <xsl:when test="p:bgPr/a:solidFill">
          <xsl:for-each select="p:bgPr/a:solidFill">
            <xsl:call-template name="tmpShapeSolidFillColor">
              <xsl:with-param name="SMName" select="$slideMasterFile"/>
                    </xsl:call-template>
               </xsl:for-each>
         </xsl:when>
        <xsl:when test="p:bgPr/a:gradFill">
          <xsl:call-template name="tmpBackGrndGradFillColor">
            <xsl:with-param name="FileType" select="concat(substring-before($slideMasterFile,'.xml'),'-Gradient')"/>
            <xsl:with-param name="SMName" select="$slideMasterFile"/>
            </xsl:call-template>
            </xsl:when>
        <xsl:when test="p:bgRef and p:bgRef/@idx &gt; 0 and p:bgRef/@idx &lt; 1000">
          <xsl:for-each select="p:bgRef/a:solidFill">
            <xsl:call-template name="tmpShapeSolidFillColor">
              <xsl:with-param name="SMName" select="$slideMasterFile"/>
                    </xsl:call-template>
           </xsl:for-each>
        </xsl:when>
        <xsl:when test="(p:bgPr/a:blipFill or p:bgRef/a:blipFill) and p:bgPr/a:blipFill/a:blip/@r:embed">
        <xsl:attribute name="draw:fill-image-name">
            <xsl:value-of select="concat(substring-before($slideMasterFile,'.xml'),'BackImg')"/>
          </xsl:attribute>
          <xsl:for-each select="p:bgPr">
            <xsl:call-template name="tmpPictureFillProp"/>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="p:bgRef/@idx &gt; 1000">
          <xsl:variable name="idx" select="p:bgRef/@idx - 1000"/>
          <xsl:variable name="blnImage">
            <xsl:for-each select="key('Part', concat('ppt/slideMasters/_rels/',$slideMasterFile,'.rels'))//node()/@Target[contains(.,'theme')]">
              <xsl:variable name="var_Themefile" select="concat('ppt',substring-after(.,'..'))"/>
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
            </xsl:for-each>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$blnImage='1'">
               <xsl:attribute name="draw:fill-image-name">
                <xsl:value-of select="concat(substring-before($slideMasterFile,'.xml'),'BackImg')"/>
              </xsl:attribute>
              <xsl:for-each select="p:bgPr">
                <xsl:call-template name="tmpPictureFillProp"/>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="p:bgRef/a:schemeClr">
                <xsl:attribute name="draw:fill-color">
                  <xsl:call-template name ="getColorCode">
                    <xsl:with-param name ="color">
                      <xsl:call-template name="tmpThemeClr_Background">
                        <xsl:with-param name="ClrMap" select="p:bgRef/a:schemeClr/@val"/>
                      </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name ="lumMod">
                      <xsl:value-of select="p:bgRef/a:schemeClr/a:lumMod/@val" />
                    </xsl:with-param>
                    <xsl:with-param name ="lumOff">
                      <xsl:value-of select="p:bgRef/a:schemeClr/a:lumOff/@val" />
                    </xsl:with-param>
                    <xsl:with-param name ="SMName" select="$slideMasterFile"/>
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="draw:fill">
                  <xsl:value-of select="'solid'"/>
                </xsl:attribute>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="draw:fill-color">
            <xsl:value-of select="'#FFFFFF'"/>
          </xsl:attribute>
          <xsl:attribute name="draw:fill">
            <xsl:value-of select="'solid'"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:if test="not(key('Part', concat('ppt/slideMasters/',$slideMasterFile))//p:cSld/p:bg)">
       <xsl:attribute name="draw:fill-color">
            <xsl:value-of select="'#FFFFFF'"/>
          </xsl:attribute>
          <xsl:attribute name="draw:fill">
            <xsl:value-of select="'solid'"/>
          </xsl:attribute>
    </xsl:if>
  </xsl:template>
  <xsl:template name="tmpgetBackImage">
    <xsl:param name="FilePath"/>
    <xsl:param name="FileName"/>
    <xsl:param name="FileType"/>
    <xsl:variable name="var_FileType">
      <xsl:if test="$FileType='SM'">
        <xsl:value-of select="'slideMasters'"/>
      </xsl:if>
      <xsl:if test="$FileType='S'">
        <xsl:value-of select="'slides'"/>
      </xsl:if>
      <xsl:if test="$FileType='SL'">
        <xsl:value-of select="'slideLayouts'"/>
      </xsl:if>
      <xsl:if test="contains($FileType,'handoutMaster')">
        <xsl:value-of select="'handoutMasters'"/>
      </xsl:if>
      <xsl:if test="contains($FileType,'notesMaster')">
        <xsl:value-of select="'notesMasters'"/>
      </xsl:if>
    </xsl:variable>
    <xsl:for-each select="key('Part', $FilePath)//p:cSld/p:bg">
      <xsl:choose>
        <xsl:when test="p:bgPr/a:blipFill and p:bgPr/a:blipFill/a:blip/@r:embed">
          <!-- Pictures-->
          <xsl:for-each select="p:bgPr">
            <xsl:call-template name="tmpInsertBackImage">
              <xsl:with-param name ="slideRel" select ="concat('ppt/',$var_FileType,'/_rels/',$FileName,'.rels')"/>
              <xsl:with-param name ="backImage" select ="'1'"/>
              <xsl:with-param name ="SMName" select ="concat(substring-before($FileName,'.xml'),'BackImg')"/>
            </xsl:call-template>
          </xsl:for-each>
          <!-- Pictures-->
        </xsl:when>
        <xsl:when test="p:bgRef/@idx &gt; 1000 or p:bgRef/a:blipFill">
            <xsl:variable name="idx" select="p:bgRef/@idx - 1000"/>
          <xsl:variable name="var_Themefile">
             <xsl:choose>
              <xsl:when test="$FileType='SM'">
                <xsl:for-each select="key('Part', concat('ppt/slideMasters/_rels/',substring-after($FilePath,'ppt/slideMasters/'),'.rels'))//node()/@Target[contains(.,'theme')]">
                  <xsl:value-of select="concat('ppt',substring-after(.,'..'))"/>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="$FileType='SL'">
                <xsl:for-each select="key('Part', concat('ppt/slideMasters/_rels/',substring-after($FilePath,'ppt/slideLayouts/'),'.rels'))//node()/@Target[contains(.,'theme')]">
                  <xsl:value-of select="concat('ppt',substring-after(.,'..'))"/>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="$FileType='S'">
                <xsl:variable name="layoutFile">
                  <xsl:for-each select="key('Part', concat('ppt/slides/_rels/',substring-after($FilePath,'ppt/slides/'),'.rels'))//node()/@Target[contains(.,'slideLayouts')]">
                    <xsl:value-of select="substring-after(.,'../slideLayouts/')"/>
                  </xsl:for-each>
                </xsl:variable>
                 <xsl:variable name="SMFile">
                   <xsl:for-each select="key('Part', concat('ppt/slideLayouts/',$layoutFile))//node()/@Target[contains(.,'slideMasters')]">
                     <xsl:value-of select="substring-after(.,'../slideMasters/')"/>
                  </xsl:for-each>
                </xsl:variable>
                <xsl:for-each select="key('Part', concat('ppt/slideMasters/_rels/',$SMFile,'.rels'))//node()/@Target[contains(.,'slideLayouts')]">
                  <xsl:value-of select="concat('ppt',substring-after(.,'..'))"/>
                </xsl:for-each>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="blnImage">
            <xsl:choose>
              <xsl:when test="$FileType='SM'">
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
              </xsl:when>
              <xsl:when test="$FileType='SL'">
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
              </xsl:when>
              <xsl:when test="$FileType='S'">
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
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:if test="$blnImage='1'">
            <!-- Pictures-->
            <xsl:call-template name="tmpInsertBackImage">
              <xsl:with-param name ="slideRel" select ="concat('ppt/',$var_FileType,'/_rels/',$FileName,'.rels')"/>
              <xsl:with-param name ="backImage" select ="'1'"/>
              <xsl:with-param name ="idx" select ="p:bgRef/@idx - 1000"/> 
              <xsl:with-param name ="SMName" select ="concat(substring-before($FileName,'.xml'),'BackImg')"/>
             <xsl:with-param name ="ThemeFile" select ="$var_Themefile"/>
            </xsl:call-template>
            <!-- Pictures-->
          </xsl:if>
          </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:for-each select="key('Part', $FilePath)//p:cSld/p:spTree">
      <xsl:for-each select="node()">
        <xsl:choose>
          <xsl:when test="name()='p:sp'">
            <xsl:choose>
              <xsl:when test="not(p:nvSpPr/p:nvPr/p:ph)">
                <xsl:variable name="var_pos" select="position()"/>
                <xsl:choose>
                  <xsl:when test="p:spPr/a:blipFill/a:blip/@r:embed">
                    <!-- Pictures-->
                    <xsl:for-each select="p:spPr">
                      <xsl:call-template name="tmpInsertBackImage">
                        <xsl:with-param name ="slideRel" select ="concat('ppt/',$var_FileType,'/_rels/',$FileName,'.rels')"/>
                        <xsl:with-param name ="backImage" select ="'1'"/>
                        <xsl:with-param name ="var_pos" select ="$var_pos"/>
                        <xsl:with-param name ="SMName" select ="concat(substring-before($FileName,'.xml'),'-shapeImg')"/>
                      </xsl:call-template>
                    </xsl:for-each>
                    <!-- Pictures-->
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="p:nvSpPr/p:nvPr/p:ph">
                <xsl:variable name="var_pos" select="position()"/>
                <xsl:variable name="var_shapeType">
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
                <xsl:choose>
                  <xsl:when test="p:spPr/a:blipFill/a:blip/@r:embed">
                    <!-- Pictures-->
                    <xsl:for-each select="p:spPr">
                      <xsl:call-template name="tmpInsertBackImage">
                        <xsl:with-param name ="slideRel" select ="concat('ppt/',$var_FileType,'/_rels/',$FileName,'.rels')"/>
                        <xsl:with-param name ="backImage" select ="'1'"/>
                        <xsl:with-param name ="var_pos">
                          <xsl:choose>
                            <xsl:when test="$FileType='SM' and (not (contains($var_shapeType,'title')) and not(contains($var_shapeType,'subtitle')))">
                              <xsl:value-of select="$var_pos"/>
                            </xsl:when>
                            <xsl:when test="$FileType='SL' and (not (contains($var_shapeType,'title')) and not(contains($var_shapeType,'subtitle')))">
                              <xsl:value-of select="$var_pos"/>
                            </xsl:when>
                            <xsl:when test="$FileType='S'">
                              <xsl:value-of select="$var_pos"/>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:with-param>
                        <xsl:with-param name ="SMName" select ="concat(substring-before($FileName,'.xml'),'-',$var_shapeType,'Img')"/>
                      </xsl:call-template>
                    </xsl:for-each>
                    <!-- Pictures-->
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="name()='p:grpSp'">
            <xsl:variable name="var_pos" select="position()"/>
            <xsl:for-each select=".">
              <xsl:call-template name="tmpGroupedShapeImage">
                <xsl:with-param name ="FileName" select ="$FileName"/>
                <xsl:with-param name ="var_FileType" select ="$var_FileType"/>
                <xsl:with-param name ="var_pos" select ="$var_pos"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="tmpGroupedShapeImage">
    <xsl:param name="FileName"/>
    <xsl:param name="var_FileType"/>
    <xsl:param name="var_shapeType"/>
    <xsl:param name="var_pos"/>
    
    <xsl:for-each select="node()">
      <xsl:choose>
        <xsl:when test="name()='p:sp'">
          <xsl:choose>
            <xsl:when test="not(p:nvSpPr/p:nvPr/p:ph)">
              <xsl:variable name="pos" select="position()"/>
              <xsl:choose>
                <xsl:when test="p:spPr/a:blipFill/a:blip/@r:embed">
                  <!-- Pictures-->
                  <xsl:for-each select="p:spPr">
                    <xsl:call-template name="tmpInsertBackImage">
                      <xsl:with-param name ="slideRel" select ="concat('ppt/',$var_FileType,'/_rels/',$FileName,'.rels')"/>
                      <xsl:with-param name ="backImage" select ="'1'"/>
                      <xsl:with-param name ="var_pos" select ="concat($var_pos,'-',$pos)"/>
                      <xsl:with-param name ="SMName" select ="concat(substring-before($FileName,'.xml'),'-grpshapeImg')"/>
                    </xsl:call-template>
                  </xsl:for-each>
                  <!-- Pictures-->
                </xsl:when>
              </xsl:choose>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="name()='p:grpSp'">
          <xsl:variable name="pos" select="position()"/>
          <xsl:call-template name="tmpGroupedShapeImage">
            <xsl:with-param name ="FileName" select ="$FileName"/>
            <xsl:with-param name ="var_FileType" select ="$var_FileType"/>
            <xsl:with-param name ="var_pos" select ="concat($var_pos,'-',$pos)"/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
        </xsl:for-each>
  </xsl:template>
  <xsl:template name ="Outlines">
    <xsl:param name="level"/>
    <xsl:param name="SMName"/>
    <xsl:param name="blnBullet"></xsl:param>
    <xsl:if test="not($blnBullet='true')">
      <style:paragraph-properties>
        <xsl:choose>
          <xsl:when test="./a:buChar/@char">
            <xsl:attribute name ="text:enable-numbering">
              <xsl:value-of select ="'true'"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="./a:buBlip">
            <xsl:attribute name ="text:enable-numbering">
              <xsl:value-of select ="'true'"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="./a:buAutoNum/@type">
            <xsl:attribute name ="text:enable-numbering">
              <xsl:value-of select ="'true'"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name ="text:enable-numbering">
              <xsl:value-of select ="'false'"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <!--<xsl:choose>
        <xsl:when test="$level='1'">
          <xsl:attribute name ="text:enable-numbering">
            <xsl:value-of select ="'true'"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>-->
        <xsl:call-template name="tmpSMParagraphStyle"/>
        <xsl:if test="$level='1'">
          <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='body']">
            <xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:bodyPr/@vert='vert'">
              <xsl:attribute name ="style:writing-mode">
                <xsl:value-of select ="'tb-rl'"/>
              </xsl:attribute>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>
      </style:paragraph-properties>
    </xsl:if>
    <style:text-properties>
      <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='body' or (not(@type) and @idx)]">
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txBody/a:p/a:pPr[@lvl = $level - 1]">
          <xsl:choose>
            <xsl:when test="../a:r[1]/a:rPr/@lang">
              <xsl:for-each select="../a:r[1]/a:rPr">
                <xsl:call-template name="tmpTextLanguage">
                  <xsl:with-param name="lang" select="@lang"/>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="../a:endParaRPr/@lang">
              <xsl:for-each select="../a:endParaRPr">
                <xsl:call-template name="tmpTextLanguage">
                  <xsl:with-param name="lang" select="@lang"/>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="style:language-asian">
                <xsl:value-of select="'en'"/>
              </xsl:attribute>
              <xsl:attribute name="style:country-asian">
                <xsl:value-of select="'US'"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>

        </xsl:for-each>
      </xsl:for-each>
      <xsl:choose>
        <xsl:when test="$blnBullet='true'">
          <xsl:attribute name ="style:font-charset">
            <xsl:value-of select ="'x-symbol'"/>
          </xsl:attribute>
          <xsl:if test ="./a:buSzPct">
            <xsl:attribute name ="fo:font-size">
              <xsl:value-of select ="concat((./a:buSzPct/@val div 1000),'%')"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test ="not(./a:buSzPct)">
            <xsl:attribute name ="fo:font-size">
              <xsl:value-of select ="'100%'"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test ="./a:buClr">
            <xsl:if test ="./a:buClr/a:srgbClr">
              <xsl:variable name ="color" select ="./a:buClr/a:srgbClr/@val"/>
              <xsl:attribute name ="fo:color">
                <xsl:value-of select ="concat('#',$color)"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test ="./a:buClr/a:schemeClr">
              <xsl:variable name="var_SchmClrVal" select="./a:buClr/a:schemeClr/@val"/>
              <xsl:attribute name ="fo:color">
                <xsl:call-template name ="getColorCode">
                  <xsl:with-param name ="color">
                    <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:clrMap">
                    <xsl:call-template name="tmpThemeClr">
                      <xsl:with-param name="ClrMap" select="$var_SchmClrVal"/>
                    </xsl:call-template>
                    </xsl:for-each>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:attribute>
            </xsl:if>
          </xsl:if>
          <xsl:if test ="not(./a:buClr)">
            <xsl:choose>
              <xsl:when test="./a:defRPr/a:solidFill/a:srgbClr">
                <xsl:attribute name ="fo:color">
                  <xsl:value-of select="concat('#',./a:defRPr/a:solidFill/a:srgbClr/@val)"></xsl:value-of>
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="./a:defRPr/a:solidFill/a:schemeClr">
                <xsl:variable name="var_SchmClrVal" select="./a:defRPr/a:solidFill/a:schemeClr/@val"/>
                <xsl:attribute name ="fo:color">
                  <xsl:call-template name ="getColorCode">
                    <xsl:with-param name ="color">
                      <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:clrMap">
                        <xsl:call-template name="tmpThemeClr">
                          <xsl:with-param name="ClrMap" select="$var_SchmClrVal"/>
                        </xsl:call-template>
                      </xsl:for-each>
                    </xsl:with-param>
                    <xsl:with-param name ="lumMod">
                      <xsl:choose>
                        <xsl:when test="./a:defRPr/a:solidFill/a:schemeClr/a:lumMod">
                          <xsl:value-of select="./a:defRPr/a:solidFill/a:schemeClr/a:lumMod/@val" />
                        </xsl:when>
                      </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name ="lumOff">
                      <xsl:choose>
                        <xsl:when test="./a:defRPr/a:solidFill/a:schemeClr/a:lumOff">
                          <xsl:value-of select="./a:defRPr/a:solidFill/a:schemeClr/a:lumOff/@val" />
                        </xsl:when>
                      </xsl:choose>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name ="fo:color">
                  <xsl:value-of select="'#000000'"/>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <xsl:attribute name ="fo:font-family">
            <xsl:if test ="./a:buFont/@typeface">
              <xsl:variable name ="typeFaceVal" select ="./a:buFont/@typeface"/>
              <xsl:for-each select ="./a:buFont/@typeface">
                <xsl:if test ="$typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt'">
                  <xsl:call-template name="slideMasterFontName">
                    <xsl:with-param name="fontType">
                      <xsl:value-of select="'minor'"/>
                    </xsl:with-param>
                    <xsl:with-param name="SMName" select="$SMName"/>
                  </xsl:call-template>
                </xsl:if>
                <xsl:if test ="not($typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt')">
                  <xsl:value-of select ="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:if>
            <xsl:if test ="not(./a:buFont/@typeface)">
              <xsl:value-of select ="'StarSymbol'"/>
            </xsl:if>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="./a:defRPr/@sz">
            <xsl:attribute name ="style:font-size-asian">
              <xsl:value-of select ="concat(./a:defRPr/@sz div 100 ,'pt')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:font-size-complex">
              <xsl:value-of select ="concat(./a:defRPr/@sz div 100 ,'pt')"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:call-template name="tmpShapeTextProperty">
            <xsl:with-param name="fontType" select="'minor'"/>
            <xsl:with-param name="SLMName" select="$SMName"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </style:text-properties>
  </xsl:template>
  <xsl:template name ="GraphicStyleForSlideMaster">
    <xsl:for-each select="key('Part', 'ppt/presentation.xml')//p:sldMasterIdLst/p:sldMasterId">
      <xsl:variable name="sldMasterIdRelation">
        <xsl:value-of select="@r:id"></xsl:value-of>
      </xsl:variable>
      <!--Loop thru each slide master.xml-->
      <xsl:for-each select="key('Part', 'ppt/_rels/presentation.xml.rels')//node()[@Id=$sldMasterIdRelation]">
        <xsl:variable name="slideMasterPath">
          <xsl:value-of select="substring-after(@Target,'/')"/>
        </xsl:variable>
        <xsl:variable name="slideMasterName">
          <xsl:value-of select="substring-before($slideMasterPath,'.xml')"/>
        </xsl:variable>
        <!--Graphic properties for shapes with p:sp nodes-->
        <xsl:for-each select="key('Part', concat('ppt/slideMasters/',$slideMasterPath))//p:cSld/p:spTree">
           <xsl:for-each select="node()">
             <xsl:choose>
              <xsl:when test="name()='p:sp'">
              <xsl:variable name="var_pos" select="position()"/>
              <xsl:for-each select=".">
                  <xsl:variable name ="ParaId">
                      <xsl:value-of select ="concat($slideMasterName,'PARA',$var_pos)"/>
                    </xsl:variable>
               <xsl:choose>
                  <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='dt'">
              <!-- style for DateTime-->
              <style:style>
                <xsl:attribute name="style:name">
                  <xsl:value-of select="concat($slideMasterName,'-DateTime')"/>
                </xsl:attribute>
                <xsl:attribute name ="style:family">
                  <xsl:value-of select ="'presentation'"/>
                </xsl:attribute>
                <xsl:attribute name="style:parent-style-name">
                  <xsl:value-of select="concat($slideMasterName,'-backgroundobjects')"/>
                </xsl:attribute>
                <xsl:call-template name="tmpSMDatePageNoFooterStyle">
                  <xsl:with-param name="SMName" select="$slideMasterPath"/>
                  <xsl:with-param name="shapePhType" select="'DateTime'"/>
                </xsl:call-template>
              </style:style>
            </xsl:when>
                  <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='ftr'">
              <!-- style for footer-->
              <style:style>
                <xsl:attribute name="style:name">
                  <xsl:value-of select="concat($slideMasterName,'-footer')"/>
                </xsl:attribute>
                <xsl:attribute name ="style:family">
                  <xsl:value-of select ="'presentation'"/>
                </xsl:attribute>
                <xsl:attribute name="style:parent-style-name">
                  <xsl:value-of select="concat($slideMasterName,'-backgroundobjects')"/>
                </xsl:attribute>
                <xsl:call-template name="tmpSMDatePageNoFooterStyle">
                  <xsl:with-param name="SMName" select="$slideMasterPath"/>
                  <xsl:with-param name="shapePhType" select="'Footer'"/>
                  <xsl:with-param name="spType" select="'Footer'"/>
                </xsl:call-template>
              </style:style>
                  <xsl:call-template name="tmpFtrSlNoDtStyle">
                      <xsl:with-param name="ParaId" select="$ParaId"/>
                      <xsl:with-param name="TypeId" select="$slideMasterName"/>
                    <xsl:with-param name="SMName" select="$slideMasterPath"/>
                    </xsl:call-template>
            </xsl:when>
                  <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='sldNum'">
              <!-- style for DateTime-->
              <style:style>
                <xsl:attribute name="style:name">
                  <xsl:value-of select="concat($slideMasterName,'-pageno')"/>
                </xsl:attribute>
                <xsl:attribute name ="style:family">
                  <xsl:value-of select ="'presentation'"/>
                </xsl:attribute>
                <xsl:attribute name="style:parent-style-name">
                  <xsl:value-of select="concat($slideMasterName,'-backgroundobjects')"/>
                </xsl:attribute>
                <xsl:call-template name="tmpSMDatePageNoFooterStyle">
                  <xsl:with-param name="SMName" select="$slideMasterPath"/>
                  <xsl:with-param name="spType" select="'PageNo'"/>
                  <xsl:with-param name="shapePhType" select="'PageNumber'"/>
                </xsl:call-template>
                  
              </style:style>
                     <xsl:call-template name="tmpFtrSlNoDtStyle">
                      <xsl:with-param name="ParaId" select="$ParaId"/>
                      <xsl:with-param name="TypeId" select="$slideMasterName"/>
                    <xsl:with-param name="SMName" select="$slideMasterName"/>
                    </xsl:call-template>
            </xsl:when>
                  <xsl:when test="not(p:nvSpPr/p:nvPr/p:ph)">
                    <xsl:variable  name ="GraphicId">
                       <xsl:value-of select ="concat($slideMasterName,'gr',$var_pos,generate-id())"/>
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
                          <xsl:with-param name="FileType" select="$slideMasterName"/>
                          <xsl:with-param name="SMName" select="$slideMasterPath"/>
                          
                        </xsl:call-template>
                        <!--LINE COLOR-->
                        <xsl:call-template name ="LineColor" >
                              <xsl:with-param name="SMName" select="$slideMasterPath"/>
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
                          <xsl:attribute name ="style:writing-mode">
                            <xsl:call-template name ="getTextDirection">
                              <xsl:with-param name ="vert" select ="p:txBody/a:bodyPr/@vert" />
                            </xsl:call-template>
                          </xsl:attribute>
                        </style:paragraph-properties>
                      </xsl:if>
                    </style:style>
                    <xsl:call-template name="tmpShapeTextProcess">
                      <xsl:with-param name="ParaId" select="concat($ParaId,generate-id())"/>
                      <xsl:with-param name="TypeId" select="$slideMasterName"/>
                      <xsl:with-param name="flagTextBox" select="$flagTextBox"/>
                      <xsl:with-param name="SMName" select="$slideMasterPath"/>
                    </xsl:call-template>
                  </xsl:when>
               </xsl:choose>
              </xsl:for-each>
             </xsl:when>
              <xsl:when test="name()='p:cxnSp'">
                 <xsl:variable name="var_pos" select="position()"/>
                 <xsl:for-each select=".">
                <xsl:variable  name ="GraphicId">
                       <xsl:value-of select ="concat($slideMasterName,concat('grLine',$var_pos))"/>
                     </xsl:variable>
                     <xsl:variable name ="ParaId">
                  <xsl:value-of select ="concat($slideMasterName ,concat('PARA',$var_pos))"/>
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
                          <xsl:with-param name="SMName" select="$slideMasterPath"/>
                        </xsl:call-template>
                        <!--LINE COLOR-->
                        <xsl:call-template name ="LineColor" >
                             <xsl:with-param name="SMName" select="$slideMasterPath"/>
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
                      <xsl:with-param name="TypeId" select="$slideMasterName"/>
                    </xsl:call-template>
              </xsl:for-each>
            </xsl:when>
              <!--Picture Border-->
              <xsl:when test="name()='p:pic'">
                <xsl:variable name="varmaster">
                  <xsl:value-of select="position()"/>
                </xsl:variable>
              <xsl:for-each select=".">
                
                  <xsl:variable  name ="GraphicId">
                    <xsl:value-of select ="concat($slideMasterName,'Picture',$varmaster,'gr')"/>
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
                      <!--Croppin-->
                      <xsl:if test="not(p:nvPicPr/p:nvPr/a:audioFile or p:nvPicPr/p:nvPr/a:wavAudioFile or p:nvPicPr/p:nvPr/a:videoFile)">
                        <xsl:variable name ="imageId">
                          <xsl:value-of select ="./p:blipFill/a:blip/@r:embed"/>
                        </xsl:variable>
                        <xsl:variable name="slideRel">
                          <xsl:value-of select="concat('ppt/slideMasters/_rels/',$slideMasterPath,'.rels')"/>
                        </xsl:variable>
                        <xsl:variable name ="sourceFile">
                          <xsl:for-each select ="key('Part', $slideRel)//node()[@Id = $imageId]">
                            <xsl:value-of select ="@Target"/>
                          </xsl:for-each>
                        </xsl:variable >
                        <xsl:variable name="var_picWidth">
                          <xsl:value-of select="concat('ppt',substring-after($sourceFile,'..'))"/>
                        </xsl:variable>
                        <xsl:if test="string-length(substring-after($sourceFile,'..')) > 0">
                        <xsl:if test="./p:blipFill/a:srcRect/@l or ./p:blipFill/a:srcRect/@r or ./p:blipFill/a:srcRect/@t or ./p:blipFill/a:srcRect/@b ">
                          <xsl:variable name="left">
                            <xsl:if test="p:blipFill/a:srcRect/@l">
                              <xsl:value-of select="p:blipFill/a:srcRect/@l"/>
                            </xsl:if>
                            <xsl:if test="not(p:blipFill/a:srcRect/@l)">
                              <xsl:value-of select="0"/>
                            </xsl:if>
                          </xsl:variable>
                          <xsl:variable name="right">
                            <xsl:if test="p:blipFill/a:srcRect/@r">
                              <xsl:value-of select="p:blipFill/a:srcRect/@r"/>
                            </xsl:if>
                            <xsl:if test="not(p:blipFill/a:srcRect/@r)">
                              <xsl:value-of select="0"/>
                            </xsl:if>
                          </xsl:variable>
                          <xsl:variable name="top">
                            <xsl:if test="p:blipFill/a:srcRect/@t">
                              <xsl:value-of select="p:blipFill/a:srcRect/@t"/>
                            </xsl:if>
                            <xsl:if test="not(p:blipFill/a:srcRect/@t)">
                              <xsl:value-of select="0"/>
                            </xsl:if>
                          </xsl:variable>
                          <xsl:variable name="bottom">
                            <xsl:if test="p:blipFill/a:srcRect/@b">
                              <xsl:value-of select="p:blipFill/a:srcRect/@b"/>
                            </xsl:if>
                            <xsl:if test="not(p:blipFill/a:srcRect/@b)">
                              <xsl:value-of select="0"/>
                            </xsl:if>
                          </xsl:variable>
                          <xsl:attribute name ="fo:clip">
                            <xsl:variable name="temp">
                              <xsl:value-of select="concat('image-props:',$var_picWidth,':',$left,':',$right,':',$top,':',$bottom)"/>
                            </xsl:variable>
                            <xsl:value-of select="$temp"/>
                          </xsl:attribute>
                        </xsl:if>
                      </xsl:if>
                        </xsl:if>
                      <!--Added by sanjay for master style-->
                      <xsl:if test="p:blipFill/a:blip/a:lum">
                        <xsl:for-each select="p:blipFill/a:blip/a:lum">
                          <xsl:call-template name="BrightContrast"/>
                        </xsl:for-each>
                      </xsl:if>
                    </style:graphic-properties >
                  </style:style>
                </xsl:for-each>
             </xsl:when>
               <xsl:when test="name()='p:grpSp'">
              <xsl:variable name="var_pos" select="position()"/>
                   <xsl:for-each select=".">
                     <xsl:call-template name="tmpSMGroupStyle">
                       <xsl:with-param name="var_pos" select="$var_pos"/>
                       <xsl:with-param name="slideMasterName" select="$slideMasterName"/>
                     </xsl:call-template>
                   </xsl:for-each>
                 </xsl:when>
             </xsl:choose>
           </xsl:for-each>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="tmpSMGroupStyle">
    <xsl:param name="slideMasterName"/>
    <xsl:param name="var_pos"/>
              <xsl:for-each select="node()">
                <xsl:choose>
                  <xsl:when test="name()='p:sp'">
                     <xsl:variable name="pos" select="position()"/>
                    <xsl:if test="not(p:nvSpPr/p:nvPr/p:ph)">
                    <xsl:variable  name ="GraphicId">
                      <xsl:value-of select ="concat('SMgrp',$slideMasterName,'gr',$var_pos,'-', $pos)"/>
                    </xsl:variable>
                    <xsl:variable name ="ParaId">
                      <xsl:value-of select ="concat('SMgrp',$slideMasterName,'PARA',$var_pos,'-', $pos)"/>
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
                          <xsl:with-param name="FileType" select="$slideMasterName"/>
                          <xsl:with-param name="flagGroup" select="'True'"/>
                          <xsl:with-param name="SMName" select="concat($slideMasterName,'.xml')"/>
                        </xsl:call-template>

                        <!--LINE COLOR-->
                        <xsl:call-template name ="LineColor">
                          <xsl:with-param name="SMName" select="concat($slideMasterName,'.xml')"/>
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
                      <xsl:with-param name="TypeId" select="$slideMasterName"/>
                      <xsl:with-param name="flagTextBox" select="$flagTextBox"/>
                    </xsl:call-template>
                  </xsl:if>
                </xsl:when>
        <xsl:when test="name()='p:pic'">
          <xsl:variable name="pos" select="position()"/>
              <xsl:variable  name ="GraphicId">
                <xsl:value-of select ="concat('SMgrp',$slideMasterName,'Picture',$var_pos,'-', $pos,'gr')"/>
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
                       <!--Added by sanjay-->
                       <xsl:if test="p:blipFill/a:blip/a:lum">
                         <xsl:for-each select="p:blipFill/a:blip/a:lum">
                           <xsl:call-template name="BrightContrast"/>
                         </xsl:for-each>
                       </xsl:if>
                  <!--Image Cropping-->
                  <xsl:call-template name="tmpImageCropping">
                    <xsl:with-param name="slideRel" select="concat('ppt/slideMasters/_rels',$slideMasterName,'.xml.rels')"/>
                  </xsl:call-template>
                  <!--TEXT ALIGNMENT-->
                  <xsl:call-template name ="TextLayout" />
                </style:graphic-properties >
              </style:style>
            </xsl:when>
                  <xsl:when test="name()='p:cxnSp'">
                      <xsl:variable name="pos" select="position()"/>
                    <xsl:for-each select=".">
                      <xsl:variable  name ="GraphicId">
                        <xsl:value-of select ="concat('SMgrp',$slideMasterName,'grLine',$var_pos,'-', $pos)"/>
                      </xsl:variable>
                      <xsl:variable name ="ParaId">
                        <xsl:value-of select ="concat('SMgrp',$slideMasterName,'PARA',$var_pos,'-', $pos)"/>
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
                            <xsl:with-param name="SMName" select="concat($slideMasterName,'.xml')"/>
                          </xsl:call-template>
                          <!--LINE COLOR-->
                          <xsl:call-template name ="LineColor">
                            <xsl:with-param name="SMName" select="concat($slideMasterName,'.xml')"/>
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
                        <xsl:with-param name="TypeId" select="$slideMasterName"/>
                      </xsl:call-template>
                    </xsl:for-each>
                  </xsl:when>
        <xsl:when test="name()='p:grpSp'">
          <xsl:variable name="pos" select="position()"/>
          <xsl:call-template name="tmpSMGroupStyle">
            <xsl:with-param name="slideMasterName" select="$slideMasterName"/>
            <xsl:with-param name="var_pos" select="concat($var_pos,'-',$pos)"/>
          </xsl:call-template>
          </xsl:when>
             </xsl:choose>
           </xsl:for-each>
       </xsl:template>
  <xsl:template name="OutlineNumbering">
    <xsl:for-each select=".">
      <xsl:if test ="a:buAutoNum">
        <xsl:if test ="a:buAutoNum/@type[contains(.,'arabicPeriod')]">
          <xsl:attribute name ="style:num-format" >
            <xsl:value-of  select ="'1'"/>
          </xsl:attribute>
          <xsl:attribute name ="style:num-suffix">
            <xsl:value-of select ="'.'"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test ="a:buAutoNum/@type[contains(.,'arabicParenR')]">
          <xsl:attribute name ="style:num-format" >
            <xsl:value-of  select ="'1'"/>
          </xsl:attribute >
          <xsl:attribute name ="style:num-suffix">
            <xsl:value-of select ="')'"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test ="a:buAutoNum/@type[contains(.,'arabicParenBoth')]">
          <xsl:attribute name ="style:num-format" >
            <xsl:value-of  select ="'1'"/>
          </xsl:attribute >
          <xsl:attribute name ="style:num-suffix">
            <xsl:value-of select ="')'"/>
          </xsl:attribute>
          <xsl:attribute name ="style:num-prefix">
            <xsl:value-of select ="'('"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test ="a:buAutoNum/@type[contains(.,'alphaUcPeriod')]">
          <xsl:attribute name ="style:num-format" >
            <xsl:value-of  select ="'A'"/>
          </xsl:attribute >
          <xsl:attribute name ="style:num-suffix">
            <xsl:value-of select ="'.'"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test ="a:buAutoNum/@type[contains(.,'alphaUcParenR')]">
          <xsl:attribute name ="style:num-format" >
            <xsl:value-of  select ="'A'"/>
          </xsl:attribute >
          <xsl:attribute name ="style:num-suffix">
            <xsl:value-of select ="')'"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test ="a:buAutoNum/@type[contains(.,'alphaUcParenBoth')]">
          <xsl:attribute name ="style:num-format" >
            <xsl:value-of  select ="'A'"/>
          </xsl:attribute >
          <xsl:attribute name ="style:num-suffix">
            <xsl:value-of select ="')'"/>
          </xsl:attribute>
          <xsl:attribute name ="style:num-prefix">
            <xsl:value-of select ="'('"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test ="a:buAutoNum/@type[contains(.,'alphaLcPeriod')]">
          <xsl:attribute name ="style:num-format" >
            <xsl:value-of  select ="'a'"/>
          </xsl:attribute >
          <xsl:attribute name ="style:num-suffix">
            <xsl:value-of select ="'.'"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test ="a:buAutoNum/@type[contains(.,'alphaLcParenR')]">
          <xsl:attribute name ="style:num-format" >
            <xsl:value-of  select ="'a'"/>
          </xsl:attribute >
          <xsl:attribute name ="style:num-suffix">
            <xsl:value-of select ="')'"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test ="a:buAutoNum/@type[contains(.,'alphaLcParenBoth')]">
          <xsl:attribute name ="style:num-format" >
            <xsl:value-of  select ="'a'"/>
          </xsl:attribute >
          <xsl:attribute name ="style:num-suffix">
            <xsl:value-of select ="')'"/>
          </xsl:attribute>
          <xsl:attribute name ="style:num-prefix">
            <xsl:value-of select ="'('"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test ="a:buAutoNum/@type[contains(.,'romanUcPeriod')]">
          <xsl:attribute name ="style:num-format" >
            <xsl:value-of  select ="'I'"/>
          </xsl:attribute >
          <xsl:attribute name ="style:num-suffix">
            <xsl:value-of select ="'.'"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test ="a:buAutoNum/@type[contains(.,'romanLcPeriod')]">
          <xsl:attribute name ="style:num-format" >
            <xsl:value-of  select ="'i'"/>
          </xsl:attribute >
          <xsl:attribute name ="style:num-suffix">
            <xsl:value-of select ="'.'"/>
          </xsl:attribute>
          <!-- start at value-->
          <!-- <xsl:if test ="@startAt">
              <xsl:attribute name ="text:start-value">
                <xsl:value-of select ="a:buAutoNum[@startAt]"/>
              </xsl:attribute>
            </xsl:if>-->
        </xsl:if >
        <xsl:if test="a:buAutoNum/@startAt">
          <xsl:attribute name ="text:start-value">
            <xsl:value-of select ="a:buAutoNum/@startAt"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="not(a:buAutoNum/@startAt)">
          <xsl:attribute name ="text:start-value">
            <xsl:value-of select ="1"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="tmpSMGraphicProperty">
    <xsl:param name="blnSubTitle"/>
    <xsl:param name="SMName"/>
    <xsl:param name="shapePhType"/>
    <xsl:variable name="var_spType">
      <xsl:choose>
        <xsl:when test="contains($shapePhType,'Footer')">
          <xsl:value-of select="'ftr'"/>
        </xsl:when>
        <xsl:when test="contains($shapePhType,'PageNumber')">
          <xsl:value-of select="'sldNum'"/>
        </xsl:when>
        <xsl:when test="contains($shapePhType,'DateTime')">
          <xsl:value-of select="'dt'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$shapePhType"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:for-each select=".">
    <xsl:choose>
      <xsl:when test ="p:spPr/a:noFill">
        <xsl:attribute name ="draw:fill">
          <xsl:value-of select="'none'" />
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="./p:spPr/a:solidFill">
         <xsl:for-each select="./p:spPr/a:solidFill">
              <xsl:call-template name="tmpShapeSolidFillColor">
                <xsl:with-param name="SMName" select="$SMName"/>
                </xsl:call-template>
              </xsl:for-each>
       </xsl:when>
      <xsl:when test="p:spPr/a:gradFill">
        <xsl:call-template name="tmpGradFillColor">
          <xsl:with-param name="FileType" select="substring-before($SMName,'.xml')"/>
          <xsl:with-param name="shapePhType" select="$shapePhType"/>
          <xsl:with-param name="SMName" select="$SMName"/>
                  </xsl:call-template>
      </xsl:when>
      <xsl:when test="p:spPr/a:blipFill and p:spPr/a:blipFill/a:blip/@r:embed ">
       <xsl:attribute name="draw:fill-image-name">
          <xsl:value-of select="concat(substring-before($SMName,'.xml'),$var_spType,'Img')"/>
        </xsl:attribute>
        <xsl:for-each select="p:spPr">
        <xsl:call-template name="tmpPictureFillProp"/>
          </xsl:for-each>
      </xsl:when>
      <!--Fill refernce-->
      <xsl:when test ="p:style/a:fillRef">
        <xsl:for-each select="p:style/a:fillRef">
          <xsl:call-template name="tmpShapeSolidFillColor"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="draw:fill">
          <xsl:value-of select="'none'"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
        <xsl:if test ="p:spPr/a:ln">
      <xsl:call-template name="LineColor"/>
      <xsl:call-template name="LineStyle"/>
    </xsl:if>
    <xsl:if test ="not(p:spPr/a:ln)">
      <xsl:attribute name="draw:stroke">
        <xsl:value-of select="'none'"/>
      </xsl:attribute>
    </xsl:if>
     <xsl:for-each select="p:txBody/a:bodyPr">
        <xsl:call-template name="tmpInternalMargin"/>
        <xsl:call-template name="tmpWrapSpAutoFit"/>
        <xsl:call-template name="tmpShapeVerticalAlign"/>
    </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="tmpShapeTextProperty">
    <xsl:param name="SLMName"/>
    <xsl:param name="LayoutFileName"/>
    <xsl:param name="spType"/>
    <xsl:param name="index"/>
    <xsl:param name ="DefFont"/>
    <xsl:param name ="fontType"/>
    <xsl:param name ="shapeType"/>

    <xsl:variable name="fontscale">
      <xsl:choose>
        <xsl:when test="p:txBody/a:bodyPr/a:normAutofit/@fontScale">
          <xsl:value-of select="p:txBody/a:bodyPr/a:normAutofit/@fontScale"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'0'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test ="a:defRPr/@sz">
      <xsl:attribute name ="fo:font-size"	>
        <xsl:value-of  select ="concat(format-number(a:defRPr/@sz div 100,'#.##'),'pt')"/>
      </xsl:attribute>
     <xsl:attribute name ="style:font-size-asian">
        <xsl:value-of  select ="concat(format-number(a:defRPr/@sz div 100,'#.##'),'pt')"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test ="a:defRPr/a:latin/@typeface">
          <xsl:attribute name ="fo:font-family">
          <xsl:variable name ="typeFaceVal" select ="a:defRPr/a:latin/@typeface"/>
          <xsl:for-each select ="a:defRPr/a:latin/@typeface">
          <xsl:if test ="$typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt'">
            <xsl:call-template name="slideMasterFontName">
                <xsl:with-param name="fontType" select="$fontType"/>
            <xsl:with-param name="SMName" select="$SLMName"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test ="not($typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt')">
            <xsl:value-of select ="."/>
          </xsl:if>
        </xsl:for-each>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="a:defRPr/a:sym/@typeface">
        <xsl:attribute name ="fo:font-family">
          <xsl:variable name ="typeFaceVal" select ="a:defRPr/a:sym/@typeface"/>
          <xsl:for-each select ="a:defRPr/a:sym/@typeface">
            <xsl:if test ="$typeFaceVal='+mn-sym' or $typeFaceVal='+mj-sym'">
              <xsl:call-template name="slideMasterFontName">
                <xsl:with-param name="fontType" select="$fontType"/>
                <xsl:with-param name="SMName" select="$SLMName"/>
              </xsl:call-template>
            </xsl:if>
            <xsl:if test ="$typeFaceVal='Wingdings'">
              <xsl:value-of  select ="'Arial'"/>
            </xsl:if>
            <xsl:if test ="not($typeFaceVal='+mn-sym' or $typeFaceVal='+mj-sym' or $typeFaceVal='Wingdings')">
              <xsl:value-of select ="."/>
            </xsl:if>
          </xsl:for-each>
        </xsl:attribute >
      </xsl:when>
      <xsl:when test ="a:defRPr/a:cs/@typeface">
        <xsl:attribute name ="fo:font-family">
          <xsl:variable name ="typeFaceVal" select ="a:defRPr/a:cs/@typeface"/>
          <xsl:for-each select ="a:defRPr/a:cs/@typeface">
            <xsl:if test ="$typeFaceVal='+mn-cs' or $typeFaceVal='+mj-cs'">
              <xsl:call-template name="slideMasterFontName">
                <xsl:with-param name="fontType" select="$fontType"/>
                <xsl:with-param name="SMName" select="$SLMName"/>
              </xsl:call-template>
      </xsl:if>
            <xsl:if test ="not($typeFaceVal='+mn-cs' or $typeFaceVal='+mj-cs')">
              <xsl:value-of select ="."/>
            </xsl:if>
          </xsl:for-each>
        </xsl:attribute >
      </xsl:when>

    </xsl:choose>
   
     <xsl:if test ="not(./a:defRPr/a:latin/@typeface) and not(./a:defRPr/a:cs/@typeface) and not(./a:defRPr/a:sym/@typeface)">
        <xsl:attribute name ="fo:font-family">
        <xsl:call-template name="slideMasterFontName">
          <xsl:with-param name="fontType">
            <xsl:value-of select="'minor'"/>
          </xsl:with-param>
          <xsl:with-param name="SMName" select="$SLMName"/>
        </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
    <!-- strike style:text-line-through-style-->
    <xsl:if test ="./a:defRPr/@strike">
      <xsl:if test ="./a:defRPr[@strike!='noStrike']">
      <xsl:attribute name ="style:text-line-through-style">
        <xsl:value-of select ="'solid'"/>
      </xsl:attribute>
      <xsl:choose >
        <xsl:when test ="./a:defRPr/@strike='dblStrike'">
          <xsl:attribute name ="style:text-line-through-type">
            <xsl:value-of select ="'double'"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test ="./a:defRPr/@strike='sngStrike'">
          <xsl:attribute name ="style:text-line-through-type">
            <xsl:value-of select ="'single'"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
    </xsl:if>
	  <!--SuperScript and SubScript for Text added by Mathi on 1st Aug 2007-->
	  <xsl:if test="./a:defRPr/@baseline">
		  <xsl:variable name="baseData">
			  <xsl:value-of select="./a:defRPr/@baseline"/>
		  </xsl:variable>
      <xsl:variable name="subSuperScriptValue">
        <xsl:value-of select="number(format-number($baseData div 1000,'#'))"/>
				  </xsl:variable>

      <xsl:call-template name="tmpSubSuperScript">
        <xsl:with-param name="baseline" select="$baseData"/>
        <xsl:with-param name="subSuperScriptValue" select="$subSuperScriptValue"/>
      </xsl:call-template>
	  </xsl:if>
	  
    <!-- Kening Property-->
    <xsl:if test ="./a:defRPr/@kern">
      <xsl:choose >
        <xsl:when test ="./a:defRPr/@kern = '0'">
          <xsl:attribute name ="style:letter-kerning">
            <xsl:value-of select ="'false'"/>
          </xsl:attribute >
        </xsl:when >
        <xsl:when test ="format-number(./a:defRPr/@kern,'#.##') &gt; 0">
          <xsl:attribute name ="style:letter-kerning">
            <xsl:value-of select ="'true'"/>
          </xsl:attribute >
        </xsl:when >
      </xsl:choose>
    </xsl:if >
    <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:choose>
      <xsl:when test ="./a:defRPr/a:solidFill/a:srgbClr/@val">
      <xsl:attribute name ="fo:color">
        <xsl:value-of select ="translate(concat('#',./a:defRPr/a:solidFill/a:srgbClr/@val),$ucletters,$lcletters)"/>
      </xsl:attribute>
      </xsl:when>
      <xsl:when test ="./a:defRPr/a:solidFill/a:schemeClr/@val">
           <xsl:variable name="var_schmClrVal" select="./a:defRPr/a:solidFill/a:schemeClr/@val"/>
                  <xsl:attribute name ="fo:color">
                   <xsl:call-template name ="getColorCode">
          <xsl:with-param name ="color">
                  <xsl:choose>
                    <xsl:when test="$shapeType='PageNo' or $shapeType='DateTime' or $shapeType='Footer' ">
                      <xsl:for-each select="key('Part', concat('ppt/slideMasters/',$SLMName))//p:clrMap">
                        <xsl:call-template name="tmpThemeClr">
                          <xsl:with-param name="ClrMap" select="$var_schmClrVal"/>
                        </xsl:call-template>
                      </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                  <xsl:for-each select="/child::node()/p:clrMap">
              <xsl:call-template name="tmpThemeClr">
                <xsl:with-param name="ClrMap" select="$var_schmClrVal"/>
              </xsl:call-template>
            </xsl:for-each>
                    </xsl:otherwise>
                  </xsl:choose>

          </xsl:with-param>
          <xsl:with-param name ="lumMod">
            <xsl:value-of select="./a:defRPr/a:solidFill/a:schemeClr/a:lumMod/@val"/>
          </xsl:with-param>
          <xsl:with-param name ="lumOff">
            <xsl:value-of select="./a:defRPr/a:solidFill/a:schemeClr/a:lumOff/@val"/>
          </xsl:with-param>
                     <xsl:with-param name ="SMName" select="$SLMName"/>
        </xsl:call-template>
                 </xsl:attribute>
            </xsl:when>
      <xsl:when test ="./a:defRPr/a:gradFill">
        <xsl:for-each select="./a:defRPr/a:gradFill/a:gsLst/child::node()[1]">
          <xsl:if test="name()='a:gs'">
            <xsl:choose>
              <xsl:when test="a:srgbClr/@val">
                <xsl:attribute name="fo:color">
                  <xsl:value-of select="concat('#',a:srgbClr/@val)" />
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="a:schemeClr/@val">
                <xsl:attribute name="fo:color">
                  <xsl:call-template name="getColorCode">
                    <xsl:with-param name="color">
                      <xsl:value-of select="a:schemeClr/@val" />
                    </xsl:with-param>
                    <xsl:with-param name="lumMod">
                      <xsl:value-of select="a:schemeClr/a:lumMod/@val" />
                    </xsl:with-param>
                    <xsl:with-param name="lumOff">
                      <xsl:value-of select="a:schemeClr/a:lumOff/@val" />
                    </xsl:with-param>
                    <xsl:with-param name ="SMName" select="$SLMName"/>
                  </xsl:call-template>
                </xsl:attribute>

              </xsl:when>
            </xsl:choose>
        </xsl:if>  
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="./a:defRPr/@b='1'">
        <xsl:attribute name ="fo:font-weight">
          <xsl:value-of select ="'bold'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name ="fo:font-weight">
          <xsl:value-of select ="'normal'"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <!--UnderLine-->
    <xsl:if test ="./a:defRPr/@u">
      <xsl:for-each select ="./a:defRPr">
        <xsl:call-template name="tmpUnderLine">
          <xsl:with-param name="u" select="@u"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if >
    <xsl:if test ="not(./a:defRPr/@u)">
      <xsl:attribute name ="style:text-underline-style">
        <xsl:value-of select ="'none'"/>
      </xsl:attribute>
    </xsl:if>
    <!-- Italic-->
    <xsl:attribute name ="fo:font-style">
      <xsl:if test ="./a:defRPr/@i='1'">
        <xsl:value-of select ="'italic'"/>
      </xsl:if >
      <xsl:if test ="./a:defRPr/@i='0'">
        <xsl:value-of select ="'normal'"/>
      </xsl:if >
      <xsl:if test ="not(./a:defRPr/@i)">
        <xsl:value-of select ="'normal'"/>
      </xsl:if >
    </xsl:attribute>
    <!-- Character Spacing -->
    <xsl:if test ="./a:defRPr/@spc">
      <xsl:attribute name ="fo:letter-spacing">
        <xsl:variable name="length" select="./a:defRPr/@spc" />
        <xsl:value-of select="concat(format-number($length * 2.54 div 7200,'#.###'),'cm')"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
   <xsl:template name="tmpSMOutlineStyle">
    <xsl:param name="prm_SMName"/>
    <xsl:param name="SMName"/>
    <style:graphic-properties draw:stroke="none" draw:fill="none">
      <xsl:call-template name="tmpSMGraphicProperty">
        <xsl:with-param name="SMName" select="$prm_SMName"/>
        <xsl:with-param name="shapePhType" select="'outline'"/>
      </xsl:call-template>
      <text:list-style>
        <xsl:for-each select ="./p:txBody/a:p">
          <xsl:call-template name="tmpSMListLevelStyle">
            <xsl:with-param name="SlideMasterFile">
              <xsl:value-of select="$prm_SMName"/>
            </xsl:with-param>
            <xsl:with-param name="levelNo">
              <xsl:value-of select="./a:pPr/@lvl"/>
            </xsl:with-param>
            <xsl:with-param name="pos">
              <xsl:value-of select="position()"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
        <xsl:variable name="var_MaxOutNumber">
          <xsl:for-each select="./p:txBody/a:p/a:pPr/@lvl">
            <xsl:sort data-type="number" order="descending"/>
            <xsl:if test="position()=1">
              <xsl:value-of select="."/>
            </xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$var_MaxOutNumber='0'">
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'0'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'2'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'0'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'3'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'0'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'4'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'0'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'5'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'0'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'6'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'0'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'7'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'0'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'8'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'0'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'9'"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$var_MaxOutNumber='1'">
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'1'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'3'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'1'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'4'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'1'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'5'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'1'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'6'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'1'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'7'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'1'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'8'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'1'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'9'"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$var_MaxOutNumber='2'">
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'2'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'4'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'2'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'5'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'2'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'6'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'2'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'7'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'2'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'8'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'2'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'9'"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$var_MaxOutNumber='3'">
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'3'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'5'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'3'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'6'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'3'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'7'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'3'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'8'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'3'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'9'"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$var_MaxOutNumber='4'">
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'4'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'6'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'4'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'7'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'4'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'8'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'4'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'9'"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$var_MaxOutNumber='5'">
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'5'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'7'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'5'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'8'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'5'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'9'"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$var_MaxOutNumber='6'">
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'6'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'8'"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'6'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'9'"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$var_MaxOutNumber='7'">
            <xsl:call-template name="tmpSMListLevelStyle">
              <xsl:with-param name="SlideMasterFile">
                <xsl:value-of select="$prm_SMName"/>
              </xsl:with-param>
              <xsl:with-param name="levelNo">
                <xsl:value-of select="'7'"/>
              </xsl:with-param>
              <xsl:with-param name="pos">
                <xsl:value-of select="'9'"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
      </text:list-style>
      <xsl:if test ="p:txBody/a:bodyPr/@vert='vert'">
        <style:paragraph-properties>
          <xsl:attribute name ="style:writing-mode">
            <xsl:value-of select ="'tb-rl'"/>
          </xsl:attribute>
        </style:paragraph-properties>
      </xsl:if>
    </style:graphic-properties>
    <xsl:for-each select ="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl1pPr">
      <xsl:call-template name="Outlines">
        <xsl:with-param name="level">
          <xsl:value-of select="'1'"/>
        </xsl:with-param>
        <xsl:with-param name="SMName" select="$prm_SMName"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="tmpSubtitleOutlineStyle">
    <xsl:param name="slideMasterName"/>
    <xsl:param name="slideMasterPath"/>
    <!-- style for sub-Title-->
    <style:style>
      <xsl:attribute name="style:name">
        <xsl:value-of select="concat($slideMasterName,'-subtitle')"/>
      </xsl:attribute>
      <xsl:attribute name ="style:family">
        <xsl:value-of select ="'presentation'"/>
      </xsl:attribute>
      <xsl:call-template name="tmpSMOutlineStyle">
        <xsl:with-param name="prm_SMName" select="$slideMasterPath"/>
        <xsl:with-param name="SMName" select="concat($slideMasterName,'-subtitle')"/>
      </xsl:call-template>
    </style:style>
    <!-- style for Outline 1-->
    <style:style>
      <xsl:attribute name="style:name">
        <xsl:value-of select="concat($slideMasterName,'-outline1')"/>
      </xsl:attribute>
      <xsl:attribute name ="style:family">
        <xsl:value-of select ="'presentation'"/>
      </xsl:attribute>
      <xsl:call-template name="tmpSMOutlineStyle">
        <xsl:with-param name="prm_SMName" select="$slideMasterPath"/>
        <xsl:with-param name="SMName" select="concat($slideMasterName,'-outline')"/>
      </xsl:call-template>
    </style:style>
    <xsl:variable name="var_MaxOutNumber">
      <xsl:for-each select="./p:txBody/a:p/a:pPr/@lvl">
        <xsl:sort data-type="number" order="descending"/>
        <xsl:if test="position()=1">
          <xsl:value-of select="."/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <!-- style for other Outlines-->
    <xsl:choose>
      <xsl:when test="$var_MaxOutNumber='0'">
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl1pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline2')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline1')"/>
            </xsl:attribute>
            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'2'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl1pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline3')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline2')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'3'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl1pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline4')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline3')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'4'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl1pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline5')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline4')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'5'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl1pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline6')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline5')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'6'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl1pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline7')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline6')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'7'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl1pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline8')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline7')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'8'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl1pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline9')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline8')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'9'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="$var_MaxOutNumber='1'">
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl2pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline2')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline1')"/>
            </xsl:attribute>
            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'2'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl2pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline3')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline2')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'3'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl2pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline4')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline3')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'4'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl2pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline5')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline4')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'5'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl2pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline6')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline5')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'6'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl2pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline7')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline6')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'7'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl2pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline8')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline7')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'8'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl2pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline9')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline8')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'9'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="$var_MaxOutNumber='2'">
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl2pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline2')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline1')"/>
            </xsl:attribute>
            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'2'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl3pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline3')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline2')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'3'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl3pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline4')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline3')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'4'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl3pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline5')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline4')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'5'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl3pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline6')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline5')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'6'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl3pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline7')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline6')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'7'"/>
              </xsl:with-param>
          <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl3pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline8')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline7')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'8'"/>
              </xsl:with-param>
          <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl3pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline9')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline8')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'9'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="$var_MaxOutNumber='3'">
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl2pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline2')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline1')"/>
            </xsl:attribute>
            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'2'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl3pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline3')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline2')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'3'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl4pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline4')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline3')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'4'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl4pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline5')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline4')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'5'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl4pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline6')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline5')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'6'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl4pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline7')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline6')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'7'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl4pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline8')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline7')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'8'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl4pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline9')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline8')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'9'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="$var_MaxOutNumber='4'">
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl2pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline2')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline1')"/>
            </xsl:attribute>
            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'2'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl3pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline3')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline2')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'3'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl4pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline4')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline3')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'4'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl5pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline5')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline4')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'5'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl5pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline6')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline5')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'6'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl5pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline7')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline6')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'7'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl5pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline8')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline7')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'8'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl5pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline9')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline8')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'9'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="$var_MaxOutNumber='5'">
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl2pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline2')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline1')"/>
            </xsl:attribute>
            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'2'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl3pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline3')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline2')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'3'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl4pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline4')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline3')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'4'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl5pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline5')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline4')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'5'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl6pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline6')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline5')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'6'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl6pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline7')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline6')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'7'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl6pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline8')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline7')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'8'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl6pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline9')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline8')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'9'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="$var_MaxOutNumber='6'">
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl2pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline2')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline1')"/>
            </xsl:attribute>
            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'2'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl3pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline3')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline2')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'3'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl4pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline4')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline3')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'4'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl5pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline5')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline4')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'5'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl6pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline6')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline5')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'6'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl7pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline7')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline6')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'7'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl7pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline8')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline7')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'8'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl7pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline9')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline8')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'9'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="$var_MaxOutNumber='7'">
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl2pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline2')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline1')"/>
            </xsl:attribute>
            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'2'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl3pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline3')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline2')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'3'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl4pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline4')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline3')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'4'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl5pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline5')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline4')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'5'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl6pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline6')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline5')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'6'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl7pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline7')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline6')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'7'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl8pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline9')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline8')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'9'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="$var_MaxOutNumber='8'">
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl2pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline2')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline1')"/>
            </xsl:attribute>
            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'2'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl3pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline3')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline2')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'3'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl4pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline4')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline3')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'4'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl5pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline5')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline4')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'5'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl6pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline6')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline5')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'6'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl7pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline7')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline6')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'7'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl8pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline8')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline7')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'8'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
        <xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txStyles/p:bodyStyle/a:lvl9pPr">
          <style:style>
            <xsl:attribute name="style:name">
              <xsl:value-of select="concat($slideMasterName,'-outline9')"/>
            </xsl:attribute>
            <xsl:attribute name ="style:family">
              <xsl:value-of select ="'presentation'"/>
            </xsl:attribute>
            <xsl:attribute name ="style:parent-style-name">
              <xsl:value-of select ="concat($slideMasterName,'-outline8')"/>
            </xsl:attribute>

            <xsl:call-template name="Outlines">
              <xsl:with-param name="level">
                <xsl:value-of select="'9'"/>
              </xsl:with-param>
              <xsl:with-param name="SMName" select="$slideMasterPath"/>
            </xsl:call-template>
          </style:style>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="tmp_drawFrame">
    <xsl:param name="slideMasterName"/>
    <xsl:param name="presentationCls"/>
    <xsl:param name="styleName"/>
    <xsl:attribute name ="presentation:style-name">
      <xsl:value-of select ="concat($slideMasterName,$styleName)"/>
    </xsl:attribute>
    <xsl:call-template name="tmpWriteCordinates"/>
    <xsl:attribute name ="presentation:class">
      <xsl:value-of select="$presentationCls"/>
    </xsl:attribute>
    <xsl:attribute name ="presentation:placeholder">
      <xsl:value-of select="'true'"/>
    </xsl:attribute>
    <xsl:attribute name ="draw:layer">
      <xsl:value-of select="'backgroundobjects'"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="tmpBackImageStyle">
    <xsl:for-each select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:sldIdLst/p:sldId">
      <xsl:variable name ="pageSlide">
        <xsl:value-of select ="concat(concat('ppt/slides/slide',position()),'.xml')"/>
      </xsl:variable>
      <xsl:call-template name="tmpgetBackImage">
        <xsl:with-param name="FilePath" select="$pageSlide"/>
        <xsl:with-param name="FileType" select="'S'"/>
        <xsl:with-param name="FileName" select="concat('slide',position(),'.xml')"/>
      </xsl:call-template>
      </xsl:for-each>
  </xsl:template>
  <!-- Template Added by Vijayeta
           Insert Handout styles
           Date:30th July-->
  <xsl:template name="tmp_handoutDrawFrame">
    <xsl:param name="handoutMasterName"/>
    <xsl:param name="presentationCls"/>
    <xsl:param name="styleName" />
    <xsl:param name="textStyleName"/>
    <xsl:attribute name ="draw:style-name">
      <xsl:value-of select ="$styleName"/>
    </xsl:attribute>
     <xsl:attribute name ="presentation:class">
      <xsl:value-of select="$presentationCls"/>
    </xsl:attribute>
    <xsl:attribute name ="draw:text-style-name">
      <xsl:value-of select="$textStyleName"/>
    </xsl:attribute>
    <xsl:attribute name ="draw:layer">
      <xsl:value-of select="'backgroundobjects'"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name ="insertPageThumbnail">
    <xsl:param name ="noOfSlides"/>
    <xsl:choose>
      <xsl:when test ="$noOfSlides &lt; '6' ">
        <xsl:choose >
          <xsl:when test ="$noOfSlides ='1' or $noOfSlides ='0'">
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="2.794cm" svg:y="4.327cm" >
              <xsl:attribute name ="draw:page-number">
                <xsl:value-of select ="'1'"/>
              </xsl:attribute>
            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="11.176cm" svg:y="4.327cm" >

            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="19.558cm" svg:y="4.327cm" >

            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="2.794cm" svg:y="13.071cm" >

            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="11.176cm" svg:y="13.071cm" >

            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="19.558cm" svg:y="13.071cm">

            </draw:page-thumbnail>
          </xsl:when>
          <xsl:when test ="$noOfSlides ='2'">
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="2.794cm" svg:y="4.327cm" >
              <xsl:attribute name ="draw:page-number">
                <xsl:value-of select ="'1'"/>
              </xsl:attribute>
            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="11.176cm" svg:y="4.327cm" >
              <xsl:attribute name ="draw:page-number">
                <xsl:value-of select ="'2'"/>
              </xsl:attribute>
            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="19.558cm" svg:y="4.327cm" >

            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="2.794cm" svg:y="13.071cm" >

            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="11.176cm" svg:y="13.071cm" >

            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="19.558cm" svg:y="13.071cm">

            </draw:page-thumbnail>
          </xsl:when>
          <xsl:when test ="$noOfSlides ='3'">
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="2.794cm" svg:y="4.327cm" >
              <xsl:attribute name ="draw:page-number">
                <xsl:value-of select ="'1'"/>
              </xsl:attribute>
            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="11.176cm" svg:y="4.327cm" >
              <xsl:attribute name ="draw:page-number">
                <xsl:value-of select ="'2'"/>
              </xsl:attribute>
            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="19.558cm" svg:y="4.327cm" >
              <xsl:attribute name ="draw:page-number">
                <xsl:value-of select ="'3'"/>
              </xsl:attribute>
            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="2.794cm" svg:y="13.071cm" >

            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="11.176cm" svg:y="13.071cm" >

            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="19.558cm" svg:y="13.071cm">

            </draw:page-thumbnail>
          </xsl:when>
          <xsl:when test ="$noOfSlides ='4'">
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="2.794cm" svg:y="4.327cm" >
              <xsl:attribute name ="draw:page-number">
                <xsl:value-of select ="'1'"/>
              </xsl:attribute>
            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="11.176cm" svg:y="4.327cm" >
              <xsl:attribute name ="draw:page-number">
                <xsl:value-of select ="'2'"/>
              </xsl:attribute>
            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="19.558cm" svg:y="4.327cm" >
              <xsl:attribute name ="draw:page-number">
                <xsl:value-of select ="'3'"/>
              </xsl:attribute>
            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="2.794cm" svg:y="13.071cm" >
              <xsl:attribute name ="draw:page-number">
                <xsl:value-of select ="'4'"/>
              </xsl:attribute>
            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="11.176cm" svg:y="13.071cm" >

            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="19.558cm" svg:y="13.071cm">

            </draw:page-thumbnail>
          </xsl:when>
          <xsl:when test ="$noOfSlides ='5'">
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="2.794cm" svg:y="4.327cm" >
              <xsl:attribute name ="draw:page-number">
                <xsl:value-of select ="'1'"/>
              </xsl:attribute>
            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="11.176cm" svg:y="4.327cm" >
              <xsl:attribute name ="draw:page-number">
                <xsl:value-of select ="'2'"/>
              </xsl:attribute>
            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="19.558cm" svg:y="4.327cm" >
              <xsl:attribute name ="draw:page-number">
                <xsl:value-of select ="'3'"/>
              </xsl:attribute>
            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="2.794cm" svg:y="13.071cm" >
              <xsl:attribute name ="draw:page-number">
                <xsl:value-of select ="'4'"/>
              </xsl:attribute>
            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="11.176cm" svg:y="13.071cm" >
              <xsl:attribute name ="draw:page-number">
                <xsl:value-of select ="'5'"/>
              </xsl:attribute>
            </draw:page-thumbnail>
            <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="19.558cm" svg:y="13.071cm">

            </draw:page-thumbnail>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test ="$noOfSlides ='6' or $noOfSlides &gt; '6' ">
        <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="2.794cm" svg:y="4.327cm" >
          <xsl:attribute name ="draw:page-number">
            <xsl:value-of select ="'1'"/>
          </xsl:attribute>
        </draw:page-thumbnail>
        <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="11.176cm" svg:y="4.327cm" >
          <xsl:attribute name ="draw:page-number">
            <xsl:value-of select ="'2'"/>
          </xsl:attribute>
        </draw:page-thumbnail>
        <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="19.558cm" svg:y="4.327cm" >
          <xsl:attribute name ="draw:page-number">
            <xsl:value-of select ="'3'"/>
          </xsl:attribute>
        </draw:page-thumbnail>
        <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="2.794cm" svg:y="13.071cm" >
          <xsl:attribute name ="draw:page-number">
            <xsl:value-of select ="'4'"/>
          </xsl:attribute>
        </draw:page-thumbnail>
        <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="11.176cm" svg:y="13.071cm" >
          <xsl:attribute name ="draw:page-number">
            <xsl:value-of select ="'5'"/>
          </xsl:attribute>
        </draw:page-thumbnail>
        <draw:page-thumbnail draw:layer="backgroundobjects" svg:width="5.587cm" svg:height="4.19cm" svg:x="19.558cm" svg:y="13.071cm">
          <xsl:attribute name ="draw:page-number">
            <xsl:value-of select ="'6'"/>
          </xsl:attribute>
        </draw:page-thumbnail>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- Template Added by Vijayeta
           Insert Handout styles
           Date:30th July-->
  <xsl:template name="tmpHandoutGraphicStyle">
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
        <xsl:variable name ="themeName">
          <xsl:for-each select="key('Part', concat('ppt/handoutMasters/_rels/',$handoutMasterPath,'.rels'))//node()/@Target[contains(.,'theme')]">
            <xsl:value-of  select ="concat('ppt/theme/',substring-after(.,'../theme/'))"/>
          </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="key('Part', concat('ppt/handoutMasters/',$handoutMasterPath))//p:sp">
          <xsl:variable name ="pos" select ="position()"/>
          <xsl:variable name="var_fontScale">
            <xsl:if test="./p:txBody/a:bodyPr/a:normAutofit/@fontScale">
              <xsl:value-of select="./p:txBody/a:bodyPr/a:normAutofit/@fontScale"/>
            </xsl:if>
            <xsl:if test="not(./p:txBody/a:bodyPr/a:normAutofit/@fontScale)">
              <xsl:value-of select="'100000'"/>
            </xsl:if>
          </xsl:variable>
          <xsl:variable name ="DefFont">
            <xsl:for-each select ="key('Part', $themeName)/a:theme/a:themeElements/a:fontScheme
						/a:majorFont/a:latin/@typeface">
              <xsl:value-of select ="."/>
            </xsl:for-each>
          </xsl:variable>
          <xsl:choose >
            <xsl:when test ="p:nvSpPr/p:nvPr/p:ph/@type='hdr' or p:nvSpPr/p:nvPr/p:ph/@type='dt'">
              <style:style style:family="graphic" style:parent-style-name="standard">
                <xsl:attribute name ="style:name">
                  <xsl:value-of select ="concat('grHeaderDateTime',$pos)"/>
                </xsl:attribute >
                <style:graphic-properties draw:stroke="none" draw:fill="none"  draw:auto-grow-height="false">
                  <xsl:call-template name="tmpSlideGrahicProp">
                    <xsl:with-param name="FileType" select="$handoutMasterName"/>
                    <xsl:with-param name="shapePhType">
                      <xsl:choose>
                        <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='hdr'">
                          <xsl:value-of select="'Header'"/>
                        </xsl:when>
                        <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='dt'">
                          <xsl:value-of select="'DateTime'"/>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="spType">
                      <xsl:value-of select="p:nvSpPr/p:nvPr/p:ph/@type"/>
                    </xsl:with-param>
                  </xsl:call-template>
                </style:graphic-properties >
              </style:style>
              <xsl:if test ="p:nvSpPr/p:nvPr/p:ph/@type='hdr'">
                <style:style style:family="paragraph">
                  <xsl:attribute name ="style:name">
                    <xsl:value-of select ="concat('paraHeaderFooter',$pos)"/>
                  </xsl:attribute>
                  <style:paragraph-properties>
                    <xsl:call-template name="tmpHMParagraphStyle"/>
                  </style:paragraph-properties>
                  <style:text-properties style:font-charset="x-symbol">
                    <xsl:attribute name ="fo:font-size">
                      <xsl:value-of select ="concat(format-number(./p:txBody/a:lstStyle/a:lvl1pPr/a:defRPr/@sz div 100, '#.##'), 'pt')"/>
                    </xsl:attribute>
                    <xsl:attribute name ="style:font-size-asian">
                      <xsl:value-of select ="concat(format-number(./p:txBody/a:lstStyle/a:lvl1pPr/a:defRPr/@sz div 100, '#.##'), 'pt')"/>
                    </xsl:attribute>
                    <xsl:attribute name ="style:font-size-complex">
                      <xsl:value-of select ="concat(format-number(./p:txBody/a:lstStyle/a:lvl1pPr/a:defRPr/@sz div 100, '#.##'), 'pt')"/>
                    </xsl:attribute>
                  </style:text-properties>
                </style:style>
                <!-- Text properties-->
                <xsl:if test ="./p:txBody/a:p/a:r">
                  <style:style style:name="{generate-id()}" style:family="text">
                    <style:text-properties style:font-charset="x-symbol">
                      <xsl:for-each select ="./p:txBody/a:p/a:r">
                        <xsl:call-template name="tmpHandOutTextProperty">
                          <xsl:with-param name="DefFont" select="$DefFont"/>
                          <xsl:with-param name="fontscale" select="$var_fontScale"/>
                        </xsl:call-template>
                      </xsl:for-each>
                    </style:text-properties>
                  </style:style>
                </xsl:if>
              </xsl:if>
              <xsl:if test ="p:nvSpPr/p:nvPr/p:ph/@type='dt'">
                <style:style style:family="paragraph">
                  <xsl:attribute name ="style:name">
                    <xsl:value-of select ="concat('paraDateTimePageNum',$pos)"/>
                  </xsl:attribute>
                  <style:paragraph-properties fo:text-align="end" >
                    <xsl:call-template name="tmpHMParagraphStyle"/>
                  </style:paragraph-properties>
                  <style:text-properties style:font-charset="x-symbol">
                    <xsl:attribute name ="fo:font-size">
                      <xsl:value-of select ="concat(format-number(./p:txBody/a:lstStyle/a:lvl1pPr/a:defRPr/@sz div 100, '#.##'), 'pt')"/>
                    </xsl:attribute>
                    <xsl:attribute name ="style:font-size-asian">
                      <xsl:value-of select ="concat(format-number(./p:txBody/a:lstStyle/a:lvl1pPr/a:defRPr/@sz div 100, '#.##'), 'pt')"/>
                    </xsl:attribute>
                    <xsl:attribute name ="style:font-size-complex">
                      <xsl:value-of select ="concat(format-number(./p:txBody/a:lstStyle/a:lvl1pPr/a:defRPr/@sz div 100, '#.##'), 'pt')"/>
                    </xsl:attribute>
                  </style:text-properties>
                </style:style>
                <!-- Text properties-->
                <xsl:if test ="./p:txBody/a:p/a:r">
                  <style:style style:name="{generate-id()}" style:family="text">
                    <style:text-properties style:font-charset="x-symbol">
                      <xsl:for-each select ="./p:txBody/a:p/a:r">
                        <xsl:call-template name="tmpHandOutTextProperty">
                          <xsl:with-param name="DefFont" select="$DefFont"/>
                          <xsl:with-param name="fontscale" select="$var_fontScale"/>
                        </xsl:call-template>
                      </xsl:for-each>
                    </style:text-properties>
                  </style:style>
                </xsl:if>
              </xsl:if>
            </xsl:when>
            <xsl:when test ="p:nvSpPr/p:nvPr/p:ph/@type='ftr' or p:nvSpPr/p:nvPr/p:ph/@type='sldNum'">
              <style:style style:family="graphic" style:parent-style-name="standard">
                <xsl:attribute name ="style:name">
                  <xsl:value-of select ="concat('grFooterPageNum',$pos)"/>
                </xsl:attribute >
                <style:graphic-properties draw:stroke="none" draw:fill="none" draw:auto-grow-height="false" draw:textarea-vertical-align="bottom">
                  <xsl:call-template name="tmpSlideGrahicProp">
                    <xsl:with-param name="FileType" select="$handoutMasterName"/>
                    <xsl:with-param name="shapePhType">
                      <xsl:choose>
                        <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='ftr'">
                          <xsl:value-of select="'Footer'"/>
                        </xsl:when>
                        <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='sldNum'">
                          <xsl:value-of select="'PageNumber'"/>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="spType">
                      <xsl:value-of select="p:nvSpPr/p:nvPr/p:ph/@type"/>
                    </xsl:with-param>
                  </xsl:call-template>
                </style:graphic-properties >
              </style:style>
              <xsl:if test ="p:nvSpPr/p:nvPr/p:ph/@type='sldNum'">
                <style:style style:family="paragraph">
                  <xsl:attribute name ="style:name">
                    <xsl:value-of select ="concat('paraDateTimePageNum',$pos)"/>
                  </xsl:attribute>
                  <style:paragraph-properties fo:text-align="end" >
                    <xsl:call-template name="tmpHMParagraphStyle"/>
                  </style:paragraph-properties>
                  <style:text-properties style:font-charset="x-symbol">
                    <xsl:attribute name ="fo:font-size">
                      <xsl:value-of select ="concat(format-number(./p:txBody/a:lstStyle/a:lvl1pPr/a:defRPr/@sz div 100, '#.##'), 'pt')"/>
                    </xsl:attribute>
                    <xsl:attribute name ="style:font-size-asian">
                      <xsl:value-of select ="concat(format-number(./p:txBody/a:lstStyle/a:lvl1pPr/a:defRPr/@sz div 100, '#.##'), 'pt')"/>
                    </xsl:attribute>
                    <xsl:attribute name ="style:font-size-complex">
                      <xsl:value-of select ="concat(format-number(./p:txBody/a:lstStyle/a:lvl1pPr/a:defRPr/@sz div 100, '#.##'), 'pt')"/>
                    </xsl:attribute>
                  </style:text-properties>
                </style:style>
                <!-- Text properties-->
                <xsl:if test ="./p:txBody/a:p/a:r">
                  <style:style style:name="{generate-id()}" style:family="text">
                    <style:text-properties style:font-charset="x-symbol">
                      <xsl:for-each select ="./p:txBody/a:p/a:r">
                        <xsl:call-template name="tmpHandOutTextProperty">
                          <xsl:with-param name="DefFont" select="$DefFont"/>
                          <xsl:with-param name="fontscale" select="$var_fontScale"/>
                        </xsl:call-template>
                      </xsl:for-each>
                    </style:text-properties>
                  </style:style>
                </xsl:if>
              </xsl:if>
              <xsl:if test ="p:nvSpPr/p:nvPr/p:ph/@type='ftr' ">
                <style:style style:family="paragraph">
                  <xsl:attribute name ="style:name">
                    <xsl:value-of select ="concat('paraHeaderFooter',$pos)"/>
                  </xsl:attribute>
                  <style:paragraph-properties>
                    <xsl:call-template name="tmpHMParagraphStyle"/>
                  </style:paragraph-properties>
                  <style:text-properties style:font-charset="x-symbol">
                    <xsl:attribute name ="fo:font-size">
                      <xsl:value-of select ="concat(format-number(./p:txBody/a:lstStyle/a:lvl1pPr/a:defRPr/@sz div 100, '#.##'), 'pt')"/>
                    </xsl:attribute>
                    <xsl:attribute name ="style:font-size-asian">
                      <xsl:value-of select ="concat(format-number(./p:txBody/a:lstStyle/a:lvl1pPr/a:defRPr/@sz div 100, '#.##'), 'pt')"/>
                    </xsl:attribute>
                    <xsl:attribute name ="style:font-size-complex">
                      <xsl:value-of select ="concat(format-number(./p:txBody/a:lstStyle/a:lvl1pPr/a:defRPr/@sz div 100, '#.##'), 'pt')"/>
                    </xsl:attribute>
                  </style:text-properties>
                </style:style>
                <!-- Text properties-->
                <xsl:if test ="./p:txBody/a:p/a:r">
                  <style:style style:name="{generate-id()}" style:family="text">
                    <style:text-properties style:font-charset="x-symbol">
                      <xsl:for-each select ="./p:txBody/a:p/a:r">
                        <xsl:call-template name="tmpHandOutTextProperty">
                          <xsl:with-param name="DefFont" select="$DefFont"/>
                          <xsl:with-param name="fontscale" select="$var_fontScale"/>
                        </xsl:call-template>
                      </xsl:for-each>
                    </style:text-properties>
                  </style:style>
                </xsl:if>
              </xsl:if>
            </xsl:when>
            <xsl:when test = "not(p:nvSpPr/p:nvPr/p:ph/@type) and not(p:nvSpPr/p:nvPr/p:ph/@idx)">
              <!--Generate graphic properties ID-->
              <xsl:variable  name ="GraphicId">
                <xsl:value-of select ="concat($handoutMasterName,concat('gr',position()))"/>
              </xsl:variable>
              <xsl:variable name ="ParaId">
                <xsl:value-of select ="concat($handoutMasterName ,concat('PARA',position()))"/>
              </xsl:variable>
              <style:style style:family="graphic" style:parent-style-name="standard">
                <xsl:attribute name ="style:name">
                  <xsl:value-of select ="$GraphicId"/>
                </xsl:attribute >
                <style:graphic-properties>

                  <!--FILL-->
                  <xsl:call-template name ="Fill" />

                  <!--LINE COLOR-->
                  <xsl:call-template name ="LineColor" />

                  <!--LINE STYLE-->
                  <xsl:call-template name ="LineStyle"/>

                  <!--TEXT ALIGNMENT-->
                  <xsl:call-template name ="TextLayout" />

                </style:graphic-properties >
              </style:style>
              <xsl:call-template name="tmpShapeTextProcess">
                <xsl:with-param name="ParaId" select="$ParaId"/>
              </xsl:call-template>
            </xsl:when >
          </xsl:choose>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each >
  </xsl:template>
  <!-- Template for BackGround colour, HandoutMaster-->
  <xsl:template name ="getHandOutBg">
    <xsl:choose>
      <xsl:when test="p:spPr/a:solidFill/a:srgbClr">
        <xsl:attribute name="draw:fill-color">
          <xsl:value-of select="concat('#',p:spPr/a:solidFill/a:srgbClr/@val)"/>
        </xsl:attribute>
        <xsl:attribute name="draw:fill">
          <xsl:value-of select="'solid'"/>
        </xsl:attribute>
      </xsl:when>
    <xsl:when test="p:spPr/a:solidFill/a:schemeClr">
        <xsl:attribute name="draw:fill-color">
          <xsl:call-template name ="getColorCode">
            <xsl:with-param name ="color">
        <xsl:call-template name="tmpThemeClr_Background">
                <xsl:with-param name="ClrMap" select="p:spPr/a:solidFill/a:schemeClr/@val"/>
              </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name ="lumMod">
              <xsl:value-of select="p:spPr/a:solidFill/a:schemeClr/a:lumMod/@val" />
            </xsl:with-param>
            <xsl:with-param name ="lumOff">
              <xsl:value-of select="p:spPr/a:solidFill/a:schemeClr/a:lumOff/@val" />
            </xsl:with-param>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="draw:fill">
          <xsl:value-of select="'solid'"/>
        </xsl:attribute>
      </xsl:when>
    <xsl:otherwise>
        <xsl:attribute name="draw:fill-color">
          <xsl:value-of select="'#FFFFFF'"/>
        </xsl:attribute>
        <xsl:attribute name="draw:fill">
          <xsl:value-of select="'solid'"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Hand out Common Templates-->
  <xsl:template name="tmpHMParagraphStyle">
    <!--Text alignment-->
    <xsl:if test ="./p:txBody/a:p/a:pPr/@algn">
      <xsl:attribute name ="fo:text-align">
        <xsl:choose>
          <!-- Center Alignment-->
          <xsl:when test ="./p:txBody/a:p/a:pPr/@algn ='ctr'">
            <xsl:value-of select ="'center'"/>
          </xsl:when>
          <!-- Right Alignment-->
          <xsl:when test ="./p:txBody/a:p/a:pPr/@algn ='r'">
            <xsl:value-of select ="'end'"/>
          </xsl:when>
          <!-- Left Alignment-->
          <xsl:when test ="./p:txBody/a:p/a:pPr/@algn ='l'">
            <xsl:value-of select ="'start'"/>
          </xsl:when>
          <!-- Added by lohith - for fix 1737161-->
          <xsl:when test ="./p:txBody/a:p/a:pPr/@algn ='just'">
            <xsl:value-of select ="'justify'"/>
          </xsl:when>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if >
    <!-- Convert Laeft margin of the paragraph-->
    <xsl:if test ="./p:txBody/a:p/a:pPr/@marL">
      <xsl:attribute name ="fo:margin-left">
        <xsl:value-of select="concat(format-number( ./p:txBody/a:p/a:pPr/@marL div 360000, '#.##'), 'cm')"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test ="./p:txBody/a:p/a:pPr/@marR">
      <xsl:attribute name ="fo:margin-right">
        <xsl:value-of select="concat(format-number(./p:txBody/a:p/a:pPr/@marR div 360000, '#.##'), 'cm')"/>
      </xsl:attribute>
    </xsl:if>
    <!--<xsl:if test ="./@indent">
      <xsl:attribute name ="fo:text-indent">
        <xsl:value-of select="concat(format-number(./@indent div 360000, '#.##'), 'cm')"/>
      </xsl:attribute>
    </xsl:if >-->
    <xsl:if test ="./p:txBody/a:lstStyle/a:lvl1pPr/a:defRPr/@sz">
      <xsl:variable name="var_fontsize">
        <xsl:value-of select="./p:txBody/a:lstStyle/a:lvl1pPr/a:defRPr/@sz"/>
      </xsl:variable>
      <xsl:for-each select="./p:txBody/a:p/a:pPr/a:spcBef/a:spcPct">
        <xsl:if test ="@val">
          <xsl:attribute name ="fo:margin-top">
            <xsl:value-of select="concat(format-number( (( $var_fontsize * ( @val div 100000 ) ) div 2835) * 1.2  ,'#.###'),'cm')"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="./p:txBody/a:p/a:pPr/a:spcAft/a:spcPct">
        <xsl:if test ="@val">
          <xsl:attribute name ="fo:margin-bottom">
            <xsl:value-of select="concat(format-number( (( $var_fontsize * ( @val div 100000 ) ) div 2835 ) * 1.2 ,'#.###'),'cm')"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
    <xsl:for-each select="./p:txBody/a:p/a:pPr/a:spcAft/a:spcPts">
      <xsl:if test ="@val">
        <xsl:attribute name ="fo:margin-bottom">
          <xsl:value-of select="concat(format-number(@val div  2835 ,'#.##'),'cm')"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="./p:txBody/a:p/a:pPr/a:spcBef/a:spcPts">
      <xsl:if test ="@val">
        <xsl:attribute name ="fo:margin-top">
          <xsl:value-of select="concat(format-number(@val div  2835 ,'#.##'),'cm')"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="./p:txBody/a:p/a:pPr/a:lnSpc">
      <xsl:if test ="./a:spcPct">
        <!--<xsl:choose>
          <xsl:when test="$lnSpcReduction='0'">-->
        <xsl:attribute name="fo:line-height">
          <xsl:value-of select="concat(format-number(./a:spcPct/@val div 1000,'###'), '%')"/>
        </xsl:attribute>
        <!--</xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="fo:line-height">
              <xsl:value-of select="concat(format-number((./a:spcPct/@val - $lnSpcReduction) div 1000,'###'), '%')"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>-->
      </xsl:if >
      <xsl:if test ="./a:spcPts">
        <xsl:attribute name="style:line-height-at-least">
          <xsl:value-of select="concat(format-number(./a:spcPts/@val div 2835, '#.##'), 'cm')"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="tmpHandOutTextProperty">
    <xsl:param name ="DefFont" />
    <xsl:param name ="fontscale"/>
    <xsl:if test ="a:rPr/@sz">
      <xsl:attribute name ="fo:font-size"	>
        <xsl:for-each select ="a:rPr/@sz">
          <xsl:choose>
            <xsl:when test="$fontscale ='100000'">
              <xsl:value-of  select ="concat(format-number(. div 100,'#.##'),'pt')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of  select ="concat(format-number(round((. *($fontscale div 1000) )div 10000),'#.##'),'pt')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test ="not(a:rPr/@sz)">
      <xsl:attribute name ="fo:font-size">
        <xsl:for-each select ="parent::node()/parent::node()/a:lstStyle/a:lvl1pPr/a:defRPr/@sz">
          <xsl:choose>
            <xsl:when test="$fontscale ='100000'">
              <xsl:value-of  select ="concat(format-number(. div 100,'#.##'),'pt')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of  select ="concat(format-number(round((. *($fontscale div 1000) )div 10000),'#.##'),'pt')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test ="a:rPr/a:latin/@typeface">
      <xsl:attribute name ="fo:font-family">
        <xsl:variable name ="typeFaceVal" select ="a:rPr/a:latin/@typeface"/>
        <xsl:for-each select ="a:rPr/a:latin/@typeface">
          <xsl:if test ="$typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt'">
            <xsl:value-of  select ="$DefFont"/>
          </xsl:if>
          <xsl:if test ="not($typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt')">
            <xsl:value-of select ="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:attribute>
    </xsl:if>
    <!-- strike style:text-line-through-style-->
    <xsl:if test ="a:rPr/@strike">
      <xsl:if test ="a:rPr[@strike!='noStrike']">
      <xsl:attribute name ="style:text-line-through-style">
        <xsl:value-of select ="'solid'"/>
      </xsl:attribute>
      <xsl:choose >
        <xsl:when test ="a:rPr/@strike='dblStrike'">
          <xsl:attribute name ="style:text-line-through-type">
            <xsl:value-of select ="'double'"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test ="a:rPr/@strike='sngStrike'">
          <xsl:attribute name ="style:text-line-through-type">
            <xsl:value-of select ="'single'"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
    </xsl:if>
    <xsl:if test ="not(a:rPr/@strike)">
      <xsl:if test ="parent::node()/parent::node()/a:lstStyle/a:lvl1pPr/a:defRPr/@strike">
        <xsl:if test ="parent::node()/parent::node()/a:lstStyle/a:lvl1pPr/a:defRPr[@strike!='noStrike']">
        <xsl:attribute name ="style:text-line-through-style">
          <xsl:value-of select ="'solid'"/>
        </xsl:attribute>
        <xsl:choose >
          <xsl:when test ="parent::node()/parent::node()/a:lstStyle/a:lvl1pPr/a:defRPr/@strike='dblStrike'">
            <xsl:attribute name ="style:text-line-through-type">
              <xsl:value-of select ="'double'"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:when test ="parent::node()/parent::node()/a:lstStyle/a:lvl1pPr/a:defRPr/@strike='sngStrike'">
            <xsl:attribute name ="style:text-line-through-type">
              <xsl:value-of select ="'single'"/>
            </xsl:attribute>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
    </xsl:if>
    </xsl:if>
    <!-- Kening Property-->
    <xsl:if test ="a:rPr/@kern">
      <xsl:choose >
        <xsl:when test ="a:rPr/@kern = '0'">
          <xsl:attribute name ="style:letter-kerning">
            <xsl:value-of select ="'false'"/>
          </xsl:attribute >
        </xsl:when >
        <xsl:when test ="format-number(a:rPr/@kern,'#.##') &gt; 0">
          <xsl:attribute name ="style:letter-kerning">
            <xsl:value-of select ="'true'"/>
          </xsl:attribute >
        </xsl:when >
      </xsl:choose>
    </xsl:if >
    <!-- Bold Property-->
    <xsl:if test ="a:rPr/@b">
      <xsl:if test ="a:rPr/@b='1'">
        <xsl:attribute name ="fo:font-weight">
          <xsl:value-of select ="'bold'"/>
        </xsl:attribute>
      </xsl:if >
      <xsl:if test ="a:rPr/@b='0'">
        <xsl:attribute name ="fo:font-weight">
          <xsl:value-of select ="'normal'"/>
        </xsl:attribute>
      </xsl:if >
    </xsl:if >
    <xsl:if test ="not(a:rPr/@b)">
      <xsl:if test ="parent::node()/parent::node()/a:lstStyle/a:lvl1pPr/a:defRPr/@b='1'">
        <xsl:attribute name ="fo:font-weight">
          <xsl:value-of select ="'bold'"/>
        </xsl:attribute>
      </xsl:if >
      <xsl:if test ="parent::node()/parent::node()/a:lstStyle/a:lvl1pPr/a:defRPr/@b='0' or not(parent::node()/parent::node()/a:lstStyle/a:lvl1pPr/a:defRPr/@b)">
        <xsl:attribute name ="fo:font-weight">
          <xsl:value-of select ="'normal'"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:if>
    <!--UnderLine-->
    <xsl:if test ="a:rPr/@u">
      <xsl:for-each select ="a:rPr">
        <xsl:call-template name="tmpUnderLine">
          <xsl:with-param name="u" select="@u"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if >
    <xsl:if test ="not(a:rPr/@u)">
      <xsl:if test ="parent::node()/parent::node()/a:lstStyle/a:lvl1pPr/a:defRPr/@u">
        <xsl:call-template name="tmpUnderLine">
          <xsl:with-param name="u" select="parent::node()/parent::node()/a:lstStyle/a:lvl1pPr/a:defRPr/@u"/>
        </xsl:call-template>
      </xsl:if >
    </xsl:if>
    <!-- Italic-->
    <xsl:if test ="a:rPr/@i">
      <xsl:attribute name ="fo:font-style">
        <xsl:if test ="a:rPr/@i='1'">
          <xsl:value-of select ="'italic'"/>
        </xsl:if >
        <xsl:if test ="a:rPr/@i='0'">
          <xsl:value-of select ="'none'"/>
        </xsl:if>
      </xsl:attribute>
    </xsl:if >
    <xsl:if test ="not(a:rPr/@i)">
      <!--<xsl:if test ="parent::node()/parent::node()/a:lstStyle/a:lvl1pPr/a:defRPr/@i='1'">-->
      <xsl:attribute name ="fo:font-style">
        <xsl:if test ="parent::node()/parent::node()/a:lstStyle/a:lvl1pPr/a:defRPr/@i='1'">
          <xsl:value-of select ="'italic'"/>
        </xsl:if >
        <xsl:if test ="parent::node()/parent::node()/a:lstStyle/a:lvl1pPr/a:defRPr/@i='0' or not(parent::node()/parent::node()/a:lstStyle/a:lvl1pPr/a:defRPr/@i)">
          <xsl:value-of select ="'none'"/>
        </xsl:if>
      </xsl:attribute>
    </xsl:if>
    <!-- Character Spacing -->
    <xsl:if test ="a:rPr/@spc">
      <xsl:attribute name ="fo:letter-spacing">
        <xsl:variable name="length" select="a:rPr/@spc" />
        <xsl:value-of select="concat(format-number($length * 2.54 div 7200,'#.###'),'cm')"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:if test ="a:rPr/a:solidFill/a:srgbClr/@val">
      <xsl:attribute name ="fo:color">
        <xsl:value-of select ="translate(concat('#',a:rPr/a:solidFill/a:srgbClr/@val),$ucletters,$lcletters)"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test ="a:rPr/a:solidFill/a:schemeClr/@val">
      <xsl:attribute name ="fo:color">
        <xsl:call-template name ="getColorCode">
          <xsl:with-param name ="color">
            <xsl:value-of select="a:rPr/a:solidFill/a:schemeClr/@val"/>
          </xsl:with-param>
          <xsl:with-param name ="lumMod">
            <xsl:value-of select="a:rPr/a:solidFill/a:schemeClr/a:lumMod/@val"/>
          </xsl:with-param>
          <xsl:with-param name ="lumOff">
            <xsl:value-of select="a:rPr/a:solidFill/a:schemeClr/a:lumOff/@val"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test ="not(a:rPr/a:solidFill/a:srgbClr/@val) and not(a:rPr/a:solidFill/a:schemeClr/@val)">
      <xsl:choose>
        <xsl:when test ="parent::node()/parent::node()/parent::node()/p:style/a:fontRef/a:srgbClr">
          <xsl:attribute name ="fo:color">
            <xsl:value-of select ="translate(concat('#',parent::node()/parent::node()/parent::node()/p:style/a:fontRef/a:srgbClr/@val),$ucletters,$lcletters)"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test ="parent::node()/parent::node()/parent::node()/p:style/a:fontRef/a:schemeClr">
          <xsl:attribute name ="fo:color">
            <xsl:call-template name ="getColorCode">
              <xsl:with-param name ="color">
                <xsl:value-of select="parent::node()/parent::node()/parent::node()/p:style/a:fontRef/a:schemeClr/@val"/>
              </xsl:with-param>
              <xsl:with-param name ="lumMod">
                <xsl:value-of select="parent::node()/parent::node()/parent::node()/p:style/a:fontRef/a:schemeClr/a:lumMod/@val"/>
              </xsl:with-param>
              <xsl:with-param name ="lumOff">
                <xsl:value-of select="parent::node()/parent::node()/parent::node()/p:style/a:fontRef/a:schemeClr/a:lumOff/@val"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
    <!--Shadow fo:text-shadow-->
    <xsl:if test ="a:rPr/a:effectLst/a:outerShdw">
      <xsl:attribute name ="fo:text-shadow">
        <xsl:value-of select ="'1pt 1pt'"/>
      </xsl:attribute>
    </xsl:if>
    <!--SuperScript and SubScript for Text added by Mathi on 31st Jul 2007-->
    <xsl:if test="(a:rPr/@baseline)">
      <xsl:variable name="baseData">
        <xsl:value-of select="a:rPr/@baseline"/>
      </xsl:variable>
      <xsl:variable name="subSuperScriptValue">
        <xsl:value-of select="number(format-number($baseData div 1000,'#'))"/>
          </xsl:variable>
      <xsl:call-template name="tmpSubSuperScript">
        <xsl:with-param name="baseline" select="$baseData"/>
        <xsl:with-param name="subSuperScriptValue" select="$subSuperScriptValue"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <!-- End of Template Added by Vijayeta to Insert Handout styles-->
  <!-- End of Template Added by Vijayeta to Insert Handout styles-->
   <xsl:template name ="tmpFtrSlNoDtStyle">
    <xsl:param name="ParaId"/>
    <xsl:param name="TypeId"/>
     <xsl:param name="SMName"/>
	   <xsl:message terminate="no">progress:p:cSld</xsl:message>
    <!--@ Default Font Name from PPTX -->
    <xsl:variable name ="DefFont">
      <xsl:call-template name="slideMasterFontName">
          <xsl:with-param name="fontType" select="'minor'"/>
          <xsl:with-param name="SMName" select="$SMName"/>
        </xsl:call-template>
    </xsl:variable>
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
      <xsl:variable name ="listStyleName">
        <!-- Added by vijayeta, to get the text box number-->
        <xsl:variable name ="textNumber" select ="./parent::node()/p:nvSpPr/p:cNvPr/@id"/>
        <!-- Added by vijayeta, to get the text box number-->
        <xsl:choose>
          <xsl:when test ="./parent::node()/p:spPr/a:prstGeom/@prst or ./parent::node()/child::node()[1]/child::node()[1]/@name[contains(., 'TextBox')] or ./parent::node()/child::node()[1]/child::node()[1]/@name[contains(., 'Text Box')]">
            <xsl:value-of select ="concat($TypeId,'textboxshape_List',$textNumber)"/>
          </xsl:when>
          <xsl:otherwise >
            <xsl:value-of select ="concat($TypeId,'List',position())"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test ="(a:p/a:pPr/a:buChar) or (a:p/a:pPr/a:buAutoNum) or (a:p/a:pPr/a:buBlip) ">
        <xsl:call-template name ="insertBulletStyle">          
          <xsl:with-param name ="ParaId" select ="$ParaId"/>
          <xsl:with-param name ="listStyleName" select ="$listStyleName"/>          
        </xsl:call-template>
      </xsl:if>
      <xsl:for-each select ="a:p">
        <xsl:variable name ="levelForDefFont">
          <!--<xsl:if test ="$bulletTypeBool='true'">-->
          <xsl:if test ="a:pPr/@lvl">
            <xsl:value-of select ="a:pPr/@lvl"/>
          </xsl:if>
          <xsl:if test ="not(a:pPr/@lvl)">
            <xsl:value-of select ="'0'"/>
          </xsl:if>
          <!--</xsl:if>-->
        </xsl:variable>
        <style:style style:family="paragraph">
          <xsl:attribute name ="style:name">
            <xsl:value-of select ="concat($ParaId,position())"/>
          </xsl:attribute >
          <style:paragraph-properties  text:enable-numbering="false" >
            <xsl:if test ="parent::node()/a:bodyPr/@vert='vert'">
              <xsl:attribute name ="style:writing-mode">
                <xsl:value-of select ="'tb-rl'"/>
              </xsl:attribute>
            </xsl:if>
           
             
             <xsl:for-each select="./parent::node()/a:lstStyle/a:lvl1pPr">
              <xsl:call-template name="tmpSMParagraphStyle"/>
            </xsl:for-each>
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
           
            <xsl:if test ="a:pPr/a:tabLst/a:tab">
              <xsl:call-template name ="paragraphTabstops" />
            </xsl:if>
         
          </style:paragraph-properties >
        </style:style>
        <xsl:for-each select ="node()" >
          <!-- Add here-->
          <xsl:if test ="name()='a:r'">
            <style:style style:family="text">
              <xsl:attribute name="style:name">
                <xsl:value-of select="concat($TypeId,generate-id())"/>
              </xsl:attribute>
              <style:text-properties style:font-charset="x-symbol">
                <!-- added by vipul to get text propreties from Presentation.xml-->
                 <xsl:for-each select="./parent::node()/parent::node()/a:lstStyle/a:lvl1pPr">
                  <xsl:call-template name="tmpShapeTextProperty">
                    <xsl:with-param name="fontType" select="'minor'"/>
                    <xsl:with-param name="SLMName" select="$SMName"/>
                  </xsl:call-template>
                  <xsl:if test ="./a:defRPr/a:solidFill/a:schemeClr/@val">
                     <xsl:variable name="var_schmClrVal" select="./a:defRPr/a:solidFill/a:schemeClr/@val"/>
                  <xsl:attribute name ="fo:color">
                   <xsl:call-template name ="getColorCode">
          <xsl:with-param name ="color">
            <xsl:for-each select="./parent::node()/parent::node()/parent::node()/parent::node()/parent::node()/parent::node()/p:clrMap">
              <xsl:call-template name="tmpThemeClr">
                <xsl:with-param name="ClrMap" select="$var_schmClrVal"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:with-param>
          <xsl:with-param name ="lumMod">
            <xsl:value-of select="./a:defRPr/a:solidFill/a:schemeClr/a:lumMod/@val"/>
          </xsl:with-param>
          <xsl:with-param name ="lumOff">
            <xsl:value-of select="./a:defRPr/a:solidFill/a:schemeClr/a:lumOff/@val"/>
          </xsl:with-param>
                     <xsl:with-param name ="SMName" select="$SMName"/>
        </xsl:call-template>

                 </xsl:attribute>
          
        </xsl:if>  
                </xsl:for-each>
                 <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
                  <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
                <xsl:choose>
                  <xsl:when test ="a:rPr/a:latin/@typeface">
                    <xsl:attribute name ="fo:font-family">
                   <xsl:variable name ="typeFaceVal" select ="a:rPr/a:latin/@typeface"/>
                   <xsl:for-each select ="a:rPr/a:latin/@typeface">
                  <xsl:if test ="$typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt'">
                      <xsl:value-of  select ="$DefFont"/>
                    </xsl:if>
                     <xsl:if test ="not($typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt')">
                      <xsl:value-of select ="."/>
                  </xsl:if>
                  </xsl:for-each>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test ="a:rPr/a:sym/@typeface">
                    <xsl:attribute name ="fo:font-family">
                      <xsl:variable name ="typeFaceVal" select ="a:rPr/a:sym/@typeface"/>
                      <xsl:for-each select ="a:rPr/a:sym/@typeface">
                        <xsl:if test ="$typeFaceVal='+mn-sym' or $typeFaceVal='+mj-sym'">
                          <xsl:value-of  select ="$DefFont"/>
                   </xsl:if>
                        <xsl:if test ="$typeFaceVal='Wingdings'">
                          <xsl:value-of  select ="'Arial'"/>
                        </xsl:if>
                        <xsl:if test ="not($typeFaceVal='+mn-sym' or $typeFaceVal='+mj-sym' or $typeFaceVal='Wingdings')">
                          <xsl:value-of select ="."/>
                        </xsl:if>
                      </xsl:for-each>
                    </xsl:attribute >
                  </xsl:when>
                  <xsl:when test ="a:rPr/a:cs/@typeface">
                    <xsl:attribute name ="fo:font-family">
                      <xsl:variable name ="typeFaceVal" select ="a:rPr/a:cs/@typeface"/>
                      <xsl:for-each select ="a:rPr/a:cs/@typeface">
                        <xsl:if test ="$typeFaceVal='+mn-cs' or $typeFaceVal='+mj-cs'">
                          <xsl:value-of  select ="$DefFont"/>
                        </xsl:if>
                        <xsl:if test ="not($typeFaceVal='+mn-cs' or $typeFaceVal='+mj-cs')">
                          <xsl:value-of select ="."/>
                        </xsl:if>
                      </xsl:for-each>
                    </xsl:attribute >
                  </xsl:when>

                </xsl:choose>
                  <xsl:if test ="a:rPr/a:solidFill/a:srgbClr/@val">
                   <xsl:attribute name ="fo:color">
                     <xsl:value-of select ="translate(concat('#',a:rPr/a:solidFill/a:srgbClr/@val),$ucletters,$lcletters)"/>
                  </xsl:attribute>
             </xsl:if>
                  <xsl:if test ="a:rPr/a:solidFill/a:schemeClr/@val">
                    <xsl:variable name="var_schmClrVar" select="a:rPr/a:solidFill/a:schemeClr/@val"/>
                       <xsl:attribute name ="fo:color">
                          <xsl:call-template name ="getColorCode">
                          <xsl:with-param name ="color">
                            <xsl:for-each select="./parent::node()/parent::node()/parent::node()/parent::node()/parent::node()/parent::node()/p:clrMap">
                              <xsl:call-template name="tmpThemeClr">
                                <xsl:with-param name="ClrMap" select="$var_schmClrVar"/>
                              </xsl:call-template>
                            </xsl:for-each>
           </xsl:with-param>
          <xsl:with-param name ="lumMod">
            <xsl:value-of select="a:rPr/a:solidFill/a:schemeClr/a:lumMod/@val"/>
          </xsl:with-param>
          <xsl:with-param name ="lumOff">
            <xsl:value-of select="a:rPr/a:solidFill/a:schemeClr/a:lumOff/@val"/>
          </xsl:with-param>
                            <xsl:with-param name ="SMName" select="$SMName"/>
        </xsl:call-template>
      </xsl:attribute>
    </xsl:if>
        <xsl:if test ="a:rPr/@sz">
      <xsl:attribute name ="fo:font-size"	>
        <xsl:for-each select ="a:rPr/@sz">
          <xsl:choose>
            <xsl:when test="$var_fontScale ='100000'">
              <xsl:value-of  select ="concat(format-number(. div 100,'#.##'),'pt')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of  select ="concat(format-number(round((. *($var_fontScale div 1000) )div 10000),'#.##'),'pt')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:attribute>
    </xsl:if>
              </style:text-properties>
            </style:style>
          </xsl:if>
          <!-- Added by lohith.ar for fix 1731885-->
          <xsl:if test ="name()='a:endParaRPr'">
            <style:style style:family="text">
              <xsl:attribute name="style:name">
                <xsl:value-of select="concat($TypeId,generate-id())"/>
              </xsl:attribute>
              <style:text-properties style:font-charset="x-symbol">
                <!-- Bug 1711910 Fixed,On date 2-06-07,by Vijayeta-->
              
                  <xsl:choose >
                    <xsl:when test ="a:endParaRPr/a:latin/@typeface">
                      <xsl:attribute name ="fo:font-family">
                        <xsl:variable name ="typeFaceVal" select ="a:endParaRPr/a:latin/@typeface"/>
                        <xsl:for-each select ="a:endParaRPr/a:latin/@typeface">
                          <xsl:if test ="$typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt'">
                            <xsl:value-of select ="$DefFont"/>
                          </xsl:if>
                            <xsl:if test ="not($typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt')">
                            <xsl:value-of select ="."/>
                          </xsl:if>
                        </xsl:for-each>
                      </xsl:attribute>
                    </xsl:when>
                  <xsl:when test ="a:endParaRPr/a:sym/@typeface">
                      <xsl:attribute name ="fo:font-family">
                      <xsl:variable name ="typeFaceVal" select ="a:endParaRPr/a:sym/@typeface"/>
                      <xsl:for-each select ="a:endParaRPr/a:sym/@typeface">
                        <xsl:if test ="$typeFaceVal='+mn-sym' or $typeFaceVal='+mj-sym'">
                            <xsl:value-of select ="$DefFont"/>
                          </xsl:if>
                        <xsl:if test ="$typeFaceVal='Wingdings'">
                          <xsl:value-of  select ="'Arial'"/>
                        </xsl:if>
                        <xsl:if test ="not($typeFaceVal='+mn-sym' or $typeFaceVal='+mj-sym' or $typeFaceVal='Wingdings')">
                            <xsl:value-of select ="."/>
                          </xsl:if>
                        </xsl:for-each>
                      </xsl:attribute>
                    </xsl:when>
                  <xsl:when test ="a:endParaRPr/a:cs/@typeface">
                      <xsl:attribute name ="fo:font-family">
                      <xsl:variable name ="typeFaceVal" select ="a:endParaRPr/a:cs/@typeface"/>
                      <xsl:for-each select ="a:endParaRPr/a:cs/@typeface">
                        <xsl:if test ="$typeFaceVal='+mn-cs' or $typeFaceVal='+mj-cs'">
                        <xsl:value-of select ="$DefFont"/>
                        </xsl:if>
                        <xsl:if test ="not($typeFaceVal='+mn-cs' or $typeFaceVal='+mj-cs')">
                          <xsl:value-of select ="."/>
                        </xsl:if>
                      </xsl:for-each>
                      </xsl:attribute>
                    </xsl:when>
                  </xsl:choose>
                <xsl:if test ="not(a:endParaRPr/a:latin/@typeface) and not(a:endParaRPr/a:cs/@typeface) and not(a:endParaRPr/a:sym/@typeface)">
                  <xsl:attribute name ="fo:font-family">
                    <xsl:value-of select ="$DefFont"/>
                  </xsl:attribute>
                </xsl:if>
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
                <!--Empty lines font size in BVT and bug 1764385, date 13th aug-->
                <!--it was '<xsl:if test ="not(a:pPr/@sz)">' earlier-->
                <xsl:if test ="not(./@sz)">
                  <xsl:if test="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/a:lvl1pPr/a:defRPr/@sz">
                    <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/a:lvl1pPr/a:defRPr">
                      <xsl:attribute name ="fo:font-size">
                        <xsl:value-of  select ="concat(format-number(@sz div 100,'#.##'),'pt')"/>
                      </xsl:attribute>
                    </xsl:for-each>
                  </xsl:if>
                </xsl:if>
              </style:text-properties>
            </style:style>
          </xsl:if>
        </xsl:for-each >
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
<xsl:template name ="tmpSMGroupedShapes">
    <xsl:param name ="SlideID" />
    <xsl:param name ="SlideRelationId" />
    <xsl:param name ="grID" />
    <xsl:param name ="prID" />
    <xsl:param name ="pos" />
   <xsl:param name ="SlidePos" />
  <xsl:param name ="grpCordinates"/>
   <draw:g>
          <xsl:for-each select="node()">
           <xsl:choose>
            <xsl:when test="name()='p:pic'">
              <xsl:variable name="var_pos" select="position()"/>
              <xsl:for-each select=".">
                <xsl:variable  name ="GraphicId">
                  <xsl:value-of select ="concat('SMgrp',$SlidePos,'Picture',$pos,'-', $var_pos,'gr')"/>
                </xsl:variable>
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
            <xsl:when test="name()='p:graphicFrame'">
              <xsl:if test="./a:graphic/a:graphicData/p:oleObj or ./a:graphic/a:graphicData/mc:AlternateContent/mc:Fallback/p:oleObj ">
                <xsl:call-template name="tmpOLEObjects">
                  <xsl:with-param name ="SlideRelationId" select="$SlideRelationId" />
                <xsl:with-param name="grpBln" select="'true'"/>
                  <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
                </xsl:call-template>
              </xsl:if>
            </xsl:when>
            <xsl:when test="name()='p:sp'">
              <xsl:variable name="var_pos" select="position()"/>
              <xsl:for-each select=".">
                <xsl:choose>
                  <xsl:when test="not(p:nvSpPr/p:nvPr/p:ph)">
                      <xsl:variable  name ="GraphicId">
                       <xsl:value-of select ="concat('SMgrp',$SlidePos,'gr',$pos,'-', $var_pos)"/>
                      </xsl:variable>
                      <xsl:variable name ="ParaId">
                      <xsl:value-of select ="concat('SMgrp',$SlidePos,'PARA',$pos,'-', $var_pos)"/>
                      </xsl:variable>
                      <xsl:call-template name ="shapes">
                        <!-- parameter added by chhavi:for ODF1.1 conformance-->
                        <xsl:with-param name ="layId" select="'true'"/>
                        <xsl:with-param name="GraphicId" select ="$GraphicId"/>
                        <xsl:with-param name ="ParaId" select="$ParaId" />
                        <xsl:with-param name ="TypeId" select="$SlideID" />
                        <xsl:with-param name="SlideRelationId" select="$SlideRelationId"/>
                        <xsl:with-param name="var_pos" select="$var_pos"/>
                       <xsl:with-param name="grpBln" select="'true'"/>
                      <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
                      </xsl:call-template>
                  </xsl:when>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="name()='p:cxnSp'">
              <xsl:variable name="var_pos" select="position()"/>
              <xsl:for-each select=".">
              <xsl:variable  name ="GraphicId">
                <xsl:value-of select ="concat('SMgrp',$SlidePos,'grLine',$pos,'-', $var_pos)"/>
              </xsl:variable>
              <xsl:variable name ="ParaId">
                <xsl:value-of select ="concat('SMgrp',$SlidePos,'PARA',$pos,'-', $var_pos)"/>
              </xsl:variable>
              <xsl:call-template name ="shapes">
                    <!-- parameter added by chhavi:for ODF1.1 conformance-->
                    <xsl:with-param name ="layId" select="'true'"/>
                <xsl:with-param name="GraphicId" select ="$GraphicId"/>
                <xsl:with-param name ="ParaId" select="$ParaId" />
                <xsl:with-param name ="TypeId" select="$SlideID" />
                  <xsl:with-param name ="SlideRelationId" select ="$SlideRelationId" />
                <xsl:with-param name="grpBln" select="'true'"/>
                <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
                </xsl:call-template>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="name()='p:grpSp'">
               <xsl:variable name="var_pos" select="position()"/>
               <xsl:variable name="InnerLevelgrpCordinates">
                 <xsl:call-template name="tmpGetgroupTransformValues"/>
               </xsl:variable>
               <xsl:call-template name ="tmpSMGroupedShapes">
                 <xsl:with-param name ="SlidePos"  select ="$SlidePos" />
                <xsl:with-param name ="SlideID"  select ="$SlideID" />
                 <xsl:with-param name ="pos"  select ="concat($pos,'-',$var_pos)" />
                <xsl:with-param name ="SlideRelationId" select="$SlideRelationId" />
                 <xsl:with-param name ="grpCordinates" select ="concat($grpCordinates,$InnerLevelgrpCordinates)" />
               </xsl:call-template>
            </xsl:when>
          </xsl:choose>
      </xsl:for-each>
     </draw:g>
  </xsl:template>
  <xsl:template name="tmpGradientFillStyle">
    <xsl:param name="FilePath"/>
    <xsl:param name="FileName"/>
    <xsl:param name="FileType"/>
    <xsl:param name="groupPrefix"/>
     <xsl:param name="FlagSMLytSlide"/>
    <xsl:param name="SMName"/>
    <xsl:for-each select="key('Part', $FilePath)//p:cSld/p:spTree">
        <xsl:for-each select="node()">
          <xsl:message terminate="no">progress:a:p</xsl:message>
          <xsl:choose>
            <xsl:when test="name()='p:sp'">
              <xsl:variable name="var_TextBoxType">
                <xsl:choose>
                  <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='ctrTitle' or p:nvSpPr/p:nvPr/p:ph/@type='title'">
                    <xsl:value-of select="'title'"/>
                  </xsl:when>
                  <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='subTitle'">
                    <xsl:value-of select="'subtitle'"/>
                  </xsl:when>
                  <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='ftr'">
                    <xsl:value-of select="'Footer'"/>
                  </xsl:when>
                  <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='sldNum'">
                    <xsl:value-of select="'PageNumber'"/>
                  </xsl:when>
                  <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='dt'">
                    <xsl:value-of select="'DateTime'"/>
                  </xsl:when>
                  <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='hdr'">
                    <xsl:value-of select="'Header'"/>
                  </xsl:when>
                  <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='body' and p:nvSpPr/p:nvPr/p:ph/@idx ">
                    <xsl:value-of select="'outline'"/>
                  </xsl:when>
                  <xsl:when test="not(p:nvSpPr/p:nvPr/p:ph/@type) and p:nvSpPr/p:nvPr/p:ph/@idx ">
                    <xsl:value-of select="'outline'"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:variable>
              <xsl:variable name="var_index">
                <xsl:choose >
                  <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@idx">
                    <xsl:value-of select="p:nvSpPr/p:nvPr/p:ph/@idx"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:variable>
              <xsl:variable name="var_pos" select="position()"/>
              <xsl:call-template name="tmpGrad">
                <xsl:with-param name="FilePath" select="$FilePath" />
                <xsl:with-param name="FileName" select="$FileName"/>
                <xsl:with-param name="FileType" select="$FileType"/>
                <xsl:with-param name="var_TextBoxType" select="$var_TextBoxType" />
                <xsl:with-param name="var_index" select="$var_index"/>
                <xsl:with-param name="var_pos" select="$var_pos"/>
                <xsl:with-param name="groupPrefix" select="$groupPrefix"/>
                <xsl:with-param name="SMName" select="$SMName"/>
                            </xsl:call-template>
            </xsl:when>
            <xsl:when test="name()='p:grpSp'">
              <xsl:variable name="grpVarPos" select="position()"/>
                           <xsl:variable name="var_pos" select="position()"/>
              <xsl:for-each select=".">
                <xsl:call-template name="tmpGroupGradient">
                  <xsl:with-param name="FilePath" select="$FilePath" />
                  <xsl:with-param name="FileName" select="$FileName"/>
                  <xsl:with-param name="FileType" select="$FileType"/>
                  <xsl:with-param name="grppos" select="$var_pos"/>
                  <xsl:with-param name="groupPrefix">
                    <xsl:choose>
                      <xsl:when test="contains($FileType,'slideLayout')">
                        <xsl:value-of select="'SlideLayoutGroup'"/>
                      </xsl:when>
                      <xsl:when test="contains($FileType,'slideMaster')">
                        <xsl:value-of select="'SMGroup'"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="'SlideGroup'"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:with-param>
                  <xsl:with-param name="SMName" select="$SMName"/>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:template>
  <xsl:template name="tmpGroupGradient">
    <xsl:param name="FilePath" />
    <xsl:param name="FileName"/>
    <xsl:param name="FileType" />
    <xsl:param name="grppos"/>
    <xsl:param name="groupPrefix"/>
      <xsl:param name="SMName"/>
    <xsl:for-each select="node()">
      <xsl:choose>
        <xsl:when test="name()='p:sp'">
          <xsl:if test="not(p:nvSpPr/p:nvPr/p:ph)">
            <xsl:variable name="var_pos" select="position()"/>
            <xsl:call-template name="tmpGrad">
              <xsl:with-param name="FilePath" select="$FilePath" />
              <xsl:with-param name="FileName" select="$FileName"/>
              <xsl:with-param name="FileType" select="$FileType"/>
              <xsl:with-param name="var_pos" select="concat($grppos,'-',$var_pos)"/>
              <xsl:with-param name="groupPrefix" select="$groupPrefix"/>
              <xsl:with-param name="SMName" select="$SMName"/>
            
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <xsl:when test="name()='p:grpSp'">
          <xsl:variable name="var_pos" select="position()"/>
          <xsl:call-template name="tmpGroupGradient">
            <xsl:with-param name="FilePath" select="$FilePath" />
            <xsl:with-param name="FileName" select="$FileName"/>
            <xsl:with-param name="FileType" select="$FileType"/>
            <xsl:with-param name="grppos" select="concat($grppos,'-',$var_pos)"/>
            <xsl:with-param name="groupPrefix" select="$groupPrefix"/>
            <xsl:with-param name="SMName" select="$SMName"/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>

  </xsl:template>
   <xsl:template name="tmpGrad">
      <xsl:param name="FilePath"/>
      <xsl:param name="FileName"/>
      <xsl:param name="FileType"/>
      <xsl:param name="groupPrefix"/>
      <xsl:param name="var_TextBoxType"/>
      <xsl:param name="var_pos"/>
      <xsl:param name="var_index"/>
     <xsl:param name="SMName"/>
              <xsl:for-each select="p:spPr/a:gradFill">
                <draw:gradient>
        <xsl:variable name="gradientName">
                    <xsl:choose>
                      <xsl:when test="contains($FileType,'slideLayout') and $var_TextBoxType !=''">
                <xsl:value-of select="concat($groupPrefix,$FileType,'-',$var_TextBoxType,$var_index,'Gradient')"/>
                      </xsl:when>
            <xsl:when test="contains($FileType,'handoutMaster') and $var_TextBoxType !=''">
              <xsl:value-of select="concat($groupPrefix,$FileType,$var_TextBoxType,'Gradient')"/>
            </xsl:when>
            <xsl:when test="contains($FileType,'slideMaster') and $var_TextBoxType !='' and not(contains($FileType,'slideLayout'))">
                        <xsl:value-of select="concat($FileType,$var_TextBoxType,'Gradient')"/>
                      </xsl:when>
                      <xsl:otherwise>
                <xsl:value-of select="concat($groupPrefix,$FileType,'Gradient',$var_pos)"/>
                      </xsl:otherwise>
                    </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="draw:name">
          <xsl:value-of select="$gradientName"/>
                  </xsl:attribute>
                  <xsl:attribute name="draw:display-name">
                    <xsl:value-of select="$gradientName"/>
                  </xsl:attribute>
                  <xsl:call-template name="tmpGradientFillTiletoRect">
                    <xsl:with-param name="SMName" select="$SMName"/>
                  </xsl:call-template>
                </draw:gradient>
              </xsl:for-each>
           </xsl:template>
  <xsl:template name="tmpBGgradientFillStyle">
    <xsl:param name="FilePath"/>
    <xsl:param name="FileName"/>
    <xsl:param name="FileType"/>
    <xsl:param name="SMName"/>
    <xsl:for-each select="key('Part', $FilePath)//p:cSld/p:bg">
        <xsl:message terminate="no">progress:a:p</xsl:message>
            <xsl:for-each select="p:bgPr/a:gradFill">
              <draw:gradient>
                <xsl:attribute name="draw:name">
                  <xsl:value-of select="concat($FileType,'-Gradient')"/>
                </xsl:attribute>
                <xsl:attribute name="draw:display-name">
                  <xsl:value-of select="concat($FileType,'-Gradient')"/>
                </xsl:attribute>
                <xsl:call-template name="tmpGradientFillTiletoRect">
                  <xsl:with-param name="SMName" select="$SMName"/>
                </xsl:call-template>
              </draw:gradient>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:template>
   <xsl:template name="tmpGradientFillTiletoRect">
          <xsl:param name="SMName"/>
          <xsl:variable name="gradientType">
                    <xsl:choose>
              <xsl:when test="a:lin" >
                <xsl:value-of select="'linear'"/>
                                </xsl:when>
              <xsl:when test="a:path">
                <xsl:value-of select="'path'"/>
                      </xsl:when>
<!--Conformance Test-->
                      <xsl:otherwise>
                        <xsl:value-of select="'linear'"/>
                      </xsl:otherwise>
                    </xsl:choose>
          </xsl:variable>
          <xsl:for-each select="a:gsLst/a:gs">
            <xsl:call-template name="tmpGradientStop">
              <xsl:with-param name="gradType" select="$gradientType"/>
               <xsl:with-param name="SMName" select="$SMName"/>
                                    </xsl:call-template>
                                  </xsl:for-each>
<!--Conformance Test-->
     <!--modified by chhavi-->
     <xsl:choose>
       <xsl:when test ="a:lin">
           <xsl:for-each select="a:lin">
                  <xsl:if test="@ang">
                    <xsl:attribute name="draw:angle">
                      <xsl:variable name="angleValue">
                      <xsl:value-of select="round((((( -1 * @ang ) + 5400000 ) mod 21600000 ) div 60000) * 10)"/>
                      </xsl:variable>
                      <xsl:choose>
                        <xsl:when test="$angleValue &lt; 0">
                          <xsl:value-of select="-1 * $angleValue "/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="$angleValue "/>
                        </xsl:otherwise>
                      </xsl:choose>
                        </xsl:attribute>
                  </xsl:if>
                   <xsl:attribute name="draw:style">
                    <xsl:value-of select="'linear'"/>
                  </xsl:attribute>
                </xsl:for-each>
       </xsl:when>
       <xsl:when test ="./a:path">
          <xsl:for-each select="./a:path">
                  <xsl:choose>
                    <xsl:when test="@path='circle'">
                      <xsl:attribute name="draw:style">
                        <xsl:value-of select="'radial'"/>
                      </xsl:attribute>
                    </xsl:when>
              <xsl:when test="@path='shape'">
                <xsl:attribute name="draw:style">
                  <xsl:value-of select="'ellipsoid'"/>
                </xsl:attribute>
              </xsl:when>
                    <xsl:when test="@path='rect'">
                      <xsl:attribute name="draw:style">
                        <xsl:value-of select="'rectangular'"/>
                      </xsl:attribute>
                    </xsl:when>
                  </xsl:choose>
                  <xsl:for-each select="./a:fillToRect">
                    <xsl:choose>
                <xsl:when test="@l and @r and @t and @b">
                        <xsl:attribute name="draw:cx">
                    <xsl:variable name="var_cx">
                      <xsl:value-of select="number(format-number(( (@l+ @r) div 2 ) div 1000,'#')) "/>
                    </xsl:variable>
                    <xsl:value-of select="concat($var_cx,'%') "/>
                  </xsl:attribute>
                  <xsl:attribute name="draw:cy">
                    <xsl:variable name="var_cy">
                      <xsl:value-of select="number(format-number(( (@t+ @b) div 2 ) div 1000,'#')) "/>
                    </xsl:variable>
                    <xsl:value-of select="concat($var_cy,'%') "/>
                        </xsl:attribute>
                      </xsl:when>
                <xsl:when test="@l and @b">
                        <xsl:attribute name="draw:cx">
                    <xsl:variable name="var_cx">
                      <xsl:value-of select="number(format-number( @l  div 1000,'#')) "/>
                    </xsl:variable>
                    <xsl:value-of select="concat($var_cx,'%') "/>
                  </xsl:attribute>
                  <xsl:attribute name="draw:cy">
                    <xsl:value-of select="'0%' "/>
                        </xsl:attribute>
                      </xsl:when>
          <xsl:when test="@l and @t">
                        <xsl:attribute name="draw:cx">
              <xsl:variable name="var_cx">
                <xsl:value-of select="number(format-number( @l  div 1000,'#')) "/>
              </xsl:variable>
              <xsl:value-of select="concat($var_cx,'%') "/>
                        </xsl:attribute>
              <xsl:attribute name="draw:cy">
              <xsl:variable name="var_cy">
                <xsl:value-of select="number(format-number( @t  div 1000,'#')) "/>
              </xsl:variable>
              <xsl:value-of select="concat($var_cy,'%') "/>
                        </xsl:attribute>
                      </xsl:when>
          <xsl:when test="@r and @b">
            <xsl:attribute name="draw:cx">
              <xsl:value-of select="'0%' "/>
            </xsl:attribute>
                        <xsl:attribute name="draw:cy">
              <xsl:value-of select="'0%' "/>
                        </xsl:attribute>
                      </xsl:when>
          <xsl:when test="@r and @t">
                        <xsl:attribute name="draw:cx">
              <xsl:value-of select="'0%' "/>
            </xsl:attribute>
            <xsl:attribute name="draw:cy">
              <xsl:variable name="var_cy">
                <xsl:value-of select="number(format-number( @t  div 1000,'#')) "/>
              </xsl:variable>
              <xsl:value-of select="concat($var_cy,'%') "/>
                        </xsl:attribute>
                      </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="draw:cx">
              <xsl:value-of select="'100%' "/>
            </xsl:attribute>
            <xsl:attribute name="draw:cy">
              <xsl:value-of select="'100%' "/>
            </xsl:attribute>
          </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                </xsl:for-each>
       </xsl:when>
       <xsl:otherwise>
         <xsl:attribute name="draw:style">
           <xsl:value-of select="'linear'"/>
         </xsl:attribute>
       </xsl:otherwise>
     </xsl:choose>


              </xsl:template>
<xsl:template name="tmpGradientStop">
    <xsl:param name="gradType"/>
    <xsl:param name="SMName"/>
    <xsl:if test="position()=1">
      <xsl:choose>
        <xsl:when test="a:srgbClr/@val">
          <xsl:choose>
            <xsl:when test="$gradType='linear'" >
              <xsl:attribute name="draw:start-color">
                <xsl:value-of select="concat('#',a:srgbClr/@val)" />
              </xsl:attribute>
            </xsl:when>
            <xsl:when test="$gradType='path'" >
              <xsl:attribute name="draw:end-color">
                <xsl:value-of select="concat('#',a:srgbClr/@val)" />
              </xsl:attribute>
            </xsl:when>
          </xsl:choose>
         
        </xsl:when>
        <xsl:when test="a:schemeClr/@val">
          <xsl:variable name="var_schemeClr" select="a:schemeClr/@val"/>
          <xsl:choose>
            <xsl:when test="$gradType='linear'" >
              <xsl:attribute name="draw:start-color">
                <xsl:call-template name="getColorCode">
                  <xsl:with-param name="color">
                    <xsl:choose>
                      <xsl:when test="$SMName!=''">
                        <xsl:for-each select="key('Part', concat('ppt/slideMasters/',$SMName))//p:clrMap">
                          <xsl:call-template name="tmpThemeClr">
                            <xsl:with-param name="ClrMap" select="$var_schemeClr"/>
                          </xsl:call-template>
                        </xsl:for-each>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="a:schemeClr/@val" />
                      </xsl:otherwise>
                    </xsl:choose>
                
                  </xsl:with-param>
                  <xsl:with-param name="lumMod">
                    <xsl:value-of select="a:schemeClr/a:lumMod/@val" />
                  </xsl:with-param>
                  <xsl:with-param name="lumOff">
                    <xsl:value-of select="a:schemeClr/a:lumOff/@val" />
                  </xsl:with-param>
                  <xsl:with-param name ="shade">
                    <xsl:for-each select="a:schemeClr/a:shade/@val">
                      <xsl:value-of select=". div 1000"/>
                    </xsl:for-each>
                  </xsl:with-param>
                  <xsl:with-param name ="SMName" select="$SMName"/>
                </xsl:call-template>
              </xsl:attribute>
            </xsl:when>
            <xsl:when test="$gradType='path'" >
              <xsl:attribute name="draw:end-color">
                <xsl:call-template name="getColorCode">
                  <xsl:with-param name="color">
                    <xsl:choose>
                      <xsl:when test="$SMName!=''">
                        <xsl:for-each select="key('Part', concat('ppt/slideMasters/',$SMName))//p:clrMap">
                          <xsl:call-template name="tmpThemeClr">
                            <xsl:with-param name="ClrMap" select="$var_schemeClr"/>
                          </xsl:call-template>
                        </xsl:for-each>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="a:schemeClr/@val" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:with-param>
                  <xsl:with-param name="lumMod">
                    <xsl:value-of select="a:schemeClr/a:lumMod/@val" />
                  </xsl:with-param>
                  <xsl:with-param name="lumOff">
                    <xsl:value-of select="a:schemeClr/a:lumOff/@val" />
                  </xsl:with-param>
                  <xsl:with-param name ="shade">
                    <xsl:for-each select="a:schemeClr/a:shade/@val">
                      <xsl:value-of select=". div 1000"/>
                    </xsl:for-each>
                  </xsl:with-param>
                  <xsl:with-param name ="SMName" select="$SMName"/>
                </xsl:call-template>
              </xsl:attribute>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="position()=last()">
      <xsl:choose>
        <xsl:when test="a:srgbClr/@val">
          <xsl:choose>
            <xsl:when test="$gradType='linear'" >
              <xsl:attribute name="draw:end-color">
                <xsl:value-of select="concat('#',a:srgbClr/@val)" />
              </xsl:attribute>
            </xsl:when>
            <xsl:when test="$gradType='path'" >
              <xsl:attribute name="draw:start-color">
                <xsl:value-of select="concat('#',a:srgbClr/@val)" />
              </xsl:attribute>
            </xsl:when>
          </xsl:choose>

        </xsl:when>
        <xsl:when test="a:schemeClr/@val">
          <xsl:variable name="var_schemeClr" select="a:schemeClr/@val"/>
          <xsl:choose>
            <xsl:when test="$gradType='linear'" >
              <xsl:attribute name="draw:end-color">
                <xsl:call-template name="getColorCode">
                  <xsl:with-param name="color">
                    <xsl:choose>
                      <xsl:when test="$SMName!=''">
                        <xsl:for-each select="key('Part', concat('ppt/slideMasters/',$SMName))//p:clrMap">
                          <xsl:call-template name="tmpThemeClr">
                            <xsl:with-param name="ClrMap" select="$var_schemeClr"/>
                          </xsl:call-template>
                        </xsl:for-each>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="a:schemeClr/@val" />
                      </xsl:otherwise>
                    </xsl:choose>

                  </xsl:with-param>
                  <xsl:with-param name="lumMod">
                    <xsl:value-of select="a:schemeClr/a:lumMod/@val" />
                  </xsl:with-param>
                  <xsl:with-param name="lumOff">
                    <xsl:value-of select="a:schemeClr/a:lumOff/@val" />
                  </xsl:with-param>
                  <xsl:with-param name ="shade">
                    <xsl:for-each select="a:schemeClr/a:shade/@val">
                      <xsl:value-of select=". div 1000"/>
                    </xsl:for-each>
                  </xsl:with-param>
                  <xsl:with-param name ="SMName" select="$SMName"/>
                </xsl:call-template>
              </xsl:attribute>
            </xsl:when>
            <xsl:when test="$gradType='path'" >
              <xsl:attribute name="draw:start-color">
                <xsl:call-template name="getColorCode">
                  <xsl:with-param name="color">
                    <xsl:choose>
                      <xsl:when test="$SMName!=''">
                        <xsl:for-each select="key('Part', concat('ppt/slideMasters/',$SMName))//p:clrMap">
                          <xsl:call-template name="tmpThemeClr">
                            <xsl:with-param name="ClrMap" select="$var_schemeClr"/>
                          </xsl:call-template>
                        </xsl:for-each>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="a:schemeClr/@val" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:with-param>
                  <xsl:with-param name="lumMod">
                    <xsl:value-of select="a:schemeClr/a:lumMod/@val" />
                  </xsl:with-param>
                  <xsl:with-param name="lumOff">
                    <xsl:value-of select="a:schemeClr/a:lumOff/@val" />
                  </xsl:with-param>
                  <xsl:with-param name ="shade">
                    <xsl:for-each select="a:schemeClr/a:shade/@val">
                      <xsl:value-of select=". div 1000"/>
                    </xsl:for-each>
                  </xsl:with-param>
                  <xsl:with-param name ="SMName" select="$SMName"/>
                </xsl:call-template>
              </xsl:attribute>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>