<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  * Copyright (c) 2007-2009 DIaLOGIKa
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
  xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
  xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
  xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
  xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
  xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
  xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
  xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
  xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
  xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships"
  xmlns:b="http://schemas.openxmlformats.org/officeDocument/2006/bibliography"
  xmlns:oox="urn:oox"
  exclude-result-prefixes="w wp r rels b oox">

  <xsl:key name="fieldRunsByFieldId" match="w:r" use="@oox:fid" />
  <xsl:key name="fieldRunsByParaId" match="w:r[@oox:fid]" use="@oox:fpid" />

  <!-- 
  *************************************************************************
  MATCHING TEMPLATES
  *************************************************************************
  -->

  <!--
    Summary: Inserts a declaration for every SET field
    Author: makz (DIaLOGIKa)
    Date: 2.11.2007
  -->
  <xsl:template match="w:instrText" mode="UserFieldDecls">
    <!-- rebuild the field code using a series of instrText, in current run or followings -->
    <xsl:variable name="fieldCode">
      <xsl:call-template name="BuildFieldCode" />
    </xsl:variable>

    <xsl:variable name="fieldType">
      <xsl:call-template name="ParseFieldTypeFromFieldCode">
        <xsl:with-param name="fieldCode" select="$fieldCode" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="$fieldType = 'SET'">
      <xsl:variable name="fieldName">
        <xsl:call-template name="ParseFieldArgumentFromFieldCode">
          <xsl:with-param name="fieldCode" select="$fieldCode" />
          <xsl:with-param name="fieldType" select="'SET'" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="fieldValue">
        <xsl:call-template name="ExtractFieldValue">
          <xsl:with-param name="fieldCode" select="$fieldCode" />
          <xsl:with-param name="fieldName" select="$fieldName" />
          <xsl:with-param name="fieldType" select="'SET'" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="valueType">
        <xsl:choose>
          <xsl:when test="number($fieldValue)">float</xsl:when>
          <xsl:otherwise>string</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <text:user-field-decl text:name="{$fieldName}" office:value-type="{$valueType}">
        <xsl:choose>
          <xsl:when test="$valueType = 'float' or $valueType = 'percentage' ">
            <xsl:attribute name="office:value">
              <xsl:value-of select="$fieldValue" />
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="$valueType = 'currency' ">
            <xsl:attribute name="office:value">
              <xsl:value-of select="$fieldValue" />
            </xsl:attribute>
            <xsl:attribute name="office:currency" />
          </xsl:when>
          <xsl:when test="$valueType = 'date' ">
            <xsl:attribute name="office:date-value">
              <xsl:value-of select="$fieldValue" />
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="$valueType = 'time' ">
            <xsl:attribute name="office:time-value">
              <xsl:value-of select="$fieldValue" />
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="$valueType = 'boolean' ">
            <xsl:attribute name="office:boolean-value">
              <xsl:value-of select="$fieldValue" />
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="$valueType = 'string' ">
            <xsl:attribute name="office:string-value">
              <xsl:value-of select="$fieldValue" />
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="office:value">
              <xsl:value-of select="$fieldValue" />
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </text:user-field-decl>
    </xsl:if>

  </xsl:template>

  <xsl:template match="w:instrText" mode="automaticstyles">

    <xsl:variable name="fieldCode">
      <xsl:call-template name="BuildFieldCode" />
    </xsl:variable>

    <xsl:variable name="fieldType">
      <xsl:call-template name="ParseFieldTypeFromFieldCode">
        <xsl:with-param name="fieldCode" select="$fieldCode" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <!--  possible date types: DATE, PRINTDATE, SAVEDATE, CREATEDATE-->
      <xsl:when test="$fieldType = 'CREATEDATE' or $fieldType = 'DATE' 
                or $fieldType = 'PRINTDATE' or $fieldType = 'SAVEDATE'">
        <xsl:call-template name="InsertDateStyle">
          <xsl:with-param name="fieldCode" select="$fieldCode" />
          <xsl:with-param name="dateText" select="string(../following-sibling::w:r/w:t)" />
        </xsl:call-template>
      </xsl:when>
      <!-- possible time types: TIME, EDITTIME-->
      <xsl:when test="$fieldType = 'EDITTIME' or $fieldType = 'TIME'">
        <xsl:call-template name="InsertTimeStyle">
          <xsl:with-param name="timeText" select="$fieldCode" />
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- template with mode automaticpict should behave as with mode automaticstyles -->
  <xsl:template match="w:instrText" mode="automaticpict">
    <xsl:apply-templates select="." mode="automaticstyles" />
  </xsl:template>

  <xsl:template name="InsertComplexField">
    <!-- the context is w:r -->

    <!-- field creating is triggered by the first w:instrText or in case the field wraps over several paragraphs -->
    <xsl:if test="@oox:fStart">
      <text:span text:style-name="{generate-id(.)}">
        <xsl:variable name="fieldCode">
          <xsl:call-template name="BuildFieldCode" />
        </xsl:variable>

        <xsl:variable name="fieldId" select="@oox:fid" />
        <xsl:call-template name="InsertFieldFromFieldCode">
          <xsl:with-param name="fieldCode" select="$fieldCode" />
          <xsl:with-param name="fieldDisplayValue" select="key('fieldRunsByParaId', @oox:fpid)[@oox:fid = $fieldId]" />
          <xsl:with-param name="isLocked" select="@oox:flocked = '1'" />
        </xsl:call-template>
      </text:span>
    </xsl:if>
  </xsl:template>

  <!-- stop doing things for w:instrText, otherwise the text content 
       (i.e. the field code) will be insterted as text -->
  <xsl:template match="w:instrText" />
  <xsl:template match="w:instrText" mode="fieldDisplayValue" />
  <xsl:template match="w:instrText" mode="fieldDisplayValueEscapeSpace" />

  <!-- translate simple fields -->
  <xsl:template match="w:fldSimple">
    <!-- nested fields are handled by the surrounding field and converted to static text -->
    <xsl:if test="w:r/@oox:f &lt;= 1">
      <!-- a simple field may contain several runs, however we only keep the formatting of the first one -->
      <text:span text:style-name="{generate-id(w:r)}">
        <xsl:call-template name="InsertFieldFromFieldCode">
          <xsl:with-param name="fieldCode" select="@w:instr" />
          <xsl:with-param name="fieldDisplayValue" select="w:r" />
          <xsl:with-param name="isLocked" select="@w:fldLock = '1'" />
        </xsl:call-template>
      </text:span>
    </xsl:if>
  </xsl:template>

  <xsl:template match="w:fldSimple[contains(@w:instr,'DATE') or contains(@w:instr,'LastSavedTime') or contains(@w:instr, 'CreateTime')
    or contains(@w:instr,'CreateDate') or contains(@w:instr, 'PrintDate') or contains(@w:instr, 'SaveDate')]" mode="automaticstyles">
    <xsl:call-template name="InsertDateStyle">
      <xsl:with-param name="fieldCode" select="@w:instr" />
      <xsl:with-param name="dateText" select="string(w:r/w:t)" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="w:fldSimple[contains(@w:instr,'TIME') or contains(@w:instr, 'TotalEditingTime') or contains(@w:instr, 'EditTime')]" mode="automaticstyles">
    <xsl:call-template name="InsertTimeStyle">
      <xsl:with-param name="timeText" select="@w:instr" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="w:fldSimple" mode="automaticstyles">
    <xsl:apply-templates select="w:r/w:rPr" mode="automaticstyles" />
  </xsl:template>

  <xsl:template match="w:r" mode="fieldDisplayValue">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="w:t" mode="fieldDisplayValueEscapeSpace">
    <!-- ODF 1.1 only allows text inside ODF fields, no text:s nodes, therefore spaces are replaced by en-space -->
    <xsl:value-of select="translate( ., ' ', '&#x2002;')" />
    <!--<xsl:value-of select="concat('ooc-Replace-', '.', '- ', '-&#x00A0;', '-ooe')" />-->
  </xsl:template>

  <xsl:template match="text()" mode="fieldDisplayValue" />

  <xsl:template name="BuildFieldCode">
    <xsl:param name="ooxFieldId" select="@oox:fid | parent::*/@oox:fid" />

    <xsl:choose>
      <!-- simple field -->
      <xsl:when test="@w:instr">
        <xsl:value-of select="normalize-space(@w:instr)" />
      </xsl:when>
      <!-- complex field -->
      <xsl:otherwise>
        <xsl:variable name="fieldCode">
          <xsl:for-each select="key('fieldRunsByFieldId', $ooxFieldId)//w:instrText">
            <xsl:value-of select="." />
          </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="normalize-space($fieldCode)" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- returns the field type from the field code in uppercase letters -->
  <xsl:template name="ParseFieldTypeFromFieldCode">
    <xsl:param name="fieldCode" />
    <!-- field can start with space, but first none-space text is field code -->
    <xsl:variable name="trimmedFieldCode" select="normalize-space($fieldCode)" />

    <xsl:choose>
      <xsl:when test="starts-with($trimmedFieldCode, '=')">
        <!-- formula fields start with '=' and don't require a space character as separator-->
        <xsl:value-of select="'FORMULA'" />
      </xsl:when>
      <xsl:when test="contains($trimmedFieldCode, ' ')">
        <xsl:value-of select="translate(substring-before($trimmedFieldCode, ' '), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
      </xsl:when>
      <xsl:otherwise>
        <!-- return uppercase field code -->
        <xsl:value-of select="translate($trimmedFieldCode, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- return the part of the field code following the field type  -->
  <xsl:template name="ParseFieldInstructionFromFieldCode">
    <xsl:param name="fieldCode" />
    <!-- field can start with space, but first none-space text is field code -->
    <xsl:variable name="trimmedFieldCode" select="normalize-space($fieldCode)" />

    <xsl:choose>
      <xsl:when test="starts-with($trimmedFieldCode, '=')">
        <xsl:value-of select="normalize-space(substring($trimmedFieldCode, 2))" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space(substring-after($trimmedFieldCode, ' '))" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
    Summary: extracts the field argument out of a field code
    Author: makz (DIaLOGIKa)
    Date: 2.11.2007
  -->
  <xsl:template name="ParseFieldArgumentFromFieldCode">
    <xsl:param name="fieldCode" />
    <xsl:param name="fieldType" />

    <xsl:variable name="fieldInstruction" select="normalize-space(substring-after($fieldCode, $fieldType))" />

    <xsl:variable name="fieldName">
      <xsl:choose>
        <xsl:when test="contains($fieldInstruction, ' ')">
          <xsl:value-of select="substring-before($fieldInstruction, ' ')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$fieldInstruction" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <!-- strip quotes -->
      <xsl:when test="contains($fieldName, '&quot;')">
        <xsl:value-of select="substring-before(substring-after($fieldName, '&quot;'), '&quot;')" />
      </xsl:when>
      <xsl:when test="contains= '\'">

      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$fieldName" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ParseFieldArgumentFromFieldInstruction">
    <xsl:param name="fieldInstruction" />

    <xsl:variable name="fieldArgument">
      <xsl:choose>
        <!-- strip field switches from the beginning -->
        <xsl:when test="starts-with($fieldInstruction, '\')">
          <xsl:call-template name="ParseFieldArgumentFromFieldInstruction">
            <xsl:with-param name="fieldInstruction" select="substring-after($fieldInstruction, ' ')" />
          </xsl:call-template>
        </xsl:when>
        <!-- strip field switches from the end -->
        <xsl:when test="contains= '\'">
          <xsl:call-template name="ParseFieldArgumentFromFieldInstruction">
            <xsl:with-param name="fieldInstruction" select="substring-before($fieldInstruction, '\')" />
          </xsl:call-template>
        </xsl:when>
        <!-- strip quotes -->
        <xsl:when test="contains($fieldInstruction, '&quot;')">
          <xsl:value-of select="substring-before(substring-after($fieldInstruction, '&quot;'), '&quot;')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$fieldInstruction" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="normalize-space($fieldArgument)" />
  </xsl:template>

  <!--
    Summary: extracts the field value out of a field code
    Author: makz (DIaLOGIKa)
    Date: 2.11.2007
  -->
  <xsl:template name="ExtractFieldValue">
    <xsl:param name="fieldCode" />
    <xsl:param name="fieldName" />
    <xsl:param name="fieldType" />

    <xsl:variable name="trimmedFieldCode" select="normalize-space(substring-after(substring-after($fieldCode, $fieldType), $fieldName))" />

    <xsl:choose>
      <xsl:when test="substring($trimmedFieldCode, 1,1) = &apos;&quot;&apos;">
        <xsl:value-of select="substring-before(substring-after($trimmedFieldCode, &apos;&quot;&apos;), &apos;&quot;&apos;)" />
      </xsl:when>
      <xsl:when test="contains($trimmedFieldCode, ' ')">
        <xsl:value-of select="substring-before($trimmedFieldCode, ' ')" />
      </xsl:when>
      <!--xsl:when test="$trimmedFieldCode = '' ">
          < at least a blank space >
          <xsl:text xml:space="preserve"> </xsl:text>
          </xsl:when-->
      <xsl:otherwise>
        <xsl:value-of select="$trimmedFieldCode" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="InsertFieldFromFieldCode">
    <!-- the field code -->
    <xsl:param name="fieldCode" />
    <!-- a node set containing the text being displayed -->
    <xsl:param name="fieldDisplayValue" />
    <!-- a flag indicating whether the field content is set to be updated by the application -->
    <xsl:param name="isLocked" select="false()" />

    <!-- the type of the field such as CREATEDATE, REF, etc -->
    <xsl:variable name="fieldType">
      <xsl:call-template name="ParseFieldTypeFromFieldCode">
        <xsl:with-param name="fieldCode" select="$fieldCode" />
      </xsl:call-template>
    </xsl:variable>
    <!-- the remaining part of the field code containing the instruction -->
    <xsl:variable name="fieldInstruction">
      <xsl:call-template name="ParseFieldInstructionFromFieldCode">
        <xsl:with-param name="fieldCode" select="$fieldCode" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <!-- date and time fields -->
      <xsl:when test="$fieldType = 'CREATEDATE' or $fieldType = 'DATE' 
                or $fieldType = 'EDITTIME' or $fieldType = 'PRINTDATE' 
                or $fieldType = 'SAVEDATE' or $fieldType = 'TIME'">
        <xsl:call-template name="InsertDateAndTimeFields">
          <xsl:with-param name="fieldType" select="$fieldType" />
          <xsl:with-param name="fieldInstruction" select="$fieldInstruction" />
          <xsl:with-param name="fieldDisplayValue" select="$fieldDisplayValue" />
          <xsl:with-param name="isLocked" select="$isLocked" />
        </xsl:call-template>
      </xsl:when>
      <!-- document automation -->
      <xsl:when test="$fieldType = 'COMPARE' or $fieldType = 'DOCVARIABLE' 
                or $fieldType = 'GOTOBUTTON' or $fieldType = 'IF' 
                or $fieldType = 'MACROBUTTON' or $fieldType = 'PRINT'">
        <xsl:call-template name="InsertDocumentAutomationFields">
          <xsl:with-param name="fieldType" select="$fieldType" />
          <xsl:with-param name="fieldInstruction" select="$fieldInstruction" />
          <xsl:with-param name="fieldDisplayValue" select="$fieldDisplayValue" />
          <xsl:with-param name="isLocked" select="$isLocked" />
        </xsl:call-template>
      </xsl:when>
      <!-- document information -->
      <xsl:when test="$fieldType = 'AUTHOR' or $fieldType = 'COMMENTS' 
                or $fieldType = 'DOCPROPERTY' or $fieldType = 'FILENAME' 
                or $fieldType = 'FILESIZE' or $fieldType = 'INFO' 
                or $fieldType = 'KEYWORDS' or $fieldType = 'LASTSAVEDBY' 
                or $fieldType = 'NUMCHARS' or $fieldType = 'NUMPAGES' 
                or $fieldType = 'NUMWORDS' or $fieldType = 'SUBJECT' 
                or $fieldType = 'TEMPLATE' or $fieldType = 'TITLE'">
        <xsl:call-template name="InsertDocumentInformationFields">
          <xsl:with-param name="fieldType" select="$fieldType" />
          <xsl:with-param name="fieldInstruction" select="$fieldInstruction" />
          <xsl:with-param name="fieldDisplayValue" select="$fieldDisplayValue" />
          <xsl:with-param name="isLocked" select="$isLocked" />
        </xsl:call-template>
      </xsl:when>
      <!-- equations and formulas -->
      <!-- not yet implemented; create static text -->
      <!--<xsl:when test="$fieldType = 'FORMULA' or $fieldType = 'ADVANCE' 
                or $fieldType = 'EQ' or $fieldType = 'SYMBOL'">

      </xsl:when>-->
      <!-- index and tables -->
      <xsl:when test="$fieldType = 'INDEX' or $fieldType = 'RD' or $fieldType = 'TA' 
                or $fieldType = 'TC' or $fieldType = 'TOA' or $fieldType = 'TOC' or $fieldType = 'XE'">
        <xsl:call-template name="InsertIndexAndTableFields">
          <xsl:with-param name="fieldType" select="$fieldType" />
          <xsl:with-param name="fieldInstruction" select="$fieldInstruction" />
          <xsl:with-param name="fieldDisplayValue" select="$fieldDisplayValue" />
          <xsl:with-param name="isLocked" select="$isLocked" />
        </xsl:call-template>
      </xsl:when>
      <!-- links and references -->
      <xsl:when test="$fieldType = 'AUTOTEXT' or $fieldType = 'AUTOTEXTLIST' 
                or $fieldType = 'BIBLIOGRAPHY' or $fieldType = 'CITATION' 
                or $fieldType = 'HYPERLINK' or $fieldType = 'INCLUDEPICTURE' 
                or $fieldType = 'INCLUDETEXT' or $fieldType = 'LINK' 
                or $fieldType = 'NOTEREF' or $fieldType = 'PAGEREF' 
                or $fieldType = 'QUOTE' or $fieldType = 'REF' or $fieldType = 'STYLEREF'">
        <xsl:call-template name="InsertLinkAndReferenceFields">
          <xsl:with-param name="fieldType" select="$fieldType" />
          <xsl:with-param name="fieldInstruction" select="$fieldInstruction" />
          <xsl:with-param name="fieldDisplayValue" select="$fieldDisplayValue" />
          <xsl:with-param name="isLocked" select="$isLocked" />
        </xsl:call-template>
      </xsl:when>
      <!-- mail merge -->
      <!-- not yet implemented; create static text -->
      <!--<xsl:when test="$fieldType = 'ADDRESSBLOCK' or $fieldType = 'ASK' 
                or $fieldType = 'COMPARE' or $fieldType = 'DATABASE' 
                or $fieldType = 'FILLIN' or $fieldType = 'GREETINGLINE' 
                or $fieldType = 'IF' or $fieldType = 'MERGEFIELD' 
                or $fieldType = 'MERGEREC' or $fieldType = 'MERGESEQ' 
                or $fieldType = 'NEXT' or $fieldType = 'NEXTIF' 
                or $fieldType = 'SET' or $fieldType = 'SKIPIF'">

      </xsl:when>-->
      <!-- numbering -->
      <xsl:when test="$fieldType = 'AUTONUM' or $fieldType = 'AUTONUMLGL' 
                or $fieldType = 'AUTONUMOUT' or $fieldType = 'BARCODE' 
                or $fieldType = 'LISTNUM' or $fieldType = 'PAGE' 
                or $fieldType = 'REVNUM' or $fieldType = 'SECTION' 
                or $fieldType = 'SECTIONPAGES' or $fieldType = 'SEQ'">
        <xsl:call-template name="InsertNumberingFields">
          <xsl:with-param name="fieldType" select="$fieldType" />
          <xsl:with-param name="fieldInstruction" select="$fieldInstruction" />
          <xsl:with-param name="fieldDisplayValue" select="$fieldDisplayValue" />
          <xsl:with-param name="isLocked" select="$isLocked" />
        </xsl:call-template>
      </xsl:when>
      <!-- user information -->
      <xsl:when test="$fieldType = 'USERADDRESS' or $fieldType = 'USERINITIALS' or $fieldType = 'USERNAME'">
        <xsl:call-template name="InsertUserInformationFields">
          <xsl:with-param name="fieldType" select="$fieldType" />
          <xsl:with-param name="fieldInstruction" select="$fieldInstruction" />
          <xsl:with-param name="fieldDisplayValue" select="$fieldDisplayValue" />
          <xsl:with-param name="isLocked" select="$isLocked" />
        </xsl:call-template>
      </xsl:when>
      <!-- form field -->
      <!-- not yet implemented; create static text -->
      <!--<xsl:when test="$fieldType = 'FORMCHECKBOX' or $fieldType = 'FORMDROPDOWN' or $fieldType = 'FORMTEXT'">

      </xsl:when>-->
      <xsl:when test="$fieldType = 'SET'">
        <!-- SET fields are converted in mode "UserFieldDecls" -->
      </xsl:when>
      <xsl:otherwise>
        <!-- translate field to static text -->
        <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValue" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="InsertDateAndTimeFields">
    <!-- the type of the field such as TIME, etc -->
    <xsl:param name="fieldType" />
    <!-- the remaining part of the field code containing the instruction -->
    <xsl:param name="fieldInstruction" />
    <!-- a node set containing the text being displayed -->
    <xsl:param name="fieldDisplayValue" />
    <!-- a flag indicating whether the field content is set to be updated by the application -->
    <xsl:param name="isLocked" select="false()" />

    <xsl:variable name="dateValue">
      <xsl:for-each select="$fieldDisplayValue//w:t">
        <xsl:value-of select="." />
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="xsdDateTime" select="concat('ooc-XsdDateTimeFromField', '-oop-', $fieldInstruction, '-oop-', $dateValue, '-ooe')" />

    <xsl:choose>
      <xsl:when test="$fieldType = 'CREATEDATE'">
        <!--<text:creation-time style:data-style-name="{generate-id(.)} ">
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValue" />
        </text:creation-time>-->
        <!-- TODO: which one is correct? creation-time? or creation-date? -->
        <text:creation-date style:data-style-name="{generate-id(.)}" text:fixed="{$isLocked}">
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:creation-date>
      </xsl:when>
      <xsl:when test="$fieldType = 'DATE'">
        <text:date style:data-style-name="{generate-id(.)}" text:fixed="{$isLocked}">

          <xsl:if test="$xsdDateTime != ''">
            <xsl:attribute name="text:date-value">
              <xsl:value-of select="$xsdDateTime" />
            </xsl:attribute>
          </xsl:if>

          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:date>
      </xsl:when>
      <xsl:when test="$fieldType = 'EDITTIME'">
        <text:editing-duration style:data-style-name="{generate-id(.)}" text:fixed="{$isLocked}">
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:editing-duration>
      </xsl:when>
      <xsl:when test="$fieldType = 'PRINTDATE'">
        <text:print-date style:data-style-name="{generate-id(.)}" text:fixed="{$isLocked}">
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:print-date>
      </xsl:when>
      <xsl:when test="$fieldType = 'SAVEDATE'">
        <text:modification-date style:data-style-name="{generate-id(.)}" text:fixed="{$isLocked}">
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:modification-date>
      </xsl:when>
      <xsl:when test="$fieldType = 'TIME'">
        <text:time style:data-style-name="{generate-id(.) }" text:fixed="{$isLocked}">
          <xsl:if test="$xsdDateTime != ''">
            <xsl:attribute name="text:time-value">
              <xsl:value-of select="$xsdDateTime" />
            </xsl:attribute>
          </xsl:if>

          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:time>
      </xsl:when>
      <xsl:otherwise>
        <!-- translate field to static text -->
        <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValue" />
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="InsertDocumentAutomationFields">
    <!-- the type of the field such as TIME, etc -->
    <xsl:param name="fieldType" />
    <!-- the remaining part of the field code containing the instruction -->
    <xsl:param name="fieldInstruction" />
    <!-- a node set containing the text being displayed -->
    <xsl:param name="fieldDisplayValue" />
    <!-- a flag indicating whether the field content is set to be updated by the application -->
    <xsl:param name="isLocked" select="false()" />

    <xsl:choose>
      <xsl:when test="$fieldType = 'MACROBUTTON'">
        <xsl:value-of select="normalize-space(substring-after($fieldInstruction,' '))" />
      </xsl:when>
      <xsl:otherwise>
        <!-- translate field to static text: COMPARE, DOCVARIABLE, GOTOBUTTON, IF, PRINT-->
        <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValue" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="InsertDocumentInformationFields">
    <!-- the type of the field such as REF, etc -->
    <xsl:param name="fieldType" />
    <!-- the remaining part of the field code containing the instruction -->
    <xsl:param name="fieldInstruction" />
    <!-- a node set containing the text being displayed -->
    <xsl:param name="fieldDisplayValue" />
    <!-- a flag indicating whether the field content is set to be updated by the application -->
    <xsl:param name="isLocked" select="false()" />

    <xsl:choose>
      <xsl:when test="$fieldType = 'AUTHOR'">
        <text:initial-creator text:fixed="{$isLocked}">
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:initial-creator>
      </xsl:when>
      <xsl:when test="$fieldType = 'COMMENTS'">
        <text:description text:fixed="{$isLocked}">
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:description>
      </xsl:when>
      <xsl:when test="$fieldType = 'DOCPROPERTY'">
        <xsl:call-template name="InsertDOCPROPERTY">
          <xsl:with-param name="fieldInstruction" select="$fieldInstruction" />
          <xsl:with-param name="fieldDisplayValue" select="$fieldDisplayValue" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$fieldType = 'FILENAME'">
        <text:file-name text:display="name" text:fixed="{$isLocked}">
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:file-name>
      </xsl:when>
      <xsl:when test="$fieldType = 'INFO'">
        <!-- fields of this kind are treated as if INFO was omitted 
             and the remaining instruction is translated as a the actual field -->
        <xsl:call-template name="InsertFieldFromFieldCode">
          <xsl:with-param name="fieldCode" select="$fieldInstruction" />
          <xsl:with-param name="fieldDisplayValue" select="$fieldDisplayValue" />
          <xsl:with-param name="isLocked" select="$isLocked" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$fieldType = 'KEYWORDS'">
        <text:keywords text:fixed="{$isLocked}">
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:keywords>
      </xsl:when>
      <xsl:when test="$fieldType = 'LASTSAVEDBY'">
        <text:creator text:fixed="{$isLocked}">
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:creator>
      </xsl:when>
      <xsl:when test="$fieldType = 'NUMCHARS'">
        <text:character-count>
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:character-count>
      </xsl:when>
      <xsl:when test="$fieldType = 'NUMPAGES'">
        <text:page-count>
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:page-count>
      </xsl:when>
      <xsl:when test="$fieldType = 'NUMWORDS'">
        <text:word-count>
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:word-count>
      </xsl:when>
      <xsl:when test="$fieldType = 'SUBJECT'">
        <text:subject text:fixed="{$isLocked}">
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:subject>
      </xsl:when>
      <xsl:when test="$fieldType = 'TITLE'">
        <text:title text:fixed="{$isLocked}">
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:title>
      </xsl:when>
      <xsl:when test="$fieldType = 'TEMPLATE'">
        <text:template-name text:display="name" text:fixed="{$isLocked}">
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:template-name>
      </xsl:when>
      <xsl:otherwise>
        <!-- translate field to static text: FILESIZE -->
        <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValue" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="InsertIndexAndTableFields">
    <!-- the type of the field such as REF, etc -->
    <xsl:param name="fieldType" />
    <!-- the remaining part of the field code containing the instruction -->
    <xsl:param name="fieldInstruction" />
    <!-- a node set containing the text being displayed -->
    <xsl:param name="fieldDisplayValue" />
    <!-- a flag indicating whether the field content is set to be updated by the application -->
    <xsl:param name="isLocked" select="false()" />

    <xsl:choose>
      <xsl:when test="$fieldType = 'XE'">
        <!-- TODO -->
        <xsl:call-template name="InsertIndexMark">
          <xsl:with-param name="instrText" select="$fieldInstruction" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- translate field to static text: INDEX, RD, TA, TC, TOA, TOC -->
        <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValue" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="InsertLinkAndReferenceFields">
    <!-- the type of the field such as REF, etc -->
    <xsl:param name="fieldType" />
    <!-- the remaining part of the field code containing the instruction -->
    <xsl:param name="fieldInstruction" />
    <!-- a node set containing the text being displayed -->
    <xsl:param name="fieldDisplayValue" />
    <!-- a flag indicating whether the field content is set to be updated by the application -->
    <xsl:param name="isLocked" select="false()" />

    <xsl:choose>
      <xsl:when test="$fieldType = 'AUTOTEXT'">
        <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValue" />
      </xsl:when>
      <xsl:when test="$fieldType = 'REF' or $fieldType = 'PAGEREF'">
        <xsl:variable name="fieldArgument">
          <xsl:call-template name="ParseFieldArgumentFromFieldCode">
            <xsl:with-param name="fieldCode" select="$fieldInstruction" />
          </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
          <!-- is the referenced field a bookmark? -->
          <xsl:when test="key('bookmarksByName', $fieldArgument)">
            <xsl:call-template name="InsertCrossReference">
              <xsl:with-param name="fieldCode" select="concat($fieldType, ' ', $fieldInstruction)" />
              <xsl:with-param name="fieldDisplayValue" select="$fieldDisplayValue" />
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="InsertUserVariable">
              <xsl:with-param name="fieldCode" select="concat($fieldType, ' ', $fieldInstruction)" />
              <xsl:with-param name="fieldDisplayValue" select="$fieldDisplayValue" />
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$fieldType = 'HYPERLINK'">
        <xsl:variable name="linkTarget">
          <xsl:call-template name="ParseFieldArgumentFromFieldInstruction">
            <xsl:with-param name="fieldInstruction" select="$fieldInstruction" />
          </xsl:call-template>
        </xsl:variable>
        <text:a xlink:type="simple" xlink:href="{concat('ooc-UriFromPath', '-oop-', $linkTarget, '-ooe')}" >
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValue" />
        </text:a>
      </xsl:when>
      <xsl:when test="$fieldType = 'CITATION'">
        <xsl:call-template name="InsertTextBibliographyMark">
          <!-- TODO -->
          <xsl:with-param name="TextIdentifier" select="substring-before($fieldInstruction, ' \')" />
        </xsl:call-template>
      </xsl:when>
      <!--<xsl:when test="$fieldType = 'AUTOTEXTLIST' 
                or $fieldType = 'BIBLIOGRAPHY' 
                or $fieldType = 'INCLUDEPICTURE' 
                or $fieldType = 'INCLUDETEXT' or $fieldType = 'LINK' 
                or $fieldType = 'NOTEREF' 
                or $fieldType = 'QUOTE'">

      </xsl:when>-->
      <xsl:otherwise>
        <!-- translate field to static text: STYLEREF -->
        <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValue" />
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="InsertNumberingFields">
    <!-- the type of the field such as AUTONUM, etc -->
    <xsl:param name="fieldType" />
    <!-- the remaining part of the field code containing the instruction -->
    <xsl:param name="fieldInstruction" />
    <!-- a node set containing the text being displayed -->
    <xsl:param name="fieldDisplayValue" />
    <!-- a flag indicating whether the field content is set to be updated by the application -->
    <xsl:param name="isLocked" select="false()" />

    <xsl:choose>
      <xsl:when test="$fieldType = 'PAGE'">
        <!-- TODO: adapt template InsertPageNumber so that we only need to pass the field instruction -->
        <xsl:call-template name="InsertPageNumber">
          <xsl:with-param name="fieldCode" select="concat($fieldType, ' ', $fieldInstruction)" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$fieldType = 'REVNUM'">
        <text:editing-cycles text:fixed="{$isLocked}">
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:editing-cycles>
      </xsl:when>
      <xsl:when test="$fieldType = 'SEQ'">
        <xsl:variable name="refType" select="substring-before($fieldInstruction,' ')" />

        <text:sequence text:ref-name="{concat('ref',concat($refType, $fieldDisplayValue/w:r))}"
                       text:name="{$refType}"
                       text:formula="{concat(concat('ooow:',$refType),'+1')}">
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:sequence>
      </xsl:when>
      <xsl:when test="$fieldType = 'AUTONUM' or $fieldType = 'AUTONUMLGL' 
                or $fieldType = 'AUTONUMOUT'">
        <!-- TODO: Count when pre-processing the input document. Using preceding:: is expensive -->
        <xsl:value-of select="concat(count(preceding::w:instrText[contains(.,'AUTONUM')])+1,'.')" />
      </xsl:when>
      <xsl:when test="$fieldType = 'BARCODE' 
                or $fieldType = 'LISTNUM'
                or $fieldType = 'SECTION' 
                or $fieldType = 'SECTIONPAGES'">

      </xsl:when>
      <xsl:otherwise>
        <!-- translate field to static text -->
        <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValue" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="InsertUserInformationFields">
    <!-- the type of the field such as USERNAME, etc -->
    <xsl:param name="fieldType" />
    <!-- the remaining part of the field code containing the instruction -->
    <xsl:param name="fieldInstruction" />
    <!-- a node set containing the text being displayed -->
    <xsl:param name="fieldDisplayValue" />
    <!-- a flag indicating whether the field content is set to be updated by the application -->
    <xsl:param name="isLocked" select="false()" />

    <xsl:choose>
      <xsl:when test="$fieldType = 'USERADDRESS'">
        <text:sender-street text:fixed="{$isLocked}">
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:sender-street>
      </xsl:when>
      <xsl:when test="$fieldType = 'USERINITIALS'">
        <text:author-initials text:fixed="{$isLocked}">
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:author-initials>
      </xsl:when>
      <xsl:when test="$fieldType = 'USERNAME'">
        <text:author-name text:fixed="{$isLocked}">
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:author-name>
      </xsl:when>
      <xsl:otherwise>
        <!-- translate field to static text -->
        <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValue" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="InsertUserVariable">
    <xsl:param name="fieldCode" />

    <!-- truncate field to find arguments -->
    <xsl:variable name="fieldName">
      <xsl:call-template name="ParseFieldArgumentFromFieldCode">
        <xsl:with-param name="fieldCode" select="$fieldCode" />
        <xsl:with-param name="fieldType" select="'REF'" />
      </xsl:call-template>
    </xsl:variable>

    <text:user-field-get>
      <xsl:attribute name="text:name">
        <xsl:value-of select="$fieldName" />
      </xsl:attribute>
      <xsl:value-of select="w:r/w:t" />
    </text:user-field-get>
  </xsl:template>

  <!-- alphabetical index mark -->
  <xsl:template name="InsertIndexMark">
    <xsl:param name="instrText" />
    <xsl:variable name="value" select="substring-before(substring-after($instrText,'&quot;'),'&quot;')" />

    <text:alphabetical-index-mark>
      <xsl:choose>
        <xsl:when test="not(contains($value, ':'))">
          <xsl:attribute name="text:string-value">
            <xsl:value-of select="$value" />
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="contains($value, ':')">
          <xsl:variable name="TextKey1" select="substring-before($value, ':')" />
          <xsl:variable name="TextKey2" select="substring-after($value, ':')" />

          <xsl:choose>
            <xsl:when test="contains($TextKey2, ':')">
              <xsl:attribute name="text:string-value">
                <xsl:value-of select="substring-after($TextKey2, ':')" />
              </xsl:attribute>
              <xsl:attribute name="text:key2">
                <xsl:value-of select="substring-before($TextKey2, ':')" />
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="text:string-value">
                <xsl:value-of select="$TextKey2" />
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:attribute name="text:key1">
            <xsl:value-of select="$TextKey1" />
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
    </text:alphabetical-index-mark>
  </xsl:template>

  <!--
  Summary: inserts a reference to bookmark
  Author: Clever Age
  Modified: makz (DIaLOGIKa)
  Date: 2.11.2007
  -->
  <xsl:template name="InsertCrossReference">
    <xsl:param name="fieldCode" />
    <xsl:param name="fieldDisplayValue" />

    <!--clam, dialogika: bugfix 2000762-->
    <xsl:variable name="ReferenceFormat">
      <xsl:choose>
        <xsl:when test="contains($fieldCode, ' \w')">chapter</xsl:when>
        <xsl:otherwise>text</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <text:bookmark-ref>
      <xsl:attribute name="text:reference-format">
        <xsl:value-of select="$ReferenceFormat" />
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="contains($fieldCode, 'PAGEREF')">
          <xsl:attribute name="text:ref-name">
            <xsl:choose>
              <xsl:when test="contains($fieldCode, ' \')">
                <xsl:value-of select="substring-before(concat('_',substring-after($fieldCode,'_')), ' \')" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('_',substring-after($fieldCode,'_'))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="text:ref-name">
            <!--clam, dialogika: trim inserted because of bug 1839938-->
            <xsl:choose>
              <xsl:when test="contains($fieldCode, ' \')">
                <xsl:value-of select="normalize-space(substring-before(substring-after($fieldCode, 'REF '), ' \'))" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="normalize-space(substring-after($fieldCode, 'REF '))" />
              </xsl:otherwise>
            </xsl:choose>

          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />

    </text:bookmark-ref>
  </xsl:template>

  <xsl:template name="InsertDateStyle">
    <xsl:param name="fieldCode" />
    <xsl:param name="dateText" />

    <xsl:variable name="FormatDate" select="substring-before(substring-after($dateText, '&quot;'), '&quot;')" />

    <!-- some of the DOCPROPERTY date field types have constant date format, 
      which is not saved in fieldCode so it need to be given directly in these cases-->
    <xsl:choose>

      <xsl:when test="contains($fieldCode, 'CREATETIME') or contains($fieldCode,'LASTESAVEDTIME')">
        <xsl:call-template name="InsertDocprTimeStyle" />
      </xsl:when>

      <xsl:when test="contains($fieldCode, 'CREATEDATE') or contains($fieldCode, 'SAVEDATE') or contains($fieldCode, 'PRINTDATE')">
        <xsl:call-template name="InsertCreationDateStyle" />
      </xsl:when>

      <!--default scenario-->
      <xsl:otherwise>
        <xsl:call-template name="InsertDateFormat">
          <xsl:with-param name="FormatDate" select="$FormatDate" />
          <xsl:with-param name="ParamField" select="'DATE'" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="InsertCreationDateStyle">
    <number:date-style style:name="{generate-id()}">
      <number:day />
      <number:text>
        <xsl:text> </xsl:text>
      </number:text>
      <number:month number:style="long" number:textual="true" />
      <number:text>
        <xsl:text> </xsl:text>
      </number:text>
      <number:year number:style="long" />
    </number:date-style>
  </xsl:template>

  <!--DOCPROPERTY CreateDate, SaveDate, PrintDate default format-->
  <xsl:template name="InsertDocprLongDateStyle">
    <number:date-style style:name="{generate-id()}">
      <number:month number:style="long" />
      <number:text>-</number:text>
      <number:day number:style="long" />
      <number:text>-</number:text>
      <number:year number:style="long" />
      <number:text>
        <xsl:text> </xsl:text>
      </number:text>
      <number:hours number:style="long" />
      <number:text>:</number:text>
      <number:minutes number:style="long" />
      <number:text>:</number:text>
      <number:seconds number:style="long" />
      <number:text>
        <xsl:text> </xsl:text>
      </number:text>
      <number:am-pm />
    </number:date-style>
  </xsl:template>

  <!--DOCPROPERTY CreateTime, LastSavedTime default format-->
  <xsl:template name="InsertDocprTimeStyle">
    <number:date-style style:name="{generate-id()}">
      <number:year number:style="long" />
      <number:text>-</number:text>
      <number:month number:style="long" />
      <number:text>-</number:text>
      <number:day number:style="long" />
      <number:text>
        <xsl:text> </xsl:text>
      </number:text>
      <number:hours number:style="long" />
      <number:text>:</number:text>
      <number:minutes number:style="long" />
    </number:date-style>
  </xsl:template>

  <xsl:template name="InsertTimeStyle">
    <xsl:param name="timeText" />

    <xsl:call-template name="InsertDateFormat">
      <xsl:with-param name="FormatDate" select="substring-before(substring-after($timeText, '&quot;'), '&quot;')" />
      <xsl:with-param name="ParamField" select="'TIME'" />
    </xsl:call-template>

  </xsl:template>

  <xsl:template name="InsertFieldProperties">
    <xsl:param name="fieldCodeContainer" select="ancestor::w:fldSimple | ancestor::w:r/w:instrText" />

    <xsl:variable name="fieldCode">
      <xsl:choose>
        <xsl:when test="$fieldCodeContainer/@w:instr">
          <xsl:value-of select="$fieldCodeContainer/@w:instr" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="BuildFieldCode">
            <xsl:with-param name="instrText" select="$fieldCodeContainer" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="contains($fieldCode,'Upper')">
        <xsl:attribute name="fo:text-transform">
          <xsl:text>uppercase</xsl:text>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="contains($fieldCode,'Lower')">
        <xsl:attribute name="fo:text-transform">
          <xsl:text>lowercase</xsl:text>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="contains($fieldCode,'FirstCap') or contains($fieldCode,'Caps')">
        <xsl:attribute name="fo:text-transform">
          <xsl:text>capitalize</xsl:text>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="contains($fieldCode,'SBCHAR')">
        <xsl:attribute name="fo:letter-spacing">
          <xsl:text>-0.018cm</xsl:text>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="contains($fieldCode,'DBCHAR')">
        <xsl:attribute name="fo:letter-spacing">
          <xsl:text>0.176cm</xsl:text>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="InsertDateFormat">
    <xsl:param name="FormatDate" />
    <xsl:param name="ParamField" />
    <number:date-style style:name="{generate-id()}">
      <xsl:call-template name="InsertFormatDateStyle">
        <xsl:with-param name="FormatDate">
          <xsl:choose>
            <xsl:when test="$FormatDate!=''">
              <xsl:value-of select="$FormatDate" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$ParamField='TIME'">
                  <xsl:text>HH:mm</xsl:text>
                </xsl:when>
                <xsl:when test="$ParamField='DATE'">
                  <xsl:text>yyyy-MM-dd</xsl:text>
                </xsl:when>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </number:date-style>
  </xsl:template>

  <xsl:template name="InsertFormatDateStyle">
    <xsl:param name="FormatDate" />
    <xsl:param name="DateText" />
    <xsl:choose>

      <xsl:when test="starts-with($FormatDate, 'yyyy')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:year number:style="long" />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'yyyy')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'yy')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:year />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'yy')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'y')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:year />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'y')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'YYYY')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:year number:style="long" />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'YYYY')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'YY')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:year />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'YY')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'Y')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:year />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'Y')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'MMMM')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:month number:style="long" number:textual="true" />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'MMMM')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'MMM')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:month number:textual="true" />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'MMM')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'MM')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:month number:style="long" />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'MM')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'M')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:month />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'M')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'dddd')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:day-of-week number:style="long" />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'dddd')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'ddd')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:day-of-week />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'ddd')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'dd')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:day number:style="long" />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'dd')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'd')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:day number:style="long" />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'd')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'DDDD')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:day-of-week number:style="long" />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'DDDD')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'DDD')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:day-of-week />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'DDD')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'DD')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:day number:style="long" />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'DD')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'D')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:day number:style="long" />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'D')" />
        </xsl:call-template>
      </xsl:when>


      <xsl:when test="starts-with($FormatDate, 'hh')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:hours number:style="long" />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'hh')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'h')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:hours />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'h')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'HH')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:hours number:style="long" />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'HH')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'H')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:hours />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'H')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'mm')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:minutes number:style="long" />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'mm')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'm')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:minutes />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'm')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'ss')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:seconds number:style="long" />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'ss')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 's')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:seconds />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 's')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'SS')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:seconds number:style="long" />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'SS')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'S')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:seconds />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'S')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="starts-with($FormatDate, 'am/pm')">
        <xsl:if test="$DateText">
          <number:text>
            <xsl:value-of select="$DateText" />
          </number:text>
        </xsl:if>
        <number:am-pm />
        <xsl:call-template name="InsertFormatDateStyle">
          <xsl:with-param name="FormatDate" select="substring-after($FormatDate, 'am/pm')" />
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
        <xsl:variable name="Apostrof">
          <xsl:text>&apos;</xsl:text>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="contains(substring($FormatDate, 1, 1), $Apostrof)">
            <xsl:call-template name="InsertFormatDateStyle">
              <xsl:with-param name="FormatDate" select="substring-after(substring-after($FormatDate, $Apostrof), $Apostrof)" />
              <xsl:with-param name="DateText" select="concat($DateText, substring-before(substring-after($FormatDate, $Apostrof), $Apostrof))" />
            </xsl:call-template>
          </xsl:when>

          <xsl:when test="substring-after($FormatDate, substring($FormatDate, 1, 1))">
            <xsl:call-template name="InsertFormatDateStyle">
              <xsl:with-param name="FormatDate" select="substring-after($FormatDate, substring($FormatDate, 1, 1))" />
              <xsl:with-param name="DateText" select="concat($DateText, substring($FormatDate, 1, 1))" />
            </xsl:call-template>
          </xsl:when>

          <xsl:otherwise>
            <xsl:if test="$DateText">
              <number:text>
                <xsl:value-of select="$DateText" />
              </number:text>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Page Number Field -->
  <xsl:template name="InsertPageNumber">
    <xsl:param name="fieldCode" />

    <xsl:variable name="docName">
      <xsl:call-template name="GetDocumentName" />
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$docName = 'document.xml'">
        <xsl:if test="key('sectPr', number(ancestor-or-self::node()/@oox:s))/w:pgNumType/@w:chapStyle">
          <text:chapter text:display="number"
                        text:outline-level="{key('sectPr', number(ancestor-or-self::node()/@oox:s))/w:pgNumType/@w:chapStyle}" />
          <xsl:choose>
            <xsl:when test="key('sectPr', number(ancestor-or-self::node()/@oox:s))/w:pgNumType/@w:chapSep = 'period'">
              <xsl:text>.</xsl:text>
            </xsl:when>
            <xsl:when test="key('sectPr', number(ancestor-or-self::node()/@oox:s))/w:pgNumType/@w:chapSep = 'colon'">
              <xsl:text>:</xsl:text>
            </xsl:when>
            <xsl:otherwise>-</xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>

        <xsl:variable name="rId" select="key('Part', 'word/_rels/document.xml.rels')/rels:Relationships/rels:Relationship[@Target = $docName]/@Id" />

        <xsl:for-each select="key('Part', 'word/document.xml')">
          <xsl:for-each select="key('sectPr', '')[w:headerReference/@r:id = $rId or w:footerReference/@r:id = $rId]">
            <xsl:if test="w:pgNumType/@w:chapStyle">
              <text:chapter text:display="number"
                            text:outline-level="{w:pgNumType/@w:chapStyle}" />
              <xsl:choose>
                <xsl:when test="w:pgNumType/@w:chapSep = 'period'">
                  <xsl:text>.</xsl:text>
                </xsl:when>
                <xsl:when test="key('sectPr', number(ancestor-or-self::node()/@oox:s))/w:pgNumType/@w:chapSep = 'colon'">
                  <xsl:text>:</xsl:text>
                </xsl:when>
                <xsl:otherwise>-</xsl:otherwise>
              </xsl:choose>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>

    <text:page-number>

      <xsl:variable name="rId" select="concat('',key('Part', 'word/_rels/document.xml.rels')/descendant::node()[@Target=$docName]/@Id)" />
      <xsl:variable name="nodesectPr" select="key('sectPr', '')[w:headerReference/@r:id = $rId or w:footerReference/@r:id = $rId]" />

      <!--dialogika, clam: bugfix (special workaround) for #1826728-->
      <xsl:attribute name="text:select-page">
        <xsl:choose>
          <xsl:when test="$nodesectPr[1]/w:pgNumType/@w:start='0'">
            <xsl:text>previous</xsl:text>
          </xsl:when>
          <xsl:when test="$nodesectPr[1]/preceding::w:sectPr[w:pgNumType/@w:start][1]/w:pgNumType/@w:start='0'">
            <xsl:text>previous</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>current</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:variable name="standardNumType">
        <xsl:choose>
          <xsl:when test="$nodesectPr/w:pgNumType/@w:fmt">
            <xsl:choose>
              <xsl:when test="$nodesectPr/w:pgNumType/@w:fmt = 'lowerRoman'">i</xsl:when>
              <xsl:when test="$nodesectPr/w:pgNumType/@w:fmt = 'upperRoman'">I</xsl:when>
              <xsl:when test="$nodesectPr/w:pgNumType/@w:fmt = 'lowerLetter'">a</xsl:when>
              <xsl:when test="$nodesectPr/w:pgNumType/@w:fmt = 'upperLetter'">A</xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:attribute name="style:num-format">
        <xsl:choose>
          <xsl:when test="contains($fieldCode, 'Arabic')">1</xsl:when>
          <xsl:when test="contains($fieldCode, 'alphabetic')">a</xsl:when>
          <xsl:when test="contains($fieldCode, 'ALPHABETIC')">A</xsl:when>
          <xsl:when test="contains($fieldCode, 'roman')">i</xsl:when>
          <xsl:when test="contains($fieldCode, 'ROMAN')">I</xsl:when>
          <xsl:when test="$standardNumType">
            <xsl:value-of select="$standardNumType" />
          </xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:value-of select="./w:r/w:t" />
    </text:page-number>
  </xsl:template>

  <!-- Insert Citations -->
  <xsl:template name="InsertTextBibliographyMark">
    <xsl:param name="TextIdentifier" />

    <xsl:variable name="Path" select="key('Part', 'customXml/item1.xml')/b:Sources/b:Source[b:Tag = $TextIdentifier]" />

    <xsl:variable name="BibliographyType" select="$Path/b:SourceType" />

    <xsl:variable name="LastName">
      <xsl:choose>
        <xsl:when test="$Path/b:Author/b:Author/b:NameList/b:Person/b:Last">
          <xsl:value-of select="$Path/b:Author/b:Author/b:NameList/b:Person/b:Last" />
        </xsl:when>
        <xsl:when test="$Path/b:Author/b:Author/b:Corporate">
          <xsl:value-of select="$Path/b:Author/b:Author/b:Corporate" />
        </xsl:when>
        <xsl:otherwise />
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="FirstName">
      <xsl:choose>
        <xsl:when test="$Path/b:Author/b:Author/b:NameList/b:Person/b:First">
          <xsl:value-of select="$Path/b:Author/b:Author/b:NameList/b:Person/b:First" />
        </xsl:when>
        <xsl:otherwise />
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="Middle">
      <xsl:choose>
        <xsl:when test="$Path/b:Author/b:Author/b:NameList/b:Person/b:Middle">
          <xsl:value-of select="$Path/b:Author/b:Author/b:NameList/b:Person/b:Middle" />
        </xsl:when>
        <xsl:otherwise />
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="Author">
      <xsl:choose>
        <xsl:when test="$LastName != '' and $FirstName != '' and $Middle != ''">
          <xsl:value-of select="concat($LastName, ' ', $FirstName,' ', $Middle)" />
        </xsl:when>
        <xsl:when test="$LastName != '' and $FirstName != ''">
          <xsl:value-of select="concat($LastName, ' ', $FirstName)" />
        </xsl:when>
        <xsl:when test="$LastName != '' and $Middle != ''">
          <xsl:value-of select="concat($LastName, ' ', $Middle)" />
        </xsl:when>
        <xsl:when test="$FirstName != '' and $Middle != ''">
          <xsl:value-of select="concat($FirstName,' ', $Middle)" />
        </xsl:when>
        <xsl:when test="$LastName != ''">
          <xsl:value-of select="$LastName" />
        </xsl:when>
        <xsl:when test="$FirstName != ''">
          <xsl:value-of select="$FirstName" />
        </xsl:when>
        <xsl:when test="$Middle != ''">
          <xsl:value-of select="$Middle" />
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="City" select="$Path/b:City" />
    <xsl:variable name="StateProvince" select="$Path/b:StateProvince" />
    <xsl:variable name="CountryRegion" select="$Path/b:CountryRegion" />

    <xsl:variable name="Address">
      <xsl:choose>
        <xsl:when test="$City != '' and $StateProvince != '' and $CountryRegion != ''">
          <xsl:value-of select="concat($City,' ',$StateProvince,' ',$CountryRegion)" />
        </xsl:when>
        <xsl:when test="$City != '' and $StateProvince != ''">
          <xsl:value-of select="concat($City,' ',$StateProvince)" />
        </xsl:when>
        <xsl:when test="$City != '' and $CountryRegion != ''">
          <xsl:value-of select="concat($City,' ',$CountryRegion)" />
        </xsl:when>
        <xsl:when test="$StateProvince != '' and $CountryRegion != ''">
          <xsl:value-of select="concat($StateProvince,' ',$CountryRegion)" />
        </xsl:when>
        <xsl:when test="$City != ''">
          <xsl:value-of select="$City" />
        </xsl:when>
        <xsl:when test="$StateProvince != ''">
          <xsl:value-of select="$StateProvince" />
        </xsl:when>
        <xsl:when test="$CountryRegion != ''">
          <xsl:value-of select="$CountryRegion" />
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="TextIdent">
      <xsl:value-of select="$LastName" />
      <xsl:if test="$Path/b:Year">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="$Path/b:Year" />
      </xsl:if>
    </xsl:variable>

    <text:bibliography-mark>
      <xsl:attribute name="text:identifier">
        <xsl:value-of select="$TextIdent" />
      </xsl:attribute>
      <xsl:attribute name="text:bibliography-type">
        <xsl:choose>
          <xsl:when test="$BibliographyType = 'Book'">
            <xsl:text>book</xsl:text>
          </xsl:when>
          <xsl:when test="$BibliographyType = 'JournalArticle'">
            <xsl:text>article</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>book</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="$Author">
        <xsl:attribute name="text:author">
          <xsl:value-of select="$Author" />
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$Path/b:Title">
        <xsl:attribute name="text:title">
          <xsl:value-of select="$Path/b:Title" />
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$Path/b:Year">
        <xsl:attribute name="text:year">
          <xsl:value-of select="$Path/b:Year" />
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$Path/b:Publisher">
        <xsl:attribute name="text:publisher">
          <xsl:value-of select="$Path/b:Publisher" />
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$Address">
        <xsl:attribute name="text:address">
          <xsl:value-of select="$Address" />
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$Path/b:Volume">
        <xsl:attribute name="text:volume">
          <xsl:value-of select="$Path/b:Volume" />
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$Path/b:StandardNumber">
        <xsl:attribute name="text:number">
          <xsl:value-of select="$Path/b:StandardNumber" />
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$Path/b:Pages">
        <xsl:attribute name="text:pages">
          <xsl:value-of select="$Path/b:Pages" />
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$Path/b:Edition">
        <xsl:attribute name="text:edition">
          <xsl:value-of select="$Path/b:Edition" />
        </xsl:attribute>
      </xsl:if>
      <xsl:value-of select="$LastName" />
    </text:bibliography-mark>
  </xsl:template>

  <xsl:template name="InsertDOCPROPERTY">
    <xsl:param name="fieldInstruction" />
    <xsl:param name="fieldDisplayValue" />
    <!-- a flag indicating whether the field content is set to be updated by the application -->
    <xsl:param name="isLocked" select="false()" />

    <xsl:variable name="docpropCategory">
      <xsl:call-template name="ParseFieldTypeFromFieldCode">
        <xsl:with-param name="fieldCode" select="$fieldInstruction" />
      </xsl:call-template>
    </xsl:variable>

    <!-- For the following combinations of DOCPROPERTY and docprop-category, 
         there is an equivalent field, in which case we insert this fields. -->
    <xsl:variable name="equivalentFieldType">
      <xsl:choose>
        <xsl:when test="$docpropCategory = 'AUTHOR'">
          <xsl:text>AUTHOR</xsl:text>
        </xsl:when>
        <xsl:when test="$docpropCategory = 'BYTES'">
          <xsl:text>FILESIZE</xsl:text>
        </xsl:when>
        <xsl:when test="$docpropCategory = 'CHARACTERS'">
          <xsl:text>NUMCHARS</xsl:text>
        </xsl:when>
        <xsl:when test="$docpropCategory = 'COMMENTS'">
          <xsl:text>COMMENTS</xsl:text>
        </xsl:when>
        <xsl:when test="$docpropCategory = 'CREATETIME'">
          <xsl:text>CREATEDATE</xsl:text>
        </xsl:when>
        <xsl:when test="$docpropCategory = 'LASTPRINTED'">
          <xsl:text>PRINTDATE</xsl:text>
        </xsl:when>
        <xsl:when test="$docpropCategory = 'LASTSAVEDBY'">
          <xsl:text>LASTSAVEDBY</xsl:text>
        </xsl:when>
        <xsl:when test="$docpropCategory = 'LASTSAVEDTIME'">
          <xsl:text>SAVEDATE</xsl:text>
        </xsl:when>
        <xsl:when test="$docpropCategory = 'PAGES'">
          <xsl:text>NUMPAGES</xsl:text>
        </xsl:when>
        <xsl:when test="$docpropCategory = 'REVISIONNUMBER'">
          <xsl:text>REVNUM</xsl:text>
        </xsl:when>
        <xsl:when test="$docpropCategory = 'SUBJECT'">
          <xsl:text>SUBJECT</xsl:text>
        </xsl:when>
        <xsl:when test="$docpropCategory = 'TEMPLATE'">
          <xsl:text>TEMPLATE</xsl:text>
        </xsl:when>
        <xsl:when test="$docpropCategory = 'TITLE'">
          <xsl:text>TITLE</xsl:text>
        </xsl:when>
        <xsl:when test="$docpropCategory = 'TOTALEDITINGTIME'">
          <xsl:text>EDITTIME</xsl:text>
        </xsl:when>
        <!-- additional mappings (not defined in spec -->
        <xsl:when test="$docpropCategory = 'WORDS'">
          <xsl:text>NUMWORDS</xsl:text>
        </xsl:when>
        <xsl:when test="$docpropCategory = 'KEYWORDS'">
          <xsl:text>KEYWORDS</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$equivalentFieldType != ''">
        <!-- insert equivalent field -->
        <xsl:call-template name="InsertFieldFromFieldCode">
          <xsl:with-param name="fieldCode" select="concat(equivalentFieldType, substring-after($fieldInstruction, $docpropCategory))" />
          <xsl:with-param name="fieldDisplayValue" select="$fieldDisplayValue" />
          <xsl:with-param name="isLocked" select="$isLocked" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$docpropCategory = 'COMPANY'">
        <text:sender-company text:fixed="{$isLocked}">
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:sender-company>
      </xsl:when>
      <xsl:when test="$docpropCategory = 'PARAGRAPHS'">
        <text:paragraph-count text:fixed="{$isLocked}">
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:paragraph-count>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="pattern" select="'\s*(?:&quot;(.*?)&quot;|([^ ]*))[ \\]*.*'" />
        <!-- custom document properties -->
        <text:user-defined text:name="{concat('ooc-RegexReplace', '-oop-', $fieldInstruction, '-oop-', $pattern, '-oop-', '$1$2', '-oop-', true(), '-ooe')}" text:fixed="true" >
          <!-- NOTE: We set the field to be fixed, because OOo 3.0 cannot handle document properties of certain types correctly (e.g. dates) -->
          <xsl:apply-templates select="$fieldDisplayValue" mode="fieldDisplayValueEscapeSpace" />
        </text:user-defined>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>