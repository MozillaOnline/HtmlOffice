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
  xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
  xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
  xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
  xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
  xmlns:oox="urn:oox"              
  xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
  xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
  exclude-result-prefixes="w oox">

  <!-- 
  *************************************************************************
  MATCHING TEMPLATES
  *************************************************************************
  -->

  <!--
  Summary: Handles the conversion of inline and floating tables.
  -->
  <xsl:template match="w:tbl">
    <xsl:choose>
      <xsl:when test="not(w:tblPr/w:tblpPr)">
        <!-- convert inline table -->
        <xsl:call-template name="InsertTable" />
      </xsl:when>
      <xsl:when test=".//w:commentReference or .//w:footnoteReference or .//w:endnoteReference or .//w:fldChar or .//w:fldSimple">
        <!--Floating tables with notes, comments and fields do not open in OOo. 
            They also do not open in Word after a roundtrip because they will be placed within a shape -->
        <xsl:call-template name="InsertTable" />
      </xsl:when>
      <xsl:otherwise>
        <!-- position floating tables using a frame -->
        <text:p text:style-name="HiddenParagraph">
          <draw:frame>
            <xsl:attribute name="draw:style-name">
              <xsl:value-of select="generate-id(w:tblPr/w:tblpPr)"/>
            </xsl:attribute>
            <xsl:attribute name="draw:name">
              <xsl:value-of select="concat('Frame', generate-id(w:tblPr/w:tblpPr))"/>
            </xsl:attribute>
            <xsl:call-template name="InsertTableFramePosition">
              <xsl:with-param name="tblPr" select="w:tblPr" />
            </xsl:call-template>

            <xsl:choose>
              <!-- relative width -->
              <xsl:when test="w:tblPr/w:tblW/@w:type='pct'">
                <xsl:attribute name="style:rel-width">
                  <xsl:value-of select="concat(100 * w:tblPr/w:tblW/@w:w div 5000, '%')"/>
                </xsl:attribute>
              </xsl:when>
              <!-- absolute width -->
              <xsl:when test="w:tblPr/w:tblW/@w:type='dxa'">
                <xsl:attribute name="svg:width">
                  <xsl:value-of select="concat((w:tblPr/w:tblW/@w:w) * 2.54 div 1440.0, 'cm')" />
                </xsl:attribute>
              </xsl:when>
            </xsl:choose>
            
            <draw:text-box>
              <xsl:if test="not(w:tblPr/w:tblW/@w:type='pct') and not(w:tblPr/w:tblW/@w:type='dxa')">
                <!--auto width-->
                <xsl:attribute name="fo:min-width">
                  <xsl:text>0cm</xsl:text>
                </xsl:attribute>
              </xsl:if>
              <xsl:call-template name="InsertTable" />
            </draw:text-box>
          </draw:frame>
        </text:p>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template match="w:tblPr" mode="automaticstyles">
    <xsl:apply-templates select="w:tblpPr" mode="automaticstyles" />

    <style:style style:name="{generate-id(parent::w:tbl)}" style:family="table">
      <xsl:if test="w:tblStyle">
        <xsl:attribute name="style:parent-style-name">
          <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', w:tblStyle/@w:val, '-ooe')"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:call-template name="InsertMasterPageNameAttribute"/>
      <xsl:call-template name="InsertTableProperties">
        <xsl:with-param name="Default">StyleTableProperties</xsl:with-param>
      </xsl:call-template>
    </style:style>
  </xsl:template>

  <!-- 
  Converts the properties of a positioned table
  The tblpPr proerties are converted to a style of a draw:frame
  -->
  <xsl:template match="w:tblpPr" mode="automaticstyles">
    <style:style style:name="{generate-id(.)}" style:family="graphic" style:parent-style-name="Frame">
      <style:graphic-properties>
        <xsl:attribute name="style:wrap">
          <xsl:text>dynamic</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="style:number-wrapped-paragraphs">
          <xsl:text>no-limit</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="fo:background-color">
          <xsl:text>#ffffff</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="style:background-transparency">
          <xsl:text>100%</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="draw:wrap-influence-on-position">
          <xsl:text>once-successive</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="fo:padding">
          <xsl:text>0cm</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="fo:border">
          <xsl:text>none</xsl:text>
        </xsl:attribute>

        <xsl:call-template name="InsertTableFramePositionForStyle">
          <xsl:with-param name="tblpPr" select="." />
        </xsl:call-template>
      </style:graphic-properties>
    </style:style>
  </xsl:template>

  <xsl:template match="w:tblGrid">
    <xsl:for-each select="w:gridCol">
      <table:table-column table:style-name="{generate-id(self::w:gridCol)}" />
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="w:tblGrid" mode="automaticstyles">

    <xsl:variable name="totalGridWidth">
      <xsl:call-template name="ComputeGridWidth">
        <xsl:with-param name="grid" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="tblW" select="ancestor::w:tbl/w:tblPr/w:tblW" />

    <xsl:for-each select="w:gridCol">

      <style:style style:name="{generate-id(self::w:gridCol)}" style:family="table-column">
        <style:table-column-properties>
          <xsl:call-template name="InsertColumnWidthForStyle">
            <xsl:with-param name="gridCol" select="." />
            <xsl:with-param name="gridWidth" select="$totalGridWidth" />
            <xsl:with-param name="tblW" select="$tblW" />
          </xsl:call-template>
        </style:table-column-properties>
      </style:style>

    </xsl:for-each>
  </xsl:template>

  <xsl:template match="w:tr">
    <xsl:choose>
      <xsl:when test="child::w:trPr/w:tblHeader">
        <table:table-header-rows>
          <table:table-row>
            <xsl:if test="w:trPr">
              <!-- an automaitic style is only generated for rows with a w:trPr node -->
              <xsl:attribute name="table:style-name">
                <xsl:value-of select="generate-id(self::w:tr)"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates />
          </table:table-row>
        </table:table-header-rows>
      </xsl:when>
      <xsl:otherwise>
        <table:table-row>
          <xsl:if test="w:trPr">
            <!-- an automaitic style is only generated for rows with a w:trPr node -->
            <xsl:attribute name="table:style-name">
              <xsl:value-of select="generate-id(self::w:tr)"/>
            </xsl:attribute>
          </xsl:if>

          <!-- Insert empty cells for gridBefore -->
          <xsl:call-template name="InsertEmptyCells">
            <xsl:with-param name="count" select="w:trPr/w:gridBefore/@w:val" />
          </xsl:call-template>

          <xsl:apply-templates />
        </table:table-row>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="w:trPr" mode="automaticstyles">
    <style:style style:name="{generate-id(parent::w:tr)}" style:family="table-row">
      <style:table-row-properties>
        <xsl:call-template name="InsertRowProperties"/>
      </style:table-row-properties>
    </style:style>
  </xsl:template>


  <xsl:template match="w:tc">
    <xsl:choose>
      <!-- for w:vMerge="continuous" cells, create a table:covered-table-cell element -->
      <xsl:when test="w:tcPr/w:vMerge and not(w:tcPr/w:vMerge/@w:val = 'restart')">
        <table:covered-table-cell table:style-name="{generate-id()}">
          <xsl:apply-templates/>
        </table:covered-table-cell>
      </xsl:when>
      <xsl:otherwise>
        <!-- create normal a table cell -->
        <table:table-cell table:style-name="{generate-id()}">
          <!-- column-span -->
          <xsl:if test="w:tcPr/w:gridSpan and w:tcPr/w:gridSpan/@w:val != '0'">
            <xsl:attribute name="table:number-columns-spanned">
              <xsl:value-of select="w:tcPr/w:gridSpan/@w:val"/>
            </xsl:attribute>
          </xsl:if>
          <!-- new row-span (w:vMerge="restart") -->
          <xsl:if test="w:tcPr/w:vMerge and w:tcPr/w:vMerge/@w:val = 'restart' ">
            <xsl:variable name="number-rows-spanned">
              <xsl:call-template name="ComputeNumberRowsSpanned">
                <xsl:with-param name="cellPosition">
                  <xsl:call-template name="GetCellPosition"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:variable>
            <xsl:attribute name="table:number-rows-spanned">
              <xsl:choose>
                <!-- patch: can't have number-rows-spanned < 2 -->
                <xsl:when test="$number-rows-spanned &lt; 2">2</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$number-rows-spanned"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </xsl:if>

          <!--
          makz: If the last paragraph in a table cell is behind a inner table and it is empty (no run), 
          it is the default w:p that must exist in every cell.
          Word does not display this paragraph. So we cannot not convert it because Open Office will display it.
          
          See bug 1839896 for reference.
          -->
          <xsl:variable name="childCount" select="count(*)" />
          <xsl:for-each select="./*">
            <xsl:if test="not(position() = $childCount and preceding-sibling::w:tbl and not(w:r))">
              <xsl:apply-templates select="."/>
            </xsl:if>
          </xsl:for-each>

        </table:table-cell>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="w:tcPr" mode="automaticstyles">
    <style:style style:name="{generate-id(parent::w:tc)}" style:family="table-cell">
      <xsl:if test="w:tcStyle">
        <xsl:attribute name="style:parent-style-name">
          <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', w:tcStyle/@w:val, '-ooe')"/>
        </xsl:attribute>
      </xsl:if>
      <style:table-cell-properties>
        <xsl:call-template name="InsertCellsProperties" >
          <xsl:with-param name="tcPr" select="." />
          <xsl:with-param name="tableStyleId" select="ancestor::w:tbl/w:tblPr/w:tblStyle/@w:val" />
        </xsl:call-template>
      </style:table-cell-properties>
    </style:style>
  </xsl:template>


  <!-- 
  *************************************************************************
  CALLED TEMPLATES
  *************************************************************************
  -->

  <!--
  Summary:  Converts inline and floating tables
  Author:   divo (DIaLOGIKa)
  Params:   none
  -->
  <xsl:template name="InsertTable">
    <table:table>
      <xsl:attribute name="table:style-name">
        <xsl:value-of select="generate-id(self::w:tbl)"/>
      </xsl:attribute>
      <!--TODO: @table:style-name -->
      <xsl:apply-templates select="w:tblGrid"/>
      <xsl:apply-templates select="w:tr"/>
    </table:table>
  </xsl:template>


  <!--
  Summary:  Converts the positioning properties of a Word table to draw:frame properties
  Author:   makz (DIaLOGIKa)
  Params:   tblPr: The properties of the Word table
  -->
  <xsl:template name="InsertTableFramePosition">
    <xsl:param name="tblPr" />

    <xsl:attribute name="text:anchor-type">
      <xsl:choose>
        <xsl:when test="$tblPr/w:tblpPr/@w:vertAnchor='text' or $tblPr/w:tblpPr/@w:horzAnchor='text'">
          <xsl:text>char</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>paragraph</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <xsl:if test="$tblPr/w:tblpPr/@w:tblpX != ''">
      <xsl:attribute name="svg:x">
        <xsl:value-of select="concat(($tblPr/w:tblpPr/@w:tblpX) * 2.54 div 1440.0, 'cm')" />
      </xsl:attribute>
    </xsl:if>

    <xsl:if test="$tblPr/w:tblpPr/@w:tblpY != ''">
      <xsl:attribute name="svg:y">
        <xsl:value-of select="concat(($tblPr/w:tblpPr/@w:tblpY) * 2.54 div 1440.0, 'cm')" />
      </xsl:attribute>
    </xsl:if>

  </xsl:template>

  <!--
  Summary:  Converts the positioning properties of a Word table to the style of a draw:frame
  Author:   makz (DIaLOGIKa)
  Params:   tblpPr: The positioning properties of the Word table
  -->
  <xsl:template name="InsertTableFramePositionForStyle">
    <xsl:param name="tblpPr" />

    <xsl:attribute name="style:vertical-rel">
      <xsl:choose>
        <xsl:when test="$tblpPr/@w:vertAnchor='page'">
          <xsl:text>page</xsl:text>
        </xsl:when>
        <xsl:when test="$tblpPr/@w:vertAnchor='margin'">
          <xsl:text>paragraph-content</xsl:text>
        </xsl:when>
        <xsl:when test="$tblpPr/@w:vertAnchor='text'">
          <xsl:text>char</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>

    <xsl:attribute name="style:vertical-pos">
      <xsl:choose>
        <xsl:when test="$tblpPr/@w:tblpYSpec = 'top'">
          <xsl:text>top</xsl:text>
        </xsl:when>
        <xsl:when test="$tblpPr/@w:tblpYSpec = 'center'">
          <xsl:text>middle</xsl:text>
        </xsl:when>
        <xsl:when test="$tblpPr/@w:tblpYSpec = 'bottom'">
          <xsl:text>bottom</xsl:text>
        </xsl:when>
        <xsl:when test="$tblpPr/@w:tblpY != ''">
          <xsl:text>from-top</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>

    <xsl:attribute name="style:horizontal-rel">
      <xsl:choose>
        <xsl:when test="$tblpPr/@w:horzAnchor='page'">
          <xsl:text>page</xsl:text>
        </xsl:when>
        <xsl:when test="$tblpPr/@w:horzAnchor='margin'">
          <xsl:text>paragraph-content</xsl:text>
        </xsl:when>
        <xsl:when test="$tblpPr/@w:horzAnchor='text'">
          <xsl:text>char</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>

    <xsl:attribute name="style:horizontal-pos">
      <xsl:choose>
        <xsl:when test="$tblpPr/@w:tblpXSpec = 'left'">
          <xsl:text>left</xsl:text>
        </xsl:when>
        <xsl:when test="$tblpPr/@w:tblpXSpec = 'center'">
          <xsl:text>center</xsl:text>
        </xsl:when>
        <xsl:when test="$tblpPr/@w:tblpXSpec = 'right'">
          <xsl:text>right</xsl:text>
        </xsl:when>
        <xsl:when test="$tblpPr/@w:tblpY != ''">
          <xsl:text>from-left</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>


  <!--
  Summary:  Inserts a certain amount of empty cells into a row
  Author:   makz (DIaLOGIKa)
  Params:   count: The count of cells
            iterator: This params is only used internally by the recursive call
  -->
  <xsl:template name="InsertEmptyCells">
    <xsl:param name="count" select="'0'" />
    <xsl:param name="iterator" select="'0'"/>

    <xsl:if test="$iterator &lt; $count">
      <table:table-cell>
        <text:p/>
      </table:table-cell>

      <xsl:call-template name="InsertEmptyCells">
        <xsl:with-param name="iterator" select ="$iterator + 1" />
        <xsl:with-param name="count" select ="$count" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- compute the number of rows that are spanned by context cell -->
  <xsl:template name="ComputeNumberRowsSpanned">
    <xsl:param name="cellPosition"/>
    <xsl:param name="rowCount" select="1"/>

    <xsl:choose>
      <xsl:when test="ancestor::w:tr[1]/following-sibling::w:tr[1]">
        <xsl:for-each select="ancestor::w:tr[1]/following-sibling::w:tr[1]/w:tc[1]">
          <xsl:call-template name="ComputeNumberRowsSpannedUsingCells">
            <xsl:with-param name="cellPosition" select="$cellPosition"/>
            <xsl:with-param name="rowCount" select="$rowCount"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$rowCount"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ComputeNumberRowsSpannedUsingCells">
    <xsl:param name="cellPosition"/>
    <xsl:param name="rowCount"/>

    <xsl:variable name="currentPosition">
      <xsl:call-template name="GetCellPosition"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$currentPosition = $cellPosition">
        <xsl:choose>
          <!-- go to the following row -->
          <xsl:when test="w:tcPr/w:vMerge and not(w:tcPr/w:vMerge/@w:val = 'restart')">
            <xsl:choose>
              <xsl:when test="not(parent::w:tr/following-sibling::w:tr[1]/w:tc[1])">
                <!-- Bug #1694962 -->
                <xsl:value-of select="$rowCount +2"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="parent::w:tr/following-sibling::w:tr[1]/w:tc[1]">
                  <xsl:call-template name="ComputeNumberRowsSpannedUsingCells">
                    <xsl:with-param name="cellPosition" select="$cellPosition"/>
                    <xsl:with-param name="rowCount" select="$rowCount+1"/>
                  </xsl:call-template>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$rowCount"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- go to the following cell -->
      <xsl:when test="$currentPosition &lt; $cellPosition and following-sibling::w:tc[1]">
        <xsl:for-each select="following-sibling::w:tc[1]">
          <xsl:call-template name="ComputeNumberRowsSpannedUsingCells">
            <xsl:with-param name="cellPosition" select="$cellPosition"/>
            <xsl:with-param name="rowCount" select="$rowCount"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$rowCount"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- find the position of context cell -->
  <xsl:template name="GetCellPosition">
    <xsl:param name="currentPosition" select="1"/>
    <xsl:choose>
      <xsl:when test="preceding-sibling::w:tc">
        <xsl:for-each select="preceding-sibling::w:tc[1]">
          <xsl:choose>
            <xsl:when test="w:tcPr/w:gridSpan and w:tcPr/w:gridSpan/@w:val != '0' ">
              <xsl:call-template name="GetCellPosition">
                <xsl:with-param name="currentPosition"
                  select="$currentPosition+number(w:tcPr/w:gridSpan/@w:val)"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="GetCellPosition">
                <xsl:with-param name="currentPosition" select="$currentPosition+1"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$currentPosition"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--  insert table properties: width, align, indent-->
  <xsl:template name="InsertTableProperties">
    <xsl:param name="Default"/>

    <style:table-properties table:border-model="collapsing">
      <xsl:choose>
        <xsl:when test="w:tblW/@w:type='pct'">
          <xsl:attribute name="style:rel-width">
            <xsl:call-template name="ConvertTwips">
              <xsl:with-param name="length">
                <xsl:value-of select="w:tblW/@w:w"/>
              </xsl:with-param>
              <xsl:with-param name="unit">pct</xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="table:align">
            <xsl:call-template name="InsertTableAlign"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="w:tblW/@w:type='dxa'">
          <xsl:attribute name="style:width">
            <xsl:value-of select="concat((w:tblW/@w:w) * 2.54 div 1440.0, 'cm')" />
          </xsl:attribute>
          <xsl:attribute name="table:align">
            <xsl:call-template name="InsertTableAlign"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="w:tblW/@w:type='auto'">
          <xsl:attribute name="style:width">
            <xsl:value-of select="concat((sum(ancestor::w:tbl[1]/w:tblGrid/w:gridCol/@w:w)) * 2.54 div 1440.0, 'cm')" />
          </xsl:attribute>
          <xsl:attribute name="table:align">
            <xsl:call-template name="InsertTableAlign"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>

      <xsl:call-template name="InsertTableIndentAttribute">
        <xsl:with-param name="tblPr" select="." />
      </xsl:call-template>

      <xsl:if test="parent::w:tbl/descendant::w:pageBreakBefore and 
        not(generate-id(parent::w:tbl) = generate-id(ancestor::w:body/child::node()[1]))">
        <xsl:choose>
          <xsl:when test="not(parent::w:tbl/preceding::w:p[1]/w:pPr/w:sectPr)">
            <xsl:attribute name="fo:break-before">
              <xsl:text>page</xsl:text>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="precSectPr" select="preceding::w:p[1]/w:pPr/w:sectPr"/>
            <xsl:variable name="followingSectPr" select="key('sectPr', number(ancestor-or-self::node()/@oox:s))"/>
            <xsl:if
              test="($precSectPr/w:pgSz/@w:w = $followingSectPr/w:pgSz/@w:w
              and $precSectPr/w:pgSz/@w:h = $followingSectPr/w:pgSz/@w:h
              and $precSectPr/w:pgSz/@w:orient = $followingSectPr/w:pgSz/@w:orient
              and $precSectPr/w:pgMar/@w:top = $followingSectPr/w:pgMar/@w:top
              and $precSectPr/w:pgMar/@w:left = $followingSectPr/w:pgMar/@w:left
              and $precSectPr/w:pgMar/@w:right = $followingSectPr/w:pgMar/@w:right
              and $precSectPr/w:pgMar/@w:bottom = $followingSectPr/w:pgMar/@w:bottom
              and $precSectPr/w:pgMar/@w:header = $followingSectPr/w:pgMar/@w:header
              and $precSectPr/w:pgMar/@w:footer = $followingSectPr/w:pgMar/@w:footer)">
              <xsl:attribute name="fo:break-before">
                <xsl:text>page</xsl:text>
              </xsl:attribute>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>

      <xsl:if test="$Default='StyleTableProperties'">
        <xsl:attribute name="fo:margin-bottom">
          <xsl:value-of select="concat((w:tblpPr/@w:bottomFromText) * 2.54 div 1440.0, 'cm')" />
        </xsl:attribute>
      </xsl:if>

    </style:table-properties>
  </xsl:template>

  <xsl:template name="InsertTableAlign">
    <xsl:choose>
      <xsl:when test="w:jc">
        <xsl:value-of select="w:jc/@w:val"/>
      </xsl:when>
      <xsl:when test="w:tblpPr/@w:tblpXSpec">
        <xsl:value-of select="w:tblpPr/@w:tblpXSpec"/>
      </xsl:when>
      <xsl:otherwise>left</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
  Summary:  Inserts the column width or relative column width of the column 
  Author:   makz (DIaLOGIKa)
  Params:   tblW: The w:tblW node of the table
            gridCol:
            gridWidth: The total dxa width of the grid
  -->
  <xsl:template name="InsertColumnWidthForStyle">
    <xsl:param name="gridCol" />
    <xsl:param name="gridWidth" />
    <xsl:param name="tblW" />

    <xsl:choose>
      <xsl:when test="$tblW/@w:type='pct'">
        <!-- table and cell width are relative values -->
        <xsl:attribute name="style:rel-column-width">
          <xsl:value-of select="concat(($gridCol/@w:w * 10000) div $gridWidth, '*')" />
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <!-- use absolute value -->
        <xsl:attribute name="style:column-width">
          <xsl:value-of select="concat(($gridCol/@w:w) * 2.54 div 1440.0, 'cm')" />
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--
  Summary:  Inserts the indent of a table.
  Author:   makz (DIaLOGIKa)
  Params:   table: The w:tbl node
  -->
  <xsl:template name="InsertTableIndentAttribute">
    <xsl:param name="tblPr" />

    <xsl:variable name="tableIndent">
      <xsl:call-template name="GetTableIndent">
        <xsl:with-param name="tblPr" select="$tblPr"/>
        <xsl:with-param name="styleName" select="$tblPr/w:tblStyle/@w:val" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="cellMargin">
      <xsl:call-template name="GetLeftCellMargin">
        <xsl:with-param name="tblPr" select="$tblPr"/>
        <xsl:with-param name="styleName" select="$tblPr/w:tblStyle/@w:val" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:attribute name="fo:margin-left">
      <xsl:value-of select="concat(($tableIndent - $cellMargin) * 2.54 div 1440.0, 'cm')" />
    </xsl:attribute>
  </xsl:template>


  <!--
  Summary:  Insert cells properties: vertical align, margins, borders  
  Author:   Clever Age
  Modified: makz (DIaLOGIKa)
  Params:   tableStyleId: The style id of the table that hosts the cell
            tcPr: The w:tcPr node of the cell
  -->
  <xsl:template name="InsertCellsProperties">
    <xsl:param name="tableStyleId" />
    <xsl:param name="tcPr" select="." />

    <!-- vertical align -->
    <xsl:call-template name="InsertCellVAlign"/>

    <!-- margins-->
    <xsl:variable name="mstyleId" select="ancestor::w:tbl[1]/w:tblPr/w:tblStyle/@w:val"/>
    
    <xsl:choose>
      <xsl:when test="key('Part', 'word/styles.xml')/w:styles/w:style[@w:styleId=$mstyleId or @w:styleId=concat('CONTENT_',$mstyleId)]">
        <xsl:variable name="mstyle" select="key('Part', 'word/styles.xml')/w:styles/w:style[@w:styleId = $mstyleId or @w:styleId = concat('CONTENT_',$mstyleId)]/w:tblPr/w:tblCellMar"/>
        <!-- margin is specified in styles.xml -->
        <xsl:call-template name="InsertCellMargins">
          <xsl:with-param name="tcMar" select="w:tcMar/w:bottom"/>
          <xsl:with-param name="tblMar" select="ancestor::w:tbl[1]/w:tblPr/w:tblCellMar/w:bottom"/>
          <xsl:with-param name="tblDefMar" select="$mstyle/w:bottom"/>
          <xsl:with-param name="attribute">fo:padding-bottom</xsl:with-param>
        </xsl:call-template>
				<!--Sart - if 'START' replaces 'LEFT'-->
				<xsl:choose>
					<xsl:when test ="ancestor::w:tbl[1]/w:tblPr/w:tblCellMar/w:start">
						<xsl:call-template name="InsertCellMargins">
							<xsl:with-param name="tcMar" select="w:tcMar/w:start"/>
							<xsl:with-param name="tblMar" select="ancestor::w:tbl[1]/w:tblPr/w:tblCellMar/w:start"/>
							<xsl:with-param name="tblDefMar" select="$mstyle/w:start"/>
							<xsl:with-param name="attribute">fo:padding-left</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
        <xsl:call-template name="InsertCellMargins">
          <xsl:with-param name="tcMar" select="w:tcMar/w:left"/>
          <xsl:with-param name="tblMar" select="ancestor::w:tbl[1]/w:tblPr/w:tblCellMar/w:left"/>
          <xsl:with-param name="tblDefMar" select="$mstyle/w:left"/>
          <xsl:with-param name="attribute">fo:padding-left</xsl:with-param>
        </xsl:call-template>
					</xsl:otherwise>
				</xsl:choose >
				<!--End  - if 'START' replaces 'LEFT'-->

				<!--Sart - if 'END' replaces 'RIGHT'-->
				<xsl:choose>
					<xsl:when test ="ancestor::w:tbl[1]/w:tblPr/w:tblCellMar/w:end">
						<xsl:call-template name="InsertCellMargins">
							<xsl:with-param name="tcMar" select="w:tcMar/w:end"/>
							<xsl:with-param name="tblMar" select="ancestor::w:tbl[1]/w:tblPr/w:tblCellMar/w:end"/>
							<xsl:with-param name="tblDefMar" select="$mstyle/w:end"/>
							<xsl:with-param name="attribute">fo:padding-right</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
        <xsl:call-template name="InsertCellMargins">
          <xsl:with-param name="tcMar" select="w:tcMar/w:right"/>
          <xsl:with-param name="tblMar" select="ancestor::w:tbl[1]/w:tblPr/w:tblCellMar/w:right"/>
          <xsl:with-param name="tblDefMar" select="$mstyle/w:right"/>
          <xsl:with-param name="attribute">fo:padding-right</xsl:with-param>
        </xsl:call-template>
					</xsl:otherwise >
				</xsl:choose >
				<!--End  - if 'END' replaces 'RIGHT'-->
        <xsl:call-template name="InsertCellMargins">
          <xsl:with-param name="tcMar" select="w:tcMar/w:top"/>
          <xsl:with-param name="tblMar" select="ancestor::w:tbl[1]/w:tblPr/w:tblCellMar/w:top"/>
          <xsl:with-param name="tblDefMar" select="$mstyle/w:top"/>
          <xsl:with-param name="attribute">fo:padding-top</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="w:tcMar or ancestor::w:tbl[1]/w:tblPr/w:tblCellMar">
        <!-- margin is specified direct in the table -->
        <xsl:call-template name="InsertCellMargins">
          <xsl:with-param name="tcMar" select="w:tcMar/w:bottom"/>
          <xsl:with-param name="tblMar" select="ancestor::w:tbl[1]/w:tblPr/w:tblCellMar/w:bottom"/>
          <xsl:with-param name="attribute">fo:padding-bottom</xsl:with-param>
        </xsl:call-template>
				<!--Sart - if 'START' replaces 'LEFT'-->
				<xsl:choose>
					<xsl:when test ="ancestor::w:tbl[1]/w:tblPr/w:tblCellMar/w:left">
						<xsl:call-template name="InsertCellMargins">
							<xsl:with-param name="tcMar" select="w:tcMar/w:start"/>
							<xsl:with-param name="tblMar" select="ancestor::w:tbl[1]/w:tblPr/w:tblCellMar/w:start"/>
							<xsl:with-param name="attribute">fo:padding-left</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
        <xsl:call-template name="InsertCellMargins">
          <xsl:with-param name="tcMar" select="w:tcMar/w:left"/>
          <xsl:with-param name="tblMar" select="ancestor::w:tbl[1]/w:tblPr/w:tblCellMar/w:left"/>
          <xsl:with-param name="attribute">fo:padding-left</xsl:with-param>
        </xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				<!--End - if 'START' replaces 'LEFT'-->

				<!--sart - if 'END' replaces 'RIGHT'-->
				<xsl:choose>
					<xsl:when test ="ancestor::w:tbl[1]/w:tblPr/w:tblCellMar/w:end">
						<xsl:call-template name="InsertCellMargins">
							<xsl:with-param name="tcMar" select="w:tcMar/w:end"/>
							<xsl:with-param name="tblMar" select="ancestor::w:tbl[1]/w:tblPr/w:tblCellMar/w:end"/>
							<xsl:with-param name="attribute">fo:padding-right</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
        <xsl:call-template name="InsertCellMargins">
          <xsl:with-param name="tcMar" select="w:tcMar/w:right"/>
          <xsl:with-param name="tblMar" select="ancestor::w:tbl[1]/w:tblPr/w:tblCellMar/w:right"/>
          <xsl:with-param name="attribute">fo:padding-right</xsl:with-param>
        </xsl:call-template>
					</xsl:otherwise>
				</xsl:choose >
				<!--end - if 'END' replaces 'RIGHT'-->

        <xsl:call-template name="InsertCellMargins">
          <xsl:with-param name="tcMar" select="w:tcMar/w:top"/>
          <xsl:with-param name="tblMar" select="ancestor::w:tbl[1]/w:tblPr/w:tblCellMar/w:top"/>
          <xsl:with-param name="attribute">fo:padding-top</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- use application dafaults (no margin specified) -->
        <xsl:attribute name="fo:padding-top">
          <xsl:text>0cm</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="fo:padding-bottom">
          <xsl:text>0cm</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="fo:padding-left">
          <xsl:text>0.19cm</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="fo:padding-right">
          <xsl:text>0.19cm</xsl:text>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>

    <!-- borders -->
    <xsl:call-template name="InsertLeftCellBorder" />
    <xsl:call-template name="InsertRightCellBorder" />
    <xsl:call-template name="InsertBottomCellBorder" />
    <xsl:call-template name="InsertTopCellBorder" />

    <!-- Background color -->
    <xsl:call-template name="InsertBackgroundColorForStyle">
      <xsl:with-param name="tcPr" select="$tcPr" />
      <xsl:with-param name="tableStyleId" select="$tableStyleId" />
    </xsl:call-template>

  </xsl:template>


  <!-- insert table cell content vertical alignment -->
  <xsl:template name="InsertCellVAlign">
    <xsl:if test="w:vAlign">
      <xsl:choose>
        <xsl:when test="w:vAlign/@w:val = 'center'">
          <xsl:attribute name="style:vertical-align">
            <xsl:value-of select="'middle'"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="style:vertical-align">
            <xsl:value-of select="w:vAlign/@w:val"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>


  <!--  insert cell margins-->
  <xsl:template name="InsertCellMargins">
    <xsl:param name="tcMar"/>
    <xsl:param name="tblMar"/>
    <xsl:param name="tblDefMar"/>
    <xsl:param name="attribute"/>
    <xsl:choose>
      <xsl:when test="$tcMar">
        <xsl:attribute name="{$attribute}">
          <xsl:value-of select="concat(($tcMar/@w:w) * 2.54 div 1440.0, 'cm')" />
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="$tblMar">
        <xsl:attribute name="{$attribute}">
          <xsl:value-of select="concat(($tblMar/@w:w) * 2.54 div 1440.0, 'cm')" />
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="$tblDefMar">
        <xsl:attribute name="{$attribute}">
          <xsl:value-of select="concat(($tblDefMar/@w:w) * 2.54 div 1440.0, 'cm')" />
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <!--
  Summary:  Inserts the background color for a table cell style
  Author:   makz (DIaLOGIKa)
  Params:   tcPr: The w:tcPr node of the cell
            tableStyleId: The style id of the table that hosts the cell
  -->
  <xsl:template name="InsertBackgroundColorForStyle">
    <xsl:param name="tcPr" />
    <xsl:param name="tableStyleId" />

    <xsl:choose>
      <xsl:when test="$tcPr/w:shd">
        <!-- use direct formatting -->
        <xsl:attribute name="fo:background-color">
          <xsl:call-template name="ComputeShading">
            <xsl:with-param name="shd" select="$tcPr/w:shd" />
          </xsl:call-template>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="key('StyleId', $tableStyleId)">
        <!-- use style -->
        <xsl:call-template name="InsertBackgroundColorForStyle">
          <xsl:with-param name="tcPr" select="key('StyleId', $tableStyleId)/w:tcPr" />
          <xsl:with-param name="tableStyleId" select="key('StyleId', $tableStyleId)/w:basedOn/@w:val" />
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>

  </xsl:template>


  <!--
  Summary:  Inserts the left border of the cell
  Author:   makz (DIaLOGIKa)
  Params:   styleId: The style id of the w:tbl to which the cell belongs
            tcBorders: The w:tcBorders element of the cell
            tblBorders: The w:tblBorders of the w:table to which the cell belongs
            contextCell: The cell itself
  -->
  <xsl:template name="InsertLeftCellBorder">
    <xsl:param name="styleId" select="ancestor::w:tbl[1]/w:tblPr/w:tblStyle/@w:val"/>
    <xsl:param name="tcBorders" select="w:tcBorders"/>
    <xsl:param name="tblBorders" select="ancestor::w:tbl[1]/w:tblPr/w:tblBorders"/>
    <xsl:param name="contextCell" select="parent::w:tc"/>

    <xsl:choose>
      <xsl:when test="$contextCell/preceding-sibling::w:tc">
        <!-- the cell is somewhere in the table -->
        <xsl:choose>
					<xsl:when test="$tcBorders/w:start">
						<!-- use the left border of the cell definition -->
						<xsl:call-template name="InsertBorderSide">
							<xsl:with-param name="side" select="$tcBorders/w:start"/>
							<xsl:with-param name="sideName" select="'left'"/>
							<xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
						</xsl:call-template>
					</xsl:when>
          <xsl:when test="$tcBorders/w:left">
            <!-- use the left border of the cell definition -->
            <xsl:call-template name="InsertBorderSide">
              <xsl:with-param name="side" select="$tcBorders/w:left"/>
              <xsl:with-param name="sideName" select="'left'"/>
              <xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$tblBorders/w:insideV">
            <!-- use the inside vertical border of the table definition -->
            <xsl:call-template name="InsertBorderSide">
              <xsl:with-param name="side" select="$tblBorders/w:insideV"/>
              <xsl:with-param name="sideName" select="'left'"/>
              <xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$styleId = 'TableGrid'">
            <!-- use the default border -->
            <xsl:call-template name="InsertDefaultCellBorder">
              <xsl:with-param name="sideName" select="'left'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="key('StyleId', $styleId) or key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val != $styleId">
            <!-- use the style -->
            <xsl:choose>
              <xsl:when test="key('StyleId', $styleId)">
                <xsl:call-template name="InsertLeftCellBorder">
                  <xsl:with-param name="contextCell" select="$contextCell"/>
                  <xsl:with-param name="styleId" select="key('StyleId', $styleId)/w:tblPr/w:tblStyle/@w:val"/>
                  <xsl:with-param name="tcBorders" select="key('StyleId', $styleId)/w:tcPr/w:tcBorders"/>
                  <xsl:with-param name="tblBorders" select="key('StyleId', $styleId)/w:tblPr/w:tblBorders"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val != $styleId">
                <xsl:call-template name="InsertLeftCellBorder">
                  <xsl:with-param name="contextCell" select="$contextCell"/>
                  <xsl:with-param name="styleId" select="key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val"/>
                  <xsl:with-param name="tcBorders" select="key('default-styles', 'table')/w:tcPr/w:tcBorders"/>
                  <xsl:with-param name="tblBorders" select="key('default-styles', 'table')/w:tblPr/w:tblBorders"/>
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- the cell is at the left border -->
        <xsl:choose>
					<xsl:when test="$tcBorders/w:start">
						<!-- use the left border of the cell definition -->
						<xsl:call-template name="InsertBorderSide">
							<xsl:with-param name="side" select="$tcBorders/w:start"/>
							<xsl:with-param name="sideName" select="'left'"/>
							<xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$tblBorders/w:start">
						<!-- use the left border of the table definition -->
						<xsl:call-template name="InsertBorderSide">
							<xsl:with-param name="side" select="$tblBorders/w:start"/>
							<xsl:with-param name="sideName" select="'left'"/>
							<xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
						</xsl:call-template>
					</xsl:when>
          <xsl:when test="$tcBorders/w:left">
            <!-- use the left border of the cell definition -->
            <xsl:call-template name="InsertBorderSide">
              <xsl:with-param name="side" select="$tcBorders/w:left"/>
              <xsl:with-param name="sideName" select="'left'"/>
              <xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$tblBorders/w:left">
            <!-- use the left border of the table definition -->
            <xsl:call-template name="InsertBorderSide">
              <xsl:with-param name="side" select="$tblBorders/w:left"/>
              <xsl:with-param name="sideName" select="'left'"/>
              <xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$styleId = 'TableGrid'">
            <!-- use the default border -->
            <xsl:call-template name="InsertDefaultCellBorder">
              <xsl:with-param name="sideName" select="'left'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="key('StyleId', $styleId) or key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val != $styleId">
            <!-- use the style -->
            <xsl:choose>
              <xsl:when test="key('StyleId', $styleId)">
                <xsl:call-template name="InsertLeftCellBorder">
                  <xsl:with-param name="contextCell" select="$contextCell"/>
                  <xsl:with-param name="styleId" select="key('StyleId', $styleId)/w:tblPr/w:tblStyle/@w:val"/>
                  <xsl:with-param name="tcBorders" select="key('StyleId', $styleId)/w:tcPr/w:tcBorders"/>
                  <xsl:with-param name="tblBorders" select="key('StyleId', $styleId)/w:tblPr/w:tblBorders"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val != $styleId">
                <xsl:call-template name="InsertLeftCellBorder">
                  <xsl:with-param name="contextCell" select="$contextCell"/>
                  <xsl:with-param name="styleId" select="key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val"/>
                  <xsl:with-param name="tcBorders" select="key('default-styles', 'table')/w:tcPr/w:tcBorders"/>
                  <xsl:with-param name="tblBorders" select="key('default-styles', 'table')/w:tblPr/w:tblBorders"/>
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--
  Summary:  Inserts the right border of the cell
  Author:   makz (DIaLOGIKa)
  Params:   styleId: The style id of the w:tbl to which the cell belongs
            tcBorders: The w:tcBorders element of the cell
            tblBorders: The w:tblBorders of the w:table to which the cell belongs
            contextCell: The cell itself
  -->
  <xsl:template name="InsertRightCellBorder">
    <xsl:param name="styleId" select="ancestor::w:tbl[1]/w:tblPr/w:tblStyle/@w:val"/>
    <xsl:param name="tcBorders" select="w:tcBorders"/>
    <xsl:param name="tblBorders" select="ancestor::w:tbl[1]/w:tblPr/w:tblBorders"/>
    <xsl:param name="contextCell" select="parent::w:tc"/>

    <xsl:choose>
      <xsl:when test="$contextCell/following-sibling::w:tc">
        <!-- the cell is somewhere in the table -->
        <xsl:choose>
					<xsl:when test="$tcBorders/w:end">
						<!-- use the right border of the cell definition -->
						<xsl:call-template name="InsertBorderSide">
							<xsl:with-param name="side" select="$tcBorders/w:end"/>
							<xsl:with-param name="sideName" select="'right'"/>
							<xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
						</xsl:call-template>
					</xsl:when>
          <xsl:when test="$tcBorders/w:right">
            <!-- use the right border of the cell definition -->
            <xsl:call-template name="InsertBorderSide">
              <xsl:with-param name="side" select="$tcBorders/w:right"/>
              <xsl:with-param name="sideName" select="'right'"/>
              <xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$tblBorders/w:insideV">
            <!-- use the inside vertical border of the table definition -->
            <xsl:call-template name="InsertBorderSide">
              <xsl:with-param name="side" select="$tblBorders/w:insideV"/>
              <xsl:with-param name="sideName" select="'right'"/>
              <xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$styleId = 'TableGrid'">
            <!-- use the default border -->
            <xsl:call-template name="InsertDefaultCellBorder">
              <xsl:with-param name="sideName" select="'right'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="key('StyleId', $styleId) or key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val != $styleId">
            <!-- use the style -->
            <xsl:choose>
              <xsl:when test="key('StyleId', $styleId)">
                <xsl:call-template name="InsertRightCellBorder">
                  <xsl:with-param name="contextCell" select="$contextCell"/>
                  <xsl:with-param name="styleId" select="key('StyleId', $styleId)/w:tblPr/w:tblStyle/@w:val"/>
                  <xsl:with-param name="tcBorders" select="key('StyleId', $styleId)/w:tcPr/w:tcBorders"/>
                  <xsl:with-param name="tblBorders" select="key('StyleId', $styleId)/w:tblPr/w:tblBorders"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val != $styleId">
                <xsl:call-template name="InsertRightCellBorder">
                  <xsl:with-param name="contextCell" select="$contextCell"/>
                  <xsl:with-param name="styleId" select="key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val"/>
                  <xsl:with-param name="tcBorders" select="key('default-styles', 'table')/w:tcPr/w:tcBorders"/>
                  <xsl:with-param name="tblBorders" select="key('default-styles', 'table')/w:tblPr/w:tblBorders"/>
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- the cell is at the right border -->
        <xsl:choose>
          <xsl:when test="$tcBorders/w:right">
            <!-- use the right border of the cell definition -->
            <xsl:call-template name="InsertBorderSide">
              <xsl:with-param name="side" select="$tcBorders/w:right"/>
              <xsl:with-param name="sideName" select="'right'"/>
              <xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$tblBorders/w:right">
            <!-- use the right border of the table definition -->
            <xsl:call-template name="InsertBorderSide">
              <xsl:with-param name="side" select="$tblBorders/w:right"/>
              <xsl:with-param name="sideName" select="'right'"/>
              <xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
            </xsl:call-template>
          </xsl:when>
					<xsl:when test="$tcBorders/w:end">
						<!-- use the right border of the cell definition -->
						<xsl:call-template name="InsertBorderSide">
							<xsl:with-param name="side" select="$tcBorders/w:end"/>
							<xsl:with-param name="sideName" select="'right'"/>
							<xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$tblBorders/w:end">
						<!-- use the right border of the table definition -->
						<xsl:call-template name="InsertBorderSide">
							<xsl:with-param name="side" select="$tblBorders/w:end"/>
							<xsl:with-param name="sideName" select="'right'"/>
							<xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
						</xsl:call-template>
					</xsl:when>
          <xsl:when test="$styleId = 'TableGrid'">
            <!-- use the default border -->
            <xsl:call-template name="InsertDefaultCellBorder">
              <xsl:with-param name="sideName" select="'right'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="key('StyleId', $styleId) or key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val != $styleId">
            <!-- use the style -->
            <xsl:choose>
              <xsl:when test="key('StyleId', $styleId)">
                <xsl:call-template name="InsertRightCellBorder">
                  <xsl:with-param name="contextCell" select="$contextCell"/>
                  <xsl:with-param name="styleId" select="key('StyleId', $styleId)/w:tblPr/w:tblStyle/@w:val"/>
                  <xsl:with-param name="tcBorders" select="key('StyleId', $styleId)/w:tcPr/w:tcBorders"/>
                  <xsl:with-param name="tblBorders" select="key('StyleId', $styleId)/w:tblPr/w:tblBorders"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val != $styleId">
                <xsl:call-template name="InsertRightCellBorder">
                  <xsl:with-param name="contextCell" select="$contextCell"/>
                  <xsl:with-param name="styleId" select="key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val"/>
                  <xsl:with-param name="tcBorders" select="key('default-styles', 'table')/w:tcPr/w:tcBorders"/>
                  <xsl:with-param name="tblBorders" select="key('default-styles', 'table')/w:tblPr/w:tblBorders"/>
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--
  Summary:  Inserts the top border of the cell
  Author:   makz (DIaLOGIKa)
  Params:   styleId: The style id of the w:tbl to which the cell belongs
            tcBorders: The w:tcBorders element of the cell
            tblBorders: The w:tblBorders of the w:table to which the cell belongs
            contextCell: The cell itself
            contextRow: The row to which the cell belongs
            contextCell: The cell itself
  -->
  <xsl:template name="InsertTopCellBorder">
    <xsl:param name="styleId" select="ancestor::w:tbl[1]/w:tblPr/w:tblStyle/@w:val"/>
    <xsl:param name="tcBorders" select="w:tcBorders"/>
    <xsl:param name="tblBorders" select="ancestor::w:tbl[1]/w:tblPr/w:tblBorders"/>
    <xsl:param name="contextCell" select="parent::w:tc"/>
    <xsl:param name="contextRow" select="ancestor::w:tr"/>

    <xsl:choose>
      <xsl:when test="$contextRow/preceding-sibling::w:tr">
        <!-- the cell is somewhere in the table -->
        <xsl:choose>
          <xsl:when test="$tcBorders/w:top">
            <!-- use the top border of the cell definition -->
            <xsl:call-template name="InsertBorderSide">
              <xsl:with-param name="side" select="$tcBorders/w:top"/>
              <xsl:with-param name="sideName" select="'top'"/>
              <xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$tblBorders/w:insideH">
            <!-- use the inside horizontal border of the table definition -->
            <xsl:call-template name="InsertBorderSide">
              <xsl:with-param name="side" select="$tblBorders/w:insideH"/>
              <xsl:with-param name="sideName" select="'top'"/>
              <xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$styleId = 'TableGrid'">
            <!-- use the default border -->
            <xsl:call-template name="InsertDefaultCellBorder">
              <xsl:with-param name="sideName" select="'top'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="key('StyleId', $styleId) or key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val != $styleId">
            <!-- use the style -->
            <xsl:choose>
              <xsl:when test="key('StyleId', $styleId)">
                <xsl:call-template name="InsertTopCellBorder">
                  <xsl:with-param name="contextRow" select="$contextRow"/>
                  <xsl:with-param name="contextCell" select="$contextCell"/>
                  <xsl:with-param name="styleId" select="key('StyleId', $styleId)/w:tblPr/w:tblStyle/@w:val"/>
                  <xsl:with-param name="tcBorders" select="key('StyleId', $styleId)/w:tcPr/w:tcBorders"/>
                  <xsl:with-param name="tblBorders" select="key('StyleId', $styleId)/w:tblPr/w:tblBorders"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val != $styleId">
                <xsl:call-template name="InsertTopCellBorder">
                  <xsl:with-param name="contextRow" select="$contextRow"/>
                  <xsl:with-param name="contextCell" select="$contextCell"/>
                  <xsl:with-param name="styleId" select="key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val"/>
                  <xsl:with-param name="tcBorders" select="key('default-styles', 'table')/w:tcPr/w:tcBorders"/>
                  <xsl:with-param name="tblBorders" select="key('default-styles', 'table')/w:tblPr/w:tblBorders"/>
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- the cell is at the top border -->
        <xsl:choose>
          <xsl:when test="$tcBorders/w:top">
            <!-- use the top border of the cell definition -->
            <xsl:call-template name="InsertBorderSide">
              <xsl:with-param name="side" select="$tcBorders/w:top"/>
              <xsl:with-param name="sideName" select="'top'"/>
              <xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$tblBorders/w:top">
            <!-- use the top border of the table definition -->
            <xsl:call-template name="InsertBorderSide">
              <xsl:with-param name="side" select="$tblBorders/w:top"/>
              <xsl:with-param name="sideName" select="'top'"/>
              <xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$styleId = 'TableGrid'">
            <!-- use the default border -->
            <xsl:call-template name="InsertDefaultCellBorder">
              <xsl:with-param name="sideName" select="'top'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="key('StyleId', $styleId) or key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val != $styleId">
            <!-- use the style -->
            <xsl:choose>
              <xsl:when test="key('StyleId', $styleId)">
                <xsl:call-template name="InsertTopCellBorder">
                  <xsl:with-param name="contextRow" select="$contextRow"/>
                  <xsl:with-param name="contextCell" select="$contextCell"/>
                  <xsl:with-param name="styleId" select="key('StyleId', $styleId)/w:tblPr/w:tblStyle/@w:val"/>
                  <xsl:with-param name="tcBorders" select="key('StyleId', $styleId)/w:tcPr/w:tcBorders"/>
                  <xsl:with-param name="tblBorders" select="key('StyleId', $styleId)/w:tblPr/w:tblBorders"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val != $styleId">
                <xsl:call-template name="InsertTopCellBorder">
                  <xsl:with-param name="contextRow" select="$contextRow"/>
                  <xsl:with-param name="contextCell" select="$contextCell"/>
                  <xsl:with-param name="styleId" select="key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val"/>
                  <xsl:with-param name="tcBorders" select="key('default-styles', 'table')/w:tcPr/w:tcBorders"/>
                  <xsl:with-param name="tblBorders" select="key('default-styles', 'table')/w:tblPr/w:tblBorders"/>
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--
  Summary:  Inserts the bottom border of the cell
  Author:   makz (DIaLOGIKa)
  Params:   styleId: The style id of the w:tbl to which the cell belongs
            tcBorders: The w:tcBorders element of the cell
            tblBorders: The w:tblBorders of the w:table to which the cell belongs
            contextCell: The cell itself
            contextRow: The row to which the cell belongs
  -->
  <xsl:template name="InsertBottomCellBorder">
    <xsl:param name="styleId" select="ancestor::w:tbl[1]/w:tblPr/w:tblStyle/@w:val"/>
    <xsl:param name="tcBorders" select="w:tcBorders"/>
    <xsl:param name="tblBorders" select="ancestor::w:tbl[1]/w:tblPr/w:tblBorders"/>
    <xsl:param name="contextCell" select="parent::w:tc"/>
    <xsl:param name="contextRow" select="ancestor::w:tr"/>

    <xsl:variable name="cellPos" select="count($contextCell/preceding-sibling::*) + 1"  />
    <xsl:variable name="isMerged" select="$contextRow/following-sibling::w:tr[1]/w:tc[$cellPos]/w:tcPr/w:vMerge"/>

    <xsl:choose>
      <xsl:when test="$contextRow/following-sibling::w:tr and not($isMerged)">
        <!-- the cell is somewhere in the table -->
        <xsl:choose>
          <xsl:when test="$tcBorders/w:bottom">
            <!-- use the bottom border of the cell definition -->
            <xsl:call-template name="InsertBorderSide">
              <xsl:with-param name="side" select="$tcBorders/w:bottom"/>
              <xsl:with-param name="sideName" select="'bottom'"/>
              <xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$tblBorders/w:insideH">
            <!-- use the inside horizontal border of the table definition -->
            <xsl:call-template name="InsertBorderSide">
              <xsl:with-param name="side" select="$tblBorders/w:insideH"/>
              <xsl:with-param name="sidename" select="'bottom'"/>
              <xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$styleId = 'TableGrid'">
            <!-- use the default border -->
            <xsl:call-template name="InsertDefaultCellBorder">
              <xsl:with-param name="sideName" select="'bottom'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="key('StyleId', $styleId) or key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val != $styleId">
            <!-- use the style -->
            <xsl:choose>
              <xsl:when test="key('StyleId', $styleId)">
                <xsl:call-template name="InsertBottomCellBorder">
                  <xsl:with-param name="contextRow" select="$contextRow"/>
                  <xsl:with-param name="contextCell" select="$contextCell"/>
                  <xsl:with-param name="styleId" select="key('StyleId', $styleId)/w:tblPr/w:tblStyle/@w:val"/>
                  <xsl:with-param name="tcBorders" select="key('StyleId', $styleId)/w:tcPr/w:tcBorders"/>
                  <xsl:with-param name="tblBorders" select="key('StyleId', $styleId)/w:tblPr/w:tblBorders"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val != $styleId">
                <xsl:call-template name="InsertBottomCellBorder">
                  <xsl:with-param name="contextRow" select="$contextRow"/>
                  <xsl:with-param name="contextCell" select="$contextCell"/>
                  <xsl:with-param name="styleId" select="key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val"/>
                  <xsl:with-param name="tcBorders" select="key('default-styles', 'table')/w:tcPr/w:tcBorders"/>
                  <xsl:with-param name="tblBorders" select="key('default-styles', 'table')/w:tblPr/w:tblBorders"/>
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- the cell is at the bottom border -->
        <xsl:choose>
          <xsl:when test="$tcBorders/w:bottom">
            <!-- use the bottom border of the cell definition -->
            <xsl:call-template name="InsertBorderSide">
              <xsl:with-param name="side" select="$tcBorders/w:bottom"/>
              <xsl:with-param name="sideName" select="'bottom'"/>
              <xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$tblBorders/w:bottom">
            <!-- use the bottom border of the table definition -->
            <xsl:call-template name="InsertBorderSide">
              <xsl:with-param name="side" select="$tblBorders/w:bottom"/>
              <xsl:with-param name="sideName" select="'bottom'"/>
              <xsl:with-param name="emulateOpenOfficeTableBorders" select="'true'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$styleId = 'TableGrid'">
            <!-- use the default border -->
            <xsl:call-template name="InsertDefaultCellBorder">
              <xsl:with-param name="sideName" select="'bottom'" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="key('StyleId', $styleId) or key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val != $styleId">
            <!-- use the style -->
            <xsl:choose>
              <xsl:when test="key('StyleId', $styleId)">
                <xsl:call-template name="InsertBottomCellBorder">
                  <xsl:with-param name="contextRow" select="$contextRow"/>
                  <xsl:with-param name="contextCell" select="$contextCell"/>
                  <xsl:with-param name="styleId" select="key('StyleId', $styleId)/w:tblPr/w:tblStyle/@w:val"/>
                  <xsl:with-param name="tcBorders" select="key('StyleId', $styleId)/w:tcPr/w:tcBorders"/>
                  <xsl:with-param name="tblBorders" select="key('StyleId', $styleId)/w:tblPr/w:tblBorders"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val != $styleId">
                <xsl:call-template name="InsertBottomCellBorder">
                  <xsl:with-param name="contextRow" select="$contextRow"/>
                  <xsl:with-param name="contextCell" select="$contextCell"/>
                  <xsl:with-param name="styleId" select="key('default-styles', 'table')/w:tblPr/w:tblStyle/@w:val"/>
                  <xsl:with-param name="tcBorders" select="key('default-styles', 'table')/w:tcPr/w:tcBorders"/>
                  <xsl:with-param name="tblBorders" select="key('default-styles', 'table')/w:tblPr/w:tblBorders"/>
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--  
  Summary:  Insert default cell borders
  Author:   makz (DIaLOGIKa)
  Params:   sideName: The side at which the border shall be inserted
  -->
  <xsl:template name="InsertDefaultCellBorder">
    <xsl:param name="sideName"/>

    <xsl:attribute name="{concat('fo:border-', $sideName)}">
      <xsl:text>0.002cm solid #000000</xsl:text>
    </xsl:attribute>
  </xsl:template>


  <!--  insert row properties: height-->
  <xsl:template name="InsertRowProperties">
    <xsl:choose>
      <xsl:when test="w:trHeight/@w:hRule='exact'">
        <xsl:attribute name="style:row-height">
          <xsl:value-of select="concat((w:trHeight/@w:val) * 2.54 div 1440.0, 'cm')" />
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="style:min-row-height">
          <xsl:value-of select="concat((w:trHeight/@w:val) * 2.54 div 1440.0, 'cm')" />
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:attribute name="style:keep-together">
      <xsl:choose>
        <xsl:when test="w:cantSplit">
          <xsl:text>false</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>true</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>


  <!--
  Summary:  Computes the total width of a table grid
  Author:   makz (DIaLOGIKa)
  Params:   grid: The w:tblGrid node
  -->
  <xsl:template name="ComputeGridWidth">
    <xsl:param name="grid" />
    <xsl:param name="width" select="0" />
    <xsl:param name="iterator" select="1" />

    <xsl:choose>
      <xsl:when test="$iterator &lt;= count($grid/w:gridCol)">
        <xsl:call-template name="ComputeGridWidth">
          <xsl:with-param name="grid" select="$grid" />
          <xsl:with-param name="iterator" select="$iterator + 1"/>
          <xsl:with-param name="width" select="$width + $grid/w:gridCol[number($iterator)]/@w:w"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$width"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--
  Summary:  Returns the left margin of the first cell as dxa value
  Author:   makz (DIaLOGIKa)
  Params:   tblPr: The w:tblPr node of the table
            styleName: The name of the style thta should be used
  -->
  <xsl:template name="GetLeftCellMargin">
    <xsl:param name="tblPr" />
    <xsl:param name="styleName" />

    <xsl:choose>
			<xsl:when test="$tblPr/w:tblCellMar/w:start and $tblPr/w:tblCellMar/w:start/@w:type='dxa'">
				<!-- Direct Formatting -->
				<xsl:value-of select="$tblPr/w:tblCellMar/w:start/@w:w"/>
			</xsl:when>
      <xsl:when test="$tblPr/w:tblCellMar/w:left and $tblPr/w:tblCellMar/w:left/@w:type='dxa'">
        <!-- Direct Formatting -->
        <xsl:value-of select="$tblPr/w:tblCellMar/w:left/@w:w"/>
      </xsl:when>
      <xsl:when test="$styleName != ''">
        <!-- The table has a style, try to find in style -->
        <xsl:variable name="style" select="key('StyleId', $styleName)" />
        <xsl:call-template name="GetLeftCellMargin">
          <xsl:with-param name="tblPr" select="$style/w:tblPr"/>
          <xsl:with-param name="styleName" select="$style/w:basedOn/@w:val" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="key('StyleId', 'TableNormal')">
        <!-- Use the TableNormal Style -->
        <xsl:variable name="style" select="key('StyleId', 'TableNormal')" />
        <xsl:call-template name="GetLeftCellMargin">
          <xsl:with-param name="tblPr" select="$style/w:tblPr"/>
          <xsl:with-param name="styleName" select="$style/w:basedOn/@w:val or $style/w:name/@w:val" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>0</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--
  Summary:  Returns the left padding of the first cell in dxa
  Author:   makz (DIaLOGIKa)
  Params:   tblPr: The w:tblPr node of the table
            styleName: The name of the style that should be used
  -->
  <xsl:template name="GetTableIndent">
    <xsl:param name="tblPr" />
    <xsl:param name="styleName" />

    <xsl:choose>
      <xsl:when test="$tblPr and $tblPr/w:tblInd and $tblPr/w:tblInd/@w:type='dxa'">
        <!--  iThere is direct formatting -->
        <xsl:value-of select="$tblPr/w:tblInd/@w:w"/>
      </xsl:when>
      <xsl:when test="$styleName != ''">
        <!-- the table has a style, try to find in style -->
        <xsl:variable name="style" select="key('StyleId', $styleName)" />
        <xsl:call-template name="GetTableIndent">
          <xsl:with-param name="tblPr" select="$style/w:tblPr"/>
          <xsl:with-param name="styleName" select="$style/w:basedOn/@w:val" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$tblPr and key('StyleId', 'TableNormal')">
        <!-- Use the TableNormal Style -->
        <xsl:variable name="style" select="key('StyleId', 'TableNormal')" />
        <xsl:call-template name="GetTableIndent">
          <xsl:with-param name="tblPr" select="$style/w:tblPr"/>
          <xsl:with-param name="styleName" select="$style/w:basedOn/@w:val  or $style/w:name/@w:val" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>0</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
