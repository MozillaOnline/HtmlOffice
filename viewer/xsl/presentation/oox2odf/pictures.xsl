<?xml version="1.0" encoding="utf-8"?>
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
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"
xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0"
xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0"
xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:dom="http://www.w3.org/2001/xml-events"
xmlns="http://schemas.openxmlformats.org/package/2006/relationships"
xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships"
xmlns:pzip="urn:cleverage:xmlns:post-processings:zip"
xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties"
xmlns:dc="http://purl.org/dc/elements/1.1/"
xmlns:dcterms="http://purl.org/dc/terms/"
xmlns:exsl="http://exslt.org/common"
exclude-result-prefixes="p a r xlink rels">  
  <xsl:template name="InsertPicture">
    <xsl:param name ="slideRel"/>
    <xsl:param name="audio"/>
	  <xsl:param name ="slideId"/>
	  <xsl:param name ="source"/>
<xsl:param name ="sourceName"/>
    <xsl:param name ="PicPosition"/>
    <xsl:param name ="MasterId"/>
    <xsl:param name ="srcName"/>
 <xsl:param name ="grpBln"/>
    <xsl:param name ="grpGraphicID"/>
    <xsl:param name ="grpCordinates"/>

    <!-- warn if Audio or Video -->
    <xsl:message terminate="no">translation.oox2odf.pictureTypeProperties</xsl:message>
    <xsl:variable name ="imageId">
      <xsl:value-of select ="./p:blipFill/a:blip/@r:embed"/>
    </xsl:variable>
    <xsl:variable name ="audioId">
      <xsl:if test="p:nvPicPr/p:nvPr/a:wavAudioFile">
        <xsl:value-of select ="./p:nvPicPr/p:nvPr/a:wavAudioFile/@r:embed"/>
      </xsl:if>
      <xsl:if test="p:nvPicPr/p:nvPr/a:audioFile">
        <xsl:value-of select ="./p:nvPicPr/p:nvPr/a:audioFile/@r:link"/>
      </xsl:if>
      <xsl:if test="p:nvPicPr/p:nvPr/a:videoFile">
        <xsl:value-of select ="./p:nvPicPr/p:nvPr/a:videoFile/@r:link"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name ="sourceFile">
      <xsl:for-each select ="key('Part', $slideRel)//node()[@Id = $imageId]">
        <xsl:value-of select ="@Target"/>
      </xsl:for-each>
    </xsl:variable >
    <xsl:if test="not(contains($sourceFile,'http://') or contains($sourceFile,'https://'))">
    <xsl:variable name ="targetFile">
        <xsl:value-of select ="substring-after(substring-after($sourceFile,'/'),'/')"/>
    </xsl:variable>
    <xsl:if test="not(p:nvPicPr/p:nvPr/a:audioFile or p:nvPicPr/p:nvPr/a:wavAudioFile or p:nvPicPr/p:nvPr/a:videoFile)">
        <pzip:copy pzip:source="{concat('ppt',substring-after($sourceFile,'..'))}"
             pzip:target="{concat('Pictures/',$targetFile)}"/>
    </xsl:if>
    <xsl:if test="p:nvPicPr/p:nvPr/a:audioFile or p:nvPicPr/p:nvPr/a:wavAudioFile or p:nvPicPr/p:nvPr/a:videoFile">
        <pzip:copy pzip:source="{concat('ppt',substring-after($sourceFile,'..'))}"
             pzip:target="{concat('Pictures/',$targetFile)}"/>
    </xsl:if>
    <draw:frame draw:layer="layout">
      <!--Edited by vipul to get cordinates from Layout-->
		<xsl:choose>
			<xsl:when test="$source='Layout'"/>
			<xsl:when test="$grpBln='true'"/>
			<xsl:otherwise>
		<xsl:attribute name ="draw:id"	>
					<xsl:value-of select ="concat('Picsldraw',$slideId,'an',./p:nvPicPr/p:cNvPr/@id)"/>
		</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		
 <xsl:variable  name ="GraphicId">
        <xsl:value-of select ="concat('SLPicture',$slideId,'gr',./p:nvPicPr/p:cNvPr/@id)"/>
      </xsl:variable>
      <xsl:variable  name ="masterGraphicId">
        <xsl:value-of select ="concat($MasterId,'Picture',$PicPosition,'gr')"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$sourceName='content'">
        <xsl:attribute name ="draw:style-name">
          <xsl:value-of select ="$GraphicId"/>
        </xsl:attribute >
        </xsl:when>
        <xsl:when test="$srcName='styles'">
        <xsl:attribute name ="draw:style-name">
          <xsl:value-of select ="$masterGraphicId"/>
        </xsl:attribute >
        </xsl:when>
        <xsl:when test="$grpGraphicID!=''">
          <xsl:attribute name ="draw:style-name">
            <xsl:value-of select ="$grpGraphicID"/>
          </xsl:attribute >
        </xsl:when>
      </xsl:choose>
     
      <xsl:choose>
        <xsl:when test ="p:spPr/a:xfrm/a:off">
          <xsl:choose>
            <xsl:when test="$grpBln='true'">
              <xsl:call-template name="tmpGropingWriteCordinates">
                <xsl:with-param name ="grpCordinates" select ="$grpCordinates" />
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
          <xsl:call-template name="tmpWriteCordinates"/>
            </xsl:otherwise>
          </xsl:choose>

        </xsl:when>
        <xsl:when test ="not(p:spPr/a:xfrm/a:off)">
          <xsl:variable name ="LayoutFileNo">
            <xsl:for-each select ="key('Part', $slideRel)//node()/@Target[contains(.,'slideLayouts')]">
              <xsl:value-of select ="concat('ppt',substring(.,3))"/>
            </xsl:for-each>
          </xsl:variable>
          <xsl:for-each select ="key('Part', $LayoutFileNo)/p:sldLayout/p:cSld/p:spTree/p:sp">
            <xsl:if test="p:nvSpPr/p:nvPr/p:ph[@type='pic']">
              <xsl:choose>
                <xsl:when test="$grpBln='true'">
              <xsl:call-template name="tmpWriteCordinates"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="tmpWriteCordinates"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>
      <xsl:if test="$audio='audio'">
        <xsl:variable name="audioFile">
          <xsl:if test="p:nvPicPr/p:nvPr/a:wavAudioFile or p:nvPicPr/p:nvPr/a:audioFile or p:nvPicPr/p:nvPr/a:videoFile ">
            <xsl:for-each select ="key('Part', $slideRel)//node()[@Id = $audioId]">
              <xsl:value-of select ="@Target"/>
            </xsl:for-each>
          </xsl:if>
        </xsl:variable>
        <xsl:variable name="TargetMode">
          <xsl:if test="p:nvPicPr/p:nvPr/a:wavAudioFile or p:nvPicPr/p:nvPr/a:audioFile or p:nvPicPr/p:nvPr/a:videoFile ">
            <xsl:for-each select ="key('Part', $slideRel)//node()[@Id = $audioId]">
              <xsl:value-of select ="@TargetMode"/>
            </xsl:for-each>
          </xsl:if>
        </xsl:variable>
        <xsl:variable name="audioTargetFile">
          <xsl:value-of select ="substring-after(substring-after($audioFile,'/'),'/')"/>
        </xsl:variable>
        <draw:plugin xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad" draw:mime-type="application/vnd.sun.star.media">
          <xsl:if test="p:nvPicPr/p:nvPr/a:audioFile or p:nvPicPr/p:nvPr/a:wavAudioFile or p:nvPicPr/p:nvPr/a:videoFile">
            <xsl:variable name ="destinationFile">
              <xsl:value-of select ="substring-after(substring-after($audioFile,'/'),'/')"/>
            </xsl:variable>
            <!--<xsl:attribute name ="xlink:href"  >
              <xsl:value-of select ="$destinationFile"/>
            </xsl:attribute>-->
            <xsl:if test="not(p:nvPicPr/p:nvPr/a:wavAudioFile)">
              <xsl:attribute name ="xlink:href">
                <xsl:choose>
                  <xsl:when test="$TargetMode='External'">
                    <xsl:choose>
                      <xsl:when test="contains($audioFile,'file:///')">
                        <xsl:if test="string-length(substring-after($audioFile,'file:///')) > 0">
                          <xsl:value-of select ="concat('/',translate(substring-after($audioFile,'file:///'),'\','/'))"/>
                        </xsl:if>
                      </xsl:when>
                      <xsl:when test="contains($audioFile,'http://') or contains($audioFile,'https://')">
                        <xsl:value-of select ="$audioFile"/>
                      </xsl:when>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="contains($audioFile,'file:///')">
                <xsl:if test="string-length(substring-after($audioFile,'file:///')) > 0">
                  <xsl:value-of select ="concat('/',translate(substring-after($audioFile,'file:///'),'\','/'))"/>
                </xsl:if>
                <xsl:if test="string-length(substring-after($audioFile,'file:///')) = 0 ">
                  <xsl:value-of select ="concat('../',$audioFile)"/>
                </xsl:if>
                      </xsl:when>
                      <xsl:when test="contains($audioFile,'http://') or contains($audioFile,'https://')">
                        <xsl:value-of select ="$audioFile"/>
                      </xsl:when>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="p:nvPicPr/p:nvPr/a:wavAudioFile">
              <!--<xsl:attribute name ="xlink:href"  >
                <xsl:value-of select ="concat('Pictures/',$audioTargetFile)"/>
              </xsl:attribute>-->
              <xsl:variable name="FolderNameGUID">
                <xsl:call-template name="GenerateGUIDForFolderName">
                  <xsl:with-param name="RootNode" select="." />
                </xsl:call-template>
              </xsl:variable>
              <xsl:variable name="varDestMediaFileTargetPath">
                <xsl:value-of select="concat($FolderNameGUID,'|',$audioId,'.wav')"/>
              </xsl:variable>
              <xsl:variable name="varMediaFilePathForOdp">
                <xsl:value-of select="concat('../',$FolderNameGUID,'/',$audioId,'.wav')"/>
              </xsl:variable>
              <xsl:attribute name ="xlink:href">
                <xsl:value-of select ="$varMediaFilePathForOdp"/>
              </xsl:attribute>
              <xsl:variable name="soundTargetFile">
                <xsl:value-of select="concat('ppt/',substring-after($audioFile,'/'))"/>
                <!--<xsl:value-of select="concat('ppt/media',substring-after($audioFile,'/'))"/>-->
                <!--<xsl:value-of select ="substring-after(substring-after($audioFile,'/'),'/')"/>-->
              </xsl:variable>
              <pzip:extract pzip:source="{$soundTargetFile}" pzip:target="{$varDestMediaFileTargetPath}" />
              <!--<pzip:copy pzip:source="{concat('ppt',substring-after($audioFile,'..'))}"
            pzip:target="{concat('Pictures/',$audioTargetFile)}"/>-->
            </xsl:if>
          </xsl:if>
          <draw:param draw:name="Loop" draw:value="false"/>
          <draw:param draw:name="Mute" draw:value="false"/>
          <draw:param draw:name="VolumeDB" draw:value="0"/>
        </draw:plugin>
        <!--ODF1.1 Conformance-->
          <draw:image  xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad">
            <xsl:attribute name ="xlink:href"  >
              <xsl:value-of select ="concat('Pictures/',$targetFile)"/>
            </xsl:attribute>
            <text:p />
          </draw:image>
        
        <!--<xsl:if test="p:blipFill/a:blip/@r:embed != ''">
          <draw:image  xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad">
            --><!--xlink:href="Pictures/100000000000032000000258B0234CE5.jpg"--><!--
            <xsl:attribute name ="xlink:href"  >
              <xsl:value-of select ="concat('Pictures/',$targetFile)"/>
            </xsl:attribute>
            <text:p />
          </draw:image>
        </xsl:if>-->
      </xsl:if>
      <xsl:if test="not($audio)">
        <xsl:variable name="varHyperLinksForPic">
          <!-- Added by lohith.ar - Start - Mouse click hyperlinks -->
          <office:event-listeners>
            <xsl:for-each select ="p:nvPicPr/p:cNvPr">
              <xsl:call-template name="tmpHyperLinkForShapesPic">
                <xsl:with-param name="SlideRelationId" select="$slideRel"/>
              </xsl:call-template>
            </xsl:for-each>
          </office:event-listeners>
          <!-- End - Mouse click hyperlinks-->
        </xsl:variable>
        <draw:image  xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad">
          <xsl:attribute name ="xlink:href"  >
            <xsl:value-of select ="concat('Pictures/',$targetFile)"/>
          </xsl:attribute>         
          <text:p />
        </draw:image>
          <xsl:if test="exsl:node-set($varHyperLinksForPic)//presentation:event-listener">
            <xsl:copy-of select="$varHyperLinksForPic" />
          </xsl:if>      
      </xsl:if>
    </draw:frame>
    </xsl:if>
  </xsl:template>
  <xsl:template name="tmpInsertBackImage">
    <xsl:param name ="slideRel"/>
    <xsl:param name ="idx"/>
    <xsl:param name="SMName"/>
    <xsl:param name="ThemeFile"/>
    <xsl:param name="var_pos"/>
       <!--<xsl:variable name="var_idx">
          <xsl:value-of select="number(./p:bgRef/@idx - 1000)"/>
      </xsl:variable>-->
    <xsl:variable name ="imageId">
      <xsl:choose>
        <xsl:when test="$idx &gt; 0">
          <xsl:for-each select ="key('Part', concat('ppt/theme/',substring-after($ThemeFile,'ppt/theme/')))/a:theme/a:themeElements/a:fmtScheme/a:bgFillStyleLst/child::node()[$idx]">
            <xsl:if test="name()='a:blipFill'">
              <xsl:value-of select ="./a:blip/@r:embed"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select ="./a:blipFill/a:blip/@r:embed"/>
          </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name ="sourceFile">
      <xsl:choose>
      <xsl:when test="$idx &gt; 0">
        <xsl:for-each select ="key('Part', concat('ppt/theme/_rels/',substring-after($ThemeFile,'ppt/theme/'),'.rels'))//node()[@Id = $imageId]">
          <xsl:value-of select ="@Target"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select ="key('Part', $slideRel)//node()[@Id = $imageId]">
          <xsl:value-of select ="@Target"/>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
    </xsl:variable >
    <xsl:variable name ="targetFile"> 
      <xsl:value-of select ="substring-after(substring-after($sourceFile,'/'),'/')"/>
    </xsl:variable>
    <pzip:copy pzip:source="{concat('ppt',substring-after($sourceFile,'..'))}"
				   pzip:target="{concat('Pictures/',$targetFile)}"/>
      <draw:fill-image xlink:href="Pictures/100000000000032000000258B0234CE5.jpg" xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad">
        <xsl:attribute name ="xlink:href"  >
          <xsl:value-of select ="concat('Pictures/',$targetFile)"/>
        </xsl:attribute>
        <xsl:attribute name ="draw:name">
          <xsl:value-of select ="concat($SMName,$var_pos)"/>
        </xsl:attribute>
      </draw:fill-image>
  </xsl:template>
</xsl:stylesheet>