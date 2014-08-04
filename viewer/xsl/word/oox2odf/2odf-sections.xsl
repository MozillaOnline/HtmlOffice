<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
  xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
  xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
  xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
  xmlns:oox="urn:oox"
  exclude-result-prefixes="w oox">
  <xsl:key name="elementsByOoxSectionId" match="w:body/*" use="@oox:s"/>

  <!-- 
  *************************************************************************
  MATCHING TEMPLATES
  *************************************************************************
  -->

  <!--
  Summary:  Writes a <text:section> for each sectPr that is applied.
            Sometimes it is not neccessary to write a section for each sectPr (if there is only the default sectPr)
            The decision is made by "InsertDocumentBody"
  Author:   CleverAge
  Modified: makz (DIaLOGIKa)
            Changed from <xsl:template match="w:sectPr[parent::w:pPr]" mode="sections">
  -->
  <xsl:template match="w:sectPr" mode="sections">
    <!--xsl:variable name="id">
      <xsl:value-of select="generate-id(preceding::w:p/w:pPr/w:sectPr)"/>
    </xsl:variable-->
    <xsl:variable name="id2" select="generate-id(.)"/>
    <xsl:choose>
      <xsl:when
        test="preceding::w:p[descendant::w:sectPr]/descendant::w:r[contains(w:instrText,'INDEX')]
        or parent::w:p[descendant::w:sectPr]/descendant::w:r[contains(w:instrText,'INDEX')]">
		  <!-- select all top-level body elements which are in the current section -->
          <xsl:apply-templates select="key('elementsByOoxSectionId', number(@oox:s))" />
      </xsl:when>
      <xsl:otherwise>
        <text:section text:style-name="{concat('ooc-NCNameFromString', '-oop-', $id2, '-ooe')}"
                      text:name="{concat('S_',$id2)}">
			      <!-- select all top-level body elements which are in the current section -->
            <!--xsl:apply-templates select="key('Part', 'word/document.xml')/w:document/w:body/child::node()[(generate-id(key('sectPr', number(@oox:s)))) = $id2]"/-->
			      <xsl:apply-templates select="key('elementsByOoxSectionId', number(@oox:s))"/>
        </text:section>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <!--
  Summary:  Writes a the style of the section
  Author:   CleverAge
  Modified: makz (DIaLOGIKa)
            Changed from <xsl:template match="w:sectPr[parent::w:pPr]" mode="automaticstyles">
  -->
  <xsl:template match="w:sectPr" mode="automaticstyles">
    <style:style style:name="{generate-id(.)}" style:family="section">
      <style:section-properties>
        <xsl:call-template name="InsertColumns"/>
        <xsl:call-template name="InsertSectionNotesConfig"/>
      </style:section-properties>
    </style:style>
  </xsl:template>

  <!-- 
  *************************************************************************
  CALLED TEMPLATES
  *************************************************************************
  -->
  
  <xsl:template name="InsertColumns">

    <xsl:choose>
      <xsl:when test="w:cols/@w:num">
        <style:columns>

          <xsl:attribute name="fo:column-count">
            <xsl:value-of select="w:cols/@w:num"/>
          </xsl:attribute>

          <xsl:choose>
            <xsl:when test="w:cols/@w:equalWidth = '0'"> </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="fo:column-gap">
                <xsl:value-of select="concat((w:cols/@w:space) * 2.54 div 1440.0, 'cm')"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:if test="w:cols/@w:sep = '1'">
            <style:column-sep style:width="0.002cm" style:color="#000000" style:height="100%"/>
          </xsl:if>

          <xsl:for-each select="w:cols/w:col">
            <style:column>
              <xsl:attribute name="style:rel-width">
                <xsl:variable name="width" select="./@w:w"/>
                <xsl:choose>
                  <xsl:when test="preceding-sibling::w:col[1]/@w:space">
                    <xsl:variable name="space" select="round(number(preceding-sibling::w:col[1]/@w:space) div 2)"/>
                    
                    <xsl:value-of select="concat($width + $space,'*')"/>
                  </xsl:when>
                  <xsl:when test="./@w:space">
                    <xsl:variable name="space" select="round(number(./@w:space) div 2)"/>
                    <xsl:value-of select="concat($width + $space,'*')"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$width"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>

              <xsl:attribute name="fo:start-indent">
                <xsl:value-of select="concat((format-number(preceding-sibling::w:col/@w:space div 2, '#.###')) * 2.54 div 1440.0, 'cm')" />
              </xsl:attribute>
              <xsl:attribute name="fo:end-indent">
                <xsl:value-of select="concat((format-number(./@w:space div 2, '#.###')) * 2.54 div 1440.0, 'cm')" />
              </xsl:attribute>
            </style:column>
          </xsl:for-each>
        </style:columns>
      </xsl:when>
      <xsl:otherwise>
        <style:columns>
          <xsl:attribute name="fo:column-count">
            <xsl:text>1</xsl:text>
          </xsl:attribute>
        </style:columns>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="InsertSectionNotesConfig">
    <!-- TODO : more attributes -->
    <xsl:if test="w:footnotePr/w:pos/@w:val = 'beneathText' ">
      <xsl:call-template name="InsertNotesConfigurationContent">
        <xsl:with-param name="noteType">footnote</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="w:endnotePr/w:pos/@w:val = 'sectEnd' ">
      <xsl:call-template name="InsertNotesConfigurationContent">
        <xsl:with-param name="noteType">endnote</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  
  <xsl:template match="text()" mode="sections"/>
</xsl:stylesheet>
