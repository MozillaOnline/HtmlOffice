<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
  xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
  xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
  xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
  xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
  xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
  xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
  xmlns="http://schemas.openxmlformats.org/package/2006/relationships"
  xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" 
  xmlns:oox="urn:oox"
  exclude-result-prefixes="w r oox">

  <xsl:key name="footnotes" match="w:footnoteReference" use="''"/>
  <xsl:key name="endnotes" match="w:endnoteReference" use="''"/>

  <!-- footnotes -->
  <xsl:template match="w:r[w:footnoteReference]">
    <xsl:variable name="footnoteId" select="w:footnoteReference/@w:id"/>
    <xsl:variable name="textFootnote" select="w:t"/>
    <!-- change context to get the footnote content -->
    <xsl:for-each select="key('Part', 'word/footnotes.xml')/w:footnotes/w:footnote[@w:id=$footnoteId]">

      <text:span>
        <text:note text:id="{concat('ftn',count(preceding-sibling::w:footnote) - 1)}"
          text:note-class="footnote">
          <text:note-citation>
            <xsl:choose>
              <xsl:when test="@w:suppressRef = 1 or @w:suppressRef = 'true' or @w:suppressRef = 'On' or $textFootnote!=''">
                <xsl:choose>
                  <xsl:when test="$textFootnote!=''">
                    <xsl:attribute name="text:label">
                      <xsl:value-of select="concat($textFootnote, ' ')"/>
                    </xsl:attribute>
                    <xsl:value-of select="concat($textFootnote, ' ')"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="text:label">
                      <xsl:apply-templates select="w:t"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="w:t"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="count(preceding-sibling::w:footnote) - 1"/>
              </xsl:otherwise>
            </xsl:choose>
          </text:note-citation>
          <text:note-body>
            <xsl:apply-templates select="."/>
          </text:note-body>
        </text:note>
      </text:span>
    </xsl:for-each>
  </xsl:template>

  <!-- endnote -->
  <xsl:template match="w:r[w:endnoteReference]">
    <xsl:variable name="endnoteId" select="w:endnoteReference/@w:id"/>
    <xsl:variable name="textEndnote" select="w:t"/>
    <!-- change context to get the footnote content -->
    <xsl:for-each select="key('Part', 'word/endnotes.xml')/w:endnotes/w:endnote[@w:id=$endnoteId]">
      <text:span>
        <text:note text:id="{concat('edn',count(preceding-sibling::w:endnote) - 1)}"
          text:note-class="endnote">
          <text:note-citation>
            <xsl:choose>
              <xsl:when test="@w:suppressRef = 1 or @w:suppressRef = 'true' or @w:suppressRef = 'On'  or $textEndnote!=''">
                <xsl:choose>
                  <xsl:when test="$textEndnote">
                    <xsl:attribute name="text:label">
                      <xsl:value-of select="concat($textEndnote, ' ')"/>
                    </xsl:attribute>
                    <xsl:value-of select="concat($textEndnote, ' ')"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="text:label">
                      <xsl:apply-templates select="w:t"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="w:t"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="count(preceding-sibling::w:endnote) - 1"/>
              </xsl:otherwise>
            </xsl:choose>
          </text:note-citation>
          <text:note-body>
            <xsl:apply-templates select="."/>
          </text:note-body>
        </text:note>
      </text:span>
    </xsl:for-each>
  </xsl:template>

  <!-- Insert text:notes-configuration element -->

  <xsl:template name="InsertNotesConfiguration">
    <xsl:for-each select="key('Part', 'word/document.xml')">
      <xsl:if test="key('footnotes', '')">
        <xsl:call-template name="InsertNotesConfigurationContent">
          <xsl:with-param name="noteType">footnote</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="key('endnotes', '')">
        <xsl:call-template name="InsertNotesConfigurationContent">
          <xsl:with-param name="noteType">endnote</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Insert text-notes-configuration element content -->

  <xsl:template name="InsertNotesConfigurationContent">
    <xsl:param name="noteType"/>
    <text:notes-configuration text:note-class="{$noteType}">
      <xsl:choose>
        <xsl:when test="$noteType='footnote' ">
          <xsl:attribute name="text:citation-style-name">FootnoteText</xsl:attribute>
          <xsl:attribute name="text:citation-body-style-name">FootnoteReference</xsl:attribute>
          <xsl:if test="not(parent::w:sectPr)">
            <xsl:attribute name="text:start-numbering-at">document</xsl:attribute>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$noteType='endnote' ">
          <xsl:attribute name="text:citation-style-name">EndnoteText</xsl:attribute>
          <xsl:attribute name="text:citation-body-style-name">EndnoteReference</xsl:attribute>
        </xsl:when>
      </xsl:choose>
    </text:notes-configuration>
  </xsl:template>

</xsl:stylesheet>
