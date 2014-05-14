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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
xmlns:manifest="urn:oasis:names:tc:opendocument:xmlns:manifest:1.0"
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
exclude-result-prefixes="p a r xlink ">
	<xsl:template name="getColorCode">
		<xsl:param name="color"/>
		<xsl:param name ="lumMod"/>
		<xsl:param name ="lumOff"/>
                <xsl:param  name ="shade"/>
    <xsl:param name ="tint"/>
    <xsl:param name ="SMName"/>
    <xsl:message terminate="no">progress:a:p</xsl:message>
		<xsl:message terminate="no">progress:p:cSld</xsl:message>
    <xsl:variable name ="SMRel" >
      <xsl:value-of select ="concat('ppt/slideMasters/_rels/',$SMName,'.rels')"/>
    </xsl:variable>
    <xsl:variable name ="ThemeName" >
      <xsl:for-each select ="key('Part', $SMRel)//node()/@Target[contains(.,'theme')]">
        <xsl:value-of  select="substring-after(.,'../theme/')"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="themeFileName">
      <xsl:choose>
        <xsl:when test="$ThemeName!=''">
          <xsl:value-of select="concat('ppt/theme/',$ThemeName)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'ppt/theme/theme1.xml'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
		<xsl:variable name ="ThemeColor">
			<xsl:for-each select ="key('Part', $themeFileName)/a:theme/a:themeElements/a:clrScheme">
				<xsl:for-each select ="node()">
					<xsl:if test ="name() =concat('a:',$color)">
						<xsl:choose >
							<xsl:when test ="contains(node()/@val,'window') ">
								<xsl:value-of select ="node()/@lastClr"/>
							</xsl:when>
							<xsl:otherwise >
								<xsl:value-of select ="node()/@val"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>			
		</xsl:variable>
		<xsl:variable name ="BgTxColors">
			<xsl:if test ="$color ='bg2'">
				<xsl:value-of select ="key('Part', 'ppt/theme/theme1.xml') //a:lt2/a:srgbClr/@val"/>
			</xsl:if>
			<xsl:if test ="$color ='bg1'">
				<!--<xsl:value-of select ="key('Part', 'ppt/theme/theme1.xml') //a:lt1/node()/@lastClr" />-->
				<xsl:choose>
					<xsl:when test ="key('Part', 'ppt/theme/theme1.xml') //a:lt1/a:srgbClr/@val">
						<xsl:value-of select ="key('Part', 'ppt/theme/theme1.xml') //a:lt1/a:srgbClr/@val" />
					</xsl:when>
					<xsl:when test="key('Part', 'ppt/theme/theme1.xml') //a:lt1/node()/@lastClr">
						<xsl:value-of select ="key('Part', 'ppt/theme/theme1.xml') //a:lt1/node()/@lastClr" />
					</xsl:when>
				</xsl:choose>
			</xsl:if>
			<!--<xsl:if test ="$color ='tx1'">
				<xsl:value-of select ="key('Part', 'ppt/theme/theme1.xml') //a:dk1/node()/@lastClr"/>
			</xsl:if>-->
			<xsl:if test ="$color ='tx1'">
				<xsl:choose>
					<xsl:when test ="key('Part', 'ppt/theme/theme1.xml') //a:dk1/node()/@lastClr">
					<xsl:value-of select ="key('Part', 'ppt/theme/theme1.xml') //a:dk1/node()/@lastClr"/>
					</xsl:when>
				<xsl:when test ="key('Part', 'ppt/theme/theme1.xml') //a:dk1/node()/@val">
					<xsl:value-of select ="key('Part', 'ppt/theme/theme1.xml') //a:dk1/node()/@val"/>
				</xsl:when>
				</xsl:choose>
			</xsl:if>
			<xsl:if test ="$color ='tx2'">
				<xsl:value-of select ="key('Part', 'ppt/theme/theme1.xml') //a:dk2/a:srgbClr/@val"/>
			</xsl:if>			
		</xsl:variable>
		<xsl:variable name ="NewColor">
			<xsl:if test ="$ThemeColor != ''">
				<xsl:value-of select ="$ThemeColor"/>
			</xsl:if>
			<xsl:if test ="$BgTxColors !=''">
				<xsl:value-of select ="$BgTxColors"/>
			</xsl:if>
		</xsl:variable>
		<xsl:call-template name ="ConverThemeColor">
			<xsl:with-param name="color" select="$NewColor" />
			<xsl:with-param name ="lumMod" select ="$lumMod"/>
			<xsl:with-param name ="lumOff" select ="$lumOff"/>
                        <xsl:with-param name ="shade" select ="$shade"/>
      <xsl:with-param name ="tint" select ="$tint"/>
		</xsl:call-template>
	</xsl:template >
	<xsl:template name="ConvertEmu">
		<xsl:param name="length" />
		<xsl:param name="unit" />
		<xsl:message terminate="no">progress:p:cSld</xsl:message>
		<xsl:choose>
			<xsl:when test="$length = '' or not($length) or $length = 0 or format-number($length div 360000, '#.##') = ''">
				<xsl:value-of select="concat(0,'cm')" />
			</xsl:when>
			<xsl:when test="$unit = 'cm'">
				<xsl:value-of select="concat(format-number($length div 360000, '#.##'), 'cm')" />
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="InsertWhiteSpaces">
		<xsl:param name="string" select="."/>
		<xsl:param name="length" select="string-length(.)"/>
		<xsl:message terminate="no">progress:p:cSld</xsl:message>
		<!-- string which doesn't contain whitespaces-->
		<xsl:choose>
			<xsl:when test="not(contains($string,' '))">
				<xsl:value-of select="$string"/>
			</xsl:when>
			<!-- convert white spaces  -->
			<xsl:otherwise>
				<xsl:variable name="before">
					<xsl:value-of select="substring-before($string,' ')"/>
				</xsl:variable>
				<xsl:variable name="after">
					<xsl:call-template name="CutStartSpaces">
						<xsl:with-param name="cuted">
							<xsl:value-of select="substring-after($string,' ')"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$before != '' ">
					<xsl:value-of select="concat($before,' ')"/>
				</xsl:if>
				<!--add remaining whitespaces as text:s if there are any-->
				<xsl:if test="string-length(concat($before,' ', $after)) &lt; $length ">
					<xsl:choose>
						<xsl:when test="($length - string-length(concat($before, $after))) = 1">
							<text:s/>
						</xsl:when>
						<xsl:otherwise>
							<text:s>
								<xsl:attribute name="text:c">
									<xsl:choose>
										<xsl:when test="$before = ''">
											<xsl:value-of select="$length - string-length($after)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$length - string-length(concat($before,' ', $after))"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
							</text:s>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<!--repeat it for substring which has whitespaces-->
				<xsl:if test="contains($string,' ') and $length &gt; 0">
					<xsl:call-template name="InsertWhiteSpaces">
						<xsl:with-param name="string">
							<xsl:value-of select="$after"/>
						</xsl:with-param>
						<xsl:with-param name="length">
							<xsl:value-of select="string-length($after)"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="CutStartSpaces">
		<xsl:param name="cuted"/>
		<xsl:choose>
			<xsl:when test="starts-with($cuted,' ')">
				<xsl:call-template name="CutStartSpaces">
					<xsl:with-param name="cuted">
						<xsl:value-of select="substring-after($cuted,' ')"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$cuted"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="ConverThemeColor">
		<xsl:param name="color"/>
		<xsl:param name ="lumMod"/>
		<xsl:param name ="lumOff"/>
                <xsl:param name ="shade"/>
    <xsl:param name ="tint"/>

		<xsl:message terminate="no">progress:p:cSld</xsl:message>
		<xsl:variable name ="Red">
			<xsl:call-template name ="HexToDec">
				<xsl:with-param name ="number" select ="substring($color,1,2)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name ="Green">
			<xsl:call-template name ="HexToDec">
				<xsl:with-param name ="number" select ="substring($color,3,2)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name ="Blue">
			<xsl:call-template name ="HexToDec">
				<xsl:with-param name ="number" select ="substring($color,5,2)"/>
			</xsl:call-template>
		</xsl:variable>
    <xsl:choose>
      <xsl:when test="$shade!='' and $tint=''">
      <xsl:call-template name ="calculateShade">
        <xsl:with-param name ="Red" select ="$Red" />
        <xsl:with-param name ="Green" select ="$Green"/>
        <xsl:with-param name ="Blue" select ="$Blue"/>
        <xsl:with-param name ="shade" select ="$shade"/>
      </xsl:call-template >
      </xsl:when>
      <xsl:when test="$tint!='' and $shade=''">
        <!--<xsl:value-of select="'#FFFF00'"/>-->
        <xsl:call-template name="CalculateTintedColor">
          <xsl:with-param name="color" select="$color"/>
          <xsl:with-param name="tint" select="$tint"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$tint='' and $shade=''">
		<xsl:choose >
			<xsl:when test ="$lumOff = '' and $lumMod != '' ">
				<xsl:variable name ="NewRed">
					<xsl:value-of  select =" floor($Red * $lumMod div 100000) "/>
				</xsl:variable>
				<xsl:variable name ="NewGreen">
					<xsl:value-of  select =" floor($Green * $lumMod div 100000)"/>
				</xsl:variable>
				<xsl:variable name ="NewBlue">
					<xsl:value-of  select =" floor($Blue * $lumMod div 100000)"/>
				</xsl:variable>
				<xsl:call-template name ="CreateRGBColor">
					<xsl:with-param name ="Red" select ="$NewRed"/>
					<xsl:with-param name ="Green" select ="$NewGreen"/>
					<xsl:with-param name ="Blue" select ="$NewBlue"/>
				</xsl:call-template>
			</xsl:when>			
			<xsl:when test ="$lumMod = '' and $lumOff != ''">
				<!-- TBD Not sure whether this condition will occure-->
			</xsl:when>
			<xsl:when test ="$lumMod = '' and $lumOff =''">
				<xsl:value-of  select ="concat('#',$color)"/>
			</xsl:when>
			<xsl:when test ="$lumOff != '' and $lumMod!= '' ">
				<xsl:variable name ="NewRed">
					<xsl:value-of select ="floor(((255 - $Red) * (1 - ($lumMod  div 100000)))+ $Red )"/>
				</xsl:variable>
				<xsl:variable name ="NewGreen">
					<xsl:value-of select ="floor(((255 - $Green) * ($lumOff  div 100000)) + $Green )"/>
				</xsl:variable>
				<xsl:variable name ="NewBlue">
					<xsl:value-of select ="floor(((255 - $Blue) * ($lumOff div 100000)) + $Blue) "/>
				</xsl:variable>
				<xsl:call-template name ="CreateRGBColor">
					<xsl:with-param name ="Red" select ="$NewRed"/>
					<xsl:with-param name ="Green" select ="$NewGreen"/>
					<xsl:with-param name ="Blue" select ="$NewBlue"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
      </xsl:when>
    </xsl:choose>


  </xsl:template>
  <xsl:template name="CalculateTintedColor">
    <xsl:param name="color"/>
    <xsl:param name="tint"/>

    <xsl:variable name="HLSMAX" select="255"/>

    <xsl:variable name="hls">
      <xsl:call-template name="RGBtoHLS">
        <xsl:with-param name="rgb" select="$color"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="hue">
      <xsl:value-of select="substring-before($hls,',')"/>
    </xsl:variable>
    <xsl:variable name="lum">
      <xsl:value-of select="substring-before(substring-after($hls,','),',')"/>
    </xsl:variable>
    <xsl:variable name="sat">
      <xsl:value-of select="substring-after(substring-after($hls,','),',')"/>
    </xsl:variable>

    <xsl:variable name="newLum">
      <xsl:choose>
        <xsl:when test="$tint &lt; 0">
          <xsl:value-of select="floor($lum * (1 + $tint))"/>
        </xsl:when>
        <xsl:when test="$tint > 0">
          <xsl:value-of select="floor($lum * (1 - $tint) + ($HLSMAX - $HLSMAX * (1 - $tint)))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$lum"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="rgb">
      <xsl:call-template name="HLStoRGB">
        <xsl:with-param name="hls">
          <xsl:value-of select="concat($hue,',',$newLum,',',$sat)"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="red">
      <xsl:call-template name="DecToHex">
        <xsl:with-param name="number">
          <xsl:value-of select="substring-before($rgb,',')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="green">
      <xsl:call-template name="DecToHex">
        <xsl:with-param name="number">
          <xsl:value-of select="substring-before(substring-after($rgb,','),',')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="blue">
      <xsl:call-template name="DecToHex">
        <xsl:with-param name="number">
          <xsl:value-of select="substring-after(substring-after($rgb,','),',')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:value-of select="concat('#',$red,$green,$blue)"/>

  </xsl:template>
  <xsl:template name="RGBtoHLS">
    <xsl:param name="rgb"/>

    <xsl:variable name="HLSMAX" select="255"/>
    <xsl:variable name="RGBMAX" select="255"/>
    <xsl:variable name="UNDEFINED">
      <xsl:value-of select="$HLSMAX * 2 div 3"/>
    </xsl:variable>

    <xsl:variable name="r">
      <xsl:call-template name="HexToDec">
        <xsl:with-param name="number">
          <xsl:value-of select="substring($rgb,1,2)"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="g">
      <xsl:call-template name="HexToDec">
        <xsl:with-param name="number">
          <xsl:value-of select="substring($rgb,3,2)"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="b">
      <xsl:call-template name="HexToDec">
        <xsl:with-param name="number">
          <xsl:value-of select="substring($rgb,5,2)"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="max">
      <xsl:choose>
        <xsl:when test="$r &gt; $g">
          <xsl:choose>
            <xsl:when test="$r &gt; $b">
              <xsl:value-of select="$r"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$b"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$g &gt; $b">
              <xsl:value-of select="$g"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$b"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="min">
      <xsl:choose>
        <xsl:when test="$r &lt; $g">
          <xsl:choose>
            <xsl:when test="$r &lt; $b">
              <xsl:value-of select="$r"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$b"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$g &lt; $b">
              <xsl:value-of select="$g"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$b"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="l">
      <xsl:value-of select="floor(( (($max + $min) * $HLSMAX) + $RGBMAX ) div (2 * $RGBMAX))"/>
    </xsl:variable>

    <xsl:variable name="s">
      <xsl:choose>
        <xsl:when test="$max = $min">
          <xsl:text>0</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="($l &lt; ($HLSMAX div 2)) or ($l = ($HLSMAX div 2))">
              <xsl:value-of
                select="floor(( (($max - $min) * $HLSMAX) + (($max + $min) div 2) ) div ($max + $min))"
              />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="floor(( (($max - $min) * $HLSMAX) + ((2 * $RGBMAX - $max - $min) div 2) ) div (2 * $RGBMAX - $max - $min))"
              />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="Rdelta">
      <xsl:value-of
        select="( (($max - $r) * ($HLSMAX div 6)) + (($max - $min) div 2) ) div ($max - $min)"/>
    </xsl:variable>
    <xsl:variable name="Gdelta">
      <xsl:value-of
        select="( (($max - $g) * ($HLSMAX div 6)) + (($max - $min) div 2) ) div ($max - $min)"/>
    </xsl:variable>
    <xsl:variable name="Bdelta">
      <xsl:value-of
        select="( (($max - $b) * ($HLSMAX div 6)) + (($max - $min) div 2) ) div ($max - $min)"/>
    </xsl:variable>

    <xsl:variable name="h_part">
      <xsl:choose>
        <xsl:when test="$max = $min">
          <xsl:value-of select="$UNDEFINED"/>
        </xsl:when>
        <xsl:when test="$r = $max">
          <xsl:value-of select="$Bdelta - $Gdelta"/>
        </xsl:when>
        <xsl:when test="$g = $max">
          <xsl:value-of select="($HLSMAX div 3) + $Rdelta - $Bdelta"/>
        </xsl:when>
        <xsl:when test="$b = $max">
          <xsl:value-of select="((2 * $HLSMAX) div 3) + $Gdelta - $Rdelta"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="h">
      <xsl:choose>
        <xsl:when test="$h_part &lt; 0">
          <xsl:value-of select="floor($h_part + $HLSMAX)"/>
        </xsl:when>
        <xsl:when test="$h_part &gt; $HLSMAX">
          <xsl:value-of select="floor($h_part - $HLSMAX)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="floor($h_part)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="concat($h,',',$l,',',$s)"/>
  </xsl:template>
  <xsl:template name="HLStoRGB">
    <xsl:param name="hls"/>

    <xsl:variable name="HLSMAX" select="255"/>
    <xsl:variable name="RGBMAX" select="255"/>

    <xsl:variable name="hue">
      <xsl:value-of select="substring-before($hls,',')"/>
    </xsl:variable>
    <xsl:variable name="lum">
      <xsl:value-of select="substring-before(substring-after($hls,','),',')"/>
    </xsl:variable>
    <xsl:variable name="sat">
      <xsl:value-of select="substring-after(substring-after($hls,','),',')"/>
    </xsl:variable>

    <xsl:variable name="magic2">
      <xsl:choose>
        <xsl:when test="$lum &gt; $HLSMAX div 2">
          <xsl:value-of select="$lum + $sat - (($lum * $sat) + ($HLSMAX div 2)) div $HLSMAX"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="($lum * ($HLSMAX + $sat) + ($HLSMAX div 2)) div $HLSMAX"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="magic1">
      <xsl:value-of select="2 * $lum - $magic2"/>
    </xsl:variable>

    <xsl:variable name="red">
      <xsl:choose>
        <xsl:when test="$sat = 0">
          <xsl:value-of select="($lum * $RGBMAX) div $HLSMAX"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="hueR">
            <xsl:call-template name="HueToRGB">
              <xsl:with-param name="n1">
                <xsl:value-of select="$magic1"/>
              </xsl:with-param>
              <xsl:with-param name="n2">
                <xsl:value-of select="$magic2"/>
              </xsl:with-param>
              <xsl:with-param name="hue">
                <xsl:value-of select="$hue + ($HLSMAX div 3)"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="($hueR * $RGBMAX + ($HLSMAX div 2)) div $HLSMAX"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="green">
      <xsl:choose>
        <xsl:when test="$sat = 0">
          <xsl:value-of select="($lum * $RGBMAX) div $HLSMAX"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="hueG">
            <xsl:call-template name="HueToRGB">
              <xsl:with-param name="n1">
                <xsl:value-of select="$magic1"/>
              </xsl:with-param>
              <xsl:with-param name="n2">
                <xsl:value-of select="$magic2"/>
              </xsl:with-param>
              <xsl:with-param name="hue">
                <xsl:value-of select="$hue"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="($hueG * $RGBMAX + ($HLSMAX div 2)) div $HLSMAX"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="blue">
      <xsl:choose>
        <xsl:when test="$sat = 0">
          <xsl:value-of select="($lum * $RGBMAX) div $HLSMAX"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="hueB">
            <xsl:call-template name="HueToRGB">
              <xsl:with-param name="n1">
                <xsl:value-of select="$magic1"/>
              </xsl:with-param>
              <xsl:with-param name="n2">
                <xsl:value-of select="$magic2"/>
              </xsl:with-param>
              <xsl:with-param name="hue">
                <xsl:value-of select="$hue - ($HLSMAX div 3)"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="($hueB * $RGBMAX + ($HLSMAX div 2)) div $HLSMAX"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="concat(floor($red),',',floor($green),',',floor($blue))"/>
  </xsl:template>
  <xsl:template name="HueToRGB">
    <xsl:param name="n1"/>
    <xsl:param name="n2"/>
    <xsl:param name="hue"/>

    <xsl:variable name="HLSMAX" select="255"/>

    <xsl:variable name="h">
      <xsl:choose>
        <xsl:when test="$hue &lt; 0">
          <xsl:value-of select="$hue + $HLSMAX"/>
        </xsl:when>
        <xsl:when test="$hue &gt; $HLSMAX">
          <xsl:value-of select="$hue - $HLSMAX"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$hue"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$h &lt; ($HLSMAX div 6)">
        <xsl:value-of select="$n1 + ((($n2 - $n1) * $h + ($HLSMAX div 12)) div ($HLSMAX div 6))"/>
      </xsl:when>
      <xsl:when test="$h &lt; ($HLSMAX div 2)">
        <xsl:value-of select="$n2"/>
      </xsl:when>
      <xsl:when test="$h &lt; (($HLSMAX * 2) div 3)">
        <xsl:value-of
          select="$n1 + ((($n2 - $n1) * ((($HLSMAX * 2) div 3) - $h) + ($HLSMAX div 12)) div ($HLSMAX div 6))"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$n1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name ="calculateShade">
    <xsl:param name ="Red"/>
    <xsl:param name ="Green"/>
    <xsl:param name ="Blue"/>
    <xsl:param name ="shade"/>
    <xsl:value-of select ="concat('shade-tint:',$Red,':',$Green,':',$Blue ,':',$shade )"/>
	</xsl:template>
	<!-- Converts Decimal values to RGB color -->
	<xsl:template name ="CreateRGBColor">
		<xsl:param name ="Red"/>
		<xsl:param name ="Green"/>
		<xsl:param name ="Blue"/>
		<xsl:message terminate="no">progress:p:cSld</xsl:message>
		<xsl:variable name ="NewRed">
			<xsl:call-template name ="DecToHex">
				<xsl:with-param name ="number" select ="$Red"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name ="NewGreen">
			<xsl:call-template name ="DecToHex">
				<xsl:with-param name ="number" select ="$Green"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name ="NewBlue">
			<xsl:call-template name ="DecToHex">
				<xsl:with-param name ="number" select ="$Blue"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
		<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
		<xsl:value-of  select ="translate(concat('#',$NewRed,$NewGreen,$NewBlue),ucletters,lcletters)"/>
	</xsl:template>
	<!-- Converts Hexa Decimal Value to Decimal-->
	<xsl:template name="HexToDec">
		<!-- @Description: This is a recurive algorithm converting a hex to decimal -->
		<!-- @Context: None -->
		<xsl:param name="number"/>
		<!-- (string|number) The hex number to convert -->
		<xsl:param name="step" select="0"/>
		<!-- (number) The exponent (only used during convertion)-->
		<xsl:param name="value" select="0"/>
		<!-- (number) The result from the previous digit's convertion (only used during convertion) -->
		<xsl:variable name="number1">
			<!-- translates all letters to lower case -->
			<xsl:value-of select="translate($number,'ABCDEF','abcdef')"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length($number1) &gt; 0">
				<xsl:variable name="one">
					<!-- The last digit in the hex number -->
					<xsl:choose>
						<xsl:when test="substring($number1,string-length($number1) ) = 'a'">
							<xsl:text>10</xsl:text>
						</xsl:when>
						<xsl:when test="substring($number1,string-length($number1)) = 'b'">
							<xsl:text>11</xsl:text>
						</xsl:when>
						<xsl:when test="substring($number1,string-length($number1)) = 'c'">
							<xsl:text>12</xsl:text>
						</xsl:when>
						<xsl:when test="substring($number1,string-length($number1)) = 'd'">
							<xsl:text>13</xsl:text>
						</xsl:when>
						<xsl:when test="substring($number1,string-length($number1)) = 'e'">
							<xsl:text>14</xsl:text>
						</xsl:when>
						<xsl:when test="substring($number1,string-length($number1)) = 'f'">
							<xsl:text>15</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring($number1,string-length($number1))"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="power">
					<!-- The result of the exponent calculation -->
					<xsl:call-template name="Power">
						<xsl:with-param name="base">16</xsl:with-param>
						<xsl:with-param name="exponent">
							<xsl:value-of select="number($step)"/>
						</xsl:with-param>
						<xsl:with-param name="value1">16</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="string-length($number1) = 1">
						<xsl:value-of select="($one * $power )+ number($value)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="HexToDec">
							<xsl:with-param name="number">
								<xsl:value-of select="substring($number1,1,string-length($number1) - 1)"/>
							</xsl:with-param>
							<xsl:with-param name="step">
								<xsl:value-of select="number($step) + 1"/>
							</xsl:with-param>
							<xsl:with-param name="value">
								<xsl:value-of select="($one * $power) + number($value)"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- Converts Decimal Value to Hexadecimal-->
	<xsl:template name="DecToHex">
		<xsl:param name="number"/>
		<xsl:variable name="high">
			<xsl:call-template name="HexMap">
				<xsl:with-param name="value">
					<xsl:value-of select="floor($number div 16)"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="low">
			<xsl:call-template name="HexMap">
				<xsl:with-param name="value">
					<xsl:value-of select="$number mod 16"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="concat($high,$low)"/>
	</xsl:template>
	<!-- calculates power function -->
	<xsl:template name="HexMap">
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="$value = 10">
				<xsl:text>A</xsl:text>
			</xsl:when>
			<xsl:when test="$value = 11">
				<xsl:text>B</xsl:text>
			</xsl:when>
			<xsl:when test="$value = 12">
				<xsl:text>C</xsl:text>
			</xsl:when>
			<xsl:when test="$value = 13">
				<xsl:text>D</xsl:text>
			</xsl:when>
			<xsl:when test="$value = 14">
				<xsl:text>E</xsl:text>
			</xsl:when>
			<xsl:when test="$value = 15">
				<xsl:text>F</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="Power">
		<xsl:param name="base"/>
		<xsl:param name="exponent"/>
		<xsl:param name="value1" select="$base"/>
		<xsl:choose>
			<xsl:when test="$exponent = 0">
				<xsl:text>1</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$exponent &gt; 1">
						<xsl:call-template name="Power">
							<xsl:with-param name="base">
								<xsl:value-of select="$base"/>
							</xsl:with-param>
							<xsl:with-param name="exponent">
								<xsl:value-of select="$exponent -1"/>
							</xsl:with-param>
							<xsl:with-param name="value1">
								<xsl:value-of select="$value1 * $base"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$value1"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
  <!-- Added by Vipul-->
  <!--Start-->
  <xsl:template name="tmpWriteCordinates">
    <xsl:message terminate="no">progress:a:p</xsl:message>
    <xsl:message terminate="no">progress:p:cSld</xsl:message>
    <xsl:for-each select ="p:spPr">
      <xsl:choose>
        <xsl:when test="a:xfrm/@rot and not((parent::node()/p:nvSpPr/p:cNvPr/@name[contains(., 'bentUpArrow ')]) and (a:xfrm/@rot='5400000'))">
          <xsl:variable name ="xCenter">
            <xsl:value-of select ="a:xfrm/a:ext/@cx"/>
          </xsl:variable>
          <xsl:variable name ="yCenter">
            <xsl:value-of select ="a:xfrm/a:ext/@cy"/>
          </xsl:variable>
          <xsl:variable name ="angle">
            <xsl:if test ="not(a:xfrm/@rot)">
              <xsl:value-of select="'0'"/>
            </xsl:if>
            <xsl:if test ="a:xfrm/@rot">
              <xsl:value-of select ="a:xfrm/@rot"/>
            </xsl:if>
          </xsl:variable>
          <xsl:variable name ="xCord">
            <xsl:if test ="a:xfrm/a:off/@x">
              <xsl:value-of select ="a:xfrm/a:off/@x"/>
            </xsl:if>
            <xsl:if test ="not(a:xfrm/a:off/@x)">
              <xsl:value-of select ="'0'"/>
            </xsl:if>
          </xsl:variable>
          <xsl:variable name ="yCord">
            <xsl:if test ="a:xfrm/a:off/@y">
              <xsl:value-of select ="a:xfrm/a:off/@y"/>
            </xsl:if>
            <xsl:if test ="not(a:xfrm/a:off/@y)">
              <xsl:value-of select ="'0'"/>
            </xsl:if>
          </xsl:variable>
          <xsl:variable name ="var_flipH">
            <xsl:if test ="a:xfrm/@flipH">
              <xsl:value-of select ="a:xfrm/@flipH"/>
            </xsl:if>
            <xsl:if test ="not(a:xfrm/@flipH)">
              <xsl:value-of select ="'0'"/>
            </xsl:if>
          </xsl:variable>
          <xsl:variable name ="var_flipV">
            <xsl:if test ="a:xfrm/@flipV">
              <xsl:value-of select ="a:xfrm/@flipV"/>
            </xsl:if>
            <xsl:if test ="not(a:xfrm/@flipV)">
              <xsl:value-of select ="'0'"/>
            </xsl:if>
          </xsl:variable>
          <xsl:attribute name ="draw:transform">
            <xsl:value-of select ="concat('draw-transform:',$xCord, ':',$yCord, ':',$xCenter, ':', $yCenter, ':', $var_flipH, ':', $var_flipV, ':', $angle)"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name ="svg:x">
            <xsl:call-template name="ConvertEmu">
              <xsl:with-param name="length" select="a:xfrm/a:off/@x"/>
              <xsl:with-param name="unit">cm</xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name ="svg:y">
            <xsl:call-template name="ConvertEmu">
              <xsl:with-param name="length" select="a:xfrm/a:off/@y"/>
              <xsl:with-param name="unit">cm</xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:attribute name ="svg:width">
        <xsl:call-template name="ConvertEmu">
          <xsl:with-param name="length" select="a:xfrm/a:ext/@cx"/>
          <xsl:with-param name="unit">cm</xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name ="svg:height">
        <xsl:call-template name="ConvertEmu">
          <xsl:with-param name="length" select="a:xfrm/a:ext/@cy"/>
          <xsl:with-param name="unit">cm</xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="tmpGropingWriteCordinates">
    <xsl:param name ="grpCordinates" />
    <xsl:param name ="ShapeType" />
    <xsl:param name ="isOLE" />
    <xsl:message terminate="no">progress:p:cSld</xsl:message>
     
       <xsl:variable name="spCordinates">
             <xsl:choose>
        <xsl:when test="$isOLE='true'">
          <xsl:for-each select ="p:xfrm">
            <xsl:call-template name="tmpGetGroupCord"/>
          </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
          <xsl:for-each select ="p:spPr/a:xfrm">
            <xsl:call-template name="tmpGetGroupCord"/>
          </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
        </xsl:variable>
    <xsl:choose>
      <xsl:when test="$ShapeType='Line'">
        <xsl:attribute name ="svg:x2">
          <xsl:value-of  select="concat('Group-TransformX2@',$grpCordinates,'$',$spCordinates,':Line')"/>
        </xsl:attribute>
        <xsl:attribute name ="svg:y2">
          <xsl:value-of  select="concat('Group-TransformY2@',$grpCordinates,'$',$spCordinates,':Line')"/>
            </xsl:attribute>
                    <xsl:attribute name ="svg:x1">
          <xsl:value-of  select="concat('Group-TransformX1@',$grpCordinates,'$',$spCordinates,':Line')"/>
            </xsl:attribute>
            <xsl:attribute name ="svg:y1">
          <xsl:value-of  select="concat('Group-TransformY1@',$grpCordinates,'$',$spCordinates,':Line')"/>
            </xsl:attribute>
               </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name ="svg:width">
          <xsl:value-of  select="concat('Group-TransformWidth@',$grpCordinates,'$',$spCordinates)"/>
      </xsl:attribute>
        <xsl:attribute name ="svg:height">
          <xsl:value-of  select="concat('Group-TransformHeight@',$grpCordinates,'$',$spCordinates)"/>
        </xsl:attribute>

      <xsl:choose>
          <xsl:when test="p:spPr/a:xfrm/@rot or contains($grpCordinates,'YESROTATION')">
          <xsl:attribute name ="draw:transform">
              <xsl:value-of  select="concat('Group-TransformDrawTranform@',$grpCordinates,'$',$spCordinates)"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name ="svg:x">
              <xsl:value-of  select="concat('Group-TransformSVGX@',$grpCordinates,'$',$spCordinates)"/>
      </xsl:attribute>
          <xsl:attribute name ="svg:y">
              <xsl:value-of  select="concat('Group-TransformSVGY@',$grpCordinates,'$',$spCordinates)"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>


  </xsl:template>
  <xsl:template name="tmpSlideParagraphStyle">
    <xsl:param name="lnSpcReduction"/>
    <xsl:param name="blnSlide"/>
    <xsl:param name="isShape"/>
    <xsl:param name="level"/>
	  <xsl:message terminate="no">progress:p:cSld</xsl:message>
    <xsl:variable name ="nodeName">
      <xsl:value-of select ="concat('a:lvl',$level,'pPr')"/>
    </xsl:variable>
    <xsl:for-each select="a:pPr">
    <!--Text alignment-->
      <xsl:if test ="@algn">
        <xsl:call-template name="tmpTextAlignMent"/>
    </xsl:if >
    <!-- Convert Laeft margin of the paragraph-->
      <xsl:if test ="@marL">
      <xsl:attribute name ="fo:margin-left">
          <xsl:value-of select="concat(format-number(@marL div 360000, '#.##'), 'cm')"/>
      </xsl:attribute>
    </xsl:if>

      <xsl:if test ="@indent">
      <xsl:attribute name ="fo:text-indent">
          <xsl:value-of select="concat(format-number(@indent div 360000, '#.##'), 'cm')"/>
      </xsl:attribute>
    </xsl:if >
    <xsl:choose>
        <xsl:when test ="a:spcBef/a:spcPts/@val">
      <xsl:attribute name ="fo:margin-top">
            <xsl:value-of select="concat(format-number(a:spcBef/a:spcPts/@val div 2835, '#.##'), 'cm')"/>
      </xsl:attribute>
      </xsl:when>
        <xsl:when test ="a:spcBef/a:spcPct/@val">
        <xsl:variable name="spaceBef">
            <xsl:value-of select="a:spcBef/a:spcPct/@val"/>
        </xsl:variable>
      <xsl:variable name="var_MaxFntSize">
        <xsl:choose>
          <xsl:when test="../a:r/a:rPr/@sz">
        <xsl:for-each select="../a:r/a:rPr/@sz">
          <xsl:sort data-type="number" order="descending"/>
          <xsl:if test="position()=1">
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
          </xsl:when>
          <xsl:when test="../a:endParaRPr/@sz">
            <xsl:for-each select="../a:endParaRPr/@sz">
              <xsl:sort data-type="number" order="descending"/>
              <xsl:if test="position()=1">
                <xsl:value-of select="."/>
              </xsl:if>
            </xsl:for-each>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
        <xsl:choose>
          <xsl:when test="$var_MaxFntSize !=''">
      <xsl:attribute name ="fo:margin-top">
              <xsl:value-of select="concat(format-number( (($var_MaxFntSize * ( $spaceBef div 100000 ) ) div 2835 ) * 1.2, '#.##'), 'cm')"/>
      </xsl:attribute>
          </xsl:when>
          <xsl:when test="$var_MaxFntSize =''">
            <xsl:if test="$isShape='true'">
               <!--Change in code for performance-->
              <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr/@sz">
              <xsl:attribute name ="fo:margin-top">
                  <xsl:value-of select="concat( format-number( (( (. * $spaceBef) div 100000 )  div 2835 ) * 1.2, '#.##'), 'cm')"/>
              </xsl:attribute>
                </xsl:for-each>
              </xsl:if>
   </xsl:when>
        </xsl:choose>
 </xsl:when>
    </xsl:choose>
    <xsl:choose>
        <xsl:when test ="a:spcAft/a:spcPts/@val">
        <xsl:attribute name ="fo:margin-bottom">
            <xsl:value-of select="concat(format-number(a:spcAft/a:spcPts/@val div 2835, '#.##'), 'cm')"/>
        </xsl:attribute>
      </xsl:when>
        <xsl:when test ="a:spcAft/a:spcPct/@val">
        <xsl:variable name="spaceAft">
            <xsl:value-of select="a:spcAft/a:spcPct/@val"/>
        </xsl:variable>
        <xsl:variable name="var_MaxFntSize">
          <xsl:choose>
            <xsl:when test="./a:r/a:rPr/@sz">
        <xsl:for-each select="./a:r/a:rPr/@sz">
          <xsl:sort data-type="number" order="descending"/>
          <xsl:if test="position()=1">
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
            </xsl:when>
            <xsl:when test="./a:endParaRPr/@sz">
              <xsl:for-each select="./a:endParaRPr/@sz">
                <xsl:sort data-type="number" order="descending"/>
                <xsl:if test="position()=1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
          </xsl:when>
          </xsl:choose>
      
      </xsl:variable>
        <xsl:choose>
          <xsl:when test="$var_MaxFntSize !=''">
      <xsl:attribute name ="fo:margin-bottom">
              <xsl:value-of select="concat(format-number( (($var_MaxFntSize * ( $spaceAft div 100000 ) ) div 2835 ) * 1.2, '#.##'), 'cm')"/>
      </xsl:attribute>
          </xsl:when>
          <xsl:when test="$var_MaxFntSize =''">
            <xsl:if test="$isShape='true'">
              <xsl:if test="$isShape='true'">
                                   <!--Change in code for performance-->
                  <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr/@sz">
                <xsl:attribute name ="fo:margin-bottom">
                      <xsl:value-of select="concat( format-number( (( (. * $spaceAft) div 100000 )  div 2835 ) * 1.2, '#.##'), 'cm')"/>
                    </xsl:attribute>
                  </xsl:for-each>
                </xsl:if>
              </xsl:if>
   </xsl:when>
    </xsl:choose>

      </xsl:when>
    </xsl:choose>
    <!--End-->
    <xsl:choose>
        <xsl:when test ="a:lnSpc/a:spcPct/@val">
      <xsl:choose>
        <xsl:when test="$lnSpcReduction='0'">
          <xsl:attribute name="fo:line-height">
                <xsl:value-of select="concat(format-number(a:lnSpc/a:spcPct/@val div 1000,'###'), '%')"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="fo:line-height">
                <xsl:value-of select="concat(format-number((a:lnSpc/a:spcPct/@val - $lnSpcReduction) div 1000,'###'), '%')"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      </xsl:when >
        <xsl:when test ="a:lnSpc/a:spcPts/@val">
      <xsl:attribute name="style:line-height-at-least">
            <xsl:value-of select="concat(format-number(a:lnSpc/a:spcPts/@val div 2835, '#.##'), 'cm')"/>
      </xsl:attribute>
      </xsl:when>
    </xsl:choose>
    </xsl:for-each>
    </xsl:template>
  <xsl:template name="tmpSMParagraphStyle">
    <xsl:param name="lnSpcReduction"/>
   
    <!--Text alignment-->
    <xsl:if test ="@algn">
    <xsl:call-template name="tmpTextAlignMent"/>
  </xsl:if >
    <!-- Convert Laeft margin of the paragraph-->
    <xsl:if test ="@marL">
      <xsl:attribute name ="fo:margin-left">
        <xsl:value-of select="concat(format-number( @marL div 360000, '#.##'), 'cm')"/>
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
  <xsl:template name="tmpSlideTextProperty">
    <xsl:param name ="DefFont" />
    <xsl:param name ="fontscale"/>
    <xsl:param name="index"/>
    <xsl:param name="SMName"/>
    <xsl:param name="DefFontMinor"/>
    <xsl:param name="varCurrentNode" select="."/>
	<xsl:message terminate="no">progress:p:cSld</xsl:message>

    <xsl:choose>
      <xsl:when test ="@lang">
        <xsl:call-template name="tmpTextLanguage">
          <xsl:with-param name="lang" select="@lang"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test ="$varCurrentNode/@lang">
        <xsl:call-template name="tmpTextLanguage">
          <xsl:with-param name="lang" select="$varCurrentNode/@lang"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
    
    <xsl:choose>
      <xsl:when test ="@sz">
      <xsl:call-template name="tmpFontSize">
        <xsl:with-param name="fontscale" select="$fontscale"/>
        <xsl:with-param name="sz" select="@sz"/>
      </xsl:call-template>
      </xsl:when>
      <xsl:when test ="$varCurrentNode/@sz">
        <xsl:call-template name="tmpFontSize">
          <xsl:with-param name="fontscale" select="$fontscale"/>
          <xsl:with-param name="sz" select="$varCurrentNode/@sz"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="$varCurrentNode/child::node()[name() = 'a:latin' or name() = 'a:ea' or name() = 'a:cs']">
        <xsl:attribute name ="fo:font-family">
          <xsl:choose>
            <xsl:when test="$varCurrentNode/a:latin/@typeface">
              <xsl:variable name="typeFaceVal" select="$varCurrentNode/a:latin/@typeface"/>
              <!--added by yeswanth.s-->
              <xsl:choose>
                <xsl:when test="$typeFaceVal='+mn-lt'">
                  <xsl:choose>
                    <xsl:when test="$DefFontMinor!=''">
                      <xsl:value-of  select ="$DefFontMinor"/>
            </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of  select ="$DefFont"/>
                    </xsl:otherwise>
                  </xsl:choose>
            </xsl:when>
                <xsl:when test="$typeFaceVal='+mj-lt'">
                  <xsl:value-of  select ="$DefFont"/>
            </xsl:when>
                <xsl:when test="not($typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt')">
                  <xsl:value-of select ="$typeFaceVal"/>
            </xsl:when>
          </xsl:choose>
              <!--end-->              
      </xsl:when>
            <xsl:when test="$varCurrentNode/a:ea/@typeface">
              <xsl:variable name="typeFaceVal" select="$varCurrentNode/a:ea/@typeface"/>
              <!--added by yeswanth.s-->
          <xsl:choose>
                <xsl:when test="$typeFaceVal='+mn-lt'">
          <xsl:choose>
                    <xsl:when test="$DefFontMinor!=''">
                      <xsl:value-of  select ="$DefFontMinor"/>
            </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of  select ="$DefFont"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="$typeFaceVal='+mj-lt'">
                  <xsl:value-of  select ="$DefFont"/>
                </xsl:when>
                <xsl:when test="not($typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt')">
                  <xsl:value-of select ="$typeFaceVal"/>
            </xsl:when>
              </xsl:choose>
              <!--end-->
            </xsl:when>
            <xsl:when test="$varCurrentNode/a:cs/@typeface">
              <xsl:variable name="typeFaceVal" select="$varCurrentNode/a:cs/@typeface"/>
              <!--added by yeswanth.s-->
              <xsl:choose>
                <xsl:when test="$typeFaceVal='+mn-lt'">
                  <xsl:choose>
                    <xsl:when test="$DefFontMinor!=''">
                      <xsl:value-of  select ="$DefFontMinor"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of  select ="$DefFont"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="$typeFaceVal='+mj-lt'">
                  <xsl:value-of  select ="$DefFont"/>
                </xsl:when>
                <xsl:when test="not($typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt')">
                  <xsl:value-of select ="$typeFaceVal"/>
                </xsl:when>
              </xsl:choose>
              <!--end-->
            </xsl:when>
          </xsl:choose>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
    <xsl:call-template name="tmpFontName">
      <xsl:with-param name="DefFont" select="$DefFont"/>
      <xsl:with-param name="DefFontMinor" select="$DefFontMinor"/>
    </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    
	  <!-- strike style:text-line-through-style-->
    <xsl:choose>
      <xsl:when test ="@strike">
        <xsl:call-template name="tmpstrike">
          <xsl:with-param name="strike" select="@strike"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test ="$varCurrentNode/@strike">
        <xsl:call-template name="tmpstrike">
          <xsl:with-param name="strike" select="$varCurrentNode/@strike"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>

    <!-- Kening Property-->
    <xsl:choose>
      <xsl:when test ="@kern">
        <xsl:call-template name="tmpKerning">
          <xsl:with-param name="kern" select="@kern"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test ="$varCurrentNode/@kern">
        <xsl:call-template name="tmpKerning">
          <xsl:with-param name="kern" select="$varCurrentNode/@kern"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>

    <!-- Bold Property-->
    <xsl:choose>
      <xsl:when test ="@b">
        <xsl:call-template name="tmpFontWeight">
          <xsl:with-param name="b" select="@b"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test ="$varCurrentNode/@b">
        <xsl:call-template name="tmpFontWeight">
          <xsl:with-param name="b" select="$varCurrentNode/@b"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
    
    
    <!--UnderLine-->
    <xsl:choose>
      <xsl:when test ="@u">
      <xsl:call-template name="tmpUnderLine">
        <xsl:with-param name="SMName" select="$SMName"/>
          <xsl:with-param name="u" select="@u"/>
      </xsl:call-template>
      </xsl:when>
      <xsl:when test ="$varCurrentNode/@u">
        <xsl:call-template name="tmpUnderLine">
          <xsl:with-param name="SMName" select="$SMName"/>
          <xsl:with-param name="u" select="$varCurrentNode/@u"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
    <!-- Italic-->
    <!-- Fix for the bug 1780908, by vijayeta, date 24th Aug '07-->
     <xsl:choose>
      <xsl:when test ="@i">
        <xsl:call-template name="tmpFontItalic">
          <xsl:with-param name="i" select="@i"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test ="$varCurrentNode/@i">
        <xsl:call-template name="tmpFontItalic">
          <xsl:with-param name="i" select="$varCurrentNode/@i"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
    <!-- Fix for the bug 1780908, by vijayeta, date 24th Aug '07-->
    <!-- Character Spacing -->
    <xsl:choose>
      <xsl:when test ="@spc">
        <xsl:call-template name="tmpletterSpacing">
          <xsl:with-param name="spc" select="@spc"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test ="$varCurrentNode/@spc">
        <xsl:call-template name="tmpletterSpacing">
          <xsl:with-param name="spc" select="$varCurrentNode/@spc"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
   
    <xsl:call-template name="tmpFontColor">
      <xsl:with-param name="SMName" select="$SMName"/>
      <xsl:with-param name="varCurrentNode" select="$varCurrentNode"/>
            </xsl:call-template>

       <!--Shadow fo:text-shadow-->
    <xsl:if test ="a:effectLst/a:outerShdw">
      <xsl:call-template name="tmpTextOuterShdw"/>
    </xsl:if>
	  
  <!--SuperScript and SubScript for Text added by Mathi on 31st Jul 2007-->
    <xsl:if test="@baseline">
      <xsl:variable name="subSuperScriptValue">
        <xsl:value-of select="number(format-number(@baseline div 1000,'#'))"/>
	  </xsl:variable>
      <xsl:call-template name="tmpSubSuperScript">
        <xsl:with-param name="baseline" select="@baseline"/>
        <xsl:with-param name="subSuperScriptValue" select="$subSuperScriptValue"/>
      </xsl:call-template>
    </xsl:if>

      </xsl:template>
  <xsl:template name="tmpGetGroupCord">
    <xsl:variable name="shapeX">
      <xsl:value-of select="a:off/@x"/>
    </xsl:variable>
    <xsl:variable name="shapeY">
      <xsl:value-of select="a:off/@y"/>
    </xsl:variable>
    <xsl:variable name="shapeCX">
      <xsl:value-of select="a:ext/@cx"/>
    </xsl:variable>
    <xsl:variable name="shapeCY">
      <xsl:value-of select="a:ext/@cy"/>
    </xsl:variable>
    <xsl:variable name="shapeRot">
      <xsl:choose>
        <xsl:when test="@rot">
          <xsl:value-of select="@rot"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'0'"/>
        </xsl:otherwise>
      </xsl:choose>
     </xsl:variable>
    <xsl:variable name="shapeflipH">
      <xsl:choose>
        <xsl:when test="@flipH">
          <xsl:value-of select="@flipH"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'0'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="shapeflipV">
      <xsl:choose>
        <xsl:when test="@flipV">
          <xsl:value-of select="@flipV"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'0'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$shapeRot='0'">
        <xsl:value-of select="concat('ROTNO:',$shapeX,':',$shapeY,':',$shapeCX,':',$shapeCY,':',$shapeRot,':',$shapeflipH,':',$shapeflipV)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('ROTYES:',$shapeX,':',$shapeY,':',$shapeCX,':',$shapeCY,':',$shapeRot,':',$shapeflipH,':',$shapeflipV)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
	<!--CalloutAdjs Template (added by Mathi)-->
	<xsl:template name="tmpCalloutAdj">
		<xsl:param name="defaultVal"/>
		<xsl:choose>
			<xsl:when test="p:spPr/a:prstGeom/a:avLst/a:gd">
				<xsl:variable name="fmla1">
					<xsl:value-of select="substring-after(p:spPr/a:prstGeom/a:avLst/child::node()[name()='a:gd'][position()=1]/@fmla,' ')"/>
				</xsl:variable>
				<xsl:variable name="fmla2">
					<xsl:value-of select="substring-after(p:spPr/a:prstGeom/a:avLst/child::node()[name()='a:gd'][position()=2]/@fmla,' ')"/>
				</xsl:variable>
				<xsl:variable name="X">
					<xsl:value-of select="(p:spPr/a:xfrm/a:off/@x)"/>
				</xsl:variable>
				<xsl:variable name="Y">
					<xsl:value-of select="p:spPr/a:xfrm/a:off/@y"/>
				</xsl:variable>
				<xsl:variable name="CX">
					<xsl:value-of select="p:spPr/a:xfrm/a:ext/@cx"/>
				</xsl:variable>
				<xsl:variable name="CY">
					<xsl:value-of select="p:spPr/a:xfrm/a:ext/@cy"/>
				</xsl:variable>
				<xsl:variable name="FlipH">
					<xsl:choose>
						<xsl:when test="p:spPr/a:xfrm/@flipH">
							<xsl:value-of select="p:spPr/a:xfrm/@flipH"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'0'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="FlipV">
					<xsl:choose>
						<xsl:when test="(p:spPr/a:xfrm/@flipV)">
							<xsl:value-of select="(p:spPr/a:xfrm/@flipV)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'0'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="Rot">
					<xsl:choose>
						<xsl:when test="(p:spPr/a:xfrm/@rot)">
							<xsl:value-of select="(p:spPr/a:xfrm/@rot)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'0'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name ="draw:modifiers">
					<xsl:value-of select ="concat('Callout-AdjNotline:',$X,':',$Y,':',$CX,':',$CY,':',$FlipH,':',$FlipV,':',$Rot,':',$fmla1,':',$fmla2)"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test="not(p:spPr/a:prstGeom/a:avLst/a:gd)">
				<xsl:attribute name ="draw:modifiers">
					<xsl:value-of select="$defaultVal"/>
				</xsl:attribute>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
  <xsl:template name="tmpTextLanguage">
    <xsl:param name="lang"/>
    <xsl:attribute name ="style:language-asian">
      <xsl:value-of select="substring-before($lang,'-')"/>
    </xsl:attribute>
    <xsl:attribute name ="style:country-asian">
      <xsl:value-of select="substring-after($lang,'-')"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="tmpTextOuterShdw">
    <xsl:attribute name ="fo:text-shadow">
      <xsl:value-of select ="'1pt 1pt'"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="tmpletterSpacing">
    <xsl:param name="spc"/>
    <xsl:attribute name ="fo:letter-spacing">
      <xsl:value-of select="concat(format-number($spc * 2.54 div 7200,'#.###'),'cm')"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="tmpFontWeight">
    <xsl:param name="b"/>
    <xsl:choose>
      <xsl:when test ="$b='1'">
        <xsl:attribute name ="fo:font-weight">
          <xsl:value-of select ="'bold'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="$b='0'">
        <xsl:attribute name ="fo:font-weight">
          <xsl:value-of select ="'normal'"/>
        </xsl:attribute>
      </xsl:when >
    </xsl:choose>
  </xsl:template>
  <xsl:template name="tmpFontItalic">
    <xsl:param name="i"/>
    <xsl:attribute name ="fo:font-style">
      <xsl:choose>
        <xsl:when test ="$i='1'">
          <xsl:value-of select ="'italic'"/>
        </xsl:when >
        <xsl:when test ="$i='0'">
          <xsl:value-of select ="'normal'"/>
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="tmpKerning">
    <xsl:param name="kern"/>
    <xsl:choose >
      <xsl:when test ="$kern = '0'">
        <xsl:attribute name ="style:letter-kerning">
          <xsl:value-of select ="'false'"/>
        </xsl:attribute >
      </xsl:when >
      <xsl:when test ="format-number($kern,'#.##') &gt; 0">
        <xsl:attribute name ="style:letter-kerning">
          <xsl:value-of select ="'true'"/>
        </xsl:attribute >
      </xsl:when >
    </xsl:choose>
  </xsl:template>
  <xsl:template name="tmpstrike">
    <xsl:param name="strike"/>
    <xsl:if test ="$strike!='noStrike'">
      <xsl:attribute name ="style:text-line-through-style">
        <xsl:value-of select ="'solid'"/>
      </xsl:attribute>
      <xsl:choose >
        <xsl:when test ="$strike='dblStrike'">
          <xsl:attribute name ="style:text-line-through-type">
            <xsl:value-of select ="'double'"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test ="$strike='sngStrike'">
          <xsl:attribute name ="style:text-line-through-type">
            <xsl:value-of select ="'single'"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <xsl:template name="tmpFontSize">
    <xsl:param name="fontscale"/>
    <xsl:param name="sz"/>
    <xsl:variable name="Fontsize">
      <xsl:choose>
        <xsl:when test="$fontscale ='100000'">
          <xsl:value-of  select ="concat(format-number($sz div 100,'#.##'),'pt')"/>
        </xsl:when>
        <xsl:when test="$fontscale !=''">
          <xsl:value-of  select ="concat(format-number(round(($sz *($fontscale div 1000) ) div 10000),'#.##'),'pt')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of  select ="concat(format-number($sz div 100,'#.##'),'pt')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:attribute name ="fo:font-size"	>
      <xsl:value-of select="$Fontsize"/>
    </xsl:attribute>
    <xsl:attribute name ="style:font-size-asian">
      <xsl:value-of select="$Fontsize"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="tmpFontName">
    <xsl:param name="DefFont"/>
    <xsl:param name="DefFontMinor"/>
    <xsl:choose>
      <xsl:when test ="a:latin/@typeface">
        <xsl:attribute name ="fo:font-family">
          <xsl:variable name ="typeFaceVal" select ="a:latin/@typeface"/>
          <xsl:for-each select ="a:latin/@typeface">
            <xsl:choose>
              <xsl:when test="$typeFaceVal='+mn-lt'">
                <xsl:choose>
                  <xsl:when test="$DefFontMinor!=''">
                    <xsl:value-of  select ="$DefFontMinor"/>
                  </xsl:when>
                  <xsl:otherwise>
              <xsl:value-of  select ="$DefFont"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="$typeFaceVal='+mj-lt'">
                <xsl:value-of  select ="$DefFont"/>
              </xsl:when>
              <xsl:when test="not($typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt')">
              <xsl:value-of select ="."/>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="a:ea/@typeface and a:rPr/@lang!='en-US'">
        <xsl:attribute name ="fo:font-family">
          <xsl:variable name ="typeFaceVal" select ="a:ea/@typeface"/>
          <xsl:for-each select ="a:rPr/a:ea/@typeface">
            <xsl:choose>
              <xsl:when test="$typeFaceVal='+mn-ea'">
                <xsl:choose>
                  <xsl:when test="$DefFontMinor!=''">
                    <xsl:value-of  select ="$DefFontMinor"/>
                  </xsl:when>
                  <xsl:otherwise>
              <xsl:value-of  select ="$DefFont"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="$typeFaceVal='+mj-ea'">
                <xsl:value-of  select ="$DefFont"/>
              </xsl:when>
              <xsl:when test="not($typeFaceVal='+mn-ea' or $typeFaceVal='+mj-ea')">
              <xsl:value-of select ="."/>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="parent::node()/parent::node()/parent::node()/parent::node()/p:style/a:fontRef/@idx">
        <xsl:choose>
          <xsl:when test="parent::node()/parent::node()/parent::node()/parent::node()/p:style/a:fontRef[@idx='major']">
        <xsl:attribute name ="fo:font-family">
          <xsl:value-of select="$DefFont"/>
        </xsl:attribute>
      </xsl:when>
          <xsl:when test="parent::node()/parent::node()/parent::node()/parent::node()/p:style/a:fontRef[@idx='minor']">
            <xsl:attribute name ="fo:font-family">
              <xsl:value-of select="$DefFontMinor"/>
            </xsl:attribute>
          </xsl:when>
        </xsl:choose>
       
      </xsl:when>
      <xsl:when test ="a:sym/@typeface and @lang!='en-US'">
        <xsl:attribute name ="fo:font-family">
          <xsl:variable name ="typeFaceVal" select ="a:sym/@typeface"/>
          <xsl:for-each select ="a:sym/@typeface">
            <xsl:choose>
              <xsl:when test="$typeFaceVal='+mn-sym'">
                <xsl:choose>
                  <xsl:when test="$DefFontMinor!=''">
                    <xsl:value-of  select ="$DefFontMinor"/>
                  </xsl:when>
                  <xsl:otherwise>
              <xsl:value-of  select ="$DefFont"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="$typeFaceVal='+mj-sym'">
                <xsl:value-of  select ="$DefFont"/>
              </xsl:when>
              <xsl:when test="not($typeFaceVal='+mn-sym' or $typeFaceVal='+mj-sym')">
              <xsl:value-of select ="."/>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>
        </xsl:attribute >
      </xsl:when>
      <xsl:when test ="a:cs/@typeface and @lang!='en-US'">
        <xsl:attribute name ="fo:font-family">
          <xsl:variable name ="typeFaceVal" select ="a:cs/@typeface"/>
          <xsl:for-each select ="a:rPr/a:cs/@typeface">
            <xsl:choose>
              <xsl:when test="$typeFaceVal='+mn-cs'">
                <xsl:choose>
                  <xsl:when test="$DefFontMinor!=''">
                    <xsl:value-of  select ="$DefFontMinor"/>
                  </xsl:when>
                  <xsl:otherwise>
              <xsl:value-of  select ="$DefFont"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="$typeFaceVal='+mj-cs'">
                <xsl:value-of  select ="$DefFont"/>
              </xsl:when>
              <xsl:when test="not($typeFaceVal='+mn-cs' or $typeFaceVal='+mj-cs')">
              <xsl:value-of select ="."/>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>
        </xsl:attribute >
      </xsl:when>
  
    </xsl:choose>
  </xsl:template>
	<xsl:template name="tmpCalloutLineAdj">
		<xsl:param name="defaultVal"/>
		<xsl:choose>
			<xsl:when test="p:spPr/a:prstGeom/a:avLst/a:gd">
				<xsl:variable name="fmla1">
					<xsl:value-of select="substring-after(p:spPr/a:prstGeom/a:avLst/child::node()[name()='a:gd'][position()=1]/@fmla,' ')"/>
				</xsl:variable>
				<xsl:variable name="fmla2">
					<xsl:value-of select="substring-after(p:spPr/a:prstGeom/a:avLst/child::node()[name()='a:gd'][position()=2]/@fmla,' ')"/>
				</xsl:variable>
				<xsl:variable name="fmla3">
					<xsl:value-of select="substring-after(p:spPr/a:prstGeom/a:avLst/child::node()[name()='a:gd'][position()=3]/@fmla,' ')"/>
				</xsl:variable>
				<xsl:variable name="fmla4">
					<xsl:value-of select="substring-after(p:spPr/a:prstGeom/a:avLst/child::node()[name()='a:gd'][position()=4]/@fmla,' ')"/>
				</xsl:variable>
				<xsl:variable name="fmla5">
					<xsl:value-of select="substring-after(p:spPr/a:prstGeom/a:avLst/child::node()[name()='a:gd'][position()=5]/@fmla,' ')"/>
				</xsl:variable>
				<xsl:variable name="fmla6">
					<xsl:value-of select="substring-after(p:spPr/a:prstGeom/a:avLst/child::node()[name()='a:gd'][position()=6]/@fmla,' ')"/>
				</xsl:variable>
				<xsl:variable name="fmla7">
					<xsl:value-of select="substring-after(p:spPr/a:prstGeom/a:avLst/child::node()[name()='a:gd'][position()=7]/@fmla,' ')"/>
				</xsl:variable>
				<xsl:variable name="fmla8">
					<xsl:value-of select="substring-after(p:spPr/a:prstGeom/a:avLst/child::node()[name()='a:gd'][position()=8]/@fmla,' ')"/>
				</xsl:variable>
				<xsl:variable name="X">
					<xsl:value-of select="p:spPr/a:xfrm/a:off/@x"/>
				</xsl:variable>
				<xsl:variable name="Y">
					<xsl:value-of select="p:spPr/a:xfrm/a:off/@y"/>
				</xsl:variable>
				<xsl:variable name="CX">
					<xsl:value-of select="p:spPr/a:xfrm/a:ext/@cx"/>
				</xsl:variable>
				<xsl:variable name="CY">
					<xsl:value-of select="p:spPr/a:xfrm/a:ext/@cy"/>
				</xsl:variable>
				<xsl:variable name="FlipH">
					<xsl:choose>
						<xsl:when test="p:spPr/a:xfrm/@flipH">
							<xsl:value-of select="p:spPr/a:xfrm/@flipH"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'0'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="FlipV">
					<xsl:choose>
						<xsl:when test="(p:spPr/a:xfrm/@flipV)">
							<xsl:value-of select="(p:spPr/a:xfrm/@flipV)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'0'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="Rot">
					<xsl:choose>
						<xsl:when test="(p:spPr/a:xfrm/@rot)">
							<xsl:value-of select="(p:spPr/a:xfrm/@rot)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'0'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:if test="p:spPr/a:prstGeom/@prst='borderCallout1'">
					<xsl:attribute name ="draw:modifiers">
						<xsl:value-of select ="concat('Callout-AdjLine1:',$X,':',$Y,':',$CX,':',$CY,':',$FlipH,':',$FlipV,':',$Rot,':',$fmla1,':',$fmla2,':',$fmla3,':',$fmla4)"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="p:spPr/a:prstGeom/@prst='borderCallout2'">
					<xsl:attribute name ="draw:modifiers">
						<xsl:value-of select ="concat('Callout-AdjLine2:',$X,':',$Y,':',$CX,':',$CY,':',$FlipH,':',$FlipV,':',$Rot,':',$fmla1,':',$fmla2,':',$fmla3,':',$fmla4,':',$fmla5,':',$fmla6)"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="p:spPr/a:prstGeom/@prst='borderCallout3'">
					<xsl:attribute name ="draw:modifiers">
						<xsl:value-of select ="concat('Callout-AdjLine3:',$X,':',$Y,':',$CX,':',$CY,':',$FlipH,':',$FlipV,':',$Rot,':',$fmla1,':',$fmla2,':',$fmla3,':',$fmla4,':',$fmla5,':',$fmla6,':',$fmla7,':',$fmla8)"/>
					</xsl:attribute>
				</xsl:if>
			</xsl:when>

			<xsl:when test="not(p:spPr/a:prstGeom/a:avLst/a:gd)">
				<xsl:if test="p:spPr/a:prstGeom/@prst='borderCallout1'">
					<xsl:attribute name ="draw:modifiers">
						<xsl:value-of select="$defaultVal"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="p:spPr/a:prstGeom/@prst='borderCallout2'">
					<xsl:attribute name ="draw:modifiers">
						<xsl:value-of select="$defaultVal"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="p:spPr/a:prstGeom/@prst='borderCallout3'">
					<xsl:attribute name ="draw:modifiers">
						<xsl:value-of select="$defaultVal"/>
					</xsl:attribute>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
    <xsl:template name="tmpSlideGrahicProp">
    <xsl:param name="ThemeName"/>
    <xsl:param name="var_pos"/>
    <xsl:param name="slideNo"/>
    <xsl:param name="FileType"/>
    <xsl:param name="shapePhType"/>
    <xsl:param name="flagShape"/>
    <xsl:param name="spType"/>
    <xsl:param name="SMName"/>

	  <xsl:message terminate="no">progress:p:cSld</xsl:message>
    <xsl:message terminate="no">progress:a:p</xsl:message>
    <!--Background Fill color-->
    <xsl:choose>
      <!-- No fill -->
      <xsl:when test ="p:spPr/a:noFill">
        <xsl:attribute name ="draw:fill">
          <xsl:value-of select="'none'" />
        </xsl:attribute>
      </xsl:when>
      <!-- Solid fill-->
      <!-- Standard color-->
      <xsl:when test ="p:spPr/a:solidFill">
        <xsl:for-each select="p:spPr/a:solidFill">
          <xsl:call-template name="tmpShapeSolidFillColor">
            <xsl:with-param name="SMName" select="$SMName"/>
                      </xsl:call-template>
                    </xsl:for-each>
                  </xsl:when>
         <xsl:when test="p:spPr/a:blipFill and p:spPr/a:blipFill/a:blip/@r:embed ">
        <xsl:call-template name="tmpblipFill">
          <xsl:with-param name="ThemeName" select="$ThemeName"/>
          <xsl:with-param name="var_pos" select="$var_pos"/>
          <xsl:with-param name="shapePhType" select="$shapePhType"/>
          <xsl:with-param name="slideNo" select="$slideNo"/>
          <xsl:with-param name="FileType" select="$FileType"/>
          <xsl:with-param name="flagShape" select="$flagShape"/>
          <xsl:with-param name="spType" select="$spType"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="p:spPr/a:gradFill">
        <xsl:call-template name="tmpGradFillColor">
          <xsl:with-param name="var_pos" select="$var_pos"/>
          <xsl:with-param name="FileType" select="concat($FileType,$slideNo)"/>
          <xsl:with-param name="shapePhType" select="$shapePhType"/>
          <xsl:with-param name="SMName" select="$SMName"/>
                  </xsl:call-template>
      </xsl:when>
            <!--Fill refernce-->
      <xsl:when test ="p:style/a:fillRef">
        <xsl:for-each select="p:style/a:fillRef">
          <xsl:call-template name="tmpShapeSolidFillColor"/>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
    <!--Line Color-->
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
        <xsl:for-each select="p:spPr/a:ln/a:solidFill">
          <xsl:attribute name ="svg:stroke-color">
            <xsl:call-template name="tmpSolidColor">
              <xsl:with-param name="SMName" select="$SMName"/>
            </xsl:call-template>
          </xsl:attribute>          
            <xsl:call-template name="tmpLineFillTransperancy">
              <xsl:with-param name="SMName" select="$SMName"/>
            </xsl:call-template>         
        </xsl:for-each>
      </xsl:when>
      <xsl:when test ="p:style/a:lnRef[@idx=0]">
        <xsl:attribute name ="draw:stroke">
          <xsl:value-of select="'none'" />
              </xsl:attribute>
       </xsl:when>
      <xsl:when test ="p:style/a:lnRef[@idx &gt;0]">
        <xsl:attribute name ="draw:stroke">
          <xsl:value-of select="'solid'" />
        </xsl:attribute>
        <xsl:for-each select="p:style/a:lnRef">
          <xsl:attribute name ="svg:stroke-color">
            <xsl:call-template name="tmpSolidColor">
              <xsl:with-param name="SMName" select="$SMName"/>
            </xsl:call-template>
          </xsl:attribute>
        
            <xsl:call-template name="tmpLineFillTransperancy">
              <xsl:with-param name="SMName" select="$SMName"/>
            </xsl:call-template>
         
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
    <!--Line Style-->
    <xsl:call-template name="LineStyle">
      <xsl:with-param name="ThemeName" select="$ThemeName"/>
    </xsl:call-template>
    <xsl:for-each select="p:txBody/a:bodyPr">
      <xsl:call-template name="tmpInternalMargin"/>
      <xsl:call-template name="tmpWrapSpAutoFit">
        <xsl:with-param name="shapePhType" select="$shapePhType"/>
      </xsl:call-template>
      <xsl:call-template name="tmpShapeVerticalAlign"/>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="tmpTextAlignMent">
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
        <!-- Justified Alignment-->
        <xsl:when test ="@algn ='just'">
          <xsl:value-of select ="'justify'"/>
          </xsl:when>
        </xsl:choose>
      </xsl:attribute>
  </xsl:template>
  <xsl:template  name="tmpMarginLet">
    <xsl:attribute name ="fo:margin-left">
      <xsl:value-of select="concat(format-number(@marL div 360000, '#.##'), 'cm')"/>
      </xsl:attribute >
  </xsl:template>
  <xsl:template  name="tmpMarginTopBottom">
    <xsl:param name="type"/>
    <xsl:param name="fontSz"/>
    <xsl:param name="spaceVal"/>
    <xsl:choose>
      <xsl:when test="$type='point'">
        <xsl:value-of select="concat(format-number($spaceVal div 2835, '#.##'), 'cm')"/>
     </xsl:when>
      <xsl:when test="$type='percentage'">
        <xsl:value-of select="concat(format-number( (( $fontSz * ($spaceVal div 100000 ) ) div 2835) * 1.2  ,'#.###'),'cm')"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="tmpShapeVerticalAlign">
    <xsl:choose>
      <xsl:when test="contains(@vert,'vert')">
        <xsl:choose>
          <xsl:when test="(@anchor='b' and @anchorCtr='0') or (@anchor='b' and not(@anchorCtr))">
            <xsl:attribute name ="draw:textarea-horizontal-align">
              <xsl:value-of select="'left'"/>
            </xsl:attribute>
            <xsl:attribute name ="draw:textarea-vertical-align">
              <xsl:value-of select="'top'"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="(@anchor='t' and @anchorCtr='0') or (@anchor='t' and not(@anchorCtr))">
            <xsl:attribute name ="draw:textarea-horizontal-align">
              <xsl:value-of select="'right'"/>
            </xsl:attribute>
            <xsl:attribute name ="draw:textarea-vertical-align">
              <xsl:value-of select="'top'"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="(@anchor='ctr' and @anchorCtr='0') or (@anchor='ctr' and not(@anchorCtr))">
            <xsl:attribute name ="draw:textarea-horizontal-align">
              <xsl:value-of select="'center'"/>
            </xsl:attribute>
            <xsl:attribute name ="draw:textarea-vertical-align">
              <xsl:value-of select="'top'"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="@anchor='t' and @anchorCtr='1'">
            <xsl:attribute name ="draw:textarea-horizontal-align">
              <xsl:value-of select="'right'"/>
            </xsl:attribute>
            <xsl:attribute name ="draw:textarea-vertical-align">
              <xsl:value-of select="'middle'"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="@anchor='ctr' and @anchorCtr='1'">
            <xsl:attribute name ="draw:textarea-horizontal-align">
              <xsl:value-of select="'center'"/>
            </xsl:attribute>
            <xsl:attribute name ="draw:textarea-vertical-align">
              <xsl:value-of select="'middle'"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="@anchor='b' and @anchorCtr='1'">
            <xsl:attribute name ="draw:textarea-horizontal-align">
              <xsl:value-of select="'left'"/>
            </xsl:attribute>
            <xsl:attribute name ="draw:textarea-vertical-align">
              <xsl:value-of select="'middle'"/>
            </xsl:attribute>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="@vert='horz' or not(a:bodyPr/@vert)">
        <xsl:if test ="@anchor">
            <xsl:attribute name ="draw:textarea-vertical-align">
            <xsl:call-template name="tmpVerticalAlign"/>
          </xsl:attribute>
        </xsl:if >
        <xsl:if test ="@anchorCtr" >
          <xsl:attribute name ="draw:textarea-horizontal-align">
            <xsl:call-template name="tmpHorizontalAlign"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="tmpVerticalAlign">
                <xsl:choose >
                  <!-- Top-->
      <xsl:when test ="@anchor = 't' ">
              <xsl:value-of select="'top'"/>
             </xsl:when>
                  <!-- Middle-->
      <xsl:when test ="@anchor = 'ctr' ">
              <xsl:value-of select="'middle'"/>
             </xsl:when>
                  <!-- bottom-->
      <xsl:when test ="@anchor = 'b' ">
              <xsl:value-of select="'bottom'"/>
             </xsl:when>
                </xsl:choose>
  </xsl:template>
  <xsl:template name="tmpHorizontalAlign">
    <xsl:choose >
      <xsl:when test ="@anchorCtr = 1 ">
              <xsl:value-of select="'center'"/>
      </xsl:when>
      <xsl:when test ="@anchorCtr= 0 or not(@anchorCtr)">
                  <xsl:value-of select ="'justify'"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="tmpInternalMargin">
    <xsl:if test ="@tIns">
      <xsl:attribute name ="fo:padding-top">
        <xsl:value-of select ="concat(format-number(number(@tIns div 360000), '#.##'), 'cm')"/>
      </xsl:attribute>
                </xsl:if>
    <xsl:if test ="@lIns">
      <xsl:attribute name ="fo:padding-left">
        <xsl:value-of select ="concat(format-number(number(@lIns div 360000), '#.##'), 'cm')"/>
            </xsl:attribute>
           </xsl:if>
    <xsl:if test ="@bIns">
      <xsl:attribute name ="fo:padding-bottom">
        <xsl:value-of select ="concat(format-number(number(@bIns div 360000), '#.##'), 'cm')"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test ="@rIns">
      <xsl:attribute name ="fo:padding-right">
        <xsl:value-of select ="concat(format-number(number(@rIns div 360000), '#.##'), 'cm')"/>
      </xsl:attribute>
          </xsl:if>
  </xsl:template>
  <xsl:template name="tmpblipFill">
    <xsl:param name="ThemeName"/>
    <xsl:param name="var_pos"/>
    <xsl:param name="slideNo"/>
    <xsl:param name="FileType"/>
    <xsl:param name="shapePhType"/>
    <xsl:param name="flagShape"/>
    <xsl:param name="spType"/>
    <xsl:attribute name="draw:fill-image-name">
      <xsl:choose>
        <xsl:when test="$spType!=''">
          <xsl:value-of select="concat($FileType,$slideNo,'-',$spType,'Img',$var_pos)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($FileType,$slideNo,'-',$shapePhType,'Img',$var_pos)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:for-each select="p:spPr">
      <xsl:call-template name="tmpPictureFillProp"/>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="tmpWrapSpAutoFit">
    <xsl:param name="flagshape"/>
    <xsl:choose>
      <xsl:when test="a:spAutoFit">
        <xsl:choose>
          <xsl:when test="@wrap='none'">
            <xsl:attribute name="draw:auto-grow-height">
              <xsl:value-of select ="'true'"/>
            </xsl:attribute>
            <xsl:attribute name="draw:auto-grow-width">
              <xsl:value-of select ="'true'"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <!--changed by yeswanth - bug#2961087 : changed to false for draw:auto-grow-height-->
        <xsl:attribute name="draw:auto-grow-height">
              <xsl:value-of select ="'false'"/>
        </xsl:attribute>
        <xsl:attribute name="draw:auto-grow-width">
          <xsl:value-of select ="'false'"/>
        </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$flagshape ='yes'">
        <xsl:attribute name="draw:auto-grow-height">
          <xsl:value-of select ="'false'"/>
        </xsl:attribute>
        <xsl:attribute name="draw:auto-grow-width">
          <xsl:value-of select ="'false'"/>
        </xsl:attribute>
        </xsl:if>     
      </xsl:otherwise>
    </xsl:choose>
    <!--Wrap text in shape -->
    <!--doubt : 2961087-->
    <xsl:choose>
      <xsl:when test="not(@wrap)">
        <xsl:attribute name ="fo:wrap-option">
          <xsl:value-of select ="'no-wrap'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@wrap='none'">
        <xsl:attribute name ="fo:wrap-option">
          <xsl:value-of select ="'wrap'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="(@wrap='square')  or (@fontAlgn='auto')">
        <xsl:attribute name ="fo:wrap-option">
          <xsl:value-of select ="'no-wrap'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name ="fo:wrap-option">
          <xsl:value-of select ="'no-wrap'"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="tmpPictureFillProp">
      <xsl:attribute name="draw:fill-color">
        <xsl:value-of select="'#FFFFFF'"/>
      </xsl:attribute>
      <xsl:attribute name="draw:fill">
        <xsl:value-of select="'bitmap'"/>
      </xsl:attribute>
      <xsl:choose>
      <xsl:when test="a:blipFill/a:stretch/a:fillRect">
          <xsl:attribute name="style:repeat">
            <xsl:value-of select="'stretch'"/>
          </xsl:attribute>
        </xsl:when>
      <xsl:when test="a:blipFill/a:tile">
        <xsl:for-each select="a:blipFill/a:tile">
            <xsl:if test="@sx">
              <xsl:attribute name="draw:fill-image-ref-point-x">
                <xsl:value-of select ="concat(format-number(@sx div 1000, '#'), '%')"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="@sy">
              <xsl:attribute name="draw:fill-image-ref-point-y">
                <xsl:value-of select ="concat(format-number(@sy div 1000, '#'), '%')"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="@algn">
              <xsl:attribute name="draw:fill-image-ref-point">
                <xsl:choose>
                  <xsl:when test="@algn='tl'">
                    <xsl:value-of select ="'top-left'"/>
                  </xsl:when>
                  <xsl:when test="@algn='t'">
                    <xsl:value-of select ="'top'"/>
                  </xsl:when>
                  <xsl:when test="@algn='tr'">
                    <xsl:value-of select ="'top-right'"/>
                  </xsl:when>
                  <xsl:when test="@algn='r'">
                    <xsl:value-of select ="'right'"/>
                  </xsl:when>
                  <xsl:when test="@algn='bl'">
                    <xsl:value-of select ="'bottom-left'"/>
                  </xsl:when>
                  <xsl:when test="@algn='br'">
                    <xsl:value-of select ="'bottom-right'"/>
                  </xsl:when>
                  <xsl:when test="@algn='b'">
                    <xsl:value-of select ="'bottom'"/>
                  </xsl:when>
                  <xsl:when test="@algn='ctr'">
                    <xsl:value-of select ="'center'"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:attribute>
            </xsl:if>
            </xsl:for-each>
        </xsl:when>
      </xsl:choose>
    <!-- Image Transperancy -->
    <xsl:if test="a:blipFill/a:blip/a:alphaModFix/@amt">
      <xsl:variable name ="alpha">
        <xsl:value-of select ="a:blipFill/a:blip/a:alphaModFix/@amt"/>
      </xsl:variable>
      <xsl:if test="($alpha != '') or ($alpha != 0)">
        <xsl:attribute name ="draw:opacity">
          <xsl:value-of select="concat(($alpha div 1000), '%')"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$alpha = '0'">
        <xsl:attribute name ="draw:opacity">
          <xsl:value-of select="'0%'"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:if>
  </xsl:template>
   <xsl:template name="tmpGradFillColor">
    <xsl:param name="var_pos"/>
    <xsl:param name="FileType"/>
    <xsl:param name="flagGroup"/>
    <xsl:param name="shapePhType"/>
    <xsl:param name="SMName"/>
    <xsl:attribute name="draw:fill-gradient-name">
      <xsl:choose>
        <xsl:when test="$flagGroup='True'">
          <xsl:choose>
            <xsl:when test="contains($FileType,'slideLayout')">
              <xsl:value-of select="concat('SlideLayoutGroup',$FileType,$shapePhType,'Gradient',$var_pos)" />
            </xsl:when>
            <xsl:when test="contains($FileType,'slideMaster')">
              <xsl:value-of select="concat('SMGroup',$FileType,$shapePhType,'Gradient',$var_pos)" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('SlideGroup',$FileType,$shapePhType,'Gradient',$var_pos)" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="contains($FileType,'Layout') or contains($FileType,'Master') ">
      <xsl:value-of select="concat($FileType,$shapePhType,'Gradient',$var_pos)" />
             
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($FileType,'Gradient',$var_pos)" />
            </xsl:otherwise>
          </xsl:choose>


        </xsl:otherwise>
        </xsl:choose>


    </xsl:attribute>

    <xsl:for-each select="p:spPr/a:gradFill/a:gsLst/child::node()[1]">
      <xsl:if test="name()='a:gs'">
        <xsl:call-template name="tmpShapeSolidFillColor">
          <xsl:with-param name="SMName" select="$SMName"/>
          <xsl:with-param name="fillName" select="'gradient'"/>
              </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="tmpBackGrndGradFillColor">
    <xsl:param name="FileType"/>
    <xsl:param name="SMName"/>
    <xsl:attribute name="draw:fill-gradient-name">
      <xsl:value-of select="$FileType" />
    </xsl:attribute>

    <xsl:for-each select="p:bgPr/a:gradFill/a:gsLst/child::node()[1]">
      <xsl:if test="name()='a:gs'">
        <xsl:call-template name="tmpShapeSolidFillColor">
          <xsl:with-param name="SMName" select="$SMName"/>
          <xsl:with-param name="fillName" select="'gradient'"/>
              </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="tmpSubSuperScript">
    <xsl:param name="baseline"/>
    <xsl:param name="subSuperScriptValue"/>
    <xsl:choose>
      <xsl:when test="($baseline &gt; 0)">
        <xsl:variable name="relativeFntSz">
          <xsl:value-of select="100 - $subSuperScriptValue "/>
        </xsl:variable>
        <xsl:variable name="raisedLowerByVal">
          <xsl:value-of select="100 - $relativeFntSz"/>
        </xsl:variable>
        <xsl:variable name="superScriptVal">
          <xsl:value-of select="concat($raisedLowerByVal, '% ',$relativeFntSz,' %' )"/>
        </xsl:variable>
        <xsl:attribute name="style:text-position">
          <xsl:value-of select="$superScriptVal"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="($baseline &lt; 0)">
        <xsl:variable name="relativeFntSz">
          <xsl:value-of select="100 + $subSuperScriptValue "/>
        </xsl:variable>
        <xsl:variable name="raisedLowerByVal">
          <xsl:value-of select="100 - $relativeFntSz"/>
        </xsl:variable>
        <xsl:variable name="subScriptVal">
          <xsl:value-of select="concat('-',$raisedLowerByVal, '% ',$relativeFntSz,' %' )"/>
        </xsl:variable>
        <xsl:attribute name="style:text-position">
          <xsl:value-of select="$subScriptVal"/>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- Start - Template to Add hyperlinks defined at the Text level - added by lohith-->
  <xsl:template name="AddTextHyperlinks">
    <xsl:param name="nodeAColonR" />
    <xsl:param name="slideRelationId" />
    <xsl:param name="slideId" />
    <xsl:param name="nodeTextSpan" />
	<xsl:message terminate="no">progress:p:cSld</xsl:message>
    <!-- varible to get the slide number ( Eg: 1,2 etc )-->
    <xsl:variable name="slidePostion">
      <xsl:value-of select="format-number(substring-after($slideId,'slide'),'#')"/>
    </xsl:variable>
    <!-- varible to get the numer of slides in the persentation -->
    <xsl:variable name="slideCount">
      <xsl:value-of select="count(key('Part', 'ppt/presentation.xml')/p:presentation/p:sldIdLst/p:sldId)"/>
    </xsl:variable>
    <xsl:if test="$nodeAColonR/a:hlinkClick/@action[contains(.,'slide')] and string-length($nodeAColonR/a:hlinkClick/@r:id) = 0 ">
      <xsl:choose>
        <xsl:when test="$nodeAColonR/a:hlinkClick/@action[ contains(.,'jump=previousslide')]">
          <text:a>
          <xsl:if test="$slidePostion > 1">
            <xsl:attribute name="xlink:href">
              <xsl:value-of select="concat('#Slide ',($slidePostion - 1))"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="$slidePostion = 1">
              <xsl:attribute name="xlink:href">
            <xsl:value-of select="concat('#Slide ',1)"/>
              </xsl:attribute>
          </xsl:if>
            <xsl:copy-of select="$nodeTextSpan"/>
          </text:a>
        </xsl:when>
        <xsl:when test="$nodeAColonR/a:hlinkClick/@action[ contains(.,'jump=nextslide')]">
          <text:a>
          <xsl:if test="$slidePostion = $slideCount">
            <xsl:attribute name="xlink:href">
              <xsl:value-of select="concat('#Slide ',$slidePostion)"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="$slidePostion &lt; $slideCount">
            <xsl:attribute name="xlink:href">
              <xsl:value-of select="concat('#Slide ',($slidePostion + 1))"/>
            </xsl:attribute>
          </xsl:if>
            <xsl:copy-of select="$nodeTextSpan"/>
          </text:a>
        </xsl:when>
        <xsl:when test="$nodeAColonR/a:hlinkClick/@action[ contains(.,'jump=firstslide')]">
          <text:a>
          <xsl:attribute name="xlink:href">
            <xsl:value-of select="concat('#Slide ',1)"/>
          </xsl:attribute>
            <xsl:copy-of select="$nodeTextSpan"/>
          </text:a>
        </xsl:when>
        <xsl:when test="$nodeAColonR/a:hlinkClick/@action[ contains(.,'jump=lastslide')]">
          <text:a>
          <xsl:attribute name="xlink:href">
            <xsl:value-of select="concat('#Slide ',$slideCount)"/>
          </xsl:attribute>
            <xsl:copy-of select="$nodeTextSpan"/>
          </text:a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$nodeTextSpan"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="$nodeAColonR/a:hlinkClick/@action[ contains(.,'noaction')]">
      <xsl:copy-of select="$nodeTextSpan"/>
    </xsl:if>
	  
    <xsl:if test="string-length($nodeAColonR/a:hlinkClick/@r:id) > 0">
      <xsl:variable name="RelationId">
        <xsl:value-of select="$nodeAColonR/a:hlinkClick/@r:id"/>
      </xsl:variable>
      <xsl:variable name="Target">
        <xsl:value-of select="key('Part', $slideRelationId)/rels:Relationships/rels:Relationship[@Id=$RelationId]/@Target"/>
      </xsl:variable>
      <xsl:variable name="type">
        <xsl:value-of select="key('Part', $slideRelationId)/rels:Relationships/rels:Relationship[@Id=$RelationId]/@Type"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="contains($Target,'mailto:') or contains($Target,'http:') or contains($Target,'https:')">
          <text:a>
          <xsl:attribute name="xlink:href">
            <xsl:value-of select="$Target"/>
          </xsl:attribute>
            <xsl:copy-of select="$nodeTextSpan"/>
          </text:a>
        </xsl:when>
        <xsl:when test="contains($Target,'slide')">
          <text:a>
          <xsl:attribute name="xlink:href">
            <xsl:value-of select="concat('#Slide ',substring-before(substring-after($Target,'slide'),'.xml'))"/>
          </xsl:attribute>
            <xsl:copy-of select="$nodeTextSpan"/>
          </text:a>
        </xsl:when>
        <xsl:when test="contains($Target,'file:///')">
          <text:a>
          <xsl:attribute name="xlink:href">
            <xsl:value-of select="concat('file:///',translate(substring-after($Target,'file:///'),'\','/'))"/>
          </xsl:attribute>
            <xsl:copy-of select="$nodeTextSpan"/>
          </text:a>
        </xsl:when>
        <xsl:when test="contains($type,'hyperlink') and (contains($Target,'http:') or contains($Target,'https:'))">
          <text:a>
          <xsl:attribute name="xlink:href">
            <xsl:value-of select="$Target"/>
          </xsl:attribute>
            <xsl:copy-of select="$nodeTextSpan"/>
          </text:a>
        </xsl:when>
        <xsl:when test="contains($type,'hyperlink') and not(contains($Target,'http:')) and not(contains($Target,'https:'))">
          <!-- warn if hyperlink Path  -->
          <xsl:message terminate="no">translation.oox2odf.hyperlinkTypeRelativePath</xsl:message>
          <text:a>
          <xsl:attribute name="xlink:href">
            <!--Link Absolute Path-->
            <xsl:value-of select ="concat('hyperlink-path:',$Target)"/>
            <!--End-->
          </xsl:attribute>
            <xsl:copy-of select="$nodeTextSpan"/>
          </text:a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$nodeTextSpan"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
	  <!--
	  Defect: 2948306(Office2010 Compatibility)
	  By:     Vijayeta
	  Desc:   If the hyperlink is not provided to the text that is supposed to contain hyperlink, 
			  then the text is lost on reverse conversion that involves Office 2010 file. 
	  -->
	<xsl:if test="string-length($nodeAColonR/a:hlinkClick/@r:id) = 0">
		<xsl:copy-of select="$nodeTextSpan"/>
	</xsl:if>
	  <!--End of fix for 2948306-->
  </xsl:template>
  <!-- End - Template to Add hyperlinks defined at the Text level -->
  <!-- Template to generate GUID - Folder to copy the sound files -->
  <xsl:template name="GenerateGUIDForFolderName">
    <xsl:param name="RootNode"/>
    <xsl:variable name="GUIDOne">
      <xsl:value-of select="generate-id($RootNode)"/>
    </xsl:variable>
    <xsl:variable name="GUIDTwo">
      <xsl:value-of select="generate-id(child::node())"/>
    </xsl:variable>
    <xsl:variable name="GUIDThree">
      <xsl:value-of select="generate-id(.)"/>
    </xsl:variable>
    <xsl:value-of select="concat($GUIDOne,'-',$GUIDTwo,'-',$GUIDThree)"/>
  </xsl:template>
  <!-- End of template - GenerateGUIDForFolderName -->
  <xsl:template name="tmpUnderLine">
    <xsl:param name="SMName"/>
    <xsl:param name="u"/>
	<xsl:message terminate="no">progress:p:cSld</xsl:message>
    <xsl:if test ="./a:uFill/a:solidFill">
      <xsl:for-each select ="./a:uFill/a:solidFill">
      <xsl:attribute name ="style:text-underline-color">
          <xsl:call-template name="tmpSolidColor">
            <xsl:with-param name="SMName" select="$SMName"/>
        </xsl:call-template>
      </xsl:attribute>
      </xsl:for-each>
    </xsl:if>
    <xsl:choose >
      <xsl:when test ="$u='dbl'">
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
      <xsl:when test ="$u='heavy'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'solid'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'bold'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="$u='dotted'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'dotted'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'auto'"/>
        </xsl:attribute>
      </xsl:when>
      <!-- dottedHeavy-->
      <xsl:when test ="$u='dottedHeavy'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'dotted'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'bold'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="$u='dash'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'dash'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'auto'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="$u='dashHeavy'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'dash'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'bold'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="$u='dashLong'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'long-dash'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'auto'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="$u='dashLongHeavy'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'long-dash'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'bold'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="$u='dotDash'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'dot-dash'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'auto'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="$u='dotDashHeavy'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'dot-dash'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'bold'"/>
        </xsl:attribute>
      </xsl:when>
      <!-- dot-dot-dash-->
      <xsl:when test ="$u='dotDotDash'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'dot-dot-dash'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'auto'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="$u='dotDotDashHeavy'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'dot-dot-dash'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'bold'"/>
        </xsl:attribute>
      </xsl:when>
      <!-- Wavy and Heavy-->
      <xsl:when test ="$u='wavy'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'wave'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'auto'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="$u='wavyHeavy'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'wave'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'bold'"/>
        </xsl:attribute>
      </xsl:when>
      <!-- wavyDbl-->
      <!-- style:text-underline-style="wave" style:text-underline-type="double"-->
      <xsl:when test ="$u='wavyDbl'">
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
      <xsl:when test ="$u='sng'">
        <xsl:attribute name ="style:text-underline-type">
          <xsl:value-of select ="'single'"/>
        </xsl:attribute>
        <xsl:attribute name ="style:text-underline-width">
          <xsl:value-of select ="'auto'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test ="$u='none'">
        <xsl:attribute name ="style:text-underline-style">
          <xsl:value-of select ="'none'"/>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name ="tmpShapeTextProcess">
    <xsl:param name="ParaId"/>
    <xsl:param name="TypeId"/>
    <xsl:param name="SMName"/>
    <xsl:param name="DefFont"/>
    <xsl:param name="DefFontMinor"/>
    <xsl:param name="flagTextBox"/>
    
    <xsl:variable name ="slideRel" select ="concat('ppt/slides/_rels/',$TypeId,'.xml.rels')"/>
	<xsl:message terminate="no">progress:p:cSld</xsl:message>
    <xsl:message terminate="no">progress:a:p</xsl:message>
    <xsl:for-each select ="./p:txBody">
      <xsl:variable name="var_fontScale">
        <xsl:if test="./a:bodyPr/a:normAutofit/@fontScale">
          <xsl:value-of select="./a:bodyPr/a:normAutofit/@fontScale"/>
        </xsl:if>
        <xsl:if test="not(./a:bodyPr/a:normAutofit/@fontScale)">
          <xsl:value-of select="'100000'"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="var_lnSpcReduction">
        <xsl:if test="./a:bodyPr/a:normAutofit/@lnSpcReduction">
          <xsl:value-of select="./a:bodyPr/a:normAutofit/@lnSpcReduction"/>
        </xsl:if>
        <xsl:if test="not(./a:bodyPr/a:normAutofit/@lnSpcReduction)">
          <xsl:value-of select="'0'"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name ="listStyleName">
        <!-- Added by vijayeta, to get the text box number-->
        <xsl:variable name ="textNumber" select ="./parent::node()/p:nvSpPr/p:cNvPr/@id"/>
        <!-- Added by vijayeta, to get the text box number-->
        <xsl:choose>
          <xsl:when test ="./parent::node()/p:spPr/a:prstGeom/@prst or ./parent::node()/child::node()[1]/child::node()[1]/@name[contains(., 'TextBox')] or ./parent::node()/child::node()[1]/child::node()[1]/@name[contains(., 'Text Box')]">
            <xsl:value-of select ="concat($TypeId,'textboxshape_List',$textNumber)"/>
          </xsl:when>
          <xsl:otherwise >
            <xsl:value-of select ="concat($TypeId,'List',position())"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test ="(a:p/a:pPr/a:buChar) or (a:p/a:pPr/a:buAutoNum) or (a:p/a:pPr/a:buBlip) ">
        <xsl:call-template name ="insertBulletStyle">          
          <xsl:with-param name ="ParaId" select ="$ParaId"/>
          <xsl:with-param name ="listStyleName" select ="$listStyleName"/>
          <xsl:with-param name ="slideRel" select ="$slideRel"/>
          <xsl:with-param name ="flageShape" select ="'True'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:for-each select ="a:p">
        <xsl:variable name ="levelForDefFont">
          <xsl:choose>
          <xsl:when test ="a:pPr/@lvl">
            <xsl:value-of select ="a:pPr/@lvl"/>
          </xsl:when>
            <xsl:otherwise>
            <xsl:value-of select ="'0'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <style:style style:family="paragraph">
          <xsl:attribute name ="style:name">
            <xsl:value-of select ="concat($ParaId,position())"/>
          </xsl:attribute >
          <style:paragraph-properties  text:enable-numbering="false" >
            <xsl:if test ="parent::node()/a:bodyPr/@vert='vert'">
              <xsl:attribute name ="style:writing-mode">
                <xsl:value-of select ="'tb-rl'"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tmpSlideParagraphStyle">
              <xsl:with-param name="lnSpcReduction" select="$var_lnSpcReduction"/>
              <xsl:with-param name="level" select="$levelForDefFont+1"/>
              <xsl:with-param name="isShape" select="'true'"/>
            </xsl:call-template>
            <!-- added by vipul to get Paragraph propreties from Presentation.xml-->
            <!--<xsl:if test="$levelForDefFont !='' and $levelForDefFont !='0' ">-->
              <xsl:call-template name="tmpPresentationDefaultParagraphStyle">
              <xsl:with-param name="lnSpcReduction" select="$var_lnSpcReduction"/>
              <xsl:with-param name="level" select="$levelForDefFont+1"/>
                <xsl:with-param name="SMName" select="$SMName"/>
            </xsl:call-template>
            <!--</xsl:if>-->
            <xsl:if test ="a:pPr/a:buChar or a:pPr/a:buAutoNum or a:pPr/a:buBlip ">
              <xsl:choose >
                <xsl:when test ="not(a:r/a:t)">
                  <xsl:attribute name="text:enable-numbering">
                    <xsl:value-of select ="'false'"/>
                  </xsl:attribute>
                </xsl:when>
                <xsl:otherwise >
                  <xsl:attribute name="text:enable-numbering">
                    <xsl:value-of select ="'true'"/>
                  </xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <!-- @@Code for Paragraph tabs Pradeep Nemadi -->
            <!-- Starts-->
            <xsl:choose>
              <xsl:when test ="a:pPr/a:tabLst/a:tab">
              <xsl:call-template name ="paragraphTabstops">
                <xsl:with-param name ="isSahpe" select ="'true'"/>
                <xsl:with-param name="level" select="$levelForDefFont + 1"/>
              </xsl:call-template >                 
              </xsl:when>
              <xsl:when test ="a:pPr/@defTabSz">
              <xsl:call-template name ="paragraphTabstops">
                  <xsl:with-param name ="defaultPos" select ="a:pPr/@defTabSz"/>
                <xsl:with-param name ="isSahpe" select ="'true'"/>
                <xsl:with-param name="level" select="$levelForDefFont + 1"/>
              </xsl:call-template >
              </xsl:when>
              <xsl:when test = "not(a:pPr/a:tabLst/a:tab)">
                <xsl:variable name="tabStopValue">
                  <xsl:variable name="nodeName" select="concat('a:lvl',$levelForDefFont + 1 ,'pPr')"/>
                  <xsl:for-each select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle//child::node()[name()=$nodeName]">
                    <xsl:choose>
                      <xsl:when test ="a:defRPr/a:tabLst/a:tab">
                        <xsl:value-of select="a:defRPr/a:tabLst/a:tab[1]/@pos"/>
                      </xsl:when>
                      <xsl:when test ="@defTabSz">
                        <xsl:value-of select="@defTabSz"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="'914400'"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                </xsl:variable>
                <xsl:call-template name ="paragraphTabstops">
                  <xsl:with-param name ="defaultPos" select ="$tabStopValue"/>
                  <xsl:with-param name ="isSahpe" select ="'true'"/>
                  <xsl:with-param name="level" select="$levelForDefFont + 1"/>
                </xsl:call-template >
              </xsl:when>
            </xsl:choose>
          
            <!-- Ends -->
          </style:paragraph-properties >
        </style:style>
        <xsl:for-each select ="node()" >
          <!-- Add here-->
          <xsl:if test ="name()='a:r'">
            <style:style style:family="text">
              <xsl:attribute name="style:name">
                <xsl:value-of select="concat($TypeId,generate-id())"/>
              </xsl:attribute>
              <style:text-properties style:font-charset="x-symbol">
                <xsl:for-each select ="a:rPr">
                <xsl:call-template name="tmpSlideTextProperty">
                  <xsl:with-param name="DefFont" select="$DefFont"/>
                  <xsl:with-param name="DefFontMinor" select="$DefFontMinor"/>
                  <xsl:with-param name="fontscale" select="$var_fontScale"/>
                  <xsl:with-param name="SMName" select="$SMName"/>
                </xsl:call-template>
                </xsl:for-each>
                <!-- added by vipul to get text propreties from Presentation.xml-->
                <xsl:call-template name="tmpPresentationDefaultTextProp">
                  <xsl:with-param name="DefFont" select="$DefFont"/>
                  <xsl:with-param name="DefFontMinor" select="$DefFontMinor"/>
                  <xsl:with-param name="level" select="$levelForDefFont+1"/>
                  <xsl:with-param name="fontscale" select="$var_fontScale"/>
                  <xsl:with-param name="SMName" select="$SMName"/>
                  <xsl:with-param name="flagTextBox" select="$flagTextBox"/>
                </xsl:call-template>
                
              </style:text-properties>
            </style:style>
          </xsl:if>
          <xsl:if test ="name()='a:fld'">
            <xsl:variable name="pos" select="position()"/>
            <style:style style:family="text">
              <xsl:attribute name="style:name">
                <xsl:value-of select="concat($TypeId,generate-id())"/>
              </xsl:attribute>
              <style:text-properties style:font-charset="x-symbol">
                <xsl:for-each select ="a:rPr">
                <xsl:call-template name="tmpSlideTextProperty">
                  <xsl:with-param name="DefFont" select="$DefFont"/>
                  <xsl:with-param name="DefFontMinor" select="$DefFontMinor"/>
                  <xsl:with-param name="fontscale" select="$var_fontScale"/>
                  <xsl:with-param name="SMName" select="$SMName"/>
                </xsl:call-template>
                </xsl:for-each>
                <!-- added by vipul to get text propreties from Presentation.xml-->
                <xsl:call-template name="tmpPresentationDefaultTextProp">
                  <xsl:with-param name="DefFont" select="$DefFont"/>
                  <xsl:with-param name="DefFontMinor" select="$DefFontMinor"/>
                  <xsl:with-param name="level" select="$levelForDefFont+1"/>
                  <xsl:with-param name="fontscale" select="$var_fontScale"/>
                  <xsl:with-param name="SMName" select="$SMName"/>
                  <xsl:with-param name="flagTextBox" select="$flagTextBox"/>
                </xsl:call-template>

              </style:text-properties>
            </style:style>
          </xsl:if>
          <!-- Added by lohith.ar for fix 1731885-->
          <xsl:if test ="name()='a:endParaRPr'">
            <style:style style:family="text">
              <xsl:attribute name="style:name">
                <xsl:value-of select="concat($TypeId,generate-id())"/>
              </xsl:attribute>
              <style:text-properties style:font-charset="x-symbol">
                <xsl:call-template name="tmpFontName">
                  <xsl:with-param name="DefFont" select="$DefFont"/>
                </xsl:call-template>
                <xsl:attribute name ="style:font-family-generic"	>
                  <xsl:value-of select ="'roman'"/>
                </xsl:attribute>
                <xsl:attribute name ="style:font-pitch"	>
                  <xsl:value-of select ="'variable'"/>
                </xsl:attribute>
                <xsl:if test ="./@sz">
                  <xsl:attribute name ="fo:font-size"	>
                    <xsl:for-each select ="./@sz">
                      <xsl:value-of select ="concat(format-number(. div 100,'#.##'), 'pt')"/>
                    </xsl:for-each>
                    </xsl:attribute>
                 </xsl:if>
                <xsl:if test ="not(./@sz)">
                 <!--Changed in code for performance-->
                        <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/a:lvl1pPr/a:defRPr/@sz">
                      <xsl:attribute name ="fo:font-size">
                            <xsl:value-of  select ="concat(format-number(. div 100,'#.##'),'pt')"/>
                    </xsl:attribute>
                    </xsl:for-each>
                        </xsl:if>
         </style:text-properties>
            </style:style>
                        </xsl:if>
                      </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name ="tmpTableTextParaProp">
    <xsl:param name="ParaId"/>
    <xsl:param name="TypeId"/>
    <xsl:param name="SMName"/>
    <xsl:param name="DefFont"/>

    <xsl:variable name ="slideRel" select ="concat('ppt/slides/_rels/',$TypeId,'.xml.rels')"/>
    <xsl:message terminate="no">progress:p:cSld</xsl:message>
    <xsl:message terminate="no">progress:a:p</xsl:message>
    <xsl:for-each select ="./a:txBody">
      <xsl:variable name="var_fontScale">
        <xsl:if test="./a:bodyPr/a:normAutofit/@fontScale">
          <xsl:value-of select="./a:bodyPr/a:normAutofit/@fontScale"/>
        </xsl:if>
        <xsl:if test="not(./a:bodyPr/a:normAutofit/@fontScale)">
          <xsl:value-of select="'100000'"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="var_lnSpcReduction">
        <xsl:if test="./a:bodyPr/a:normAutofit/@lnSpcReduction">
          <xsl:value-of select="./a:bodyPr/a:normAutofit/@lnSpcReduction"/>
        </xsl:if>
        <xsl:if test="not(./a:bodyPr/a:normAutofit/@lnSpcReduction)">
          <xsl:value-of select="'0'"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name ="listStyleName">
        <xsl:value-of select ="concat($TypeId,'List',position())"/>
      </xsl:variable>
      <xsl:if test ="(a:p/a:pPr/a:buChar) or (a:p/a:pPr/a:buAutoNum) or (a:p/a:pPr/a:buBlip) ">
        <xsl:call-template name ="insertBulletStyle">
          <xsl:with-param name ="ParaId" select ="$ParaId"/>
          <xsl:with-param name ="listStyleName" select ="$listStyleName"/>
          <xsl:with-param name ="slideRel" select ="$slideRel"/>
          <xsl:with-param name ="flageShape" select ="'True'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:for-each select ="a:p">
        <xsl:variable name ="levelForDefFont">
          <xsl:choose>
            <xsl:when test ="a:pPr/@lvl">
              <xsl:value-of select ="a:pPr/@lvl"/>
                  </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select ="'0'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <style:style style:family="paragraph">
          <xsl:attribute name ="style:name">
            <xsl:value-of select ="concat($ParaId,generate-id(),position())"/>
          </xsl:attribute >
          <style:paragraph-properties  text:enable-numbering="false" >
            <xsl:if test ="parent::node()/a:bodyPr/@vert='vert'">
              <xsl:attribute name ="style:writing-mode">
                <xsl:value-of select ="'tb-rl'"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tmpSlideParagraphStyle">
              <xsl:with-param name="lnSpcReduction" select="$var_lnSpcReduction"/>
              <xsl:with-param name="level" select="$levelForDefFont+1"/>
            </xsl:call-template>
                  
            <xsl:if test ="a:pPr/a:buChar or a:pPr/a:buAutoNum or a:pPr/a:buBlip ">
              <xsl:choose >
                <xsl:when test ="not(a:r/a:t)">
                  <xsl:attribute name="text:enable-numbering">
                    <xsl:value-of select ="'false'"/>
                    </xsl:attribute>
                  </xsl:when>
                <xsl:otherwise >
                  <xsl:attribute name="text:enable-numbering">
                    <xsl:value-of select ="'true'"/>
                  </xsl:attribute>
                </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:choose>
              <xsl:when test ="a:pPr/a:tabLst/a:tab">
              <xsl:call-template name ="paragraphTabstops">
                <xsl:with-param name ="isSahpe" select ="'true'"/>
                <xsl:with-param name="level" select="$levelForDefFont + 1"/>
              </xsl:call-template >
              </xsl:when>
              <xsl:when test ="a:pPr/@defTabSz">
                <xsl:call-template name ="paragraphTabstops">
                  <xsl:with-param name ="defaultPos" select ="a:pPr/@defTabSz"/>
                  <xsl:with-param name ="isSahpe" select ="'true'"/>
                  <xsl:with-param name="level" select="$levelForDefFont + 1"/>
                </xsl:call-template >
              </xsl:when>
              <xsl:when test = "not(a:pPr/a:tabLst/a:tab)">
              <xsl:call-template name ="paragraphTabstops">
                <xsl:with-param name ="defaultPos" select ="'914400'"/>
                <xsl:with-param name ="isSahpe" select ="'true'"/>
                <xsl:with-param name="level" select="$levelForDefFont + 1"/>
              </xsl:call-template >
              </xsl:when>
            </xsl:choose>
          </style:paragraph-properties >
        </style:style>
        <xsl:for-each select ="node()" >
          <xsl:if test ="name()='a:r'">
            <style:style style:family="text">
              <xsl:attribute name="style:name">
                <xsl:value-of select="concat($TypeId,generate-id())"/>
                </xsl:attribute>
              <style:text-properties style:font-charset="x-symbol">
                <xsl:for-each select ="a:rPr">
                  <xsl:call-template name="tmpSlideTextProperty">
                    <xsl:with-param name="DefFont" select="$DefFont"/>
                    <xsl:with-param name="fontscale" select="$var_fontScale"/>
                    <xsl:with-param name="SMName" select="$SMName"/>
                  </xsl:call-template>
                </xsl:for-each>
              </style:text-properties>
            </style:style>
          </xsl:if>
          <xsl:if test ="name()='a:endParaRPr'">
            <style:style style:family="text">
              <xsl:attribute name="style:name">
                <xsl:value-of select="concat($TypeId,generate-id())"/>
                </xsl:attribute>
              <style:text-properties style:font-charset="x-symbol">
                <xsl:call-template name="tmpFontName">
                  <xsl:with-param name="DefFont" select="$DefFont"/>
                </xsl:call-template>
                <xsl:attribute name ="style:font-family-generic"	>
                  <xsl:value-of select ="'roman'"/>
                </xsl:attribute>
                <xsl:attribute name ="style:font-pitch"	>
                  <xsl:value-of select ="'variable'"/>
                </xsl:attribute>
                <xsl:if test ="./@sz">
                  <xsl:attribute name ="fo:font-size"	>
                    <xsl:for-each select ="./@sz">
                      <xsl:value-of select ="concat(format-number(. div 100,'#.##'), 'pt')"/>
                    </xsl:for-each>
                  </xsl:attribute>
                </xsl:if>
                  <xsl:if test ="not(./@sz)">
                <!--Changde in code for performance-->
                    <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/a:lvl1pPr/a:defRPr/@sz">
                      <xsl:attribute name ="fo:font-size">
                        <xsl:value-of  select ="concat(format-number(. div 100,'#.##'),'pt')"/>
                      </xsl:attribute>
                    </xsl:for-each>
                  </xsl:if>
         </style:text-properties>
            </style:style>
          </xsl:if>
        </xsl:for-each >
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="tmpLayoutTabStop">
    <xsl:param name="spType"/>
    <xsl:param name="level"/>
    <xsl:param name="SMName"/>
    <xsl:param name="LayoutFileName"/>
    <xsl:param name="index"/>
    <xsl:variable name="nodeName" select="concat('a:lvl',$level ,'pPr')"/>
    <xsl:choose>
      <xsl:when  test="$spType='outline'">
        <xsl:for-each select="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@idx=$index and ( not(@type) or @type='body')]">
          <xsl:choose>
            <xsl:when test="parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]/a:defRPr/a:tabLst/a:tab
                            | parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]/@defTabSz">
              <xsl:for-each select="parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]">
                <xsl:choose>
                  <xsl:when test ="a:defRPr/a:tabLst/a:tab">
                    <xsl:value-of select="a:defRPr/a:tabLst/a:tab[1]/@pos"/>
                  </xsl:when>
                  <xsl:when test ="@defTabSz">
                    <xsl:value-of select="@defTabSz"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]">
                <xsl:choose>
                  <xsl:when test ="a:defRPr/a:tabLst/a:tab">
                    <xsl:value-of select="a:defRPr/a:tabLst/a:tab[1]/@pos"/>
                  </xsl:when>
                  <xsl:when test ="@defTabSz">
                    <xsl:value-of select="@defTabSz"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="'914400'"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:otherwise>
          
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:when  test="$spType='title'">
        <xsl:for-each select="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='title' or @type='ctrTitle']">
          <xsl:choose>
            <xsl:when test="parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]/a:defRPr/a:tabLst/a:tab
                            | parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]/@defTabSz">
              <xsl:for-each select="parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]">
                <xsl:choose>
                  <xsl:when test ="a:defRPr/a:tabLst/a:tab">
                    <xsl:value-of select="a:defRPr/a:tabLst/a:tab[1]/@pos"/>
                  </xsl:when>
                  <xsl:when test ="@defTabSz">
                    <xsl:value-of select="@defTabSz"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
         
              <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:titleStyle/child::node()[name()=$nodeName]">
                <xsl:choose>
                  <xsl:when test ="a:defRPr/a:tabLst/a:tab">
                    <xsl:value-of select="a:defRPr/a:tabLst/a:tab[1]/@pos"/>
                  </xsl:when>
                  <xsl:when test ="@defTabSz">
                    <xsl:value-of select="@defTabSz"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="'914400'"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:otherwise>

          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:when  test="$spType='subtitle'">
        <xsl:for-each select="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='subTitle']">
          <xsl:choose>
            <xsl:when test="parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]/a:defRPr/a:tabLst/a:tab
                            | parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]/@defTabSz">
              <xsl:for-each select="parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]">
                <xsl:choose>
                  <xsl:when test ="a:defRPr/a:tabLst/a:tab">
                    <xsl:value-of select="a:defRPr/a:tabLst/a:tab[1]/@pos"/>
                  </xsl:when>
                  <xsl:when test ="@defTabSz">
                    <xsl:value-of select="@defTabSz"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$SMName))//p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]">
                <xsl:choose>
                  <xsl:when test ="a:defRPr/a:tabLst/a:tab">
                    <xsl:value-of select="a:defRPr/a:tabLst/a:tab[1]/@pos"/>
                  </xsl:when>
                  <xsl:when test ="@defTabSz">
                    <xsl:value-of select="@defTabSz"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:for-each>
            </xsl:otherwise>

          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name ="paragraphTabstops">
    <xsl:param name="level"/>
    <xsl:param name="LayoutFileName"/>
    <xsl:param name="index"/>
    <xsl:param name="slideMasterName"/>
    <xsl:param name="spType"/>
    <xsl:param name="defaultPos"/>
    <xsl:param name="isSahpe"/>
        <xsl:variable name ="nodeName">
      <xsl:value-of select ="concat('a:lvl',$level,'pPr')"/>
    </xsl:variable>
    <xsl:variable name="var_MarL">
      <xsl:if test ="a:pPr/@marL">
          <xsl:value-of select="a:pPr/@marL"/>
      </xsl:if>
      <xsl:if test ="not(a:pPr/@marL)">
        <xsl:choose>
          <xsl:when test="$isSahpe='true'">
                <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/@marL">
                  <xsl:value-of select="."/>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
            <xsl:if test="$spType='outline'">
              <xsl:for-each select="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph">
                <xsl:if test ="./@idx=$index">
                  <xsl:if test="not(./@type) or ./@type='body'">
                    <xsl:if test ="parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]/@marL">
                      <xsl:value-of select="parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]/@marL"/>
                    </xsl:if>
                    <xsl:if test ="not(parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]/@marL)">
                      <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMasterName))//p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]/@marL">
                           <xsl:value-of select="."/>
                       </xsl:for-each>
                    </xsl:if>
                  </xsl:if>
                </xsl:if>
              </xsl:for-each>
            </xsl:if>
            <xsl:if test="$spType!='outline'">
              <xsl:choose>
                <xsl:when test="$spType='title'">
                  <xsl:for-each select="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='ctrTitle' or @type= 'title']">
                    <xsl:if test ="parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]/@marL">
                      <xsl:value-of select="parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]/@marL"/>
                    </xsl:if>
                    <xsl:if test ="not(parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]/@marL)">
						<xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMasterName))//p:txStyles/p:titleStyle/child::node()[name()=$nodeName]/@marL">
                          <xsl:value-of select="."/>
                   </xsl:for-each>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:when>
                <xsl:when test="$spType='subtitle'">
                  <xsl:for-each select="key('Part', concat('ppt/slideLayouts/',$LayoutFileName))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@type='subTitle']">
                    <xsl:if test ="parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]/@marL">
                      <xsl:value-of select="parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]/@marL"/>
                    </xsl:if>
                    <xsl:if test ="not(parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]/@marL)">
						  <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMasterName))//p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]/@marL">
                          <xsl:value-of select="."/>
                </xsl:for-each>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:when>
                <xsl:when test="$spType='body'">
                  <xsl:if test ="parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]/@marL">
                    <xsl:value-of select="parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]/@marL"/>
                  </xsl:if>
                  <xsl:if test ="not(parent::node()/parent::node()/parent::node()/p:txBody//child::node()[name()=$nodeName]/@marL)">
						<xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMasterName))//p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]/@marL">
                        <xsl:value-of select="."/>
                   </xsl:for-each>

                  </xsl:if>
                </xsl:when>
              
              </xsl:choose>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:if>
       
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="a:pPr/a:tabLst/a:tab">
        <style:tab-stops>
          <xsl:for-each select ="a:pPr/a:tabLst/a:tab">
          <style:tab-stop>
            <xsl:attribute name ="style:position">
				<xsl:choose>
					<xsl:when test="$var_MarL =''">
						<xsl:value-of select ="concat(format-number(@pos  div 360000,'#.##'),'cm')"/>
					</xsl:when>
					<xsl:otherwise>
                <xsl:value-of select ="concat(format-number((@pos - $var_MarL) div 360000,'#.##'),'cm')"/>
					</xsl:otherwise>
				</xsl:choose>
            </xsl:attribute>
            <xsl:if test ="@algn">
              <xsl:attribute name ="style:type">
                <xsl:choose >
                  <xsl:when test ="@algn='ctr'">
                    <xsl:value-of select ="'center'"/>
                  </xsl:when>
                  <xsl:when test ="@algn='r'">
                    <xsl:value-of select ="'right'"/>
                  </xsl:when>
                  <xsl:when test ="@algn='l'">
                    <xsl:value-of select ="'left'"/>
                  </xsl:when>
                  <xsl:when test ="@algn='dec'">
                    <xsl:value-of select ="'char'"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:attribute>
            </xsl:if>
          </style:tab-stop >
          </xsl:for-each>
        </style:tab-stops>
      </xsl:when>
      <xsl:when test="$defaultPos!=''">
    <style:tab-stops>
           <style:tab-stop>
          <xsl:attribute name ="style:position">
			  <xsl:choose>
				  <xsl:when test="$var_MarL =''">
					  <xsl:value-of select ="concat(format-number($defaultPos  div 360000,'#.##'),'cm')"/>
				  </xsl:when>
				  <xsl:otherwise>
              <xsl:value-of select ="concat(format-number(($defaultPos - $var_MarL) div 360000,'#.##'),'cm') "/>
				  </xsl:otherwise>
			  </xsl:choose>
          </xsl:attribute>
          <xsl:if test ="@algn">
            <xsl:attribute name ="style:type">
              <xsl:choose >
                <xsl:when test ="@algn='ctr'">
                  <xsl:value-of select ="'center'"/>
                </xsl:when>
                <xsl:when test ="@algn='r'">
                  <xsl:value-of select ="'right'"/>
                </xsl:when>
                <xsl:when test ="@algn='l'">
                  <xsl:value-of select ="'left'"/>
                </xsl:when>
                <xsl:when test ="@algn='dec'">
                  <xsl:value-of select ="'char'"/>
                </xsl:when>
              </xsl:choose>
            </xsl:attribute>
          </xsl:if>
        </style:tab-stop >
        </style:tab-stops>
      </xsl:when>
    </xsl:choose>         
  </xsl:template>
  <!-- Hand out Common Templates-->
  <xsl:template name="tmpHMParagraphStyle">
    <!--Text alignment-->
    <xsl:if test ="./p:txBody/a:p/a:pPr/@algn">
      <xsl:attribute name ="fo:text-align">
        <xsl:choose>
          <!-- Center Alignment-->
          <xsl:when test ="./p:txBody/a:p/a:pPr/@algn ='ctr'">
            <xsl:value-of select ="'center'"/>
          </xsl:when>
          <!-- Right Alignment-->
          <xsl:when test ="./p:txBody/a:p/a:pPr/@algn ='r'">
            <xsl:value-of select ="'end'"/>
          </xsl:when>
          <!-- Left Alignment-->
          <xsl:when test ="./p:txBody/a:p/a:pPr/@algn ='l'">
            <xsl:value-of select ="'start'"/>
          </xsl:when>
          <!-- Added by lohith - for fix 1737161-->
          <xsl:when test ="./p:txBody/a:p/a:pPr/@algn ='just'">
            <xsl:value-of select ="'justify'"/>
          </xsl:when>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if >
    <!-- Convert Laeft margin of the paragraph-->
    <xsl:if test ="./p:txBody/a:p/a:pPr/@marL">
      <xsl:attribute name ="fo:margin-left">
        <xsl:value-of select="concat(format-number( ./p:txBody/a:p/a:pPr/@marL div 360000, '#.##'), 'cm')"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test ="./p:txBody/a:p/a:pPr/@marR">
      <xsl:attribute name ="fo:margin-right">
        <xsl:value-of select="concat(format-number(./p:txBody/a:p/a:pPr/@marR div 360000, '#.##'), 'cm')"/>
      </xsl:attribute>
    </xsl:if>
    <!--<xsl:if test ="./@indent">
      <xsl:attribute name ="fo:text-indent">
        <xsl:value-of select="concat(format-number(./@indent div 360000, '#.##'), 'cm')"/>
      </xsl:attribute>
    </xsl:if >-->
    <xsl:if test ="./p:txBody/a:lstStyle/a:lvl1pPr/a:defRPr/@sz">
      <xsl:variable name="var_fontsize">
        <xsl:value-of select="./p:txBody/a:lstStyle/a:lvl1pPr/a:defRPr/@sz"/>
      </xsl:variable>
      <xsl:for-each select="./p:txBody/a:p/a:pPr/a:spcBef/a:spcPct">
        <xsl:if test ="@val">
          <xsl:attribute name ="fo:margin-top">
            <xsl:value-of select="concat(format-number( (( $var_fontsize * ( @val div 100000 ) ) div 2835) * 1.2  ,'#.###'),'cm')"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="./p:txBody/a:p/a:pPr/a:spcAft/a:spcPct">
        <xsl:if test ="@val">
          <xsl:attribute name ="fo:margin-bottom">
            <xsl:value-of select="concat(format-number( (( $var_fontsize * ( @val div 100000 ) ) div 2835 ) * 1.2 ,'#.###'),'cm')"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
    <xsl:for-each select="./p:txBody/a:p/a:pPr/a:spcAft/a:spcPts">
      <xsl:if test ="@val">
        <xsl:attribute name ="fo:margin-bottom">
          <xsl:value-of select="concat(format-number(@val div  2835 ,'#.##'),'cm')"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="./p:txBody/a:p/a:pPr/a:spcBef/a:spcPts">
      <xsl:if test ="@val">
        <xsl:attribute name ="fo:margin-top">
          <xsl:value-of select="concat(format-number(@val div  2835 ,'#.##'),'cm')"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="./p:txBody/a:p/a:pPr/a:lnSpc">
      <xsl:if test ="./a:spcPct">
        <!--<xsl:choose>
          <xsl:when test="$lnSpcReduction='0'">-->
        <xsl:attribute name="fo:line-height">
          <xsl:value-of select="concat(format-number(./a:spcPct/@val div 1000,'###'), '%')"/>
        </xsl:attribute>
        <!--</xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="fo:line-height">
              <xsl:value-of select="concat(format-number((./a:spcPct/@val - $lnSpcReduction) div 1000,'###'), '%')"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>-->
      </xsl:if >
      <xsl:if test ="./a:spcPts">
        <xsl:attribute name="style:line-height-at-least">
          <xsl:value-of select="concat(format-number(./a:spcPts/@val div 2835, '#.##'), 'cm')"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="tmpHandOutTextProperty">
    <xsl:param name ="DefFont" />
    <xsl:param name ="fontscale"/>
    <xsl:if test ="a:rPr/@sz">
      <xsl:attribute name ="fo:font-size"	>
        <xsl:for-each select ="a:rPr/@sz">
          <xsl:choose>
            <xsl:when test="$fontscale ='100000'">
              <xsl:value-of  select ="concat(format-number(. div 100,'#.##'),'pt')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of  select ="concat(format-number(round((. *($fontscale div 1000) )div 10000),'#.##'),'pt')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test ="a:rPr/a:latin/@typeface">
      <xsl:attribute name ="fo:font-family">
        <xsl:variable name ="typeFaceVal" select ="a:rPr/a:latin/@typeface"/>
        <xsl:for-each select ="a:rPr/a:latin/@typeface">
          <xsl:if test ="$typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt'">
            <xsl:value-of  select ="$DefFont"/>
          </xsl:if>
          <xsl:if test ="not($typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt')">
            <xsl:value-of select ="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:attribute>
    </xsl:if>
    <!-- strike style:text-line-through-style-->
    <xsl:if test ="a:rPr/@strike">
      <xsl:if test ="a:rPr/@strike!='noStrike'">
      <xsl:attribute name ="style:text-line-through-style">
        <xsl:value-of select ="'solid'"/>
      </xsl:attribute>
      <xsl:choose >
        <xsl:when test ="a:rPr/@strike='dblStrike'">
          <xsl:attribute name ="style:text-line-through-type">
            <xsl:value-of select ="'double'"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test ="a:rPr/@strike='sngStrike'">
          <xsl:attribute name ="style:text-line-through-type">
            <xsl:value-of select ="'single'"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
    </xsl:if>
    <!-- Kening Property-->
    <xsl:if test ="a:rPr/@kern">
      <xsl:choose >
        <xsl:when test ="a:rPr/@kern = '0'">
          <xsl:attribute name ="style:letter-kerning">
            <xsl:value-of select ="'false'"/>
          </xsl:attribute >
        </xsl:when >
        <xsl:when test ="format-number(a:rPr/@kern,'#.##') &gt; 0">
          <xsl:attribute name ="style:letter-kerning">
            <xsl:value-of select ="'true'"/>
          </xsl:attribute >
        </xsl:when >
      </xsl:choose>
    </xsl:if >
    <!-- Bold Property-->
    <xsl:if test ="a:rPr/@b">
      <xsl:if test ="a:rPr/@b='1'">
        <xsl:attribute name ="fo:font-weight">
          <xsl:value-of select ="'bold'"/>
        </xsl:attribute>
      </xsl:if >
      <xsl:if test ="a:rPr/@b='0'">
        <xsl:attribute name ="fo:font-weight">
          <xsl:value-of select ="'normal'"/>
        </xsl:attribute>
      </xsl:if >
    </xsl:if >
    <!--UnderLine-->
    <xsl:if test ="a:rPr/@u">
      <xsl:for-each select ="a:rPr">
        <xsl:call-template name="tmpUnderLine">
          <xsl:with-param name="u" select="@u"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if >
    <!-- Italic-->
    <xsl:if test ="a:rPr/@i">
      <xsl:attribute name ="fo:font-style">
        <xsl:if test ="a:rPr/@i='1'">
          <xsl:value-of select ="'italic'"/>
        </xsl:if >
        <xsl:if test ="a:rPr/@i='0'">
          <xsl:value-of select ="'none'"/>
        </xsl:if>
      </xsl:attribute>
    </xsl:if >
    <!-- Character Spacing -->
    <xsl:if test ="a:rPr/@spc">
      <xsl:attribute name ="fo:letter-spacing">
        <xsl:variable name="length" select="a:rPr/@spc" />
        <xsl:value-of select="concat(format-number($length * 2.54 div 7200,'#.###'),'cm')"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:if test ="a:rPr/a:solidFill/a:srgbClr/@val">
      <xsl:attribute name ="fo:color">
        <xsl:value-of select ="translate(concat('#',a:rPr/a:solidFill/a:srgbClr/@val),$ucletters,$lcletters)"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test ="a:rPr/a:solidFill/a:schemeClr/@val">
      <xsl:attribute name ="fo:color">
        <xsl:call-template name ="getColorCode">
          <xsl:with-param name ="color">
            <xsl:value-of select="a:rPr/a:solidFill/a:schemeClr/@val"/>
          </xsl:with-param>
          <xsl:with-param name ="lumMod">
            <xsl:value-of select="a:rPr/a:solidFill/a:schemeClr/a:lumMod/@val"/>
          </xsl:with-param>
          <xsl:with-param name ="lumOff">
            <xsl:value-of select="a:rPr/a:solidFill/a:schemeClr/a:lumOff/@val"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>
    </xsl:if>
   
    <!--Shadow fo:text-shadow-->
    <xsl:if test ="a:rPr/a:effectLst/a:outerShdw">
      <xsl:attribute name ="fo:text-shadow">
        <xsl:value-of select ="'1pt 1pt'"/>
      </xsl:attribute>
    </xsl:if>
    <!--SuperScript and SubScript for Text added by Mathi on 31st Jul 2007-->
    <xsl:if test="(a:rPr/@baseline)">
      <xsl:variable name="baseData">
        <xsl:value-of select="a:rPr/@baseline"/>
      </xsl:variable>
      <xsl:variable name="subSuperScriptValue">
        <xsl:value-of select="number(format-number($baseData div 1000,'#'))"/>
          </xsl:variable>
      <xsl:call-template name="tmpSubSuperScript">
        <xsl:with-param name="baseline" select="$baseData"/>
        <xsl:with-param name="subSuperScriptValue" select="$subSuperScriptValue"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <xsl:template name ="tmpPresentationDefaultTextProp">
    <xsl:param name="level"/>
    <xsl:param name="DefFont"/>
    <xsl:param name="DefFontMinor"/>
    <xsl:param name="SMName"/>
    <xsl:param name="flagTextBox"/>
    <xsl:message terminate="no">progress:p:cSld</xsl:message>
    <xsl:message terminate="no">progress:a:p</xsl:message>
    <xsl:variable name ="nodeName">
      <xsl:value-of select ="concat('a:lvl',$level,'pPr')"/>
    </xsl:variable>
    <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:if test ="not(a:rPr/@sz)">
     <!--Changed in code for performance-->
      <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr/@sz">
          <xsl:attribute name ="fo:font-size">
          <xsl:value-of  select ="concat(format-number(. div 100,'#.##'),'pt')"/>
          </xsl:attribute>
          <xsl:attribute name ="style:font-size-asian">
          <xsl:value-of  select ="concat(format-number(. div 100,'#.##'),'pt')"/>
          </xsl:attribute>
        </xsl:for-each>
      </xsl:if>
      <xsl:if test ="not(a:rPr/@strike)">
      <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr[@strike!='noStrike']">
              <xsl:attribute name ="style:text-line-through-style">
                <xsl:value-of select ="'solid'"/>
              </xsl:attribute>
              <xsl:choose >
                <xsl:when test ="@strike='dblStrike'">
                  <xsl:attribute name ="style:text-line-through-type">
                    <xsl:value-of select ="'double'"/>
                  </xsl:attribute>
                </xsl:when>
                <xsl:when test ="@strike='sngStrike'">
                  <xsl:attribute name ="style:text-line-through-type">
                    <xsl:value-of select ="'single'"/>
                  </xsl:attribute>
                </xsl:when>
              </xsl:choose>
            </xsl:for-each>
          </xsl:if>
    <xsl:if test ="not(a:rPr/@kern)">
          <xsl:if test="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr/@kern">
        <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr">
          <xsl:choose >
            <xsl:when test ="@kern = '0'">
              <xsl:attribute name ="style:letter-kerning">
                <xsl:value-of select ="'false'"/>
              </xsl:attribute >
            </xsl:when >
            <xsl:when test ="format-number(@kern,'#.##') &gt; 0">
              <xsl:attribute name ="style:letter-kerning">
                <xsl:value-of select ="'true'"/>
              </xsl:attribute >
            </xsl:when >
          </xsl:choose>
        </xsl:for-each>
      </xsl:if>
          </xsl:if>
    <xsl:if test ="not(a:rPr/@b)">
         <xsl:if test="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr/@b">
        <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr">
              <xsl:if test ="@b='1'">
                <xsl:attribute name ="fo:font-weight">
                  <xsl:value-of select ="'bold'"/>
                </xsl:attribute>
              </xsl:if >
              <xsl:if test ="@b='0'">
                <xsl:attribute name ="fo:font-weight">
                  <xsl:value-of select ="'normal'"/>
                </xsl:attribute>
              </xsl:if >
            </xsl:for-each>
          </xsl:if>
       </xsl:if>
    <xsl:if test ="not(a:rPr/@u)">
          <xsl:if test="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr/@u">
        <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr">
          <xsl:call-template name="tmpUnderLine">
            <xsl:with-param name="SMName" select="$SMName"/>
            <xsl:with-param name="u" select="@u"/>
          </xsl:call-template>
            </xsl:for-each>
          </xsl:if>
          </xsl:if>
    <xsl:if test ="not(a:rPr/@i)">
            <xsl:if test="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr/@i">
        <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr">
          <xsl:attribute name ="fo:font-style">
            <xsl:if test ="@i='1'">
              <xsl:value-of select ="'italic'"/>
            </xsl:if >
            <xsl:if test ="@i='0'">
              <xsl:value-of select ="'none'"/>
            </xsl:if>
          </xsl:attribute>
        </xsl:for-each>
      </xsl:if>
           </xsl:if>
    <xsl:if test ="not(a:rPr/@spc)">
      <xsl:if test="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr/@spc">
        <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr">
          <xsl:attribute name ="fo:letter-spacing">
            <xsl:variable name="length" select="@spc" />
            <xsl:value-of select="concat(format-number($length * 2.54 div 7200,'#.###'),'cm')"/>
          </xsl:attribute>
        </xsl:for-each>
      </xsl:if>
    </xsl:if>
    <xsl:choose>
      <xsl:when test ="a:rPr/a:latin/@typeface"/>
      <xsl:when test ="a:rPr/a:ea/@typeface and a:rPr/@lang!='en-US'"/>
      <xsl:when test ="parent::node()/parent::node()/parent::node()/p:style/a:fontRef/@idx"/>
      <xsl:when test ="a:rPr/a:sym/@typeface and a:rPr/@lang!='en-US'"/>
      <xsl:when test ="a:rPr/a:cs/@typeface and a:rPr/@lang!='en-US'"/>
      <xsl:otherwise>
        <xsl:if test="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr/a:latin/@typeface">
          <xsl:attribute name ="fo:font-family">
            <xsl:variable name ="typeFaceVal" select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr/a:latin/@typeface"/>
            <xsl:for-each select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr/a:latin/@typeface">
                <xsl:choose>
                  <xsl:when test="$typeFaceVal='+mn-lt'">
                    <xsl:choose>
                      <xsl:when test="$DefFontMinor!=''">
                        <xsl:value-of  select ="$DefFontMinor"/>
                      </xsl:when>
                      <xsl:otherwise>
                <xsl:value-of  select ="$DefFont"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="$typeFaceVal='+mj-lt'">
                    <xsl:value-of  select ="$DefFont"/>
                  </xsl:when>
                  <xsl:when test="not($typeFaceVal='+mn-lt' or $typeFaceVal='+mj-lt')">
                <xsl:value-of select ="."/>
                  </xsl:when>
                </xsl:choose>
            </xsl:for-each>
          </xsl:attribute>
        </xsl:if>
      </xsl:otherwise>
    
    </xsl:choose>
    <xsl:if test ="not(a:rPr/a:solidFill/a:srgbClr/@val )
                   and not(a:rPr/a:solidFill/a:schemeClr/@val)
                   and not(parent::node()/parent::node()/parent::node()/p:style/a:fontRef/a:schemeClr/@val)
                   and not(parent::node()/parent::node()/parent::node()/p:style/a:fontRef/a:srgbClr/@val)">
      <xsl:if test="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr/a:solidFill">
        <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr/a:solidFill">
              <xsl:attribute name ="fo:color">
            <xsl:call-template name="tmpSolidColor">
              <xsl:with-param name="SMName" select="$SMName"/>
                </xsl:call-template>
              </xsl:attribute>
            </xsl:for-each>
      </xsl:if>
           </xsl:if>
    <xsl:if test ="not(a:effectLst/a:outerShdw)">
               <xsl:if test="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr/a:effectLst/a:outerShdw">
            <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr">
              <xsl:attribute name ="fo:text-shadow">
                <xsl:value-of select ="'1pt 1pt'"/>
              </xsl:attribute>
            </xsl:for-each>
          </xsl:if>
             
    </xsl:if>
    <xsl:if test="not(a:rPr/@baseline)">
               <xsl:if test="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr/@baseline">
            <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:defRPr">
              <xsl:variable name="baseData">
                <xsl:value-of select="@baseline"/>
              </xsl:variable>
              <xsl:variable name="subSuperScriptValue">
                <xsl:value-of select="number(format-number($baseData div 1000,'#'))"/>
              </xsl:variable>
              <xsl:call-template name="tmpSubSuperScript">
                <xsl:with-param name="baseline" select="$baseData"/>
                <xsl:with-param name="subSuperScriptValue" select="$subSuperScriptValue"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:if>
            </xsl:if>
  </xsl:template>
  <xsl:template name="tmpPresentationDefaultParagraphStyle">
    <xsl:param name="lnSpcReduction"/>
    <xsl:param name="level"/>
    <xsl:param name="SMName"/>
    <xsl:variable name ="nodeName">
      <xsl:value-of select ="concat('a:lvl',$level,'pPr')"/>
    </xsl:variable>

        <xsl:if test ="not(./a:pPr/@algn)">
      <xsl:if test="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/@algn">
        <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]">
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
              <!-- Added by lohith - for fix 1737161-->
              <xsl:when test ="@algn ='just'">
                <xsl:value-of select ="'justify'"/>
              </xsl:when>
            </xsl:choose>
          </xsl:attribute>
        </xsl:for-each>
      </xsl:if>
    </xsl:if>
    <xsl:if test ="not(./a:pPr/@marL)">
      <xsl:if test="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/@marL">
        <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]">
          <xsl:attribute name ="fo:margin-left">
            <xsl:value-of select="concat(format-number( @marL div 360000, '#.##'), 'cm')"/>
          </xsl:attribute>
        </xsl:for-each>
      </xsl:if>
    </xsl:if>
       <xsl:if test ="not(./a:pPr/@indent)">
      <xsl:if test="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[$level][name()=$nodeName]/@indent">
        <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[$level][name()=$nodeName]">
          <xsl:attribute name ="fo:text-indent">
            <xsl:value-of select="concat(format-number(@indent div 360000, '#.##'), 'cm')"/>
          </xsl:attribute>
        </xsl:for-each>
      </xsl:if>
    </xsl:if>
    <xsl:if test ="not(./a:pPr/a:spcAft/a:spcPts/@val) and not(a:pPr/a:spcAft/a:spcPct/@val)">
      <xsl:if test="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:spcAft/a:spcPts">
        <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:spcAft/a:spcPts">
          <xsl:if test ="@val">
            <xsl:attribute name ="fo:margin-bottom">
              <xsl:value-of select="concat(format-number(@val div  2835 ,'#.##'),'cm')"/>
            </xsl:attribute>
          </xsl:if>
        </xsl:for-each>
      </xsl:if>
    </xsl:if>
    <xsl:if test ="not(./a:pPr/a:spcBef/a:spcPts/@val) and not(a:pPr/a:spcBef/a:spcPct/@val)">
      <xsl:if test="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:spcBef/a:spcPts">
        <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:spcBef/a:spcPts">
          <xsl:if test ="@val">
            <xsl:attribute name ="fo:margin-top">
              <xsl:value-of select="concat(format-number(@val div  2835 ,'#.##'),'cm')"/>
            </xsl:attribute>
          </xsl:if>
        </xsl:for-each>
      </xsl:if>
    </xsl:if>
    <xsl:if test ="not(./a:pPr/a:lnSpc/a:spcPct) and not(./a:pPr/a:lnSpc/a:spcPts)">
      <xsl:if test="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:lnSpc/a:spcPct">
        <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:lnSpc/a:spcPct">
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
        </xsl:for-each>
      </xsl:if>
        <xsl:if test="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:lnSpc/a:spcPts">
        <xsl:for-each select="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]/a:lnSpc/a:spcPts">
          <xsl:attribute name="style:line-height-at-least">
            <xsl:value-of select="concat(format-number(@val div 2835, '#.##'), 'cm')"/>
          </xsl:attribute>
        </xsl:for-each>
      </xsl:if>
    </xsl:if>
  </xsl:template>
  <xsl:template name="tmpThemeClr">
    <xsl:param name="ClrMap"/>
    <xsl:for-each select=".">
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
  <xsl:template name="tmpThemeClr_Background">
    <xsl:param name="ClrMap"/>
    <xsl:for-each select="./parent::node()/parent::node()/p:clrMap">
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
  <xsl:template name="tmpGetgroupTransformValues">
    <xsl:variable name="grpX">
      <xsl:value-of select="p:grpSpPr/a:xfrm/a:off/@x"/>
    </xsl:variable>
    <xsl:variable name="grpY">
      <xsl:value-of select="p:grpSpPr/a:xfrm/a:off/@y"/>
    </xsl:variable>
    <xsl:variable name="grpCX">
      <xsl:value-of select="p:grpSpPr/a:xfrm/a:ext/@cx"/>
    </xsl:variable>
    <xsl:variable name="grpCY">
      <xsl:value-of select="p:grpSpPr/a:xfrm/a:ext/@cy"/>
    </xsl:variable>
    <xsl:variable name="grpChX">
      <xsl:value-of select="p:grpSpPr/a:xfrm/a:chOff/@x"/>
    </xsl:variable>
    <xsl:variable name="grpChY">
      <xsl:value-of select="p:grpSpPr/a:xfrm/a:chOff/@y"/>
    </xsl:variable>
    <xsl:variable name="grpChCX">
      <xsl:value-of select="p:grpSpPr/a:xfrm/a:chExt/@cx"/>
    </xsl:variable>
    <xsl:variable name="grpChCY">
      <xsl:value-of select="p:grpSpPr/a:xfrm/a:chExt/@cy"/>
    </xsl:variable>
    <xsl:variable name="grpRot">
      <xsl:choose>
        <xsl:when test="p:grpSpPr/a:xfrm/@rot">
          <xsl:value-of select="p:grpSpPr/a:xfrm/@rot"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'0'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="grpflipH">
      <xsl:choose>
        <xsl:when test="p:grpSpPr/a:xfrm/@flipH">
          <xsl:value-of select="p:grpSpPr/a:xfrm/@flipH"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'0'"/>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:variable>
    <xsl:variable name="grpflipV">
      <xsl:choose>
        <xsl:when test="p:grpSpPr/a:xfrm/@flipV">
          <xsl:value-of select="p:grpSpPr/a:xfrm/@flipV"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'0'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <!--change made by chhavi for odf conformance v1.1-->
      <xsl:when test="$grpRot != 0 ">
        <xsl:value-of select="concat($grpX,':',$grpY,':',$grpCX,':',$grpCY,':',$grpChX,':',$grpChY,':',$grpChCX,':',$grpChCY,':',$grpRot,':',$grpflipH,':',$grpflipV,':','YESROTATION','@')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($grpX,':',$grpY,':',$grpCX,':',$grpCY,':',$grpChX,':',$grpChY,':',$grpChCX,':',$grpChCY,':',$grpRot,':',$grpflipH,':',$grpflipV,':','NOROTATION','@')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="tmpImageCropping">
    <xsl:param name ="slideRel"/>
    <!--Image Cropping-->
    <xsl:variable name ="imageId">
      <xsl:value-of select ="./p:blipFill/a:blip/@r:embed"/>
    </xsl:variable>
    <xsl:variable name ="sourceFile">
      <xsl:for-each select ="key('Part', $slideRel)//node()[@Id = $imageId and @Type='http://schemas.openxmlformats.org/officeDocument/2006/relationships/image']">
        <xsl:value-of select ="@Target"/>
      </xsl:for-each>
    </xsl:variable >
    <xsl:variable name="var_picWidth">
      <xsl:value-of select="concat('ppt',substring-after($sourceFile,'..'))"/>
    </xsl:variable>
    <xsl:if test="string-length(substring-after($sourceFile,'..')) > 0">
    <xsl:if test="./p:blipFill/a:srcRect/@l or ./p:blipFill/a:srcRect/@r or ./p:blipFill/a:srcRect/@t or ./p:blipFill/a:srcRect/@b ">
      <xsl:variable name="left">
        <xsl:if test="p:blipFill/a:srcRect/@l">
          <xsl:value-of select="p:blipFill/a:srcRect/@l"/>
        </xsl:if>
        <xsl:if test="not(p:blipFill/a:srcRect/@l)">
          <xsl:value-of select="0"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="right">
        <xsl:if test="p:blipFill/a:srcRect/@r">
          <xsl:value-of select="p:blipFill/a:srcRect/@r"/>
        </xsl:if>
        <xsl:if test="not(p:blipFill/a:srcRect/@r)">
          <xsl:value-of select="0"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="top">
        <xsl:if test="p:blipFill/a:srcRect/@t">
          <xsl:value-of select="p:blipFill/a:srcRect/@t"/>
        </xsl:if>
        <xsl:if test="not(p:blipFill/a:srcRect/@t)">
          <xsl:value-of select="0"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="bottom">
        <xsl:if test="p:blipFill/a:srcRect/@b">
          <xsl:value-of select="p:blipFill/a:srcRect/@b"/>
        </xsl:if>
        <xsl:if test="not(p:blipFill/a:srcRect/@b)">
          <xsl:value-of select="0"/>
        </xsl:if>
      </xsl:variable>
      <xsl:attribute name ="fo:clip">
        <xsl:variable name="temp">
          <xsl:value-of select="concat('image-props:',$var_picWidth,':',$left,':',$right,':',$top,':',$bottom)"/>
        </xsl:variable>
        <xsl:value-of select="$temp"/>
      </xsl:attribute>
    </xsl:if>
    </xsl:if>
  </xsl:template>
  <xsl:template name="tmpShapeShadow">
    <xsl:choose>
      <xsl:when test="p:spPr/a:effectLst/a:outerShdw ">
        <xsl:for-each select="p:spPr/a:effectLst/a:outerShdw">
          <xsl:call-template name ="ShapesShadow"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="p:style/a:effectRef/@idx &gt;0 ">
        <xsl:variable name="idx" select="p:style/a:effectRef/@idx"/>
        <xsl:for-each select="key('Part', 'ppt/theme/theme1.xml')/a:theme/a:themeElements/a:fmtScheme/a:effectStyleLst/a:effectStyle">
          <xsl:if test="position()=$idx">
            <xsl:for-each select="./a:effectLst/a:outerShdw">
              <xsl:call-template name ="ShapesShadow"/>
            </xsl:for-each>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
 	<!--code changed by yeswanth.s for bug#2019519 , 17 July 2008-->
 <xsl:template name ="insertBulletCharacter">
    <xsl:param name ="character"/>
    <xsl:choose>
      <xsl:when test="$character= ''">
        <xsl:value-of select ="' '"/>
      </xsl:when>
		<xsl:when test="$character= '¨'">
			<xsl:value-of select="''"/>
		</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select ="$character"/>
      </xsl:otherwise>
    </xsl:choose >
  </xsl:template>
  <xsl:template name="tmpTextSpanNode">
    <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
        <xsl:choose >
          <xsl:when test ="a:rPr[@cap!='none']">
            <xsl:choose >
              <xsl:when test =".=''">
                <text:s/>
              </xsl:when>
              <xsl:when test ="not(contains(.,'  '))">
                <xsl:value-of select ="translate(.,$lcletters,$ucletters)"/>
              </xsl:when>
              <xsl:when test =". =' '">
                <text:s/>
              </xsl:when>
              <xsl:otherwise >
                <xsl:call-template name ="InsertWhiteSpaces">
                  <xsl:with-param name ="string" select ="translate(.,$lcletters,$ucletters)"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise >
            <xsl:choose >
              <xsl:when test =".=''">
                <text:s/>
              </xsl:when>
              <xsl:when test ="not(contains(.,'  '))">
                <xsl:value-of select ="."/>
              </xsl:when>
              <xsl:otherwise >
                <xsl:call-template name ="InsertWhiteSpaces">
                  <xsl:with-param name ="string" select ="."/>
                </xsl:call-template>
              </xsl:otherwise >
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
  </xsl:template>
  <xsl:template name="tmpMenifestEntryForOLEobject">
    <xsl:for-each select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:sldIdLst/p:sldId">
      <xsl:variable name ="pageSlide">
        <xsl:value-of select ="concat(concat('ppt/slides/slide',position()),'.xml')"/>
      </xsl:variable>
      <xsl:for-each select ="key('Part', $pageSlide)/p:sld/p:cSld/p:spTree">
        <xsl:for-each select="node()">
          <xsl:if test="name()='p:graphicFrame'">
            <!--<xsl:if test="./a:graphic/a:graphicData/p:oleObj ">-->
			  <!--
			  Defect: 2948303,PPTX:Loss of OLE Object(Office2010)
			  By:Vijayeta
			  Desc: Changed xpath to accomodate other nodes that appear in Office 2010 viz. mc:AlternateContent
			  -->
			  <xsl:if test="./a:graphic/a:graphicData//child::node()[name()='p:oleObj']">
              <manifest:file-entry manifest:media-type="application/vnd.sun.star.oleobject">
                <xsl:attribute name="manifest:full-path">
                  <xsl:value-of select="concat('Oleobject',generate-id())"/>
                </xsl:attribute>
              </manifest:file-entry>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <!--End-->
</xsl:stylesheet>
