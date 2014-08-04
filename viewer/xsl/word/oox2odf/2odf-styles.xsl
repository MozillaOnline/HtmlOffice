<?xml version="1.0" encoding="UTF-8" ?>
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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
  xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
  xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
  xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
  xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
  xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
  xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
  xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
  xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
  xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
  xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:pcut="urn:cleverage:xmlns:post-processings:pcut" xmlns:v="urn:schemas-microsoft-com:vml"
  xmlns:oox="urn:oox"
  xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships"
  xmlns:manifest="urn:oasis:names:tc:opendocument:xmlns:manifest:1.0"
  exclude-result-prefixes="w r wp v oox rels">

  <xsl:import href="2odf-footnotes.xsl"/>
  <xsl:key name="StyleId" match="w:style" use="@w:styleId"/>
  <xsl:key name="ParagraphsByStyleId" match="/oox:package/oox:part[@oox:name = 'word/document.xml']/w:document/w:body/w:p/w:pPr/w:tabs/w:tab" use="../../w:pStyle/@w:val" />
  <xsl:key name="default-styles" match="w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on']" use="@w:type"/>

  <!-- 
  *************************************************************************
  GLOBAL VARIABLES
  *************************************************************************
  -->

  <xsl:variable name="pm1" select="concat('PAGE', generate-id(key('Part', 'word/document.xml')/w:document/w:body/w:sectPr))"/>

  <!-- global variable to warn if document is number (retrieve numbering when necessary -->
  <xsl:variable name="lines-are-numbered">
    <xsl:for-each select="key('Part', 'word/document.xml')">
      <xsl:choose>
        <xsl:when test="key('sectPr', '')/w:lnNumType">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:variable>

  <!-- 
  *************************************************************************
  MATCHING TEMPLATES
  *************************************************************************
  -->

  <!-- spacing before/after and line spacing -->
  <!-- Can came from style.xml or document.xml-->
  <xsl:template match="w:spacing" mode="pPrChildren">

    <!--fo:margin-top and bottom must be defined together (ODF 1.1 Spec.)-->
    <!--if only one is set we must get the other in hierarchy style-->
    <xsl:variable name="parentStyle" select="parent::node()/parent::node()/w:basedOn/@w:val"/>
    <xsl:variable name="NodeStyleId" select="parent::node()/parent::node()/@w:styleId"/>
    <xsl:variable name="NodeStyleFromContent" select="parent::node()/w:pStyle/@w:val"/>

    <!--/@w:styleId-->
    <!--if name of parent:parent node is w:style or w:p -->
    <xsl:choose>
      <xsl:when test="ancestor::w:style">
        <xsl:choose>
          <xsl:when test="count(@w:before)=0 and count(@w:after)=0">
            <!--Nothing to do the parent style is well defined-->
          </xsl:when>
          <xsl:when test="count(@w:before)=1 and count(@w:after)=0">
            <!--Retrieve w:after from hierarchy styles  -->
            <xsl:variable name="foMarginBottomToWrite">
              <xsl:call-template name="getMarginBottomForParagraph">
                <xsl:with-param name="StyleParagraphId" select="$NodeStyleId"/>
                <xsl:with-param name="documentParagraphWAfter" select="@w:after"/>
              </xsl:call-template>
            </xsl:variable>
            <!--Write the margins-->
            <xsl:call-template name="setFoMarginTop">
              <xsl:with-param name="setParagraphWBefore" select="@w:before"/>
            </xsl:call-template>
            <xsl:call-template name="setFoMarginBottom">
              <xsl:with-param name="setParagraphWAfter" select="$foMarginBottomToWrite"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="count(@w:before)=0 and count(@w:after)=1">
            <!--Retrieve w:after from hierarchy styles  -->
            <xsl:variable name="foMarginTopToWrite">
              <xsl:call-template name="getMarginTopForParagraph">
                <xsl:with-param name="StyleParagraphId" select="$NodeStyleId"/>
                <xsl:with-param name="documentParagraphWBefore" select="@w:before"/>
              </xsl:call-template>
            </xsl:variable>

            <!--Write the margins-->
            <xsl:call-template name="setFoMarginTop">
              <xsl:with-param name="setParagraphWBefore" select="$foMarginTopToWrite"/>
            </xsl:call-template>

            <xsl:call-template name="setFoMarginBottom">
              <xsl:with-param name="setParagraphWAfter" select="@w:after"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="count(@w:before)=1 and count(@w:after)=1">
            <xsl:call-template name="setFoMarginTop">
              <xsl:with-param name="setParagraphWBefore" select="@w:before"/>
            </xsl:call-template>

            <xsl:call-template name="setFoMarginBottom">
              <xsl:with-param name="setParagraphWAfter" select="@w:after"/>
            </xsl:call-template>

          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="ancestor::w:p">
        <xsl:choose>
          <xsl:when test="count(@w:before)=0 and count(@w:after)=0">
            <!--Nothing to do the parent style is well defined-->
          </xsl:when>
          <xsl:when test="count(@w:before)=1 and count(@w:after)=0">
            <!--Retrieve w:after from hierarchy styles  -->
            <xsl:variable name="foMarginBottomToWrite">
              <xsl:call-template name="getMarginBottomForParagraph">
                <xsl:with-param name="StyleParagraphId" select="$NodeStyleFromContent"/>
                <!--<xsl:with-param name="documentParagraphWAfter" select="@w:after"/>-->
              </xsl:call-template>
            </xsl:variable>
            <!--Write the margins-->
            <xsl:call-template name="setFoMarginTop">
              <xsl:with-param name="setParagraphWBefore" select="@w:before"/>
            </xsl:call-template>
            <xsl:call-template name="setFoMarginBottom">
              <xsl:with-param name="setParagraphWAfter" select="$foMarginBottomToWrite"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="count(@w:before)=0 and count(@w:after)=1">
            <!--Retrieve w:after from hierarchy styles  -->
            <xsl:variable name="foMarginTopToWrite">
              <xsl:call-template name="getMarginTopForParagraph">
                <xsl:with-param name="StyleParagraphId" select="$NodeStyleFromContent"/>
                <!--<xsl:with-param name="documentParagraphWBefore" select="@w:before"/>-->
              </xsl:call-template>
            </xsl:variable>
            <!--Write the margins-->
            <xsl:call-template name="setFoMarginTop">
              <xsl:with-param name="setParagraphWBefore" select="$foMarginTopToWrite"/>
            </xsl:call-template>
            <xsl:call-template name="setFoMarginBottom">
              <xsl:with-param name="setParagraphWAfter" select="@w:after"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="count(@w:before)=1 and count(@w:after)=1">
            <xsl:call-template name="setFoMarginTop">
              <xsl:with-param name="setParagraphWBefore" select="@w:before"/>
            </xsl:call-template>
            <xsl:call-template name="setFoMarginBottom">
              <xsl:with-param name="setParagraphWAfter" select="@w:after"/>
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!--Come from Default Style (OOX-wpPrDefault)-->
        <!-- spacing before/after -->
        <xsl:call-template name="setFoMarginTop">
          <xsl:with-param name="setParagraphWBefore" select="@w:before"/>
        </xsl:call-template>

        <xsl:call-template name="setFoMarginBottom">
          <xsl:with-param name="setParagraphWAfter" select="@w:after"/>
        </xsl:call-template>
      </xsl:otherwise>

    </xsl:choose>

    <!-- line spacing -->
    <xsl:if test="@w:line">
      <xsl:choose>
        <xsl:when test="@w:lineRule='atLeast'">
          <xsl:attribute name="style:line-height-at-least">
            <xsl:value-of select="concat(@w:line * 2.54 div 1440.0, 'cm')" />
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="@w:lineRule='exact'">
          <xsl:attribute name="fo:line-height">
            <xsl:value-of select="concat(@w:line * 2.54 div 1440.0, 'cm')" />
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <!-- value of lineRule is 'auto' -->
          <xsl:attribute name="fo:line-height">
            <!-- convert 240th of line to percent -->
            <xsl:value-of select="concat(@w:line div 240 * 100,'%')"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- text:align -->
  <xsl:template match="w:jc" mode="pPrChildren">
    <xsl:attribute name="fo:text-align">
      <xsl:choose>
        <xsl:when test="@w:val='center'">center</xsl:when>
        <xsl:when test="@w:val='left'">
          <xsl:choose>
            <xsl:when test="parent::w:pPr/w:bidi and not(parent::w:pPr/w:bidi[@w:val = 'off' ] or parent::w:pPr/w:bidi[@w:val = '0' ])">end</xsl:when>
            <xsl:otherwise>start</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="@w:val='right'">
          <xsl:choose>
            <xsl:when test="parent::w:pPr/w:bidi and not(parent::w:pPr/w:bidi[@w:val = 'off' ] or parent::w:pPr/w:bidi[@w:val = '0' ])">start</xsl:when>
            <xsl:otherwise>end</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="@w:val='both' or @w:val='distribute'">justify</xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="parent::w:pPr/w:bidi and not(parent::w:pPr/w:bidi[@w:val = 'off' ] or parent::w:pPr/w:bidi[@w:val = '0' ])">end</xsl:when>
            <xsl:otherwise>start</xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!-- vertical alignment of text -->
  <xsl:template match="w:textAlignment" mode="pPrChildren">
    <xsl:attribute name="style:vertical-align">
      <xsl:choose>
        <xsl:when test="@w:val='bottom'">
          <xsl:value-of select="'bottom'"/>
        </xsl:when>
        <xsl:when test="@w:val='top'">
          <xsl:value-of select="'top'"/>
        </xsl:when>
        <xsl:when test="@w:val='center'">
          <xsl:value-of select="'middle'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'auto'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!-- snap to grid -->
  <xsl:template match="w:snapToGrid" mode="pPrChildren">
    <xsl:attribute name="style:snap-to-layout-grid">
      <xsl:choose>
        <xsl:when test="@w:val='off' or @w:val='false' or @w:val=0">
          <xsl:value-of select="'false'"/>
        </xsl:when>
        <xsl:when test="@w:val='on' or @w:val='true' or @w:val=1">
          <xsl:value-of select="'true'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'true'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!-- suppress line numbering -->
  <xsl:template match="w:suppressLineNumbers" mode="pPrChildren">
    <xsl:attribute name="text:number-lines">
      <xsl:choose>
        <xsl:when test="@w:val='off' or @w:val='false' or @w:val=0">
          <xsl:value-of select="'true'"/>
        </xsl:when>
        <xsl:when test="@w:val='on' or @w:val='true' or @w:val=1">
          <xsl:value-of select="'false'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'false'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="w:overflowPunct" mode="pPrChildren">
    <xsl:attribute name="style:punctuation-wrap">
      <xsl:choose>
        <xsl:when test="@w:val='off' or @w:val='false' or @w:val=0">hanging</xsl:when>
        <xsl:when test="@w:val='on' or @w:val='true' or @w:val=1">simple</xsl:when>
        <xsl:otherwise>simple</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!-- text direction. btLr and tbLrV directions are lost. -->
  <xsl:template match="w:textDirection" mode="pPrChildren">
    <xsl:attribute name="style:writing-mode">
      <xsl:choose>
        <xsl:when test="@w:val='lrTb'">lr-tb</xsl:when>
        <xsl:when test="@w:val='lrTbV'">lr-tb</xsl:when>
        <xsl:when test="@w:val='tbRl'">rl-tb</xsl:when>
        <xsl:when test="@w:val='tbRlV'">tb-rl</xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!-- outline -->
  <xsl:template match="w:outline" mode="rPrChildren">
    <xsl:attribute name="style:text-outline">
      <xsl:choose>
        <xsl:when test="@w:val='off' or @w:val='false' or @w:val=0">false</xsl:when>
        <xsl:when test="@w:val='on' or @w:val='true' or @w:val=1">true</xsl:when>
        <xsl:otherwise>true</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!-- text shadow -->
  <xsl:template match="w:shadow" mode="rPrChildren">
    <xsl:attribute name="fo:text-shadow">
      <xsl:choose>
        <xsl:when test="@w:val='off' or @w:val='false' or @w:val=0">none</xsl:when>
        <xsl:when test="@w:val='on' or @w:val='true' or @w:val=1">#000000 0.2em 0.2em</xsl:when>
        <xsl:otherwise>#000000 0.2em 0.2em</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!-- text imprint -->
  <xsl:template match="w:imprint" mode="rPrChildren">
    <xsl:attribute name="style:font-relief">engraved</xsl:attribute>
  </xsl:template>

  <!-- text emboss -->
  <xsl:template match="w:emboss" mode="rPrChildren">
    <xsl:attribute name="style:font-relief">embossed</xsl:attribute>
  </xsl:template>

  <!-- text hiddent -->
  <xsl:template match="w:vanish" mode="rPrChildren">
    <!-- TODO: w:vanish is a toggle property. This needs to be handled correctly. -->
    <xsl:attribute name="text:display">
      <xsl:choose>
        <xsl:when test="@w:val = 0">true</xsl:when>
        <xsl:otherwise>none</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="w:em" mode="rPrChildren">
    <xsl:attribute name="style:text-emphasize">
      <xsl:choose>
        <xsl:when test="@w:val = 'circle'">circle above</xsl:when>
        <xsl:when test="@w:val = 'comma'">accent above</xsl:when>
        <xsl:when test="@w:val = 'dot'">dot above</xsl:when>
        <xsl:when test="@w:val = 'underDot'">dot below</xsl:when>
        <xsl:when test="@w:val = 'none'">none</xsl:when>
        <xsl:otherwise>none</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!-- text bg color -->
  <xsl:template match="w:highlight" mode="rPrChildren">
    <xsl:attribute name="fo:background-color">
      <xsl:choose>
        <xsl:when test="@w:val = 'black'">#000000</xsl:when>
        <xsl:when test="@w:val = 'blue'">#0000FF</xsl:when>
        <xsl:when test="@w:val = 'cyan'">#00FFFF</xsl:when>
        <xsl:when test="@w:val = 'darkBlue'">#000080</xsl:when>
        <xsl:when test="@w:val = 'darkCyan'">#008080</xsl:when>
        <xsl:when test="@w:val = 'darkGray'">#808080</xsl:when>
        <xsl:when test="@w:val = 'darkGreen'">#008000</xsl:when>
        <xsl:when test="@w:val = 'darkMagenta'">#800080</xsl:when>
        <xsl:when test="@w:val = 'darkRed'">#800000</xsl:when>
        <xsl:when test="@w:val = 'darkYellow'">#808000</xsl:when>
        <xsl:when test="@w:val = 'green'">#00FF00</xsl:when>
        <xsl:when test="@w:val = 'lightGray'">#C0C0C0</xsl:when>
        <xsl:when test="@w:val = 'magenta'">#FF00FF</xsl:when>
        <xsl:when test="@w:val = 'red'">#FF0000</xsl:when>
        <xsl:when test="@w:val = 'white'">#FFFFFF</xsl:when>
        <xsl:when test="@w:val = 'yellow'">#FFFF00</xsl:when>
        <xsl:when test="@w:val = 'none'">transparent</xsl:when>
        <xsl:otherwise>transparent</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!-- underline -->
  <xsl:template match="w:u" mode="rPrChildren">
    <xsl:call-template name="InsertUnderline"/>
  </xsl:template>

  <!-- fonts -->
  <xsl:template match="w:rFonts" mode="rPrChildren">
    <xsl:choose>
      <xsl:when test="ancestor::node()/w:style[@w:type='paragraph' and @w:default='1']/w:rPr/w:rFonts/@w:ascii">
        <xsl:attribute name="style:font-name">
          <xsl:value-of select="ancestor::node()/w:style[@w:type='paragraph' and @w:default='1']/w:rPr/w:rFonts/@w:ascii" />
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="@w:asciiTheme">
          <xsl:attribute name="style:font-name">
            <xsl:call-template name="ComputeThemeFontName">
              <xsl:with-param name="fontTheme" select="@w:asciiTheme"/>
              <xsl:with-param name="fontType">a:latin</xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@w:ascii">
      <xsl:attribute name="style:font-name">
        <xsl:value-of select="@w:ascii"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@w:cstheme">
      <xsl:attribute name="style:font-name-complex">
        <xsl:call-template name="ComputeThemeFontName">
          <xsl:with-param name="fontTheme" select="@w:cstheme"/>
          <xsl:with-param name="fontType">a:cs</xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@w:cs">
      <xsl:attribute name="style:font-name-complex">
        <xsl:value-of select="@w:cs"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@w:eastAsiaTheme">
      <xsl:attribute name="style:font-name-asian">
        <xsl:call-template name="ComputeThemeFontName">
          <xsl:with-param name="fontTheme" select="@w:eastAsiaTheme"/>
          <xsl:with-param name="fontType">a:ea</xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@w:eastAsia">
      <xsl:attribute name="style:font-name-asian">
        <xsl:value-of select="@w:eastAsia"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- text color -->
  <xsl:template match="w:color" mode="rPrChildren">
    <xsl:if test="@w:val != 'auto'">
      <xsl:attribute name="fo:color">
        <xsl:value-of select="concat('#',@w:val)"/>
      </xsl:attribute>
    </xsl:if>
    <!--auto text color-->
    <xsl:if test="@w:val = 'auto'">
      <xsl:attribute name="style:use-window-font-color">true</xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- letter spacing -->
  <xsl:template match="w:spacing" mode="rPrChildren">
    <xsl:attribute name="fo:letter-spacing">
      <xsl:choose>
        <!--ignore when in field because they can have it's own letter spacing properties see: InsertFieldProperties -->
        <xsl:when test="ancestor::w:r/w:instrText or ancestor::w:r/parent::w:fldSimple"/>
        <xsl:when test="@w:val=0 or not(@w:val)">normal</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(@w:val  * 2.54 div 1440.0, 'cm')" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!-- text scale -->
  <xsl:template match="w:w[@w:val]" mode="rPrChildren">
    <xsl:attribute name="style:text-scale">
      <xsl:value-of select="@w:val"/>
    </xsl:attribute>
  </xsl:template>

  <!-- letter kerning -->
  <xsl:template match="w:kern" mode="rPrChildren">
    <xsl:attribute name="style:letter-kerning">true</xsl:attribute>
  </xsl:template>

  <!-- font size -->
  <xsl:template match="w:sz" mode="rPrChildren-dropcap-forbidden">
    <xsl:variable name="fontSize">
      <xsl:call-template name="ConvertHalfPoints">
        <xsl:with-param name="length" select="@w:val"/>
        <xsl:with-param name="unit">pt</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <!-- do not insert this property into drop cap text style -->
    <xsl:attribute name="fo:font-size">
      <xsl:value-of select="$fontSize"/>
    </xsl:attribute>

    <!-- 
    makz: for asian fonts write the asian attribute too 
    Fix bug #1791505 
    -->
    <xsl:if test="../w:rFonts/@w:hint='eastAsia' or ../w:rFonts/@w:eastAsia">
      <xsl:attribute name="style:font-size-asian">
        <xsl:value-of select="$fontSize"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template match="w:szCs" mode="rPrChildren">
    <xsl:attribute name="style:font-size-complex">
      <xsl:call-template name="ConvertHalfPoints">
        <xsl:with-param name="length" select="@w:val"/>
        <xsl:with-param name="unit">pt</xsl:with-param>
      </xsl:call-template>
    </xsl:attribute>
  </xsl:template>

  <!-- languages and countries -->
  <xsl:template match="w:lang" mode="rPrChildren">
    <xsl:if test="@w:val">
      <xsl:attribute name="fo:language">
        <xsl:value-of select="substring-before(@w:val,'-')"/>
      </xsl:attribute>
      <xsl:attribute name="fo:country">
        <xsl:value-of select="substring-after(@w:val,'-')"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@w:bidi">
      <xsl:attribute name="style:language-complex">
        <xsl:value-of select="substring-before(@w:bidi,'-')"/>
      </xsl:attribute>
      <xsl:attribute name="style:country-complex">
        <xsl:value-of select="substring-after(@w:bidi,'-')"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@w:eastAsia">
      <xsl:attribute name="style:language-asian">
        <xsl:value-of select="substring-before(@w:eastAsia,'-')"/>
      </xsl:attribute>
      <xsl:attribute name="style:country-asian">
        <xsl:value-of select="substring-after(@w:eastAsia,'-')"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- text east asian layout -->
  <xsl:template match="w:eastAsianLayout" mode="rPrChildren">
    <xsl:if test="@w:combine = 'lines'">
      <xsl:attribute name="style:text-combine">lines</xsl:attribute>
      <xsl:choose>
        <xsl:when test="parent::w:rPr/w:combineBrackets = 'angle'">
          <xsl:attribute name="style:text-combine-start-char">
            <xsl:value-of select="'&lt;'"/>
          </xsl:attribute>
          <xsl:attribute name="style:text-combine-end-char">
            <xsl:value-of select="'&gt;'"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="parent::w:rPr/w:combineBrackets = 'curly'">
          <xsl:attribute name="style:text-combine-start-char">{</xsl:attribute>
          <xsl:attribute name="style:text-combine-end-char">}</xsl:attribute>
        </xsl:when>
        <xsl:when test="parent::w:rPr/w:combineBrackets = 'round'">
          <xsl:attribute name="style:text-combine-start-char">(</xsl:attribute>
          <xsl:attribute name="style:text-combine-end-char">)</xsl:attribute>
        </xsl:when>
        <xsl:when test="parent::w:rPr/w:combineBrackets = 'square'">
          <xsl:attribute name="style:text-combine-start-char">[</xsl:attribute>
          <xsl:attribute name="style:text-combine-end-char">]</xsl:attribute>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- script type -->
  <xsl:template match="w:cs" mode="rPrChildren">
    <xsl:if test="@w:val='on' or @w:val='true' or @w:val=1 or not(w:cs/@w:val) or w:cs/@w:val = '' ">
      <xsl:attribute name="style:script-type">complex</xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- text effect. Mostly lost. -->
  <xsl:template match="w:effect" mode="rPrChildren">
    <xsl:if test="@w:val='blinkBackground'">
      <xsl:attribute name="style:text-blinking">true</xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- create styles -->
  <xsl:template match="w:style[@w:type != 'numbering' ]">
    <xsl:message terminate="no">progress:w:style</xsl:message>

    <xsl:variable name="currentStyleId" select="@w:styleId"/>

    <!--math: Added for bugfix #1934315 START-->
    <xsl:variable name="isDefaultTOCStyle">
      <xsl:call-template name ="CheckDefaultTOCStyle">
        <xsl:with-param name="name">
          <xsl:value-of select="$currentStyleId" />
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <!--math: Added for bugfix #1934315 END-->

    <xsl:choose>
      <!-- do not add anchor and symbol styles if they are there already-->
      <xsl:when
			  test="(
        ($currentStyleId='FootnoteReference' or $currentStyleId='EndnoteReference')
        and key('StyleId', concat(substring-before($currentStyleId,'Reference'),'_20_anchor'))
        ) or (
        ($currentStyleId='FootnoteText' or $currentStyleId='EndnoteText')
        and key('StyleId', concat(substring-before($currentStyleId,'Text'),'_20_Symbol')) )" />


      <!--math: bugfix #1934315 START-->
      <!--<xsl:when test="contains($currentStyleId,'TOC')">-->
      <xsl:when test="$isDefaultTOCStyle = 'true'">
        <style:style style:name="{concat('ooc-NCNameFromString', '-oop-', concat('Contents ',substring-after($currentStyleId,'TOC')), '-ooe')}"
                     style:display-name="{concat('Contents ', normalize-space(substring-after(self::node()/w:name/@w:val,'toc')))}">

          <xsl:call-template name="InsertStyleFamily"/>
          <xsl:if test="w:basedOn">
            <xsl:attribute name="style:parent-style-name">
              <xsl:call-template name="TocToContent">
                <xsl:with-param name="styleValue">
                  <xsl:value-of select="w:basedOn/@w:val"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:attribute>
          </xsl:if>
          <xsl:call-template name="InsertStyleProperties"/>
        </style:style>
      </xsl:when>
      <xsl:otherwise>
        <style:style style:name="{concat('ooc-NCNameFromString', '-oop-', $currentStyleId, '-ooe')}">

          <xsl:if test="w:name/@w:val != '' ">
            <xsl:attribute name="style:display-name">
              <xsl:choose>
                <!-- change display name for: heading to Heading to avoid duplicate styles (Heading 1-9 are added by default by  OO)-->
                <xsl:when test="contains(w:name/@w:val, 'heading')">
                  <xsl:value-of select="translate(w:name/@w:val,'h','H')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="w:name/@w:val"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </xsl:if>
          <xsl:call-template name="InsertStyleFamily"/>
          <xsl:if test="w:basedOn/@w:val != '' ">
            <xsl:attribute name="style:parent-style-name">
              <xsl:call-template name="TocToContent">
                <xsl:with-param name="styleValue">
                  <xsl:value-of select="w:basedOn/@w:val"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="w:next/@w:val != '' ">
            <xsl:attribute name="style:next-style-name">
              <xsl:call-template name="TocToContent">
                <xsl:with-param name="styleValue">
                  <xsl:value-of select="w:next/@w:val"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:attribute>
          </xsl:if>

          <!--math, dialogika: added for bugfix #1802258 BEGIN -->
          <xsl:variable name="IsDefaultHeading">
            <xsl:call-template name="CheckDefaultHeading">
              <xsl:with-param name="Name">
                <xsl:value-of select="w:name/@w:val" />
              </xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <!--math, dialogika: added for bugfix #1802258 END -->

          <xsl:choose>
            <!--Begin part responsible for numbering paragrafs -->
            <!--math, dialogika: changed for bugfix #1802258 BEGIN -->
            <xsl:when test="w:pPr/w:outlineLvl/@w:val&lt;9 and $IsDefaultHeading='true'">
              <!--<xsl:when test="w:pPr/w:outlineLvl/@w:val&lt;9 and contains($currentStyleId,'Heading')">-->
              <!--math, dialogika: changed for bugfix #1802258 END -->
              <xsl:attribute name="style:default-outline-level">
                <xsl:value-of select="number(w:pPr/w:outlineLvl/@w:val)+1"/>
              </xsl:attribute>
            </xsl:when>
            <!--<xsl:otherwise>
              <xsl:if test="w:basedOn">
                <xsl:variable name="parentStyle">
                  <xsl:value-of select="w:basedOn/@w:val"/>
                </xsl:variable>
                <xsl:if test="ancestor::node()/w:style[@w:styleId=$parentStyle]/w:pPr/w:outlineLvl/@w:val&lt;9">
                  <xsl:attribute name="style:default-outline-level">
                    <xsl:value-of select="number(ancestor::node()/w:style[@w:styleId=$parentStyle]/w:pPr/w:outlineLvl/@w:val)+1" />
                  </xsl:attribute>
                </xsl:if>
              </xsl:if>
            </xsl:otherwise>-->
          </xsl:choose>
          <!--End part responsible for numbering paragrafs-->
          <xsl:call-template name="InsertStyleProperties"/>
        </style:style>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- avoid inserting text in paragraph properties -->
  <xsl:template match="w:t" mode="pPrChildren">
    <xsl:apply-templates mode="automaticstyles"/>
  </xsl:template>

  <xsl:template match="w:keepNext" mode="pPrChildren">
    <xsl:attribute name="fo:keep-with-next">
      <xsl:choose>
        <xsl:when test="@w:val='off' or @w:val='false' or @w:val=0">
          <xsl:value-of select="'auto'"/>
        </xsl:when>
        <xsl:when test="@w:val='on' or @w:val='true' or @w:val=1">
          <xsl:value-of select="'always'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'always'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="w:keepLines" mode="pPrChildren">
    <xsl:attribute name="fo:keep-together">
      <xsl:choose>
        <xsl:when test="@w:val='off' or @w:val='false' or @w:val=0">
          <xsl:value-of select="'auto'"/>
        </xsl:when>
        <xsl:when test="@w:val='on' or @w:val='true' or @w:val=1">
          <xsl:value-of select="'always'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'always'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!-- 
  Summary: Template inserts paragraph borders
  Author: Clever Age
  Modified: makz (DIaLOGIKa)
  Date: 22.10.2007
  -->
  <xsl:template match="w:pBdr" mode="pPrChildren">
    <!-- 
    Do not insert the border if the paragraph is a frame.
    In this case the paragraph is inserted as draw:frame and 
    the conversion of the border is handled by the frame conversion
    -->
    <xsl:if test="not(parent::node()/w:framePr)">
      <xsl:call-template name="InsertBorders">
        <xsl:with-param name="border" select="."/>
      </xsl:call-template>
      <xsl:call-template name="InsertParagraphShadow"/>
    </xsl:if>
  </xsl:template>


  <!-- 
  Summary: Template inserts paragraph shading
  Author: Clever Age
  Modified: makz (DIaLOGIKa)
  Date: 26.05.2008
  -->
  <xsl:template match="w:shd" mode="pPrChildren">
    <!-- 
    Do not insert the shading if the paragraph is a frame.
    In this case the paragraph is inserted as draw:frame and 
    the conversion of the shading is handled by the frame conversion
    -->
    <xsl:if test="not(parent::node()/w:framePr)">
      <xsl:attribute name="fo:background-color">
        <xsl:call-template name="ComputeShading"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- shading on runs -->
  <xsl:template match="w:shd" mode="rPrChildren">
    <xsl:attribute name="fo:background-color">
      <xsl:call-template name="ComputeShading"/>
    </xsl:attribute>
  </xsl:template>

  <!-- font weight -->
  <xsl:template match="w:b" mode="rPrChildren">
    <xsl:attribute name="fo:font-weight">
      <xsl:choose>
        <xsl:when test="@w:val='off' or @w:val='false' or @w:val=0">normal</xsl:when>
        <xsl:when test="@w:val='on' or @w:val='true' or @w:val=1">bold</xsl:when>
        <xsl:otherwise>bold</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="w:bCs" mode="rPrChildren">
    <xsl:attribute name="style:font-weight-complex">
      <xsl:choose>
        <xsl:when test="@w:val='off' or @w:val='false' or @w:val=0">normal</xsl:when>
        <xsl:when test="@w:val='on' or @w:val='true' or @w:val=1">bold</xsl:when>
        <xsl:otherwise>bold</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!-- italic -->
  <xsl:template match="w:i" mode="rPrChildren">
    <xsl:attribute name="fo:font-style">
      <xsl:choose>
        <xsl:when test="@w:val='off' or @w:val='false' or @w:val=0">normal</xsl:when>
        <xsl:when test="@w:val='on' or @w:val='true' or @w:val=1">italic</xsl:when>
        <xsl:otherwise>italic</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="w:iCs" mode="rPrChildren">
    <xsl:attribute name="style:font-style-complex">
      <xsl:choose>
        <xsl:when test="@w:val='off' or @w:val='false' or @w:val=0">normal</xsl:when>
        <xsl:when test="@w:val='on' or @w:val='true' or @w:val=1">italic</xsl:when>
        <xsl:otherwise>italic</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!-- case transform -->
  <xsl:template match="w:caps" mode="rPrChildren">
    <xsl:attribute name="fo:text-transform">
      <xsl:choose>
        <!--ignore when in field because they can have it's own text transform properties see: InsertFieldProperties -->
        <xsl:when test="ancestor::w:r/w:instrText or ancestor::w:r/parent::w:fldSimple"/>
        <xsl:when test="@w:val='off' or @w:val='false' or @w:val=0">none</xsl:when>
        <xsl:when test="@w:val='on' or @w:val='true' or @w:val=1">uppercase</xsl:when>
        <xsl:otherwise>uppercase</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="w:smallCaps" mode="rPrChildren">
    <xsl:attribute name="fo:font-variant">
      <xsl:choose>
        <xsl:when test="@w:val='off' or @w:val='false' or @w:val=0">normal</xsl:when>
        <xsl:when test="@w:val='on' or @w:val='true' or @w:val=1">small-caps</xsl:when>
        <xsl:otherwise>small-caps</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!-- hyphenation -->
  <xsl:template match="w:suppressAutoHyphens" mode="textProppPrChildren">
    <xsl:choose>
      <xsl:when test="@w:val='off' or @w:val='false' or @w:val=0">
        <xsl:attribute name="fo:hyphenate">true</xsl:attribute>
        <xsl:attribute name="fo:hyphenation-remain-char-count">2</xsl:attribute>
        <xsl:attribute name="fo:hyphenation-push-char-count">2</xsl:attribute>
      </xsl:when>
      <xsl:when test="@w:val='on' or @w:val='true' or @w:val=1">
        <xsl:attribute name="fo:hyphenate">false</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="fo:hyphenate">false</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- 
  *************************************************************************
  CALLED TEMPLATES
  *************************************************************************
  -->

  <xsl:template name="styles">
    <office:document-styles>
      <office:font-face-decls>
        <xsl:apply-templates select="key('Part', 'word/fontTable.xml')/w:fonts"/>
      </office:font-face-decls>
      <!-- document styles -->
      <office:styles>
        <!-- Sona: #2014221 and Arrow Feature Continuation-->
        <xsl:for-each select ="key('Part', 'word/document.xml')/w:document/w:body//node()[name()='v:shape' or name()='v:rect' or name()='v:line' or name()='v:group' or name()='v:oval' or name()='v:roundrect']">
          <xsl:call-template name="getDashType">
            <xsl:with-param name="shape" select="." />
          </xsl:call-template>
          <xsl:call-template name="InsertArrowStyle">
            <xsl:with-param name="shape" select="." />
          </xsl:call-template>
        </xsl:for-each>

        <!--code added by yeswanth.s : 17 Oct 08-->
        <xsl:for-each select="key('PartsByType', 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/header')//w:pict/node()[name()='v:shape' or name()='v:rect' or name()='v:line' or name()='v:group' or name()='v:oval' or name()='v:roundrect']">
          <xsl:call-template name="getDashType">
            <xsl:with-param name="shape" select="." />
          </xsl:call-template>
          <xsl:call-template name="InsertArrowStyle">
            <xsl:with-param name="shape" select="." />
          </xsl:call-template>
        </xsl:for-each>
        <!--end-->

        <!--gradient fill -->
        <xsl:apply-templates select="key('Part', 'word/document.xml')/w:document/w:body//v:fill[@type='gradient']" mode="officestyles" />
        <!-- Vipul: Picture Fill-->
        <xsl:apply-templates select="key('Part', 'word/document.xml')/w:document/w:body//v:fill[@type='tile' or @type='pattern' or @type='frame']" mode="officestyles" />

        <!--heading numbering style, insert outline numbering style only if heading style is linked to level in Word (numId and outlineLvl are in styles.xml Heading style defintion) -->
        <xsl:if test="key('Part', 'word/styles.xml')/w:styles/w:style[child::w:pPr/w:outlineLvl and child::w:pPr/w:numPr/w:numId]">
          <xsl:call-template name="InsertOutlineListStyle"/>
        </xsl:if>
        <!-- document styles -->
        <xsl:call-template name="InsertDefaultStyles"/>

        <!-- insert the normal styles -->
        <xsl:apply-templates select="key('Part', 'word/styles.xml')/w:styles"/>

        <!--clam: special hyperlink style for toc (bug #1806204)-->
        <xsl:if test="not(key('Part', 'word/styles.xml')/w:styles/w:style[@w:styleId='X3AS7TOCHyperlink'])">
          <style:style style:name="{concat('ooc-NCNameFromString', '-oop-', 'X3AS7TOCHyperlink', '-ooe')}" style:display-name="X3AS7TOCHyperlink" style:family="text" style:parent-style-name="DefaultParagraphFont">
            <style:text-properties fo:color="#000000" style:text-underline-style="none" />
          </style:style>
        </xsl:if>

        <!--clam: special style for tabs in footer (bug #1803097)-->
        <xsl:if test="not(key('Part', 'word/styles.xml')/w:styles/w:style[@w:styleId='X3AS7TABSTYLE'])">
          <style:style style:name="{concat('ooc-NCNameFromString', '-oop-', 'X3AS7TABSTYLE', '-ooe')}" style:family="paragraph" style:parent-style-name="Footer">
            <style:paragraph-properties>
              <style:tab-stops>
                <style:tab-stop style:type="right" style:position="25cm" />
              </style:tab-stops>
            </style:paragraph-properties>
          </style:style>
        </xsl:if>

        <!--clam: special style for bullets with symbol font (bug #1806059)-->
        <xsl:if test="not(key('Part', 'word/styles.xml')/w:styles/w:style[@w:styleId='BulletSymbol'])">
          <style:style style:family="text" style:name="{concat('ooc-NCNameFromString', '-oop-', 'BulletSymbol', '-ooe')}">
            <style:text-properties style:font-name="Symbol" />
          </style:style>
        </xsl:if>

        <xsl:call-template name="InsertNotesConfiguration"/>
        <xsl:if test="key('Part', 'word/document.xml')/w:document/descendant::w:r[contains(w:instrText,'CITATION')]">
          <xsl:call-template name="BibliographyConfiguration"/>
        </xsl:if>
        <!-- Insert List Style Properties -->
        <xsl:call-template name="ListStyleProperties"/>
        <!-- Insert Line Numbering -->
        <xsl:call-template name="InsertLineNumbering"/>
      </office:styles>
      <!-- automatic styles -->
      <office:automatic-styles>
        <xsl:call-template name="HeaderFooterAutomaticStyle"/>
        <!-- TODO : create other automatic styles. This one handles only the default (last w:sectPr of document.xml). -->
        <xsl:if test="key('Part', 'word/document.xml')/w:document/w:body/w:sectPr">
          <xsl:call-template name="InsertDefaultPageLayout"/>
        </xsl:if>

        <!--
        makz: paragraph style for additional paragraph that should not be visible
        -->
        <style:style style:name="{concat('ooc-NCNameFromString', '-oop-', 'HiddenParagraph', '-ooe')}" style:family="paragraph" style:parent-style-name="Standard">
          <style:text-properties fo:font-size="2pt" style:font-size-asian="2pt" style:font-size-complex="2pt"/>
        </style:style>
      </office:automatic-styles>
      <!-- master styles -->
      <office:master-styles>
        <xsl:if test="key('Part', 'word/document.xml')/w:document/w:body/w:sectPr">
          <xsl:call-template name="InsertDefaultMasterPage"/>
        </xsl:if>
      </office:master-styles>
    </office:document-styles>
  </xsl:template>

  <!-- 
  Insert default style for all categories of styles.
  Use only last instance of default style if several of a certain type (cf OOX spec)
  -->
  <xsl:template name="InsertDefaultStyles">

    <xsl:for-each select="key('Part', 'word/styles.xml')">
      <!-- paragraph default -->
      <xsl:call-template name="InsertDefaultParagraphStyle"/>
      <!-- text default -->
      <xsl:call-template name="InsertDefaultTextStyle"/>
      <!-- table default -->
      <xsl:call-template name="InsertDefaultTableStyle"/>
      <!-- graphic defaul -->
      <!-- Commented by Sonata:Defect fix 2630175 DOCX: All VML get blue background  -->
      <!--<xsl:call-template name="InsertDefaultGraphicStyle" /> -->
      <!-- TODO : other ODF style families : section, table-column, table-row, table-cell, table-page, chart, default, drawing-page, graphic, presentation, control and ruby -->
    </xsl:for-each>
  </xsl:template>

  <!-- compute default paragraph props. Use default style, then docDefaults. -->
  <xsl:template name="InsertDefaultParagraphStyle">
    <xsl:if test="w:styles/w:docDefaults[w:pPrDefault or w:rPrDefault] or key('default-styles', 'paragraph')">
      <style:default-style style:family="paragraph">
        <style:paragraph-properties>
          <xsl:call-template name="InsertDefaultTabStop"/>

          <xsl:for-each select="key('default-styles', 'paragraph')[last()]/w:pPr">
            <xsl:call-template name="InsertParagraphPropertiesDefault"/>
          </xsl:for-each>

          <!-- do not retain docDefault pPr properties that are already retained -->
          <xsl:for-each select="w:styles/w:docDefaults/w:pPrDefault/w:pPr/child::node()">
            <xsl:variable name="elementName" select="name()"/>
            <xsl:choose>
              <!-- insert attribute using template name -->
              <xsl:when test="self::w:autoSpaceDN or self::w:autoSpaceDE and not(key('default-styles', 'paragraph')[last()]/w:rPr[w:autoSpaceDN or w:autoSpaceDE])">
                <xsl:call-template name="InsertParagraphAutoSpace"/>
              </xsl:when>
              <xsl:otherwise>
                <!--insert attributes using match-->
                <xsl:if test="not(key('default-styles', 'paragraph')[last()]/w:pPr/*[name() = $elementName])">
                  <xsl:apply-templates select="." mode="pPrChildren"/>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </style:paragraph-properties>
        <style:text-properties>
          <xsl:for-each select="key('default-styles', 'paragraph')[last()]/w:rPr">
            <xsl:call-template name="InsertTextProperties"/>
          </xsl:for-each>
          <xsl:for-each select="key('default-styles', 'paragraph')[last()]/w:pPr">
            <xsl:call-template name="InsertpPrTextProperties"/>
          </xsl:for-each>
          <!-- do not retain docDefault pPr properties that are already retained -->
          <xsl:for-each select="w:styles/w:docDefaults/w:rPrDefault/w:rPr/child::node()">
            <xsl:variable name="elementName" select="name()"/>
            <xsl:choose>
              <!-- insert attribute using template name -->
              <xsl:when test="self::w:dstrike or self::w:strike and not(key('default-styles', 'paragraph')[last()]/w:rPr[w:dstrike or w:strike])">
                <xsl:call-template name="InsertTextStrikeLine"/>
              </xsl:when>
              <xsl:when test="self::w:vertAlign or self::w:position and not(key('default-styles', 'paragraph')[last()]/w:rPr[w:vertAlign or w:position])">
                <xsl:call-template name="InsertTextPosition"/>
              </xsl:when>
              <xsl:otherwise>
                <!-- insert attributes using match -->
                <!--<xsl:if test="not(key('default-styles', 'paragraph')[last()]/w:rPr/*[name() = $elementName])">-->
                <xsl:apply-templates select="." mode="rPrChildren"/>
                <xsl:apply-templates select="." mode="rPrChildren-dropcap-forbidden"/>
                <!--</xsl:if>-->
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
          <xsl:for-each select="w:styles/w:docDefaults/w:pPrDefault/w:pPr/child::node()">
            <xsl:variable name="elementName" select="name()"/>
            <xsl:if test="not(key('default-styles', 'paragraph')[last()]/w:pPr/*[name() = $elementName])">
              <xsl:apply-templates select="." mode="pPrChildren"/>
            </xsl:if>
          </xsl:for-each>
          <!--default text properties-->
          <xsl:call-template name="InsertDefaultTextProperties"/>
          <!-- enforce default properties -->
          <xsl:call-template name="EnforceDefaultProperties">
            <xsl:with-param name="type">paragraph</xsl:with-param>
          </xsl:call-template>
        </style:text-properties>
      </style:default-style>
    </xsl:if>
  </xsl:template>

  <!--default tab-stop-->
  <xsl:template name="InsertDefaultTabStop">
    <xsl:if test="key('Part', 'word/settings.xml')/w:settings/w:defaultTabStop/@w:val">
      <xsl:attribute name="style:tab-stop-distance">
        <xsl:value-of select="concat(key('Part', 'word/settings.xml')/w:settings/w:defaultTabStop/@w:val * 2.54 div 1440.0, 'cm')"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="InsertDefaultTextProperties">
    <!--auto text color-->
    <xsl:attribute name="style:use-window-font-color">true</xsl:attribute>
  </xsl:template>

  <!-- default character style -->
  <xsl:template name="InsertDefaultTextStyle">
    <xsl:if test="w:styles/w:docDefaults[w:rPrDefault] or key('default-styles', 'character') or key('default-styles', 'paragraph')/w:rPr">
      <style:default-style style:family="text">
        <style:text-properties>
          <xsl:for-each select="key('default-styles', 'character')[last()]/w:rPr">
            <xsl:call-template name="InsertTextProperties"/>
          </xsl:for-each>
          <!-- do not retain rPr in default paragraph properties that are already retained -->
          <xsl:for-each select="key('default-styles', 'paragraph')/w:rPr/child::node()">
            <xsl:variable name="elementName" select="name()"/>
            <xsl:choose>
              <!-- insert attribute using template name -->
              <xsl:when test="self::w:dstrike or self::w:strike and not(key('default-styles', 'character')[last()]/w:rPr[w:dstrike or w:strike])">
                <xsl:call-template name="InsertTextStrikeLine"/>
              </xsl:when>
              <xsl:when test="self::w:vertAlign or self::w:position and not(key('default-styles', 'character')[last()]/w:rPr[w:vertAlign or w:position])">
                <xsl:call-template name="InsertTextPosition"/>
              </xsl:when>
              <xsl:otherwise>
                <!-- insert attributes using match -->
                <xsl:if test="not(key('default-styles', 'character')[last()]/w:rPr/*[name() = $elementName])">
                  <xsl:apply-templates select="." mode="rPrChildren"/>
                  <xsl:apply-templates select="." mode="rPrChildren-dropcap-forbidden"/>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
          <!-- do not retain docDefault pPr properties that are already retained -->
          <xsl:for-each select="w:styles/w:docDefaults/w:rPrDefault/w:rPr/child::node()">
            <xsl:variable name="elementName" select="name()"/>
            <xsl:choose>
              <!-- insert attribute using template name -->
              <xsl:when test="self::w:dstrike or self::w:strike and not(key('default-styles', 'character')[last()]/w:rPr[w:dstrike or w:strike])">
                <xsl:if test="not(key('default-styles', 'paragraph')[last()]/w:rPr[w:dstrike or w:strike])">
                  <xsl:call-template name="InsertTextStrikeLine"/>
                </xsl:if>
              </xsl:when>
              <xsl:when test="self::w:vertAlign or self::w:position and not(key('default-styles', 'character')[last()]/w:rPr[w:vertAlign or w:position])">
                <xsl:if test="not(key('default-styles', 'paragraph')[last()]/w:rPr[w:dstrike or w:strike])">
                  <xsl:call-template name="InsertTextPosition"/>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <!-- insert attributes using match -->
                <!--<xsl:if test="not(key('default-styles', 'character')[last()]/w:rPr/*[name() = $elementName])">
                  <xsl:if test="not(key('default-styles', 'paragraph')[last()]/w:rPr/*[name() = $elementName])">-->
                <xsl:apply-templates select="." mode="rPrChildren"/>
                <xsl:apply-templates select="." mode="rPrChildren-dropcap-forbidden"/>
                <!--</xsl:if>
                </xsl:if>-->
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
          <!--default text properties-->
          <xsl:call-template name="InsertDefaultTextProperties"/>
          <!-- enforce default properties -->
          <xsl:call-template name="EnforceDefaultProperties">
            <xsl:with-param name="type">character</xsl:with-param>
          </xsl:call-template>
        </style:text-properties>
      </style:default-style>
    </xsl:if>
  </xsl:template>

  <!-- for the following properties, check if they are are ever mentionned. If not, use a defined default value -->
  <xsl:template name="EnforceDefaultProperties">
    <xsl:param name="type"/>
    <!-- font size -->
    <xsl:if test="not(key('default-styles', $type)//w:rPr/w:sz) and not(w:styles/w:docDefaults/w:rPrDefault/w:rPr/w:sz)">
      <xsl:attribute name="fo:font-size">10pt</xsl:attribute>
    </xsl:if>
    <!-- font size asian and complex-->
    <xsl:if test="not(key('default-styles', $type)//w:rPr/w:szCs) and not(w:styles/w:docDefaults/w:rPrDefault/w:rPr/w:szCs)">
      <xsl:attribute name="style:font-size-complex">10pt</xsl:attribute>
      <xsl:attribute name="style:font-size-asian">10pt</xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- default table style -->
  <xsl:template name="InsertDefaultTableStyle">
    <xsl:for-each select="key('default-styles', 'table')[last()]">
      <style:default-style style:family="table">
        <xsl:call-template name="InsertTableProperties"/>
      </style:default-style>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="InsertDefaultGraphicStyle">
    <style:default-style style:family="graphic">
      <style:graphic-properties draw:fill="solid"
                                draw:fill-color="#4f81bd"
                                draw:opacity="100%"
                                draw:stroke="solid"
                                svg:stroke-width="0.02778in"
                                svg:stroke-color="#385d8a"
                                svg:stroke-opacity="100%" />
    </style:default-style>
  </xsl:template>

  <xsl:template name="HeaderFooterAutomaticStyle">
    <xsl:for-each select="key('Part', 'word/document.xml')/w:document/w:body/w:sectPr">
      <xsl:call-template name="HeaderFooterStyles"/>
    </xsl:for-each>
    <xsl:for-each select="key('Part', 'word/document.xml')/w:document/w:body/w:p/w:pPr/w:sectPr">
      <xsl:call-template name="HeaderFooterStyles"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="HeaderFooterStyles">
    <xsl:for-each select="w:headerReference">
      <xsl:choose>
        <xsl:when test="./@w:type = 'default'">
          <xsl:variable name="headerId" select="./@r:id"/>
          <xsl:variable name="headerXmlDocument"
					  select="concat('word/',key('Part', 'word/_rels/document.xml.rels')/descendant::node()[@Id=$headerId]/@Target)"/>
          <xsl:for-each select="key('Part', $headerXmlDocument)">

            <!-- Generate automatic Styles for paragraphs-->
            <xsl:apply-templates mode="automaticstyles"/>

            <!-- Generate automatic Styles for pict/shapes/textboxes-->
            <xsl:apply-templates mode="automaticpict"/>

            <xsl:if test="key('Part', $headerXmlDocument)/w:hdr[descendant::w:numPr/w:numId]">
              <!-- automatic list styles-->
              <xsl:apply-templates select="key('Part', 'word/numbering.xml')/w:numbering/w:num"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="./@w:type = 'even'">
          <xsl:variable name="headerId" select="./@r:id"/>
          <xsl:variable name="headerXmlDocument"
					  select="concat('word/',key('Part', 'word/_rels/document.xml.rels')/descendant::node()[@Id=$headerId]/@Target)"/>
          <xsl:for-each select="key('Part', $headerXmlDocument)">

            <!-- Generate automatic Styles for paragraphs-->
            <xsl:apply-templates mode="automaticstyles"/>

            <!-- Generate automatic Styles for pict/shapes/textboxes-->
            <xsl:apply-templates mode="automaticpict"/>

            <xsl:if test="key('Part', $headerXmlDocument)/w:hdr[descendant::w:numPr/w:numId]">
              <!-- automatic list styles-->
              <xsl:apply-templates select="key('Part', 'word/numbering.xml')/w:numbering/w:num"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="./@w:type = 'first'">
          <xsl:variable name="headerId" select="./@r:id"/>
          <xsl:variable name="headerXmlDocument"
					  select="concat('word/',key('Part', 'word/_rels/document.xml.rels')/descendant::node()[@Id=$headerId]/@Target)"/>
          <xsl:for-each select="key('Part', $headerXmlDocument)">

            <!-- Generate automatic Styles for paragraphs-->
            <xsl:apply-templates mode="automaticstyles"/>

            <!-- Generate automatic Styles for pict/shapes/textboxes-->
            <xsl:apply-templates mode="automaticpict"/>

            <xsl:if test="key('Part', $headerXmlDocument)/w:hdr[descendant::w:numPr/w:numId]">
              <!-- automatic list styles-->
              <xsl:apply-templates select="key('Part', 'word/numbering.xml')/w:numbering/w:num"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:for-each select="w:footerReference">
      <xsl:choose>
        <xsl:when test="./@w:type = 'default'">
          <xsl:variable name="footerId" select="./@r:id"/>
          <xsl:variable name="footerXmlDocument"
					  select="concat('word/',key('Part', 'word/_rels/document.xml.rels')/descendant::node()[@Id=$footerId]/@Target)"/>
          <xsl:for-each select="key('Part', $footerXmlDocument)">

            <!-- Generate automatic Styles for paragraphs-->
            <xsl:apply-templates mode="automaticstyles"/>

            <!-- Generate automatic Styles for pict/shapes/textboxes-->
            <xsl:apply-templates mode="automaticpict"/>

            <xsl:if test="key('Part', $footerXmlDocument)/w:ftr[descendant::w:numPr/w:numId]">
              <!-- automatic list styles-->
              <xsl:apply-templates select="key('Part', 'word/numbering.xml')/w:numbering/w:num"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="./@w:type = 'even'">
          <xsl:variable name="footerId" select="./@r:id"/>
          <xsl:variable name="footerXmlDocument"
					  select="concat('word/',key('Part', 'word/_rels/document.xml.rels')/descendant::node()[@Id=$footerId]/@Target)"/>
          <xsl:for-each select="key('Part', $footerXmlDocument)">

            <!-- Generate automatic Styles for paragraphs-->
            <xsl:apply-templates mode="automaticstyles"/>

            <!-- Generate automatic Styles for pict/shapes/textboxes-->
            <xsl:apply-templates mode="automaticpict"/>

            <xsl:if test="key('Part', $footerXmlDocument)/w:ftr[descendant::w:numPr/w:numId]">
              <!-- automatic list styles-->
              <xsl:apply-templates select="key('Part', 'word/numbering.xml')/w:numbering/w:num"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="./@w:type = 'first'">
          <xsl:variable name="footerId" select="./@r:id"/>
          <xsl:variable name="footerXmlDocument"
					  select="concat('word/',key('Part', 'word/_rels/document.xml.rels')/descendant::node()[@Id=$footerId]/@Target)"/>
          <xsl:for-each select="key('Part', $footerXmlDocument)">

            <!-- Generate automatic Styles for paragraphs-->
            <xsl:apply-templates mode="automaticstyles"/>

            <!-- Generate automatic Styles for pict/shapes/textboxes-->
            <xsl:apply-templates mode="automaticpict"/>

            <xsl:if test="key('Part', $footerXmlDocument)/w:ftr[descendant::w:numPr/w:numId]">
              <!-- automatic list styles-->
              <xsl:apply-templates select="key('Part', 'word/numbering.xml')/w:numbering/w:num"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- handle default master page style -->
  <xsl:template name="InsertDefaultMasterPage">

    <!-- default master page : -->
    <!-- actually, this assumption is false : w:body/w:sectPr does not carry any default section properties
        it is simply the last section of the document. There are no default section properties in an OOX document -->
    <style:master-page style:name="{concat('ooc-NCNameFromString', '-oop-', 'Standard', '-ooe')}" style:page-layout-name="{concat('ooc-NCNameFromString', '-oop-', $pm1, '-ooe')}">
      <xsl:for-each select="key('Part', 'word/document.xml')/w:document/w:body/w:sectPr">
        <xsl:call-template name="HeaderFooter"/>
      </xsl:for-each>
    </style:master-page>
    <!-- first page default master page -->
    <xsl:if test="key('Part', 'word/document.xml')/w:document/w:body/w:sectPr/w:titlePg">
      <style:master-page style:name="{concat('ooc-NCNameFromString', '-oop-', 'First Page', '-ooe')}" style:page-layout-name="{concat('ooc-NCNameFromString', '-oop-', $pm1, '-ooe')}"
			  style:next-style-name="{concat('ooc-NCNameFromString', '-oop-', 'Standard', '-ooe')}" style:display-name="First Page">
        <xsl:for-each select="key('Part', 'word/document.xml')/w:document/w:body/w:sectPr">
          <xsl:call-template name="HeaderFooterFirst"/>
        </xsl:for-each>
      </style:master-page>
    </xsl:if>

    <xsl:for-each select="key('Part', 'word/document.xml')/w:document/w:body/w:p/w:pPr/w:sectPr">
      <!-- create first-page of section master page -->
      <xsl:if test="w:titlePg or key('Part', 'word/document.xml')/w:document/w:body/w:sectPr/w:titlePg">
        <style:master-page style:name="{concat('ooc-NCNameFromString', '-oop-', concat('First_H_',generate-id(.)), '-ooe')}"
                           style:next-style-name="{concat('ooc-NCNameFromString', '-oop-', concat('H_',generate-id(.)), '-ooe')}"
                           style:page-layout-name="{concat('PAGE', generate-id(.))}"
                           style:display-name="{concat('First_H_',generate-id(.))}">
          <xsl:choose>
            <xsl:when test="w:headerReference/@w:type = 'first' or w:footerReference/@w:type = 'first'">
              <xsl:call-template name="HeaderFooterFirst"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="key('Part', 'word/document.xml')/w:document/w:body/w:sectPr">
                <xsl:call-template name="HeaderFooterFirst"/>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </style:master-page>
      </xsl:if>
      <!-- insert master page of current section -->
      <style:master-page style:name="{concat('ooc-NCNameFromString', '-oop-', concat('H_',generate-id(.)), '-ooe')}"
                         style:page-layout-name="{concat('PAGE', generate-id(.))}"
                         style:display-name="{concat('H_',generate-id(.))}">
        <xsl:call-template name="HeaderFooter"/>
      </style:master-page>
    </xsl:for-each>

    <xsl:for-each select="key('Part', 'word/document.xml')/w:document/w:body/w:p/w:pPr/w:sectPr">
      <xsl:if test="preceding::w:sectPr/w:pgSz/@w:w != ./w:pgSz/@w:w
        or preceding::w:sectPr/w:pgSz/@w:h != ./w:pgSz/@w:h
        or preceding::w:sectPr/w:pgSz/@w:orient != ./w:pgSz/@w:orient
        or key('Part', 'word/document.xml')/w:document/w:body/w:sectPr/w:pgSz/@w:w != ./w:pgSz/@w:w
        or key('Part', 'word/document.xml')/w:document/w:body/w:sectPr/w:pgSz/@w:h != ./w:pgSz/@w:h
        or key('Part', 'word/document.xml')/w:document/w:body/w:sectPr/w:pgSz/@w:orient != ./w:pgSz/@w:orient ">
        <style:master-page>
          <xsl:attribute name="style:name">
            <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', concat('PAGE_',generate-id(.)), '-ooe')"/>
          </xsl:attribute>
          <xsl:attribute name="style:page-layout-name">
            <xsl:value-of select="concat('PAGE',generate-id(.))"/>
          </xsl:attribute>
          <xsl:attribute name="style:display-name">
            <xsl:value-of select="concat('PAGE_',generate-id(.))"/>
          </xsl:attribute>
          <xsl:call-template name="HeaderFooter"/>
        </style:master-page>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>


  <!--START clam bugfix #1802289-->
  <xsl:template name="HeaderFooter">
    <xsl:variable name="headerId">
      <xsl:choose>
        <xsl:when test="w:headerReference/@w:type = 'default'">
          <xsl:value-of select="w:headerReference[./@w:type = 'default']/@r:id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="w:titlePg">
              <xsl:choose>
                <xsl:when test="preceding::w:sectPr[w:headerReference/@w:type = 'first'][1]/w:headerReference[./@w:type = 'first']/@r:id">
                  <xsl:value-of select="preceding::w:sectPr[w:headerReference/@w:type = 'first'][1]/w:headerReference[./@w:type = 'first']/@r:id"/>
                </xsl:when>
                <xsl:otherwise>newempty</xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="preceding::w:sectPr[w:headerReference/@w:type = 'default'][1]/w:headerReference[./@w:type = 'default']/@r:id"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$headerId = 'newempty'">
        <style:header>
          <text:p/>
        </style:header>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$headerId != ''">
          <style:header>
            <xsl:variable name="headerXmlDocument" select="concat('word/',key('Part', 'word/_rels/document.xml.rels')/descendant::node()[@Id=$headerId]/@Target)"/>
            <!-- change context to get header content -->
            <xsl:for-each select="key('Part', $headerXmlDocument)">
              <xsl:call-template name="TrackChanges"/>
              <xsl:apply-templates/>
            </xsl:for-each>
          </style:header>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    <!--END clam bugfix #1802289-->

    <xsl:if test="key('Part', 'word/settings.xml')/w:settings/w:evenAndOddHeaders">
      <xsl:variable name="headerIdEven">
        <xsl:choose>
          <xsl:when test="w:headerReference/@w:type = 'even'">
            <xsl:value-of select="w:headerReference[./@w:type = 'even']/@r:id"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="preceding::w:sectPr[w:headerReference/@w:type = 'even'][1]/w:headerReference[./@w:type = 'even']/@r:id" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$headerIdEven != ''">
          <xsl:if test="$headerId = ''">
            <style:header>
              <text:p/>
            </style:header>
          </xsl:if>
          <style:header-left>
            <xsl:variable name="headerXmlDocument" select="concat('word/',key('Part', 'word/_rels/document.xml.rels')/descendant::node()[@Id=$headerIdEven]/@Target)" />
            <!-- change context to get header content -->
            <xsl:for-each select="key('Part', $headerXmlDocument)">
              <xsl:call-template name="TrackChanges" />
              <xsl:apply-templates/>
            </xsl:for-each>
          </style:header-left>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$headerId = ''">
            <style:header />
          </xsl:if>
          <style:header-left>
            <text:p/>
          </style:header-left>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <!--
		Defect      : 2218801, Test footer
		Code Changes: Vijayeta
		Desc        : If a doc has only footers in even page, footer is not retained.
		-->
    <xsl:variable name="footerId">
      <xsl:choose>
        <xsl:when test="w:footerReference/@w:type = 'default'">
          <xsl:value-of select="w:footerReference[./@w:type = 'default']/@r:id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="preceding::w:sectPr[w:footerReference/@w:type = 'default'][1]/w:footerReference[./@w:type = 'default']/@r:id" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="footerIdEven">
      <xsl:choose>
        <xsl:when test="w:footerReference/@w:type = 'even'">
          <xsl:value-of select="w:footerReference[./@w:type = 'even']/@r:id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="preceding::w:sectPr[w:footerReference/@w:type = 'even'][1]/w:footerReference[./@w:type = 'even']/@r:id" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!--additional condiditon added for the defects 2218801-->
    <xsl:if test="$footerId != '' or ($footerId = '' and $footerIdEven != '') ">
      <xsl:if test="$footerId != ''">
        <style:footer>
          <xsl:variable name="footerXmlDocument" select="concat('word/',key('Part', 'word/_rels/document.xml.rels')/descendant::node()[@Id=$footerId]/@Target)"/>
          <!-- change context to get footer content -->
          <xsl:for-each select="key('Part', $footerXmlDocument)">
            <xsl:call-template name="TrackChanges" />
            <xsl:apply-templates/>
          </xsl:for-each>
        </style:footer>
      </xsl:if>
      <xsl:if test="key('Part', 'word/settings.xml')/w:settings/w:evenAndOddHeaders">
        <!--<xsl:variable name="footerIdEven">
          <xsl:choose>
            <xsl:when test="w:footerReference/@w:type = 'even'">
              <xsl:value-of select="w:footerReference[./@w:type = 'even']/@r:id"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="preceding::w:sectPr[w:footerReference/@w:type = 'even'][1]/w:footerReference[./@w:type = 'even']/@r:id" />
            </xsl:otherwise>
          </xsl:choose>
				</xsl:variable>-->
        <xsl:choose>
          <xsl:when test="$footerIdEven != ''">
            <xsl:if test="$footerId = ''">
              <style:footer>
                <text:p/>
              </style:footer>
            </xsl:if>
            <style:footer-left>
              <xsl:variable name="footerXmlDocument" select="concat('word/',key('Part', 'word/_rels/document.xml.rels')/descendant::node()[@Id=$footerIdEven]/@Target)"/>
              <!-- change context to get footer content -->
              <xsl:for-each select="key('Part', $footerXmlDocument)">
                <xsl:call-template name="TrackChanges" />
                <xsl:apply-templates/>
              </xsl:for-each>
            </style:footer-left>
          </xsl:when>
          <xsl:otherwise>
            <style:footer-left>
              <text:p/>
            </style:footer-left>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="HeaderFooterFirst">
    <xsl:variable name="headerId">
      <xsl:choose>
        <xsl:when test="w:headerReference/@w:type = 'first'">
          <xsl:value-of select="w:headerReference[./@w:type = 'first']/@r:id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="preceding::w:sectPr/w:headerReference[./@w:type = 'first'][1]/@r:id"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!--<xsl:if test="$headerId != ''">
      <style:header>
        <xsl:variable name="headerXmlDocument"
          select="concat('word/',key('Part', 'word/_rels/document.xml.rels')/descendant::node()[@Id=$headerId]/@Target)"/>
        -->
    <!-- change context to get header content -->
    <!--
        <xsl:for-each select="key('Part', $headerXmlDocument)">
          <xsl:apply-templates/>
        </xsl:for-each>
      </style:header>
    </xsl:if>-->
    <xsl:choose>
      <xsl:when test="$headerId != ''">
        <style:header>
          <xsl:variable name="headerXmlDocument" select="concat('word/',key('Part', 'word/_rels/document.xml.rels')/descendant::node()[@Id=$headerId]/@Target)"/>
          <!-- change context to get header content -->
          <xsl:for-each select="key('Part', $headerXmlDocument)">
            <xsl:call-template name="TrackChanges" />
            <xsl:apply-templates/>
          </xsl:for-each>
        </style:header>
      </xsl:when>
      <xsl:otherwise>
        <!--clam, dialogika: bugfix 1911697-->
        <xsl:if test="w:headerReference">
          <style:header>
            <text:p></text:p>
          </style:header>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:variable name="footerId">
      <xsl:choose>
        <xsl:when test="w:footerReference/@w:type = 'first'">
          <xsl:value-of select="w:footerReference[./@w:type = 'first']/@r:id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="preceding::w:sectPr/w:footerReference[./@w:type = 'first'][1]/@r:id" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$footerId != ''">
      <style:footer>
        <xsl:variable name="footerXmlDocument" select="concat('word/',key('Part', 'word/_rels/document.xml.rels')/descendant::node()[@Id=$footerId]/@Target)"/>
        <!-- change context to get footer content -->
        <xsl:for-each select="key('Part', $footerXmlDocument)">
          <xsl:call-template name="TrackChanges" />
          <xsl:apply-templates/>
        </xsl:for-each>
      </style:footer>
    </xsl:if>
  </xsl:template>

  <!-- handle default page layout -->
  <xsl:template name="InsertDefaultPageLayout">
    <style:page-layout style:name="{concat('ooc-NCNameFromString', '-oop-', $pm1, '-ooe')}">
      <xsl:if test="key('Part', 'word/settings.xml')/w:settings/w:mirrorMargins">
        <xsl:attribute name="style:page-usage">
          <xsl:text>mirrored</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:for-each select="key('Part', 'word/document.xml')/w:document/w:body/w:sectPr">
        <style:page-layout-properties>
          <xsl:call-template name="InsertPageLayoutProperties"/>
          <xsl:call-template name="InsertColumns"/>
        </style:page-layout-properties>
        <xsl:if test="./w:headerReference/@w:type or preceding::w:headerReference/@w:type">
          <style:header-style>
            <style:header-footer-properties>
              <xsl:call-template name="InsertHeaderFooterProperties">
                <xsl:with-param name="object">header</xsl:with-param>
              </xsl:call-template>
            </style:header-footer-properties>
          </style:header-style>
        </xsl:if>
        <xsl:if test="./w:footerReference[@w:type='default' or @w:type='even'] or preceding::w:footerReference[@w:type='default' or @w:type='even']">
          <style:footer-style>
            <style:header-footer-properties>
              <xsl:call-template name="InsertHeaderFooterProperties">
                <xsl:with-param name="object">footer</xsl:with-param>
              </xsl:call-template>
            </style:header-footer-properties>
          </style:footer-style>
        </xsl:if>
      </xsl:for-each>
    </style:page-layout>
    <xsl:for-each select="key('Part', 'word/document.xml')/w:document/w:body/w:p/w:pPr/w:sectPr">
      <style:page-layout>
        <xsl:if test="key('Part', 'word/settings.xml')/w:settings/w:mirrorMargins">
          <xsl:attribute name="style:page-usage">
            <xsl:text>mirrored</xsl:text>
          </xsl:attribute>
        </xsl:if>
        <xsl:attribute name="style:name">
          <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', concat('PAGE', generate-id(.)), '-ooe')"/>
        </xsl:attribute>
        <style:page-layout-properties>
          <xsl:call-template name="InsertPageLayoutProperties"/>
        </style:page-layout-properties>
        <style:header-style>
          <style:header-footer-properties>
            <xsl:call-template name="InsertHeaderFooterProperties">
              <xsl:with-param name="object">header</xsl:with-param>
            </xsl:call-template>
          </style:header-footer-properties>
        </style:header-style>
        <style:footer-style>
          <style:header-footer-properties>
            <xsl:call-template name="InsertHeaderFooterProperties">
              <xsl:with-param name="object">footer</xsl:with-param>
            </xsl:call-template>
          </style:header-footer-properties>
        </style:footer-style>
      </style:page-layout>
    </xsl:for-each>
  </xsl:template>

  <!-- conversion of page properties -->
  <!-- TODO : handle other properties -->
  <xsl:template name="InsertPageLayoutProperties">

    <!-- page size -->
    <xsl:if test="w:pgSz">
      <xsl:attribute name="fo:page-width">
        <xsl:value-of  select="concat(w:pgSz/@w:w  * 2.54 div 1440.0, 'cm')" />
      </xsl:attribute>
      <xsl:attribute name="fo:page-height">
        <xsl:value-of select="concat(w:pgSz/@w:h * 2.54 div 1440.0, 'cm')" />
      </xsl:attribute>
      <xsl:if test="w:pgSz/@w:orient">
        <xsl:attribute name="style:print-orientation">
          <xsl:value-of select="w:pgSz/@w:orient"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:if>

    <!--clam, dialogika: document grids should be implemented (this is only a basic conversion to deal with bug #1791570-->
    <xsl:if test="w:docGrid">
      <!--<xsl:attribute name="style:layout-grid-lines">
        <xsl:text>30</xsl:text>
      </xsl:attribute>-->
      <xsl:if test="w:docGrid[@w:type='lines' or @w:type='linesAndChars']/@w:linePitch">
        <xsl:attribute name="style:layout-grid-base-height">
          <xsl:value-of select="concat(w:docGrid/@w:linePitch * 2.54 div 1440.0, 'cm')" />
        </xsl:attribute>
        <xsl:attribute name="style:layout-grid-mode">
          <xsl:text>line</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <!--<xsl:attribute name="style:layout-grid-ruby-height">
        <xsl:text>0.6cm</xsl:text>
      </xsl:attribute>-->
      <!--<xsl:attribute name="style:layout-grid-ruby-below">
        <xsl:text>false</xsl:text>
      </xsl:attribute>-->
    </xsl:if>

    <xsl:if test="w:pgBorders">
      <xsl:call-template name="InsertPageBorders"/>
      <xsl:call-template name="InsertPagePadding"/>
    </xsl:if>

    <!-- page margins -->
    <xsl:if test="w:pgMar">
      <xsl:call-template name="ComputePageMargins"/>
    </xsl:if>

    <!--  page color  -->
    <xsl:if test="//w:document//w:background/@w:color">
      <xsl:attribute name="fo:background-color">
        <xsl:text>#</xsl:text>
        <xsl:value-of select="//w:document//w:background/@w:color"/>
      </xsl:attribute>
    </xsl:if>

    <!-- page numbering style. -->
    <!-- TODO : handle chapter numbering -->
    <xsl:if test="w:pgNumType">
      <xsl:call-template name="InsertPageNumbering"/>
    </xsl:if>

    <!-- footnote seperators -->
    <xsl:call-template name="InsertCustomFootnoteSeperator"/>

  </xsl:template>

  <!--
  Summary: Template inserts formatted footnote seperators.
  Author: makz (DIaLOGIKa)
  Date: 9.10.2007
  -->
  <xsl:template name="InsertCustomFootnoteSeperator">

    <!-- Get the font size of the style referenced to the default paragraph -->
    <xsl:variable name="paraStyle" select="key('Part', 'word/styles.xml')/w:styles/w:style[@w:default='1']/w:pPr/w:pStyle/@w:val" />
    <xsl:variable name="charStyle" select="key('Part', 'word/styles.xml')/w:styles/w:style[@w:styleId='$paraStyle']/w:basedOn/@w:val" />
    <xsl:variable name="fontSize" >
      <xsl:call-template name="ConvertPoints">
        <xsl:with-param name="length">
          <xsl:value-of select="key('StyleId',$charStyle)/w:rPr/w:sz/@w:val" />
        </xsl:with-param>
        <xsl:with-param name="unit">cm</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <!-- Get the space-before from ooxml -->
    <xsl:variable name="spaceBefore">
      <xsl:choose>
        <xsl:when test="key('Part', 'word/styles.xml')/w:styles/w:style[@w:default='1']/w:pPr/w:spacing/@w:before">
          <xsl:value-of select="concat(key('Part', 'word/styles.xml')/w:styles/w:style[@w:default='1']/w:pPr/w:spacing/@w:before * 2.54 div 1440.0, 'cm')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:spacing/@w:before * 2.54 div 1440.0, 'cm')" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Get the space-after from ooxml -->
    <xsl:variable name="spaceAfter">
      <xsl:choose>
        <xsl:when test="key('Part', 'word/styles.xml')/w:styles/w:style[@w:default='1']/w:pPr/w:spacing/@w:after">
          <xsl:value-of select="concat(key('Part', 'word/styles.xml')/w:styles/w:style[@w:default='1']/w:pPr/w:spacing/@w:after * 2.54 div 1440.0, 'cm')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:spacing/@w:after * 2.54 div 1440.0, 'cm')" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- create default value for relwidth and width -->
    <xsl:variable name="width">0.005cm</xsl:variable>
    <xsl:variable name="relwidth">
      <xsl:variable name="pageWidthStr" select="concat((w:pgSz/@w:w) * 2.54 div 1440.0, 'cm')" />
      <xsl:variable name="pageWidth" select="substring-before($pageWidthStr, 'cm')" />

      <xsl:variable name="marLeftStr" select="concat((w:pgMar/@w:left) * 2.54 div 1440.0, 'cm')" />
      <xsl:variable name="marLeft" select="substring-before($marLeftStr, 'cm')" />

      <xsl:variable name="marRightStr" select="concat((w:pgMar/@w:right) * 2.54 div 1440.0, 'cm')" />
      <xsl:variable name="marRight" select="substring-before($marRightStr, 'cm')" />

      <xsl:variable name="areaWidth" select="$pageWidth - $marLeft - $marRight" />

      <xsl:variable name="wordSepWidth" select="'5.1'" />

      <xsl:value-of select="($wordSepWidth * 100) div $areaWidth"/>

    </xsl:variable>

    <style:footnote-sep>
      <xsl:attribute name="style:distance-before-sep">
        <xsl:value-of select="$spaceBefore"/>
      </xsl:attribute>
      <xsl:attribute name="style:distance-after-sep">
        <xsl:value-of select="$spaceAfter"/>
      </xsl:attribute>
      <xsl:attribute name="style:width">
        <xsl:value-of select="$width"/>
      </xsl:attribute>
      <xsl:attribute name="style:rel-width">
        <xsl:value-of select="$relwidth"/>
      </xsl:attribute>
    </style:footnote-sep>
  </xsl:template>

  <xsl:template name="InsertPageBorders">

    <xsl:if test="w:pgBorders/w:top/@w:shadow or w:pgBorders/w:left/@w:shadow or w:pgBorders/w:right/@w:shadow or w:pgBorders/w:bottom/@w:shadow">
      <xsl:attribute name="style:shadow">
        <xsl:text>#000000 0.049cm 0.049cm</xsl:text>
      </xsl:attribute>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="w:pgBorders/w:top">
        <xsl:variable name="type">
          <xsl:choose>
            <xsl:when test="w:pgBorders/w:top/@w:val = 'single'">
              <xsl:text>solid</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>solid</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="sz" select="concat(w:pgBorders/w:top/@w:sz * 2.54 div 1440.0, 'cm')"/>

        <xsl:variable name="color">
          <xsl:choose>
            <xsl:when test="w:pgBorders/w:top/@w:color != 'auto'">
              <xsl:value-of select="w:pgBorders/w:top/@w:color"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>000000</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="fo:border-top">
          <xsl:value-of select="concat($type,' ',$sz,' #',$color)"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="fo:border-top">
          <xsl:text>none</xsl:text>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="w:pgBorders/w:left">
        <xsl:variable name="type">
          <xsl:choose>
            <xsl:when test="w:pgBorders/w:left/@w:val = 'single'">
              <xsl:text>solid</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>solid</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="sz" select="concat(w:pgBorders/w:left/@w:sz * 2.54 div 1440.0, 'cm')" />

        <xsl:variable name="color">
          <xsl:choose>
            <xsl:when test="w:pgBorders/w:left/@w:color != 'auto'">
              <xsl:value-of select="w:pgBorders/w:left/@w:color"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>000000</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="fo:border-left">
          <xsl:value-of select="concat($type,' ',$sz,' #',$color)"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="fo:border-left">
          <xsl:text>none</xsl:text>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="w:pgBorders/w:right">
        <xsl:variable name="type">
          <xsl:choose>
            <xsl:when test="w:pgBorders/w:right/@w:val = 'single'">
              <xsl:text>solid</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>solid</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="sz" select="concat(w:pgBorders/w:right/@w:sz * 2.54 div 1440.0, 'cm')" />

        <xsl:variable name="color">
          <xsl:choose>
            <xsl:when test="w:pgBorders/w:right/@w:color != 'auto'">
              <xsl:value-of select="w:pgBorders/w:right/@w:color"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>000000</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="fo:border-right">
          <xsl:value-of select="concat($type,' ',$sz,' #',$color)"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="fo:border-right">
          <xsl:text>none</xsl:text>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="w:pgBorders/w:bottom">
        <xsl:variable name="type">
          <xsl:choose>
            <xsl:when test="w:pgBorders/w:bottom/@w:val = 'single'">
              <xsl:text>solid</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>solid</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="sz" select="concat(w:pgBorders/w:bottom/@w:sz * 2.54 div 1440.0, 'cm')" />

        <xsl:variable name="color">
          <xsl:choose>
            <xsl:when test="w:pgBorders/w:bottom/@w:color != 'auto'">
              <xsl:value-of select="w:pgBorders/w:bottom/@w:color"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>000000</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="fo:border-bottom">
          <xsl:value-of select="concat($type,' ',$sz,' #',$color)"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="fo:border-bottom">
          <xsl:text>none</xsl:text>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="InsertPagePadding">
    <xsl:if test="w:pgBorders/w:top">
      <xsl:attribute name="fo:padding-top">
        <xsl:choose>
          <xsl:when test="w:pgBorders/@w:offsetFrom = 'page'">
            <xsl:variable name="marg" select="concat(w:pgMar/@w:top * 2.54 div 1440.0, 'cm')" />
            <xsl:variable name="space">
              <xsl:call-template name="ConvertPoints">
                <xsl:with-param name="length">
                  <xsl:value-of select="w:pgBorders/w:top/@w:space"/>
                </xsl:with-param>
                <xsl:with-param name="unit">cm</xsl:with-param>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of
						  select="concat(substring-before($marg,'cm') - substring-before($space,'cm'),'cm')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="ConvertPoints">
              <xsl:with-param name="length">
                <xsl:value-of select="w:pgBorders/w:top/@w:space"/>
              </xsl:with-param>
              <xsl:with-param name="unit">cm</xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="w:pgBorders/w:left">
      <xsl:attribute name="fo:padding-left">
        <xsl:choose>
          <xsl:when test="w:pgBorders/@w:offsetFrom = 'page'">
            <xsl:variable name="marg" select="concat(w:pgMar/@w:left * 2.54 div 1440.0, 'cm')" />

            <xsl:variable name="space">
              <xsl:call-template name="ConvertPoints">
                <xsl:with-param name="length">
                  <xsl:value-of select="w:pgBorders/w:left/@w:space"/>
                </xsl:with-param>
                <xsl:with-param name="unit">cm</xsl:with-param>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="concat(substring-before($marg,'cm') - substring-before($space,'cm'),'cm')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="ConvertPoints">
              <xsl:with-param name="length">
                <xsl:value-of select="w:pgBorders/w:left/@w:space"/>
              </xsl:with-param>
              <xsl:with-param name="unit">cm</xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="w:pgBorders/w:right">
      <xsl:attribute name="fo:padding-right">
        <xsl:choose>
          <xsl:when test="w:pgBorders/@w:offsetFrom = 'page'">
            <xsl:variable name="marg" select="concat(w:pgMar/@w:right * 2.54 div 1440.0, 'cm')" />

            <xsl:variable name="space">
              <xsl:call-template name="ConvertPoints">
                <xsl:with-param name="length">
                  <xsl:value-of select="w:pgBorders/w:right/@w:space"/>
                </xsl:with-param>
                <xsl:with-param name="unit">cm</xsl:with-param>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of
						  select="concat(substring-before($marg,'cm') - substring-before($space,'cm'),'cm')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="ConvertPoints">
              <xsl:with-param name="length">
                <xsl:value-of select="w:pgBorders/w:right/@w:space"/>
              </xsl:with-param>
              <xsl:with-param name="unit">cm</xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="w:pgBorders/w:bottom">
      <xsl:attribute name="fo:padding-bottom">
        <xsl:choose>
          <xsl:when test="w:pgBorders/@w:offsetFrom = 'page'">
            <xsl:variable name="marg" select="concat(w:pgMar/@w:bottom * 2.54 div 1440.0, 'cm')" />

            <xsl:variable name="space">
              <xsl:call-template name="ConvertPoints">
                <xsl:with-param name="length">
                  <xsl:value-of select="w:pgBorders/w:bottom/@w:space"/>
                </xsl:with-param>
                <xsl:with-param name="unit">cm</xsl:with-param>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of
						  select="concat(substring-before($marg,'cm') - substring-before($space,'cm'),'cm')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="ConvertPoints">
              <xsl:with-param name="length">
                <xsl:value-of select="w:pgBorders/w:bottom/@w:space"/>
              </xsl:with-param>
              <xsl:with-param name="unit">cm</xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- page margins -->
  <xsl:template name="ComputePageMargins">
    <xsl:attribute name="fo:margin-top">
      <xsl:variable name="marg">
        <xsl:call-template name="ConvertTwips">
          <xsl:with-param name="unit">cm</xsl:with-param>
          <xsl:with-param name="length">
            <xsl:choose>
              <!--clam: Bugfix #1797903-->
              <xsl:when test="preceding::w:headerReference/@w:type or ./w:headerReference/@w:type">
                <xsl:choose>
                  <xsl:when test="w:pgMar/@w:top &lt; 0">
                    <xsl:value-of select="w:pgMar/@w:top"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="w:pgMar/@w:header"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="key('Part', 'word/settings.xml')/w:settings/w:gutterAtTop">
                    <xsl:choose>
                      <xsl:when test="w:pgMar/@w:top &lt; 0">
                        <xsl:value-of select="w:pgMar/@w:top + w:pgMar/@w:gutter"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when
													  test="w:pgMar/@w:top + w:pgMar/@w:gutter &lt; w:pgMar/@w:header">
                            <xsl:value-of select="w:pgMar/@w:header"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="w:pgMar/@w:top + w:pgMar/@w:gutter"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="w:pgMar/@w:top"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="w:pgBorders/w:top">
          <xsl:variable name="space">
            <xsl:call-template name="ConvertPoints">
              <xsl:with-param name="length">
                <xsl:value-of select="w:pgBorders/w:top/@w:space"/>
              </xsl:with-param>
              <xsl:with-param name="unit">cm</xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="w:pgBorders/@w:offsetFrom='page'">
              <xsl:value-of select="$space"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(substring-before($marg,'cm') - substring-before($space,'cm'),'cm')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$marg"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <xsl:attribute name="fo:margin-left">
      <xsl:variable name="marg">
        <xsl:call-template name="ConvertTwips">
          <xsl:with-param name="length">
            <xsl:choose>
              <xsl:when test="key('Part', 'word/settings.xml')/w:settings/w:gutterAtTop">
                <xsl:value-of select="w:pgMar/@w:left"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="w:pgMar/@w:left + w:pgMar/@w:gutter"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="unit">cm</xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="w:pgBorders/w:left">
          <xsl:variable name="space">
            <xsl:call-template name="ConvertPoints">
              <xsl:with-param name="length">
                <xsl:value-of select="w:pgBorders/w:left/@w:space"/>
              </xsl:with-param>
              <xsl:with-param name="unit">cm</xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="w:pgBorders/@w:offsetFrom='page'">
              <xsl:value-of select="$space"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(substring-before($marg,'cm') - substring-before($space,'cm'),'cm')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$marg"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <xsl:attribute name="fo:margin-bottom">
      <xsl:variable name="marg">
        <xsl:call-template name="ConvertTwips">
          <xsl:with-param name="unit">cm</xsl:with-param>
          <xsl:with-param name="length">
            <xsl:choose>
              <xsl:when test="preceding::w:footerReference[@w:type='default' or @w:type='even'] or ./w:footerReference[@w:type='default' or @w:type='even']">
                <xsl:choose>
                  <xsl:when test="w:pgMar/@w:bottom &lt; 0">
                    <xsl:value-of select="w:pgMar/@w:bottom"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="w:pgMar/@w:footer"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="w:pgMar/@w:bottom"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="w:pgBorders/w:bottom">
          <xsl:variable name="space">
            <xsl:call-template name="ConvertPoints">
              <xsl:with-param name="length">
                <xsl:value-of select="w:pgBorders/w:bottom/@w:space"/>
              </xsl:with-param>
              <xsl:with-param name="unit">cm</xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="w:pgBorders/@w:offsetFrom='page'">
              <xsl:value-of select="$space"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(substring-before($marg,'cm') - substring-before($space,'cm'),'cm')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$marg"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <xsl:attribute name="fo:margin-right">
      <xsl:variable name="marg" select="concat(w:pgMar/@w:right * 2.54 div 1440.0, 'cm')" />

      <xsl:choose>
        <xsl:when test="w:pgBorders/w:right">
          <xsl:variable name="space">
            <xsl:call-template name="ConvertPoints">
              <xsl:with-param name="length">
                <xsl:value-of select="w:pgBorders/w:right/@w:space"/>
              </xsl:with-param>
              <xsl:with-param name="unit">cm</xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="w:pgBorders/@w:offsetFrom='page'">
              <xsl:value-of select="$space"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
							  select="concat(substring-before($marg,'cm') - substring-before($space,'cm'),'cm')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$marg"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!-- page numbers -->
  <xsl:template name="InsertPageNumbering">
    <xsl:if test="w:pgNumType/@w:fmt">
      <!-- Most number format are lost. -->
      <xsl:choose>
        <xsl:when
				  test="contains(w:pgNumType/@w:fmt,'decimal') or w:pgNumType/@w:fmt = 'numberInDash' or w:pgNumType/@w:fmt = 'ordinal' ">
          <!-- prefix and suffix -->
          <xsl:choose>
            <xsl:when test="w:pgNumType/@w:fmt = 'numberInDash' ">
              <xsl:attribute name="style:num-prefix">- </xsl:attribute>
              <xsl:attribute name="style:num-suffix"> -</xsl:attribute>
            </xsl:when>
            <xsl:when test="w:pgNumType/@w:fmt = 'decimalEnclosedParen' ">
              <xsl:attribute name="style:num-prefix">(</xsl:attribute>
              <xsl:attribute name="style:num-suffix">)</xsl:attribute>
            </xsl:when>
            <xsl:when test="w:pgNumType/@w:fmt = 'decimalEnclosedFullstop' ">
              <xsl:attribute name="style:num-suffix">.</xsl:attribute>
            </xsl:when>
            <xsl:when test="contains(w:pgNumType/@w:fmt,'decimalEnclosedCircle')">
              <xsl:attribute name="style:num-prefix">(</xsl:attribute>
              <xsl:attribute name="style:num-suffix">)</xsl:attribute>
            </xsl:when>
            <xsl:otherwise/>
          </xsl:choose>
          <!-- start number -->
          <xsl:attribute name="style:num-format">
            <xsl:choose>
              <xsl:when test="w:pgNumType/@w:start">
                <xsl:value-of select="w:pgNumType/@w:start"/>
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="w:pgNumType/@w:fmt = 'lowerLetter' ">
          <xsl:attribute name="style:num-format">a</xsl:attribute>
        </xsl:when>
        <xsl:when test="w:pgNumType/@w:fmt = 'upperLetter' ">
          <xsl:attribute name="style:num-format">A</xsl:attribute>
        </xsl:when>
        <xsl:when test="w:pgNumType/@w:fmt = 'lowerRoman' ">
          <xsl:attribute name="style:num-format">i</xsl:attribute>
        </xsl:when>
        <xsl:when test="w:pgNumType/@w:fmt = 'upperRoman' ">
          <xsl:attribute name="style:num-format">I</xsl:attribute>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- header / footer properties -->
  <!-- TODO : handle other properties -->
  <xsl:template name="InsertHeaderFooterProperties">
    <xsl:param name="object"/>

    <!-- min height calculated with page Margins properties. -->
    <xsl:variable name="min-height">
      <xsl:call-template name="ConvertTwips">
        <xsl:with-param name="unit">cm</xsl:with-param>
        <xsl:with-param name="length">
          <xsl:choose>
            <xsl:when test="$object = 'header' ">
              <xsl:choose>
                <!-- if @w:header is not 0, we assume there's a header to compute in this section -->
                <xsl:when test="w:pgMar[@w:header]">
                  <!--and w:pgMar[@w:header != 0]">-->
                  <xsl:choose>
                    <xsl:when test="w:pgMar/@w:top &lt; 0">
                      <xsl:choose>
                        <xsl:when test="key('Part', 'word/settings.xml')/w:settings/w:gutterAtTop">
                          <xsl:choose>
                            <xsl:when
														  test=" - w:pgMar/@w:top + w:pgMar/@w:gutter &lt; w:pgMar/@w:header"
                              >0</xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of
															  select=" - w:pgMar/@w:top + w:pgMar/@w:gutter - w:pgMar/@w:header"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:choose>
                            <xsl:when test=" - w:pgMar/@w:top &lt; w:pgMar/@w:header">0</xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select=" - w:pgMar/@w:top - w:pgMar/@w:header"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="key('Part', 'word/settings.xml')/w:settings/w:gutterAtTop">
                          <xsl:choose>
                            <xsl:when
														  test="w:pgMar/@w:top + w:pgMar/@w:gutter &lt; w:pgMar/@w:header">0</xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of
															  select="w:pgMar/@w:top + w:pgMar/@w:gutter - w:pgMar/@w:header"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:choose>
                            <xsl:when test="w:pgMar/@w:top &lt; w:pgMar/@w:header">0</xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="w:pgMar/@w:top - w:pgMar/@w:header"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <!-- if @w:footer is not 0, we assume there's a footer to compute in this section -->
                <xsl:when test="w:pgMar[@w:footer]">
                  <!--and w:pgMar[@w:footer != 0]">-->
                  <xsl:choose>
                    <xsl:when test="w:pgMar/@w:bottom &lt; 0">
                      <xsl:choose>
                        <xsl:when test=" - w:pgMar/@w:bottom &lt; w:pgMar/@w:footer">0</xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select=" - w:pgMar/@w:bottom - w:pgMar/@w:footer"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="w:pgMar/@w:bottom &lt; w:pgMar/@w:footer">0</xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="w:pgMar/@w:bottom - w:pgMar/@w:footer"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <!--clam, dialogika-->
    <xsl:variable name="min-height-minus-height">
      <xsl:variable name="min-height-without-unit" select="substring($min-height, 0, string-length($min-height)-1)"/>
      <xsl:variable name="min-height-0point1" select="$min-height-without-unit - 0.1"/>
      <xsl:value-of select="concat(string($min-height-0point1), 'cm')"/>
    </xsl:variable>

    <!-- no spacing in OOX. -->
    <xsl:choose>
      <!--clam, dialogika-->
      <xsl:when test="$object = 'header' ">
        <xsl:attribute name="fo:margin-bottom">
          <xsl:value-of select="$min-height-minus-height"/>
        </xsl:attribute>
        <xsl:attribute name="style:dynamic-spacing">true</xsl:attribute>
      </xsl:when>
      <!--<xsl:when test="$object = 'header' ">
        <xsl:attribute name="fo:margin-bottom">0cm</xsl:attribute>
        <xsl:attribute name="style:dynamic-spacing">false</xsl:attribute>
      </xsl:when>-->
      <xsl:otherwise>
        <!--clam, dialogika: bugfix 1911678-->
        <xsl:attribute name="style:dynamic-spacing">true</xsl:attribute>
        <xsl:attribute name="fo:margin-top">
          <xsl:value-of select="$min-height-minus-height"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:attribute name="fo:margin-left">0cm</xsl:attribute>
    <xsl:attribute name="fo:margin-right">0cm</xsl:attribute>

    <xsl:attribute name="fo:min-height">
      <xsl:value-of select="$min-height"/>
    </xsl:attribute>

  </xsl:template>

  <xsl:template name="InsertStyleFamily">
    <xsl:attribute name="style:family">
      <xsl:choose>
        <xsl:when test="@w:type = 'character' ">
          <xsl:text>text</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@w:type"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="InsertExtraTabs">
    <xsl:param name="currentStyleId"/>
    <style:tab-stops>
      <xsl:for-each
			  select="key('Part', 'word/document.xml')/descendant::w:pPr[w:pStyle/@w:val = $currentStyleId][1]/w:tabs/w:tab">
        <xsl:call-template name="InsertTabs"/>
      </xsl:for-each>
    </style:tab-stops>
  </xsl:template>

  <!-- Properties for paragraphs having no w:pPr element -->
  <xsl:template name="InsertDefaultParagraphProperties">
    <xsl:if test="self::w:p[not(w:pPr)]">
      <style:paragraph-properties>


        <!-- Sets top and/or bottom  margin if contextual spacing applies-->
        <xsl:variable name="isContextualSpacing">
          <xsl:call-template name="isContextualSpacing"/>
        </xsl:variable>
        <xsl:if test="$isContextualSpacing = 'true' ">
          <xsl:call-template name="contextualSpacing">
            <xsl:with-param name="prevP" select="preceding-sibling::w:p[1]"/>
            <xsl:with-param name="nextP" select="following-sibling::w:p[1]"/>
          </xsl:call-template>
        </xsl:if>

        <xsl:variable name="isContextualSpacingApplied">
          <!-- Copy of the preceding template (we cant write attributes and get a return value-->
          <xsl:choose>
            <xsl:when test="$isContextualSpacing = 'true' ">
              <xsl:call-template name="contextualSpacingApplied">
                <xsl:with-param name="prevP" select="preceding-sibling::w:p[1]"/>
                <xsl:with-param name="nextP" select="following-sibling::w:p[1]"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'false'" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!--Check if contextualSpacing was applied-->
        <!--If not Insert margins in style from Normal Style or w:default -->

        <xsl:if test="$isContextualSpacingApplied='false'">
          <xsl:variable name="DefaultBefore">
            <xsl:call-template name="getMarginTopFromWpPrDefault"/>
          </xsl:variable>

          <xsl:variable name="DefaultAfter">
            <xsl:call-template name="getMarginBottomFromWpPrDefault"/>
          </xsl:variable>

          <!--clam, dialogika: default line height added as bugfix for 1998724-->
          <xsl:variable name="DefaultLineHeight">
            <xsl:call-template name="getLineHeightFromWpPrDefault"/>
          </xsl:variable>

          <xsl:variable name="DefaultLineRule">
            <xsl:call-template name="getLineRuleFromWpPrDefault"/>
          </xsl:variable>

          <xsl:if test="not($DefaultLineHeight = '0')">

            <xsl:choose>
              <xsl:when test="$DefaultLineRule='atLeast'">
                <xsl:attribute name="style:line-height-at-least">
                  <xsl:value-of select="concat($DefaultLineHeight * 2.54 div 1440.0, 'cm')" />
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="$DefaultLineRule='exact'">
                <xsl:attribute name="fo:line-height">
                  <xsl:value-of select="concat($DefaultLineHeight * 2.54 div 1440.0, 'cm')" />
                </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <!-- value of lineRule is 'auto' -->
                <xsl:attribute name="fo:line-height">
                  <!-- convert 240th of line to percent -->
                  <xsl:value-of select="concat($DefaultLineHeight div 240 * 100,'%')"/>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>

          </xsl:if>

          <xsl:call-template name="InsertPageNumberOffset" />

          <xsl:call-template name="setFoMarginTop">
            <xsl:with-param name="setParagraphWBefore" select="$DefaultBefore"/>
          </xsl:call-template>

          <xsl:call-template name="setFoMarginBottom">
            <xsl:with-param name="setParagraphWAfter" select="$DefaultAfter"/>
          </xsl:call-template>

          <!--math, dialogika: bugfix #1775344 BEGIN-->
          <!--get indent from default properties-->
          <!-- ODF4.0M2-->
          <xsl:attribute name="fo:margin-left">
            <xsl:choose>
              <xsl:when test="key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:start">
                <xsl:value-of select="concat(key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:start * 2.54 div 1440.0, 'cm')" />
              </xsl:when>
              <xsl:when test="key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:left">
                <xsl:value-of select="concat(key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:left * 2.54 div 1440.0, 'cm')" />
              </xsl:when>
            </xsl:choose>
          </xsl:attribute>

          <xsl:attribute name="fo:margin-right">
            <xsl:choose>
              <xsl:when test="key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:end">
                <xsl:value-of select="concat(key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:end * 2.54 div 1440.0, 'cm')" />
              </xsl:when>
              <xsl:when test="key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:right">
                <xsl:value-of select="concat(key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:right * 2.54 div 1440.0, 'cm')" />
              </xsl:when>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="fo:text-indent">
            <xsl:choose>
              <xsl:when test="key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:hanging != ''">
                <xsl:value-of select="concat(-key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:hanging * 2.54 div 1440.0, 'cm')" />
              </xsl:when>
              <xsl:when test="key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:firstLine != ''">
                <xsl:value-of select="concat(key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:firstLine * 2.54 div 1440.0, 'cm')" />
              </xsl:when>
              <xsl:otherwise>0cm</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <!--math, dialogika: bugfix #1775344 END-->

        </xsl:if>
        <!--//Insert margins in style from Normal
        Style or w:default -->

        <!-- no spacing in OOX. when the paragraph is in table-->
        <xsl:if test="ancestor::w:tc">
          <xsl:attribute name="fo:margin-bottom">0cm</xsl:attribute>
          <xsl:attribute name="fo:margin-top">0cm</xsl:attribute>
        </xsl:if>

        <xsl:call-template name="InsertParagraphWidowControl"/>
        <xsl:call-template name="InsertDropCapProperties"/>
      </style:paragraph-properties>
    </xsl:if>
  </xsl:template>

  <xsl:template name="contextualSpacingApplied">
    <xsl:param name="prevP" select="parent::w:p/preceding-sibling::w:p[1]"/>
    <!-- The previous paragraph -->
    <xsl:param name="nextP" select="parent::w:p/following-sibling::w:p[1]"/>
    <!-- The next paragraph -->

    <xsl:variable name="isContextualSpacing">
      <xsl:call-template name="isContextualSpacing"/>
    </xsl:variable>

    <xsl:variable name="topContextualApplied">
      <!-- Sets the top margin if there is a preceding paragraph... -->
      <xsl:if test="$prevP">
        <xsl:variable name="prevStyle" select="$prevP/w:pPr/w:pStyle/@w:val"/>
        <!-- The previous paragraph's style  -->
        <!-- ... and the previous pararaph has the same style -->
        <xsl:if test="w:pStyle/@w:val = $prevStyle or (boolean(w:pStyle/@w:val) = false() and boolean($prevStyle) = false())">
          <xsl:value-of select="'true'"/>
        </xsl:if>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="BottomContextualApplied">
      <!-- Sets the bottom margin if there is a following paragraph... -->
      <xsl:if test="$nextP">

        <xsl:variable name="nextStyle" select="$nextP/w:pPr/w:pStyle/@w:val"/>
        <!-- The next paragraph's style  -->
        <!-- ... and the next paragraph has the same style  -->
        <xsl:if test="w:pStyle/@w:val = $nextStyle or (boolean(w:pStyle/@w:val) = false() and boolean($nextStyle) = false())">
          <xsl:value-of select="'true'"/>
        </xsl:if>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="bCtxIsApplied">
      <xsl:choose>
        <xsl:when test="$isContextualSpacing='true' and ($topContextualApplied='true' or $BottomContextualApplied='true')">
          <xsl:value-of select="'true'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'false'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="$bCtxIsApplied"/>

  </xsl:template>

  <!-- Retrieve drop cap properties, if any -->
  <xsl:template name="InsertDropCapProperties">
    <xsl:variable name="prev-paragraph" select="ancestor-or-self::w:p[1]/preceding-sibling::w:p[1]"/>
    <xsl:if test="$prev-paragraph/w:pPr/w:framePr[@w:dropCap]">
      <xsl:variable name="dropcap-properties" select="$prev-paragraph/w:pPr/w:framePr"/>
      <style:drop-cap style:length="{string-length($prev-paragraph/w:r[1]/w:t)}"
			  style:style-name="{generate-id($prev-paragraph/w:r[1])}">
        <xsl:attribute name="style:lines">
          <xsl:choose>
            <xsl:when test="$dropcap-properties/@w:lines">
              <xsl:value-of select="$dropcap-properties/@w:lines"/>
            </xsl:when>
            <xsl:otherwise>2</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:if test="$dropcap-properties/@w:hSpace">
          <xsl:attribute name="style:distance">
            <xsl:value-of select="concat($dropcap-properties/@w:hSpace * 2.54 div 1440.0, 'cm')" />
          </xsl:attribute>
        </xsl:if>
      </style:drop-cap>
    </xsl:if>
  </xsl:template>

  <!-- Compute style and text properties of context style. -->
  <xsl:template name="InsertStyleProperties">

    <xsl:if test="self::node()/@w:type = 'paragraph'">
      <style:paragraph-properties>
        <xsl:if test="w:pPr">
          <xsl:for-each select="w:pPr">
            <xsl:call-template name="InsertParagraphProperties"/>
          </xsl:for-each>
        </xsl:if>

        <!-- add default paragraph propeties to Normal or Default style (it can't be in style:default-style becouse of OO bug ? (see #1593148 image partly lost))-->
        <!--clam, dialogika: bugfix 1911687-->
        <!--<xsl:if test="self::node()/@w:styleId = 'Normal' or self::node()/@w:styleId = 'Default'">
          <xsl:for-each select="ancestor::w:styles/w:docDefaults">
            <xsl:if test="w:pPrDefault/w:pPr">
              <xsl:for-each select="w:pPrDefault/w:pPr">
                <xsl:call-template name="InsertParagraphProperties"/>
              </xsl:for-each>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>-->

        <xsl:variable name="isDefaultTOCStyle">
          <xsl:call-template name ="CheckDefaultTOCStyle">
            <xsl:with-param name="name">
              <xsl:value-of select="self::node()/@w:styleId" />
            </xsl:with-param>
          </xsl:call-template>
        </xsl:variable>

        <!--<xsl:if test="contains(self::node()/@w:styleId,'TOC') or contains(self::node()/@w:styleId,'TableofFigures') and not(w:pPr/w:tabs)">-->
        <xsl:if test="$isDefaultTOCStyle='true' or contains(self::node()/@w:styleId,'TableofFigures') and not(w:pPr/w:tabs)">
          <xsl:call-template name="InsertExtraTabs">
            <xsl:with-param name="currentStyleId">
              <xsl:value-of select="self::node()/@w:styleId"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>

        <!-- Drop cap paragraph properties -->
        <xsl:call-template name="InsertDropCapProperties"/>

        <!-- Insert default text alignment property for bidi paragraphs -->
        <!--<xsl:for-each select="w:pPr">
          <xsl:call-template name="InsertDefaultBidiProperties"/>
        </xsl:for-each>-->

      </style:paragraph-properties>
    </xsl:if>

    <xsl:if test="(self::node()/@w:type = 'paragraph' and w:rPr) or self::node()/@w:type = 'character'">
      <style:text-properties>
        <xsl:if test="w:rPr">
          <xsl:for-each select="w:rPr">
            <xsl:call-template name="InsertTextProperties"/>
          </xsl:for-each>
          <xsl:for-each select="w:pPr">
            <xsl:call-template name="InsertpPrTextProperties"/>
          </xsl:for-each>
        </xsl:if>
      </style:text-properties>
    </xsl:if>

  </xsl:template>


  <!--math, dialogika: changed for correct indentation calculation BEGIN -->
  <xsl:template name="CheckIfList">
    <xsl:param name="StyleId"/>


    <xsl:variable name="numId">
      <xsl:choose>

        <!--<xsl:when test="w:numPr/w:numId/@w:val and w:numPr/w:ilvl/@w:val &lt; 10">-->
        <xsl:when test="w:numPr/w:numId/@w:val">
          <xsl:value-of select ="w:numPr/w:numId/@w:val" />
        </xsl:when>

        <!--<xsl:when test="parent::w:style[@w:styleId=$StyleId]/w:pPr/w:numPr/w:numId/@w:val and parent::w:style[@w:styleId=$StyleId]/w:pPr/w:numPr/w:ilvl/@w:val &lt; 10">-->
        <xsl:when test="parent::w:style[@w:styleId=$StyleId]/w:pPr/w:numPr/w:numId/@w:val">
          <xsl:value-of select ="parent::w:style[@w:styleId=$StyleId]/w:pPr/w:numPr/w:numId/@w:val" />
        </xsl:when>

        <!--<xsl:when test="key('Part', 'word/styles.xml')/w:styles/w:style[@w:styleId=$StyleId]/w:pPr/w:numPr/w:numId/@w:val and key('Part', 'word/styles.xml')/w:styles/w:style[@w:styleId=$StyleId]/w:pPr/w:numPr/w:ilvl/@w:val &lt; 10">-->
        <xsl:when test="key('StyleId', $StyleId)/w:pPr/w:numPr/w:numId/@w:val">
          <xsl:value-of select ="key('StyleId', $StyleId)/w:pPr/w:numPr/w:numId/@w:val" />
        </xsl:when>

        <xsl:otherwise>NaN</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!--math, dialogika: ilvl needed for bugfix #1948002-->
    <xsl:variable name="ilvl">
      <xsl:choose>

        <xsl:when test="w:numPr/w:ilvl/@w:val">
          <xsl:value-of select ="w:numPr/w:ilvl/@w:val" />
        </xsl:when>

        <xsl:when test="parent::w:style[@w:styleId=$StyleId]/w:pPr/w:numPr/w:ilvl/@w:val">
          <xsl:value-of select ="parent::w:style[@w:styleId=$StyleId]/w:pPr/w:numPr/w:ilvl/@w:val" />
        </xsl:when>

        <xsl:when test="key('StyleId', $StyleId)/w:pPr/w:numPr/w:ilvl/@w:val">
          <xsl:value-of select ="key('StyleId', $StyleId)/w:pPr/w:numPr/w:ilvl/@w:val" />
        </xsl:when>

        <xsl:otherwise>NaN</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <!--math, dialogika: bugfix #1827476 BEGIN-->
      <xsl:when test="$numId = '0'">false</xsl:when>
      <!--math, dialogika: bugfix #1827476 END-->

      <!--math, dialogika: Bugfix #1948002 if numFmt = 'none' return false-->
      <xsl:when test="key('abstractNumId', key('numId', $numId)/w:abstractNumId/@w:val)/w:lvl[@w:ilvl=$ilvl]/w:numFmt/@w:val='none'">false</xsl:when>
      <xsl:when test="$numId != 'NaN' and key('numId', $numId)">true</xsl:when>
      <xsl:when test="key('StyleId', $StyleId)/w:basedOn/@w:val">
        <xsl:call-template name="CheckIfList">
          <xsl:with-param name ="StyleId" select="key('StyleId', $StyleId)/w:basedOn/@w:val"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!--math, dialogika: changed for correct indentation calculation END -->



  <xsl:template name="FirstLine">

    <xsl:variable name="StyleId" select="w:pStyle/@w:val|parent::w:style/@w:styleId"/>

    <xsl:variable name="NumId">
      <xsl:choose>
        <xsl:when test="w:numPr/w:numId/@w:val">
          <xsl:value-of select="w:numPr/w:numId/@w:val"/>
        </xsl:when>
        <xsl:when test="key('StyleId', $StyleId)/w:pPr/w:numPr/w:numId/@w:val">
          <xsl:value-of select="key('StyleId', $StyleId)/w:pPr/w:numPr/w:numId/@w:val" />
        </xsl:when>
        <xsl:when test="key('Part', 'word/document.xml')/w:document/w:body/w:p/w:pPr/w:pStyle[@w:val=$StyleId]/following-sibling::w:numPr/w:numId/@w:val != ''">
          <xsl:value-of select="key('Part', 'word/document.xml')/w:document/w:body/w:p/w:pPr/w:pStyle[@w:val=$StyleId]/following-sibling::w:numPr/w:numId/@w:val" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="Abstract" select="parent::w:abstractNum/@w:abstractNumId"/>
          <xsl:value-of select="key('Part', 'word/numbering.xml')/w:numbering/w:num[w:abstractNumId/@w:val = $Abstract]/@w:numId" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="Ivl">
      <xsl:choose>
        <xsl:when test="w:numPr/w:ilvl/@w:val">
          <xsl:value-of select="w:numPr/w:ilvl/@w:val"/>
        </xsl:when>
        <xsl:when test="./@w:ilvl">
          <xsl:value-of select="./@w:ilvl"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="key('Part', 'word/styles.xml')">
            <xsl:choose>
              <xsl:when test="key('StyleId',$StyleId)/w:pPr/w:numPr/w:ilvl/@w:val">
                <xsl:value-of select="key('StyleId',$StyleId)/w:pPr/w:numPr/w:ilvl/@w:val"/>
              </xsl:when>
              <xsl:otherwise/>
            </xsl:choose>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="AbstractNumId">
      <xsl:choose>
        <xsl:when
				  test="key('numId', $NumId)/w:abstractNumId/@w:val">
          <xsl:value-of select="key('numId', $NumId)/w:abstractNumId/@w:val" />
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="w:ind/@w:firstLine != ''">
        <xsl:value-of select="w:ind/@w:firstLine"/>
      </xsl:when>
      <xsl:when
			  test="key('abstractNumId', $AbstractNumId)/w:lvl[@w:ilvl=$Ivl]/w:pPr/w:ind/@w:firstLine and $Ivl &lt; 10">
        <xsl:value-of
				  select="key('abstractNumId', $AbstractNumId)/w:lvl[@w:ilvl=$Ivl]/w:pPr/w:ind/@w:firstLine"
        />
      </xsl:when>
      <xsl:when
			  test="key('Part', 'word/document.xml')/w:document/w:body/w:p[w:pPr/w:numPr/w:numId/@w:val = $NumId]/w:pPr/w:ind/@w:firstLine and $Ivl &lt; 10">
        <xsl:value-of
				  select="key('Part', 'word/document.xml')/w:document/w:body/w:p[w:pPr/w:numPr/w:numId/@w:val = $NumId]/w:pPr/w:ind/@w:firstLine"
        />
      </xsl:when>
      <xsl:otherwise>NaN</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="CalculateMarginLeft">
    <xsl:param name="StyleId"/>
    <xsl:param name="CheckIfList"/>
    <xsl:param name="IndHanging"/>
    <xsl:param name="IndLeft"/>

    <xsl:choose>
      <xsl:when test="$CheckIfList='true'">
        <xsl:variable name="NumId">
          <xsl:choose>
            <xsl:when test="w:numPr/w:numId/@w:val">
              <xsl:value-of select="w:numPr/w:numId/@w:val"/>
            </xsl:when>
            <xsl:when
						  test="key('StyleId', $StyleId)/w:pPr/w:numPr/w:numId/@w:val">
              <xsl:value-of
							  select="key('StyleId', $StyleId)/w:pPr/w:numPr/w:numId/@w:val"
              />
            </xsl:when>
            <xsl:when
						  test="key('Part', 'word/document.xml')/w:document/w:body/w:p/w:pPr/w:pStyle[@w:val=$StyleId]/following-sibling::w:numPr/w:numId/@w:val != ''">
              <xsl:value-of
							  select="key('Part', 'word/document.xml')/w:document/w:body/w:p/w:pPr/w:pStyle[@w:val=$StyleId]/following-sibling::w:numPr/w:numId/@w:val"
              />
            </xsl:when>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="Ivl">
          <xsl:choose>
            <xsl:when test="w:numPr/w:ilvl/@w:val">
              <xsl:value-of select="w:numPr/w:ilvl/@w:val"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="key('Part', 'word/styles.xml')">
                <xsl:choose>
                  <xsl:when test="key('StyleId',$StyleId)/w:pPr/w:numPr/w:ilvl/@w:val">
                    <xsl:value-of select="key('StyleId',$StyleId)/w:pPr/w:numPr/w:ilvl/@w:val"/>
                  </xsl:when>
                  <xsl:otherwise/>
                </xsl:choose>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="AbstractNumId">
          <xsl:choose>
            <xsl:when
						  test="key('numId', $NumId)/w:abstractNumId/@w:val">
              <xsl:value-of select="key('numId', $NumId)/w:abstractNumId/@w:val" />
            </xsl:when>
          </xsl:choose>
        </xsl:variable>

        <!-- ODF4.0M2-->
        <xsl:variable name="LeftNumber">
          <xsl:choose>
            <xsl:when test="key('abstractNumId', $AbstractNumId)/w:lvl[@w:ilvl=$Ivl]/w:pPr/w:ind/@w:start">
              <xsl:value-of select="key('abstractNumId', $AbstractNumId)/w:lvl[@w:ilvl=$Ivl]/w:pPr/w:ind/@w:start"/>
            </xsl:when>
            <xsl:when test="key('abstractNumId', $AbstractNumId)/w:lvl[@w:ilvl=$Ivl]/w:pPr/w:ind/@w:left">
              <xsl:value-of select="key('abstractNumId', $AbstractNumId)/w:lvl[@w:ilvl=$Ivl]/w:pPr/w:ind/@w:left"
              />
            </xsl:when>
            <xsl:when test="key('numId', $NumId)/w:lvlOverride/w:lvl/w:pPr/w:ind/@w:start">
              <xsl:value-of select="key('numId', $NumId)/w:lvlOverride/w:lvl/w:pPr/w:ind/@w:start" />
            </xsl:when>
            <xsl:when test="key('numId', $NumId)/w:lvlOverride/w:lvl/w:pPr/w:ind/@w:left">
              <xsl:value-of select="key('numId', $NumId)/w:lvlOverride/w:lvl/w:pPr/w:ind/@w:left" />
            </xsl:when>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="HangingNumber">
          <xsl:choose>
            <xsl:when
						  test="key('abstractNumId', $AbstractNumId)/w:lvl[@w:ilvl=$Ivl]/w:pPr/w:ind/@w:hanging">
              <xsl:value-of
							  select="key('abstractNumId', $AbstractNumId)/w:lvl[@w:ilvl=$Ivl]/w:pPr/w:ind/@w:hanging"
              />
            </xsl:when>
            <xsl:when
						  test="key('numId', $NumId)/w:lvlOverride/w:lvl/w:pPr/w:ind/@w:hanging">
              <xsl:value-of select="key('numId', $NumId)/w:lvlOverride/w:lvl/w:pPr/w:ind/@w:hanging" />
            </xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="FirstLine">
          <xsl:choose>
            <xsl:when test="w:ind/@w:firstLine != ''">
              <xsl:value-of select="w:ind/@w:firstLine"/>
            </xsl:when>
            <xsl:when
						  test="key('abstractNumId', $AbstractNumId)/w:lvl[@w:ilvl=$Ivl]/w:pPr/w:ind/@w:firstLine and $Ivl &lt; 10">
              <xsl:value-of
							  select="key('abstractNumId', $AbstractNumId)/w:lvl[@w:ilvl=$Ivl]/w:pPr/w:ind/@w:firstLine"
              />
            </xsl:when>
            <xsl:otherwise>NaN</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- left indent -->
        <!-- ODF4.0M2-->
        <xsl:choose>
          <xsl:when test="$FirstLine != 'NaN'">
            <xsl:value-of select="$IndLeft"/>
          </xsl:when>
          <xsl:when test=" $LeftNumber = '' and $IndLeft =''">
            <xsl:for-each select="key('Part', 'word/styles.xml')">
              <xsl:choose>
                <xsl:when test="key('StyleId',$StyleId)/w:pPr/w:ind/@w:start">
                  <xsl:choose>
                    <xsl:when test="key('StyleId',$StyleId)/w:pPr/w:ind/@w:start != '' and key('StyleId',$StyleId)/w:pPr/w:ind/@w:hanging != ''">
                      <xsl:value-of select="key('StyleId',$StyleId)/w:pPr/w:ind/@w:start - key('StyleId',$StyleId)/w:pPr/w:ind/@w:hanging"
                  />
                    </xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="key('StyleId',$StyleId)/w:pPr/w:ind/@w:left">
                  <xsl:choose>
                    <xsl:when test="key('StyleId',$StyleId)/w:pPr/w:ind/@w:left != '' and key('StyleId',$StyleId)/w:pPr/w:ind/@w:hanging != ''">
                      <xsl:value-of select="key('StyleId',$StyleId)/w:pPr/w:ind/@w:left - key('StyleId',$StyleId)/w:pPr/w:ind/@w:hanging"
                  />
                    </xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
              </xsl:choose>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="$IndLeft != ''">
            <xsl:choose>
              <xsl:when test="$IndLeft != $IndHanging or ($IndHanging = 0 and $IndLeft= 0)">
                <xsl:choose>
                  <xsl:when
									  test="$LeftNumber = $HangingNumber and ($IndHanging = '' or $IndHanging = 'Nan')">
                    <xsl:value-of select="$IndLeft - $HangingNumber"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$IndLeft - $LeftNumber + $HangingNumber"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="$IndLeft = $IndHanging">0</xsl:when>
              <xsl:when test="$IndLeft != ''">
                <xsl:value-of select="$IndLeft"/>
              </xsl:when>
              <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="w:ind/@w:start != ''">
            <xsl:value-of select="w:ind/@w:start"/>
          </xsl:when>
          <xsl:when test="w:ind/@w:left != ''">
            <xsl:value-of select="w:ind/@w:left"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Regression JP 24.08.2007 <xsl:variable name="context" select="self::node()"/>-->
            <xsl:for-each select="key('Part', 'word/styles.xml')">

              <!--math, dialogika bugfix #1751701 indentation problem BEGIN-->

              <xsl:call-template name="getStyleLeftInd">
                <xsl:with-param name="StyleId">
                  <xsl:value-of select="$StyleId" />
                </xsl:with-param>
              </xsl:call-template>

              <!--<xsl:choose>
                -->
              <!-- Regression JP 24.08.2007 <xsl:when test="not($context/parent::w:p) and key('StyleId',$StyleId)/w:pPr/w:ind/@w:left != ''">-->
              <!--
                <xsl:when test="key('StyleId',$StyleId)/w:pPr/w:ind/@w:left != ''">
                  <xsl:value-of select="key('StyleId',$StyleId)/w:pPr/w:ind/@w:left "/>
                </xsl:when>
                <xsl:when
                  test="contains($StyleId,'TOC') and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:left != ''">
                  <xsl:value-of
                    select="key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:left"
                  />
                </xsl:when>
                <xsl:when
                  test="w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:pPr/w:ind/@w:left">
                  <xsl:value-of
                    select="w:styles/w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:pPr/w:ind/@w:left"
                  />
                </xsl:when>
                <xsl:when test="w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:left != ''">
                  <xsl:value-of select="w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:left"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
              </xsl:choose>-->

              <!--math, dialogika bugfix #1751701 indentation problem END-->

            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--math, dialogika bugfix #1828267 BEGIN-->
  <!--Take leftChars, hangingChars, firstLineChars into account-->

  <xsl:template name="getLeftMarginFromChars">
    <xsl:param name="StyleId" />
    <xsl:param name="TextIndent" />

    <xsl:variable name="LeftChars">
      <xsl:choose>
        <xsl:when test="w:ind/@w:leftChars != ''">
          <xsl:value-of select="w:ind/@w:leftChars"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="key('Part', 'word/styles.xml')">
            <xsl:call-template name="getStyleLeftChars">
              <xsl:with-param name="StyleId">
                <xsl:value-of select="$StyleId" />
              </xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>

      <xsl:when test="$LeftChars != 'NaN'">
        <xsl:choose>
          <!--math, dialogika: empirically determined formula-->
          <xsl:when test="$TextIndent != 'NaN' and $TextIndent &lt; 0">
            <xsl:value-of select="2.574 * $LeftChars - $TextIndent"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="2.574 * $LeftChars "/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="getStyleLeftChars">
    <xsl:param name="StyleId" />

    <xsl:variable name="isDefaultTOCStyle">
      <xsl:call-template name ="CheckDefaultTOCStyle">
        <xsl:with-param name="name">
          <xsl:value-of select="$StyleId" />
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <!-- Regression JP 24.08.2007 <xsl:when test="not($context/parent::w:p) and key('StyleId',$StyleId)/w:pPr/w:ind/@w:left != ''">-->
      <xsl:when test="key('StyleId',$StyleId)/w:pPr/w:ind/@w:leftChars != ''">
        <xsl:value-of select="key('StyleId',$StyleId)/w:pPr/w:ind/@w:leftChars "/>
      </xsl:when>

      <!--<xsl:when test="contains($StyleId,'TOC') and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:leftChars != ''">-->
      <xsl:when test="$isDefaultTOCStyle='true' and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:leftChars != ''">
        <xsl:value-of select="key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:leftChars" />
      </xsl:when>

      <xsl:when test="w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:pPr/w:ind/@w:leftChars">
        <xsl:value-of select="w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:pPr/w:ind/@w:leftChars" />
      </xsl:when>

      <xsl:when test="w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:leftChars != ''">
        <xsl:value-of select="w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:leftChars"/>
      </xsl:when>

      <xsl:when test="key('StyleId',$StyleId)/w:basedOn/@w:val">
        <xsl:call-template name="getStyleLeftChars">
          <xsl:with-param name="StyleId">
            <xsl:value-of select="key('StyleId',$StyleId)/w:basedOn/@w:val" />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>NaN</xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="getStyleTextIndChars">
    <xsl:param name="StyleId" />

    <xsl:variable name="isDefaultTOCStyle">
      <xsl:call-template name ="CheckDefaultTOCStyle">
        <xsl:with-param name="name">
          <xsl:value-of select="$StyleId" />
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>

      <xsl:when test="key('StyleId',$StyleId)/w:pPr/w:ind/@w:hangingChars != ''">
        <xsl:value-of select="-key('StyleId',$StyleId)/w:pPr/w:ind/@w:hangingChars "/>
      </xsl:when>

      <xsl:when test="key('StyleId',$StyleId)/w:pPr/w:ind/@w:firstLineChars != ''">
        <xsl:value-of select="key('StyleId',$StyleId)/w:pPr/w:ind/@w:firstLineChars"/>
      </xsl:when>

      <!--<xsl:when test="contains($StyleId,'TOC') and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:hangingChars != ''">-->
      <xsl:when test="$isDefaultTOCStyle='true' and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:hangingChars != ''">
        <xsl:value-of select="-key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:hangingChars" />
      </xsl:when>

      <!--<xsl:when test="contains($StyleId,'TOC') and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:firstLineChars != ''">-->
      <xsl:when test="$isDefaultTOCStyle='true' and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:firstLineChars != ''">
        <xsl:value-of select="key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:firstLineChars" />
      </xsl:when>

      <xsl:when test="w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:pPr/w:ind/@w:hangingChars">
        <xsl:value-of select="-w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:pPr/w:ind/@w:hangingChars" />
      </xsl:when>

      <xsl:when test="w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:pPr/w:ind/@w:firstLineChars">
        <xsl:value-of select="w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:pPr/w:ind/@w:firstLineChars" />
      </xsl:when>


      <xsl:when test="w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:hangingChars != ''">
        <xsl:value-of select="-w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:hangingChars"/>
      </xsl:when>

      <xsl:when test="w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:firstLineChars != ''">
        <xsl:value-of select="w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:firstLineChars"/>
      </xsl:when>


      <xsl:when test="key('StyleId',$StyleId)/w:basedOn/@w:val">
        <xsl:call-template name="getStyleTextIndChars">
          <xsl:with-param name="StyleId">
            <xsl:value-of select="key('StyleId',$StyleId)/w:basedOn/@w:val" />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>NaN</xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="getTextIndentFromChars">
    <xsl:param name="StyleId" />


    <xsl:variable name="TextIndentChars">
      <xsl:choose>
        <xsl:when test="w:ind/@w:hangingChars">
          <xsl:value-of select="-w:ind/@w:hangingChars"/>
        </xsl:when>
        <xsl:when test="w:ind/@w:firstLineChars">
          <xsl:value-of select="w:ind/@w:firstLineChars"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="key('Part', 'word/styles.xml')">
            <xsl:call-template name="getStyleTextIndChars">
              <xsl:with-param name="StyleId">
                <xsl:value-of select="$StyleId" />
              </xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="FontSizeInHalfPoints" >
      <xsl:call-template name="getFontSizeInHalfPoints">
        <xsl:with-param name="StyleId">
          <xsl:value-of select="$StyleId"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$TextIndentChars != 'NaN' and $FontSizeInHalfPoints != 'NaN'">
        <!--math, dialogika: empirically determined formula-->
        <xsl:value-of select="$TextIndentChars*(0.17 + $FontSizeInHalfPoints * 0.1)"/>
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="getFontSizeInHalfPoints">
    <xsl:param name="StyleId" />

    <xsl:choose>
      <xsl:when test="../w:r[1]/w:rPr/w:sz/@w:val != ''">
        <xsl:value-of select="../w:r[1]/w:rPr/w:sz/@w:val"/>
      </xsl:when>
      <xsl:when test="../w:r[1]/w:rPr/w:szCs/@w:val != ''">
        <xsl:value-of select="../w:r[1]/w:rPr/w:szCs/@w:val"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="key('Part', 'word/styles.xml')">
          <xsl:call-template name="getStyleFontSize">
            <xsl:with-param name="StyleId">
              <xsl:value-of select="$StyleId" />
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="getStyleFontSize">
    <xsl:param name="StyleId" />

    <xsl:variable name="isDefaultTOCStyle">
      <xsl:call-template name ="CheckDefaultTOCStyle">
        <xsl:with-param name="name">
          <xsl:value-of select="$StyleId" />
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>

      <xsl:when test="key('StyleId',$StyleId)/w:rPr/w:sz/@w:val != ''">
        <xsl:value-of select="key('StyleId',$StyleId)/w:rPr/w:sz/@w:val "/>
      </xsl:when>

      <xsl:when test="key('StyleId',$StyleId)/w:rPr/w:szCs/@w:val != ''">
        <xsl:value-of select="key('StyleId',$StyleId)/w:rPr/w:szCs/@w:val "/>
      </xsl:when>

      <!--<xsl:when test="contains($StyleId,'TOC') and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:rPr/w:sz/@w:val != ''">-->
      <xsl:when test="$isDefaultTOCStyle='true' and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:rPr/w:sz/@w:val != ''">
        <xsl:value-of select="key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:rPr/w:sz/@w:val" />
      </xsl:when>

      <!--<xsl:when test="contains($StyleId,'TOC') and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:rPr/w:szCs/@w:val != ''">-->
      <xsl:when test="$isDefaultTOCStyle='true' and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:rPr/w:szCs/@w:val != ''">
        <xsl:value-of select="key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:rPr/w:szCs/@w:val" />
      </xsl:when>


      <xsl:when test="w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:rPr/w:sz/@w:val">
        <xsl:value-of select="w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:rPr/w:sz/@w:val" />
      </xsl:when>

      <xsl:when test="w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:rPr/w:szCs/@w:val">
        <xsl:value-of select="w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:rPr/w:szCs/@w:val" />
      </xsl:when>


      <xsl:when test="w:styles/w:docDefaults/w:pPrDefault/w:rPr/w:sz/@w:val != ''">
        <xsl:value-of select="w:styles/w:docDefaults/w:pPrDefault/w:rPr/w:sz/@w:val"/>
      </xsl:when>

      <xsl:when test="w:styles/w:docDefaults/w:pPrDefault/w:rPr/w:szCs/@w:val != ''">
        <xsl:value-of select="w:styles/w:docDefaults/w:pPrDefault/w:rPr/w:szCs/@w:val"/>
      </xsl:when>


      <xsl:when test="key('StyleId',$StyleId)/w:basedOn/@w:val">
        <xsl:call-template name="getStyleFontSize">
          <xsl:with-param name="StyleId">
            <xsl:value-of select="key('StyleId',$StyleId)/w:basedOn/@w:val" />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>NaN</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--math, dialogika bugfix #1828267 END-->


  <!--math, dialogika bugfix #1751701 indentation problem BEGIN-->
  <xsl:template name="getStyleLeftInd">
    <xsl:param name="StyleId" />

    <xsl:variable name="isDefaultTOCStyle">
      <xsl:call-template name ="CheckDefaultTOCStyle">
        <xsl:with-param name="name">
          <xsl:value-of select="$StyleId" />
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <!-- Regression JP 24.08.2007 <xsl:when test="not($context/parent::w:p) and key('StyleId',$StyleId)/w:pPr/w:ind/@w:left != ''">-->
      <xsl:when test="key('StyleId',$StyleId)/w:pPr/w:ind/@w:start != ''">
        <xsl:value-of select="key('StyleId',$StyleId)/w:pPr/w:ind/@w:start "/>
      </xsl:when>

      <xsl:when test="key('StyleId',$StyleId)/w:pPr/w:ind/@w:left != ''">
        <xsl:value-of select="key('StyleId',$StyleId)/w:pPr/w:ind/@w:left "/>
      </xsl:when>

      <!--<xsl:when test="contains($StyleId,'TOC') and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:left != ''">-->
      <xsl:when test="$isDefaultTOCStyle='true' and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:start != ''">
        <xsl:value-of select="key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:start" />
      </xsl:when>

      <xsl:when test="$isDefaultTOCStyle='true' and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:left != ''">
        <xsl:value-of select="key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:left" />
      </xsl:when>

      <!-- makz: bugfix 1947862 :
      
        First check if there is a basedOn style.
        If there is no basedOn style, use the default style.
        
        -->
      <xsl:when test="key('StyleId',$StyleId)/w:basedOn/@w:val">
        <!-- use the basedOn style -->
        <xsl:call-template name="getStyleLeftInd">
          <xsl:with-param name="StyleId">
            <xsl:value-of select="key('StyleId',$StyleId)/w:basedOn/@w:val" />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$StyleId = ''">
        <xsl:choose>
          <!-- use the default style -->
          <xsl:when test="w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:pPr/w:ind/@w:start">
            <xsl:value-of select="w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:pPr/w:ind/@w:start" />
          </xsl:when>
          <xsl:when test="w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:pPr/w:ind/@w:left">
            <xsl:value-of select="w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:pPr/w:ind/@w:left" />
          </xsl:when>

          <xsl:when test="w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:start != ''">
            <xsl:value-of select="w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:start"/>
          </xsl:when>
          <xsl:when test="w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:left != ''">
            <xsl:value-of select="w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:left"/>
          </xsl:when>

          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--math, dialogika bugfix #1751701 indentation problem END-->


  <!--math, dialogika bugfix #1744208 and #1645291 BEGIN-->

  <xsl:template name="CalculateMarginRight">
    <xsl:param name="StyleId" />

    <xsl:choose>
      <xsl:when test="w:ind/@w:end != ''">
        <xsl:value-of select="w:ind/@w:end"/>
      </xsl:when>
      <xsl:when test="w:ind/@w:right != ''">
        <xsl:value-of select="w:ind/@w:right"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="key('Part', 'word/styles.xml')">
          <xsl:call-template name="getStyleRightInd">
            <xsl:with-param name="StyleId">
              <xsl:value-of select="$StyleId" />
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="getStyleRightInd">
    <xsl:param name="StyleId" />

    <xsl:variable name="isDefaultTOCStyle">
      <xsl:call-template name ="CheckDefaultTOCStyle">
        <xsl:with-param name="name">
          <xsl:value-of select="$StyleId" />
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="key('StyleId',$StyleId)/w:pPr/w:ind/@w:end != ''">
        <xsl:value-of select="key('StyleId',$StyleId)/w:pPr/w:ind/@w:end "/>
      </xsl:when>
      <xsl:when test="key('StyleId',$StyleId)/w:pPr/w:ind/@w:right != ''">
        <xsl:value-of select="key('StyleId',$StyleId)/w:pPr/w:ind/@w:right "/>
      </xsl:when>

      <!--<xsl:when test="contains($StyleId,'TOC') and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:right != ''">-->
      <xsl:when test="$isDefaultTOCStyle='true' and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:end != ''">
        <xsl:value-of select="key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:end" />
      </xsl:when>
      <xsl:when test="$isDefaultTOCStyle='true' and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:right != ''">
        <xsl:value-of select="key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:right" />
      </xsl:when>
      <!-- makz: bugfix 1947862 :
      
      First check if there is a basedOn style.
      If there is no basedOn style, use the default style.
      -->

      <xsl:when test="key('StyleId',$StyleId)/w:basedOn/@w:val">
        <!-- use the basedOn style -->
        <xsl:call-template name="getStyleRightInd">
          <xsl:with-param name="StyleId">
            <xsl:value-of select="key('StyleId',$StyleId)/w:basedOn/@w:val" />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$StyleId = ''">
            <!-- use the default style -->
            <xsl:choose>
              <xsl:when test="w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:pPr/w:ind/@w:end">
                <xsl:value-of select="w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:pPr/w:ind/@w:end" />
              </xsl:when>
              <xsl:when test="w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:pPr/w:ind/@w:right">
                <xsl:value-of select="w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:pPr/w:ind/@w:right" />
              </xsl:when>

              <xsl:when test="w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:end != ''">
                <xsl:value-of select="w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:end"/>
              </xsl:when>
              <xsl:when test="w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:right != ''">
                <xsl:value-of select="w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:right"/>
              </xsl:when>
              <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--math, dialogika bugfix #1828267 BEGIN-->
  <!--Take leftChars, hangingChars, firstLineChars into account-->

  <xsl:template name="CalculateTextIndent">
    <xsl:param name="StyleId" />

    <xsl:choose>
      <xsl:when test="w:ind/@w:hanging">
        <xsl:value-of select="-w:ind/@w:hanging"/>
      </xsl:when>
      <xsl:when test="w:ind/@w:firstLine">
        <xsl:value-of select="w:ind/@w:firstLine"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="key('Part', 'word/styles.xml')">
          <xsl:call-template name="getStyleTextInd">
            <xsl:with-param name="StyleId" select="$StyleId" />
          </xsl:call-template>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="getStyleTextInd">
    <xsl:param name="StyleId" />

    <xsl:variable name="isDefaultTOCStyle">
      <xsl:call-template name ="CheckDefaultTOCStyle">
        <xsl:with-param name="name">
          <xsl:value-of select="$StyleId" />
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>

      <xsl:when test="key('StyleId',$StyleId)/w:pPr/w:ind/@w:hanging != ''">
        <xsl:value-of select="-key('StyleId',$StyleId)/w:pPr/w:ind/@w:hanging "/>
      </xsl:when>

      <xsl:when test="key('StyleId',$StyleId)/w:pPr/w:ind/@w:firstLine != ''">
        <xsl:value-of select="key('StyleId',$StyleId)/w:pPr/w:ind/@w:firstLine"/>
      </xsl:when>


      <!--<xsl:when test="contains($StyleId,'TOC') and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:hanging != ''">-->
      <xsl:when test="$isDefaultTOCStyle='true' and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:hanging != ''">
        <xsl:value-of select="-key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:hanging" />
      </xsl:when>

      <!--<xsl:when test="contains($StyleId,'TOC') and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:firstLine != ''">-->
      <xsl:when test="$isDefaultTOCStyle='true' and key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:firstLine != ''">
        <xsl:value-of select="key('StyleId',concat('Contents_20',substring-after($StyleId,'TOC')))/w:pPr/w:ind/@w:firstLine" />
      </xsl:when>


      <xsl:when test="w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:pPr/w:ind/@w:hanging">
        <xsl:value-of select="-w:styles/w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:pPr/w:ind/@w:hanging" />
      </xsl:when>

      <xsl:when test="w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:pPr/w:ind/@w:firstLine">
        <xsl:value-of select="w:styles/w:styles/w:style[@w:default = 1 or @w:default = 'true' or @w:default = 'on' and w:type='paragraph']/w:pPr/w:ind/@w:firstLine" />
      </xsl:when>


      <xsl:when test="w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:hanging != ''">
        <xsl:value-of select="-w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:hanging"/>
      </xsl:when>

      <xsl:when test="w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:firstLine != ''">
        <xsl:value-of select="w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:ind/@w:firstLine"/>
      </xsl:when>


      <xsl:when test="key('StyleId',$StyleId)/w:basedOn/@w:val">
        <xsl:call-template name="getStyleTextInd">
          <xsl:with-param name="StyleId">
            <xsl:value-of select="key('StyleId',$StyleId)/w:basedOn/@w:val" />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--math, dialogika bugfix #1744208 and #1645291 END-->


  <xsl:template name="InsertParagraphPropertiesDefault">
    <xsl:call-template name="InsertParagraphBreakBefore"/>
    <xsl:call-template name="InsertParagraphAutoSpace"/>
    <xsl:call-template name="InsertParagraphWidowControl"/>
    <xsl:call-template name="InsertSuppressLineNumbering"/>
    <xsl:call-template name="InsertDropCapProperties"/>
  </xsl:template>

  <!-- conversion of paragraph properties -->
  <xsl:template name="InsertParagraphProperties">
    <!-- TODO : report lost attributes :
      w:afterAutospacing and w:beforeAutospacing attributes are lost
      w:afterLines and w:beforeLines attributes are lost 
    -->
    <xsl:variable name="StyleId" select="w:pStyle/@w:val|parent::w:style/@w:styleId"/>

    <!-- are we in a list -->
    <xsl:variable name="CheckIfList">
      <xsl:call-template name="CheckIfList">
        <xsl:with-param name="StyleId" select="$StyleId"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- left indent -->
    <xsl:variable name="IndLeft">
      <xsl:choose>
        <xsl:when test="w:ind/@w:start != ''">
          <xsl:value-of select="number(w:ind/@w:start)"/>
        </xsl:when>
        <xsl:when test="w:ind/@w:left != ''">
          <xsl:value-of select="number(w:ind/@w:left)"/>
        </xsl:when>

        <!-- Automatic styles should not duplicate the inherited fo:margin-left property (cf. 15.5.17 of ODF v 1.0 spec)  -->
        <xsl:when test="key('StyleId', $StyleId)/w:pPr/w:ind/@w:start != '' and $CheckIfList != 'true'">
          <xsl:value-of select="key('StyleId', $StyleId)/w:pPr/w:ind/@w:start" />
        </xsl:when>
        <xsl:when test="key('StyleId', $StyleId)/w:pPr/w:ind/@w:left != '' and $CheckIfList != 'true'">
          <xsl:value-of select="key('StyleId', $StyleId)/w:pPr/w:ind/@w:left" />
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <!-- hanging indent -->
    <xsl:variable name="IndHanging">
      <xsl:choose>
        <xsl:when test="w:ind/@w:hanging != ''">
          <xsl:value-of select="number(w:ind/@w:hanging)"/>
        </xsl:when>
        <!-- Automatic styles should not duplicate the inherited fo:text-indent property  -->
        <xsl:when test="key('StyleId', $StyleId)/w:pPr/w:ind/@w:hanging != ''">
          <xsl:value-of select="key('StyleId', $StyleId)/w:pPr/w:ind/@w:hanging" />
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <!--math, dialogika bugfix #1828267 BEGIN
        Workaround for Office 2003 conversion bug:
        take leftChars, hangingChars, firstLineChars into account-->

    <!-- text indent -->
    <xsl:variable name="TextIndent">
      <xsl:variable name="TextIndentTemp">
        <xsl:call-template name="CalculateTextIndent">
          <xsl:with-param name="StyleId" select="$StyleId"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$TextIndentTemp = '31680' or $TextIndentTemp = '-31680'">
          <!--Office 2003 conversion bug ch -> twips-->
          <xsl:call-template name="getTextIndentFromChars">
            <xsl:with-param name="StyleId">
              <xsl:value-of select="$StyleId"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$TextIndentTemp" />
        </xsl:otherwise>
      </xsl:choose>

    </xsl:variable>

    <!-- margin left -->
    <xsl:variable name="MarginLeft">
      <xsl:variable name="LeftTemp">
        <xsl:call-template name="CalculateMarginLeft">
          <xsl:with-param name="StyleId">
            <xsl:value-of select="$StyleId"/>
          </xsl:with-param>
          <xsl:with-param name="CheckIfList">
            <xsl:value-of select="$CheckIfList"/>
          </xsl:with-param>
          <xsl:with-param name="IndHanging">
            <xsl:value-of select="$IndHanging"/>
          </xsl:with-param>
          <xsl:with-param name="IndLeft">
            <xsl:value-of select="$IndLeft"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:variable>

      <xsl:choose>

        <xsl:when test="$LeftTemp = '31680'">
          <!--Office 2003 conversion bug ch -> twips-->
          <xsl:call-template name="getLeftMarginFromChars">
            <xsl:with-param name="StyleId">
              <xsl:value-of select="$StyleId" />
            </xsl:with-param>
            <xsl:with-param name="TextIndent">
              <xsl:value-of select="$TextIndent"/>
            </xsl:with-param>
          </xsl:call-template>

        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$LeftTemp" />
        </xsl:otherwise>
      </xsl:choose>

    </xsl:variable>

    <!--math, dialogika bugfix #1828267 END-->


    <!--math, dialogika bugfix #1744208 and #1645291 BEGIN-->

    <!-- margin right -->
    <xsl:variable name="MarginRight">
      <xsl:call-template name="CalculateMarginRight">
        <xsl:with-param name="StyleId">
          <xsl:value-of select="$StyleId"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <!--math, dialogika bugfix #1744208 and #1645291 END-->


    <!-- handle frames in text used as char-->
    <xsl:if test="contains(parent::w:p/w:r/w:pict/v:shape/@style,'mso-position-horizontal-relative:char') and not(w:textAlignment)">
      <xsl:attribute name="style:vertical-align">bottom</xsl:attribute>
    </xsl:if>

    <!-- no spacing in OOX. when the paragraph is in table-->

    <!-- BUG 1693008 - Space before and after paragraph is lost in tables - 05/07/2007
      Why desactivate spacing when paragraph is in table ???
      With theses values set to 0cm, never the margin on top and bottom will be applied
      -->

    <!-- insert attributes using match -->
    <xsl:apply-templates mode="pPrChildren"/>

    <!-- insert default properties for bidi paragraphs -->
    <xsl:call-template name="InsertDefaultBidiProperties"/>

    <xsl:call-template name="InsertPageNumberOffset" />

    <!-- Sets top and/or bottom  margin if contextual spacing applies -->
    <xsl:variable name="isContextualSpacing">
      <xsl:call-template name="isContextualSpacing"/>
    </xsl:variable>
    <xsl:if test="$isContextualSpacing = 'true' ">
      <xsl:call-template name="contextualSpacing"/>
    </xsl:if>

    <!-- Must not set it to 0 because it can overwrite the parent style -->
    <!--xsl:if test="ancestor::w:tc">
      <xsl:attribute name="fo:margin-bottom">0cm</xsl:attribute>
      <xsl:attribute name="fo:margin-top">0cm</xsl:attribute>
    </xsl:if-->

    <xsl:if test="ancestor::w:tc and ancestor::w:tbl/w:tblPr/w:tblStyle">
      <xsl:if test="$StyleId = ''">
        <xsl:variable name="TableStyleName" select="ancestor::w:tbl/w:tblPr/w:tblStyle/@w:val"></xsl:variable>
        <xsl:variable name="Spacing" select="key('Part', 'word/styles.xml')/w:styles/w:style[@w:styleId=$TableStyleName]/w:pPr/w:spacing"></xsl:variable>
        <xsl:if test="$Spacing/@w:after='0'">
          <xsl:attribute name="fo:margin-bottom">0cm</xsl:attribute>
        </xsl:if>
      </xsl:if>
    </xsl:if>


    <!-- insert attributes using template -->
    <xsl:call-template name="InsertParagraphBreakBefore"/>

    <xsl:call-template name="InsertParagraphAutoSpace"/>

    <!--math, dialogika: changed for correct indentation calculation BEGIN -->
    <!--added parameter <xsl:with-param name="StyleContext">-->

    <xsl:call-template name="InsertParagraphIndent">
      <xsl:with-param name="MarginLeft" select="$MarginLeft"/>
      <!--math, dialogika bugfix #1744208 and #1645291 BEGIN-->
      <xsl:with-param name="MarginRight" select="$MarginRight"/>
      <xsl:with-param name="TextIndent" select="$TextIndent"/>
      <!--math, dialogika bugfix #1744208 and #1645291 END-->
      <xsl:with-param name="CheckIfList" select="$CheckIfList"/>
      <xsl:with-param name="IndHanging" select="$IndHanging"/>
      <xsl:with-param name="IndLeft" select="$IndLeft"/>
      <xsl:with-param name="StyleContext">
        <xsl:choose>
          <xsl:when test="parent::w:style/@w:styleId">
            <xsl:value-of select="'true'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'false'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>

    <!--math, dialogika: changed for correct indentation calculation END -->

    <xsl:call-template name="InsertParagraphWidowControl"/>
    <xsl:call-template name="InsertSuppressLineNumbering"/>

    <!-- child elements : -->
    <!-- tab-stops -->
    <xsl:call-template name="InsertParagraphTabStops">
      <xsl:with-param name="MarginLeft" select="$MarginLeft"/>
      <xsl:with-param name="parentStyleId" select="w:pStyle/@w:val|parent::w:style/w:basedOn/@w:val" />
    </xsl:call-template>

    <!-- drop cap properties -->
    <xsl:call-template name="InsertDropCapProperties"/>
  </xsl:template>


  <xsl:template name="contextualSpacing">
    <!-- @Description: Sets top and bottom margin to zero to emulate contextual spacing feature
            Expects that template isContextualSpacing is called before calling this template for 
            performance reasons 
      -->
    <!-- @Context: A paragraph node (i.e. &lt;w:Ppr&gt;), or a node paragraph property node (i.e. &lt;w:Ppr&gt;) -->
    <!-- @Returns: Nothing -->

    <xsl:param name="prevP" select="parent::w:p/preceding-sibling::w:p[1]"/>
    <!-- The previous paragraph -->
    <xsl:param name="nextP" select="parent::w:p/following-sibling::w:p[1]"/>
    <!-- The next paragraph -->

    <!--xsl:variable name="isContextualSpacing">
      <xsl:call-template name="isContextualSpacing"/>
    </xsl:variable-->

    <!-- if contextual spacing is applied to the current paragraph -->
    <!--xsl:if test="$isContextualSpacing = 'true' "-->

    <!-- Sets the top margin if there is a preceding paragraph... -->
    <xsl:if test="$prevP">

      <xsl:variable name="prevStyle" select="$prevP/w:pPr/w:pStyle/@w:val"/>
      <!-- The previous paragraph's style  -->

      <!-- ... and the previous pararaph has the same style -->
      <xsl:if test="w:pStyle/@w:val = $prevStyle or (boolean(w:pStyle/@w:val) = false() and boolean($prevStyle) = false())">
        <xsl:attribute name="fo:margin-top">0cm</xsl:attribute>
      </xsl:if>
    </xsl:if>

    <!-- Sets the bottom margin if there is a following paragraph... -->
    <xsl:if test="$nextP">

      <xsl:variable name="nextStyle" select="$nextP/w:pPr/w:pStyle/@w:val"/>
      <!-- The next paragraph's style  -->

      <!-- ... and the next paragraph has the same style  -->
      <xsl:if test="w:pStyle/@w:val = $nextStyle or (boolean(w:pStyle/@w:val) = false() and boolean($nextStyle) = false())">
        <xsl:attribute name="fo:margin-bottom">0cm</xsl:attribute>
      </xsl:if>
    </xsl:if>
    <!--/xsl:if-->
  </xsl:template>

  <xsl:template name="isContextualSpacing">
    <!-- @Description:  Checks whether the current paragraph has contextual spacing -->
    <!-- @Context: A paragraph node (i.e. &lt;w:Ppr&gt;), or a node paragraph property node (i.e. &lt;w:Ppr&gt;)-->
    <!-- @Returns: <b>true</b> if the current paragraph has contextual spacing, <b>false</b> otherwise    -->

    <xsl:choose>

      <!-- is Contextual Spacing defined in current paragraph properties?... -->
      <xsl:when test="w:contextualSpacing/@w:val= '0' ">false</xsl:when>
      <xsl:when test="w:contextualSpacing">true</xsl:when>

      <!-- is Contextual Spacing defined in parent style?... -->
      <xsl:when test="w:pStyle/@w:val">
        <xsl:call-template name="isContextualSpacingInStyle">
          <xsl:with-param name="styleID" select="w:pStyle/@w:val"/>
        </xsl:call-template>
      </xsl:when>

      <!-- is Contextual Spacing defined in default style?... -->
      <xsl:otherwise>
        <xsl:call-template name="isContextualSpacingInStyle"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="isContextualSpacingInStyle">
    <!-- @Description: Checks a given style for contextual spacing. If not found, 
                       will search recursively in the parent's styles -->
    <!-- @Context:     none -->
    <!-- @Returns:     <b>true</b> if the element &lt;w:contextualSpacing/&gt; is found, 
                       <b>false</b> otherwise. -->

    <xsl:param name="styleID"/>
    <!-- The style ID of the style to be parsed. 
                                      If not specified will use the default style -->

    <!-- Switch context in order to parse the styles in word/styles.xml -->
    <xsl:for-each select="key('Part', 'word/styles.xml')/w:styles">
      <xsl:choose>

        <!-- We have a named style... -->
        <xsl:when test="$styleID">
          <xsl:variable name="style" select="key('StyleId', $styleID)"/>
          <!--  The style to be parsed -->

          <xsl:choose>
            <xsl:when test="$style/w:pPr/w:contextualSpacing/@w:val= '0' ">false</xsl:when>
            <xsl:when test="$style/w:pPr/w:contextualSpacing">true</xsl:when>

            <!-- Search the parent style if any... -->
            <xsl:otherwise>
              <xsl:variable name="parentStyleID" select="$style/w:basedOn/@w:val"/>
              <xsl:choose>
                <xsl:when test="$parentStyleID">
                  <xsl:call-template name="isContextualSpacingInStyle">
                    <xsl:with-param name="styleID" select="$parentStyleID"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <!-- Checks the default style...  -->
        <xsl:otherwise>
          <xsl:variable name="style" select="key('default-styles', 'paragraph')"/>
          <xsl:choose>
            <xsl:when test="$style/w:pPr/w:contextualSpacing">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>

      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- break before paragraph -->
  <xsl:template name="InsertParagraphBreakBefore">
    <xsl:choose>
      <xsl:when test="parent::w:p/w:r/w:br[@w:type='page' or @w:type='column'] and not(ancestor::w:tc)">
        <!-- if this is a break page-->
        <xsl:if test="parent::w:p/w:r/w:br[@w:type='page']">
          <xsl:call-template name="InsertFlagTextBeforeBreakPage2"/>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="parent::w:p//w:t or parent::w:p//w:br">
            <xsl:attribute name="fo:break-before">
              <xsl:value-of select="parent::w:p/w:r/w:br[@w:type='page' or @w:type='column']/@w:type"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <!--clam: empty paragraphs with page break before insert unwanted line breaks-->
            <xsl:attribute name="fo:break-after">
              <xsl:value-of select="parent::w:p/w:r/w:br[@w:type='page' or @w:type='column']/@w:type"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <!--<xsl:attribute name="fo:break-before">
          <xsl:value-of select="parent::w:p/w:r/w:br[@w:type='page' or @w:type='column']/@w:type"/>
        </xsl:attribute>-->
      </xsl:when>
      <xsl:when test="w:r/w:br[@w:type='page' or @w:type='column']">
        <!-- if this is a break page-->
        <xsl:if test="w:r/w:br[@w:type='page']">
          <xsl:call-template name="InsertFlagTextBeforeBreakPage1"/>
        </xsl:if>
        <xsl:attribute name="fo:break-before">
          <xsl:value-of select="w:br[@w:type='page' or @w:type='column']/@w:type"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>

        <xsl:if test="w:pageBreakBefore">

          <!-- 20080715/divo performance optimization -->
          <!--
          <xsl:variable name="precSectPr" select="preceding::w:p[1]/w:pPr/w:sectPr" />
          <xsl:variable name="followingSectPr" select="following::w:sectPr[1]" />
          -->
          <!--
          <xsl:variable name="precSectPr" select="key('p', number(ancestor-or-self::node()/@oox:id) - 1)/w:pPr/w:sectPr" />
				  <xsl:variable name="followingSectPr" select="key('sectPr', number(ancestor-or-self::node()/@oox:s))" />
          -->

          <!--
          makz/divo:  we don't know if this test is really necessary.
                      It avoids that a pagebreak is written if it is the first paragraph in a section and the section has also a break before
          
          <xsl:if
            test="($precSectPr/w:pgSz/@w:w = $followingSectPr/w:pgSz/@w:w
            and $precSectPr/w:pgSz/@w:h = $followingSectPr/w:pgSz/@w:h
            and ($precSectPr/w:pgSz/@w:orient = $followingSectPr/w:pgSz/@w:orient
            or (not($precSectPr/w:pgSz/@w:orient) and not($followingSectPr/w:pgSz/@w:orient)))
            and $precSectPr/w:pgMar/@w:top = $followingSectPr/w:pgMar/@w:top
            and $precSectPr/w:pgMar/@w:left = $followingSectPr/w:pgMar/@w:left
            and $precSectPr/w:pgMar/@w:right = $followingSectPr/w:pgMar/@w:right
            and $precSectPr/w:pgMar/@w:bottom = $followingSectPr/w:pgMar/@w:bottom
            and $precSectPr/w:pgMar/@w:header = $followingSectPr/w:pgMar/@w:header
            and $precSectPr/w:pgMar/@w:footer = $followingSectPr/w:pgMar/@w:footer
            and (not($precSectPr/w:headerReference) or not($followingSectPr/w:headerReference))
            and (not($precSectPr/w:footerReference) or not($followingSectPr/w:footerReference)))
            or not($precSectPr)">
          -->

          <!-- if this is a break page-->
          <xsl:if test="w:pageBreakBefore/@w:val!='off' and w:pageBreakBefore/@w:val!='false' and w:pageBreakBefore/@w:val!=0">
            <xsl:call-template name="InsertFlagTextBeforeBreakPage3"/>
          </xsl:if>
          <xsl:attribute name="fo:break-before">
            <xsl:choose>
              <xsl:when test="w:pageBreakBefore/@w:val='off' or w:pageBreakBefore/@w:val='false' or w:pageBreakBefore/@w:val=0">
                <xsl:value-of select="'auto'"/>
              </xsl:when>
              <xsl:when test="w:pageBreakBefore/@w:val='on' or w:pageBreakBefore/@w:val='true' or w:pageBreakBefore/@w:val=1">
                <xsl:value-of select="'page'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'page'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:if>
        <!--</xsl:if>-->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Detect if there is text before a break page in a paragraph -->
  <!-- BUG 1583404 - Page breaks not correct converted - 09/07/2007-->
  <xsl:template name="InsertFlagTextBeforeBreakPage1">
    <!--2008-10-31/divo: Fix for #2124338 
        fo:break-before="page" has no effect for the first paragraph in an ODT document, therefore we need to create an extra paragraph
        This more than ugly implementation done in the previous fix for #1583404 show how f****d up this whole XSLT thing really is... -->
    <xsl:if test="preceding-sibling::w:r/w:t[1] or not(../preceding-sibling::node())">
      <xsl:attribute name="pcut:cut">
        <xsl:value-of select="'1'"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="InsertFlagTextBeforeBreakPage2">
    <!--2008-10-31/divo: Fix for #2124338 
        fo:break-before="page" has no effect for the first paragraph in an ODT document, therefore we need to create an extra paragraph
        This more than ugly implementation done in the previous fix for #1583404 show how f****d up this whole XSLT thing really is... -->
    <xsl:if test="parent::w:p/w:r[w:br[@w:type='page']]/preceding-sibling::w:r/w:t[1] or not(../preceding-sibling::node())">
      <xsl:attribute name="pcut:cut">
        <xsl:value-of select="'1'"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="InsertFlagTextBeforeBreakPage3">
    <xsl:if test="ancestor::w:r/preceding-sibling::w:r/w:t[1]">
      <xsl:attribute name="pcut:cut">
        <xsl:value-of select="'1'"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- text autospace -->
  <xsl:template name="InsertParagraphAutoSpace">
    <xsl:if test="w:autoSpaceDN or w:autoSpaceDE">
      <xsl:attribute name="style:text-autospace">
        <xsl:choose>
          <xsl:when
					  test="w:autoSpaceDN/@w:val='off' or w:autoSpaceDN/@w:val='false' or w:autoSpaceDN/@w:val=0 or w:autoSpaceDE/@w:val='off' or w:autoSpaceDE/@w:val='false' or w:autoSpaceDE/@w:val=0">
            <xsl:value-of select="'none'"/>
          </xsl:when>
          <xsl:when
					  test="w:autoSpaceDN/@w:val='on' or w:autoSpaceDN/@w:val='true' or w:autoSpaceDN/@w:val=1 or w:autoSpaceDE/@w:val='on' or w:autoSpaceDE/@w:val='true' or w:autoSpaceDE/@w:val=1">
            <xsl:value-of select="'ideograph-alpha'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'ideograph-alpha'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>


  <!--math, dialogika: changed for correct indentation calculation BEGIN -->

  <xsl:template name="GetIndirectListLevelParameter">
    <xsl:param name="StyleId"/>
    <xsl:param name="Parameter"/>

    <xsl:variable name="NumberingDefinitions" select="key('Part', 'word/numbering.xml')/w:numbering"/>

    <xsl:variable name="ParagraphStyleDefinition" select="key('StyleId',$StyleId)"/>

    <xsl:variable name="IndirectNumId" select="$ParagraphStyleDefinition/w:pPr/w:numPr/w:numId/@w:val"/>

    <xsl:variable name="IndirectAbstractNumId" select="key('numId', $IndirectNumId)/w:abstractNumId/@w:val"/>

    <xsl:variable name="IndirectIlvl">
      <xsl:choose>
        <xsl:when test="$ParagraphStyleDefinition/w:pPr/w:numPr/w:ilvl/@w:val">
          <xsl:value-of select="$ParagraphStyleDefinition/w:pPr/w:numPr/w:ilvl/@w:val"/>
        </xsl:when>
        <xsl:when test="key('abstractNumId', $IndirectAbstractNumId)/w:lvl[w:pStyle/@w:val=$StyleId]">
          <xsl:value-of select="key('abstractNumId', $IndirectAbstractNumId)/w:lvl[w:pStyle/@w:val=$StyleId]/@w:ilvl"/>
        </xsl:when>
        <!--assume default level 0-->
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="IndirectListLevelDefinition" select="key('abstractNumId', $IndirectAbstractNumId)/w:lvl[@w:ilvl=$IndirectIlvl][1]"/>

    <xsl:choose>
      <xsl:when test = "$IndirectListLevelDefinition">
        <xsl:choose>
          <xsl:when test = "$Parameter='NumId'" >
            <xsl:value-of select="$IndirectNumId" />
          </xsl:when>
          <xsl:when test = "$Parameter='AbstractNumId'" >
            <xsl:value-of select="$IndirectAbstractNumId" />
          </xsl:when>
          <xsl:when test = "$Parameter='Ilvl'" >
            <xsl:value-of select="$IndirectIlvl" />
          </xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test = "$ParagraphStyleDefinition/w:basedOn/@w:val">
        <xsl:call-template name="GetIndirectListLevelParameter">
          <xsl:with-param name="StyleId">
            <xsl:value-of select="$ParagraphStyleDefinition/w:basedOn/@w:val" />
          </xsl:with-param>
          <xsl:with-param name="Parameter">
            <xsl:value-of select="$Parameter" />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>

    </xsl:choose>

  </xsl:template>


  <!-- space before/after -->
  <xsl:template name="InsertParagraphIndent">
    <xsl:param name="MarginLeft"/>
    <!--math, dialogika bugfix #1744208 and #1645291 BEGIN-->
    <xsl:param name="MarginRight"/>
    <xsl:param name="TextIndent"/>
    <!--math, dialogika bugfix #1744208 and #1645291 END-->
    <xsl:param name="CheckIfList"/>
    <xsl:param name="IndHanging"/>
    <xsl:param name="IndLeft"/>
    <xsl:param name="StyleContext"/>

    <xsl:choose>
      <xsl:when test="$CheckIfList = 'true'">

        <!-- in list -->

        <!--<xsl:message terminate="no">translation.oox2odf.lists.indentation.directFormatting</xsl:message>-->

        <xsl:attribute name="fo:margin-left">0cm</xsl:attribute>

        <xsl:choose>

          <xsl:when test="$StyleContext = 'true'">
            <!--in style context-->
            <xsl:attribute name="fo:text-indent">0cm</xsl:attribute>
          </xsl:when>

          <xsl:otherwise>

            <!--not in style context-->
            <xsl:variable name="DirectNumId" select="w:numPr/w:numId/@w:val"/>
            <xsl:variable name="DirectIlvl" select="w:numPr/w:ilvl/@w:val"/>
            <xsl:variable name="NumberingDefinitions" select="key('Part', 'word/numbering.xml')/w:numbering"/>
            <xsl:variable name="DirectAbstractNumId" select="key('numId', $DirectNumId)/w:abstractNumId/@w:val"/>
            <xsl:variable name="DirectListLevelDefinition" select="key('abstractNumId', $DirectAbstractNumId)/w:lvl[@w:ilvl=$DirectIlvl][1]"/>
            <xsl:variable name="StyleId" select="w:pStyle/@w:val"/>
            <xsl:variable name="ParagraphStyleDefinition" select="key('StyleId', $StyleId)[1]"/>

            <xsl:variable name="IndirectNumId">
              <xsl:call-template name="GetIndirectListLevelParameter">
                <xsl:with-param name="StyleId">
                  <xsl:value-of select="$StyleId" />
                </xsl:with-param>
                <xsl:with-param name="Parameter">NumId</xsl:with-param>
              </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="IndirectAbstractNumId">
              <xsl:call-template name="GetIndirectListLevelParameter">
                <xsl:with-param name="StyleId">
                  <xsl:value-of select="$StyleId" />
                </xsl:with-param>
                <xsl:with-param name="Parameter">AbstractNumId</xsl:with-param>
              </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="IndirectIlvl">
              <xsl:call-template name="GetIndirectListLevelParameter">
                <xsl:with-param name="StyleId">
                  <xsl:value-of select="$StyleId" />
                </xsl:with-param>
                <xsl:with-param name="Parameter">Ilvl</xsl:with-param>
              </xsl:call-template>
            </xsl:variable>


            <xsl:variable name="IndirectListLevelDefinition" select="key('abstractNumId', $IndirectAbstractNumId)/w:lvl[@w:ilvl=$IndirectIlvl][1]"/>


            <!--math: bugfix #2142500 : Use IndirectListLevelDefinition only if no direct list level definition is present.
            If direct list level definition is present and no w:suff is defined there, the standard ('tab') is used in Word, anyway.
            (not the value of w:suff of the indirect list level definition).-->
            <xsl:variable name ="Suffix">
              <xsl:choose>
                <xsl:when test="$DirectListLevelDefinition/w:suff/@w:val">
                  <xsl:value-of select="$DirectListLevelDefinition/w:suff/@w:val" />
                </xsl:when>
                <xsl:when test="not($DirectListLevelDefinition) and $IndirectListLevelDefinition/w:suff/@w:val">
                  <xsl:value-of select="$IndirectListLevelDefinition/w:suff/@w:val" />
                </xsl:when>
                <xsl:otherwise>'tab'</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:variable name="Hanging">
              <xsl:choose>
                <xsl:when test="w:ind/@w:hanging">
                  <!--Paragraph has direct formatting -> take this value-->
                  <xsl:value-of select="w:ind/@w:hanging"/>
                </xsl:when>

                <xsl:otherwise>
                  <!--Paragraph has *NO* direct formatting-->

                  <xsl:choose>

                    <!-- FIRSTLINE: direct firstLine counts-->
                    <xsl:when test="w:ind/@w:firstLine">0</xsl:when>

                    <xsl:when test="$DirectListLevelDefinition/w:pPr/w:ind/@w:hanging">
                      <!--take directly referenced list style value -->
                      <xsl:value-of select="$DirectListLevelDefinition/w:pPr/w:ind/@w:hanging"/>
                    </xsl:when>

                    <!--FIRSTLINE: directly referenced list style firstLine value counts-->
                    <xsl:when test="$DirectListLevelDefinition/w:pPr/w:ind/@w:firstLine">0</xsl:when>

                    <xsl:when test="$ParagraphStyleDefinition/w:pPr/w:ind/@w:hanging">
                      <!--take paragraph style value-->
                      <xsl:value-of select="$ParagraphStyleDefinition/w:pPr/w:ind/@w:hanging"/>
                    </xsl:when>

                    <!--FIRSTLINE: paragraph style firstLine value counts-->
                    <xsl:when test="$ParagraphStyleDefinition/w:pPr/w:ind/@w:firstLine">0</xsl:when>

                    <xsl:when test="$IndirectListLevelDefinition/w:pPr/w:ind/@w:hanging">
                      <!--take list style value referenced by paragraph style-->
                      <xsl:value-of select="$IndirectListLevelDefinition/w:pPr/w:ind/@w:hanging"/>
                    </xsl:when>

                    <xsl:otherwise>0</xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>


            <xsl:variable name="FirstLine">
              <xsl:choose>

                <!--hanging has more priority than firstline-->
                <xsl:when test="$Hanging != '0'">0</xsl:when>

                <xsl:when test="w:ind/@w:firstLine">
                  <!--Paragraph has direct formatting -> take this value-->
                  <xsl:value-of select="w:ind/@w:firstLine"/>
                </xsl:when>

                <xsl:otherwise>
                  <!--Paragraph has *NO* direct formatting-->

                  <xsl:choose>

                    <xsl:when test="$DirectListLevelDefinition/w:pPr/w:ind/@w:firstLine">
                      <!--take directly referenced list style value -->
                      <xsl:value-of select="$DirectListLevelDefinition/w:pPr/w:ind/@w:firstLine"/>
                    </xsl:when>

                    <xsl:when test="$ParagraphStyleDefinition/w:pPr/w:ind/@w:firstLine">
                      <!--take paragraph style value-->
                      <xsl:value-of select="$ParagraphStyleDefinition/w:pPr/w:ind/@w:firstLine"/>
                    </xsl:when>

                    <xsl:when test="$IndirectListLevelDefinition/w:pPr/w:ind/@w:firstLine">
                      <!--take list style value referenced by paragraph style-->
                      <xsl:value-of select="$IndirectListLevelDefinition/w:pPr/w:ind/@w:firstLine"/>
                    </xsl:when>

                    <xsl:otherwise>0</xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="Left">
              <xsl:choose>
                <xsl:when test="w:ind/@w:start">
                  <!--Paragraph has direct formatting -> take this value-->
                  <xsl:value-of select="w:ind/@w:start"/>
                </xsl:when>
                <xsl:when test="w:ind/@w:left">
                  <!--Paragraph has direct formatting -> take this value-->
                  <xsl:value-of select="w:ind/@w:left"/>
                </xsl:when>
                <xsl:otherwise>
                  <!--Paragraph has *NO* direct formatting-->
                  <xsl:choose>
                    <xsl:when test="$DirectListLevelDefinition/w:pPr/w:ind/@w:start">
                      <!--take directly referenced list style value -->
                      <xsl:value-of select="$DirectListLevelDefinition/w:pPr/w:ind/@w:start"/>
                    </xsl:when>
                    <xsl:when test="$DirectListLevelDefinition/w:pPr/w:ind/@w:left">
                      <!--take directly referenced list style value -->
                      <xsl:value-of select="$DirectListLevelDefinition/w:pPr/w:ind/@w:left"/>
                    </xsl:when>

                    <xsl:when test="$ParagraphStyleDefinition/w:pPr/w:ind/@w:start">
                      <!--take paragraph style value-->
                      <xsl:value-of select="$ParagraphStyleDefinition/w:pPr/w:ind/@w:start"/>
                    </xsl:when>
                    <xsl:when test="$ParagraphStyleDefinition/w:pPr/w:ind/@w:left">
                      <!--take paragraph style value-->
                      <xsl:value-of select="$ParagraphStyleDefinition/w:pPr/w:ind/@w:left"/>
                    </xsl:when>

                    <xsl:when test="$IndirectListLevelDefinition/w:pPr/w:ind/@w:start">
                      <!--take list style value referenced by paragraph style-->
                      <xsl:value-of select="$IndirectListLevelDefinition/w:pPr/w:ind/@w:left"/>
                    </xsl:when>
                    <xsl:when test="$IndirectListLevelDefinition/w:pPr/w:ind/@w:start">
                      <!--take list style value referenced by paragraph style-->
                      <xsl:value-of select="$IndirectListLevelDefinition/w:pPr/w:ind/@w:left"/>
                    </xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="tabs" select="$DirectListLevelDefinition/w:pPr/w:tabs | $IndirectListLevelDefinition/w:pPr/w:tabs | $ParagraphStyleDefinition/w:pPr/w:tabs | w:tabs" />
            <xsl:variable name="SpaceToNextTab">
              <xsl:variable name="MinTabOffset" select ="350"/>
              <xsl:choose>
                <xsl:when test="$Suffix='nothing'">0</xsl:when>
                <xsl:when test="$Suffix='space'">350</xsl:when>
                <xsl:otherwise>
                  <xsl:variable name="MinRelevantCustomTab">
                    <xsl:choose>
                      <xsl:when test="$Hanging != '0'">
                        <!--hanging -> get min custom tab that is between start of first line and start of paragraph text-->
                        <xsl:call-template name="GetMinVal">
                          <xsl:with-param name="values" select="$tabs/w:tab[@w:pos &gt; ( $Left - $Hanging + $MinTabOffset) and @w:pos &lt; $Left ]/@w:pos" />
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>

                        <!--no hanging -> get min custom tab that is bigger than the start of the first line-->
                        <xsl:call-template name="GetMinVal">
                          <xsl:with-param name="values" select="$tabs/w:tab[@w:pos &gt; ( $Left + $FirstLine + $MinTabOffset)]/@w:pos" />
                        </xsl:call-template>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>

                  <xsl:choose>
                    <xsl:when test="$Hanging != '0'">

                      <!--hanging-->

                      <!--<xsl:value-of select="$Hanging" />-->

                      <xsl:choose>
                        <xsl:when test="$MinRelevantCustomTab != 'NaN'">
                          <!--take min relevant custom tab -->
                          <xsl:value-of select="$Hanging - ($Left - $MinRelevantCustomTab)" />
                        </xsl:when>
                        <xsl:otherwise>
                          <!--take hanging value-->
                          <xsl:value-of select="$Hanging" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>

                    <xsl:otherwise>

                      <!--no hanging-->

                      <xsl:variable name="DefaultTab" select="key('Part', 'word/settings.xml')/w:settings/w:defaultTabStop/@w:val"/>
                      <xsl:variable name="NextDefaultTabPos" select="(floor(($Left + $FirstLine + $MinTabOffset) div $DefaultTab) + 1) * $DefaultTab"/>

                      <xsl:choose>
                        <xsl:when test="$MinRelevantCustomTab != 'NaN'">
                          <!--take min relevant custom tab-->
                          <xsl:value-of select="$MinRelevantCustomTab - ($Left + $FirstLine)"/>
                        </xsl:when>

                        <xsl:otherwise>
                          <!--take next default tab-->
                          <xsl:value-of select="$NextDefaultTabPos - ($Left + $FirstLine)"/>
                        </xsl:otherwise>
                      </xsl:choose>

                    </xsl:otherwise>
                  </xsl:choose>

                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>


            <xsl:choose>
              <xsl:when test="$Hanging != '0'">

                <!--text-indent with hanging-->

                <xsl:attribute name="fo:text-indent">
                  <xsl:value-of select="concat(($SpaceToNextTab - $Hanging) * 2.54 div 1440.0, 'cm')"/>
                </xsl:attribute>

              </xsl:when>

              <xsl:otherwise>

                <!--text-indent without hanging-->

                <!--<xsl:variable name="RelevantCustomTabs"
                   select="$tabs/w:tab[@w:pos &gt; ( $Left + $FirstLine + $MinTabOffset)]" />

                <xsl:variable name="MinRelevantCustomTab">
                  <xsl:choose>
                    <xsl:when test="$RelevantCustomTabs/@w:pos">
                      <xsl:for-each select="$RelevantCustomTabs/@w:pos">
                        <xsl:sort data-type="number" order="ascending"/>
                        <xsl:if test="position()=1">
                          <xsl:value-of select="."/>
                        </xsl:if>
                      </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>NaN</xsl:otherwise>
                  </xsl:choose>                  
                </xsl:variable>

                <xsl:variable name="SpaceToNextTab">
                  <xsl:variable name="DefaultTab">
                    <xsl:value-of select="key('Part', 'word/settings.xml')/w:settings/w:defaultTabStop/@w:val"/>
                  </xsl:variable>
                  <xsl:variable name="NextDefaultTabPos">
                    <xsl:value-of select="(floor(($Left + $FirstLine + $MinTabOffset) div $DefaultTab) + 1) * $DefaultTab"/>
                  </xsl:variable>

                  <xsl:choose>
                    <xsl:when test="$MinRelevantCustomTab != 'NaN'">
                      <xsl:value-of select="$MinRelevantCustomTab - ($Left + $FirstLine)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$NextDefaultTabPos - ($Left + $FirstLine)"/>
                    </xsl:otherwise>
                  </xsl:choose>

                </xsl:variable>-->

                <xsl:attribute name="fo:text-indent">
                  <xsl:value-of select="concat(($FirstLine + $SpaceToNextTab) * 2.54 div 1440.0, 'cm')"/>
                </xsl:attribute>

              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>



      <xsl:otherwise>

        <!-- not in list -->

        <!-- margin left -->

        <xsl:attribute name="fo:margin-left">
          <xsl:value-of select="concat($MarginLeft * 2.54 div 1440.0, 'cm')" />
        </xsl:attribute>

        <!-- text indent -->

        <!--math, dialogika bugfix #1744208 and #1645291 BEGIN-->

        <!--<xsl:variable name="FirstLine">
          <xsl:call-template name="FirstLine"/>
        </xsl:variable>

        <xsl:variable name="TextIndent">
          <xsl:choose>
            <xsl:when test="$FirstLine != 'NaN'">
              <xsl:value-of select="$FirstLine"/>
            </xsl:when>
            <xsl:when test="$CheckIfList = 'true' and $IndHanging = $IndLeft and $IndLeft != ''">0</xsl:when>
            <xsl:when test="$CheckIfList = 'true' and $IndHanging != '' and $IndLeft !=''">
              <xsl:value-of select="-$IndHanging"/>
            </xsl:when>
            <xsl:when test="$CheckIfList = 'true'">0</xsl:when>
            <xsl:when test="$IndHanging != ''">
              <xsl:value-of select="-$IndHanging"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>-->

        <!--math, dialogika bugfix #1744208 and #1645291 END-->

        <xsl:if test="$TextIndent != ''">
          <xsl:attribute name="fo:text-indent">
            <xsl:value-of select="concat($TextIndent * 2.54 div 1440.0, 'cm')"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>

    <!-- margin left -->
    <!--<xsl:attribute name="fo:margin-left">
      <xsl:choose>
        <xsl:when test="$MarginLeft != '' and $MarginLeft != 'NaN' and $MarginLeft != 0">
          <xsl:call-template name="ConvertTwips">
            <xsl:with-param name="length">
              <xsl:value-of select="$MarginLeft"/>
            </xsl:with-param>
            <xsl:with-param name="unit">cm</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>0cm</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <xsl:variable name="FirstLine">
      <xsl:call-template name="FirstLine"/>
    </xsl:variable>

    <xsl:variable name="TextIndent">
      <xsl:choose>
        <xsl:when test="$FirstLine != 'NaN'">
          <xsl:value-of select="$FirstLine"/>
        </xsl:when>
        <xsl:when test="$CheckIfList = 'true' and $IndHanging = $IndLeft and $IndLeft != ''">0</xsl:when>
        <xsl:when test="$CheckIfList = 'true' and $IndHanging != '' and $IndLeft !=''">
          <xsl:value-of select="-$IndHanging"/>
        </xsl:when>
        <xsl:when test="$CheckIfList = 'true'">0</xsl:when>
        <xsl:when test="$IndHanging != ''">
          <xsl:value-of select="-$IndHanging"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>-->

    <!-- margin right -->

    <!--math, dialogika bugfix #1744208 and #1645291 BEGIN-->
    <xsl:attribute name="fo:margin-right">
      <xsl:value-of select="concat($MarginRight * 2.54 div 1440.0, 'cm')"/>
    </xsl:attribute>

    <!--math, dialogika bugfix #1744208 and #1645291 END-->

    <!-- text indent -->
    <!--<xsl:if test="$TextIndent != ''">
      <xsl:attribute name="fo:text-indent">
        <xsl:call-template name="ConvertTwips">
          <xsl:with-param name="length">
            <xsl:value-of select="$TextIndent"/>
          </xsl:with-param>
          <xsl:with-param name="unit">cm</xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>
    </xsl:if>-->
  </xsl:template>

  <!--math, dialogika: changed for correct indentation calculation END -->

  <!-- widow and orphan-->
  <xsl:template name="InsertParagraphWidowControl">
    <xsl:choose>
      <!-- Note that in Word a missing w:widowControl element means that widow control is enabled -->
      <xsl:when test="w:widowControl/@w:val='0' or w:widowControl/@w:val='false' or w:widowControl/@w:val='off' ">
        <xsl:attribute name="fo:widows">0</xsl:attribute>
        <xsl:attribute name="fo:orphans">0</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="fo:widows">2</xsl:attribute>
        <xsl:attribute name="fo:orphans">2</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Default properties for bidi paragraphs -->
  <xsl:template name="InsertDefaultBidiProperties">
    <xsl:if test="w:bidi and not(w:bidi[@w:val = 'off'] or w:bidi[@w:val = '0'])">
      <xsl:if test="not(w:jc)">
        <xsl:attribute name="fo:text-align">end</xsl:attribute>
      </xsl:if>
      <xsl:attribute name="style:writing-mode">rl-tb</xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- tab stops -->
  <xsl:template name="InsertParagraphTabStops">
    <xsl:param name="MarginLeft"/>
    <xsl:param name="parentStyleId"/>
    <xsl:variable name="parentParentStyleId" select="key('StyleId', $parentStyleId)/w:basedOn/@w:val" />

    <!-- divo: seems this won't work for parent's parent's parent styles etc -->
    <xsl:if test="w:tabs or key('StyleId', $parentStyleId)/w:pPr/w:tabs or key('StyleId', $parentParentStyleId)/w:pPr/w:tabs">
      <style:tab-stops>
        <xsl:variable name="me" select="w:tabs" />
        <xsl:for-each select="w:tabs/w:tab">
          <xsl:call-template name="InsertTabs">
            <xsl:with-param name="MarginLeft" select="$MarginLeft"/>
          </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="key('StyleId', $parentStyleId)/w:pPr/w:tabs/w:tab">
          <xsl:variable name="currentPos" select="./@w:pos" />
          <xsl:variable name="existingParentPos" select="key('ParagraphsByStyleId', $parentStyleId)[@w:pos=$currentPos][@w:val!='clear']" />
          <xsl:if test="not($existingParentPos)">
            <!--test="not(key('ParagraphsByStyleId', $parentStyleId)/@w:pos = ./@w:pos)">-->
            <xsl:variable name="pos" select="./@w:pos"/>

            <!--clam, dialogika: bugfix 1839626-->
            <xsl:if test="not($me/w:tab[@w:pos=$pos][@w:val='clear'])">
              <xsl:call-template name="InsertTabs">
                <xsl:with-param name="MarginLeft" select="$MarginLeft"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>

        <xsl:for-each select="key('StyleId', $parentParentStyleId)/w:pPr/w:tabs/w:tab">
          <xsl:if test="not(key('ParagraphsByStyleId', $parentStyleId)/@w:pos = ./@w:pos) and not(key('StyleId',$parentStyleId)/w:pPr/w:tabs/w:tab/@w:pos = ./@w:pos)">
            <xsl:call-template name="InsertTabs">
              <xsl:with-param name="MarginLeft" select="$MarginLeft"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:for-each>
      </style:tab-stops>
    </xsl:if>
  </xsl:template>

  <!--
  Summary: Writes the attributes of a border
  Author: makz (DIaLOGIKa)
  Date: 22.10.2007
  -->
  <xsl:template name="InsertBorders">
    <xsl:param name="border"/>

    <xsl:if test="$border/w:between">
      <xsl:attribute name="style:join-border">false</xsl:attribute>
    </xsl:if>

    <!-- insert top border -->
    <xsl:call-template name="InsertBorderSide">
      <xsl:with-param name="side" select="$border/w:top"/>
      <xsl:with-param name="sideName">
        <xsl:text>top</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
    <!-- insert bottom border -->
    <xsl:call-template name="InsertBorderSide">
      <xsl:with-param name="side" select="$border/w:bottom"/>
      <xsl:with-param name="sideName">
        <xsl:text>bottom</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
    <!-- insert left border -->
    <xsl:call-template name="InsertBorderSide">
      <xsl:with-param name="side" select="$border/w:left"/>
      <xsl:with-param name="sideName">
        <xsl:text>left</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
    <!-- insert right border -->
    <xsl:call-template name="InsertBorderSide">
      <xsl:with-param name="side" select="$border/w:right"/>
      <xsl:with-param name="sideName">
        <xsl:text>right</xsl:text>
      </xsl:with-param>
    </xsl:call-template>

  </xsl:template>

  <!--
  Summary:  Template writes the value of a border side
  Author:   makz (DIaLOGIKa)
  Date:     22.10.2007
  Params:   side: The w:left, w:right, w:top ... elements
            sideName: The name that the border shall have
  -->
  <xsl:template name="InsertBorderSide">
    <xsl:param name="side"/>
    <xsl:param name="sideName"/>
    <xsl:param name="emulateOpenOfficeTableBorders" select="'false'" />

    <xsl:choose>
      <xsl:when test="$side/@w:val">

        <!-- get border style -->
        <xsl:variable name="style">
          <xsl:choose>
            <xsl:when test="$side/@w:val">
              <xsl:call-template name="GetBorderStyle">
                <xsl:with-param name="style" select="$side/@w:val"/>
                <xsl:with-param name="emulateOpenOfficeTableBorders" select="$emulateOpenOfficeTableBorders" />
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>solid</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- get border color -->
        <xsl:variable name="color">
          <xsl:choose>
            <xsl:when test="$side/@w:color and not($side/@w:color='auto')">
              <xsl:value-of select="$side/@w:color"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>000000</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- get border width -->
        <xsl:variable name="width">
          <xsl:choose>
            <xsl:when test="$side/@w:sz">
              <xsl:choose>
                <xsl:when test="$style='double'">
                  <xsl:call-template name="ConvertEighthsPoints">
                    <xsl:with-param name="length">
                      <xsl:value-of select="$side/@w:sz * 2"/>
                    </xsl:with-param>
                    <xsl:with-param name="unit">cm</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="ConvertEighthsPoints">
                    <xsl:with-param name="length">
                      <xsl:value-of select="$side/@w:sz"/>
                    </xsl:with-param>
                    <xsl:with-param name="unit">cm</xsl:with-param>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>0cm</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- write border attribute -->
        <xsl:attribute name="{concat('fo:border-', $sideName)}">
          <xsl:value-of select="concat($width,' ',$style,' #',$color)"/>
        </xsl:attribute>

        <!-- write border padding attribute -->
        <xsl:if test="$side/@w:space and $side/@w:space != '0' ">
          <xsl:attribute name="{concat('fo:padding-',$sideName)}">
            <xsl:call-template name="ConvertPoints">
              <xsl:with-param name="length">
                <xsl:value-of select="$side/@w:space"/>
              </xsl:with-param>
              <xsl:with-param name="unit">cm</xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:if>

        <!-- write double style attribute -->
        <xsl:if test="$style='double'">
          <xsl:attribute name="{concat('style:border-line-width-',$sideName)}">
            <xsl:call-template name="ComputeDoubleBorderWidth">
              <xsl:with-param name="style" select="$side/@w:val"/>
              <xsl:with-param name="borderWidth" select="$side/@w:sz"/>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:if>

      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="{concat('fo:border-', $sideName)}">
          <xsl:text>none</xsl:text>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!--
  Summary: Template writes the shadow attribute of a border
  Author: Clever Age
  -->
  <xsl:template name="InsertParagraphShadow">

    <xsl:variable name="firstVal">
      <xsl:choose>
        <xsl:when test="w:right/@w:shadow='true' or w:right/@w:shadow=1 or w:right/@w:shadow='on'"
          >0.019in</xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="w:left/@w:shadow='true' or w:left/@w:shadow=1 or w:left/@w:shadow='on'"
              >0.019in</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="secondVal">
      <xsl:choose>
        <xsl:when
				  test="w:bottom/@w:shadow='true' or w:bottom/@w:shadow=1 or w:bottom/@w:shadow='on'"
          >0.019in</xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="w:top/@w:shadow='true' or w:top/@w:shadow=1 or w:top/@w:shadow='on'"
              >0.019in</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$firstVal!=0 and $secondVal!=0">
      <xsl:attribute name="style:shadow">
        <xsl:value-of select="concat('#000000 ',$firstVal,' ',$secondVal)"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- 
  Summary: Mapping for border styles
  Author: Clever Age
  -->
  <xsl:template name="GetBorderStyle">
    <xsl:param name="style"/>
    <xsl:param name="emulateOpenOfficeTableBorders" select="'false'" />

    <xsl:choose>
      <!--<xsl:when test="$emulateOpenOfficeTableBorders = 'true'">solid</xsl:when>-->
      <xsl:when test="$style='basicBlackDashes'">dashed</xsl:when>
      <xsl:when test="$style='basicBlackDots'">dotted</xsl:when>
      <xsl:when test="$style='basicThinLines'">double</xsl:when>
      <xsl:when test="$style='basicWideInLine'">double</xsl:when>
      <xsl:when test="$style='basicWideOutLine'">double</xsl:when>
      <xsl:when test="$style='dashed'">dashed</xsl:when>
      <xsl:when test="$style='dashSmallGap'">dashed</xsl:when>
      <xsl:when test="$style='dotted'">dotted</xsl:when>
      <xsl:when test="$style='double'">double</xsl:when>
      <xsl:when test="$style='inset'">inset</xsl:when>
      <xsl:when test="$style='nil'">hidden</xsl:when>
      <xsl:when test="$style='outset'">outset</xsl:when>
      <xsl:when test="$style='single'">solid</xsl:when>
      <xsl:when test="$style='thick'">solid</xsl:when>
      <xsl:when test="$style='thickThinSmallGap'">double</xsl:when>
      <xsl:when test="$style='thickThinMediumGap'">double</xsl:when>
      <xsl:when test="$style='thickThinLargeGap'">double</xsl:when>
      <xsl:when test="$style='thinThickSmallGap'">double</xsl:when>
      <xsl:when test="$style='thinThickMediumGap'">double</xsl:when>
      <xsl:when test="$style='thinThickLargeGap'">double</xsl:when>
      <xsl:otherwise>solid</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
  Summary: return a three arguments string defining the widths of a 'double' border
  Author: Clever Age
  -->
  <xsl:template name="ComputeDoubleBorderWidth">
    <xsl:param name="style"/>
    <xsl:param name="borderWidth"/>

    <xsl:variable name="inner">
      <xsl:call-template name="ConvertEighthsPoints">
        <xsl:with-param name="length">
          <xsl:choose>
            <xsl:when test="$style='basicWideInLine'">
              <xsl:value-of select="$borderWidth * 50 div 100"/>
            </xsl:when>
            <xsl:when test="$style='basicWideOutLine'">
              <xsl:value-of select="$borderWidth div 100"/>
            </xsl:when>
            <xsl:when test="$style='double' or $style='basicThinLines'">
              <xsl:value-of select="$borderWidth * 80 div 100"/>
            </xsl:when>
            <xsl:when test="$style='thickThinSmallGap'">
              <xsl:value-of select="$borderWidth * 67 div 100"/>
            </xsl:when>
            <xsl:when test="$style='thickThinMediumGap'">
              <xsl:value-of select="$borderWidth * 47 div 100"/>
            </xsl:when>
            <xsl:when test="$style='thickThinLargeGap'">
              <xsl:value-of select="$borderWidth * 27 div 100"/>
            </xsl:when>
            <xsl:when test="contains($style,'thinThick')">
              <xsl:value-of select="$borderWidth * 3 div 100"/>
            </xsl:when>
            <xsl:otherwise/>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="unit">cm</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="middle">
      <xsl:call-template name="ConvertEighthsPoints">
        <xsl:with-param name="length">
          <xsl:choose>
            <xsl:when test="$style='basicWideInLine' or $style='basicWideOutLine'">
              <xsl:value-of select="$borderWidth * 49 div 100"/>
            </xsl:when>
            <xsl:when test="$style='double' or $style='basicThinLines'">
              <xsl:value-of select="$borderWidth * 40 div 100"/>
            </xsl:when>
            <xsl:when test="$style='thickThinSmallGap'">
              <xsl:value-of select="$borderWidth * 30 div 100"/>
            </xsl:when>
            <xsl:when test="$style='thickThinMediumGap'">
              <xsl:value-of select="$borderWidth * 50 div 100"/>
            </xsl:when>
            <xsl:when test="$style='thickThinLargeGap'">
              <xsl:value-of select="$borderWidth * 70 div 100"/>
            </xsl:when>
            <xsl:when test="$style='thinThickSmallGap'">
              <xsl:value-of select="$borderWidth * 30 div 100"/>
            </xsl:when>
            <xsl:when test="$style='thinThickMediumGap'">
              <xsl:value-of select="$borderWidth * 50 div 100"/>
            </xsl:when>
            <xsl:when test="$style='thinThickLargeGap'">
              <xsl:value-of select="$borderWidth * 70 div 100"/>
            </xsl:when>
            <xsl:otherwise/>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="unit">cm</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="outer">
      <xsl:call-template name="ConvertEighthsPoints">
        <xsl:with-param name="length">
          <xsl:choose>
            <xsl:when test="$style='basicWideInLine'">
              <xsl:value-of select="$borderWidth div 100"/>
            </xsl:when>
            <xsl:when test="$style='basicWideOutLine'">
              <xsl:value-of select="$borderWidth * 50 div 100"/>
            </xsl:when>
            <xsl:when test="$style='double' or $style='basicThinLines'">
              <xsl:value-of select="$borderWidth * 80 div 100"/>
            </xsl:when>
            <xsl:when test="contains($style,'thickThin')">
              <xsl:value-of select="$borderWidth * 3 div 100"/>
            </xsl:when>
            <xsl:when test="$style='thinThickSmallGap'">
              <xsl:value-of select="$borderWidth * 67 div 100"/>
            </xsl:when>
            <xsl:when test="$style='thinThickMediumGap'">
              <xsl:value-of select="$borderWidth * 47 div 100"/>
            </xsl:when>
            <xsl:when test="$style='thinThickLargeGap'">
              <xsl:value-of select="$borderWidth * 27 div 100"/>
            </xsl:when>
            <xsl:otherwise/>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="unit">cm</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:value-of select="concat('0', $inner, ' 0', $middle, ' 0', $outer)"/>
  </xsl:template>

  <!-- Handle tab stops -->
  <!-- TODO : check how to deal with tab stops inside a list -->
  <xsl:template name="InsertTabs">
    <xsl:param name="MarginLeft"/>
    <style:tab-stop>
      <xsl:if test="./@w:val != 'clear'">
        <!--   type -->
        <xsl:attribute name="style:type">
          <xsl:choose>
            <xsl:when test="./@w:val='center'">center</xsl:when>
            <xsl:when test="./@w:val='right'">right</xsl:when>
            <xsl:when test="./@w:val='left'">left</xsl:when>
            <xsl:when test="./@w:val='decimal'">char</xsl:when>
            <xsl:otherwise>left</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:if test="./@w:val='decimal'">
          <xsl:attribute name="style:char">
            <xsl:value-of select="','"/>
          </xsl:attribute>
        </xsl:if>
        <!-- position 
          TODO : what if @w:pos < 0 ? -->
        <xsl:if test="./@w:pos >= 0 and ./@w:pos != ''">
          <xsl:attribute name="style:position">
            <xsl:call-template name="ConvertTwips">
              <xsl:with-param name="length">
                <xsl:choose>
                  <xsl:when test="$MarginLeft != '' and $MarginLeft != 'NaN'">
                    <xsl:value-of select="number(./@w:pos) - number($MarginLeft)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="number(./@w:pos)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
              <xsl:with-param name="unit">cm</xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:if>
        <!-- leader char -->
        <xsl:if test="./@w:leader">
          <xsl:attribute name="style:leader-style">
            <xsl:choose>
              <xsl:when test="./@w:leader='dot'">dotted</xsl:when>
              <xsl:when test="./@w:leader='heavy'">solid</xsl:when>
              <xsl:when test="./@w:leader='hyphen'">solid</xsl:when>
              <xsl:when test="./@w:leader='middleDot'">dotted</xsl:when>
              <xsl:when test="./@w:leader='none'">none</xsl:when>
              <xsl:when test="./@w:leader='underscore'">solid</xsl:when>
              <xsl:otherwise>none</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:if>
        <!-- leader text  -->
        <xsl:if test="./@w:leader and ./@w:leader!='' and ./@w:leader!='heavy' and ./@w:leader!='middleDot' and ./@w:leader!='none'">
          <xsl:attribute name="style:leader-text">
            <xsl:choose>
              <xsl:when test="./@w:leader='dot'">.</xsl:when>
              <xsl:when test="./@w:leader='hyphen'">-</xsl:when>
              <xsl:when test="./@w:leader='underscore'">_</xsl:when>
              <xsl:otherwise>none</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:if>
      </xsl:if>
    </style:tab-stop>
  </xsl:template>

  <!-- suppress line numbering if paragraph is in a not-numbered section -->
  <xsl:template name="InsertSuppressLineNumbering">
    <xsl:if test="$lines-are-numbered = 'true' ">
      <xsl:choose>
        <xsl:when test="w:suppressLineNumbers">
          <!-- problem already handled by match template, nothing to do -->
        </xsl:when>
        <xsl:when test="ancestor::w:p and not(ancestor::w:body)">
          <!-- never include paragraphs outside of body (header, footer, endnotes, footnotes) -->
          <xsl:attribute name="text:number-lines">false</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="ancestor::w:body and not(ancestor::w:tbl or ancestor::w:txbxContent)">
            <!-- check if paragraph is in a numbered section -->
            <xsl:choose>
              <xsl:when test="w:sectPr">
                <xsl:if test="w:sectPr[not(w:lnNumType)]">
                  <xsl:attribute name="text:number-lines">false</xsl:attribute>
                </xsl:if>
              </xsl:when>
              <xsl:when
							  test="ancestor::w:p[parent::w:body]/following-sibling::w:p[w:pPr/w:sectPr][1]/w:pPr/w:sectPr">
                <xsl:variable name="followingSectPr"
								  select="ancestor::w:p[parent::w:body]/following-sibling::w:p[w:pPr/w:sectPr][1]/w:pPr/w:sectPr"/>
                <xsl:if test="$followingSectPr[not(w:lnNumType)]">
                  <xsl:attribute name="text:number-lines">false</xsl:attribute>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="mainSectPr" select="ancestor::w:body/w:sectPr"/>
                <xsl:if test="$mainSectPr[not(w:lnNumType)]">
                  <xsl:attribute name="text:number-lines">false</xsl:attribute>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- ODF Text properties contained in OOX pPr element -->
  <xsl:template name="InsertpPrTextProperties">
    <xsl:apply-templates mode="textProppPrChildren"/>
  </xsl:template>

  <!-- conversion of text properties -->
  <xsl:template name="InsertTextProperties">

    <!-- attributes using match -->
    <xsl:apply-templates mode="rPrChildren"/>

    <!--clam bugfix #1806204 special case: hyperlink without style-->
    <!-- makz: modified to fix hyperlink problems in TOCs-->
    <xsl:if test="ancestor::w:hyperlink">
      <!-- 
      These are the run properties of a hyperlink.
      So it needs special threatment.
      -->
      <xsl:choose>
        <xsl:when test="not(w:rStyle) and not(w:u) and (not(w:color) or w:color/@w:val = 'auto')">
          <!--
          If there is no style referenced and no underline style is set and no color is set, 
          Word uses black color and no underlining. Open Office would use blue and underlining.
          For this reason we must write the default settings of Word:
          -->
          <xsl:attribute name="style:use-window-font-color">true</xsl:attribute>
          <xsl:attribute name="style:text-underline-type">none</xsl:attribute>
        </xsl:when>
        <xsl:when test="starts-with(ancestor::w:p/w:pPr/w:pStyle/@w:val, 'TOC')">
          <!-- 
          If this hyperlink is inside a TOC, Word always uses the color und underline style of the TOC style.
          The formatting properties of the Hyperlink style are ignored.
          
          Open Office always uses the color and the style of the Hyperlink style.
          For that reason we must write the color and underline style of the matching TOC level.
          -->
          <xsl:variable name="tocStyle" select="key('StyleId', ancestor::w:p/w:pPr/w:pStyle/@w:val)" />
          <xsl:attribute name="fo:color">
            <xsl:choose>
              <xsl:when test="$tocStyle/w:rPr/w:color/@w:val">
                <xsl:value-of select="concat('#', $tocStyle/w:rPr/w:color/@w:val)" />
              </xsl:when>
              <xsl:otherwise>#000000</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="style:text-underline-type">
            <xsl:choose>
              <xsl:when test="$tocStyle/w:rPr/w:u">single</xsl:when>
              <xsl:otherwise>none</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="./w:rStyle/@w:val = 'Hyperlink' and not(w:color)">
          <xsl:variable name="parentStyle" select="key('StyleId','Hyperlink')"></xsl:variable>
          <xsl:if test="$parentStyle/w:rPr/w:color">
            <xsl:attribute name="fo:color">
              <xsl:value-of select="concat('#',$parentStyle/w:rPr/w:color/@w:val)"></xsl:value-of>
            </xsl:attribute>
          </xsl:if>
        </xsl:when>
      </xsl:choose>
    </xsl:if>

    <!-- other attributes forbidden in drop cap text style -->
    <xsl:if test="not(ancestor::w:p[1]/w:pPr/w:framePr[@w:dropCap])">
      <xsl:apply-templates mode="rPrChildren-dropcap-forbidden"/>
      <xsl:call-template name="InsertTextPosition"/>
    </xsl:if>
    <!-- attributes from child elements -->
    <xsl:call-template name="InsertTextStrikeLine"/>
    <!-- if in field content render field text style options -->
    <xsl:if test="ancestor::w:fldSimple or ancestor::w:r/w:instrText">
      <xsl:call-template name="InsertFieldProperties"/>
    </xsl:if>
  </xsl:template>

  <!-- line through text -->
  <xsl:template name="InsertTextStrikeLine">
    <xsl:if test="w:dstrike or w:strike">
      <xsl:choose>
        <xsl:when
				  test="w:strike/@w:val='on' or w:strike/@w:val='true' or w:strike/@w:val=1 or w:strike/@w:val=1 or (w:strike and (not(w:strike/@w:val) or w:strike/@w:val = ''))">
          <xsl:attribute name="style:text-line-through-type">single</xsl:attribute>
          <xsl:attribute name="style:text-line-through-style">solid</xsl:attribute>
        </xsl:when>
        <xsl:when
				  test="w:dstrike/@w:val='on' or w:dstrike/@w:val='true' or w:dstrike/@w:val=1 or w:dstrike/@w:val=1 or (w:dstrike and (not(w:dstrike/@w:val) or w:dstrike/@w:val = ''))">
          <xsl:attribute name="style:text-line-through-type">double</xsl:attribute>
          <xsl:attribute name="style:text-line-through-style">solid</xsl:attribute>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- insert underline attributes. Context is w:rPr/w:u -->
  <xsl:template name="InsertUnderline">
    <xsl:if test="@w:val">
      <xsl:choose>
        <xsl:when test="@w:val = 'dash'">
          <xsl:attribute name="style:text-underline-style">dash</xsl:attribute>
          <xsl:attribute name="style:text-underline-type">single</xsl:attribute>
          <xsl:attribute name="style:text-underline-width">normal</xsl:attribute>
        </xsl:when>
        <xsl:when test="@w:val = 'dashDotDotHeavy'">
          <xsl:attribute name="style:text-underline-style">dot-dot-dash</xsl:attribute>
          <xsl:attribute name="style:text-underline-type">single</xsl:attribute>
          <xsl:attribute name="style:text-underline-width">thick</xsl:attribute>
        </xsl:when>
        <xsl:when test="@w:val = 'dashDotHeavy'">
          <xsl:attribute name="style:text-underline-style">dot-dash</xsl:attribute>
          <xsl:attribute name="style:text-underline-type">single</xsl:attribute>
          <xsl:attribute name="style:text-underline-width">thick</xsl:attribute>
        </xsl:when>
        <xsl:when test="@w:val = 'dashedHeavy'">
          <xsl:attribute name="style:text-underline-style">dash</xsl:attribute>
          <xsl:attribute name="style:text-underline-type">single</xsl:attribute>
          <xsl:attribute name="style:text-underline-width">thick</xsl:attribute>
        </xsl:when>
        <xsl:when test="@w:val = 'dashLong'">
          <xsl:attribute name="style:text-underline-style">long-dash</xsl:attribute>
          <xsl:attribute name="style:text-underline-type">single</xsl:attribute>
          <xsl:attribute name="style:text-underline-width">normal</xsl:attribute>
        </xsl:when>
        <xsl:when test="@w:val = 'dashLongHeavy'">
          <xsl:attribute name="style:text-underline-style">long-dash</xsl:attribute>
          <xsl:attribute name="style:text-underline-type">single</xsl:attribute>
          <xsl:attribute name="style:text-underline-width">thick</xsl:attribute>
        </xsl:when>
        <xsl:when test="@w:val = 'dotDash'">
          <xsl:attribute name="style:text-underline-style">dot-dash</xsl:attribute>
          <xsl:attribute name="style:text-underline-type">single</xsl:attribute>
          <xsl:attribute name="style:text-underline-width">normal</xsl:attribute>
        </xsl:when>
        <xsl:when test="@w:val = 'dotDotDash'">
          <xsl:attribute name="style:text-underline-style">dot-dot-dash</xsl:attribute>
          <xsl:attribute name="style:text-underline-type">single</xsl:attribute>
          <xsl:attribute name="style:text-underline-width">normal</xsl:attribute>
        </xsl:when>
        <xsl:when test="@w:val = 'dotted'">
          <xsl:attribute name="style:text-underline-style">dotted</xsl:attribute>
          <xsl:attribute name="style:text-underline-type">single</xsl:attribute>
          <xsl:attribute name="style:text-underline-width">normal</xsl:attribute>
        </xsl:when>
        <xsl:when test="@w:val = 'dottedHeavy'">
          <xsl:attribute name="style:text-underline-style">dotted</xsl:attribute>
          <xsl:attribute name="style:text-underline-type">single</xsl:attribute>
          <xsl:attribute name="style:text-underline-width">thick</xsl:attribute>
        </xsl:when>
        <xsl:when test="@w:val = 'double'">
          <xsl:attribute name="style:text-underline-style">solid</xsl:attribute>
          <xsl:attribute name="style:text-underline-type">double</xsl:attribute>
          <xsl:attribute name="style:text-underline-width">normal</xsl:attribute>
        </xsl:when>
        <xsl:when test="@w:val = 'single'">
          <xsl:attribute name="style:text-underline-style">solid</xsl:attribute>
          <xsl:attribute name="style:text-underline-type">single</xsl:attribute>
          <xsl:attribute name="style:text-underline-width">normal</xsl:attribute>
        </xsl:when>
        <xsl:when test="@w:val = 'thick'">
          <xsl:attribute name="style:text-underline-style">solid</xsl:attribute>
          <xsl:attribute name="style:text-underline-type">single</xsl:attribute>
          <xsl:attribute name="style:text-underline-width">thick</xsl:attribute>
        </xsl:when>
        <xsl:when test="@w:val = 'wave'">
          <xsl:attribute name="style:text-underline-style">wave</xsl:attribute>
          <xsl:attribute name="style:text-underline-type">single</xsl:attribute>
          <xsl:attribute name="style:text-underline-width">normal</xsl:attribute>
        </xsl:when>
        <xsl:when test="@w:val = 'wavyDouble'">
          <!-- 
          makz: the order of the attributes is importent for Open office 2.2
          I think it's a bug in Open Office, but the style attribute must be 
          written before the type attribute
          
          Fix bug #1764323
          -->
          <xsl:attribute name="style:text-underline-style">wave</xsl:attribute>
          <xsl:attribute name="style:text-underline-type">double</xsl:attribute>
          <xsl:attribute name="style:text-underline-width">auto</xsl:attribute>
        </xsl:when>
        <xsl:when test="@w:val = 'wavyHeavy'">
          <xsl:attribute name="style:text-underline-style">wave</xsl:attribute>
          <xsl:attribute name="style:text-underline-type">single</xsl:attribute>
          <xsl:attribute name="style:text-underline-width">thick</xsl:attribute>
        </xsl:when>
        <xsl:when test="@w:val = 'words'">
          <xsl:attribute name="style:text-underline-style">solid</xsl:attribute>
          <xsl:attribute name="style:text-underline-mode">skip-white-space</xsl:attribute>
          <xsl:attribute name="style:text-underline-type">single</xsl:attribute>
          <xsl:attribute name="style:text-underline-width">normal</xsl:attribute>
        </xsl:when>
        <xsl:when test="@w:val = 'none'">
          <xsl:attribute name="style:text-underline-type">none</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="style:text-underline-style">solid</xsl:attribute>
          <xsl:attribute name="style:text-underline-type">single</xsl:attribute>
          <xsl:attribute name="style:text-underline-width">normal</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="@w:color">
      <xsl:attribute name="style:text-underline-color">
        <xsl:choose>
          <xsl:when test="@w:color='auto'">font-color</xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('#',@w:color)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- compute positionning of text -->
  <xsl:template name="InsertTextPosition">
    <xsl:if test="w:vertAlign or w:position">
      <xsl:variable name="percentValue">
        <xsl:choose>
          <xsl:when test="w:position/@w:val">
            <xsl:choose>
              <xsl:when test="w:sz/@w:val != 0">
                <xsl:value-of select="round(w:position/@w:val * 100 div w:sz/@w:val)"/>
              </xsl:when>
              <xsl:when test="key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:rPrDefault/w:rPr/w:sz/@w:val">
                <xsl:variable name="defaultFontSize" select="key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:rPrDefault/w:rPr/w:sz/@w:val" />
                <xsl:value-of select="round(w:position/@w:val * 100 div number($defaultFontSize))"/>
              </xsl:when>
              <xsl:otherwise>
                <!-- if no font size is specified use 10pt = 20 as the default-->
                <xsl:value-of select="round(w:position/@w:val * 100 div 20)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:choose>

        <!-- positioning of superscript -->
        <xsl:when test="w:vertAlign/@w:val = 'superscript'">
          <xsl:attribute name="style:text-position">
            <xsl:value-of select="concat('super ',number(58 + $percentValue),'%')"/>
          </xsl:attribute>
        </xsl:when>

        <!-- positioning of subscript -->
        <xsl:when test="w:vertAlign/@w:val = 'subscript'">
          <xsl:attribute name="style:text-position">
            <xsl:value-of select="concat('sub ',number(58 - $percentValue))"/>
          </xsl:attribute>
        </xsl:when>

        <!-- positioning of normal text -->
        <xsl:when test="w:vertAlign = 'baseline'">
          <xsl:attribute name="style:text-position">
            <xsl:value-of select="concat(number($percentValue),' 100')"/>
          </xsl:attribute>
        </xsl:when>

        <!-- BUG [ 1743455 ] DOCX: 3 files corrupted during conversion
               03 / 07 / 2007
               It seems the Text-position value is wrong for the otherwise condition
               Somes files are crashing with Open Office 2.2, not with older version 2.0
                Value in the otherwise condition is the same than the positioning of normal text...
          -->
        <xsl:when test="number($percentValue) != 'NaN'">
          <xsl:attribute name="style:text-position">
            <xsl:value-of select="concat(number($percentValue),'% 100%')"/>
          </xsl:attribute>
        </xsl:when>

      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- get font name from theme -->
  <xsl:template name="ComputeThemeFontName" xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main">
    <xsl:param name="fontTheme"/>
    <xsl:param name="fontType"/>
    <xsl:variable name="fontScheme"
		  select="key('Part', 'word/theme/theme1.xml')/a:theme/a:themeElements/a:fontScheme"/>

    <xsl:variable name="fontName">
      <xsl:choose>
        <xsl:when test="contains($fontTheme,'minor')">
          <xsl:value-of select="$fontScheme/a:minorFont/child::node()[name() = $fontType]/@typeface" />
        </xsl:when>
        <xsl:when test="contains($fontTheme,'major')">
          <xsl:value-of select="$fontScheme/a:majorFont/child::node()[name() = $fontType]/@typeface" />
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$fontName = ''">
        <xsl:text>none</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$fontName"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="BibliographyConfiguration">
    <text:bibliography-configuration text:prefix="(" text:suffix=")">
      <xsl:attribute name="text:sort-by-position">false</xsl:attribute>
      <xsl:attribute name="text:sort-algorithm">
        <xsl:text>alphanumeric</xsl:text>
      </xsl:attribute>
      <text:sort-key text:key="author" text:sort-ascending="true"/>
    </text:bibliography-configuration>
  </xsl:template>

  <!-- Insert line numbering. If numbering not applied to a section, retrieve property in paragraphs -->
  <xsl:template name="InsertLineNumbering">
    <xsl:if test="$lines-are-numbered = 'true' ">
      <style:style style:name="{concat('ooc-NCNameFromString', '-oop-', 'Line numbering', '-ooe')}"
                   style:display-name="Line numbering"
                   style:family="text"/>
      <xsl:for-each select="key('Part', 'word/document.xml')">
        <text:linenumbering-configuration text:style-name="{concat('ooc-NCNameFromString', '-oop-', 'Line numbering', '-ooe')}"
                                          style:num-format="1"
                                          text:count-empty-lines="false"
                                          text:number-position="left">
          <!-- if no section is set to continuous, restart on every page -->
          <xsl:if test="not(key('sectPr', '')/w:lnNumType/@w:restart = 'continuous')">
            <xsl:attribute name="text:restart-on-page">true</xsl:attribute>
          </xsl:if>
          <xsl:attribute name="text:increment">
            <xsl:choose>
              <xsl:when test="key('sectPr', '')/w:lnNumType/@w:countBy">
                <xsl:value-of select="key('sectPr', '')/w:lnNumType/@w:countBy"/>
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="text:offset">
            <xsl:choose>
              <xsl:when test="key('sectPr', '')/w:lnNumType/@w:distance">
                <xsl:call-template name="ConvertTwips">
                  <xsl:with-param name="length">
                    <xsl:value-of select="key('sectPr', '')/w:lnNumType/@w:distance"/>
                  </xsl:with-param>
                  <xsl:with-param name="unit">cm</xsl:with-param>
                </xsl:call-template>
              </xsl:when>
              <!-- requires default value (otherwise, 0) -->
              <xsl:otherwise>0.75cm</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </text:linenumbering-configuration>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <!-- Insert List Style Properties -->
  <xsl:template name="ListStyleProperties">
    <xsl:for-each select="key('Part', 'word/numbering.xml')/w:numbering/w:abstractNum">
      <style:style style:family="text" style:name="{generate-id()}">
        <style:text-properties>
          <xsl:for-each select="w:lvl/w:rPr">
            <xsl:call-template name="InsertTextProperties"/>
          </xsl:for-each>
        </style:text-properties>
      </style:style>
    </xsl:for-each>
  </xsl:template>

  <!-- Called from getMarginTopForParagraph in case of lack of styleId-->
  <!-- Find the default w:before in w:pPrDefault-->
  <xsl:template name="getMarginTopFromWpPrDefault">

    <xsl:variable name="documentParagraphWBeforeNormal"
		  select="key('StyleId', 'Normal')/w:pPr/w:spacing/@w:before"/>
    <xsl:variable name="documentParagraphWBeforeDefault"
		  select="key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:spacing/@w:before"/>

    <xsl:choose>

      <xsl:when
			  test="count($documentParagraphWBeforeNormal)=0 and count($documentParagraphWBeforeDefault)=0">
        <xsl:value-of select="'0'"/>
      </xsl:when>

      <xsl:when
			  test="count($documentParagraphWBeforeNormal)=0 and count($documentParagraphWBeforeDefault)>0">
        <xsl:value-of select="$documentParagraphWBeforeDefault"/>
      </xsl:when>

      <xsl:when
			  test="count($documentParagraphWBeforeNormal)>0 and count($documentParagraphWBeforeDefault)=0">
        <xsl:value-of select="$documentParagraphWBeforeNormal"/>
      </xsl:when>

      <xsl:when
			  test="count($documentParagraphWBeforeNormal)>0 and count($documentParagraphWBeforeDefault)>0">
        <xsl:value-of select="$documentParagraphWBeforeNormal"/>
      </xsl:when>

    </xsl:choose>

  </xsl:template>

  <!-- Called from getMarginBottomForParagraph in case of lack of styleId-->
  <!-- Find the default w:after in w:pPrDefault-->
  <xsl:template name="getMarginBottomFromWpPrDefault">

    <xsl:variable name="documentParagraphWAfterNormal"
		  select="key('StyleId', 'Normal')/w:pPr/w:spacing/@w:after"/>
    <xsl:variable name="documentParagraphWAfterDefault"
		  select="key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:spacing/@w:after"/>

    <xsl:choose>
      <xsl:when
			  test="count($documentParagraphWAfterNormal)=0 and count($documentParagraphWAfterDefault)=0">
        <xsl:value-of select="'0'"/>
      </xsl:when>

      <xsl:when
			  test="count($documentParagraphWAfterNormal)=0 and count($documentParagraphWAfterDefault)>0">
        <xsl:value-of select="$documentParagraphWAfterDefault"/>
      </xsl:when>

      <xsl:when
			  test="count($documentParagraphWAfterNormal)>0 and count($documentParagraphWAfterDefault)=0">
        <xsl:value-of select="$documentParagraphWAfterNormal"/>
      </xsl:when>

      <xsl:when
			  test="count($documentParagraphWAfterNormal)>0 and count($documentParagraphWAfterDefault)>0">
        <xsl:value-of select="$documentParagraphWAfterNormal"/>
      </xsl:when>

    </xsl:choose>
  </xsl:template>

  <xsl:template name="getLineHeightFromWpPrDefault">

    <xsl:variable name="documentLineHeightNormal"
		  select="key('StyleId', 'Normal')/w:pPr/w:spacing/@w:line"/>
    <xsl:variable name="documentLineHeightDefault"
		  select="key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:spacing/@w:line"/>

    <xsl:choose>
      <xsl:when
			  test="count($documentLineHeightNormal)=0 and count($documentLineHeightDefault)=0">
        <xsl:value-of select="'0'"/>
      </xsl:when>

      <xsl:when
			  test="count($documentLineHeightNormal)=0 and count($documentLineHeightDefault)>0">
        <xsl:value-of select="$documentLineHeightDefault"/>
      </xsl:when>

      <xsl:when
			  test="count($documentLineHeightNormal)>0 and count($documentLineHeightDefault)=0">
        <xsl:value-of select="$documentLineHeightNormal"/>
      </xsl:when>

      <xsl:when
			  test="count($documentLineHeightNormal)>0 and count($documentLineHeightDefault)>0">
        <xsl:value-of select="$documentLineHeightNormal"/>
      </xsl:when>

    </xsl:choose>
  </xsl:template>

  <xsl:template name="getLineRuleFromWpPrDefault">

    <xsl:variable name="documentLineRuleNormal"
		  select="key('StyleId', 'Normal')/w:pPr/w:spacing/@w:lineRule"/>
    <xsl:variable name="documentLineRuleDefault"
		  select="key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:pPrDefault/w:pPr/w:spacing/@w:lineRule"/>

    <xsl:choose>
      <xsl:when
			  test="count($documentLineRuleNormal)=0 and count($documentLineRuleDefault)=0">
        <xsl:value-of select="'0'"/>
      </xsl:when>

      <xsl:when
			  test="count($documentLineRuleNormal)=0 and count($documentLineRuleDefault)>0">
        <xsl:value-of select="$documentLineRuleDefault"/>
      </xsl:when>

      <xsl:when
			  test="count($documentLineRuleNormal)>0 and count($documentLineRuleDefault)=0">
        <xsl:value-of select="$documentLineRuleNormal"/>
      </xsl:when>

      <xsl:when
			  test="count($documentLineRuleNormal)>0 and count($documentLineRuleDefault)>0">
        <xsl:value-of select="$documentLineRuleNormal"/>
      </xsl:when>

    </xsl:choose>
  </xsl:template>


  <!-- Write the attribute for fo:margin-top-->
  <xsl:template name="setFoMarginTop">
    <xsl:param name="setParagraphWBefore"/>

    <xsl:if test="$setParagraphWBefore!=''">
      <xsl:attribute name="fo:margin-top">
        <xsl:value-of select="concat($setParagraphWBefore * 2.54 div 1440.0, 'cm')"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- Write the attribute for fo:margin-bottom-->
  <xsl:template name="setFoMarginBottom">
    <xsl:param name="setParagraphWAfter"/>

    <xsl:if test="$setParagraphWAfter!=''">
      <xsl:attribute name="fo:margin-bottom">
        <xsl:value-of select="concat($setParagraphWAfter * 2.54 div 1440.0, 'cm')"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!--// Writing attributes -->
  <xsl:template name="getMarginTopForParagraph">
    <xsl:param name="StyleParagraphId"/>
    <xsl:param name="documentParagraphWBefore" select="key('StyleId', $StyleParagraphId)/w:pPr/w:spacing/@w:before"/>

    <xsl:variable name="parentStyleId" select="key('StyleId', $StyleParagraphId)/w:basedOn[1]/@w:val"/>

    <xsl:variable name="bStop">

      <xsl:if test="count($documentParagraphWBefore)>0 and $StyleParagraphId!=''">
        <!-- We have values for margin-->
        <xsl:value-of select="1"/>
      </xsl:if>

      <xsl:if test="count($documentParagraphWBefore)=0 and count($parentStyleId)>0 and $StyleParagraphId!=''">
        <!-- we dont have values for margin but we have a parent-->
        <xsl:value-of select="0"/>
      </xsl:if>

      <xsl:if test="count($documentParagraphWBefore)=0 and count($parentStyleId)=0 and $StyleParagraphId!=''">
        <!-- We are at the top of the tree without any values -->
        <xsl:value-of select="2"/>
      </xsl:if>

      <xsl:if test="$StyleParagraphId=''">
        <!-- No styleId is defined, we must apply the the <w:pPrDefault> -->
        <xsl:value-of select="3"/>
      </xsl:if>

    </xsl:variable>

    <xsl:choose>

      <!--Stop Condition-->
      <xsl:when test="$bStop='1'">
        <!--Return found margin -->
        <xsl:value-of select="$documentParagraphWBefore"/>
      </xsl:when>

      <xsl:when test="$bStop='0'">
        <xsl:call-template name="getMarginTopForParagraph">
          <xsl:with-param name="StyleParagraphId" select="$parentStyleId"/>
        </xsl:call-template>
      </xsl:when>

      <!--<xsl:when test="$bStop='2'">
        <xsl:call-template name="getMarginTopFromWpPrDefault"/>
      </xsl:when>

      <xsl:when test="$bStop='3'">
        -->
      <!-- No styleId is defined, we must apply the the <w:pPrDefault> -->
      <!--
        <xsl:call-template name="getMarginTopFromWpPrDefault"/>
      </xsl:when>-->

      <!--clam, dialogika: bugfix 1998725-->
      <xsl:otherwise>
        <xsl:call-template name="getMarginTopFromWpPrDefault"/>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>

  <!--Return values of w:spacing/@w:after value from hierarchystyle-->
  <xsl:template name="getMarginBottomForParagraph">

    <xsl:param name="StyleParagraphId"/>
    <xsl:param name="documentParagraphWAfter"
		  select="key('StyleId', $StyleParagraphId)/w:pPr/w:spacing/@w:after"/>

    <xsl:variable name="parentStyleId"
		  select="key('StyleId', $StyleParagraphId)/w:basedOn[1]/@w:val"/>

    <xsl:variable name="bStop">

      <xsl:choose>

        <xsl:when test="count($documentParagraphWAfter)>0 and $StyleParagraphId!=''">
          <!-- We have values for margin-->
          <xsl:value-of select="1"/>
        </xsl:when>

        <xsl:when
				  test="count($documentParagraphWAfter)=0 and count($parentStyleId)>0 and $StyleParagraphId!=''">
          <!-- we dont have values for margin but we have a parent-->
          <xsl:value-of select="0"/>
        </xsl:when>

        <xsl:when
				  test="count($documentParagraphWAfter)=0 and count($parentStyleId)=0 and $StyleParagraphId!=''">
          <!-- We are at the top of the tree without any values -->
          <xsl:value-of select="2"/>
        </xsl:when>

        <xsl:when test="$StyleParagraphId=''">
          <!-- No styleId is defined, we must apply the the <w:pPrDefault> if exists -->
          <xsl:value-of select="3"/>
        </xsl:when>

      </xsl:choose>

    </xsl:variable>

    <xsl:choose>

      <!--Stop Condition-->

      <xsl:when test="$bStop='1'">
        <!--Return found margins-->
        <xsl:value-of select="$documentParagraphWAfter"/>
      </xsl:when>

      <xsl:when test="$bStop='0'">
        <xsl:call-template name="getMarginBottomForParagraph">
          <xsl:with-param name="StyleParagraphId" select="$parentStyleId"/>
        </xsl:call-template>
      </xsl:when>

      <!--<xsl:when test="$bStop='2'">
        <xsl:call-template name="getMarginBottomFromWpPrDefault"/>
      </xsl:when>

      <xsl:when test="$bStop='3'">
        -->
      <!-- No styleId is defined, we must apply the the <w:pPrDefault> -->
      <!--
        <xsl:call-template name="getMarginBottomFromWpPrDefault"/>
      </xsl:when>-->

      <!--clam, dialogika: bugfix 1998725-->
      <xsl:otherwise>
        <xsl:call-template name="getMarginBottomFromWpPrDefault"/>
      </xsl:otherwise>


    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
