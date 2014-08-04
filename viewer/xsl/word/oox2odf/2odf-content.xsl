<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  * Copyright (c) 2006-2008 Clever Age
  * Copyright (c) 2006-2009 DIaLOGIKa
  *
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
  *     * Neither the names of copyright holders, nor the names of its contributors 
  *       may be used to endorse or promote products derived from this software 
  *       without specific prior written permission.
  * 
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
  * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
  * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
  * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
  * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
  * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
  * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
  * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF 
  * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
  -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:pchar="urn:cleverage:xmlns:post-processings:characters"
  xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
  xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
  xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
  xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
  xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
  xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
  xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
  xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
  xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
  xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships"
  xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
  xmlns:pcut="urn:cleverage:xmlns:post-processings:pcut"
  xmlns:v="urn:schemas-microsoft-com:vml"
  xmlns:o="urn:schemas-microsoft-com:office:office"
  xmlns:oox="urn:oox"
  exclude-result-prefixes="w r rels pchar wp v o oox">

  <xsl:import href="2odf-tables.xsl" />
  <xsl:import href="2odf-lists.xsl" />
  <xsl:import href="2odf-fonts.xsl" />
  <xsl:import href="2odf-fields.xsl" />
  <xsl:import href="2odf-footnotes.xsl" />
  <xsl:import href="2odf-indexes.xsl" />
  <xsl:import href="2odf-track.xsl" />
  <xsl:import href="2odf-frames.xsl" />
  <xsl:import href="2odf-sections.xsl" />

  <xsl:strip-space elements="*" />
  <!--<xsl:preserve-space elements="w:p" />
  <xsl:preserve-space elements="w:r" />-->

  <xsl:key name="InstrText" match="w:instrText" use="''" />
  <xsl:key name="bookmarkStart" match="w:bookmarkStart" use="@w:id" />
  <xsl:key name="bookmarksByName" match="w:bookmarkStart" use="@w:name" />
  <xsl:key name="numPr" match="w:pPr/w:numPr" use="''" />

  <xsl:key name="p" match="w:p" use="@oox:id" />
  <xsl:key name="sectPr" match="w:sectPr" use="@oox:s" />

  <!--main document-->
  <xsl:template name="content">
    <office:document-content>
      <office:scripts />
      <office:font-face-decls>
        <xsl:apply-templates select="key('Part', 'word/fontTable.xml')/w:fonts" />
      </office:font-face-decls>
      <office:automatic-styles>
        <!-- automatic styles for document body -->
        <xsl:call-template name="InsertBodyStyles" />
        <xsl:call-template name="InsertListStyles" />
        <xsl:call-template name="InsertSectionsStyles" />
        <xsl:call-template name="InsertFootnoteStyles" />
        <xsl:call-template name="InsertEndnoteStyles" />
        <xsl:call-template name="InsertFrameStyles" />
        <!--
					makz: paragraph style for additional paragraph that should not be visible
				-->
        <style:style style:name="{concat('ooc-NCNameFromString', '-oop-', 'HiddenParagraph', '-ooe')}" style:family="paragraph" style:parent-style-name="Standard">
          <style:text-properties fo:font-size="2pt" style:font-size-asian="2pt" style:font-size-complex="2pt" />
        </style:style>
      </office:automatic-styles>
      <office:body>
        <office:text>
          <xsl:for-each select="key('PartsByType', 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument')">
            <xsl:call-template name="TrackChanges" />
          </xsl:for-each>
          <xsl:call-template name="InsertUserFieldDecls" />
          <xsl:call-template name="InsertDocumentBody" />
        </office:text>
      </office:body>
    </office:document-content>
  </xsl:template>

  <!--  generates automatic styles for frames -->
  <xsl:template name="InsertFrameStyles">
    <!-- when w:pict is child of paragraph-->
    <!--<xsl:if test="key('Part', 'word/document.xml')/w:document/w:body/w:p/w:r/w:pict">
			<xsl:apply-templates select="key('Part', 'word/document.xml')/w:document/w:body/w:p/w:r/w:pict" mode="automaticpict" />
		</xsl:if>-->

    <!-- when w:pict is child of a cell-->
    <!--<xsl:if test="key('Part', 'word/document.xml')/w:document/w:body/w:tbl/w:tr/w:tc/w:p/w:r/w:pict">
			<xsl:apply-templates select="key('Part', 'word/document.xml')/w:document/w:body/w:tbl/w:tr/w:tc/w:p/w:r/w:pict" mode="automaticpict" />
		</xsl:if>-->
    <!-- 2008-10-31/divo: Generate a style for every w:pict, not only the ones in tables and paragraphs -->
    <xsl:apply-templates select="key('Part', 'word/document.xml')/w:document/w:body//w:pict" mode="automaticpict" />
  </xsl:template>

  <!--
		Summary: Insert the declarations of all SET fields
		Author: makz (DIaLOGIKa)
		Date: 2.11.2007
	-->
  <xsl:template name="InsertUserFieldDecls">
    <text:user-field-decls>
      <xsl:apply-templates select="key('Part', 'word/document.xml')/w:document/w:body//w:instrText" mode="UserFieldDecls" />
    </text:user-field-decls>
  </xsl:template>

  <!-- generates automatic styles for sections-->
  <xsl:template name="InsertSectionsStyles">
    <xsl:if test="key('Part', 'word/document.xml')/w:document/w:body/w:p/w:pPr/w:sectPr">
      <xsl:apply-templates select="key('Part', 'word/document.xml')/w:document/w:body/w:p/w:pPr/w:sectPr" mode="automaticstyles" />
    </xsl:if>
  </xsl:template>

  <!--  generates automatic styles for paragraphs  how does it exactly work ?? -->
  <xsl:template name="InsertBodyStyles">
    <xsl:apply-templates select="key('Part', 'word/document.xml')/w:document/w:body" mode="automaticstyles" />
  </xsl:template>

  <xsl:template name="InsertListStyles">
    <!-- document with lists-->
    <xsl:for-each select="key('Part', 'word/document.xml')">
      <xsl:choose>
        <xsl:when test="key('numPr', '')/w:numId">
          <!-- automatic list styles with empty num format for elements which has non-existent w:num attached -->
          <xsl:apply-templates select="key('numPr', '')/w:numId[not(key('Part', 'word/numbering.xml')/w:numbering/w:num/@w:numId = @w:val)][1]" mode="automaticstyles" />
          <!-- automatic list styles-->
          <xsl:apply-templates select="key('Part', 'word/numbering.xml')/w:numbering/w:num" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="key('Part', 'word/styles.xml')">
            <xsl:if test="key('numPr', '')/w:numId">
              <!-- automatic list styles-->
              <xsl:apply-templates select="key('Part', 'word/numbering.xml')/w:numbering/w:num" />
            </xsl:if>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="InsertFootnoteStyles">
    <xsl:if test="key('Part', 'word/footnotes.xml')/w:footnotes/w:footnote/w:p/w:r/w:rPr | 
				          key('Part', 'word/footnotes.xml')/w:footnotes/w:footnote/w:p/w:pPr">
      <xsl:apply-templates select="key('Part', 'word/footnotes.xml')/w:footnotes/w:footnote/w:p" mode="automaticstyles" />
    </xsl:if>
  </xsl:template>

  <xsl:template name="InsertEndnoteStyles">
    <xsl:if test="key('Part', 'word/endnotes.xml')/w:endnotes/w:endnote/w:p/w:r/w:rPr | 
				          key('Part', 'word/endnotes.xml')/w:endnotes/w:endnote/w:p/w:pPr">
      <xsl:apply-templates select="key('Part', 'word/endnotes.xml')/w:endnotes/w:endnote/w:p" mode="automaticstyles" />
    </xsl:if>
  </xsl:template>

  <!--  when paragraph has no parent style it should be set to Normal style which contains all default paragraph properties -->
  <xsl:template name="InsertParagraphParentStyleNameAttribute">
    <xsl:variable name="parentStyleId">
      <xsl:choose>
        <xsl:when test="w:pStyle">

          <xsl:variable name="isDefaultTOCStyle">
            <xsl:call-template name="CheckDefaultTOCStyle">
              <xsl:with-param name="name" select="w:pStyle/@w:val" />
            </xsl:call-template>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="$isDefaultTOCStyle='true'">
              <xsl:value-of select="concat('Contents ',substring-after(w:pStyle/@w:val,'TOC'))" />
            </xsl:when>
            <!--<xsl:when test="w:pStyle/@w:val='FootnoteText'">
              <xsl:value-of select="'Footnote Symbol'" />
            </xsl:when>-->
            <xsl:otherwise>
              <xsl:value-of select="w:pStyle/@w:val" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="key('Part', 'word/styles.xml')/w:styles/w:style[@w:type='paragraph' and @w:default='1']">
          <!-- if no style is referenced use the last paragraph style which has the w:default attribute set (see p692 OpenXML spec) -->
          <xsl:value-of select="key('Part', 'word/styles.xml')/w:styles/w:style[@w:type='paragraph' and @w:default='1'][last()]/@w:styleId" />
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$parentStyleId != ''">
      <xsl:attribute name="style:parent-style-name">
        <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', $parentStyleId, '-ooe')" />
      </xsl:attribute>
    </xsl:if>
  </xsl:template>


  <!--
	  Summary:  Converts the child elements of the body and handels the section conversion
	  Author:   CleverAge
	  Modified: makz (DIaLOGIKa)
	-->
  <xsl:template name="InsertDocumentBody">
    <xsl:choose>
      <xsl:when test="key('Part', 'word/document.xml')/w:document/w:body/w:p/w:pPr/w:sectPr" >
        <!--
					There is more than the default sectPr, we need to write an own section for each sectPr.
				-->
        <xsl:apply-templates select="key('Part', 'word/document.xml')/w:document/w:body//w:sectPr" mode="sections" />
      </xsl:when>
      <xsl:otherwise>
        <!--
				  There is only the default section, so we convert the child nodes directly. 
				  The properties of the default sectPr are applied tho the "Standard" master page
				-->
        <xsl:apply-templates select="key('Part', 'word/document.xml')/w:document/w:body/child::node()" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- create a style for each paragraph. Do not take w:sectPr/w:rPr into consideration. -->
  <xsl:template
	  match="w:pPr[parent::w:p]|w:r[parent::w:p[not(child::w:pPr)] and (child::w:br[@w:type='page' or @w:type='column'] or contains(child::w:pict/v:shape/@style,'mso-position-horizontal-relative:char'))]"
	  mode="automaticstyles">
    <xsl:message terminate="no">progress:w:pPr</xsl:message>
    <style:style style:name="{generate-id(parent::w:p)}" style:family="paragraph">
      <xsl:call-template name="InsertParagraphParentStyleNameAttribute" />
      <xsl:call-template name="InsertMasterPageNameAttribute" />

      <style:paragraph-properties>
        <xsl:for-each select="parent::w:p">
          <!--context switch -->
          <xsl:call-template name="InsertPageNumberOffset" />
        </xsl:for-each>

        <xsl:call-template name="InsertDefaultTabStop" />
        <xsl:call-template name="InsertParagraphProperties" />
      </style:paragraph-properties>
      <!-- add text-properties to empty paragraphs. -->
      <!--clam, dialogika: bugfix 1752761-->
      <xsl:if test="parent::w:p[count(child::node()) = 1]/w:pPr/w:rPr or w:rPr/w:vanish">
        <style:text-properties>
          <xsl:call-template name="InsertTextProperties" />
        </style:text-properties>
      </xsl:if>
    </style:style>
  </xsl:template>

  <xsl:template
	  match="w:p[not(./w:pPr) and not(w:r/w:br[@w:type='page' or @w:type='column']) and not(descendant::w:pict)]"
	  mode="automaticstyles">
    <xsl:if test="key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:pPrDefault">
      <style:style style:name="{generate-id(.)}" style:family="paragraph">
        <xsl:call-template name="InsertParagraphParentStyleNameAttribute" />
        <xsl:call-template name="InsertMasterPageNameAttribute" />
        <xsl:call-template name="InsertDefaultParagraphProperties" />
      </style:style>
    </xsl:if>
    <xsl:apply-templates mode="automaticstyles" />
  </xsl:template>

  <!-- create a style for each run. Do not take w:pPr/w:rPr into consideration. Ignore runs with no properties. -->
  <xsl:template match="w:rPr[parent::w:r and not(count(child::node())=1 and child::w:noProof)]"
	  mode="automaticstyles">
    <xsl:message terminate="no">progress:w:rPr</xsl:message>
    <style:style style:name="{generate-id(parent::w:r)}" style:family="text">
      <xsl:if test="w:rStyle">
        <xsl:attribute name="style:parent-style-name">
          <!--clam bugfix #1806204-->
          <xsl:choose>
            <xsl:when test="ancestor::w:r[contains(w:instrText,'TOC')] and w:rStyle/@w:val='Hyperlink'">X3AS7TOCHyperlink</xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', w:rStyle/@w:val, '-ooe')" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <style:text-properties>
        <xsl:call-template name="InsertTextProperties" />
      </style:text-properties>
    </style:style>
  </xsl:template>

  <!-- ignore text in automatic styles mode. -->
  <xsl:template match="w:t" mode="automaticstyles" />

  <!--  get outline level from styles hierarchy -->
  <xsl:template name="GetOutlineLevelByStyleId">
    <xsl:param name="styleId" />

    <xsl:choose>
      <xsl:when test="key('StyleId', $styleId)[1]/w:pPr/w:outlineLvl/@w:val">
        <xsl:value-of select="key('StyleId', $styleId)[1]/w:pPr/w:outlineLvl/@w:val" />
      </xsl:when>
      <!--  Search outlineLvl recursively in style hierarchy -->
      <xsl:when test="key('StyleId', $styleId)[1]/w:basedOn/@w:val">
        <xsl:call-template name="GetOutlineLevelByStyleId">
          <xsl:with-param name="styleId">
            <xsl:value-of select="key('StyleId', $styleId)[1]/w:basedOn/@w:val" />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="GetOutlineLevel">
    <xsl:param name="node" select="." />

    <xsl:variable name="outlineLevel">
      <xsl:choose>
        <xsl:when test="$node/w:pPr/w:pStyle/@w:val">
          <xsl:call-template name="GetOutlineLevelByStyleId">
            <xsl:with-param name="styleId" select="$node/w:pPr/w:pStyle/@w:val" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <!--if outlineLvl is not defined search in parent style by w:link-->
          <xsl:call-template name="GetOutlineLevelByStyleId">
            <xsl:with-param name="styleId" select="key('StyleId', $node/w:r/w:rPr/w:rStyle/@w:val)[1]/w:link/@w:val" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="isDefaultHeading">
      <xsl:call-template name="CheckDefaultHeading">
        <xsl:with-param name="Name" select="key('StyleId',$node/w:pPr/w:pStyle/@w:val)/w:name/@w:val" />
      </xsl:call-template>
    </xsl:variable>

    <!-- a value of 9 means body text, i.e. it is equivalent to no outline level set -->
    <xsl:if test="not($outlineLevel = '' or $outlineLevel = '9') and $isDefaultHeading='true'">
      <xsl:value-of select="$outlineLevel" />
    </xsl:if>

  </xsl:template>


  <!--math, dialogika: added for bugfix #1802258 BEGIN -->
  <!--Checks recursively whether given style is default heading (must start with Counter = 1)-->
  <xsl:template name="CheckDefaultHeading">
    <xsl:param name="Name" />
    <xsl:param name="Counter" select="1" />

    <xsl:choose>
      <xsl:when test="$Counter &gt; 9" >false</xsl:when>
      <xsl:when test="concat('heading ',$Counter) = $Name">true</xsl:when>
      <!--math, dialogika: added for bugfix #1792424 BEGIN -->
      <xsl:when test="concat('Heading ',$Counter) = $Name">true</xsl:when>
      <!--math, dialogika: added for bugfix #1792424 END -->
      <xsl:otherwise>
        <xsl:call-template name="CheckDefaultHeading">
          <xsl:with-param name="Name" select="$Name" />
          <xsl:with-param name="Counter">
            <xsl:value-of select="$Counter + 1" />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--math, dialogika: added for bugfix #1802258 END -->


  <!-- This templates checks several properties of the current paragraphs and then decides whether to create
		a paragraphs, lists or headings by calling apply-templates in mode paragraph, heading or list -->
  <xsl:template match="w:p">
    <xsl:message terminate="no">progress:w:p</xsl:message>

    <xsl:variable name="outlineLevel">
      <xsl:call-template name="GetOutlineLevel">
        <xsl:with-param name="node" select="." />
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="numId">
      <xsl:call-template name="GetListProperty">
        <xsl:with-param name="node" select="." />
        <xsl:with-param name="property">w:numId</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="ilvl">
      <xsl:call-template name="GetListProperty">
        <xsl:with-param name="node" select="." />
        <xsl:with-param name="property">w:ilvl</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="styleId" select="w:pPr/w:pStyle/@w:val" />

    <!--math, dialogika: added for bugfix #1802258 BEGIN -->
    <xsl:variable name="IsDefaultHeading">
      <xsl:call-template name="CheckDefaultHeading">
        <xsl:with-param name="Name">
          <xsl:value-of select="key('StyleId',$styleId)/w:name/@w:val" />
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <!--math, dialogika: added for bugfix #1802258 END -->


    <!--Only show message if list style numbering inherited from default heading is destroyed-->
    <xsl:if test="$outlineLevel != '' and $IsDefaultHeading != 'true'">

      <xsl:variable name="isParentDefaultHeading">
        <xsl:call-template name="CheckDefaultHeading">
          <xsl:with-param name="Name" select="key('StyleId',key('StyleId',$styleId)/w:basedOn/@w:val)/w:name/@w:val" />
        </xsl:call-template>
      </xsl:variable>

      <xsl:if test="$isParentDefaultHeading = 'true'">
        <xsl:message terminate="no">translation.oox2odf.lists.numbering</xsl:message>
      </xsl:if>
    </xsl:if>
    <xsl:choose>
      <!--check if the paragraph starts a table-of content or Bibliography or Alphabetical Index -->
      <xsl:when test="w:r[contains(w:instrText,'TOC') or contains(w:instrText,'BIBLIOGRAPHY') or contains(w:instrText, 'INDEX' )]">
        <xsl:apply-templates select="." mode="tocstart" />
      </xsl:when>
      <xsl:when test="@oox:index and not(w:r[@oox:f = 1]/w:fldChar[@w:fldCharType = 'end'])">
        <!-- Ignore all paragraphs inside an index. The translation of such paragraphs is triggered by the first paragraph in the index -->
        <!-- Fix #2689877: Do not ignore the last paragraph if it contains the end of the TOC -->
      </xsl:when>

		<xsl:when test="@oox:index and (not(w:r[1]/w:fldChar[@w:fldCharType='end']) 
						or w:r[w:fldChar[@w:fldCharType='end']]/preceding-sibling::*[.//w:t])">
			<!-- Ignore all paragraphs inside an index. The translation of such paragraphs is triggered by the first paragraph in the index -->
			        <!-- Fix #2689877: Do not ignore the last paragraph if it contains the end of the TOC -->
			        <!-- Fix #2689877: 
               Do not ignore the last paragraph if it contains the end of the TOC 
                (This can be an empty paragraph or a paragraph with content following the TOC in Word)
              Ignore it if it contains the end of the TOC and there is still text (.//w:t) before the end of the TOC 
            -->
		</xsl:when>
		
      <!-- ignore paragraph if it's deleted in change tracking mode-->
      <!--<xsl:when test="key('p', number(@oox:id)-1)/w:pPr/w:rPr/w:del" />-->

      <!--  check if the paragraph is a list element (it can be a heading but only if it's style is NOT linked to a list level 
				- for linked heading styles there's oultine list style created and they can't be in list (see bug  #1619448)) -->

      <!--math, dialogika: bugfix #1947995 BEGIN
				It seems that outline numbering is only created for heading styles which have a numId defined in styles.xml.
				These headings should not be put into a text:list element and used with the next case (xsl:apply-templates select="." mode="heading")-->
      <!--<xsl:when test="not($outlineLevel != '' and $IsDefaultHeading='true' and key('StyleId',$styleId)/w:pPr/w:numPr/w:numId) 
							and $numId != '' and $ilvl &lt; 10 and key('numId', $numId)/w:abstractNumId/@w:val != ''">-->

      <!--<xsl:when
			      test="not($outlineLevel != '' and not(w:pPr/w:numPr) and $ifNormal='true' and contains($styleId,'Heading')) and $numId != '' and $ilvl &lt; 10 and key('numId', $numId)/w:abstractNumId/@w:val != ''">-->

      <!--math, dialogika: bugfix #1947995 END-->

      <!--xsl:when
						test="$numId != '' and $ilvl &lt; 10 and key('Part', 'word/numbering.xml')/w:numbering/w:num[@w:numId=$numId]/w:abstractNumId/@w:val != '' 
						and not(key('Part', 'word/styles.xml')/w:styles/w:style[@w:styleId = $styleId and child::w:pPr/w:outlineLvl and child::w:pPr/w:numPr/w:numId])"-->

      <!-- divo/20081009: check that we are 
					- in a list
					- maximum at level 9 (OOo does not support more than 10 list levels)
					- and there is a numbering definition for the numId
			-->
      <xsl:when test="$numId != '' and $ilvl &lt; 10 and key('numId', $numId)">

        <xsl:apply-templates select="." mode="list">
          <xsl:with-param name="numId" select="$numId" />
          <xsl:with-param name="ilvl" select="$ilvl" />
        </xsl:apply-templates>

      </xsl:when>

      <!--math, dialogika: changed for bugfix #1802258 -->
      <!--check if the paragraph is a heading, only "default headings" are converted to text:h, 
				otherwise a regular text:p will be generated 
			-->
      <xsl:when test="$outlineLevel != '' and $IsDefaultHeading='true'">
        <xsl:apply-templates select="." mode="heading">
          <xsl:with-param name="outlineLevel" select="$outlineLevel" />
        </xsl:apply-templates>
      </xsl:when>

      <!--  default scenario - paragraph-->
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="paragraph" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--paragraph with outline level is a heading-->
  <xsl:template match="w:p" mode="heading">
    <xsl:param name="outlineLevel" />
    <xsl:variable name="numId">
      <xsl:call-template name="GetListProperty">
        <xsl:with-param name="node" select="." />
        <xsl:with-param name="property">w:numId</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <!-- NOTE: If the paragraph mark of the previous paragraph shall be treated as deleted 
               we will skip this paragraph. This paragraph has been already translated together 
               with the previous paragraph -->
    <xsl:if test="not(key('p', number(@oox:id)-1)/w:pPr/w:rPr/w:del)">
      <xsl:choose>
        <xsl:when test="ancestor::w:txbxContent">
          <text:p>
            <!--style name-->
            <xsl:if test="w:pPr or w:r/w:br[@w:type='page' or @w:type='column']">
              <xsl:attribute name="text:style-name">
                <xsl:value-of select="generate-id(self::node())" />
              </xsl:attribute>
            </xsl:if>
            <!--header outline level -->
            <!-- Fix: outline level is invalid for text:p -->
            <!--<xsl:call-template name="InsertHeadingOutlineLvl">
            <xsl:with-param name="outlineLevel" select="$outlineLevel" />
          </xsl:call-template>-->
            <!-- unnumbered heading is list header  -->
            <!-- Fix: text:is-list-header is invalid for text:p -->
            <!--<xsl:call-template name="InsertHeadingAsListHeader" />-->
            <!--change track end-->
            <xsl:if test="key('p', number(@oox:id)-1)/w:pPr/w:rPr/w:ins and $numId!=''">
              <text:change-end text:change-id="{generate-id(key('p', number(@oox:id)-1))}" />
            </xsl:if>
            <xsl:apply-templates />
            <xsl:if test="w:pPr/w:rPr/w:del">
              <!-- if this following paragraph is attached to this one in track changes mode-->
              <xsl:call-template name="InsertDeletedParagraph" />
            </xsl:if>
            <xsl:if test="w:pPr/w:rPr/w:ins">
              <text:change-start text:change-id="{generate-id(self::node())}" />
            </xsl:if>
          </text:p>
        </xsl:when>
        <xsl:otherwise>
          <text:h>
            <!--style name-->
            <xsl:if test="w:pPr or w:r/w:br[@w:type='page' or @w:type='column']">
              <xsl:attribute name="text:style-name">
                <xsl:value-of select="generate-id(self::node())" />
              </xsl:attribute>
            </xsl:if>

            <!--clam, dialogika: bugfix #2088822-->
            <xsl:variable name="myNum" select="key('Part', 'word/numbering.xml')/w:numbering/w:num[@w:numId = $numId]"></xsl:variable>

            <xsl:if test="$myNum/w:lvlOverride[@w:ilvl=$outlineLevel]/w:startOverride">
              <xsl:attribute name="text:restart-numbering">true</xsl:attribute>
              <xsl:attribute name="text:start-value">
                <xsl:value-of select="$myNum/w:lvlOverride[@w:ilvl=$outlineLevel]/w:startOverride/@w:val" />
              </xsl:attribute>
            </xsl:if>

            <!-- header outline level -->
            <xsl:call-template name="InsertHeadingOutlineLvl">
              <xsl:with-param name="outlineLevel" select="$outlineLevel" />
            </xsl:call-template>
            <!-- unnumbered heading is list header  -->
            <xsl:call-template name="InsertHeadingAsListHeader" />
            <!-- change track end-->
            <xsl:if test="key('p', number(@oox:id)-1)/w:pPr/w:rPr/w:ins and $numId!=''">
              <text:change-end text:change-id="{generate-id(key('p', number(@oox:id)-1))}" />
            </xsl:if>
            <xsl:apply-templates />
            <xsl:if test="w:pPr/w:rPr/w:del">
              <!-- if this following paragraph is attached to this one in track changes mode -->
              <xsl:call-template name="InsertDeletedParagraph" />
            </xsl:if>
            <xsl:if test="w:pPr/w:rPr/w:ins">
              <text:change-start text:change-id="{generate-id(self::node())}" />
            </xsl:if>

          </text:h>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:if test="w:pPr/w:rPr/w:ins and $numId=''">
      <text:change-end text:change-id="{generate-id(self::node())}" />
    </xsl:if>
  </xsl:template>

  <xsl:template name="InsertDeletedParagraph">
    <text:change text:change-id="{generate-id(w:pPr/w:rPr)}" />

    <!-- merge the following paragraph with the current one -->
    <xsl:apply-templates select="key('p', @oox:id+1)/child::node()" />

    <!-- check if the paragraph mark of following paragraph also should be treated as deleted -->
    <xsl:if test="key('p', @oox:id+1)/w:pPr/w:rPr/w:del">
      <xsl:for-each select="key('p', @oox:id+1)">
        <xsl:call-template name="InsertDeletedParagraph" />
      </xsl:for-each>
    </xsl:if>

  </xsl:template>

  <!--  set heading as list header (needed when number was deleted manually)-->
  <xsl:template name="InsertHeadingAsListHeader">
    <xsl:variable name="numId">
      <xsl:call-template name="GetListProperty">
        <xsl:with-param name="node" select="." />
        <xsl:with-param name="property">w:numId</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <!--check if there's a any numId in document-->
    <xsl:for-each select="key('Part', 'word/document.xml')">
      <xsl:choose>
        <xsl:when test="key('numPr','')/w:ins" />
        <xsl:when test="key('numPr', '')/w:numId">
          <xsl:call-template name="InsertListHeader">
            <xsl:with-param name="numId" select="$numId" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <!--check if there's a any numId in styles-->
          <xsl:for-each select="key('Part', 'word/styles.xml')">
            <xsl:if test="key('numPr', '')/w:numId">
              <xsl:call-template name="InsertListHeader">
                <xsl:with-param name="numId" select="$numId" />
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!--  set heading as list header (needed when number was deleted manually)-->
  <xsl:template name="InsertListHeader">
    <xsl:param name="numId" />
    <xsl:for-each select="key('Part', 'word/numbering.xml')">
      <xsl:if test="not(key('numId', $numId))">
        <xsl:attribute name="text:is-list-header">
          <xsl:text>true</xsl:text>
        </xsl:attribute>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="InsertHeadingOutlineLvl">
    <xsl:param name="outlineLevel" />
    <xsl:attribute name="text:outline-level">
      <xsl:variable name="headingLvl">
        <xsl:call-template name="GetListProperty">
          <xsl:with-param name="node" select="." />
          <xsl:with-param name="property">w:ilvl</xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$headingLvl != ''">
          <xsl:value-of select="$headingLvl+1" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$outlineLevel+1" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!--  paragraphs-->
  <xsl:template match="w:p" mode="paragraph">
    <xsl:choose>
      <!--avoid nested paragaraphs-->
      <xsl:when test="parent::w:p">
        <xsl:apply-templates select="child::node()" />
      </xsl:when>
      <!--default scenario-->
      <!-- NOTE: If the paragraph mark of the previous paragraph shall be treated as deleted 
               we will skip this paragraph. This paragraph has been already translated together 
               with the previous paragraph -->
<!--Sonata:Changes reverted, that caused Regression-->
		<xsl:when test="not(key('p', number(@oox:id)-1)/w:pPr/w:rPr/w:del)">			
        <xsl:variable name="numId">
          <xsl:call-template name="GetListProperty">
            <xsl:with-param name="node" select="." />
            <xsl:with-param name="property">w:numId</xsl:with-param>
          </xsl:call-template>
        </xsl:variable>
        <text:p>
          <!-- Reference the style -->
          <xsl:if test="w:pPr or w:r/w:br[@w:type='page' or @w:type='column'] or key('Part', 'word/styles.xml')/w:styles/w:docDefaults/w:pPrDefault">
            <xsl:attribute name="text:style-name">
              <xsl:choose>
                <xsl:when test="./w:r/w:ptab/@w:alignment = 'right' and ./w:pPr/w:pStyle/@w:val = 'Footer'">
                  <xsl:text>X3AS7TABSTYLE</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="generate-id(self::node())" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </xsl:if>

          <xsl:if test="key('p', number(@oox:id)-1)/w:pPr/w:rPr/w:ins and $numId!=''">
            <text:change-end text:change-id="{generate-id(key('p', number(@oox:id)-1))}" />
          </xsl:if>

          <xsl:apply-templates />

          <!-- Note: If the paragraph mark of the current paragraph should be treated as deleted
                     merge the following paragraph into this one. -->
          <xsl:if test="w:pPr/w:rPr/w:del">
            <xsl:call-template name="InsertDeletedParagraph" />
          </xsl:if>
          <xsl:if test="w:pPr/w:rPr/w:ins">
            <text:change-start text:change-id="{generate-id(self::node())}" />
          </xsl:if>
        </text:p>
        <xsl:if test="w:pPr/w:rPr/w:ins and $numId=''">
          <text:change-end text:change-id="{generate-id(self::node())}" />
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--tabs-->
  <xsl:template match="w:tab[not(parent::w:tabs)]">
    <xsl:choose>
      <xsl:when test="ancestor::w:footnote or ancestor::w:endnote">
        <xsl:variable name="styleId" select="ancestor::w:p/w:pPr/w:pStyle/@w:val" />

        <xsl:choose>
          <xsl:when test="generate-id(.) = generate-id(ancestor::w:p/descendant::w:tab[1]) 
                    and (ancestor::w:p/w:pPr/w:ind/@w:hanging != '' or key('StyleId', $styleId)/w:pPr/w:ind/@w:hanging != '')" />
          <!-- no tab -->
          <xsl:otherwise>
            <text:tab />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <text:tab />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--clam, dialogika: bugfix #1803097-->
  <!--<xsl:template match="w:ptab[@w:relativeTo='margin' and @w:alignment='right' and @w:leader='none']">-->
  <xsl:template match="w:ptab">
    <text:tab />
  </xsl:template>

  <!-- run -->
  <xsl:template match="w:r">
    <xsl:param name="ignoreFieldFlag" />

    <xsl:message terminate="no">progress:w:r</xsl:message>

    <!-- Detect if there is text before a break page in a paragraph, in that case the current paragraph must be split in two -->
    <!-- BUG 1583404 - Page breaks not correct converted - 17/07/2007-->
    <!-- 2008-10-31/divo: Fix for #2124338 
      fo:break-before="page" has no effect for the first paragraph in an ODT document, therefore we need to create an extra paragraph -->
    <xsl:if test="w:br[@w:type='page'] and (preceding-sibling::w:r/w:t[1] or not(../preceding-sibling::node()))">
      <pcut:paragraph_to_cut />
    </xsl:if>

    <xsl:choose>

      <!--fields-->
      <xsl:when test="@oox:fid and $ignoreFieldFlag!='true' and not(parent::w:p/@oox:index)">
        <xsl:call-template name="InsertComplexField" />
      </xsl:when>

      <!-- Comments -->
      <xsl:when test="w:commentReference/@w:id">
        <xsl:call-template name="InsertComment">
          <xsl:with-param name="Id" select="w:commentReference/@w:id" />
        </xsl:call-template>
      </xsl:when>

      <!--  Track changes -->
      <xsl:when test="parent::w:del">
        <xsl:call-template name="TrackChangesDeleteMade" />
      </xsl:when>
      <xsl:when test="parent::w:ins">
        <xsl:call-template name="TrackChangesInsertMade" />
      </xsl:when>
      <xsl:when test="descendant::w:rPrChange">
        <xsl:call-template name="TrackChangesChangesMade" />
      </xsl:when>

      <!-- attach automatic style-->
      <xsl:when test="w:rPr[not(count(child::node())=1 and child::w:noProof)]">
        <text:span text:style-name="{generate-id(self::node())}"><xsl:apply-templates /></text:span>
      </xsl:when>

      <!--default scenario-->
      <xsl:otherwise>
        <xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- path for hyperlinks-->
  <xsl:template name="GetLinkPath">
    <xsl:param name="linkHref" />
    <xsl:choose>
      <xsl:when test="contains($linkHref, 'file://') or contains($linkHref, 'http://') or contains($linkHref, 'https://') or contains($linkHref, 'mailto:')">
        <xsl:value-of select="$linkHref" />
      </xsl:when>
      <xsl:when test="contains($linkHref,'#')">
        <xsl:value-of select="$linkHref" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('../',$linkHref)" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- hyperlinks -->
  <xsl:template match="w:hyperlink">

    <text:a xlink:type="simple" office:title="{@w:tooltip}">

      <xsl:attribute name="xlink:href">
        <!-- document hyperlink -->
        <xsl:if test="@w:anchor">
          <xsl:value-of select="concat('#',@w:anchor)" />
        </xsl:if>
        <!-- file or web page hyperlink with relationship id -->
        <xsl:if test="@r:id">
          <xsl:variable name="relationshipId" select="@r:id" />
          <xsl:variable name="document">
            <xsl:call-template name="GetDocumentName" />
          </xsl:variable>
          <xsl:call-template name="GetLinkPath">
            <xsl:with-param name="linkHref" select="concat('ooc-UriFromPath', '-oop-', key('Part', concat('word/_rels/',$document,'.rels'))/rels:Relationships/rels:Relationship[@Id=$relationshipId]/@Target, '-ooe')" />
          </xsl:call-template>
        </xsl:if>
      </xsl:attribute>

      <!--hyperlink text-->
      <xsl:apply-templates select="w:r">
        <xsl:with-param name="ignoreFieldFlag" select="'true'" />
      </xsl:apply-templates>

    </text:a>

  </xsl:template>

  <!--  text bookmark-Start  -->
  <xsl:template match="w:bookmarkStart">
    <!--
			makz: check if the w:bookmarkStart doesn't belong to a user field.
			user fields are translated to user-field-decl
    
		    20080710/divo: w:bookmarkStart can also be directly below w:body. This condition was missing
		-->
    <xsl:if test="parent::w:body or (ancestor::w:p and not(preceding-sibling::w:r[1]/w:fldChar/@w:fldCharType='separate'))">

      <xsl:variable name="NameBookmark" select="@w:name" />
      <xsl:variable name="OutlineLvl" select="parent::w:p/w:pPr/w:outlineLvl/@w:val" />
      <xsl:variable name="Id" select="@w:id" />

      <xsl:choose>
        <!--math, dialogika: bugfix #1785483 BEGIN-->
        <xsl:when test="contains($NameBookmark, '_Toc') and $OutlineLvl != '' and $OutlineLvl !='9'">
          <!--math, dialogika: bugfix #1785483 END-->
          <text:bookmark text:name="{$NameBookmark}" />

          <text:toc-mark-start text:id="{@w:id}" text:outline-level="{$OutlineLvl + 1}" />

        </xsl:when>
        <!-- a bookmark must begin and end in the same text flow -->
        <xsl:when test="ancestor::w:tc and not(ancestor::w:tc//w:bookmarkEnd[@w:id=$Id])">
          <text:bookmark text:name="{$NameBookmark}" />
        </xsl:when>
        <xsl:otherwise>
          <text:bookmark-start text:name="{$NameBookmark}" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="w:bookmarkEnd">
    <xsl:variable name="Id" select="@w:id" />

    <!--
			makz: check if the w:bookmarkStart doesn't belong to a user field.
			user fields are translated to user-field-decl
    
			20080710/divo: w:bookmarkEnd can also be directly below w:body. This condition was missing
		-->
    <xsl:if test="parent::w:body or (ancestor::w:p and not(following-sibling::w:r[1]/w:fldChar/@w:fldCharType='end'))">
      <xsl:variable name="NameBookmark" select="key('bookmarkStart', @w:id)/@w:name" />
      <xsl:variable name="OutlineLvl" select="parent::w:p/w:pPr/w:outlineLvl/@w:val" />

      <xsl:choose>
        <xsl:when test="contains($NameBookmark, '_Toc')  and  $OutlineLvl != ''">
          <text:toc-mark-end text:id="@w:id" />
        </xsl:when>
        <!-- a bookmark must begin and end in the same text flow -->
        <xsl:when test="not(ancestor::w:tc) or ancestor::w:tc//w:bookmarkStart[@w:id=$Id]">
          <text:bookmark-end text:name="{$NameBookmark}" />
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- simple text  -->
  <!--dialogika, clam: text:span added for hyperlinks (bug #1827518) -->
  <xsl:template match="w:t">
    <xsl:message terminate="no">progress:w:t</xsl:message>
    <xsl:call-template name="InsertDropCapText" />
    <xsl:choose>
      <!--check whether string contains whitespace sequence-->
      <xsl:when test="not(contains(., '  ') or substring(., 1, 1) = ' ')">
        <xsl:choose>
          <xsl:when test="../w:rPr/w:rStyle/@w:val = 'Hyperlink' and ../w:rPr/w:color">
            <text:span text:style-name="{generate-id(..)}"><xsl:value-of select="." /></text:span>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="." />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!--converts whitespaces sequence to text:s-->
        <xsl:choose>
          <xsl:when test="../w:rPr/w:rStyle/@w:val = 'Hyperlink' and ../w:rPr/w:color">
            <text:span text:style-name="{generate-id(..)}"><xsl:call-template name="InsertWhiteSpaces" /></text:span>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="InsertWhiteSpaces" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- drop cap text  (only on first w:t of first w:r of w:p) -->
  <xsl:template name="InsertDropCapText">
    <xsl:if test="not(preceding-sibling::w:t[1]) and not(parent::w:r/preceding-sibling::w:r[1])">
      <xsl:variable name="prev-paragraph" select="ancestor-or-self::w:p[1]/preceding-sibling::w:p[1]" />
      <xsl:if test="$prev-paragraph/w:pPr/w:framePr[@w:dropCap]">
        <text:span text:style-name="{generate-id($prev-paragraph/w:r[1])}"><xsl:value-of select="$prev-paragraph/w:r[1]/w:t" /></text:span>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!--  convert multiple white spaces  -->
  <xsl:template name="InsertWhiteSpaces">
    <xsl:param name="string" select="." />
    <xsl:param name="length" select="string-length(.)" />
    <!-- string which doesn't contain whitespaces-->
    <xsl:choose>
      <xsl:when test="not(contains($string,' '))">
        <xsl:value-of select="$string" />
      </xsl:when>

      <!-- convert white spaces  -->
      <xsl:otherwise>
        <xsl:variable name="before" select="substring-before($string,' ')" />

        <xsl:variable name="after">
          <xsl:call-template name="CutStartSpaces">
            <xsl:with-param name="cuted">
              <xsl:value-of select="substring-after($string,' ')" />
            </xsl:with-param>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="numberOfSpaces" select="$length - string-length($before) - string-length($after)" />
        <xsl:value-of select="$before" />
        <xsl:choose>
          <xsl:when test="$numberOfSpaces = 1 and ($before = '' or $after = '')">
            <!-- single whitespace at the beginning or end of the string -->
            <text:s />
          </xsl:when>
          <xsl:when test="$numberOfSpaces = 1">
            <!-- single whitespace in the middle of the string -->
            <xsl:text> </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <!-- several consecutive whitespace characters -->
            <text:s text:c="{$numberOfSpaces}" />
          </xsl:otherwise>
        </xsl:choose>

        <!--repeat it for substring which has whitespaces-->
        <xsl:call-template name="InsertWhiteSpaces">
          <xsl:with-param name="string" select="$after" />
          <xsl:with-param name="length" select="string-length($after)" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--  cut start spaces -->
  <xsl:template name="CutStartSpaces">
    <xsl:param name="cuted" />
    <xsl:choose>
      <xsl:when test="starts-with($cuted,' ')">
        <xsl:call-template name="CutStartSpaces">
          <xsl:with-param name="cuted" select="substring-after($cuted,' ')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$cuted" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- line breaks  -->
  <xsl:template match="w:br[not(@w:type) or @w:type!='page' and @w:type!='column']">
    <text:line-break />
  </xsl:template>

  <xsl:template match="w:noBreakHyphen">–</xsl:template>

  <!-- 
		*************************************************************************
		Templates for creating Automatic Styles
		*************************************************************************
	-->
  <!-- page or column break must have style defined in paragraph -->
  <xsl:template match="w:br[@w:type='page' or @w:type='column']" mode="automaticstyles">
    <xsl:if test="not(ancestor::w:p/w:pPr)">
      <style:style style:name="{generate-id(ancestor::w:p)}" style:family="paragraph">
        <xsl:call-template name="InsertMasterPageNameAttribute" />
        <style:paragraph-properties>
          <xsl:call-template name="InsertParagraphProperties" />
        </style:paragraph-properties>
      </style:style>
    </xsl:if>
  </xsl:template>

  <!-- symbols : text style -->
  <xsl:template match="w:sym" mode="automaticstyles">
    <style:style style:name="{generate-id(.)}" style:family="text">
      <xsl:if test="@w:font">
        <style:text-properties style:font-name="{@w:font}"
                               style:font-name-complex="{@w:font}">
          <xsl:if test="../w:rPr/w:position">
            <xsl:for-each select="../w:rPr">
              <xsl:call-template name="InsertTextPosition" />
            </xsl:for-each>
          </xsl:if>
        </style:text-properties>
      </xsl:if>
    </style:style>
  </xsl:template>

  <!-- symbols -->
  <xsl:template match="w:sym">
    <!-- character post-processing -->
    <text:span text:style-name="{generate-id(.)}"><pchar:symbol pchar:code="{@w:char}" /></text:span>
  </xsl:template>

  <!-- ignore text in automatic styles mode -->
  <xsl:template match="text()" mode="automaticstyles" />
  <xsl:template match="text()" mode="automaticpict" />

  <!-- insert a master page name when required -->
  <xsl:template name="InsertMasterPageNameAttribute">
    <xsl:if test="ancestor::w:body">

      <!-- NB : precSectPr defines properties of preceding section,
			whereas followingSectPr defines properties of current section -->
      <!--xsl:param name="precSectPr" select="preceding::w:p[w:pPr/w:sectPr][1]/w:pPr/w:sectPr" />
			<xsl:param name="followingSectPr" select="following::w:p[w:pPr/w:sectPr][1]/w:pPr/w:sectPr"/-->
      <!--<xsl:param name="mainSectPr" select="key('Part', 'word/document.xml')/w:document/w:body/w:sectPr" />-->

      <xsl:variable name="mainSectPr" select="key('Part', 'word/document.xml')/w:document/w:body/w:sectPr" />
      <xsl:variable name="precSectPr" select="key('sectPr', number(ancestor-or-self::node()/@oox:s) - 1)" />
      <xsl:variable name="followingSectPr" select="(w:sectPr | key('sectPr', number(ancestor-or-self::node()/@oox:s))[ancestor::w:p/w:pPr/w:sectPr])[1]" />
      <xsl:choose>
        <!-- first case : current section is continuous with preceding section (test if precSectPr exist to avoid bugs) -->
        <xsl:when test="$precSectPr and $followingSectPr/w:type/@w:val = 'continuous' ">
          <!-- no new master page. Warn loss of page header/footer change (should not occure in OOX, but Word 2007 handles it) -->
          <xsl:if
					  test="$followingSectPr/w:headerReference[@w:type='default']/@r:id != $precSectPr/w:headerReference[@w:type='default']/@r:id
							  or $followingSectPr/w:headerReference[@w:type='even']/@r:id != $precSectPr/w:headerReference[@w:type='even']/@r:id 
							  or $followingSectPr/w:headerReference[@w:type='first']/@r:id != $precSectPr/w:headerReference[@w:type='first']/@r:id 
							  or $followingSectPr/w:footerReference[@w:type='default']/@r:id != $precSectPr/w:footerReference[@w:type='default']/@r:id
							  or $followingSectPr/w:footerReference[@w:type='even']/@r:id != $precSectPr/w:footerReference[@w:type='even']/@r:id 
							  or $followingSectPr/w:footerReference[@w:type='first']/@r:id != $precSectPr/w:footerReference[@w:type='first']/@r:id">
            <xsl:message terminate="no">
              <xsl:text>feedback:Header/footer change after continuous section break.</xsl:text>
            </xsl:message>
          </xsl:if>
        </xsl:when>
        <!-- beginning of document -->
        <xsl:when test="not(preceding::w:p[ancestor::w:body])">
          <xsl:choose>
            <xsl:when test="$followingSectPr">
              <xsl:choose>
                <xsl:when test="$followingSectPr/w:titlePg">
                  <xsl:attribute name="style:master-page-name">
                    <xsl:value-of select="concat('First_H_',generate-id($followingSectPr))" />
                  </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="style:master-page-name">
                    <xsl:value-of select="concat('H_',generate-id($followingSectPr))" />
                  </xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$mainSectPr/w:titlePg">
                  <xsl:attribute name="style:master-page-name">
                    <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', 'First Page', '-ooe')" />
                  </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="style:master-page-name">
                    <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', 'Standard', '-ooe')" />
                  </xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <!--clam: bugfix #1800794-->
          <!--<xsl:if test="preceding::w:p[parent::w:body|parent::w:tbl/tr/tv][1]/w:pPr/w:sectPr">-->

          <!-- 20080715/divo: performance improvement by using xsl:key -->
          <!--xsl:if test="preceding::w:p[parent::w:body|parent::w:tc][1]/w:pPr/w:sectPr"-->
          <!-- 20090309/divo: Fix for #2656993. The preceding paragraph might not be a top-level element, it might also be contained in a shape/textbox/table, 
               hence we also check the ancestors of that paragraph -->
          <!--<xsl:if test="key('p', number(ancestor-or-self::node()/@oox:id) - 1)/w:pPr/w:sectPr">-->
          <xsl:if test="key('p', number(ancestor-or-self::node()/@oox:id) - 1)/ancestor-or-self::w:p/w:pPr/w:sectPr">
            <xsl:choose>
              <xsl:when test="$followingSectPr and not($followingSectPr/w:headerReference) and not($followingSectPr/w:footerReference)">
                <xsl:attribute name="style:master-page-name">
                  <!-- jslaurent : hack to make it work in any situation. Does not make any sense though.
										 master page names should be reviewed and unified : many names not consistent, many styles never used -->
                  <xsl:value-of select="concat('H_',generate-id($followingSectPr))" />
                </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="$followingSectPr">
                    <xsl:choose>
                      <xsl:when test="$followingSectPr/w:titlePg">
                        <xsl:attribute name="style:master-page-name">
                          <xsl:value-of select="concat('First_H_',generate-id($followingSectPr))" />
                        </xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:if test="$followingSectPr/w:headerReference or $followingSectPr/w:footerReference">
                          <xsl:attribute name="style:master-page-name">
                            <xsl:value-of select="concat('H_',generate-id($followingSectPr))" />
                          </xsl:attribute>
                        </xsl:if>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="$mainSectPr/w:titlePg">
                        <xsl:attribute name="style:master-page-name">
                          <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', 'First Page', '-ooe')" />
                        </xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="following-sibling::w:r/w:lastRenderedPageBreak and $precSectPr/w:type/@w:val = 'continuous' and generate-id(..) = generate-id($precSectPr/following::w:p[1])">
                            <xsl:attribute name="style:master-page-name">
                              <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', 'Standard', '-ooe')" />
                            </xsl:attribute>
                          </xsl:when>
                          <xsl:when test="$precSectPr and $mainSectPr/w:type/@w:val = 'continuous' ">
                            <!-- no new master page. Warn loss of page header/footer change (should not occure in OOX, but Word 2007 handles it) -->
                            <xsl:if
														  test="$mainSectPr/w:headerReference[@w:type='default']/@r:id != $precSectPr/w:headerReference[@w:type='default']/@r:id
																  or $mainSectPr/w:headerReference[@w:type='even']/@r:id != $precSectPr/w:headerReference[@w:type='even']/@r:id 
																  or $mainSectPr/w:headerReference[@w:type='first']/@r:id != $precSectPr/w:headerReference[@w:type='first']/@r:id 
																  or $mainSectPr/w:footerReference[@w:type='default']/@r:id != $precSectPr/w:footerReference[@w:type='default']/@r:id
																  or $mainSectPr/w:footerReference[@w:type='even']/@r:id != $precSectPr/w:footerReference[@w:type='even']/@r:id 
																  or $mainSectPr/w:footerReference[@w:type='first']/@r:id != $precSectPr/w:footerReference[@w:type='first']/@r:id">
                              <xsl:message terminate="no">
                                <xsl:text>feedback:Header/footer change after continuous section break.</xsl:text>
                              </xsl:message>
                            </xsl:if>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="style:master-page-name">
                              <xsl:value-of select="concat('ooc-NCNameFromString', '-oop-', 'Standard', '-ooe')" />
                            </xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!--
		Summary: Writes the offset for page numbers. 
            The calling context must be a w:p node
		Author:  makz (DIaLOGIKa)
	-->
  <xsl:template name="InsertPageNumberOffset">
    <!--Only change the page number offset for a paragraph in the body ...-->
    <xsl:if test="ancestor::w:body">
      <!--... and only if this is the first paragraph in the section ...-->
      <xsl:if test="not(preceding-sibling::w:p) or preceding-sibling::w:p[1]/w:pPr/w:sectPr">

        <xsl:variable name="currentSectPr" select="key('sectPr', number(ancestor-or-self::node()/@oox:s))" />

        <xsl:if test="$currentSectPr/w:pgNumType/@w:start">
          <!-- there is a sectPr for this paragraph -->
          <xsl:attribute name="style:page-number">
            <xsl:value-of select="$currentSectPr/w:pgNumType/@w:start" />
          </xsl:attribute>
        </xsl:if>
      </xsl:if>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
