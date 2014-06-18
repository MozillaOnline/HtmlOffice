<?xml version="1.0" encoding="UTF-8"?>
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
xmlns:smil="urn:oasis:names:tc:opendocument:xmlns:smil-compatible:1.0" 
xmlns:anim="urn:oasis:names:tc:opendocument:xmlns:animation:1.0"
xmlns:exsl="http://exslt.org/common"
exclude-result-prefixes="p a r xlink rels xmlns">	
	<xsl:template name ="customAnimation">
		<xsl:param name ="slideId"/>
		<xsl:param name ="slideNo"/>
		<xsl:param name="pageid"/>
		<xsl:param name="FolderNameGUID"/>
    <!-- ODF conformance 1.1 Avoid creation of Warning anim:xxx-->
    <xsl:for-each select="key('Part', $slideId)">
    <xsl:if test="p:sld/p:transition | p:sld/p:timing/p:tnLst/p:par/p:cTn/p:childTnLst/p:seq/p:cTn/p:childTnLst/p:par">
		<anim:par smil:dur="indefinite" smil:restart="never" presentation:node-type="timing-root">
        <xsl:if test="p:sld/p:transition">
				<anim:par>
					<xsl:attribute name="smil:begin">
						<xsl:value-of select="concat($pageid,'.begin')"/>
					</xsl:attribute>
					<!--<xsl:copy-of select="key('Part', $slideId)"/>-->
					<!--Code added by yeswanth : To retain sound when only sound is applied in slide transition-->
					<xsl:variable name="varSTSmilType">
						<xsl:call-template name="SmilTypeForOnlySound">
							<xsl:with-param name="slidenum" select="p:sld/p:transition"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:if test="$varSTSmilType != ''">
					<anim:transitionFilter>
						<xsl:variable name="tranSpeed">
							<xsl:choose>
                  <xsl:when test="p:sld/p:transition/@spd='slow'">
									<xsl:value-of select="'3s'"/>
								</xsl:when>
                  <xsl:when test="p:sld/p:transition/@spd='med'">
							<xsl:value-of select="'2s'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'1s'"/>
								</xsl:otherwise>
							</xsl:choose>							
						</xsl:variable>
						<xsl:attribute name="smil:dur">							
							<xsl:value-of select="$tranSpeed"/>
						</xsl:attribute>
						<xsl:call-template name="SlideTransSmilType">
                <xsl:with-param name="slidenum" select="p:sld/p:transition/child::node()"/>
						</xsl:call-template>
					</anim:transitionFilter>
					</xsl:if>
					
            <xsl:if test="p:sld/p:transition/p:sndAc/p:stSnd">
						<anim:audio>
							<!--for xlink:href-->
							<xsl:variable name ="relSlideNumber">
								<xsl:call-template name="retString">
									<xsl:with-param name="string2rev" select="$slideId"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="hyperlinkrid">
                  <xsl:value-of select="p:sld/p:transition/p:sndAc/p:stSnd/p:snd/@r:embed"/>
							</xsl:variable>
							<xsl:variable name="pageRelation">
								<xsl:value-of select="concat('ppt/slides/_rels/',$relSlideNumber,'.rels')"/>
							</xsl:variable>
							<xsl:variable name="soundfilename">
								<xsl:for-each select="key('Part', $pageRelation)/rels:Relationships/rels:Relationship">
									<xsl:if test="$hyperlinkrid=@Id">
										<xsl:call-template name="retString">
											<xsl:with-param name="string2rev" select="./@Target"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:for-each>
							</xsl:variable>
							<!--end-->						
							<xsl:attribute name="xlink:href">
                <xsl:value-of select="'../'"/>
                <xsl:value-of select="concat('ooc-transFileName-oop-',concat($FolderNameGUID,'-'),'-oop-',concat('/',$soundfilename), '-ooe')" />
							</xsl:attribute>
                <xsl:if test="p:sld/p:transition/p:sndAc/p:stSnd/@loop=1">
								<xsl:attribute name="smil:repeatCount">
									<xsl:value-of select="'indefinite'"/>
								</xsl:attribute>
							</xsl:if>
						</anim:audio>
					</xsl:if>
				</anim:par>
			</xsl:if>
        <xsl:if test="p:sld/p:timing/p:tnLst/p:par/p:cTn/p:childTnLst/p:seq/p:cTn/p:childTnLst/p:par">
			<anim:seq presentation:node-type="main-sequence">
            <xsl:for-each select ="p:sld/p:timing/p:tnLst/p:par/p:cTn/p:childTnLst/p:seq/p:cTn/p:childTnLst/p:par">
                                    <xsl:if test="./p:cTn/p:childTnLst/p:par/p:cTn/p:childTnLst/p:par/p:cTn/@presetClass != 'mediacall'">
					<xsl:variable name ="animType">
						<xsl:value-of select ="p:cTn/p:childTnLst/p:par/p:cTn/p:childTnLst/p:par/p:cTn/@presetID"/>
					</xsl:variable>
					<xsl:call-template name ="animProcess">
						<xsl:with-param name ="animType" select ="$animType"/>
						<xsl:with-param name ="slideNo" select ="$slideNo"/>
					</xsl:call-template>					
                                    </xsl:if>
				</xsl:for-each >

			</anim:seq>
        </xsl:if>
		</anim:par>
    </xsl:if>
    </xsl:for-each>
	</xsl:template>
	<xsl:template name ="animProcess">
		<xsl:param name ="animType"/>
		<xsl:param name ="slideNo"/>
			<anim:par >
			<xsl:attribute name="smil:begin">
				<xsl:choose>
					<xsl:when test="./p:cTn/p:stCondLst/p:cond/@delay='0'">
						<xsl:value-of select="'0s'"/>
					</xsl:when>
					<xsl:when test="./p:cTn/p:stCondLst/p:cond/@delay='indefinite'">
						<xsl:value-of select="'next'"/>
					</xsl:when>
					<xsl:when test ="./p:cTn/p:stCondLst/p:cond/@delay!=''">
						<xsl:value-of select ="concat(./p:cTn/p:stCondLst/p:cond/@delay div 1000,'s')"/>
					</xsl:when>
					<xsl:otherwise >
						<xsl:value-of select ="'next'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:for-each select="./p:cTn/p:childTnLst/p:par">
			<anim:par>
				<xsl:attribute name="smil:begin">
					<xsl:choose>
						<xsl:when test="./p:cTn/p:stCondLst/p:cond/@delay='0'">
							<xsl:value-of select="'0s'"/>
						</xsl:when>
						<xsl:when test="./p:cTn/p:stCondLst/p:cond/@delay='indefinite'">
							<xsl:value-of select="'next'"/>
						</xsl:when>
						<xsl:when test ="./p:cTn/p:stCondLst/p:cond/@delay!=''">
							<xsl:value-of select ="concat(./p:cTn/p:stCondLst/p:cond/@delay div 1000,'s')"/>
						</xsl:when>
						<xsl:otherwise >
							<xsl:value-of select ="'next'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				
				<xsl:for-each select ="p:cTn/p:childTnLst/p:par">
					<xsl:variable name="spId">
						<xsl:for-each select="p:cTn/p:childTnLst/child::node()[1]/p:cBhvr/p:tgtEl/p:spTgt">
							<xsl:value-of select="@spid"/>
						</xsl:for-each>
					</xsl:variable>
					<xsl:variable name ="animationId">
						<xsl:choose>
							<xsl:when test ="p:cTn/p:childTnLst/child::node()[1]/p:cBhvr/p:tgtEl/p:spTgt/p:txEl/p:pRg">
							<xsl:value-of select="concat('slText',$slideNo ,'an',p:cTn/p:childTnLst/child::node()[1]/p:cBhvr/p:tgtEl/p:spTgt/@spid ,p:cTn/p:childTnLst/child::node()[1]/p:cBhvr/p:tgtEl/p:spTgt/p:txEl/p:pRg/@st +1 )" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="/.//p:spTree/p:pic/p:nvPicPr/p:cNvPr[@id=$spId]">
										<xsl:value-of select="concat('Picsldraw',$slideNo ,'an',$spId)" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat('sldraw',$slideNo ,'an',$spId)" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>



					</xsl:variable>
         
					     
					<!--anim:iterate-type="by-letter" anim:iterate-interval="0.05s"-->
					<xsl:if test ="./p:cTn/p:iterate">
						<anim:iterate smil:fill="hold" anim:iterate-type="by-letter">
              <!-- code added to get the animation time correctly -->
              <xsl:attribute name ="smil:begin">
                <xsl:choose >
					<xsl:when test ="./p:cTn/p:stCondLst/p:cond/@delay='indefinite'">
						<xsl:value-of select ="'next'"/>
					</xsl:when>
                  <xsl:when test ="./p:cTn/p:stCondLst/p:cond/@delay">
                    <xsl:value-of select ="concat(./p:cTn/p:stCondLst/p:cond/@delay div 1000,'s')"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select ="'0s'"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <!-- end -->
							<xsl:attribute name ="smil:targetElement">
								<xsl:value-of select ="$animationId"/>
							</xsl:attribute>
							<xsl:attribute name ="anim:iterate-interval">								
								<xsl:choose>
								<xsl:when test="$animType = 15 ">
									<xsl:value-of select ="concat(./p:cTn/p:iterate/p:tmAbs/@val div 100000,'s')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select ="concat(./p:cTn/p:iterate/p:tmPct/@val div 100000,'s')"/>
								</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							
							<!-- commented by yeswanth on 2/1/2008 -->
							<!--<xsl:attribute name ="presentation:node-type">
								<xsl:if test ="position()=1">
									<xsl:value-of select ="'on-click'"/>
								</xsl:if>
								<xsl:if test ="position()!=1">
									<xsl:value-of select ="'with-previous'"/>
								</xsl:if>
							</xsl:attribute>-->
							<!-- added by yeswanth to get nodetype correctly on 2/1/2008 -->							
							<xsl:attribute name ="presentation:node-type">
								<xsl:choose>
									<xsl:when test="./p:cTn/@nodeType='afterEffect'">
										<xsl:value-of select="'after-previous'"/>
									</xsl:when>
									<xsl:when test="./p:cTn/@nodeType='withEffect'">
										<xsl:value-of select="'with-previous'"/>
									</xsl:when>
									<xsl:when test="./p:cTn/@nodeType='clickEffect'">
										<xsl:value-of select="'on-click'"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="'on-click'"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:call-template name ="animationType">
								<xsl:with-param name ="animType" select="$animType"/>
							</xsl:call-template >
							<xsl:call-template name ="animBody">
								<xsl:with-param name ="animationId" select ="$animationId"/>
								<xsl:with-param name ="animType">
									<xsl:choose >
										<xsl:when test ="./p:cTn/@presetClass='entr'">
											<xsl:value-of select ="'entrance'"/>
										</xsl:when>
										<xsl:when test ="./p:cTn/@presetClass ='exit'">
											<xsl:value-of select ="'exit'"/>
										</xsl:when>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</anim:iterate>
					</xsl:if>
					<xsl:if test ="not(./p:cTn/p:iterate)">
						<anim:par>
							
              <xsl:attribute name ="smil:begin">
                <xsl:choose >
					<xsl:when test ="./p:cTn/p:stCondLst/p:cond/@delay='indefinite'">
						<xsl:value-of select ="'next'"/>
					</xsl:when>
                  <xsl:when test ="./p:cTn/p:stCondLst/p:cond/@delay">
                    <xsl:value-of select ="concat(./p:cTn/p:stCondLst/p:cond/@delay div 1000,'s')"/>
                    <!--<xsl:value-of select ="concat(./parent::node()/parent::node()/p:stCondLst/p:cond/@delay div 1000,'s')"/>-->
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select ="'0s'"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
							<xsl:if test="./p:cTn/@fill='hold'">
								<!--<xsl:if test="p:cBhvr/p:cTn/@fill='hold'">-->
								<xsl:attribute name ="smil:fill">
									<xsl:value-of select="'hold'"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:attribute name ="presentation:node-type">
								<xsl:if test ="./p:cTn/@nodeType='withEffect'">
									<xsl:value-of select ="'with-previous'"/>
								</xsl:if>
                <xsl:if test ="./p:cTn/@nodeType='clickEffect'">
									<xsl:value-of select ="'on-click'"/>
								</xsl:if>
                <xsl:if test ="./p:cTn/@nodeType='afterEffect'">
                  <xsl:value-of select ="'after-previous'"/>
								</xsl:if>
							</xsl:attribute>
							<xsl:call-template name ="animationType">
								<xsl:with-param name ="animType" select="$animType"/>
							</xsl:call-template >
							<xsl:call-template name ="animBody">
								<xsl:with-param name ="animationId" select ="$animationId"/>
								<xsl:with-param name ="animType">
									<xsl:choose >
										<xsl:when test ="./p:cTn/@presetClass='entr'">
											<xsl:value-of select ="'entrance'"/>
										</xsl:when>
										<xsl:when test ="./p:cTn/@presetClass ='exit'">
											<xsl:value-of select ="'exit'"/>
										</xsl:when>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</anim:par>

					</xsl:if >
					
				</xsl:for-each>
			</anim:par>
			</xsl:for-each>
		</anim:par>
	</xsl:template>
	<xsl:template name ="animBody">
		<xsl:param name ="animationId"/>
		<xsl:param name ="animType"/>
		<xsl:for-each select ="./p:cTn/p:childTnLst">
			<xsl:for-each select ="node()">
				<xsl:choose >
					<xsl:when test ="name()='p:set'">
						<anim:set>
							<xsl:call-template name ="addDuractionNode"/>
							<xsl:attribute name ="smil:targetElement">
								<xsl:value-of select ="$animationId"/>
							</xsl:attribute>
							<xsl:if test ="./p:cBhvr/p:tgtEl/p:spTgt/p:txEl">
								<xsl:attribute name ="anim:sub-item">
									<xsl:value-of select ="'text'"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="p:cBhvr/p:cTn/@fill='hold'">
							    <xsl:attribute name ="smil:fill">
								    <xsl:value-of select="'hold'"/>
							    </xsl:attribute>
						    </xsl:if>
							<xsl:if test="p:cBhvr/p:cTn/@autoRev='1'">
								<xsl:attribute name ="smil:autoReverse">
									<xsl:value-of select="'true'"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="p:cBhvr/p:cTn/@accel">
								<xsl:attribute name ="smil:accelerate">
									<xsl:value-of select ="./p:cBhvr/p:cTn/@accel div 100000"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="p:cBhvr/p:cTn/@decel">
								<xsl:attribute name ="smil:decelerate">
									<xsl:value-of select ="./p:cBhvr/p:cTn/@decel div 100000"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:attribute name ="smil:attributeName">
								<xsl:call-template name ="smilAttributeName"/>
							</xsl:attribute>
							<xsl:attribute name ="smil:to">
								<xsl:call-template name ="smilTo"/>
							</xsl:attribute>
							<xsl:call-template name ="addSmilbeginattr"/>
						</anim:set >
					</xsl:when>
					<xsl:when test ="name()='p:anim'">
						<anim:animate presentation:additive="base">
							<xsl:if test="./@calcmode!=''">
								<xsl:attribute name="smil:calcMode">
									<xsl:value-of select="./@calcmode"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="p:cBhvr/p:cTn/@tmFilter">
								<xsl:attribute name ="smil:keySplines">
									<xsl:value-of select ="p:cBhvr/p:cTn/@tmFilter"/>
								</xsl:attribute>
							</xsl:if>							
							<xsl:if test="p:cBhvr/p:cTn/@autoRev='1'">
								<xsl:attribute name ="smil:autoReverse">
										<xsl:value-of select="'true'"/>
								</xsl:attribute>								
							</xsl:if>
							<xsl:if test ="@from">
								<xsl:attribute name ="smil:from">
									<xsl:call-template name ="mapCoordinates">
										<xsl:with-param name ="strVal"  select ="@from"/>
									</xsl:call-template>
								</xsl:attribute>
								<xsl:attribute name ="smil:to">
									<xsl:call-template name ="mapCoordinates">
										<xsl:with-param name ="strVal"  select ="@to"/>
									</xsl:call-template>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="@by">
								<xsl:attribute name ="smil:by">
									<xsl:call-template name ="mapCoordinates">
										<xsl:with-param name ="strVal">
											<xsl:value-of select ="@by"/>
										</xsl:with-param >
									</xsl:call-template>
								</xsl:attribute>
							</xsl:if >
							<xsl:call-template name ="addSmilbeginattr"/>
							<xsl:call-template name ="addDuractionNode"/>
							<xsl:if test ="./p:cBhvr/p:tgtEl/p:spTgt/p:txEl">
								<xsl:attribute name ="anim:sub-item">
									<xsl:value-of select ="'text'"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:attribute name ="smil:targetElement">
								<xsl:value-of select ="$animationId"/>
							</xsl:attribute>
							<xsl:if test="p:cBhvr/p:cTn/@fill='hold'">
								<xsl:attribute name ="smil:fill">
									<xsl:value-of select="'hold'"/>
								</xsl:attribute>
							</xsl:if>

							<xsl:if test ="p:cBhvr/p:cTn/@accel">
								<xsl:attribute name ="smil:accelerate">
									<xsl:value-of select ="./p:cBhvr/p:cTn/@accel div 100000"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="p:cBhvr/p:cTn/@decel">
								<xsl:attribute name ="smil:decelerate">
									<xsl:value-of select ="./p:cBhvr/p:cTn/@decel div 100000"/>
								</xsl:attribute>
							</xsl:if>
							
							<xsl:attribute name ="smil:attributeName">
								<xsl:call-template name ="smilAttributeName"/>
							</xsl:attribute>
							<xsl:variable name ="smilValues">
								<xsl:call-template name ="concatSmilValues">
									<xsl:with-param name ="animType" select ="$animType"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test ="$smilValues !=''">
								<xsl:attribute name ="smil:values">
									<xsl:value-of select ="$smilValues"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:variable name ="smilKeyTimes">
								<xsl:call-template name ="concatSmilKeys"/>
							</xsl:variable>
							<xsl:if test ="$smilKeyTimes!=''">
								<xsl:attribute name ="smil:keyTimes">
									<xsl:value-of select ="$smilKeyTimes"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test =".//p:tavLst/p:tav/@fmla">
								<xsl:attribute name="anim:formula">
								<xsl:call-template name ="mapCoordinates">
									<xsl:with-param name ="strVal">
										<xsl:value-of select =".//p:tavLst/p:tav/@fmla"/>
									</xsl:with-param>
								</xsl:call-template>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="./p:cBhvr/p:attrNameLst/p:attrName='style.fontSize'">
								<xsl:attribute name ="smil:to">
									<xsl:value-of select ="concat(@to,'pt')"/>
								</xsl:attribute>
							</xsl:if>
						</anim:animate >
					</xsl:when>
					<xsl:when test ="name()='p:animEffect'">
						<anim:transitionFilter >
							<xsl:call-template name ="addDuractionNode"/>
							<xsl:attribute name ="smil:targetElement">
								<xsl:value-of select ="$animationId"/>
							</xsl:attribute>
							<xsl:if test ="./p:cBhvr/p:tgtEl/p:spTgt/p:txEl">
								<xsl:attribute name ="anim:sub-item">
									<xsl:value-of select ="'text'"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="p:cBhvr/p:cTn/@tmFilter">
								<xsl:attribute name ="smil:keySplines">
									<xsl:value-of select ="p:cBhvr/p:cTn/@tmFilter"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="p:cBhvr/p:cTn/@fill='hold'">
								<xsl:attribute name ="smil:fill">
									<xsl:value-of select="'hold'"/>
								</xsl:attribute>
							</xsl:if>

							<xsl:if test="p:cBhvr/p:cTn/@autoRev='1'">
								<xsl:attribute name ="smil:autoReverse">
									<xsl:value-of select="'true'"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="p:cBhvr/p:cTn/@accel">
								<xsl:attribute name ="smil:accelerate">
									<xsl:value-of select ="./p:cBhvr/p:cTn/@accel div 100000"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="p:cBhvr/p:cTn/@decel">
								<xsl:attribute name ="smil:decelerate">
									<xsl:value-of select ="./p:cBhvr/p:cTn/@decel div 100000"/>
								</xsl:attribute>
							</xsl:if>
							
							<xsl:if test ="./@filter">
								<xsl:call-template 	name="smilFilter">
									<xsl:with-param name ="filter"
													select ="./@filter"/>
								</xsl:call-template>
								<xsl:if test ="@transition='out'">
									<xsl:attribute name ="smil:mode">
										<xsl:value-of select="'out'"/>
									</xsl:attribute>
								</xsl:if>
							</xsl:if>
							<xsl:call-template name ="addSmilbeginattr"/>
						</anim:transitionFilter >						
					</xsl:when >
					<xsl:when test ="name()='p:animClr'">
						<anim:animateColor 											   
										   presentation:additive="base"										   
										   anim:color-interpolation-direction="clockwise">
							<xsl:if test ="p:cBhvr/p:cTn/@tmFilter">
								<xsl:attribute name ="smil:keySplines">
									<xsl:value-of select ="p:cBhvr/p:cTn/@tmFilter"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:call-template name ="addSmilbeginattr"/>
							<xsl:call-template name ="addDuractionNode"/>
							<xsl:attribute name ="smil:targetElement">
								<xsl:value-of select ="$animationId"/>
							</xsl:attribute>
							<xsl:if test ="./p:cBhvr/p:tgtEl/p:spTgt/p:txEl">
								<xsl:attribute name ="anim:sub-item">
									<xsl:value-of select ="'text'"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="p:cBhvr/p:cTn/@fill='hold'">
								<xsl:attribute name ="smil:fill">
									<xsl:value-of select="'hold'"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="p:cBhvr/p:cTn/@autoRev='1'">
								<xsl:attribute name ="smil:autoReverse">
									<xsl:value-of select="'true'"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="p:cBhvr/p:cTn/@accel">
								<xsl:attribute name ="smil:accelerate">
									<xsl:value-of select ="./p:cBhvr/p:cTn/@accel div 100000"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="p:cBhvr/p:cTn/@decel">
								<xsl:attribute name ="smil:decelerate">
									<xsl:value-of select ="./p:cBhvr/p:cTn/@decel div 100000"/>
								</xsl:attribute>
							</xsl:if>
							
							<xsl:attribute name ="smil:attributeName">
								<xsl:call-template name ="smilAttributeName"/>
							</xsl:attribute>
							<xsl:variable name ="smiTo">
								<xsl:choose >
									<xsl:when test ="p:to/a:schemeClr/@val">
										<xsl:call-template 	name="getColorCode">
											<xsl:with-param name="color" select="p:to/a:schemeClr/@val"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:when test ="p:to/a:srgbClr/@val">
										<xsl:value-of select ="concat('#',p:to/a:srgbClr/@val)"/>
									</xsl:when>
									<xsl:when test ="a:srgbClr">
										<xsl:value-of select ="concat('#',p:to/a:srgbClr/@val)"/>
									</xsl:when >
									<xsl:when test =".//p:attrNameLst/p:attrName='style.fontSize'">
										<xsl:value-of select ="concat(@to,'pt')"/>
									</xsl:when>									
								</xsl:choose>
							</xsl:variable >
							<xsl:if test ="$smiTo!=''">
								<xsl:attribute name ="smil:to">
									<xsl:value-of select ="$smiTo"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:attribute name ="anim:color-interpolation">
								<xsl:value-of select ="@clrSpc"/>
							</xsl:attribute>
							<xsl:if test ="@clrSpc='hsl'">								
								<xsl:attribute name ="smil:by">
									<xsl:variable name ="varH">
										<xsl:value-of select ="round(p:by/p:hsl/@h div 60000)"/>
									</xsl:variable>
									<xsl:variable name ="varS">
										<xsl:value-of select ="round(p:by/p:hsl/@s div 1000)"/>
									</xsl:variable>
									<xsl:variable name ="varl">
										<xsl:value-of select ="round(p:by/p:hsl/@l div 1000)"/>
									</xsl:variable>
									<xsl:value-of select ="concat('hsl(',$varH,',',$varS,'%,',$varl,'%)')"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="@by" >
								<xsl:attribute name ="smil:by">
									<xsl:call-template name ="mapCoordinates">
										<xsl:with-param name ="strVal" select ="@by"/>
									</xsl:call-template>
								</xsl:attribute>
							</xsl:if>
						</anim:animateColor>
					</xsl:when >
					<xsl:when test ="name()='p:animMotion'">
						<anim:animateMotion									  									   
									   presentation:additive="base">
							<xsl:attribute name ="smil:targetElement">
								<xsl:value-of select ="$animationId"/>
							</xsl:attribute>							
							<xsl:call-template name ="addSmilbeginattr"/>
							<xsl:call-template name ="addDuractionNode"/>
							<xsl:if test ="./p:cBhvr/p:tgtEl/p:spTgt/p:txEl">
								<xsl:attribute name ="anim:sub-item">
									<xsl:value-of select ="'text'"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="p:cBhvr/p:cTn/@fill='hold'">
								<xsl:attribute name ="smil:fill">
									<xsl:value-of select="'hold'"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="p:cBhvr/p:cTn/@autoRev = 1">
								<xsl:attribute name ="smil:autoReverse">
									<xsl:value-of select ="'true'"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="p:cBhvr/p:cTn/@accel">
								<xsl:attribute name ="smil:accelerate">
									<xsl:value-of select ="round(p:cBhvr/p:cTn/@accel div 100000)"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="p:cBhvr/p:cTn/@decel">
								<xsl:attribute name ="smil:decelerate">
									<xsl:value-of select ="round(p:cBhvr/p:cTn/@decel div 100000)"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:attribute name ="svg:path">
								<xsl:value-of select ="@path"/>
							</xsl:attribute>
						</anim:animateMotion>
					</xsl:when>
					<xsl:when test ="name()='p:animScale' or name()='p:animRot' ">
						<anim:animateTransform  presentation:additive="base" >
							<xsl:attribute name ="smil:targetElement">
								<xsl:value-of select ="$animationId"/>
							</xsl:attribute>														
							<xsl:call-template name ="addSmilbeginattr"/>
							<xsl:call-template name ="addDuractionNode"/>
							
							<xsl:if test="p:cBhvr/p:cTn/@fill='hold'">
								<xsl:attribute name ="smil:fill">
									<xsl:value-of select="'hold'"/>
								</xsl:attribute>
							</xsl:if>
							
							<xsl:if test ="p:cBhvr/p:cTn/@accel">
								<xsl:attribute name ="smil:accelerate">
									<xsl:value-of select ="./p:cBhvr/p:cTn/@accel div 100000"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="p:cBhvr/p:cTn/@decel">
								<xsl:attribute name ="smil:decelerate">
									<xsl:value-of select ="./p:cBhvr/p:cTn/@decel div 100000"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="./p:cBhvr/p:tgtEl/p:spTgt/p:txEl">
								<xsl:attribute name ="anim:sub-item">
									<xsl:value-of select ="'text'"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="p:cBhvr/p:cTn/@autoRev='1'">
								<xsl:attribute name ="smil:autoReverse">
									<xsl:value-of select="'true'"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="name()='p:animRot'">
								<xsl:attribute name ="smil:by">
									<xsl:value-of select ="@by div 60000"/>
								</xsl:attribute>	
							</xsl:if>							
							<xsl:attribute name ="svg:type">
								<xsl:choose>
									<xsl:when test ="name()='p:animRot'">
										<xsl:value-of select ="'rotate'"/>
									</xsl:when>
									<xsl:otherwise >
										<xsl:value-of select ="'scale'"/>
									</xsl:otherwise>									
								</xsl:choose>
							</xsl:attribute>
							<xsl:if test ="name()!='p:animRot'">
								<xsl:choose >
									<xsl:when test ="./p:by">
										<xsl:attribute name ="smil:to">
											<xsl:value-of select ="concat(p:by/@x div 100000 ,',', p:by/@y div 100000)"/>
										</xsl:attribute >
									</xsl:when>
									<xsl:when test ="./p:from">
										<xsl:attribute name ="smil:from">
											<xsl:value-of select ="concat(p:from/@x div 100000 ,',', p:from/@y div 100000)"/>
										</xsl:attribute>
										<xsl:if test ="./p:to">
											<xsl:attribute name ="smil:to">
												<xsl:value-of select ="concat(p:to/@x div 100000,',', p:to/@y div 100000)"/>
											</xsl:attribute>
										</xsl:if>
									</xsl:when>									
									<xsl:when test ="not(./p:from) and ./p:to">
										<xsl:if test="./p:to/@x!='' and ./p:to/@y!=''">
											<xsl:attribute name ="smil:to">
												<xsl:value-of select ="concat(p:to/@x div 100000,',', p:to/@y div 100000)"/>
											</xsl:attribute>
										</xsl:if>
									</xsl:when>									
									<xsl:when test ="not(./p:by)">
										<xsl:attribute name ="smil:to">
											<xsl:call-template name ="smilTo"/>
										</xsl:attribute>
									</xsl:when>
								</xsl:choose>
							</xsl:if >
						</anim:animateTransform >
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name ="addSmilbeginattr">
		<xsl:if test ="./p:cBhvr/p:cTn/p:stCondLst/p:cond/@delay">
			<xsl:attribute name ="smil:begin">
				<xsl:choose>
					<xsl:when test ="./p:cBhvr/p:cTn/p:stCondLst/p:cond/@delay='0' or ./p:cBhvr/p:cTn/p:stCondLst/p:cond/@delay='1'">
						<xsl:value-of select ="'0s'"/>
					</xsl:when>
					<xsl:when test ="not(./p:cBhvr/p:cTn/p:stCondLst/p:cond/@delay)">
						<xsl:value-of select ="'0s'"/>
					</xsl:when>
					<xsl:otherwise >
						<xsl:value-of select ="concat(./p:cBhvr/p:cTn/p:stCondLst/p:cond/@delay div 1000,'s')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name ="addDuractionNode">
		<xsl:attribute name ="smil:dur">
			<xsl:variable name ="smilDur">
				<xsl:choose >
					<xsl:when test ="p:cBhvr/p:cTn/@dur &gt; 0">
            <xsl:value-of select ="concat(p:cBhvr/p:cTn/@dur div 1000,'s')"/>
            <!-- (round(p:cBhvr/p:cTn/@dur div 1000),'s')-->
					</xsl:when>
					<xsl:when test ="p:cBhvr/p:cTn/@dur ='indefinite'">
						<xsl:value-of select ="'indefinite'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select ="'0s'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test ="contains($smilDur,'NaN')">
				<xsl:value-of select ="'0s'"/>
			</xsl:if>
			<xsl:if test ="not(contains($smilDur,'NaN'))">
				<xsl:value-of select ="$smilDur"/>
			</xsl:if >
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template name ="concatSmilKeys">
		<xsl:variable name ="varTemp">
			<xsl:for-each select =".//p:tavLst/p:tav"	>
				<xsl:if test ="@tm='0'">
					<xsl:value-of select ="@tm"/>
				</xsl:if>
				<xsl:if test ="not(@tm='0')">
					<xsl:value-of select ="concat(';',@tm div 100000)"/>
				</xsl:if >
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:value-of select ="$varTemp"/>
	</xsl:template>
	<xsl:template name ="concatSmilValues">
		<xsl:param name ="animType" />			
		<xsl:variable name ="varTemp">
			<xsl:for-each select =".//p:tavLst/p:tav">
				<xsl:variable name ="varColon">
					<xsl:if test ="position()=1">
						<xsl:value-of select ="''"/>
					</xsl:if>
					<xsl:if test ="position()!=1">
						<xsl:value-of select ="';'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name ="newValue">
					<xsl:choose>
						<xsl:when test="./parent::node()/parent::node()/@valueType='clr'">
							<xsl:choose>
								<xsl:when test="p:val/p:clrVal/a:schemeClr/@val">
									<xsl:call-template 	name="getColorCode">
										<xsl:with-param name="color" select="p:val/p:clrVal/a:schemeClr/@val"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="p:val/p:clrVal/a:srgbClr/@val">
									<!--<xsl:call-template 	name="getColorCode">
										<xsl:with-param name="color" select="p:val/p:clrVal/a:srgbClr/@val"/>
									</xsl:call-template>-->
									<xsl:value-of select="concat('#',p:val/p:clrVal/a:srgbClr/@val)"/>
								</xsl:when>
								<xsl:when test="p:val/p:strVal/@val">
									<xsl:call-template name="decimal2Hex">
										<xsl:with-param name ="strVal">
											<xsl:if test="p:val/p:strVal/@val">
												<xsl:value-of select ="p:val/p:strVal/@val"/>
											</xsl:if>
											<xsl:if test="not(p:val/p:strVal/@val)">
												<xsl:value-of select ="'rgb(00,00,00)'"/>
											</xsl:if>
										</xsl:with-param >
									</xsl:call-template>
								</xsl:when>
							</xsl:choose>							
						</xsl:when>
						<xsl:otherwise>
					<xsl:call-template name ="mapCoordinates">
						<xsl:with-param name ="strVal">
							<xsl:if test="p:val/p:strVal/@val">
								<xsl:value-of select ="p:val/p:strVal/@val"/>
							</xsl:if>
							<xsl:if test="p:val/p:fltVal/@val">
								<xsl:value-of select ="p:val/p:fltVal/@val"/>
							</xsl:if>
						</xsl:with-param >
					</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>

				</xsl:variable>
				<xsl:value-of select ="concat($varColon,$newValue)"/>				
			</xsl:for-each>
		</xsl:variable >
		<xsl:value-of select ="$varTemp"/>			
	</xsl:template>	
	<xsl:template name="stringReplace">
		<xsl:param name="text"/>
		<xsl:param name="replace"/>
		<xsl:param name="with"/>
		<xsl:choose>
			<xsl:when test="contains($text,$replace)">
				<xsl:value-of select="substring-before($text,$replace)"/>
				<xsl:value-of select="$with"/>
				<xsl:call-template name="stringReplace">
					<xsl:with-param name="text"	select="substring-after($text,$replace)"/>
					<xsl:with-param name="replace" select="$replace"/>
					<xsl:with-param name="with" select="$with"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name ="smilAttributeName">
		<xsl:choose>			
			
			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='style.visibility'">
				<xsl:value-of select ="'visibility'"/>
			</xsl:when>
			<!-- style.fontFamily-->
			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='style.fontFamily'">
				<xsl:value-of select ="'font-family'"/>				
			</xsl:when>
			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='fill.on'">
				<xsl:value-of select ="'font-family'"/>
			</xsl:when>
			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='fill.type'">
				<xsl:value-of select ="'fill'"/>
			</xsl:when>
			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='fillcolor'">
				<xsl:value-of select ="'fill-color'"/>
			</xsl:when>
			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='ppt_h'">
				<xsl:value-of select ="'height'"/>
			</xsl:when>
			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='ppt_w'">
				<xsl:value-of select ="'width'"/>
			</xsl:when>
			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='ppt_x'">
				<xsl:value-of select ="'x'"/>
			</xsl:when>
			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='ppt_y'">
				<xsl:value-of select ="'y'"/>
			</xsl:when>
			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='r'">
				<xsl:value-of select ="'rotate'"/>
			</xsl:when>
			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='fill.on'">
				<xsl:value-of select ="'font-family'"/>
			</xsl:when>
			
			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='xshear'">
				<xsl:value-of select ="'skewX'"/>
			</xsl:when>
			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='stroke.color'">
				<xsl:value-of select ="'stroke-color'"/>
			</xsl:when>

			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='style.color'">
				<xsl:value-of select ="'color'"/>
			</xsl:when>
			
			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='style.fontFamily'">
				<xsl:value-of select ="'font-family'"/>
			</xsl:when>

			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='style.fontSize'">
				<xsl:value-of select ="'font-size'"/>
			</xsl:when>
			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='style.fontStyle'">
				<xsl:value-of select ="'font-style'"/>
			</xsl:when>

			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='style.fontWeight'">
				<xsl:value-of select ="'font-weight'"/>
			</xsl:when>
			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='style.opacity'">
				<xsl:value-of select ="'opacity'"/>
			</xsl:when>
			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='style.rotation'">
				<xsl:value-of select ="'rotate'"/>
			</xsl:when>
			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='style.textDecorationUnderline'">
				<xsl:value-of select ="'text-underline'"/>
			</xsl:when>
			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='style.visibility'">
				<xsl:value-of select ="'font-family'"/>
			</xsl:when>
			<xsl:when test ="./p:cBhvr/p:attrNameLst/p:attrName='xshear'">
				<xsl:value-of select ="'skewX'"/>
			</xsl:when>
			
		</xsl:choose> 
	</xsl:template>
	<xsl:template name ="smilTo">
		<xsl:choose>
			<xsl:when test ="p:to/p:strVal/@val='hidden'">
				<xsl:value-of select ="'hidden'"/>
			</xsl:when>
			<xsl:when test ="p:to/p:strVal/@val='visible'">
				<xsl:value-of select ="'visible'"/>
			</xsl:when>
			<xsl:when test ="p:to/p:strVal/@val ='false'">
				<xsl:value-of select ="'none'"/>
			</xsl:when>
			<xsl:when test ="p:to/p:strVal/@val = 0">
				<xsl:value-of select ="'none'"/>
			</xsl:when>		
			<xsl:when test ="p:to/p:strVal/@val ='true'">
				<xsl:value-of select ="'solid'"/>
			</xsl:when>
			<xsl:when test ="p:to/p:strVal/@val = 1">
				<xsl:value-of select ="'solid'"/>
			</xsl:when>
			<xsl:when test ="p:to/p:clrVal">
				<xsl:choose >
					<xsl:when test ="p:to/p:clrVal/a:schemeClr/@val">
						<xsl:call-template 	name="getColorCode">
							<xsl:with-param name="color" select="p:to/p:clrVal/a:schemeClr/@val"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test ="p:to/p:clrVal/a:srgbClr/@val">
						<xsl:value-of select ="concat('#',p:to/p:clrVal/a:srgbClr/@val)"/>
					</xsl:when>
					<xsl:when test ="a:srgbClr">
						<xsl:value-of select ="concat('#',p:to/p:clrVal/a:srgbClr/@val)"/>
					</xsl:when >
				</xsl:choose>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:call-template name ="mapCoordinates">
					<xsl:with-param name ="strVal" select ="p:to/p:strVal/@val"/>
				</xsl:call-template>				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name ="mapCoordinates">
		<xsl:param name ="strVal"/>
		
		<xsl:variable name ="strVal1">
			<xsl:call-template name ="stringReplace">
				<xsl:with-param name ="text" select ="$strVal"/>
				<xsl:with-param name ="replace" select ="'#'" />
				<xsl:with-param name ="with" select ="''"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name ="strValppt_x">
			<xsl:call-template name ="stringReplace">
				<xsl:with-param name ="text" select ="$strVal1"/>
				<xsl:with-param name ="replace" select ="'ppt_x'" />
				<xsl:with-param name ="with" select ="'x'"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name ="strValppt_y">
			<xsl:call-template name ="stringReplace">
				<xsl:with-param name ="text" select ="$strValppt_x"/>
				<xsl:with-param name ="replace" select ="'ppt_y'" />
				<xsl:with-param name ="with" select ="'y'"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name ="strValppt_h">
			<xsl:call-template name ="stringReplace">
				<xsl:with-param name ="text" select ="$strValppt_y"/>
				<xsl:with-param name ="replace" select ="'ppt_h'" />
				<xsl:with-param name ="with" select ="'height'"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name ="strValppt_w">
			<xsl:call-template name ="stringReplace">
				<xsl:with-param name ="text" select ="$strValppt_h"/>
				<xsl:with-param name ="replace" select ="'ppt_w'" />
				<xsl:with-param name ="with" select ="'width'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select ="$strValppt_w"/>
	</xsl:template>
	<!--RefNo-1-->
	<xsl:template name ="smilFilter">
		<xsl:param name ="filter"/>
		<xsl:choose >
			<xsl:when test ="@filter='blinds(horizontal)'" >				
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'blindsWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'horizontal'"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test ="@filter='strips(downLeft)'">
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'waterfallWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'horizontalRight'"/>
				</xsl:attribute>
			</xsl:when>
      
      <xsl:when test ="@filter='dissolve'" >
        <xsl:attribute name ="smil:type">
          <xsl:value-of select ="'dissolve'"/>
        </xsl:attribute>        
      </xsl:when>
      
      
			<xsl:when test ="@filter='blinds(vertical)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'blindsWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'vertical'"/>
				</xsl:attribute>
			</xsl:when>
			
			<xsl:when test ="@filter='barn(inHorizontal)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'barnDoorWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'horizontal'"/>
				</xsl:attribute>
				<xsl:attribute name="smil:direction">
					<xsl:value-of select ="'reverse'"/>
				</xsl:attribute>
			</xsl:when>
			
			<xsl:when test ="@filter='box(in)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'irisWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'rectangle'"/>
				</xsl:attribute>
				<xsl:attribute name="smil:direction">
					<xsl:value-of select ="'reverse'"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test ="@filter='box(out)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'irisWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'rectangle'"/>
				</xsl:attribute>				
			</xsl:when>
			
			<xsl:when test ="@filter='checkerboard(across)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'checkerBoardWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'across'"/>
				</xsl:attribute>				
			</xsl:when>
			<xsl:when test ="@filter='checkerboard(down)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'checkerBoardWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'down'"/>
				</xsl:attribute>
			</xsl:when>
			
			<xsl:when test ="@filter='circle(in)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'ellipseWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'horizontal'"/>
				</xsl:attribute>
				<xsl:attribute name="smil:direction">
					<xsl:value-of select ="'reverse'"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test ="@filter='circle(out)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'ellipseWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'horizontal'"/>
				</xsl:attribute>
			</xsl:when>
			
			<xsl:when test ="@filter='diamond(in)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'irisWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'diamond'"/>
				</xsl:attribute>
				<xsl:attribute name="smil:direction">
					<xsl:value-of select ="'reverse'"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test ="@filter='diamond(out)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'irisWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'diamond'"/>
				</xsl:attribute>
			</xsl:when>

			<xsl:when test ="@filter='slide(fromBottom)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'slideWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'fromBottom'"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test ="@filter='slide(fromLeft)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'slideWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'fromLeft'"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test ="@filter='slide(fromRight)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'slideWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'fromRight'"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test ="@filter='slide(fromTop)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'slideWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'fromTop'"/>
				</xsl:attribute>
			</xsl:when>

			<xsl:when test ="@filter='plus(in)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'fourBoxWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'cornersIn'"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test ="@filter='plus(out)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'fourBoxWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'cornersIn'"/>
				</xsl:attribute>
				<xsl:attribute name="smil:direction">
					<xsl:value-of select ="'reverse'"/>
				</xsl:attribute>
			</xsl:when>

			<xsl:when test ="@filter='randombar(horizontal)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'randomBarWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'horizontal'"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test ="@filter='randombar(vertical)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'randomBarWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'vertical'"/>
				</xsl:attribute>
			</xsl:when>
			
			<xsl:when test ="@filter='wedge'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'fanWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'centerTop'"/>
				</xsl:attribute>
			</xsl:when>

			<xsl:when test ="@filter='wheel(1)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'pinWheelWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'oneBlade'"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test ="@filter='wheel(2)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'pinWheelWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'twoBladeVertical'"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test ="@filter='wheel(3)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'pinWheelWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'threeBlade'"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test ="@filter='wheel(4)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'pinWheelWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'fourBlade'"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test ="@filter='wheel(8)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'pinWheelWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'eightBlade'"/>
				</xsl:attribute>
			</xsl:when>

			<xsl:when test ="@filter='wipe(down)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'barWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'topToBottom'"/>
				</xsl:attribute>
				<xsl:attribute name="smil:direction">
					<xsl:value-of select ="'reverse'"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test ="@filter='wipe(left)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'barWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'leftToRight'"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test ="@filter='wipe(right)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'barWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'leftToRight'"/>
				</xsl:attribute>
				<xsl:attribute name="smil:direction">
					<xsl:value-of select ="'reverse'"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test ="@filter='wipe(up)'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'barWipe'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'topToBottom'"/>
				</xsl:attribute>
			</xsl:when>

			<xsl:when test ="@filter='fade'" >
				<xsl:attribute name ="smil:type">
					<xsl:value-of select ="'fade'"/>
				</xsl:attribute>
				<xsl:attribute name ="smil:subtype">
					<xsl:value-of select ="'crossfade'"/>
				</xsl:attribute>
			</xsl:when>
			
      
		</xsl:choose>
		
	</xsl:template>
	<xsl:template name ="animationType">
		<xsl:param name ="animType" />
		<xsl:attribute name ="presentation:preset-class">
			<xsl:choose >
				<xsl:when test ="./p:cTn/@presetClass='entr'">
					<xsl:value-of select ="'entrance'"/>
				</xsl:when>
				<xsl:when test ="./p:cTn/@presetClass ='exit'">
					<xsl:value-of select ="'exit'"/>
				</xsl:when>
				<xsl:when test ="./p:cTn/@presetClass ='emph'">
					<xsl:value-of select ="'emphasis'"/>
				</xsl:when>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name ="presentation:preset-id">
			<xsl:choose>
				<xsl:when test ="./p:cTn/@presetClass='entr'">
					<xsl:choose>
						<xsl:when test ="$animType =1 ">
							<xsl:value-of select ="'ooo-entrance-appear'"/>
						</xsl:when>
						<xsl:when test ="$animType =2">
							<xsl:value-of select ="'ooo-entrance-fly-in'"/>
						</xsl:when>
						<xsl:when test ="$animType =4 ">
							<xsl:value-of select ="'ooo-entrance-box'"/>
						</xsl:when>
						<xsl:when test ="$animType =3 ">
							<xsl:value-of select ="'ooo-entrance-venetian-blinds'"/>
						</xsl:when>
						<xsl:when test ="$animType =5 ">
							<xsl:value-of select ="'ooo-entrance-checkerboard'"/>
						</xsl:when>
						<xsl:when test ="$animType =6 ">
							<xsl:value-of select ="'ooo-entrance-circle'"/>
						</xsl:when>
						<xsl:when test ="$animType =7 ">
							<xsl:value-of select ="'ooo-entrance-fly-in-slow'"/>
						</xsl:when>
						<xsl:when test ="$animType =8 ">
							<xsl:value-of select ="'ooo-entrance-diamond'"/>
						</xsl:when>
						<xsl:when test ="$animType =9">
							<xsl:value-of select ="'ooo-entrance-dissolve-in'"/>
						</xsl:when>
						<xsl:when test ="$animType =10 ">
							<xsl:value-of select ="'ooo-entrance-fade-in'"/>
						</xsl:when>
						<xsl:when test ="$animType =11 ">
							<xsl:value-of select ="'ooo-entrance-flash-once'"/>
						</xsl:when>
						<xsl:when test ="$animType =12 ">
							<xsl:value-of select ="'ooo-entrance-peek-in'"/>
						</xsl:when>
						<xsl:when test ="$animType =13 ">
							<xsl:value-of select ="'ooo-entrance-plus'"/>
						</xsl:when>
						<xsl:when test ="$animType =14 ">
							<xsl:value-of select ="'ooo-entrance-random-bars'"/>
						</xsl:when>
						<xsl:when test ="$animType =15 ">
							<xsl:value-of select ="'ooo-entrance-spiral-in'"/>
						</xsl:when>
						<xsl:when test ="$animType =16">
							<xsl:value-of select ="'ooo-entrance-split'"/>
						</xsl:when>
						<xsl:when test ="$animType =17 ">
							<xsl:value-of select ="'ooo-entrance-stretchy'"/>
						</xsl:when>
						<xsl:when test ="$animType =18 ">
							<xsl:value-of select ="'ooo-entrance-diagonal-squares'"/>
						</xsl:when>
						<xsl:when test ="$animType =19 ">
							<xsl:value-of select ="'ooo-entrance-swivel'"/>
						</xsl:when>
						<xsl:when test ="$animType =20 ">
							<xsl:value-of select ="'ooo-entrance-wedge'"/>
						</xsl:when>
						<xsl:when test ="$animType =21 ">
							<xsl:value-of select ="'ooo-entrance-wheel'"/>
						</xsl:when>
						<xsl:when test ="$animType =22 ">
							<xsl:value-of select ="'ooo-entrance-wipe'"/>
						</xsl:when>
						<xsl:when test ="$animType =23 ">
							<xsl:value-of select ="'ooo-entrance-zoom'"/>
						</xsl:when>
						<xsl:when test ="$animType =24">
							<xsl:value-of select ="'ooo-entrance-random'"/>
						</xsl:when>
						<xsl:when test ="$animType =25 ">
							<xsl:value-of select ="'ooo-entrance-boomerang'"/>
						</xsl:when>
						<xsl:when test ="$animType =26 ">
							<xsl:value-of select ="'ooo-entrance-bounce'"/>
						</xsl:when>
						<xsl:when test ="$animType =27 ">
							<xsl:value-of select ="'ooo-entrance-colored-lettering'"/>
						</xsl:when>
						<xsl:when test ="$animType =28 ">
							<xsl:value-of select ="'ooo-entrance-movie-credits'"/>
						</xsl:when>
						<xsl:when test ="$animType =29 ">
							<xsl:value-of select ="'ooo-entrance-ease-in'"/>
						</xsl:when>
						<xsl:when test ="$animType =30 ">
							<xsl:value-of select ="'ooo-entrance-float'"/>
						</xsl:when>
						<xsl:when test ="$animType =31 ">
							<xsl:value-of select ="'ooo-entrance-turn-and-grow'"/>
						</xsl:when>
						<xsl:when test ="$animType =34 ">
							<xsl:value-of select ="'ooo-entrance-breaks'"/>
						</xsl:when>
						<xsl:when test ="$animType =35 ">
							<xsl:value-of select ="'ooo-entrance-pinwheel'"/>
						</xsl:when>
						<xsl:when test ="$animType =37 ">
							<xsl:value-of select ="'ooo-entrance-rise-up'"/>
						</xsl:when>
						<xsl:when test ="$animType =38 ">
							<xsl:value-of select ="'ooo-entrance-falling-in'"/>
						</xsl:when>
						<xsl:when test ="$animType =39 ">
							<xsl:value-of select ="'ooo-entrance-thread'"/>
						</xsl:when>
						<xsl:when test ="$animType =40 ">
							<xsl:value-of select ="'ooo-entrance-unfold'"/>
						</xsl:when>
						<xsl:when test ="$animType =41 ">
							<xsl:value-of select ="'ooo-entrance-whip'"/>
						</xsl:when>
						<xsl:when test ="$animType =42 ">
							<xsl:value-of select ="'ooo-entrance-ascend'"/>
						</xsl:when>
						<xsl:when test ="$animType =43 ">
							<xsl:value-of select ="'ooo-entrance-center-revolve'"/>
						</xsl:when>
						<xsl:when test ="$animType =45 ">
							<xsl:value-of select ="'ooo-entrance-fade-in-and-swivel'"/>
						</xsl:when>
						<xsl:when test ="$animType =47 ">
							<xsl:value-of select ="'ooo-entrance-descend'"/>
						</xsl:when>
						<xsl:when test ="$animType =48 ">
							<xsl:value-of select ="'ooo-entrance-sling'"/>
						</xsl:when>
						<xsl:when test ="$animType =49 ">
							<xsl:value-of select ="'ooo-entrance-spin-in'"/>
						</xsl:when>
						<xsl:when test ="$animType =50 ">
							<xsl:value-of select ="'ooo-entrance-compress'"/>
						</xsl:when>
						<xsl:when test ="$animType =51 ">
							<xsl:value-of select ="'ooo-entrance-magnify'"/>
						</xsl:when>
						<xsl:when test ="$animType =52 ">
							<xsl:value-of select ="'ooo-entrance-curve-up'"/>
						</xsl:when>
						<xsl:when test ="$animType =53 ">
							<xsl:value-of select ="'ooo-entrance-fade-in-and-zoom'"/>
						</xsl:when>
						<xsl:when test ="$animType =54 ">
							<xsl:value-of select ="'ooo-entrance-glide'"/>
						</xsl:when>
						<xsl:when test ="$animType =55 ">
							<xsl:value-of select ="'ooo-entrance-expand'"/>
						</xsl:when>
						<xsl:when test ="$animType =56 ">
							<xsl:value-of select ="'ooo-entrance-flip'"/>
						</xsl:when>
						<xsl:when test ="$animType =58 ">
							<xsl:value-of select ="'ooo-entrance-fold'"/>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:when test ="./p:cTn/@presetClass ='exit'">
					<xsl:choose>
						<xsl:when test ="$animType =1 ">
							<xsl:value-of select ="'ooo-exit-disappear'"/>
						</xsl:when>
						<xsl:when test ="$animType =2 ">
							<xsl:value-of select ="'ooo-exit-fly-out'"/>
						</xsl:when>
						<xsl:when test ="$animType =3 ">
							<xsl:value-of select ="'ooo-exit-venetian-blinds'"/>
						</xsl:when>
						<xsl:when test ="$animType =4  ">
							<xsl:value-of select ="'ooo-exit-box'"/>
						</xsl:when>
						<xsl:when test ="$animType =5 ">
							<xsl:value-of select ="'ooo-exit-checkerboard'"/>
						</xsl:when>
						<xsl:when test ="$animType =6 ">
							<xsl:value-of select ="'ooo-exit-circle'"/>
						</xsl:when>
						<xsl:when test ="$animType =7 ">
							<xsl:value-of select ="'ooo-exit-crawl-out'"/>
						</xsl:when>
						<xsl:when test ="$animType =8 ">
							<xsl:value-of select ="'ooo-exit-diamond'"/>
						</xsl:when>
						<xsl:when test ="$animType =9 ">
							<xsl:value-of select ="'ooo-exit-dissolve'"/>
						</xsl:when>
						<xsl:when test ="$animType =10 ">
							<xsl:value-of select ="'ooo-exit-fade-out'"/>
						</xsl:when>
						<xsl:when test ="$animType =11 ">
							<xsl:value-of select ="'ooo-exit-flash-once'"/>
						</xsl:when>
						<xsl:when test ="$animType =12 ">
							<xsl:value-of select ="'ooo-exit-peek-out'"/>
						</xsl:when>
						<xsl:when test ="$animType =13 ">
							<xsl:value-of select ="'ooo-exit-plus'"/>
						</xsl:when>
						<xsl:when test ="$animType =14 ">
							<xsl:value-of select ="'ooo-exit-random-bars'"/>
						</xsl:when>
						<xsl:when test ="$animType =15 ">
							<xsl:value-of select ="'ooo-exit-spiral-out'"/>
						</xsl:when>
						<xsl:when test ="$animType =16 ">
							<xsl:value-of select ="'ooo-exit-split'"/>
						</xsl:when>
						<xsl:when test ="$animType =17 ">
							<xsl:value-of select ="'ooo-exit-collapse'"/>
						</xsl:when>
						<xsl:when test ="$animType =18 ">
							<xsl:value-of select ="'ooo-exit-diagonal-squares'"/>
						</xsl:when>
						<xsl:when test ="$animType =19 ">
							<xsl:value-of select ="'ooo-exit-swivel'"/>
						</xsl:when>
						<xsl:when test ="$animType =20 ">
							<xsl:value-of select ="'ooo-exit-wedge'"/>
						</xsl:when>
						<xsl:when test ="$animType =21 ">
							<xsl:value-of select ="'ooo-exit-wheel'"/>
						</xsl:when>
						<xsl:when test ="$animType =22 ">
							<xsl:value-of select ="'ooo-exit-wipe'"/>
						</xsl:when>
						<xsl:when test ="$animType =23 ">
							<xsl:value-of select ="'ooo-exit-zoom'"/>
						</xsl:when>
						<xsl:when test ="$animType =24 ">
							<xsl:value-of select ="'ooo-exit-random'"/>
						</xsl:when>
						<xsl:when test ="$animType =25 ">
							<xsl:value-of select ="'ooo-exit-boomerang'"/>
						</xsl:when>
						<xsl:when test ="$animType =26 ">
							<xsl:value-of select ="'ooo-exit-bounce'"/>
						</xsl:when>
						<xsl:when test ="$animType =27 ">
							<xsl:value-of select ="'ooo-exit-colored-lettering'"/>
						</xsl:when>
						<xsl:when test ="$animType =28 ">
							<xsl:value-of select ="'ooo-exit-movie-credits'"/>
						</xsl:when>
						<xsl:when test ="$animType =29 ">
							<xsl:value-of select ="'ooo-exit-ease-out'"/>
						</xsl:when>
						<xsl:when test ="$animType =30 ">
							<xsl:value-of select ="'ooo-exit-float'"/>
						</xsl:when>
						<xsl:when test ="$animType =31 ">
							<xsl:value-of select ="'ooo-exit-turn-and-grow'"/>
						</xsl:when>
						<xsl:when test ="$animType =34 ">
							<xsl:value-of select ="'ooo-exit-breaks'"/>
						</xsl:when>
						<xsl:when test ="$animType =35 ">
							<xsl:value-of select ="'ooo-exit-pinwheel'"/>
						</xsl:when>
						<xsl:when test ="$animType =37 ">
							<xsl:value-of select ="'ooo-exit-sink-down'"/>
						</xsl:when>
						<xsl:when test ="$animType =38 ">
							<xsl:value-of select ="'ooo-exit-swish'"/>
						</xsl:when>
						<xsl:when test ="$animType =39 ">
							<xsl:value-of select ="'ooo-exit-thread'"/>
						</xsl:when>
						<xsl:when test ="$animType =40 ">
							<xsl:value-of select ="'ooo-exit-unfold'"/>
						</xsl:when>
						<xsl:when test ="$animType =41 ">
							<xsl:value-of select ="'ooo-exit-whip'"/>
						</xsl:when>
						<xsl:when test ="$animType =42 ">
							<xsl:value-of select ="'ooo-exit-descend'"/>
						</xsl:when>
						<xsl:when test ="$animType =43 ">
							<xsl:value-of select ="'ooo-exit-center-revolve'"/>
						</xsl:when>
						<xsl:when test ="$animType =45 ">
							<xsl:value-of select ="'ooo-exit-fade-out-and-swivel'"/>
						</xsl:when>
						<xsl:when test ="$animType =47 ">
							<xsl:value-of select ="'ooo-exit-ascend'"/>
						</xsl:when>
						<xsl:when test ="$animType =48 ">
							<xsl:value-of select ="'ooo-exit-sling'"/>
						</xsl:when>
						<xsl:when test ="$animType =49 ">
							<xsl:value-of select ="'ooo-exit-spin-out'"/>
						</xsl:when>
						<xsl:when test ="$animType =50 ">
							<xsl:value-of select ="'ooo-exit-stretchy'"/>
						</xsl:when>
						<xsl:when test ="$animType =51 ">
							<xsl:value-of select ="'ooo-exit-magnify'"/>
						</xsl:when>
						<xsl:when test ="$animType =52 ">
							<xsl:value-of select ="'ooo-exit-curve-down'"/>
						</xsl:when>
						<xsl:when test ="$animType =53 ">
							<xsl:value-of select ="'ooo-exit-fade-out-and-zoom'"/>
						</xsl:when>
						<xsl:when test ="$animType =54 ">
							<xsl:value-of select ="'ooo-exit-glide'"/>
						</xsl:when>
						<xsl:when test ="$animType =55 ">
							<xsl:value-of select ="'ooo-exit-contract'"/>
						</xsl:when>
						<xsl:when test ="$animType =56 ">
							<xsl:value-of select ="'ooo-exit-flip'"/>
						</xsl:when>
						<xsl:when test ="$animType =58 ">
							<xsl:value-of select ="'ooo-exit-fold'"/>
						</xsl:when>
					</xsl:choose>
				</xsl:when >
				<xsl:when test ="./p:cTn/@presetClass ='emph'">
					<xsl:choose >
            <xsl:when test ="$animType =1  ">
              <xsl:value-of select ="'ooo-emphasis-fill-color'"/>
            </xsl:when>
						<xsl:when test ="$animType =2  ">
							<xsl:value-of select ="'ooo-emphasis-font'"/>
						</xsl:when>
						<xsl:when test ="$animType =3  ">
							<xsl:value-of select ="'ooo-emphasis-font-color'"/>
						</xsl:when>
						<xsl:when test ="$animType =4  ">
							<xsl:value-of select ="'ooo-emphasis-font-size'"/>
						</xsl:when>
						<xsl:when test ="$animType =5 ">
							<xsl:value-of select ="'ooo-emphasis-font-style'"/>
						</xsl:when>
						<xsl:when test ="$animType =6 ">
							<xsl:value-of select ="'ooo-emphasis-grow-and-shrink'"/>
						</xsl:when>
            <xsl:when test ="$animType =7 ">
              <xsl:value-of select ="'ooo-emphasis-line-color'"/>
            </xsl:when>
						<xsl:when test ="$animType =8  ">
							<xsl:value-of select ="'ooo-emphasis-spin'"/>
						</xsl:when>
						<xsl:when test ="$animType =9  ">
							<xsl:value-of select ="'ooo-emphasis-transparency'"/>
						</xsl:when>
						<xsl:when test ="$animType =10  ">
							<xsl:value-of select ="'ooo-emphasis-bold-flash'"/>
						</xsl:when>
						<xsl:when test ="$animType =14  ">
							<xsl:value-of select ="'ooo-emphasis-blast'"/>
						</xsl:when>
						<xsl:when test ="$animType =15  ">
							<xsl:value-of select ="'ooo-emphasis-bold-reveal'"/>
						</xsl:when>
						<xsl:when test ="$animType =16  ">
							<xsl:value-of select ="'ooo-emphasis-color-over-by-word'"/>
						</xsl:when>
						<xsl:when test ="$animType =18  ">
							<xsl:value-of select ="'ooo-emphasis-reveal-underline'"/>
						</xsl:when>
						<xsl:when test ="$animType =19  ">
							<xsl:value-of select ="'ooo-emphasis-color-blend'"/>
						</xsl:when>
						<xsl:when test ="$animType =20  ">
							<xsl:value-of select ="'ooo-emphasis-color-over-by-letter'"/>
						</xsl:when>
						<xsl:when test ="$animType =21  ">
							<xsl:value-of select ="'ooo-emphasis-complementary-color'"/>
						</xsl:when>
						<xsl:when test ="$animType =22  ">
							<xsl:value-of select ="'ooo-emphasis-complementary-color-2'"/>
						</xsl:when>
						<xsl:when test ="$animType =23  ">
							<xsl:value-of select ="'ooo-emphasis-contrasting-color'"/>
						</xsl:when>
						<xsl:when test ="$animType =24  ">
							<xsl:value-of select ="'ooo-emphasis-darken'"/>
						</xsl:when>
						<xsl:when test ="$animType =25  ">
							<xsl:value-of select ="'ooo-emphasis-desaturate'"/>
						</xsl:when>
						<xsl:when test ="$animType =26  ">
							<xsl:value-of select ="'ooo-emphasis-flash-bulb'"/>
						</xsl:when>
						<xsl:when test ="$animType =27  ">
							<xsl:value-of select ="'ooo-emphasis-flicker'"/>
						</xsl:when>
						<xsl:when test ="$animType =28  ">
							<xsl:value-of select ="'ooo-emphasis-grow-with-color'"/>
						</xsl:when>
						<xsl:when test ="$animType =30  ">
							<xsl:value-of select ="'ooo-emphasis-lighten'"/>
						</xsl:when>
						<xsl:when test ="$animType =31  ">
							<xsl:value-of select ="'ooo-emphasis-style-emphasis'"/>
						</xsl:when>
						<xsl:when test ="$animType =32  ">
							<xsl:value-of select ="'ooo-emphasis-teeter'"/>
						</xsl:when>
						<xsl:when test ="$animType =33  ">
							<xsl:value-of select ="'ooo-emphasis-vertical-highlight'"/>
						</xsl:when>
						<xsl:when test ="$animType =34 ">
							<xsl:value-of select ="'ooo-emphasis-wave'"/>
						</xsl:when>
						<xsl:when test ="$animType =35  ">
							<xsl:value-of select ="'ooo-emphasis-blink'"/>
						</xsl:when>
						<xsl:when test ="$animType =36  ">
							<xsl:value-of select ="'ooo-emphasis-shimmer'"/>
						</xsl:when>						
					</xsl:choose>
				</xsl:when >
			</xsl:choose>
		</xsl:attribute>
		<xsl:variable name ="subAnim">
			<xsl:choose>
				<xsl:when test ="./p:cTn/@presetClass='entr'">
					<xsl:choose >
						<!--Start of RefNo-1-->
						<xsl:when test ="$animType = 5">
							<xsl:choose>
								<xsl:when test ="./p:cTn/@presetSubtype ='10'">
									<xsl:value-of select ="'across'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='5'">
									<xsl:value-of select ="'downward'"/>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:when test ="$animType =17">
							<xsl:choose>
								<xsl:when test ="./p:cTn/@presetSubtype ='10'">
									<xsl:value-of select ="'across'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='4'">
									<xsl:value-of select ="'from-bottom'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='8'">
									<xsl:value-of select ="'from-left'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='1'">
									<xsl:value-of select ="'from-top'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='2'">
									<xsl:value-of select ="'from-right'"/>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:when test ="$animType =18">
							<xsl:choose>
								<xsl:when test ="./p:cTn/@presetSubtype ='12'">
									<xsl:value-of select ="'left-to-bottom'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='9'">
									<xsl:value-of select ="'left-to-top'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='6'">
									<xsl:value-of select ="'right-to-bottom'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='3'">
									<xsl:value-of select ="'right-to-top'"/>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:when test ="$animType =21">
							<xsl:choose>
								<xsl:when test ="./p:cTn/@presetSubtype ='1'">
									<xsl:value-of select ="'1'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='2'">
									<xsl:value-of select ="'2'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='3'">
									<xsl:value-of select ="'3'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='4'">
									<xsl:value-of select ="'4'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='8'">
									<xsl:value-of select ="'8'"/>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
            <xsl:when test ="$animType =3">
              <xsl:choose>
                <xsl:when test ="./p:cTn/@presetSubtype ='10'">
                  <xsl:value-of select ="'horizontal'"/>
                </xsl:when>
                <xsl:when test ="./p:cTn/@presetSubtype ='5'">
                  <xsl:value-of select ="'vertical'"/>
                </xsl:when>
                <xsl:otherwise >
                  <xsl:value-of select ="'vertical'"/>
                </xsl:otherwise>
              </xsl:choose >
              </xsl:when >
						<xsl:when test ="$animType =14">
							<xsl:choose>
								<xsl:when test ="./p:cTn/@presetSubtype ='10'">
									<xsl:value-of select ="'horizontal'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='5'">
									<xsl:value-of select ="'vertical'"/>
								</xsl:when>
								<xsl:otherwise >
									<xsl:value-of select ="'horizontal'"/>
								</xsl:otherwise>
							</xsl:choose >
						</xsl:when >
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test ="./p:cTn/@presetSubtype ='4'">
									<xsl:value-of select ="'from-bottom'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='8'">
									<xsl:value-of select ="'from-left'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='2'">
									<xsl:value-of select ="'from-right'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='1'">
									<xsl:value-of select ="'from-top'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='12'">
									<xsl:value-of select ="'from-bottom-left'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='6'">
									<xsl:value-of select ="'from-bottom-right'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='9'">
									<xsl:value-of select ="'from-top-left'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='3'">
									<xsl:value-of select ="'from-top-right'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='10'">
									<xsl:value-of select ="'vertical'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='5'">
									<xsl:value-of select ="'horizontal'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='16'">
									<xsl:value-of select ="'in'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='32'">
									<xsl:value-of select ="'out'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='26'">
									<xsl:value-of select ="'horizontal-in'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='42'">
									<xsl:value-of select ="'horizontal-out'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='21'">
									<xsl:value-of select ="'vertical-in'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='37'">
									<xsl:value-of select ="'vertical-out'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='528'">
									<xsl:value-of select ="'in-from-screen-center'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='272'">
									<xsl:value-of select ="'in-slightly'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='36'">
									<xsl:value-of select ="'out-from-screen-center'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='288'">
									<xsl:value-of select ="'out-slightly'"/>
								</xsl:when>
							</xsl:choose>
						</xsl:otherwise>
						<!--End of RefNo-1-->
					</xsl:choose>
				</xsl:when >
				<xsl:when test ="./p:cTn/@presetClass ='exit'">
					<xsl:choose >
						<!--Start of RefNo-1-->
						<xsl:when test ="$animType = 5">
							<xsl:choose>
								<xsl:when test ="./p:cTn/@presetSubtype ='10'">
									<xsl:value-of select ="'across'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='5'">
									<xsl:value-of select ="'downward'"/>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:when test ="$animType = 3">
							<xsl:choose>
								<xsl:when test ="./p:cTn/@presetSubtype ='10'">
									<xsl:value-of select ="'horizontal'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='5'">
									<xsl:value-of select ="'vertical'"/>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:when test ="$animType =18">
							<xsl:choose>
								<xsl:when test ="./p:cTn/@presetSubtype ='12'">
									<xsl:value-of select ="'left-to-bottom'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='9'">
									<xsl:value-of select ="'left-to-top'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='6'">
									<xsl:value-of select ="'right-to-bottom'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='3'">
									<xsl:value-of select ="'right-to-top'"/>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:when test ="$animType =21">
							<xsl:choose>
								<xsl:when test ="./p:cTn/@presetSubtype ='1'">
									<xsl:value-of select ="'1'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='2'">
									<xsl:value-of select ="'2'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='3'">
									<xsl:value-of select ="'3'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='4'">
									<xsl:value-of select ="'4'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='8'">
									<xsl:value-of select ="'8'"/>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test ="./p:cTn/@presetSubtype ='4'">
									<xsl:value-of select ="'from-bottom'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='8'">
									<xsl:value-of select ="'from-left'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='2'">
									<xsl:value-of select ="'from-right'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='1'">
									<xsl:value-of select ="'from-top'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='12'">
									<xsl:value-of select ="'from-bottom-left'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='6'">
									<xsl:value-of select ="'from-bottom-right'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='9'">
									<xsl:value-of select ="'from-top-left'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='3'">
									<xsl:value-of select ="'from-top-right'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='10'">
									<xsl:if test ="$animType =17">
										<xsl:value-of select ="'across'"/>
									</xsl:if>
									<xsl:if test ="$animType !=17">
										<xsl:value-of select ="'vertical'"/>
									</xsl:if>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='5'">
									<xsl:value-of select ="'horizontal'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='16'">
									<xsl:value-of select ="'in'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='32'">
									<xsl:value-of select ="'out'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='26'">
									<xsl:value-of select ="'horizontal-in'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='42'">
									<xsl:value-of select ="'horizontal-out'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='21'">
									<xsl:value-of select ="'vertical-in'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='37'">
									<xsl:value-of select ="'vertical-out'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='544'">
									<xsl:value-of select ="'544'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='272'">
									<xsl:value-of select ="'in-slightly'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='20'">
									<xsl:value-of select ="'20'"/>
								</xsl:when>
								<xsl:when test ="./p:cTn/@presetSubtype ='288'">
									<xsl:value-of select ="'out-slightly'"/>
								</xsl:when>
							</xsl:choose>
						</xsl:otherwise>
						<!--End of RefNo-1-->
					</xsl:choose>
				</xsl:when >
				<xsl:when test ="./p:cTn/@presetClass ='emph'">
					<!--Start of RefNo-1-->
					<xsl:choose>
						<xsl:when test ="./p:cTn/@presetSubtype ='2'">
							<xsl:value-of select ="'2'"/>
						</xsl:when>
						<xsl:when test ="./p:cTn/@presetSubtype ='4'">
							<xsl:value-of select ="'4'"/>
						</xsl:when>
					</xsl:choose>
					<!--End of RefNo-1-->
				</xsl:when >
			</xsl:choose>
		</xsl:variable >
		<xsl:if test ="$subAnim!=''">
			<xsl:attribute name ="presentation:preset-sub-type">
				<xsl:value-of select ="$subAnim"/>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="decimal2Hex">		
		<xsl:param name ="strVal"/>
		<xsl:variable name="hexaVal1">
			<xsl:call-template name="hexaEqu">
				<xsl:with-param name="decInput">
					<xsl:choose>
						<xsl:when test="substring-after(substring-before($strVal,','),'(') &gt; 0">
							<xsl:value-of select="substring-after(substring-before($strVal,','),'(')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-after(substring-before($strVal,','),'(') + 256"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				
			</xsl:call-template>			
		</xsl:variable>
		<xsl:variable name="hexaVal2">
			<xsl:call-template name="hexaEqu">				
				<xsl:with-param name="decInput">
					<xsl:choose>
						<xsl:when test="substring-before(substring-after($strVal,','),',') &gt; 0">
							<xsl:value-of select="substring-before(substring-after($strVal,','),',')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-before(substring-after($strVal,','),',') + 256"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>			
		</xsl:variable>
		<xsl:variable name="hexaVal3">
			<xsl:call-template name="hexaEqu">				
				<xsl:with-param name="decInput">
					<xsl:choose>
						<xsl:when test="substring-before(substring-after(substring-after($strVal,','),','),')') &gt; 0">
							<xsl:value-of select="substring-before(substring-after(substring-after($strVal,','),','),')')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-before(substring-after(substring-after($strVal,','),','),')') + 256"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>			
		</xsl:variable>
		<xsl:value-of select="concat('#',$hexaVal3,$hexaVal2,$hexaVal1)"/>
	</xsl:template>
	<xsl:template name="hexaEqu">
		<xsl:param name="decInput"/>
		<xsl:variable name="firstval">
			<xsl:call-template name="hexaConvertion">
				<xsl:with-param name="inputDecimal" select="floor($decInput div 16)"/>
			</xsl:call-template>			
		</xsl:variable>
		<xsl:variable name="secondval">
			<xsl:call-template name="hexaConvertion">
				<xsl:with-param name="inputDecimal" select="floor($decInput mod 16)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="concat($firstval,$secondval)"/>		
	</xsl:template>
	<xsl:template name="hexaConvertion">
		<xsl:param name="inputDecimal"/>
		<xsl:choose>
			<xsl:when test="$inputDecimal = 0">
				<xsl:value-of select="'0'"/>
			</xsl:when>
			<xsl:when test="$inputDecimal = 1">
				<xsl:value-of select="'1'"/>
			</xsl:when>
			<xsl:when test="$inputDecimal = 2">
				<xsl:value-of select="'2'"/>
			</xsl:when>
			<xsl:when test="$inputDecimal = 3">
				<xsl:value-of select="'3'"/>
			</xsl:when>
			<xsl:when test="$inputDecimal = 4">
				<xsl:value-of select="'4'"/>
			</xsl:when>
			<xsl:when test="$inputDecimal = 5">
				<xsl:value-of select="'5'"/>
			</xsl:when>
			<xsl:when test="$inputDecimal = 6">
				<xsl:value-of select="'6'"/>
			</xsl:when>
			<xsl:when test="$inputDecimal = 7">
				<xsl:value-of select="'7'"/>
			</xsl:when>
			<xsl:when test="$inputDecimal = 8">
				<xsl:value-of select="'8'"/>
			</xsl:when>
			<xsl:when test="$inputDecimal = 9">
				<xsl:value-of select="'9'"/>
			</xsl:when>
			<xsl:when test="$inputDecimal = 10">
				<xsl:value-of select="'a'"/>
			</xsl:when>
			<xsl:when test="$inputDecimal = 11">
				<xsl:value-of select="'b'"/>
			</xsl:when>
			<xsl:when test="$inputDecimal = 12">
				<xsl:value-of select="'c'"/>
			</xsl:when>
			<xsl:when test="$inputDecimal = 13">
				<xsl:value-of select="'d'"/>
			</xsl:when>
			<xsl:when test="$inputDecimal = 14">
				<xsl:value-of select="'e'"/>
			</xsl:when>
			<xsl:when test="$inputDecimal = 15">
				<xsl:value-of select="'f'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'0'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
	