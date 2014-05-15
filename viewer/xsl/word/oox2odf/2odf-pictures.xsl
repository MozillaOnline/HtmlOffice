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
  xmlns:o="urn:schemas-microsoft-com:office:office"
  xmlns:pzip="urn:cleverage:xmlns:post-processings:zip"
  xmlns="http://schemas.openxmlformats.org/package/2006/relationships"
  xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
  xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
  xmlns:v="urn:schemas-microsoft-com:vml"
  xmlns:oox="urn:oox"             
  xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships"
  exclude-result-prefixes="w uri a pic r v rels o wp w oox rels">

  <!--
  *************************************************************************
  SUMMARY
  *************************************************************************
  This stylesheet handles the conversion of DrawingML pictures.
  *************************************************************************
  -->

  <!-- 
  *************************************************************************
  MATCHING TEMPLATES
  *************************************************************************
  -->

  <xsl:template match="w:drawing">
    <xsl:apply-templates select="wp:inline | wp:anchor"/>
  </xsl:template>

  <xsl:template match="w:drawing" mode="automaticstyles">
    <style:style style:name="{generate-id(.)}" style:family="graphic">
      <!--in Word there are no parent style for image - make default Graphics in OO -->
      <xsl:attribute name="style:parent-style-name">
        <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', 'Graphics', w:tblStyle/@w:val, '-ooe') "/>
      </xsl:attribute>

      <style:graphic-properties>
        <xsl:call-template name="InsertPictureProperties">
          <xsl:with-param name="drawing" select="." />
        </xsl:call-template>
      </style:graphic-properties>
    </style:style>
  </xsl:template>

  <xsl:template match="w:drawing[descendant::a:hlinkClick]">
    <draw:a xlink:type="simple">
      <xsl:attribute name="xlink:href">
        <xsl:variable name="relationshipId" select="descendant::a:hlinkClick/@r:id"/>
        <xsl:variable name="document">
          <xsl:call-template name="GetDocumentName"/>
        </xsl:variable>
        <xsl:variable name="relDestination">
          <xsl:call-template name="GetTarget">
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="id" select="$relationshipId"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="GetLinkPath">
          <xsl:with-param name="linkHref" select="concat('ooc-UriFromPath', '-oop-', $relDestination, '-ooe')" />
        </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates select="wp:inline | wp:anchor"/>
    </draw:a>

  </xsl:template>

  <xsl:template match="wp:inline | wp:anchor">
    <xsl:variable name="document">
      <xsl:call-template name="GetDocumentName"/>
    </xsl:variable>

    <xsl:call-template name="CopyPictures">
      <xsl:with-param name="document">
        <xsl:value-of select="$document"/>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:if test="wp:cNvGraphicFramePr/a:graphicFrameLocks/@noChangeAspect">
      <xsl:message terminate="no">translation.oox2odf.picture.size.lockAspectRation</xsl:message>
    </xsl:if>

    <xsl:if test="a:graphic/a:graphicData/pic:pic/pic:nvPicPr/pic:cNvPicPr/@preferRelativeResize">
      <xsl:message terminate="no">translation.oox2odf.frame.relativeSize</xsl:message>
    </xsl:if>

    <xsl:if test="@locked = '1'">
      <xsl:message terminate="no">translation.oox2odf.picture.anchor.lock</xsl:message>
    </xsl:if>

    <xsl:if test="@allowOverlap = '1'">
      <xsl:message terminate="no">translation.oox2odf.picture.overlap</xsl:message>
    </xsl:if>

    <draw:frame>
      <!-- anchor type-->
      <xsl:call-template name="InsertImageAnchorType"/>

      <xsl:call-template name="DrawingMLToZindex" >
        <xsl:with-param name="wpAnchor" select="." />
      </xsl:call-template>

      <!--style name-->
      <xsl:attribute name="draw:style-name">
        <xsl:value-of select="generate-id(ancestor::w:drawing)"/>
      </xsl:attribute>

      <!--drawing name-->
      <xsl:attribute name="draw:name">
        <xsl:value-of select="wp:docPr/@name"/>
      </xsl:attribute>

      <!--position-->
      <xsl:if test="self::wp:anchor">
        <xsl:call-template name="SetPosition"/>
      </xsl:if>

      <!--size-->
      <xsl:call-template name="SetSize"/>

      <!-- image href from relationships-->
      <draw:image xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad">
        <xsl:if test="key('Part', concat('word/_rels/',$document,'.rels'))">
          <xsl:call-template name="InsertImageHref">
            <xsl:with-param name="document" select="$document"/>
          </xsl:call-template>
        </xsl:if>
      </draw:image>
    </draw:frame>
  </xsl:template>

  <!-- 
  *************************************************************************
  CALLED TEMPLATES
  *************************************************************************
  -->

  <!--
  Summary:  Inserts the z-index for a draw:frame.
  Author:   makz (DIaLOGIKa)
  Params:   wpAnchor: the wp:anchor element of the DrawingML picture.
  -->
  <xsl:template name="DrawingMLToZindex" >
    <xsl:param name="wpAnchor" />

    <xsl:variable name="z-index">
      <xsl:choose>
        <xsl:when test="$wpAnchor/@relativeHeight">
          <xsl:value-of select="number($wpAnchor/@relativeHeight)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:attribute name="draw:z-index">
      <xsl:call-template name="NormalizeZIndex">
        <xsl:with-param name="z-index" select="$z-index" />
      </xsl:call-template>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="NormalizeZIndex">
    <xsl:param name="z-index" />

    <!--
    z-index normalization:
    We put the values in new reserved ranges:
    hdr/ftr background: 0 - 500.000.000
    hdr/ftr foreground: 500.000.001 - 1.000.000.000
    maindoc background: 1.000.000.001 - 1.500.000.000
    maindoc foreground: 1.500.000.001 - 2.147.483.647
    -->
    <xsl:choose>
      <xsl:when test="ancestor::w:hdr or ancestor::w:ftr">
        <!--<xsl:choose>
          <xsl:when test="$z-index &lt; 0">
            --><!-- VML in hdr ftr background --><!--
            <xsl:value-of select="500000000 - number($z-index)" />
          </xsl:when>
          <xsl:when test="$z-index &gt;= 0">
            --><!-- VML in hdr ftr foreground --><!--
            <xsl:value-of select="500000001 + number($z-index)" />
          </xsl:when>
          <xsl:otherwise>
            --><!-- index not set --><!--
            <xsl:value-of select="500000001" />
          </xsl:otherwise>
        </xsl:choose>-->
        <xsl:choose>
          <xsl:when test="$z-index = '' or $z-index = 'NaN'">
            <xsl:value-of select="0"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="500000000 + number($z-index)" />            
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$z-index = '' or $z-index = 'NaN'">
            <xsl:value-of select="0"/>
          </xsl:when>
          <!--<xsl:when test="$z-index &lt; 0">
            --><!-- VML in main doc background --><!--
            <xsl:value-of select="1500000000 - number($z-index)" />
          </xsl:when>-->
          <xsl:otherwise>
            <!-- VML in main doc foreground -->
            <xsl:value-of select="1500000001 + number($z-index)" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>


  </xsl:template>


  <!--
  Summary: Writes the anchor-type attribute
  Author: Clever Age
  -->
  <xsl:template name="InsertImageAnchorType">
    <xsl:attribute name="text:anchor-type">
      <xsl:variable name="verticalRelativeFrom" select="wp:positionV/@relativeFrom"/>
      <xsl:variable name="horizontalRelativeFrom" select="wp:positionH/@relativeFrom"/>
      <xsl:variable name="layoutInCell" select="@layoutInCell"/>

      <xsl:choose>
        <!-- images in header must be anchored to paragraph or as-char -->
        <xsl:when test="ancestor::w:hdr">
          <xsl:choose>
            <xsl:when test="name(.) = 'wp:inline'">
              <xsl:text>as-char</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>paragraph</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <!-- images in pages -->
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="name(.) = 'wp:inline' ">
              <xsl:text>as-char</xsl:text>
            </xsl:when>
            <xsl:when test="$verticalRelativeFrom = 'line' or $horizontalRelativeFrom = 'line'">
              <xsl:text>char</xsl:text>
            </xsl:when>
            <xsl:when test="$verticalRelativeFrom = 'character' or $horizontalRelativeFrom = 'character'">
              <xsl:text>char</xsl:text>
            </xsl:when>
            <xsl:when test="$verticalRelativeFrom = 'page'">
              <xsl:text>page</xsl:text>
            </xsl:when>
            <xsl:when test="$verticalRelativeFrom = 'paragraph'">
              <xsl:text>char</xsl:text>
            </xsl:when>
            <xsl:when test="$layoutInCell = 1">
              <xsl:text>paragraph</xsl:text>
            </xsl:when>
            <xsl:when test="$layoutInCell = 0">
              <xsl:text>page</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>page</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="SetSize">
    <xsl:choose>
      <xsl:when test="a:graphic/a:graphicData/pic:pic/pic:spPr/a:ln and not(a:graphic/a:graphicData/pic:pic/pic:spPr/a:ln/a:noFill)">
        <xsl:variable name="border" select="concat(a:graphic/a:graphicData/pic:pic/pic:spPr/a:ln/@w div 360000.0, 'cm')" />
        <xsl:variable name="height" select="concat(wp:extent/@cy div 360000.0, 'cm')" />
        <xsl:variable name="width" select="concat(wp:extent/@cx div 360000.0, 'cm')" />
        <xsl:attribute name="svg:height">
          <xsl:value-of select="concat(substring-before($height,'cm')+substring-before($border,'cm')+substring-before($border,'cm'),'cm')" />
        </xsl:attribute>
        <xsl:attribute name="svg:width">
          <xsl:value-of select="concat(substring-before($width,'cm')+substring-before($border,'cm')+substring-before($border,'cm'),'cm')" />
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="svg:height">
          <xsl:value-of select="concat(wp:extent/@cy  div 360000.0, 'cm')" />
        </xsl:attribute>
        <xsl:attribute name="svg:width">
          <xsl:value-of select="concat(wp:extent/@cx div 360000.0, 'cm')" />
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="SetPosition">
    <xsl:attribute name="svg:x">
      <xsl:value-of select="concat(wp:positionH/wp:posOffset  div 360000.0, 'cm')" />
    </xsl:attribute>
    <xsl:attribute name="svg:y">
      <xsl:choose>
        <xsl:when test="wp:positionV/@relativeFrom = 'line'">
          <xsl:value-of select="concat(wp:positionV/wp:posOffset  div 360000.0, 'cm')" />
        </xsl:when>
        <xsl:when test="wp:positionV/@relativeFrom = 'bottomMargin'">
          <xsl:variable name="pgH" select="concat(/w:document/w:body/w:sectPr/w:pgSz/@w:h * 2.54 div 1440.0, 'cm')" />
          <xsl:variable name="botMar" select="concat(/w:document/w:body/w:sectPr/w:pgMar/@w:bottom  * 2.54 div 1440.0, 'cm')" />
          <xsl:variable name="Pos" select="concat(wp:positionV/wp:posOffset  div 360000.0, 'cm')" />

          <xsl:value-of select="substring-before($pgH,'cm') -substring-before($botMar,'cm') + substring-before($Pos,'cm')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(wp:positionV/wp:posOffset  div 360000.0, 'cm')" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!-- inserts image href from relationships -->
  <xsl:template name="InsertImageHref">
    <xsl:param name="document"/>
    <xsl:param name="rId"/>
    <xsl:param name="targetName"/>
    <xsl:param name="srcFolder" select="'Pictures'"/>

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
    <xsl:for-each select="key('Part', concat('word/_rels/',$document,'.rels'))/rels:Relationships/rels:Relationship[@Id=$id]">
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
      <xsl:attribute name="xlink:href">
        <xsl:choose>
          <xsl:when test="$targetmode='External'">
            <xsl:value-of select="concat('ooc-UriFromPath', '-oop-', $pziptarget, '-ooe')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($srcFolder,'/', $pziptarget)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:for-each>
  </xsl:template>

  <!--
  -->
  <xsl:template name="InsertPictureProperties">
    <xsl:param name="drawing" />

    <xsl:call-template name="InsertImagePosH"/>
    <xsl:call-template name="InsertImagePosV"/>
    <xsl:call-template name="InsertImageFlip"/>
    <xsl:call-template name="InsertImageCrop"/>
    <xsl:call-template name="InsertImageWrap">
      <xsl:with-param name="wpAnchor" select="$drawing/wp:anchor" />
    </xsl:call-template>
    <xsl:call-template name="InsertImageMargins"/>
    <xsl:call-template name="InsertImageFlowWithText"/>
    <xsl:call-template name="InsertImageBorder"/>
  </xsl:template>

  <xsl:template name="InsertImageFlowWithText">
    <!-- @layoutInCell: Specifies how this DrawingML object shall behave when its anchor is located in a table
			cell; and its specified position would cause it to intersect with a table cell displayed in the document.-->
    <xsl:variable name="layoutInCell" select="(wp:inline/@layoutInCell | wp:anchor/@layoutInCell) and ./ancestor::w:tc"/>
    <xsl:attribute name="draw:flow-with-text">
      <xsl:choose>
        <!--If the pic is inside the table-->
        <xsl:when test="(ancestor::w:hdr or ancestor::w:ftr) and (./ancestor::w:tc)">
          <xsl:text>true</xsl:text>
        </xsl:when>
        <xsl:when test="$layoutInCell = 1">
          <!--only set to true of actually inside a table. @draw:flow-with-text has an effect 
				in OOo even when the shape is not inside a table -->
          <xsl:text>true</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>false</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="InsertImageBorder">
    <xsl:if test="*[self::wp:inline or self::wp:anchor]/a:graphic/a:graphicData/pic:pic/pic:spPr/a:ln[not(a:noFill)]">
      <xsl:variable name="width" select="concat(*[self::wp:inline or self::wp:anchor]/a:graphic/a:graphicData/pic:pic/pic:spPr/a:ln/@w  div 360000.0, 'cm')" />

      <xsl:variable name="type">
        <xsl:choose>
          <xsl:when test="*[self::wp:inline or self::wp:anchor]/a:graphic/a:graphicData/pic:pic/pic:spPr/a:ln/a:prstDash/@val = 'solid'">
            <xsl:text>solid</xsl:text>
          </xsl:when>
          <xsl:when
           test="*[self::wp:inline or self::wp:anchor]/a:graphic/a:graphicData/pic:pic/pic:spPr/a:ln/@cmpd = 'double'">
            <xsl:text>double</xsl:text>
          </xsl:when>
          <xsl:when
           test="*[self::wp:inline or self::wp:anchor]/a:graphic/a:graphicData/pic:pic/pic:spPr/a:ln/@cmpd = 'thickThin'">
            <xsl:text>double</xsl:text>
          </xsl:when>
          <xsl:when
          test="*[self::wp:inline or self::wp:anchor]/a:graphic/a:graphicData/pic:pic/pic:spPr/a:ln/@cmpd = 'thinThick'">
            <xsl:text>double</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>solid</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="color">
        <xsl:choose>
          <xsl:when
            test="*[self::wp:inline or self::wp:anchor]/a:graphic/a:graphicData/pic:pic/pic:spPr/a:ln/a:solidFill/a:srgbClr">
            <xsl:value-of select="*[self::wp:inline or self::wp:anchor]/a:graphic/a:graphicData/pic:pic/pic:spPr/a:ln/a:solidFill/a:srgbClr/@val" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>000000</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:attribute name="fo:border">
        <xsl:value-of select="concat($width,' ',$type,' #',$color)"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!--
  Summary:  Inserts the style:wrap attribute for a draw:frame
  Author:   Clever Age
  Modified: makz (DIaLOGIKa)
  Params:   wpAnchor: The wp:anchor element of the DML picture
  -->
  <xsl:template name="InsertImageWrap">
    <xsl:param name="wpAnchor" />

    <xsl:if test="$wpAnchor/wp:wrapSquare or 
            $wpAnchor/wp:wrapTight or 
            $wpAnchor/wp:wrapTopAndBottom or 
            $wpAnchor/wp:wrapThrough or 
            $wpAnchor/wp:wrapNone">

      <xsl:attribute name="style:wrap">
        <xsl:choose>
          <xsl:when test="$wpAnchor/wp:wrapSquare">
            <xsl:call-template name="InsertSquareWrap">
              <xsl:with-param name="wrap" select="$wpAnchor/wp:wrapSquare/@wrapText"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$wpAnchor/wp:wrapTight">
            <xsl:call-template name="InsertSquareWrap">
              <xsl:with-param name="wrap" select="$wpAnchor/wp:wrapTight/@wrapText"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$wpAnchor/wp:wrapTopAndBottom">
            <xsl:text>none</xsl:text>
          </xsl:when>
          <xsl:when test="$wpAnchor/wp:wrapThrough">
            <xsl:call-template name="InsertSquareWrap">
              <xsl:with-param name="wrap" select="$wpAnchor/wp:wrapThrough/@wrapText"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$wpAnchor/wp:wrapNone">
            <xsl:text>run-through</xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>

    <!--
    makz:
    If no wrap is specified, Word wraps the picture in front of the text.
    If the picture is in a header or footer it will be rendered behind the text of the main document.
    If the behindDoc attribute is set, it will also be rendered behind the text.
    -->
    <xsl:if test="$wpAnchor/wp:wrapNone">
      <xsl:attribute name="style:run-through">
        <xsl:choose>
          <xsl:when test="$wpAnchor/@behindDoc='1'">
            <xsl:text>background</xsl:text>
          </xsl:when>
          <xsl:when test="ancestor::*[w:hdr] or ancestor::*[w:ftr]" >
            <xsl:text>background</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>foreground</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="InsertImageMargins">
    <xsl:if test="wp:anchor">

      <xsl:attribute name="fo:margin-top">
        <xsl:value-of select="concat(wp:anchor/@distT  div 360000.0, 'cm')" />
      </xsl:attribute>

      <xsl:attribute name="fo:margin-bottom">
        <xsl:value-of select="concat(wp:anchor/@distB  div 360000.0, 'cm')" />
      </xsl:attribute>

      <xsl:attribute name="fo:margin-left">
        <xsl:value-of select="concat(wp:anchor/@distL  div 360000.0,  'cm')" />
      </xsl:attribute>

      <xsl:attribute name="fo:margin-right">
        <xsl:value-of select="concat(wp:anchor/@distR  div 360000.0, 'cm')" />
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="InsertSquareWrap">
    <xsl:param name="wrap"/>

    <xsl:choose>
      <xsl:when test="$wrap = 'bothSides' ">
        <xsl:text>parallel</xsl:text>
      </xsl:when>
      <xsl:when test="$wrap = 'largest' ">
        <xsl:text>dynamic</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$wrap"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="GetCropSize">
    <xsl:param name="cropValue"/>
    <xsl:param name="cropOppositeValue"/>
    <xsl:param name="resultSize"/>

    <xsl:choose>
      <xsl:when test="not($cropValue)">
        <xsl:text>0</xsl:text>
      </xsl:when>

      <xsl:otherwise>
        <xsl:variable name="cropPercent" select="$cropValue div (100000)"/>
        <xsl:variable name="cropOppositePercent">
          <xsl:choose>
            <xsl:when test="$cropOppositeValue">
              <xsl:value-of select="$cropOppositeValue div (100000)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>0</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:value-of
          select="format-number(($resultSize div(1 - $cropPercent - $cropOppositePercent)) *  $cropPercent , '0.000' )"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="InsertImagePosH">

    <xsl:if test="descendant::wp:positionH">


      <xsl:call-template name="InsertGraphicPosH">
        <xsl:with-param name="align" select="descendant::wp:positionH/wp:align"/>
      </xsl:call-template>

      <xsl:call-template name="InsertGraphicPosRelativeH">
        <xsl:with-param name="relativeFrom" select="descendant::wp:positionH/@relativeFrom"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="InsertGraphicPosH">
    <xsl:param name="align"/>
    <xsl:param name="relativeFrom" />

    <xsl:attribute name="style:horizontal-pos">
      <xsl:choose>
        <!--added by chhavi to fix problam related to alignment and absolute position  in case of inner-margin and outer-margin area  -->
        <!-- Sona: #2149141 changes because mirror margins was lost-->
        <xsl:when test ="$relativeFrom='inner-margin-area' and (not($align) or $align ='' or $align = 'absolute')   or  $relativeFrom = 'outer-margin-area' and (not($align) or $align ='' or $align = 'absolute') ">
          <xsl:text>from-inside</xsl:text>
        </xsl:when>
        <xsl:when test ="$relativeFrom='inner-margin-area' or $relativeFrom='outer-margin-area'">
          <xsl:if test ="$align='left'">
            <xsl:text>inside</xsl:text>
          </xsl:if>
          <xsl:if test ="$align='right'">
            <xsl:text>outside</xsl:text>
          </xsl:if>
          <xsl:if test ="$align='center'">
            <xsl:text>middle</xsl:text>
          </xsl:if>
        </xsl:when>
        <!--end here-->
        <!-- Sona: #2149141 changes because mirror margins was lost-->
        <xsl:when test="$align = 'absolute' ">
          <xsl:text>from-left</xsl:text>
        </xsl:when>
        <xsl:when test="$align and $align != '' ">
          <xsl:value-of select="$align"/>
        </xsl:when>

        <xsl:otherwise>
          <xsl:text>from-left</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="InsertGraphicPosRelativeH">
    <xsl:param name="relativeFrom"/>
    <xsl:param name="hPos" />

    <xsl:attribute name="style:horizontal-rel">
      <xsl:choose>
        <xsl:when test="$relativeFrom = 'margin' or $relativeFrom = 'column'">
          <xsl:text>page-content</xsl:text>
        </xsl:when>
        <xsl:when test="$relativeFrom ='page'">
          <xsl:text>page</xsl:text>
        </xsl:when>
        <xsl:when test="$relativeFrom ='text'">
          <xsl:text>paragraph</xsl:text>
        </xsl:when>
        <xsl:when test=" $relativeFrom = 'outside-margin-area'">
          <!--<xsl:text>page-start-margin</xsl:text>-->
          <xsl:text>page</xsl:text>
        </xsl:when>
        <xsl:when test=" $relativeFrom = 'inside-margin-area'">
          <!--<xsl:text>page-end-margin</xsl:text>-->
          <xsl:text>page</xsl:text>
        </xsl:when>
        <xsl:when test="$relativeFrom = 'character' or $relativeFrom = 'char'">
          <xsl:text>char</xsl:text>
        </xsl:when>
        <!-- COMMENT : following values not defined in OOX spec, but used by Word 2007 -->
        <!--added by chhavi to improve absolute and alignment position-->
        <xsl:when test="$relativeFrom = 'left-margin-area' or $relativeFrom = 'outer-margin-area'">
          <!-- Sona: #2149141 changes because mirror margins was lost-->
          <xsl:text>page-start-margin</xsl:text>
        </xsl:when>
        <xsl:when test="$relativeFrom = 'right-margin-area' or $relativeFrom = 'inner-margin-area'">
          <xsl:text>page-end-margin</xsl:text>
        </xsl:when>

        <!--end here-->
        <xsl:when test="$relativeFrom=''">
          <!-- 
          if no relation is set, Word uses default values, 
          depeding on the position
          -->
          <xsl:choose>
            <!-- 
            If no position is set, it is absolute positioning.
            In this case the default relation is the paragraph-content 
            -->
            <xsl:when test="$hPos=''">
              <xsl:text>paragraph-content</xsl:text>
            </xsl:when>
            <!-- 
            If a position is set, it is relative positioning.
            In this case the default relation is the page-content 
            -->
            <xsl:otherwise>
              <xsl:text>page-content</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>paragraph</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="InsertGraphicPosV">
    <xsl:param name="align"/>
    <xsl:param name="relativeFrom"/>

    <xsl:attribute name="style:vertical-pos">
      <xsl:choose>
        <xsl:when test="$align and $align != ''">
          <xsl:choose>
            <!--special rules-->
            <xsl:when  test="$relativeFrom = 'top-margin-area' or $relativeFrom = 'bottom-margin-area' or $relativeFrom = 'inner-margin-area' or $relativeFrom = 'outer-margin-area'">
              <xsl:text>from-top</xsl:text>
            </xsl:when>
            <xsl:when test=" $relativeFrom = 'line'  and $align= 'bottom' ">
              <xsl:text>top</xsl:text>
            </xsl:when>
            <xsl:when test=" $relativeFrom = 'line'  and $align= 'top' ">
              <xsl:text>bottom</xsl:text>
            </xsl:when>
            <!--default rules-->
            <!--changed by chhavi top to from-top-->
            <xsl:when test="$align = 'top' ">
              <xsl:text>from-top</xsl:text>
            </xsl:when>
            <xsl:when test="$align = 'center' ">
              <xsl:text>middle</xsl:text>
            </xsl:when>
            <xsl:when test="$align = 'bottom' ">
              <xsl:text>bottom</xsl:text>
            </xsl:when>
            <xsl:when test="$align = 'inside' ">
              <xsl:text>top</xsl:text>
            </xsl:when>
            <xsl:when test="$align = 'outside' ">
              <xsl:text>bottom</xsl:text>
            </xsl:when>
            <xsl:when test="$align = 'from-top' ">
              <xsl:text>from-top</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <!-- Sona: change if the "mso-position-vertical" value is absolute-->
              <xsl:text>from-top</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <!-- if there is vertical position offset -->
            <xsl:when test="contains(@style,'margin-top') or wp:anchor/wp:positionV/wp:posOffset/text() != '' or (w:pPr/w:framePr/@w:y and not(w:pPr/w:framePr/@w:yAlign))">
              <xsl:text>from-top</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>from-top</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="InsertGraphicPosRelativeV">
    <xsl:param name="relativeFrom"/>
    <xsl:param name="align"/>

    <xsl:attribute name="style:vertical-rel">
      <xsl:choose>
        <xsl:when test="$relativeFrom = 'margin' ">
          <xsl:text>page-content</xsl:text>
        </xsl:when>
        <xsl:when test="$relativeFrom ='page'">
          <xsl:text>page</xsl:text>
        </xsl:when>
        <xsl:when test="$relativeFrom = 'top-margin-area'">
          <xsl:text>page</xsl:text>
        </xsl:when>
        <xsl:when test="$relativeFrom = 'bottom-margin-area'">
          <xsl:text>page</xsl:text>
        </xsl:when>
        <xsl:when test="$relativeFrom = 'inner-margin-area'">
          <xsl:text>page</xsl:text>
        </xsl:when>
        <xsl:when test="$relativeFrom = 'outer-margin-area'">
          <xsl:text>page</xsl:text>
        </xsl:when>
        <xsl:when test="$relativeFrom = 'line'">
          <!--<xsl:text>line</xsl:text>-->
          <!--changed by chhavi-->
          <xsl:text>paragraph-content</xsl:text>
          <!--end here-->
        </xsl:when>
        <xsl:when test="$relativeFrom = 'paragraph'">
          <xsl:text>paragraph-content</xsl:text>
        </xsl:when>
        <xsl:when test="$relativeFrom = 'text' or $relativeFrom = '' ">
          <xsl:text>paragraph-content</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>page</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <xsl:if
      test="$relativeFrom = 'line' and ($align = 'center'  or $align =  'outside' or $align = 'bottom' ) ">
      <xsl:attribute name="draw:flow-with-text">
        <xsl:text>false</xsl:text>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="InsertImagePosV">
    <xsl:if test="descendant::wp:positionV">
      <xsl:variable name="align" select="descendant::wp:positionV/wp:align"/>
      <xsl:variable name="relativeFrom" select="descendant::wp:positionV/@relativeFrom"/>

      <xsl:call-template name="InsertGraphicPosV">
        <xsl:with-param name="align" select="$align"/>
        <xsl:with-param name="relativeFrom" select="$relativeFrom"/>
      </xsl:call-template>

      <xsl:call-template name="InsertGraphicPosRelativeV">
        <xsl:with-param name="relativeFrom" select="$relativeFrom"/>
        <xsl:with-param name="align" select="$align"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="InsertImageFlip">
    <!--  picture flip (vertical, horizontal)-->
    <xsl:if test="descendant::pic:spPr/a:xfrm/attribute::node()">
      <xsl:for-each select="descendant::pic:pic">
        <xsl:attribute name="style:mirror">
          <xsl:choose>
            <xsl:when test="pic:spPr/a:xfrm/@flipV = '1' and pic:spPr/a:xfrm/@flipH = '1'">
              <xsl:text>horizontal vertical</xsl:text>
            </xsl:when>
            <xsl:when test="pic:spPr/a:xfrm/@flipV = '1' ">
              <xsl:text>vertical</xsl:text>
            </xsl:when>
            <xsl:when test="pic:spPr/a:xfrm/@flipH = '1' ">
              <xsl:text>horizontal</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:attribute>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template name="InsertImageCrop">
    <!-- crop -->
    <xsl:if test="descendant::pic:blipFill/a:srcRect/attribute::node()">
      <xsl:for-each select="descendant::pic:pic">
        <xsl:variable name="width" select="ancestor::w:drawing/descendant::wp:extent/@cx  div 360000.0" />
        <xsl:variable name="height" select="ancestor::w:drawing/descendant::wp:extent/@cy div 360000.0"/>

        <xsl:variable name="leftCrop">
          <xsl:call-template name="GetCropSize">
            <xsl:with-param name="cropValue" select="pic:blipFill/a:srcRect/@l"/>
            <xsl:with-param name="cropOppositeValue" select="pic:blipFill/a:srcRect/@r"/>
            <xsl:with-param name="resultSize" select="$width"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="rightCrop">
          <xsl:call-template name="GetCropSize">
            <xsl:with-param name="cropValue" select="pic:blipFill/a:srcRect/@r"/>
            <xsl:with-param name="cropOppositeValue" select="pic:blipFill/a:srcRect/@l"/>
            <xsl:with-param name="resultSize" select="$width"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="topCrop">
          <xsl:call-template name="GetCropSize">
            <xsl:with-param name="cropValue" select="pic:blipFill/a:srcRect/@t"/>
            <xsl:with-param name="cropOppositeValue" select="pic:blipFill/a:srcRect/@b"/>
            <xsl:with-param name="resultSize" select="$height"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="bottomCrop">
          <xsl:call-template name="GetCropSize">
            <xsl:with-param name="cropValue" select="pic:blipFill/a:srcRect/@b"/>
            <xsl:with-param name="cropOppositeValue" select="pic:blipFill/a:srcRect/@t"/>
            <xsl:with-param name="resultSize" select="$height"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:attribute name="fo:clip">

          <xsl:variable name="oldValue" select="concat('rect(',$topCrop,'cm ',$rightCrop,'cm ',$bottomCrop,'cm ',$leftCrop,'cm',')')" />
            
          <xsl:variable name="filecode" select="pic:blipFill/a:blip/@r:embed"></xsl:variable>
          <xsl:variable name="filename" select="key('Part', 'word/_rels/document.xml.rels')/rels:Relationships/rels:Relationship[@Id = $filecode]/@Target"></xsl:variable>
          <xsl:value-of select="concat('COMPUTEODFCROPPING[', pic:blipFill/a:srcRect/@r, ',' ,pic:blipFill/a:srcRect/@l, ',' , pic:blipFill/a:srcRect/@t, ',' ,pic:blipFill/a:srcRect/@b, ',word/' , $filename,  ',' , $oldValue, ']')"/>
        </xsl:attribute>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
