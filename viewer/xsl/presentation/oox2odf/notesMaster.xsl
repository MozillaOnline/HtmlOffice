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
  exclude-result-prefixes="a style fo r rels xmlns">  
  <xsl:template name="NotesMaster">
    <xsl:param name="smName"/>
    <!-- warn,notes master-->
    <xsl:message terminate="no">translation.oox2odf.notesMasterSingleToMultiple</xsl:message>
    <presentation:notes style:page-layout-name="PMNotes">
      <office:forms form:automatic-focus="false" form:apply-design-mode="false"/>
      <xsl:for-each select="key('Part', 'ppt/notesMasters/notesMaster1.xml')/p:notesMaster/p:cSld">
        <xsl:for-each select="p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='sldImg']">
          <draw:page-thumbnail draw:layer="backgroundobjects" presentation:class="page">
            <xsl:attribute name="presentation:style-name">
              <xsl:value-of select="concat($smName,'-title')"/>
            </xsl:attribute>
            <xsl:for-each select="./parent::node()/parent::node()/parent::node()">
              <xsl:call-template name="tmpWriteCordinates"/>
            </xsl:for-each>
          </draw:page-thumbnail>
        </xsl:for-each>
        <xsl:for-each select="p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='body']"> 
          <draw:frame  draw:layer="backgroundobjects" presentation:class="notes" presentation:placeholder="true">
            <xsl:attribute name="presentation:style-name">
              <xsl:value-of select="concat($smName,'-notes')"/>
            </xsl:attribute>
            <xsl:for-each select="./parent::node()/parent::node()/parent::node()">
              <xsl:call-template name="tmpWriteCordinates"/>
            </xsl:for-each>
            <draw:text-box>
              <!--<text:p text:style-name="P4">Click to edit Master text styles</text:p>-->
            </draw:text-box>
          </draw:frame>
        </xsl:for-each>
        <xsl:for-each select="p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='hdr']">
          <draw:frame draw:layer="backgroundobjects" presentation:class="header" >
            <xsl:attribute name="presentation:style-name">
              <xsl:value-of select="concat($smName,'-NotesHeader')"/>
            </xsl:attribute>
            <xsl:for-each select="./parent::node()/parent::node()/parent::node()">
              <xsl:call-template name="tmpWriteCordinates"/>
            </xsl:for-each>
            <draw:text-box>
              <text:p>
                <xsl:for-each select="parent::node()/parent::node()/parent::node()/p:txBody/a:p">
                  <xsl:if test="./a:r">
                    <text:span>
                      <xsl:value-of select="."/>
                    </text:span>
                  </xsl:if>
                  <xsl:if test="not(./a:r)">
                    <presentation:header/>
                  </xsl:if>
                </xsl:for-each>
              </text:p>
            </draw:text-box>
          </draw:frame>
        </xsl:for-each>
        <xsl:for-each select="p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='dt']">
          <draw:frame draw:layer="backgroundobjects" presentation:class="date-time">
            <xsl:attribute name="presentation:style-name">
              <xsl:value-of select="concat($smName,'-NotesDateTime')"/>
            </xsl:attribute>
            <xsl:for-each select="./parent::node()/parent::node()/parent::node()">
              <xsl:call-template name="tmpWriteCordinates"/>
            </xsl:for-each>
            <draw:text-box>
              <text:p>
                <xsl:for-each select="parent::node()/parent::node()/parent::node()/p:txBody/a:p/a:r/a:t">
                  <text:span>
                  <xsl:value-of select="."/>
                  </text:span>
                </xsl:for-each>
                <xsl:for-each select="parent::node()/parent::node()/parent::node()/p:txBody/a:p/a:fld">
                  <presentation:date-time/>
                </xsl:for-each>
              </text:p>
            </draw:text-box>
          </draw:frame>
        </xsl:for-each>
        <xsl:for-each select="p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='ftr']">
          <draw:frame draw:layer="backgroundobjects" presentation:class="footer" >
            <xsl:attribute name="presentation:style-name">
              <xsl:value-of select="concat($smName,'-Notesfooter')"/>
            </xsl:attribute>
              <xsl:for-each select="./parent::node()/parent::node()/parent::node()">
              <xsl:call-template name="tmpWriteCordinates"/>
            </xsl:for-each>
            <draw:text-box>
              <text:p>
                <xsl:for-each select="parent::node()/parent::node()/parent::node()/p:txBody/a:p">
                  <xsl:if test="./a:r">
                    <text:span>
                    <xsl:value-of select="."/>
                    </text:span>
                  </xsl:if>
                  <xsl:if test="not(./a:r)">
                    <presentation:footer/>
                  </xsl:if>
                </xsl:for-each>
              </text:p>
            </draw:text-box>
          </draw:frame>
        </xsl:for-each>
        <xsl:for-each select="p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='sldNum']">
          <draw:frame draw:layer="backgroundobjects" presentation:class="page-number">
            <xsl:attribute name="presentation:style-name">
              <xsl:value-of select="concat($smName,'-Notespageno')"/>
            </xsl:attribute>
              <xsl:for-each select="./parent::node()/parent::node()/parent::node()">
              <xsl:call-template name="tmpWriteCordinates"/>
            </xsl:for-each>
            <draw:text-box>
              <text:p>
                <xsl:for-each select="parent::node()/parent::node()/parent::node()/p:txBody/a:p/a:r/a:t">
                  <text:span>
                  <xsl:value-of select="."/>
                  </text:span>
                </xsl:for-each>
                <xsl:for-each select="parent::node()/parent::node()/parent::node()/p:txBody/a:p/a:fld">
                  <text:page-number>&lt;number&gt;</text:page-number>
                </xsl:for-each>
              </text:p>
            </draw:text-box>
          </draw:frame>
        </xsl:for-each>
      </xsl:for-each>
    </presentation:notes>
  </xsl:template>

  <xsl:template name="NMasterSubtitleOutlineStyle">
    <xsl:param name="slideMasterName"/>
    <xsl:param name="slideMasterPath"/>
 
    <!-- style for sub-Title-->
    <style:style>
      <xsl:attribute name="style:name">
        <xsl:value-of select="concat($slideMasterName,'-notes')"/>
      </xsl:attribute>
      <xsl:attribute name ="style:family">
        <xsl:value-of select ="'presentation'"/>
      </xsl:attribute>
      <xsl:call-template name="NotetmpOutlineStyle">
        <xsl:with-param name="prm_SMName" select="$slideMasterPath"/>
      </xsl:call-template>
    </style:style>
  </xsl:template>


  <xsl:template name="NotetmpOutlineStyle">
    <xsl:param name="prm_SMName"/>
    <xsl:for-each select="key('Part', 'ppt/notesMasters/notesMaster1.xml')//p:sp">
      <xsl:if test="p:nvSpPr/p:nvPr/p:ph/@type='body'">
    <style:graphic-properties>
      <xsl:call-template name="NotetmpGraphicProperty"/>
      <text:list-style>
          <xsl:for-each select ="./p:txBody/a:p">
            <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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
              <xsl:call-template name="NotetmpListLevelStyle">
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

        <xsl:call-template name="OutlineTen"/>
      </text:list-style>
      <!--Added by Sanjay to get correct Text Direction:Fixed Bug no-1958740-->
      <xsl:if test="p:txBody/a:bodyPr/@vert">
        <style:paragraph-properties>
            <xsl:call-template name="getTextDirection">
              <xsl:with-param name="vert" select="p:txBody/a:bodyPr/@vert"/>
            </xsl:call-template>
        </style:paragraph-properties>
      </xsl:if>
      <!--End of Bug no-1958740-->
    </style:graphic-properties>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="key('Part', 'ppt/notesMasters/notesMaster1.xml')">
      <xsl:for-each select ="p:notesMaster/p:notesStyle/a:lvl1pPr">
        <xsl:call-template name="NoteOutlines">
          <xsl:with-param name="level">
            <xsl:value-of select="'1'"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name ="NotetmpListLevelStyle">
    <xsl:param name="SlideMasterFile" />
    <xsl:param name="levelNo"></xsl:param>
    <xsl:param name="pos"></xsl:param>
    <xsl:variable name="var_SMrelationFile">
      <xsl:value-of select="concat('ppt/slideMasters/_rels/',$SlideMasterFile,'.rels')"/>
    </xsl:variable>
    <!--<xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SlideMasterFile))//p:txStyles/p:bodyStyle">-->
    <xsl:for-each select="key('Part', 'ppt/notesMasters/notesMaster1.xml')//p:notesStyle">
      <xsl:choose>
        <xsl:when test="$levelNo='0'">
          <xsl:if test ="a:lvl1pPr/a:buChar">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:call-template name ="insertBulletCharacter">
                  <xsl:with-param name ="character" select ="a:lvl1pPr/a:buChar/@char" />
                </xsl:call-template>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl1pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl1pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl1pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl1pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl1pPr/@marL &lt; 0 and ./a:lvl1pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl1pPr/@marL + ./a:lvl1pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl1pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl1pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl1pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'1'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
          <xsl:if test ="a:lvl1pPr/a:buAutoNum">
            <text:list-level-style-number>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:for-each select="./a:lvl1pPr">
                <!--<xsl:call-template name="OutlineNumbering"></xsl:call-template>-->
              </xsl:for-each>
              <style:list-level-properties>
                <xsl:if test ="./a:lvl1pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl1pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl1pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl1pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <!--<xsl:if test ="./a:lvl1pPr/@marL">
                  <xsl:attribute name ="text:space-before">
                    <xsl:value-of select="concat(format-number( (./a:lvl1pPr/@marL + ./a:lvl1pPr/@indent) div 360000, '#.##'), 'cm')"/>
                  </xsl:attribute>
                </xsl:if>-->
                <xsl:choose>
                  <xsl:when test="./a:lvl1pPr/@marL &lt; 0 and ./a:lvl1pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl1pPr/@marL + ./a:lvl1pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl1pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl1pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl1pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'1'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-number>
          </xsl:if>
          <xsl:if test ="a:lvl1pPr/a:buBlip">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:value-of select="'●'"/>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl1pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl1pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl1pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl1pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <!--<xsl:if test ="./a:lvl1pPr/@marL">
                  <xsl:attribute name ="text:space-before">
                    <xsl:value-of select="concat(format-number( (./a:lvl1pPr/@marL + ./a:lvl1pPr/@indent) div 360000, '#.##'), 'cm')"/>
                  </xsl:attribute>
                </xsl:if>-->
                <xsl:choose>
                  <xsl:when test="./a:lvl1pPr/@marL &lt; 0 and ./a:lvl1pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl1pPr/@marL + ./a:lvl1pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl1pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl1pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl1pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'1'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
          <xsl:if test="not(a:lvl1pPr/a:buAutoNum) and not(a:lvl1pPr/a:buChar) and not(a:lvl1pPr/a:buBlip)">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:call-template name ="insertBulletCharacter">
                  <xsl:with-param name ="character" select ="a:lvl2pPr/a:buChar/@char" />
                </xsl:call-template>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl1pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl1pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl1pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl1pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <!--<xsl:if test ="./a:lvl1pPr/@marL">
                  <xsl:attribute name ="text:space-before">
                    <xsl:value-of select="concat(format-number( (./a:lvl1pPr/@marL + ./a:lvl1pPr/@indent) div 360000, '#.##'), 'cm')"/>
                  </xsl:attribute>
                </xsl:if>-->
                <xsl:choose>
                  <xsl:when test="./a:lvl1pPr/@marL &lt; 0 and ./a:lvl1pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl1pPr/@marL + ./a:lvl1pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl1pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl1pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl1pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'1'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$levelNo='1'">
          <xsl:if test ="a:lvl2pPr/a:buChar">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:call-template name ="insertBulletCharacter">
                  <xsl:with-param name ="character" select ="a:lvl2pPr/a:buChar/@char" />
                </xsl:call-template>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl2pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl2pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl2pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl2pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <!--<xsl:if test ="./a:lvl2pPr/@marL">
                  <xsl:attribute name ="text:space-before">
                    <xsl:value-of select="concat(format-number( (./a:lvl2pPr/@marL + ./a:lvl2pPr/@indent) div 360000, '#.##'), 'cm')"/>
                  </xsl:attribute>
                </xsl:if>-->
                <xsl:choose>
                  <xsl:when test="./a:lvl2pPr/@marL &lt; 0 and ./a:lvl2pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl2pPr/@marL + ./a:lvl2pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl2pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl2pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl2pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'2'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
          <xsl:if test ="a:lvl2pPr/a:buAutoNum">
            <text:list-level-style-number>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:for-each select="./a:lvl2pPr">
                <!--<xsl:call-template name="OutlineNumbering"></xsl:call-template>-->
              </xsl:for-each>
              <style:list-level-properties>
                <xsl:if test ="./a:lvl2pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl2pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl2pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl2pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl2pPr/@marL &lt; 0 and ./a:lvl2pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl2pPr/@marL + ./a:lvl2pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl2pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl2pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl2pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'2'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-number>
          </xsl:if>
          <xsl:if test ="a:lvl2pPr/a:buBlip">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:value-of select="'●'"/>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl2pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl2pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl2pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl2pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl2pPr/@marL &lt; 0 and ./a:lvl2pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl2pPr/@marL + ./a:lvl2pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl2pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl2pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl2pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'2'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
          <xsl:if test="not(a:lvl2pPr/a:buAutoNum) and not(a:lvl2pPr/a:buChar) and not(a:lvl2pPr/a:buBlip)">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:call-template name ="insertBulletCharacter">
                  <xsl:with-param name ="character" select ="a:lvl2pPr/a:buChar/@char" />
                </xsl:call-template>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl2pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl2pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl2pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl2pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl2pPr/@marL &lt; 0 and ./a:lvl2pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl2pPr/@marL + ./a:lvl2pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl2pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl2pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl2pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'2'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$levelNo='2'">
          <xsl:if test ="a:lvl3pPr/a:buChar">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:call-template name ="insertBulletCharacter">
                  <xsl:with-param name ="character" select ="a:lvl3pPr/a:buChar/@char" />
                </xsl:call-template>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl3pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl3pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl3pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl3pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <!--<xsl:if test ="./a:lvl3pPr/@marL">
                  <xsl:attribute name ="text:space-before">
                    <xsl:value-of select="concat(format-number( (./a:lvl3pPr/@marL + ./a:lvl3pPr/@indent) div 360000, '#.##'), 'cm')"/>
                  </xsl:attribute>
                </xsl:if>-->
                <xsl:choose>
                  <xsl:when test="./a:lvl3pPr/@marL &lt; 0 and ./a:lvl3pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl3pPr/@marL + ./a:lvl3pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl3pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl3pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl3pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'3'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
          <xsl:if test ="a:lvl3pPr/a:buAutoNum">
            <text:list-level-style-number>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:for-each select="./a:lvl3pPr">
                <!--<xsl:call-template name="OutlineNumbering"></xsl:call-template>-->
              </xsl:for-each>
              <style:list-level-properties>
                <xsl:if test ="./a:lvl3pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl3pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl3pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl3pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl3pPr/@marL &lt; 0 and ./a:lvl3pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl3pPr/@marL + ./a:lvl3pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl3pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl3pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl3pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'3'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-number>
          </xsl:if>
          <xsl:if test ="a:lvl3pPr/a:buBlip">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:value-of select="'●'"/>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl3pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl3pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl3pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl3pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl3pPr/@marL &lt; 0 and ./a:lvl3pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl3pPr/@marL + ./a:lvl3pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl3pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl3pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl3pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'3'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
          <xsl:if test="not(a:lvl3pPr/a:buAutoNum) and not(a:lvl3pPr/a:buChar) and not(a:lvl3pPr/a:buBlip)">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:call-template name ="insertBulletCharacter">
                  <xsl:with-param name ="character" select ="a:lvl3pPr/a:buChar/@char" />
                </xsl:call-template>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl3pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl3pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl3pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl3pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl3pPr/@marL &lt; 0 and ./a:lvl3pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl3pPr/@marL + ./a:lvl3pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl3pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl3pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl3pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'3'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$levelNo='3'">
          <xsl:if test ="a:lvl4pPr/a:buChar">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:call-template name ="insertBulletCharacter">
                  <xsl:with-param name ="character" select ="a:lvl4pPr/a:buChar/@char" />
                </xsl:call-template>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl4pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl4pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl4pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl4pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <!--<xsl:if test ="./a:lvl4pPr/@marL">
                  <xsl:attribute name ="text:space-before">
                    <xsl:value-of select="concat(format-number( (./a:lvl4pPr/@marL + ./a:lvl4pPr/@indent) div 360000, '#.##'), 'cm')"/>
                  </xsl:attribute>
                </xsl:if>-->
                <xsl:choose>
                  <xsl:when test="./a:lvl4pPr/@marL &lt; 0 and ./a:lvl4pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl4pPr/@marL + ./a:lvl4pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl4pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl4pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl4pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'4'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
          <xsl:if test ="a:lvl4pPr/a:buAutoNum">
            <text:list-level-style-number>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:for-each select="./a:lvl4pPr">
                <!--<xsl:call-template name="OutlineNumbering"></xsl:call-template>-->
              </xsl:for-each>
              <style:list-level-properties>
                <xsl:if test ="./a:lvl4pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl4pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl4pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl4pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl4pPr/@marL &lt; 0 and ./a:lvl4pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl4pPr/@marL + ./a:lvl4pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl4pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl4pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl4pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'4'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-number>
          </xsl:if>
          <xsl:if test ="a:lvl4pPr/a:buBlip">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:value-of select="'●'"/>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl4pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl4pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl4pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl4pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl4pPr/@marL &lt; 0 and ./a:lvl4pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl4pPr/@marL + ./a:lvl4pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl4pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl4pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl4pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'4'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
          <xsl:if test="not(a:lvl4pPr/a:buAutoNum) and not(a:lvl4pPr/a:buChar) and not(a:lvl4pPr/a:buBlip)">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:call-template name ="insertBulletCharacter">
                  <xsl:with-param name ="character" select ="a:lvl4pPr/a:buChar/@char" />
                </xsl:call-template>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl4pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl4pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl4pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl4pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl4pPr/@marL &lt; 0 and ./a:lvl4pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl4pPr/@marL + ./a:lvl4pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl4pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl4pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl4pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'4'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$levelNo='4'">
          <xsl:if test ="a:lvl5pPr/a:buChar">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:call-template name ="insertBulletCharacter">
                  <xsl:with-param name ="character" select ="a:lvl5pPr/a:buChar/@char" />
                </xsl:call-template>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl5pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl5pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl5pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl5pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <!--<xsl:if test ="./a:lvl5pPr/@marL">
                  <xsl:attribute name ="text:space-before">
                    <xsl:value-of select="concat(format-number( (./a:lvl5pPr/@marL + ./a:lvl5pPr/@indent) div 360000, '#.##'), 'cm')"/>
                  </xsl:attribute>
                </xsl:if>-->
                <xsl:choose>
                  <xsl:when test="./a:lvl5pPr/@marL &lt; 0 and ./a:lvl5pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl5pPr/@marL + ./a:lvl5pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl5pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl5pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl5pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'5'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
          <xsl:if test ="a:lvl5pPr/a:buAutoNum">
            <text:list-level-style-number>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:for-each select="./a:lvl5pPr">
                <!--<xsl:call-template name="OutlineNumbering"></xsl:call-template>-->
              </xsl:for-each>
              <style:list-level-properties>
                <xsl:if test ="./a:lvl5pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl5pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl5pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl5pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl5pPr/@marL &lt; 0 and ./a:lvl5pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl5pPr/@marL + ./a:lvl5pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl5pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl5pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl5pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'5'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-number>
          </xsl:if>
          <xsl:if test ="a:lvl5pPr/a:buBlip">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:value-of select="'●'"/>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl5pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl5pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl5pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl5pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl5pPr/@marL &lt; 0 and ./a:lvl5pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl5pPr/@marL + ./a:lvl5pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl5pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl5pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl5pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'5'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
          <xsl:if test="not(a:lvl5pPr/a:buAutoNum) and not(a:lvl5pPr/a:buChar) and not(a:lvl5pPr/a:buBlip)">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:call-template name ="insertBulletCharacter">
                  <xsl:with-param name ="character" select ="a:lvl5pPr/a:buChar/@char" />
                </xsl:call-template>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl5pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl5pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl5pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl5pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl5pPr/@marL &lt; 0 and ./a:lvl5pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl5pPr/@marL + ./a:lvl5pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl5pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl5pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl5pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'5'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$levelNo='5'">
          <xsl:if test ="a:lvl6pPr/a:buChar">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:call-template name ="insertBulletCharacter">
                  <xsl:with-param name ="character" select ="a:lvl6pPr/a:buChar/@char" />
                </xsl:call-template>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl6pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl6pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl6pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl6pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <!--<xsl:if test ="./a:lvl6pPr/@marL">
                  <xsl:attribute name ="text:space-before">
                    <xsl:value-of select="concat(format-number( (./a:lvl6pPr/@marL + ./a:lvl6pPr/@indent) div 360000, '#.##'), 'cm')"/>
                  </xsl:attribute>
                </xsl:if>-->
                <xsl:choose>
                  <xsl:when test="./a:lvl6pPr/@marL &lt; 0 and ./a:lvl6pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl6pPr/@marL + ./a:lvl6pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl6pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl6pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl6pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'6'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
          <xsl:if test ="a:lvl6pPr/a:buAutoNum">
            <text:list-level-style-number>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:for-each select="./a:lvl6pPr">
                <!--<xsl:call-template name="OutlineNumbering"></xsl:call-template>-->
              </xsl:for-each>
              <style:list-level-properties>
                <xsl:if test ="./a:lvl6pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl6pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl6pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl6pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl6pPr/@marL &lt; 0 and ./a:lvl6pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl6pPr/@marL + ./a:lvl6pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl6pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl6pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl6pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'6'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-number>
          </xsl:if>
          <xsl:if test ="a:lvl6pPr/a:buBlip">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:value-of select="'●'"/>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl6pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl6pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl6pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl6pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl6pPr/@marL &lt; 0 and ./a:lvl6pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl6pPr/@marL + ./a:lvl6pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl6pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl6pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl6pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'6'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
          <xsl:if test="not(a:lvl6pPr/a:buAutoNum) and not(a:lvl6pPr/a:buChar) and not(a:lvl6pPr/a:buBlip)">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:call-template name ="insertBulletCharacter">
                  <xsl:with-param name ="character" select ="a:lvl6pPr/a:buChar/@char" />
                </xsl:call-template>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl6pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl6pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl6pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl6pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl6pPr/@marL &lt; 0 and ./a:lvl6pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl6pPr/@marL + ./a:lvl6pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl6pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl6pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl6pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'6'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$levelNo='6'">
          <xsl:if test ="a:lvl7pPr/a:buChar">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:call-template name ="insertBulletCharacter">
                  <xsl:with-param name ="character" select ="a:lvl7pPr/a:buChar/@char" />
                </xsl:call-template>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl7pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl7pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl7pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl7pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <!--<xsl:if test ="./a:lvl7pPr/@marL">
                  <xsl:attribute name ="text:space-before">
                    <xsl:value-of select="concat(format-number( (./a:lvl7pPr/@marL + ./a:lvl7pPr/@indent) div 360000, '#.##'), 'cm')"/>
                  </xsl:attribute>
                </xsl:if>-->
                <xsl:choose>
                  <xsl:when test="./a:lvl7pPr/@marL &lt; 0 and ./a:lvl7pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl7pPr/@marL + ./a:lvl7pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl7pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl7pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl7pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'7'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
          <xsl:if test ="a:lvl7pPr/a:buAutoNum">
            <text:list-level-style-number>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:for-each select="./a:lvl7pPr">
                <!--<xsl:call-template name="OutlineNumbering"></xsl:call-template>-->
              </xsl:for-each>
              <style:list-level-properties>
                <xsl:if test ="./a:lvl7pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl7pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl7pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl7pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl7pPr/@marL &lt; 0 and ./a:lvl7pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl7pPr/@marL + ./a:lvl7pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl7pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl7pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl7pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'7'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-number>
          </xsl:if>
          <xsl:if test ="a:lvl7pPr/a:buBlip">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:value-of select="'●'"/>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl7pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl7pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl7pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl7pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl7pPr/@marL &lt; 0 and ./a:lvl7pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl7pPr/@marL + ./a:lvl7pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl7pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl7pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl7pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'7'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
          <xsl:if test="not(a:lvl7pPr/a:buAutoNum) and not(a:lvl7pPr/a:buChar) and not(a:lvl7pPr/a:buBlip)">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:call-template name ="insertBulletCharacter">
                  <xsl:with-param name ="character" select ="a:lvl7pPr/a:buChar/@char" />
                </xsl:call-template>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl7pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl7pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl7pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl7pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl7pPr/@marL &lt; 0 and ./a:lvl7pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl7pPr/@marL + ./a:lvl7pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl7pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl7pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl7pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'7'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$levelNo='7'">
          <xsl:if test ="a:lvl8pPr/a:buChar">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:call-template name ="insertBulletCharacter">
                  <xsl:with-param name ="character" select ="a:lvl8pPr/a:buChar/@char" />
                </xsl:call-template>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl8pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl8pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl8pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl8pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <!--<xsl:if test ="./a:lvl8pPr/@marL">
                  <xsl:attribute name ="text:space-before">
                    <xsl:value-of select="concat(format-number( (./a:lvl8pPr/@marL + ./a:lvl8pPr/@indent) div 360000, '#.##'), 'cm')"/>
                  </xsl:attribute>
                </xsl:if>-->
                <xsl:choose>
                  <xsl:when test="./a:lvl8pPr/@marL &lt; 0 and ./a:lvl8pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl8pPr/@marL + ./a:lvl8pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl8pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl8pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl8pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'8'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
          <xsl:if test ="a:lvl8pPr/a:buAutoNum">
            <text:list-level-style-number>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:for-each select="./a:lvl8pPr">
                <!--<xsl:call-template name="OutlineNumbering"></xsl:call-template>-->
              </xsl:for-each>
              <style:list-level-properties>
                <xsl:if test ="./a:lvl8pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl8pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl8pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl8pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl8pPr/@marL &lt; 0 and ./a:lvl8pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl8pPr/@marL + ./a:lvl8pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl8pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl8pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl8pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'8'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-number>
          </xsl:if>
          <xsl:if test ="a:lvl8pPr/a:buBlip">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:value-of select="'●'"/>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl8pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl8pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl8pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl8pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl8pPr/@marL &lt; 0 and ./a:lvl8pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl8pPr/@marL + ./a:lvl8pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl8pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl8pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl8pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'8'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
          <xsl:if test="not(a:lvl8pPr/a:buAutoNum) and not(a:lvl8pPr/a:buChar) and not(a:lvl8pPr/a:buBlip)">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:call-template name ="insertBulletCharacter">
                  <xsl:with-param name ="character" select ="a:lvl8pPr/a:buChar/@char" />
                </xsl:call-template>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl8pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl8pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl8pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl8pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl8pPr/@marL &lt; 0 and ./a:lvl8pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl8pPr/@marL + ./a:lvl8pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl8pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl8pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl8pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'8'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$levelNo='8'">
          <xsl:if test ="a:lvl9pPr/a:buChar">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:call-template name ="insertBulletCharacter">
                  <xsl:with-param name ="character" select ="a:lvl9pPr/a:buChar/@char" />
                </xsl:call-template>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl9pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl9pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl9pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl9pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <!--<xsl:if test ="./a:lvl9pPr/@marL">
                  <xsl:attribute name ="text:space-before">
                    <xsl:value-of select="concat(format-number( (./a:lvl9pPr/@marL + ./a:lvl9pPr/@indent) div 360000, '#.##'), 'cm')"/>
                  </xsl:attribute>
                </xsl:if>-->
                <xsl:choose>
                  <xsl:when test="./a:lvl9pPr/@marL &lt; 0 and ./a:lvl9pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl9pPr/@marL + ./a:lvl9pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl9pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl9pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl9pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'9'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
          <xsl:if test ="a:lvl9pPr/a:buAutoNum">
            <text:list-level-style-number>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:for-each select="./a:lvl9pPr">
                <!--<xsl:call-template name="OutlineNumbering"></xsl:call-template>-->
              </xsl:for-each>
              <style:list-level-properties>
                <xsl:if test ="./a:lvl9pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl9pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl9pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl9pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl9pPr/@marL &lt; 0 and ./a:lvl9pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl9pPr/@marL + ./a:lvl9pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl9pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl9pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl9pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'9'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-number>
          </xsl:if>
          <xsl:if test ="a:lvl9pPr/a:buBlip">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:value-of select="'●'"/>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl9pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl9pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl9pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl9pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                <xsl:choose>
                  <xsl:when test="./a:lvl9pPr/@marL &lt; 0 and ./a:lvl9pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl9pPr/@marL + ./a:lvl9pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl9pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl9pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl9pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'8'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
          <xsl:if test="not(a:lvl9pPr/a:buAutoNum) and not(a:lvl9pPr/a:buChar) and not(a:lvl9pPr/a:buBlip)">
            <text:list-level-style-bullet>
              <xsl:attribute name ="text:level">
                <xsl:value-of select ="$pos"/>
              </xsl:attribute>
              <xsl:attribute name ="text:bullet-char">
                <xsl:call-template name ="insertBulletCharacter">
                  <xsl:with-param name ="character" select ="a:lvl9pPr/a:buChar/@char" />
                </xsl:call-template>
              </xsl:attribute >
              <style:list-level-properties>
                <xsl:if test ="./a:lvl9pPr/@indent">
                  <xsl:choose>
                    <xsl:when test="./a:lvl9pPr/@indent &lt; 0">
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number((0 - ./a:lvl9pPr/@indent) div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name ="text:min-label-width">
                        <xsl:value-of select="concat(format-number(./a:lvl9pPr/@indent div 360000, '#.##'), 'cm')"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if >
                  <xsl:choose>
                  <xsl:when test="./a:lvl9pPr/@marL &lt; 0 and ./a:lvl9pPr/@indent">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number((./a:lvl9pPr/@marL + ./a:lvl9pPr/@indent) div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="./a:lvl9pPr/@marL &gt; 0 ">
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="concat(format-number(./a:lvl9pPr/@marL div 360000, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="text:space-before">
                      <xsl:value-of select="0"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </style:list-level-properties>
              <xsl:for-each select="./a:lvl9pPr">
                <xsl:call-template name="NoteOutlines">
                  <xsl:with-param name="level">
                    <xsl:value-of select="'9'"/>
                  </xsl:with-param>
                  <xsl:with-param name="blnBullet">
                    <xsl:value-of select="'true'"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </text:list-level-style-bullet>
          </xsl:if>
        </xsl:when>      
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="OutlineTen">
    <text:list-level-style-bullet text:level="10" text:bullet-char="●">
      <style:list-level-properties text:space-before="5.4cm" text:min-label-width="0.6cm" />
      <style:text-properties fo:font-family="StarSymbol" style:use-window-font-color="true" fo:font-size="45%" />
    </text:list-level-style-bullet>

  </xsl:template>
  
  <xsl:template name ="NoteOutlines">
    <xsl:param name="level"></xsl:param>
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
        <xsl:call-template name="NMParagraphStyle"/>
        <xsl:if test="$level='1'">
          <!--<xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='body']">-->
          <xsl:for-each select="./parent::node()/parent::node()/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='body']">
            <!--<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:bodyPr/@vert='vert'">-->
            <!--Added by Sanjay to get correct Text Direction:Fixed Bug no-1958740-->
            <xsl:if test="contains(parent::node()/parent::node()/p:txBody/a:bodyPr/@vert,'vert')">
              <xsl:call-template name="getTextDirection">
                <xsl:with-param name="vert" select="parent::node()/parent::node()/p:txBody/a:bodyPr/@vert"/>
              </xsl:call-template>
            </xsl:if>
            <!--End of Bug no-1958740-->
          </xsl:for-each>
        </xsl:if>
      </style:paragraph-properties>
    </xsl:if>
    <style:text-properties>
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
              <xsl:attribute name ="fo:color">
                <xsl:call-template name ="getColorCode">
                  <xsl:with-param name ="color">
                    <xsl:call-template name="NoteThemeClr">
                      <xsl:with-param name="ClrMap" select="./a:buClr/a:schemeClr/@val"/>
                    </xsl:call-template>
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
                <xsl:attribute name ="fo:color">
                  <xsl:call-template name ="getColorCode">
                    <xsl:with-param name ="color">
                      <xsl:call-template name="NoteThemeClr">
                        <xsl:with-param name="ClrMap" select="./a:defRPr/a:solidFill/a:schemeClr/@val"/>
                      </xsl:call-template>
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
                  <xsl:call-template name="MasterFontName">
                    <xsl:with-param name="fontType">
                      <xsl:value-of select="'minor'"/>
                    </xsl:with-param>
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
          <xsl:call-template name="NMShapeTextProperty">
            <xsl:with-param name="fontType" select="'minor'"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </style:text-properties>
  </xsl:template>

  <xsl:template name="NotetmpGraphicProperty">
    <xsl:param name="blnSubTitle"/>
           <xsl:call-template name="tmpSlideGrahicProp">
                 <xsl:with-param name="FileType" select="'notesMaster1'"/>
                 <xsl:with-param name="spType">
                  <xsl:value-of select="p:nvSpPr/p:nvPr/p:ph/@type"/>
            </xsl:with-param>
          </xsl:call-template>
         </xsl:template>

  <xsl:template name ="NoteLineColor">

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
          <xsl:attribute name ="svg:stroke-color">
            <xsl:call-template name ="getColorCode">
              <xsl:with-param name ="color">
                <xsl:call-template name="NoteThemeClr">
                  <xsl:with-param name="ClrMap" select="p:spPr/a:ln/a:solidFill/a:schemeClr/@val"/>
                </xsl:call-template>
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
        <xsl:if test ="not( (p:spPr/a:prstGeom/@prst='flowChartInternalStorage') or
									(p:spPr/a:prstGeom/@prst='flowChartPredefinedProcess') or
									(p:spPr/a:prstGeom/@prst='flowChartSummingJunction') or
									(p:spPr/a:prstGeom/@prst='flowChartOr') )">
          <xsl:if test ="p:style/a:lnRef">
            <xsl:attribute name ="draw:stroke">
              <xsl:value-of select="'solid'" />
            </xsl:attribute>
            <!--Standard color for border-->
            <xsl:if test ="p:style/a:lnRef/a:srgbClr/@val">
              <xsl:attribute name ="svg:stroke-color">
                <xsl:value-of select="concat('#',p:style/a:lnRef/a:srgbClr/@val)"/>
              </xsl:attribute>

              <!--Shade percentage-->
              <!--
					<xsl:if test="p:style/a:lnRef/a:srgbClr/a:shade/@val">
						<xsl:variable name ="shade">
							<xsl:value-of select ="p:style/a:lnRef/a:srgbClr/a:shade/@val"/>
						</xsl:variable>
						-->
              <!--<xsl:if test="($shade != '') or ($shade != 0)">
							<xsl:attribute name ="svg:stroke-opacity">
								<xsl:value-of select="concat(($shade div 1000), '%')"/>
							</xsl:attribute>
						</xsl:if>-->
              <!--
					</xsl:if>-->
            </xsl:if>
            <!--Theme color for border-->
            <xsl:if test ="p:style/a:lnRef/a:schemeClr/@val">
              <xsl:attribute name ="svg:stroke-color">
                <xsl:call-template name ="getColorCode">
                  <xsl:with-param name ="color">
                    <xsl:call-template name="NoteThemeClr">
                      <xsl:with-param name="ClrMap" select="p:style/a:lnRef/a:schemeClr/@val"/>
                    </xsl:call-template>
                  </xsl:with-param>
                  <xsl:with-param name ="lumMod">
                    <xsl:value-of select="p:style/a:lnRef/a:schemeClr/a:lumMod/@val"/>
                  </xsl:with-param>
                  <xsl:with-param name ="lumOff">
                    <xsl:value-of select="p:style/a:lnRef/a:schemeClr/a:lumOff/@val"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:attribute>
              <!--Shade percentage -->
              <!--<xsl:if test="p:style/a:lnRef/a:schemeClr/a:shade/@val">
						<xsl:variable name ="shade">
							<xsl:value-of select ="p:style/a:lnRef/a:schemeClr/a:shade/@val"/>
						</xsl:variable>
						-->
              <!--<xsl:if test="($shade != '') or ($shade != 0)">
							<xsl:attribute name ="svg:stroke-opacity">
								<xsl:value-of select="concat(($shade div 1000), '%')"/>
							</xsl:attribute>
						</xsl:if>-->
              <!--
					</xsl:if>-->
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name ="GraphicStyleForNotesMaster">
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
      <!--<xsl:for-each select="key('Part', concat('ppt/slideMasters/',$slideMasterPath))//p:sp">-->
      <xsl:for-each select="key('Part', 'ppt/notesMasters/notesMaster1.xml')/p:notesMaster/p:cSld/p:spTree/p:sp">
        <xsl:choose>
          <!--style for Header -->
          <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='hdr'">
            <style:style>
              <xsl:attribute name="style:name">
                <xsl:value-of select="concat($slideMasterName,'-NotesHeader')"/>
              </xsl:attribute>
              <xsl:attribute name ="style:family">
                <xsl:value-of select ="'presentation'"/>
              </xsl:attribute>
              <xsl:attribute name="style:parent-style-name">
                <xsl:value-of select="concat($slideMasterName,'-backgroundobjects')"/>
              </xsl:attribute>
              <xsl:call-template name="NoteDatePageNoFooterStyle"/>
            </style:style>
          </xsl:when>
          <!-- style for DateTime-->
          <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='dt'">
            <style:style>
              <xsl:attribute name="style:name">
                <xsl:value-of select="concat($slideMasterName,'-NotesDateTime')"/>
              </xsl:attribute>
              <xsl:attribute name ="style:family">
                <xsl:value-of select ="'presentation'"/>
              </xsl:attribute>
              <xsl:attribute name="style:parent-style-name">
                <xsl:value-of select="concat($slideMasterName,'-backgroundobjects')"/>
              </xsl:attribute>
              <xsl:call-template name="NoteDatePageNoFooterStyle"/>
            </style:style>
          </xsl:when>
          <!-- style for footer-->
          <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='ftr'">
            <style:style>
              <xsl:attribute name="style:name">
                <xsl:value-of select="concat($slideMasterName,'-Notesfooter')"/>
              </xsl:attribute>
              <xsl:attribute name ="style:family">
                <xsl:value-of select ="'presentation'"/>
              </xsl:attribute>
              <xsl:attribute name="style:parent-style-name">
                <xsl:value-of select="concat($slideMasterName,'-backgroundobjects')"/>
              </xsl:attribute>
              <xsl:call-template name="NoteDatePageNoFooterStyle"/>
            </style:style>
          </xsl:when>
          <!-- style for slideNumber-->
          <xsl:when test="p:nvSpPr/p:nvPr/p:ph/@type='sldNum'">
            <style:style>
              <xsl:attribute name="style:name">
                <xsl:value-of select="concat($slideMasterName,'-Notespageno')"/>
              </xsl:attribute>
              <xsl:attribute name ="style:family">
                <xsl:value-of select ="'presentation'"/>
              </xsl:attribute>
              <xsl:attribute name="style:parent-style-name">
                <xsl:value-of select="concat($slideMasterName,'-backgroundobjects')"/>
              </xsl:attribute>
              <xsl:call-template name="NoteDatePageNoFooterStyle"/>
            </style:style>
          </xsl:when>
          <xsl:when test = "not(p:nvSpPr/p:nvPr/p:ph/@type) and not(p:nvSpPr/p:nvPr/p:ph/@idx)">
            <!--Generate graphic properties ID-->
            <xsl:variable  name ="GraphicId">
              <xsl:value-of select ="concat($slideMasterName,concat('gr',position()))"/>
            </xsl:variable>
            <xsl:variable name ="ParaId">
              <xsl:value-of select ="concat($slideMasterName ,concat('PARA',position()))"/>
            </xsl:variable>
            <style:style style:family="graphic" style:parent-style-name="standard">
              <xsl:attribute name ="style:name">
                <xsl:value-of select ="$GraphicId"/>
              </xsl:attribute >
              <style:graphic-properties>

                <!--FILL-->
                <xsl:call-template name ="Fill" />

                <!--LINE COLOR-->
                <xsl:call-template name ="NoteLineColor" />

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
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="NoteDatePageNoFooterStyle">
    <style:graphic-properties>
      <xsl:call-template name="NotetmpGraphicProperty"/>
    </style:graphic-properties>
    <style:paragraph-properties>
     
      <xsl:for-each select="p:txBody//a:lvl1pPr">
        <xsl:call-template name="NMParagraphStyle"/>
      </xsl:for-each>
      <!--Added by Sanjay to get correct Text Direction:Fixed Bug no-1958740-->
      <xsl:if test="p:txBody/a:bodyPr/@vert">
         <xsl:call-template name="getTextDirection">
                <xsl:with-param name="vert" select="p:txBody/a:bodyPr/@vert"/>
              </xsl:call-template>
      </xsl:if>
      <!--End of Bug no-1958740-->
    </style:paragraph-properties>
   
    <xsl:for-each select="p:txBody//a:lvl1pPr">
    <style:text-properties>
        <xsl:call-template name="NMShapeTextProperty">
          <xsl:with-param name="fontType" select="'minor'"/>
        </xsl:call-template>
      </style:text-properties>
    </xsl:for-each>

  </xsl:template>
  
  <xsl:template name="NMParagraphStyle">
    <xsl:param name="lnSpcReduction"/>

    <!--Text alignment-->
    <xsl:choose>
    <xsl:when test="parent::node()/parent::node()/a:p/a:pPr/@algn">
      <xsl:attribute name ="fo:text-align">
        <xsl:choose>
          <!-- Center Alignment-->
          <xsl:when test ="parent::node()/parent::node()/a:p/a:pPr/@algn ='ctr'">
            <xsl:value-of select ="'center'"/>
          </xsl:when>
          <!-- Right Alignment-->
          <xsl:when test ="parent::node()/parent::node()/a:p/a:pPr/@algn ='r'">
            <xsl:value-of select ="'end'"/>
          </xsl:when>
          <!-- Left Alignment-->
          <xsl:when test ="parent::node()/parent::node()/a:p/a:pPr/@algn ='l'">
            <xsl:value-of select ="'start'"/>
          </xsl:when>
          <!-- Justify-->
          <xsl:when test ="parent::node()/parent::node()/a:p/a:pPr/@algn ='just'">
            <xsl:value-of select ="'justify'"/>
          </xsl:when>
        </xsl:choose>
      </xsl:attribute>
    </xsl:when>
      <xsl:when test ="@algn">
        <xsl:attribute name ="fo:text-align">
        <xsl:choose>
          <!-- Center Alignment-->
          <xsl:when test ="@algn ='ctr'">
            <xsl:value-of select ="'center'"/>
          </xsl:when>
          <!-- Right Alignment-->
          <xsl:when test ="@algn ='r'">
            <xsl:value-of select ="'end'"/>
          </xsl:when>
          <!-- Left Alignment-->
          <xsl:when test ="@algn ='l'">
            <xsl:value-of select ="'start'"/>
          </xsl:when>
          <!-- Justify-->
          <xsl:when test ="@algn ='just'">
            <xsl:value-of select ="'justify'"/>
          </xsl:when>
        </xsl:choose>
      </xsl:attribute>
      </xsl:when>
    </xsl:choose>
    <!-- Convert Left margin of the paragraph-->
    <xsl:if test ="@marL">
      <xsl:attribute name ="fo:margin-left">
        <xsl:value-of select="concat(format-number( @marL div 360000, '#.##'), 'cm')"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test ="@marR">
      <xsl:attribute name ="fo:margin-right">
        <xsl:value-of select="concat(format-number(@marR div 360000, '#.##'), 'cm')"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test ="./@indent">
      <xsl:attribute name ="fo:text-indent">
        <xsl:value-of select="concat(format-number(./@indent div 360000, '#.##'), 'cm')"/>
      </xsl:attribute>
    </xsl:if >
    <xsl:if test ="./a:defRPr/@sz">
      <xsl:variable name="var_fontsize">
        <xsl:value-of select="./a:defRPr/@sz"/>
      </xsl:variable>
      <xsl:for-each select="./a:spcBef/a:spcPct">
        <xsl:if test ="@val">
          <xsl:attribute name ="fo:margin-top">
            <xsl:value-of select="concat(format-number( (( $var_fontsize * ( @val div 100000 ) ) div 2835) * 1.2  ,'#.###'),'cm')"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="./a:spcAft/a:spcPct">
        <xsl:if test ="@val">
          <xsl:attribute name ="fo:margin-bottom">
            <xsl:value-of select="concat(format-number( (( $var_fontsize * ( @val div 100000 ) ) div 2835 ) * 1.2 ,'#.###'),'cm')"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
    <xsl:for-each select="./a:spcAft/a:spcPts">
      <xsl:if test ="@val">
        <xsl:attribute name ="fo:margin-bottom">
          <xsl:value-of select="concat(format-number(@val div  2835 ,'#.##'),'cm')"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="./a:spcBef/a:spcPts">
      <xsl:if test ="@val">
        <xsl:attribute name ="fo:margin-top">
          <xsl:value-of select="concat(format-number(@val div  2835 ,'#.##'),'cm')"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="./a:lnSpc/a:spcPct">
      <xsl:if test ="a:lnSpc/a:spcPct">
        <xsl:choose>
          <xsl:when test="$lnSpcReduction='0'">
            <xsl:attribute name="fo:line-height">
              <xsl:value-of select="concat(format-number(@val div 1000,'###'), '%')"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="fo:line-height">
              <xsl:value-of select="concat(format-number((@val - $lnSpcReduction) div 1000,'###'), '%')"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if >
    </xsl:for-each>
    <xsl:for-each select="./a:lnSpc/a:spcPts">
      <xsl:if test ="a:lnSpc/a:spcPts">
        <xsl:attribute name="style:line-height-at-least">
          <xsl:value-of select="concat(format-number(@val div 2835, '#.##'), 'cm')"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="NMShapeTextProperty">
    <xsl:param name="LayoutFileName"/>
    <xsl:param name="spType"/>
    <xsl:param name="index"/>
    <xsl:param name ="DefFont"/>
    <xsl:param name ="fontType"/>
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
    <xsl:choose>
      <xsl:when test="parent::node()/parent::node()/a:p/a:r/a:rPr/@sz">
        <xsl:attribute name ="fo:font-size"	>
          <xsl:value-of  select ="concat(format-number(parent::node()/parent::node()/a:p/a:r/a:rPr/@sz div 100,'#.##'),'pt')"/>
        </xsl:attribute>
      </xsl:when>
       <xsl:when test ="./a:defRPr/@sz">
      <xsl:attribute name ="fo:font-size"	>
        <xsl:value-of  select ="concat(format-number(./a:defRPr/@sz div 100,'#.##'),'pt')"/>
      </xsl:attribute>
    </xsl:when>
    </xsl:choose>
    <xsl:attribute name ="fo:font-family">
      <xsl:if test ="./a:defRPr/a:latin/@typeface">
        <xsl:variable name ="typeFaceVal" select ="./a:defRPr/a:latin/@typeface"/>
        <xsl:for-each select ="./a:defRPr/a:latin/@typeface">
          <xsl:if test ="$typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt'">
            <xsl:call-template name="MasterFontName">
              <xsl:with-param name="fontType">
                <xsl:value-of select="$fontType"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test ="not($typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt')">
            <xsl:value-of select ="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:if>
      <xsl:if test ="not(./a:defRPr/a:latin/@typeface)">
        <xsl:call-template name="MasterFontName">
          <xsl:with-param name="fontType">
            <xsl:value-of select="'minor'"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:attribute>
    <!-- strike style:text-line-through-style-->
    <xsl:choose>
      <xsl:when test="parent::node()/parent::node()/a:p/a:r/a:rPr/@strike">
      <xsl:attribute name ="style:text-line-through-style">
        <xsl:value-of select ="'solid'"/>
      </xsl:attribute>
      <xsl:choose >
        <xsl:when test ="parent::node()/parent::node()/a:p/a:r/a:rPr/@strike='dblStrike'">
          <xsl:attribute name ="style:text-line-through-type">
            <xsl:value-of select ="'double'"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test ="parent::node()/parent::node()/a:p/a:r/a:rPr/@strike='sngStrike'">
          <xsl:attribute name ="style:text-line-through-type">
            <xsl:value-of select ="'single'"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      </xsl:when>
      <xsl:when test="(./a:defRPr/@strike) and (./a:defRPr/@strike != 'noStrike')">
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
      </xsl:when>
    </xsl:choose>
    <!-- Kening Property-->
    <xsl:choose>
      <xsl:when test="parent::node()/parent::node()/a:p/a:r/a:rPr/@kern">
        <xsl:choose >
        <xsl:when test ="parent::node()/parent::node()/a:p/a:r/a:rPr/@kern = '0'">
          <xsl:attribute name ="style:letter-kerning">
            <xsl:value-of select ="'false'"/>
          </xsl:attribute >
        </xsl:when >
        <xsl:when test ="format-number(parent::node()/parent::node()/a:p/a:r/a:rPr/@kern,'#.##') &gt; 0">
          <xsl:attribute name ="style:letter-kerning">
            <xsl:value-of select ="'true'"/>
          </xsl:attribute >
        </xsl:when >
      </xsl:choose>
      </xsl:when>
      <xsl:when test="./a:defRPr/@kern">
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
      </xsl:when>
    </xsl:choose>
    <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:if test ="./a:defRPr/a:solidFill/a:srgbClr/@val">
      <xsl:attribute name ="fo:color">
        <xsl:value-of select ="translate(concat('#',./a:defRPr/a:solidFill/a:srgbClr/@val),$ucletters,$lcletters)"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test ="./a:defRPr/a:solidFill/a:schemeClr/@val">
      <xsl:attribute name ="fo:color">
        <xsl:call-template name ="getColorCode">
          <xsl:with-param name ="color">
            <xsl:variable name="varcolor">
              <xsl:value-of select="./a:defRPr/a:solidFill/a:schemeClr/@val"/>
            </xsl:variable>
            <xsl:for-each select="/p:notesMaster/p:clrMap">
              <xsl:call-template name="NoteThemeClr">
                <xsl:with-param name="ClrMap" select="$varcolor"/>
              </xsl:call-template>
            </xsl:for-each>
            <!--<xsl:with-param name="ClrMap" select="./a:defRPr/a:solidFill/a:schemeClr/@val"/>-->
            <!--</xsl:call-template>-->
          </xsl:with-param>
          <xsl:with-param name ="lumMod">
            <xsl:value-of select="./a:defRPr/a:solidFill/a:schemeClr/a:lumMod/@val"/>
          </xsl:with-param>
          <xsl:with-param name ="lumOff">
            <xsl:value-of select="./a:defRPr/a:solidFill/a:schemeClr/a:lumOff/@val"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="parent::node()/parent::node()/a:p/a:r/a:rPr/@b='1'">
        <xsl:attribute name ="fo:font-weight">
          <xsl:value-of select ="'bold'"/>
        </xsl:attribute>
      </xsl:when>
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
    <xsl:choose>
      <xsl:when test="parent::node()/parent::node()/a:p/a:r/a:rPr/@u">
        <xsl:for-each select ="parent::node()/parent::node()/a:p/a:r/a:rPr">
          <xsl:call-template name="NMUnderLine"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="./a:defRPr/@u">
        <xsl:for-each select ="./a:defRPr">
          <xsl:call-template name="tmpUnderLine">
            <xsl:with-param name="u" select="@u"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'none'"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <!-- Italic-->
    <xsl:choose>
      <xsl:when test="parent::node()/parent::node()/a:p/a:r/a:rPr/@i">
        <xsl:attribute name ="fo:font-style">
          <xsl:if test ="parent::node()/parent::node()/a:p/a:r/a:rPr/@i='1'">
            <xsl:value-of select ="'italic'"/>
          </xsl:if >
          <xsl:if test ="parent::node()/parent::node()/a:p/a:r/a:rPr/@i='0'">
            <xsl:value-of select ="'normal'"/>
          </xsl:if >
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="./a:defRPr/@i">
       <xsl:attribute name ="fo:font-style">
          <xsl:if test ="./a:defRPr/@i='1'">
            <xsl:value-of select ="'italic'"/>
          </xsl:if >
          <xsl:if test ="./a:defRPr/@i='0'">
            <xsl:value-of select ="'normal'"/>
          </xsl:if >
       </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name ="fo:font-style">
           <xsl:value-of select ="'normal'"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <!-- Character Spacing -->
    <xsl:choose>
      <xsl:when test="parent::node()/parent::node()/a:p/a:r/a:rPr/@spc">
        <xsl:attribute name ="fo:letter-spacing">
          <xsl:variable name="length" select="./a:defRPr/@spc" />
          <xsl:value-of select="concat(format-number($length * 2.54 div 7200,'#.###'),'cm')"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="./a:defRPr/@spc">
        <xsl:attribute name ="fo:letter-spacing">
          <xsl:variable name="length" select="./a:defRPr/@spc" />
          <xsl:value-of select="concat(format-number($length * 2.54 div 7200,'#.###'),'cm')"/>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="NoteInsertBulletChar">
    <xsl:param name="character" />
    <xsl:choose>

      <xsl:when test="$character = 'à'">➔</xsl:when>
      <xsl:when test="$character = '§'">■</xsl:when>
      <xsl:when test="$character = 'q'">•</xsl:when>
      <xsl:when test="$character = '•'">•</xsl:when>
      <xsl:when test="$character = 'v'">●</xsl:when>
      <xsl:when test="$character = 'Ø'">➢</xsl:when>
      <xsl:when test="$character = 'ü'">✔</xsl:when>
      <xsl:when test="$character = 'o'">○</xsl:when>
      <xsl:when test="$character = '-'">–</xsl:when>
      <xsl:when test="$character = '»'">»</xsl:when>
      <xsl:otherwise>•</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="NoteThemeClr">
    <xsl:param name="ClrMap"/>
    <xsl:for-each select="/p:notesMaster/p:clrMap">
      <xsl:choose>
        <xsl:when test="$ClrMap ='tx1'">
          <xsl:value-of select="@tx1" />
        </xsl:when>
        <xsl:when test="$ClrMap ='tx2'">
          <xsl:value-of select="@tx2" />
        </xsl:when>
        <xsl:when test="$ClrMap ='dk2'">
          <xsl:value-of select="@dk2" />
        </xsl:when>
        <xsl:when test="$ClrMap ='dk1'">
          <xsl:value-of select="@dk1" />
        </xsl:when>
        <xsl:when test="$ClrMap ='lt1'">
          <xsl:value-of select="@lt1" />
        </xsl:when>
        <xsl:when test="$ClrMap ='lt2'">
          <xsl:value-of select="@lt2" />
        </xsl:when>
        <xsl:when test="$ClrMap ='bg1'">
          <xsl:value-of select="@bg1" />
        </xsl:when>
        <xsl:when test="$ClrMap ='bg2'">
          <xsl:value-of select="@bg2" />
        </xsl:when>
        <xsl:when test="$ClrMap ='accent1'">
          <xsl:value-of select="@accent1" />
        </xsl:when>
        <xsl:when test="$ClrMap ='accent2'">
          <xsl:value-of select="@accent2" />
        </xsl:when>
        <xsl:when test="$ClrMap ='accent3'">
          <xsl:value-of select="@accent3" />
        </xsl:when>
        <xsl:when test="$ClrMap ='accent4'">
          <xsl:value-of select="@accent4" />
        </xsl:when>
        <xsl:when test="$ClrMap ='accent5'">
          <xsl:value-of select="@accent5" />
        </xsl:when>
        <xsl:when test="$ClrMap ='accent6'">
          <xsl:value-of select="@accent6" />
        </xsl:when>
        <xsl:when test="$ClrMap ='hlink'">
          <xsl:value-of select="@hlink" />
        </xsl:when>
        <xsl:when test="$ClrMap ='folHlink'">
          <xsl:value-of select="@folHlink" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$ClrMap" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name ="MasterFontName">
    <xsl:param name ="fontType" />
    <xsl:choose >
      <xsl:when test ="$fontType ='major'">
        <xsl:value-of select ="key('Part', 'ppt/theme/theme1.xml')/a:theme/a:themeElements/a:fontScheme/a:majorFont/a:latin/@typeface"/>
      </xsl:when>
      <xsl:when test ="$fontType ='minor'">
        <xsl:value-of select ="key('Part', 'ppt/theme/theme1.xml')/a:theme/a:themeElements/a:fontScheme/a:minorFont/a:latin/@typeface"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="NMUnderLine">
    <xsl:if test ="./a:uFill/a:solidFill/a:srgbClr/@val">
      <xsl:attribute name ="style:text-underline-color">
        <xsl:value-of select ="concat('#',./a:uFill/a:solidFill/a:srgbClr/@val)"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test ="./a:uFill/a:solidFill/a:schemeClr/@val">
      <xsl:attribute name ="style:text-underline-color">
        <xsl:call-template name ="getColorCode">
          <xsl:with-param name ="color">
            <xsl:value-of select="./a:uFill/a:solidFill/a:schemeClr/@val"/>
          </xsl:with-param>
          <xsl:with-param name ="lumMod">
            <xsl:value-of select="./a:uFill/a:solidFill/a:schemeClr/a:lumMod/@val"/>
          </xsl:with-param>
          <xsl:with-param name ="lumOff">
            <xsl:value-of select="./a:uFill/a:solidFill/a:schemeClr/a:lumOff/@val"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>
    </xsl:if>
    <xsl:choose >
      <xsl:when test ="./@u='dbl'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'solid'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-type">
          <xsl:value-of select ="'double'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'auto'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="./@u='heavy'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'solid'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'bold'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="./@u='dotted'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'dotted'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'auto'"/>
        </xsl:attribute>
      </xsl:when>
      <!-- dottedHeavy-->
      <xsl:when test ="./@u='dottedHeavy'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'dotted'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'bold'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="./@u='dash'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'dash'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'auto'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="./@u='dashHeavy'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'dash'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'bold'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="./@u='dashLong'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'long-dash'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'auto'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="./@u='dashLongHeavy'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'long-dash'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'bold'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="./@u='dotDash'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'dot-dash'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'auto'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="./@u='dotDashHeavy'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'dot-dash'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'bold'"/>
        </xsl:attribute>
      </xsl:when>
      <!-- dot-dot-dash-->
      <xsl:when test ="./@u='dotDotDash'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'dot-dot-dash'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'auto'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="./@u='dotDotDashHeavy'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'dot-dot-dash'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'bold'"/>
        </xsl:attribute>
      </xsl:when>
      <!-- Wavy and Heavy-->
      <xsl:when test ="./@u='wavy'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'wave'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'auto'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="./@u='wavyHeavy'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'wave'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'bold'"/>
        </xsl:attribute>
      </xsl:when>
      <!-- wavyDbl-->
      <!-- style:text-underline-style="wave" style:text-underline-type="double"-->
      <xsl:when test ="./@u='wavyDbl'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'wave'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-type">
          <xsl:value-of select ="'double'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'auto'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="./@u='sng'">
        <xsl:attribute name ="style:text-underline-type">
          <xsl:value-of select ="'single'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'auto'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="./@u='none'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'none'"/>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>