<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
                xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
                xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:o="urn:schemas-microsoft-com:office:office"
                xmlns:v="urn:schemas-microsoft-com:vml"
                xmlns:pzip="urn:cleverage:xmlns:post-processings:zip"
                xmlns:oox="urn:oox"
                exclude-result-prefixes="o r rels w v oox">

  <!-- 
  *************************************************************************
  MATCHING TEMPLATES
  *************************************************************************
  -->

  <!--
  Summary: Converts OLE objects
  Author: makz (DIaLOGIKa)
  Date: 14.11.2007
  -->
  <xsl:template match="o:OLEObject">
    <draw:frame>
      <xsl:call-template name="InsertCommonShapeProperties">
        <xsl:with-param name="shape" select="../v:shape" />
      </xsl:call-template>
      <xsl:call-template name="InsertShapeZindexAttribute"/>

      <xsl:variable name="objectId" select="@r:id" />
      <xsl:variable name="imageId" select="../v:shape/v:imagedata/@r:id" />
      
      <!-- get the hosting document (headerX.xml, document.xml) -->
      <xsl:variable name="hostingDoc" select="ancestor::oox:part/@oox:name" />
      <xsl:variable name="relFile" select="concat('word/_rels/', concat(substring-after($hostingDoc, '/'), '.rels'))" />
      
      <xsl:variable name="objectPath" select="key('Part', $relFile)/rels:Relationships/rels:Relationship[@Id=$objectId]/@Target" />
      <xsl:variable name="imagePath" select="key('Part', $relFile)/rels:Relationships/rels:Relationship[@Id=$imageId]/@Target" />
      
      <xsl:variable name="objectName">
        <xsl:choose>
          <!-- Internal object -->
          <xsl:when test="@Type='Embed'">
            <xsl:value-of select="substring-after($objectPath, 'embeddings/')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('Object ', generate-id(.), '.bin')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="newName" select="substring-before($objectName, '.')" />
      <xsl:variable name="suffix" select="translate(substring-after($objectName, '.'), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')" />

      <!-- fidelity loss messages -->
      <xsl:if test="contains($objectPath, '\\')">
        <xsl:message terminate="no">translation.oox2odf.oleNetworkPath</xsl:message>
      </xsl:if>
      <xsl:if test="@Type='Embed' and ($suffix='docx' or $suffix='xlsx' or $suffix='pptx')">
        <xsl:message terminate="no">translation.oox2odf.oleOoxObject</xsl:message>
      </xsl:if>

      <xsl:call-template name="InsertObject">
        <xsl:with-param name="oldFilePath" select="$objectPath" />
        <xsl:with-param name="oldFileName" select="$objectName" />
        <xsl:with-param name="newFileName" select="$newName" />
      </xsl:call-template>
      <xsl:call-template name="InsertObjectPreview">
        <xsl:with-param name="imageFilePath" select="$imagePath" />
        <xsl:with-param name="newFileName" select="$newName" />
      </xsl:call-template>
    </draw:frame>
  </xsl:template>

  <!--
  Summary: Converts the style for OLE objects
  Author: makz (DIaLOGIKa)
  Date: 14.11.2007
  -->
  <xsl:template match="o:OLEObject" mode="automaticstyles">
    <style:style style:family="graphic" 
                 style:parent-style-name="Frame"
                 style:name="{generate-id(../v:shape)}">

      <style:graphic-properties>
        <xsl:call-template name="InsertShapeStyleProperties">
          <xsl:with-param name="shape" select="../v:shape" />
        </xsl:call-template>
      </style:graphic-properties>
    </style:style>
  </xsl:template>

  <!-- currently ignore field codes in OLE objects 
       and prevent adding the code to the output document -->
  <xsl:template match="o:FieldCodes" />
  <xsl:template match="o:FieldCodes" mode="trackchanges" />

  <!-- 
  *************************************************************************
  CALLED TEMPLATES
  *************************************************************************
  -->

  <xsl:template name="InsertOlePreviewName">
    <xsl:param name="thisId" />
    <xsl:param name="relFile" />

    <!-- get the hosting document (headerX.xml, document.xml) -->
    <xsl:variable name="hostingDoc">
      <xsl:call-template name="substring-after-last">
        <xsl:with-param name ="string" select="substring-before($relFile, '.rels')" />
        <xsl:with-param name="occurrence" select="'/'" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="olePreview" select="key('Part', concat('word/',$hostingDoc))//v:shape/v:imagedata[@r:id=$thisId]" />
    <xsl:variable name="oleId" select="$olePreview/../../o:OLEObject/@r:id" />
    <xsl:variable name="allRels" select="key('Part', $relFile)/rels:Relationships/rels:Relationship" />
    <xsl:variable name="previewRelTarget" select="$allRels[@Id=$oleId]/@Target" />

    <xsl:value-of select="substring-before(substring-after($previewRelTarget, '/'), '.')" />
  </xsl:template>
 
  
  <!--
  Summary: inserts the object itself
  Author: makz (DIaLOGIKa)
  Date: 14.11.2007
  -->
  <xsl:template name="InsertObject">
    <xsl:param name="oldFilePath" />
    <xsl:param name="newFileName" />

    <xsl:choose>
      <!-- it's an embedded object -->
      <xsl:when test="@Type='Embed'">
        <!-- copy the embedded object -->
        <pzip:copy pzip:source="{concat('word/', $oldFilePath)}" pzip:target="{$newFileName}"/>
        
        <draw:object-ole xlink:show="embed" 
                         xlink:type="simple" 
                         xlink:actuate="onLoad"
                         xlink:href="{concat('./', $newFileName)}" />
      </xsl:when>
      <!-- it's an external object -->
      <xsl:otherwise>
        <draw:object xlink:show="embed" 
                     xlink:type="simple" 
                     xlink:actuate="onLoad"
                     xlink:href="{concat('ooc-UriFromPath', '-oop-', $oldFilePath, '-ooe')}" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
  Summary: inserts the preview picture of the object
  Author: makz (DIaLOGIKa)
  Date: 14.11.2007
  -->
  <xsl:template name="InsertObjectPreview">
    <xsl:param name="imageFilePath" />
    <xsl:param name="newFileName" />

    <xsl:variable name="suffix" select="substring-after($imageFilePath, '.')" />
    
    <draw:image xlink:show="embed" 
                xlink:type="simple" 
                xlink:actuate="onLoad"
                xlink:href="{concat('./ObjectReplacements/', $newFileName)}">
      
      <!-- copy placeholder for unsupported images -->
      <xsl:choose>
        <!--
        <xsl:when test="$suffix='wmf' or $suffix='emf'">
        -->
        <xsl:when test="$suffix='xxx'">
          <pzip:copy pzip:source="#CER#WordprocessingConverter.dll#OdfConverter.Wordprocessing.resources.OLEplaceholder.png#"
                     pzip:target="{concat('ObjectReplacements/', $newFileName)}" />
        </xsl:when>

        <xsl:otherwise>
          <pzip:copy pzip:source="{concat('word/', $imageFilePath)}"
                     pzip:target="{concat('ObjectReplacements/', $newFileName)}" />
        </xsl:otherwise>
      </xsl:choose>
      
    </draw:image>
  </xsl:template>
  
</xsl:stylesheet>