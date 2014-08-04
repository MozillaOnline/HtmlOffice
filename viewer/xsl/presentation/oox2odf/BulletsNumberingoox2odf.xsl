<?xml version="1.0" encoding="utf-8" standalone="yes" ?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
  xmlns:odf="urn:odf"
  xmlns:pzip="urn:cleverage:xmlns:post-processings:zip"
  xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
  xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
  xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
  xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
  xmlns:page="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
  xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
  xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0"
  xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
  xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships"
xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"
  exclude-result-prefixes="odf style text number draw page p a r xlink">

	
	<xsl:template name ="insertBulletsNumbersoox2odf">
		<xsl:param name ="listStyleName" />
		<xsl:param  name ="ParaId"/>
		<!--added by vipul start-->
		<xsl:param  name ="TypeId"/>
		<!--added by vipul End-->
		<!-- parameters 'slideRelationId' and 'slideId' added by lohith - required to set Hyperlinks for bulleted text -->
		<xsl:param name="slideRelationId" />
		<xsl:param name="slideId" />
		<xsl:variable name ="textSpanNode">
			<text:p >
        <xsl:if test="$ParaId!=''">
				<xsl:attribute name ="text:style-name">
					<xsl:value-of select ="concat($ParaId,position())"/>
				</xsl:attribute>
        </xsl:if>
				<xsl:attribute name ="text:id" >
					<xsl:if test ="contains($slideId,'slide')">
						<xsl:value-of  select ="concat('slText',substring-after($slideId,'slide'),'an',parent::node()/parent::node()/p:nvSpPr/p:cNvPr/@id,position())"/>
					</xsl:if>
					<xsl:if test ="not(contains($slideId,'slide'))">
						<xsl:value-of  select ="concat('slText',$slideId,'an',parent::node()/parent::node()/p:nvSpPr/p:cNvPr/@id,position())"/>
					</xsl:if>
				</xsl:attribute>
				<!--<xsl:attribute name ="text:id" >
			  <xsl:value-of  select ="concat('sl',substring-after($slideId,'slide'),'an',parent::node()/parent::node()/p:nvSpPr/p:cNvPr/@id,position())"/>
		  </xsl:attribute>-->
				<xsl:for-each select ="node()">
					<xsl:if test ="name()='a:r'">
						<text:span>
							<xsl:attribute name="text:style-name">
								<xsl:value-of select="concat($TypeId,generate-id())"/>
							</xsl:attribute>
							<!-- varibale 'nodeTextSpan' added by lohith.ar - need to have the text inside <text:a> tag if assigned with hyperlinks -->
							<xsl:variable name="nodeTextSpan">
                <xsl:call-template name="tmpTextSpanNode"/>
							</xsl:variable>
							<!-- Added by lohith.ar - Code for text Hyperlinks -->
							<xsl:if test="node()/a:hlinkClick and not(node()/a:hlinkClick/a:snd) ">
               
							
									<xsl:call-template name="AddTextHyperlinks">
										<xsl:with-param name="nodeAColonR" select="node()" />
										<xsl:with-param name="slideRelationId" select="$slideRelationId" />
										<xsl:with-param name="slideId" select="$slideId" />
                    <xsl:with-param name="nodeTextSpan" select="$nodeTextSpan" />
									</xsl:call-template>
								
							<!--</xsl:if>-->
							</xsl:if>
              <!--added by chhavi for conformance-->
							<xsl:if test="not(node()/a:hlinkClick and not(node()/a:hlinkClick/a:snd))">
								<xsl:copy-of select="$nodeTextSpan"/>
							</xsl:if>
						</text:span>
					</xsl:if >
					<xsl:if test ="name()='a:br'">
						<text:line-break/>
					</xsl:if>
					<xsl:if test ="name()='a:endParaRPr'">
						<text:span>
							<xsl:attribute name="text:style-name">
								<xsl:value-of select="concat($TypeId,generate-id())"/>
							</xsl:attribute>
						</text:span >
					</xsl:if >
				</xsl:for-each>
			</text:p>
		</xsl:variable>
		<xsl:message terminate="no">progress:p:cSld</xsl:message>
		<!--condition,If Levels Present-->
		<xsl:if test ="./a:pPr/@lvl">
			<xsl:call-template name ="insertMultipleLevels">
				<xsl:with-param name ="levelCount" select ="./a:pPr/@lvl"/>
				<xsl:with-param name ="ParaId" select ="$ParaId"/>
				<xsl:with-param name ="listStyleName" select ="$listStyleName"/>
				<xsl:with-param name ="sldRelId" select ="$slideRelationId"/>
				<xsl:with-param name ="sldId" select ="$slideId"/>
				<xsl:with-param name ="TypeId" select ="$TypeId"/>
				<xsl:with-param name ="textSpanNode" select ="$textSpanNode"/>
			</xsl:call-template>
		</xsl:if>
		<!-- Fix by vijayeta,on 22nd june,bug number1739817,also test if explicit lvl=0-->
		<xsl:if test ="not(./a:pPr/@lvl) or ./a:pPr/@lvl='0'">
			<text:list>
				<xsl:attribute name ="text:style-name">
					<xsl:value-of select ="$listStyleName"/>
				</xsl:attribute>
				<text:list-item>
					<xsl:copy-of select ="$textSpanNode"/>
				</text:list-item>
			</text:list>
		</xsl:if>
		<!--End of condition,If Levels Present-->
	</xsl:template>
	<xsl:template name ="insertBulletStyle">
		<xsl:param name ="slideRel" />
		<xsl:param name ="ParaId" />
		<xsl:param name ="listStyleName"/>
		<xsl:param name ="slideMaster" />
		<xsl:param name ="var_TextBoxType" />
		<xsl:param name ="var_index" />
		<xsl:param name ="slideLayout"/>
    <xsl:param name ="flageShape"/>
    
		<xsl:if test ="./a:p/a:pPr/@lvl">
    	<xsl:for-each select ="./a:p">
		       <xsl:variable name="buSize">
			<xsl:value-of  select="a:pPr/a:buSzPct/@val"/>
		</xsl:variable>
        <xsl:variable name="var_level">
          <xsl:choose>
            <xsl:when test="a:pPr/@lvl">
              <xsl:value-of select="a:pPr/@lvl"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'0'"/>
            </xsl:otherwise>
          </xsl:choose>

        </xsl:variable> 
        <xsl:variable name ="nodeName">
        <xsl:choose>
          <xsl:when test="a:pPr/@lvl">
            <xsl:value-of select ="concat('a:lvl',$var_level+1 ,'pPr')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select ="'a:lvl1pPr'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
     
				<xsl:variable name ="textColor">
					<xsl:for-each select ="a:r">
						<xsl:if test ="position()= '1'">
							<xsl:if test ="a:rPr">
								<xsl:if test ="./a:rPr/a:solidFill">
									<xsl:if test ="./a:rPr/a:solidFill/a:srgbClr">
										<xsl:value-of select ="concat('#',./a:rPr/a:solidFill/a:srgbClr/@val)"/>
									</xsl:if>
									<xsl:if test ="./a:rPr/a:solidFill/a:schemeClr">
										<xsl:call-template name ="getColorCode">
											<xsl:with-param name ="color">
												<xsl:value-of select="./a:rPr/a:solidFill/a:schemeClr/@val"/>
											</xsl:with-param>
										</xsl:call-template >
									</xsl:if>
								</xsl:if>
								<xsl:if test ="not(./a:rPr/a:solidFill)">
									<xsl:value-of select ="'0'"/>
								</xsl:if>
							</xsl:if>
							<xsl:if test ="not(./a:rPr)">
								<xsl:value-of select ="'0'"/>
							</xsl:if>
						</xsl:if >
					</xsl:for-each>
				</xsl:variable>
			   <!--code added by yeswanth : variable textFont-->
			   <xsl:variable name="textFont">
				<xsl:if test ="./a:r/a:rPr">
					<xsl:choose>
						<xsl:when test="./a:r[1]/a:rPr/a:latin/@typeface">
							<xsl:value-of select="./a:r[1]/a:rPr/a:latin/@typeface"/>
						</xsl:when>
						<xsl:when test="./a:r[1]/a:rPr/a:ea/@typeface">
							<xsl:value-of select="./a:r[1]/a:rPr/a:ea/@typeface"/>
						</xsl:when>
						<xsl:when test="./a:r[1]/a:rPr/a:cs/@typeface">
							<xsl:value-of select="./a:r[1]/a:rPr/a:cs/@typeface"/>
						</xsl:when>
						<xsl:otherwise>
							<!--<xsl:value-of select="$slideLayout"/>-->
							<xsl:call-template name="textFontLayout">
								<xsl:with-param name="slideLayout" select="$slideLayout"/>
								<xsl:with-param name="idx" select="./parent::node()/parent::node()/p:nvSpPr/p:nvPr/p:ph/@idx"/>
								<xsl:with-param name="slideMaster" select="$slideMaster"/>
								<xsl:with-param name="level" select="$var_level"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>				
			</xsl:variable>
			   <!--end-->
				<!-- Addded by vijayeta on 18th june,to check for bunone-->
				<xsl:if test ="not(a:pPr/a:buNone)">
					<!-- Addded by vijayeta on 18th june,to check for bunone-->
					<xsl:if test ="a:pPr/@lvl!='0'">
						<xsl:variable name ="levelStyle">
							<xsl:value-of select ="concat($listStyleName,position(),'lvl',a:pPr/@lvl)"/>
						</xsl:variable>
						<xsl:variable name ="textLevel" select ="a:pPr/@lvl"/>
						<xsl:variable name ="newTextLvl" select ="$textLevel+1"/>
           
						<xsl:choose >
							<xsl:when test ="a:pPr/a:buChar">
								<text:list-style>
									<xsl:attribute name ="style:name">
										<xsl:value-of select ="$levelStyle"/>
									</xsl:attribute >
									<text:list-level-style-bullet>
										<xsl:attribute name ="text:level">
											<xsl:value-of select ="$textLevel + 1"/>
										</xsl:attribute >
										<xsl:attribute name ="text:bullet-char">
                      <xsl:call-template name ="insertBulletCharacter">
                        <xsl:with-param name ="character" select ="a:pPr/a:buChar/@char" />
                      </xsl:call-template>
                    


					                    </xsl:attribute >
                    <xsl:choose>
                      <xsl:when test="$flageShape='True'">
                        <style:list-level-properties>
                          <xsl:for-each select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]">
                            <xsl:call-template name="tmBulletListLevelProp"/>
												</xsl:for-each>
                        </style:list-level-properties>
                      </xsl:when>
                      <xsl:otherwise>
                        <style:list-level-properties>
                        <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]">
                          <xsl:call-template name="tmBulletListLevelProp"/>
                        </xsl:for-each >
                        </style:list-level-properties>
                      </xsl:otherwise>
                    </xsl:choose>
		<style:text-properties style:font-charset="x-symbol">
      <xsl:call-template name="tmpBulletFont"/>
											<xsl:if test ="a:pPr/a:buSzPct">
												<xsl:attribute name ="fo:font-size">
													<xsl:value-of select ="concat((a:pPr/a:buSzPct/@val div 1000),'%')"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test ="not(a:pPr/a:buSzPct)">
												<xsl:attribute name ="fo:font-size">
													<xsl:value-of select ="'100%'"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test ="a:pPr/a:buClr">
												<xsl:if test ="a:pPr/a:buClr/a:srgbClr">
													<xsl:variable name ="color" select ="a:pPr/a:buClr/a:srgbClr/@val"/>
													<xsl:attribute name ="fo:color">
														<xsl:value-of select ="concat('#',$color)"/>
													</xsl:attribute>
												</xsl:if>
                        <xsl:if test ="a:pPr/a:buClr/a:schemeClr">
                          <xsl:variable name ="schemeColor" select ="a:pPr/a:buClr/a:schemeClr/@val"/>
                          <xsl:variable name ="levelColor" >
                            <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle">
                              <xsl:call-template name ="getColorMap">
                                <xsl:with-param name ="schemeColor" select ="$schemeColor"/>
                              </xsl:call-template>
                            </xsl:for-each >
                          </xsl:variable>
                          <xsl:if test="$levelColor !=''">
                            <xsl:attribute name ="fo:color">
                          <xsl:call-template name ="getColorCode">
                            <xsl:with-param name ="color">
                              <xsl:value-of select="$levelColor"/>
                            </xsl:with-param>
                          </xsl:call-template >
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:if>
											</xsl:if>
											<!-- Code added by vijayeta, bug fix 1746350-->
											<xsl:if test ="not(a:pPr/a:buClr)">
												<!-- Vijayeta,Custom Bullet Colour-->
												<xsl:if test ="$textColor !='0'">
													<xsl:attribute name ="fo:color">
														<xsl:value-of select ="$textColor"/>
													</xsl:attribute>
												</xsl:if>
												<xsl:if test ="$textColor='0'">
													<xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle">
														<xsl:variable name ="levelColor" >
															<xsl:call-template name ="getLevelColor">
																<xsl:with-param name ="levelNum" select ="$newTextLvl"/>
                                <xsl:with-param name ="textColor" select="$textColor" />
															</xsl:call-template>
														</xsl:variable>
														<xsl:attribute name ="fo:color">
															<xsl:value-of select ="$levelColor"/>
														</xsl:attribute>
													</xsl:for-each>
												</xsl:if>
												<!-- Vijayeta,Custom Bullet Colour-->

											</xsl:if>
											<!--End of Code added by vijayeta, bug fix 1746350-->
										</style:text-properties >
									</text:list-level-style-bullet>
								</text:list-style>
							</xsl:when>
							<xsl:when test ="a:pPr/a:buAutoNum">
								<text:list-style>
									<xsl:attribute name ="style:name">
										<xsl:value-of select ="$levelStyle"/>
									</xsl:attribute >
									<text:list-level-style-number>
										<xsl:attribute name ="text:level">
											<xsl:value-of select ="$textLevel + 1"/>
										</xsl:attribute >
										<xsl:variable name ="startAt">
											<xsl:if test ="a:pPr/a:buAutoNum/@startAt">
												<xsl:value-of select ="a:pPr/a:buAutoNum/@startAt" />
											</xsl:if>
											<xsl:if test ="not(a:pPr/a:buAutoNum/@startAt)">
												<xsl:value-of select ="'1'" />
											</xsl:if>
										</xsl:variable>
										<xsl:call-template name ="insertNumber">
											<xsl:with-param name ="number" select ="a:pPr/a:buAutoNum/@type"/>
											<xsl:with-param name ="startAt" select ="$startAt"/>
										</xsl:call-template>
                    <style:list-level-properties>
                      <xsl:choose>
                        <xsl:when test="$flageShape='True'">
                          <xsl:for-each select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]">
                            <xsl:call-template name="tmBulletListLevelProp"/>
                          </xsl:for-each >
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]">
                            <xsl:call-template name="tmBulletListLevelProp"/>
                          </xsl:for-each >
                        </xsl:otherwise>
                      </xsl:choose>
                    </style:list-level-properties>
										<style:text-properties style:font-family-generic="swiss" style:font-pitch="variable">
											<xsl:if test ="a:pPr/a:buFont/@typeface">
												<xsl:attribute name ="fo:font-family">
													<xsl:value-of select ="a:pPr/a:buFont/@typeface"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test ="not(a:pPr/a:buFont/@typeface)">
												<xsl:attribute name ="fo:font-family">
													<xsl:value-of select ="'Arial'"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test ="not(a:pPr/a:buSzPct)">
												<xsl:attribute name ="fo:font-size">
													<xsl:value-of select ="'100%'"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test ="a:pPr/a:buClr">
												<xsl:if test ="a:p/a:pPr/a:buClr/a:srgbClr">
													<xsl:attribute name ="fo:color">
														<xsl:value-of select ="concat('#',a:p/a:pPr/a:buClr/a:srgbClr/@val)"/>
													</xsl:attribute>
												</xsl:if>
                        <xsl:if test ="a:pPr/a:buClr/a:schemeClr">
                          <xsl:variable name ="schemeColor" select ="a:pPr/a:buClr/a:schemeClr/@val"/>
                          <xsl:variable name ="levelColor" >
                            <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle">
                              <xsl:call-template name ="getColorMap">
                                <xsl:with-param name ="schemeColor" select ="$schemeColor"/>
                              </xsl:call-template>
                            </xsl:for-each >
                          </xsl:variable>
                          <!--added by chhavi for conformance-->
                          <xsl:if test="$levelColor !=''">
                            <xsl:attribute name ="fo:color">
                          <xsl:call-template name ="getColorCode">
                            <xsl:with-param name ="color">
                              <xsl:value-of select="$levelColor"/>
                            </xsl:with-param>
                          </xsl:call-template >
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:if>
											</xsl:if>
											<!-- Code added by vijayeta, bug fix 1746350-->
											<xsl:if test ="not(a:pPr/a:buClr)">
												<!-- Vijayeta,Custom Bullet Colour-->
												<xsl:if test ="$textColor !='0'">
													<xsl:attribute name ="fo:color">
														<xsl:value-of select ="$textColor"/>
													</xsl:attribute>
												</xsl:if>
												<xsl:if test ="$textColor='0'">
													<xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle">
														<xsl:variable name ="levelColor" >
															<xsl:call-template name ="getLevelColor">
																<xsl:with-param name ="levelNum" select ="$newTextLvl"/>
                                <xsl:with-param name ="textColor" select="$textColor" />
															</xsl:call-template>
														</xsl:variable>
														<xsl:attribute name ="fo:color">
															<xsl:value-of select ="$levelColor"/>
														</xsl:attribute>
													</xsl:for-each>
												</xsl:if>
												<!-- Vijayeta,Custom Bullet Colour-->

											</xsl:if>
											<!--End of Code added by vijayeta, bug fix 1746350-->
										</style:text-properties>
									</text:list-level-style-number>
								</text:list-style>
							</xsl:when>
              <xsl:when test ="a:pPr/a:buBlip">
                <xsl:variable name ="rId" select ="a:pPr/a:buBlip/a:blip/@r:embed"/>
                <xsl:variable name="XlinkHref">
                  <xsl:variable name="pzipsource">
                    <xsl:value-of select="key('Part', $slideRel)//rels:Relationships/rels:Relationship[@Id=$rId]/@Target"/>
                  </xsl:variable>
                  <xsl:value-of select="concat('Pictures/', substring-after($pzipsource,'../media/'))"/>
                </xsl:variable>
                <xsl:call-template name="copyPictures">
                  <xsl:with-param name="document">
                    <xsl:value-of select="$slideRel"/>
                  </xsl:with-param>
                  <xsl:with-param name="rId">
                    <xsl:value-of select ="$rId"/>
                  </xsl:with-param>
                </xsl:call-template>
                <text:list-style>
                  <xsl:attribute name ="style:name">
                    <xsl:value-of select ="$levelStyle"/>
                  </xsl:attribute >
                  <text:list-level-style-image xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad">
                    <xsl:attribute name ="text:level">
                      <xsl:value-of select="$newTextLvl"/>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:href">
                      <xsl:value-of select="$XlinkHref"/>
                    </xsl:attribute>
                    <style:list-level-properties style:vertical-pos="middle" style:vertical-rel="line" fo:width="0.318cm" fo:height="0.318cm" />
                  </text:list-level-style-image>
                </text:list-style>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$slideLayout))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph">
                  <xsl:if test ="./@idx=$var_index">
                    <xsl:if test="not(./@type) or ./@type='body'">
                      <xsl:call-template name ="getBulletForLevelsLayout">
                        <xsl:with-param name ="slideMaster" select ="$slideMaster"/>
                        <xsl:with-param name ="slideLayout" select ="$slideLayout"/>
                        <xsl:with-param name ="newTextLvl" select ="$newTextLvl"/>
                        <xsl:with-param name ="levelStyle" select ="$levelStyle"/>
                        <xsl:with-param name ="textColor" select ="$textColor"/>
						<xsl:with-param name="buSize" select="$buSize"/>
						<xsl:with-param name="textFont" select="$textFont"/>						  
                      </xsl:call-template>
                    </xsl:if>
                  </xsl:if>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <!-- Fix by vijayeta,on 22nd june,bug number1739817,also test if explicit lvl=0-->
          <xsl:if test ="not(a:pPr/@lvl) or a:pPr/@lvl='0'">
            <xsl:variable name ="levelStyle" select ="concat($listStyleName,position())"/>
            <xsl:choose >
              <xsl:when test ="a:pPr/a:buChar">
                <text:list-style>
                  <xsl:attribute name ="style:name">
                    <xsl:value-of select ="concat($listStyleName,position())"/>
                  </xsl:attribute >
                  <text:list-level-style-bullet>
                    <xsl:attribute name ="text:level">
                      <xsl:value-of select ="1"/>
                    </xsl:attribute >
                    <xsl:attribute name ="text:bullet-char">
                      <xsl:call-template name ="insertBulletCharacter">
                        <xsl:with-param name ="character" select ="a:pPr/a:buChar/@char" />
                      </xsl:call-template>
                     
                    </xsl:attribute >
                    <style:list-level-properties>
                      <xsl:choose>
                        <xsl:when test="$flageShape='True'">
                          <xsl:for-each select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]">
                            <xsl:call-template name="tmBulletListLevelProp"/>
                        </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]">
                            <xsl:call-template name="tmBulletListLevelProp"/>
                          </xsl:for-each >
                        </xsl:otherwise>
                      </xsl:choose>
                    </style:list-level-properties>
                    <style:text-properties style:font-charset="x-symbol" >
                      <xsl:call-template name="tmpBulletFont"/>
											<xsl:if test ="a:pPr/a:buSzPct">
												<xsl:attribute name ="fo:font-size">
													<xsl:value-of select ="concat((a:pPr/a:buSzPct/@val div 1000),'%')"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test ="not(a:pPr/a:buSzPct)">
												<xsl:attribute name ="fo:font-size">
													<xsl:value-of select ="'100%'"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test ="a:pPr/a:buClr">
												<xsl:if test ="a:pPr/a:buClr/a:srgbClr">
													<xsl:variable name ="color" select ="a:pPr/a:buClr/a:srgbClr/@val"/>
													<xsl:attribute name ="fo:color">
														<xsl:value-of select ="concat('#',$color)"/>
													</xsl:attribute>
												</xsl:if>
                        <xsl:if test ="a:pPr/a:buClr/a:schemeClr">
                          <xsl:variable name ="schemeColor" select ="a:pPr/a:buClr/a:schemeClr/@val"/>
                          <xsl:variable name ="levelColor" >
                            <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle">
                              <xsl:call-template name ="getColorMap">
                                <xsl:with-param name ="schemeColor" select ="$schemeColor"/>
                              </xsl:call-template>
                            </xsl:for-each >
                          </xsl:variable>
                          <xsl:if test="$levelColor !=''">
                            <xsl:attribute name ="fo:color">
                          <xsl:call-template name ="getColorCode">
                            <xsl:with-param name ="color">
                              <xsl:value-of select="$levelColor"/>
                            </xsl:with-param>
                          </xsl:call-template >
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:if>
											</xsl:if>
											<xsl:if test ="not(a:pPr/a:buClr)">
												<!-- Vijayeta,Custom Bullet Colour-->
												<xsl:if test ="$textColor !='0'">
													<xsl:attribute name ="fo:color">
														<xsl:value-of select ="$textColor"/>
													</xsl:attribute>
												</xsl:if>
												<xsl:if test ="$textColor='0'">
													<xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle">
														<xsl:variable name ="levelColor" >
															<xsl:call-template name ="getLevelColor">
																<xsl:with-param name ="levelNum" select ="'1'"/>
                                <xsl:with-param name ="textColor" select="$textColor" />
															</xsl:call-template>
														</xsl:variable>
														<xsl:attribute name ="fo:color">
															<xsl:value-of select ="$levelColor"/>
														</xsl:attribute>
													</xsl:for-each>
												</xsl:if>
												<!-- Vijayeta,Custom Bullet Colour-->

											</xsl:if>
											<!--End of Code added by vijayeta, bug fix 1746350-->
										</style:text-properties >
									</text:list-level-style-bullet>
								</text:list-style>
							</xsl:when>
							<xsl:when test ="a:pPr/a:buAutoNum">
								<text:list-style>
									<xsl:attribute name ="style:name">
										<xsl:value-of select ="concat($listStyleName,position())"/>
									</xsl:attribute >
									<text:list-level-style-number>
										<xsl:attribute name ="text:level">
											<xsl:value-of select ="'1'"/>
										</xsl:attribute >
										<xsl:variable name ="startAt">
											<xsl:if test ="a:pPr/a:buAutoNum/@startAt">
												<xsl:value-of select ="a:pPr/a:buAutoNum/@startAt" />
											</xsl:if>
											<xsl:if test ="not(a:pPr/a:buAutoNum/@startAt)">
												<xsl:value-of select ="'1'" />
											</xsl:if>
										</xsl:variable>
										<xsl:call-template name ="insertNumber">
											<xsl:with-param name ="number" select ="a:pPr/a:buAutoNum/@type"/>
											<xsl:with-param name ="startAt" select ="$startAt"/>
										</xsl:call-template>
                    <style:list-level-properties>
                      <xsl:choose>
                        <xsl:when test="$flageShape='True'">
                          <xsl:for-each select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]">
                            <xsl:call-template name="tmBulletListLevelProp"/>
                          </xsl:for-each >
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]">
                            <xsl:call-template name="tmBulletListLevelProp"/>
                          </xsl:for-each >
                        </xsl:otherwise>
                      </xsl:choose>
                    </style:list-level-properties>
										<style:text-properties style:font-family-generic="swiss" style:font-pitch="variable">
											<xsl:if test ="a:pPr/a:buFont/@typeface">
												<xsl:attribute name ="fo:font-family">
													<xsl:value-of select ="a:pPr/a:buFont/@typeface"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test ="not(a:pPr/a:buFont/@typeface)">
												<xsl:attribute name ="fo:font-family">
													<xsl:value-of select ="'Arial'"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test ="a:pPr/a:buSzPct">
												<xsl:attribute name ="fo:font-size">
													<xsl:value-of select ="concat((a:pPr/a:buSzPct/@val div 1000),'%')"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test ="not(a:pPr/a:buSzPct)">
												<xsl:attribute name ="fo:font-size">
													<xsl:value-of select ="'100%'"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test ="a:pPr/a:buClr">
												<xsl:if test ="a:p/a:pPr/a:buClr/a:srgbClr">
													<xsl:attribute name ="fo:color">
														<xsl:value-of select ="concat('#',a:p/a:pPr/a:buClr/a:srgbClr/@val)"/>
													</xsl:attribute>
												</xsl:if>
												<xsl:if test ="a:pPr/a:buClr/a:schemeClr">
                          <xsl:variable name ="schemeColor" select ="a:pPr/a:buClr/a:schemeClr/@val"/>
                          <xsl:variable name ="levelColor" >
                            <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle">
                              <xsl:call-template name ="getColorMap">
                                <xsl:with-param name ="schemeColor" select ="$schemeColor"/>
                              </xsl:call-template>
                            </xsl:for-each >
                          </xsl:variable>
                          <!--added by chhavi for conformance-->
                          <xsl:if test="$levelColor !=''">
                            <xsl:attribute name ="fo:color">
                          <xsl:call-template name ="getColorCode">
                            <xsl:with-param name ="color">
                              <xsl:value-of select="$levelColor"/>
                            </xsl:with-param>
                          </xsl:call-template >
                            </xsl:attribute>
                          </xsl:if>
												</xsl:if>
											</xsl:if>
											<!-- Code added by vijayeta, bug fix 1746350-->
											<xsl:if test ="not(a:pPr/a:buClr)">
												<!-- Vijayeta,Custom Bullet Colour-->
												<xsl:if test ="$textColor !='0'">
													<xsl:attribute name ="fo:color">
														<xsl:value-of select ="$textColor"/>
													</xsl:attribute>
												</xsl:if>
												<xsl:if test ="$textColor='0'">
													<xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle">
														<xsl:variable name ="levelColor" >
															<xsl:call-template name ="getLevelColor">
																<xsl:with-param name ="levelNum" select ="'1'"/>
                                <xsl:with-param name ="textColor" select="$textColor" />
															</xsl:call-template>
														</xsl:variable>
														<xsl:attribute name ="fo:color">
															<xsl:value-of select ="$levelColor"/>
														</xsl:attribute>
													</xsl:for-each>
												</xsl:if>
												<!-- Vijayeta,Custom Bullet Colour-->

											</xsl:if>
											<!--End of Code added by vijayeta, bug fix 1746350-->
										</style:text-properties>
									</text:list-level-style-number>
								</text:list-style>
							</xsl:when>
              <xsl:when test ="a:pPr/a:buBlip">
                <xsl:variable name ="rId" select ="a:pPr/a:buBlip/a:blip/@r:embed"/>
                <xsl:variable name="XlinkHref">
                  <xsl:variable name="pzipsource">
                    <xsl:value-of select="key('Part', $slideRel)//rels:Relationships/rels:Relationship[@Id=$rId]/@Target"/>
                  </xsl:variable>
                  <xsl:value-of select="concat('Pictures/', substring-after($pzipsource,'../media/'))"/>
                </xsl:variable>
                <xsl:call-template name="copyPictures">
                  <xsl:with-param name="document">
                    <xsl:value-of select="$slideRel"/>
                  </xsl:with-param>
                  <xsl:with-param name="rId">
                    <xsl:value-of select ="$rId"/>
                  </xsl:with-param>
                </xsl:call-template>
                <text:list-style>
                  <xsl:attribute name ="style:name">
                    <xsl:value-of select ="$levelStyle"/>
                  </xsl:attribute >
                  <text:list-level-style-image text:level="1" xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad">
                    <xsl:attribute name="xlink:href">
                      <xsl:value-of select="$XlinkHref"/>
                    </xsl:attribute>
                    <style:list-level-properties style:vertical-pos="middle" style:vertical-rel="line" fo:width="0.450cm" fo:height="0.450cm"/>
                  </text:list-level-style-image>
                </text:list-style>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$slideLayout))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph">
                  <xsl:if test ="./@idx=$var_index">
                    <xsl:if test="not(./@type) or ./@type='body'">
                      <xsl:call-template name ="getBulletForLevelsLayout">
                        <xsl:with-param name ="slideMaster" select ="$slideMaster"/>
                        <xsl:with-param name ="slideLayout" select ="$slideLayout"/>
                        <xsl:with-param name ="newTextLvl" select ="'1'"/>
                        <xsl:with-param name ="levelStyle" select ="$levelStyle"/>
                        <xsl:with-param name ="textColor" select ="$textColor"/>
						  <xsl:with-param name="buSize" select="$buSize"/>
						  <xsl:with-param name="textFont" select="$textFont"/>
                      </xsl:call-template>
                    </xsl:if>
                  </xsl:if>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <!-- Addded by vijayeta on 18th june,to check for bunone-->
        </xsl:if>
        <!-- Addded by vijayeta on 18th june,to check for bunone-->
      </xsl:for-each>
    </xsl:if>
    <!--End of Condition if levels are present-->
    <!--Condition if levels are not present-->
    <!-- Fix by vijayeta,on 22nd june,bug number1739817,also test if explicit lvl=0-->
    <xsl:if test ="not(./a:p/a:pPr/@lvl)">
      <xsl:for-each select ="./a:p">
        <xsl:variable name ="nodeName">
          <xsl:value-of select ="'a:lvl1pPr'"/>
        </xsl:variable>
        <!-- Addded by vijayeta on 18th june,to check for bunone-->
        <xsl:if test ="not(a:pPr/a:buNone)">
          <!-- Addded by vijayeta on 18th june,to check for bunone-->
          <xsl:variable name ="levelStyle" select ="concat($listStyleName,position())"/>
			<xsl:variable name="buSize">
				<xsl:value-of  select="a:pPr/a:buSzPct/@val"/>
			</xsl:variable>
          <xsl:variable name ="textColor">
            <xsl:for-each select ="a:r">
              <xsl:if test ="position()= '1'">
								<xsl:if test ="a:rPr">
									<xsl:if test ="./a:rPr/a:solidFill">
										<xsl:if test ="./a:rPr/a:solidFill/a:srgbClr">
											<xsl:value-of select ="concat('#',./a:rPr/a:solidFill/a:srgbClr/@val)"/>
										</xsl:if>
										<xsl:if test ="./a:rPr/a:solidFill/a:schemeClr">
											<xsl:call-template name ="getColorCode">
												<xsl:with-param name ="color">
													<xsl:value-of select="./a:rPr/a:solidFill/a:schemeClr/@val"/>
												</xsl:with-param>
											</xsl:call-template >
										</xsl:if>
									</xsl:if>
									<xsl:if test ="not(./a:rPr/a:solidFill)">
										<xsl:value-of select ="'0'"/>
									</xsl:if>
								</xsl:if>
								<xsl:if test ="not(./a:rPr)">
									<xsl:value-of select ="'0'"/>
								</xsl:if>
							</xsl:if >
						</xsl:for-each>
					</xsl:variable>
			<!--code added by yeswanth : variable textFont-->
			<xsl:variable name="textFont">
				<xsl:if test ="./a:r/a:rPr">
					<xsl:choose>
						<xsl:when test="./a:r[1]/a:rPr/a:latin/@typeface">
							<xsl:value-of select="./a:r[1]/a:rPr/a:latin/@typeface"/>
						</xsl:when>
						<xsl:when test="./a:r[1]/a:rPr/a:ea/@typeface">
							<xsl:value-of select="./a:r[1]/a:rPr/a:ea/@typeface"/>
						</xsl:when>
						<xsl:when test="./a:r[1]/a:rPr/a:cs/@typeface">
							<xsl:value-of select="./a:r[1]/a:rPr/a:cs/@typeface"/>
						</xsl:when>
						<xsl:otherwise>
							<!--<xsl:value-of select="$slideLayout"/>-->
							<xsl:call-template name="textFontLayout">
								<xsl:with-param name="slideLayout" select="$slideLayout"/>
								<xsl:with-param name="idx" select="./parent::node()/parent::node()/p:nvSpPr/p:nvPr/p:ph/@idx"/>
								<xsl:with-param name="slideMaster" select="$slideMaster"/>
								<xsl:with-param name="level">
									<xsl:choose>
										<xsl:when test="./a:r/a:rPr/@lvl and (./a:r/a:rPr/@lvl!='0')">
											<xsl:value-of select="./a:r/a:rPr/@lvl"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="'0'"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:variable>
			<!--end-->
					<xsl:choose >
						<xsl:when test ="a:pPr/a:buChar">
							<text:list-style>
								<xsl:attribute name ="style:name">
									<xsl:value-of select ="$levelStyle"/>
								</xsl:attribute >
								<text:list-level-style-bullet>
									<xsl:attribute name ="text:level">
										<xsl:value-of select ="1"/>
									</xsl:attribute >
									<xsl:attribute name ="text:bullet-char">
                  	<xsl:call-template name ="insertBulletCharacter">
											<xsl:with-param name ="character" select ="a:pPr/a:buChar/@char" />
										</xsl:call-template>
									</xsl:attribute >
                  <style:list-level-properties>
                    <xsl:choose>
                      <xsl:when test="$flageShape='True'">
                        <xsl:for-each select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]">
                          <xsl:call-template name="tmBulletListLevelProp"/>
                        </xsl:for-each >
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]">
                          <xsl:call-template name="tmBulletListLevelProp"/>
                        </xsl:for-each >
                      </xsl:otherwise>
                    </xsl:choose>
                  </style:list-level-properties>
									<style:text-properties style:font-charset="x-symbol">
                    <xsl:call-template name="tmpBulletFont"/>
										<xsl:if test ="a:pPr/a:buSzPct">
											<xsl:attribute name ="fo:font-size">
												<xsl:value-of select ="concat((a:pPr/a:buSzPct/@val div 1000),'%')"/>
											</xsl:attribute>
										</xsl:if>
										<xsl:if test ="not(a:pPr/a:buSzPct)">
											<xsl:attribute name ="fo:font-size">
												<xsl:value-of select ="'100%'"/>
											</xsl:attribute>
										</xsl:if>
                    <xsl:if test ="a:pPr/a:buClr">
                      <xsl:if test ="a:pPr/a:buClr/a:srgbClr">
                        <xsl:variable name ="color" select ="a:pPr/a:buClr/a:srgbClr/@val"/>
                        <xsl:attribute name ="fo:color">
                          <xsl:value-of select ="concat('#',$color)"/>
                        </xsl:attribute>
                      </xsl:if>
                      <xsl:if test ="a:pPr/a:buClr/a:schemeClr">
                        <xsl:variable name ="schemeColor" select ="a:pPr/a:buClr/a:schemeClr/@val"/>
                        <xsl:variable name ="levelColor" >
                          <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle">
                            <xsl:call-template name ="getColorMap">
                              <xsl:with-param name ="schemeColor" select ="$schemeColor"/>
                            </xsl:call-template>
                          </xsl:for-each >
                        </xsl:variable>
                        <xsl:if test="$levelColor !=''">
                          <xsl:if test="$levelColor !=''">
                            <xsl:attribute name ="fo:color">
                        <xsl:call-template name ="getColorCode">
                          <xsl:with-param name ="color">
                            <xsl:value-of select="$levelColor"/>
                          </xsl:with-param>
                        </xsl:call-template >
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:if>
                      </xsl:if>
                    </xsl:if >
										<!-- Code added by vijayeta, bug fix 1746350-->

										<xsl:if test ="not(a:pPr/a:buClr)">
											<!-- Vijayeta,Custom Bullet Colour-->
											<xsl:if test ="$textColor !='0'">
												<xsl:attribute name ="fo:color">
													<xsl:value-of select ="$textColor"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test ="$textColor='0'">
												<xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle">
													<xsl:variable name ="levelColor" >
														<xsl:call-template name ="getLevelColor">
															<xsl:with-param name ="levelNum" select ="'1'"/>
                              <xsl:with-param name ="textColor" select="$textColor" />
														</xsl:call-template>
													</xsl:variable>
													<xsl:attribute name ="fo:color">
														<xsl:value-of select ="$levelColor"/>
													</xsl:attribute>
												</xsl:for-each>
											</xsl:if>
											<!-- Vijayeta,Custom Bullet Colour-->

										</xsl:if>
										<!--End of Code added by vijayeta, bug fix 1746350-->
									</style:text-properties >
								</text:list-level-style-bullet>
							</text:list-style>
						</xsl:when>
						<xsl:when test ="a:pPr/a:buAutoNum">
							<text:list-style>
								<xsl:attribute name ="style:name">
									<xsl:value-of select ="$levelStyle"/>
								</xsl:attribute >
								<text:list-level-style-number>
									<xsl:attribute name ="text:level">
										<xsl:value-of select ="'1'"/>
									</xsl:attribute >
									<xsl:variable name ="startAt">
										<xsl:if test ="a:pPr/a:buAutoNum/@startAt">
											<xsl:value-of select ="a:pPr/a:buAutoNum/@startAt" />
										</xsl:if>
										<xsl:if test ="not(a:pPr/a:buAutoNum/@startAt)">
											<xsl:value-of select ="'1'" />
										</xsl:if>
									</xsl:variable>
									<xsl:call-template name ="insertNumber">
										<xsl:with-param name ="number" select ="a:pPr/a:buAutoNum/@type"/>
										<xsl:with-param name ="startAt" select ="$startAt"/>
									</xsl:call-template>
                  <style:list-level-properties>
                    <xsl:choose>
                      <xsl:when test="$flageShape='True'">
                        <xsl:for-each select ="key('Part', 'ppt/presentation.xml')/p:presentation/p:defaultTextStyle/child::node()[name()=$nodeName]">
                          <xsl:call-template name="tmBulletListLevelProp"/>
                        </xsl:for-each >
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle/child::node()[name()=$nodeName]">
                          <xsl:call-template name="tmBulletListLevelProp"/>
                        </xsl:for-each>
                      </xsl:otherwise>
                    </xsl:choose>
                  </style:list-level-properties>
									<style:text-properties style:font-family-generic="swiss" style:font-pitch="variable">
										<xsl:if test ="a:pPr/a:buFont/@typeface">
											<xsl:attribute name ="fo:font-family">
												<xsl:value-of select ="a:pPr/a:buFont/@typeface"/>
											</xsl:attribute>
										</xsl:if>
										<xsl:if test ="not(a:pPr/a:buFont/@typeface)">
											<xsl:attribute name ="fo:font-family">
												<xsl:value-of select ="'Arial'"/>
											</xsl:attribute>
										</xsl:if>
										<xsl:if test ="a:pPr/a:buSzPct">
											<xsl:attribute name ="fo:font-size">
                        <!--changed by chhavi to fix v1.1 conformance-->
												<xsl:value-of select ="concat((a:pPr/a:buSzPct/@val div 1000),'%')"/>
											</xsl:attribute>
										</xsl:if>
										<xsl:if test ="not(a:pPr/a:buSzPct)">
											<xsl:attribute name ="fo:font-size">
												<xsl:value-of select ="'100%'"/>
											</xsl:attribute>
										</xsl:if>
										<xsl:if test ="a:pPr/a:buClr">
											<xsl:if test ="a:pPr/a:buClr/a:srgbClr">
												<xsl:attribute name ="fo:color">
													<xsl:value-of select ="concat('#',a:pPr/a:buClr/a:srgbClr/@val)"/>
												</xsl:attribute>
											</xsl:if>
                      <xsl:if test ="a:pPr/a:buClr/a:schemeClr">
                        <xsl:variable name ="schemeColor" select ="a:pPr/a:buClr/a:schemeClr/@val"/>
                        <xsl:variable name ="levelColor" >
                          <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle">
                            <xsl:call-template name ="getColorMap">
                              <xsl:with-param name ="schemeColor" select ="$schemeColor"/>
                            </xsl:call-template>
                          </xsl:for-each >
                        </xsl:variable>
                        <!--added by chhavi for conformance-->
                        <xsl:if test="$levelColor !=''">
                          <xsl:attribute name ="fo:color">
                        <xsl:call-template name ="getColorCode">
                          <xsl:with-param name ="color">
                            <xsl:value-of select="$levelColor"/>
                          </xsl:with-param>
                        </xsl:call-template >
                          </xsl:attribute>
                        </xsl:if>
                     
                      </xsl:if>
										</xsl:if>
										<!-- Code added by vijayeta, bug fix 1746350-->
										<xsl:if test ="not(a:pPr/a:buClr)">
											<!-- Vijayeta,Custom Bullet Colour-->
											<xsl:if test ="$textColor !='0'">
												<xsl:attribute name ="fo:color">
													<xsl:value-of select ="$textColor"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test ="$textColor='0'">
												<xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle">
													<xsl:variable name ="levelColor" >
														<xsl:call-template name ="getLevelColor">
															<xsl:with-param name ="levelNum" select ="'1'"/>
                              <xsl:with-param name ="textColor" select="$textColor" />
														</xsl:call-template>
													</xsl:variable>
                          <xsl:if test="$levelColor !=''">
													<xsl:attribute name ="fo:color">
														<xsl:value-of select ="$levelColor"/>
													</xsl:attribute>
                          </xsl:if>
												</xsl:for-each>
											</xsl:if>
											<!-- Vijayeta,Custom Bullet Colour-->

										</xsl:if>
										<!--End of Code added by vijayeta, bug fix 1746350-->
									</style:text-properties>
								</text:list-level-style-number>
							</text:list-style>
						</xsl:when>
            <xsl:when test ="a:pPr/a:buBlip">
              <xsl:variable name ="rId" select ="a:pPr/a:buBlip/a:blip/@r:embed"/>
              <xsl:variable name="XlinkHref">
                <xsl:variable name="pzipsource">
                  <xsl:value-of select="key('Part', $slideRel)//rels:Relationships/rels:Relationship[@Id=$rId]/@Target"/>
                </xsl:variable>
                <xsl:value-of select="concat('Pictures/', substring-after($pzipsource,'../media/'))"/>
              </xsl:variable>
              <xsl:call-template name="copyPictures">
                <xsl:with-param name="document">
                  <xsl:value-of select="$slideRel"/>
                </xsl:with-param>
                <xsl:with-param name="rId">
                  <xsl:value-of select ="$rId"/>
                </xsl:with-param>
              </xsl:call-template>
              <text:list-style>
                <xsl:attribute name ="style:name">
                  <xsl:value-of select ="$levelStyle"/>
                </xsl:attribute >
                <text:list-level-style-image text:level="1" xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad">
                  <xsl:attribute name="xlink:href">
                    <xsl:value-of select="$XlinkHref"/>
                  </xsl:attribute>
                  <style:list-level-properties style:vertical-pos="middle" style:vertical-rel="line" fo:width="0.318cm" fo:height="0.318cm" />
                </text:list-level-style-image>
              </text:list-style>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$slideLayout))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph">
                <xsl:if test ="./@idx=$var_index">
                  <xsl:if test="not(./@type) or ./@type='body'">
                    <xsl:call-template name ="getBulletForLevelsLayout">
                      <xsl:with-param name ="slideMaster" select ="$slideMaster"/>
                      <xsl:with-param name ="slideLayout" select ="$slideLayout"/>
                      <xsl:with-param name ="newTextLvl" select ="'1'"/>
                      <xsl:with-param name ="levelStyle" select ="$levelStyle"/>
                      <xsl:with-param name ="textColor" select ="$textColor"/>
						<xsl:with-param name ="buSize" select ="$buSize"/>
						<xsl:with-param name="textFont" select="$textFont"/>
                    </xsl:call-template>
                  </xsl:if>
                </xsl:if>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
          <!-- Addded by vijayeta on 18th june,to check for buNone-->
        </xsl:if >
        <!-- Addded by vijayeta on 18th june,to check for buNone-->
      </xsl:for-each>
    </xsl:if>
    <!--End  of Condition if levels are not present-->
     </xsl:template>
  <xsl:template name="tmpBulletFont">
    <xsl:if test ="a:pPr/a:buFont/@typeface">
      <xsl:choose>
        <xsl:when test ="a:pPr/a:buFont[@typeface='Arial'] and a:pPr/a:buChar/@char='۩' ">
          <xsl:attribute name ="fo:font-family">
            <xsl:value-of select ="'Arial'"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test ="a:pPr/a:buFont[@typeface='Arial']">
          <xsl:attribute name ="fo:font-family">
            <xsl:value-of select ="'StarSymbol'"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test ="not(a:pPr/a:buFont[@typeface='Arial'])">
          <xsl:attribute name ="fo:font-family">
            <xsl:value-of select ="a:pPr/a:buFont/@typeface"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
     </xsl:template>
    <xsl:template name ="insertDefaultBulletNumberStyle">
    <xsl:param name ="listStyleName"/>
    <xsl:param name ="slideLayout" />
    <xsl:param name ="slideMaster" />
    <xsl:param name ="var_TextBoxType"/>
    <xsl:param name ="var_index"/>
	
    <xsl:if test ="./a:p/a:pPr">
      <!--fix for bug 1794590-->
      <xsl:choose>
      <xsl:when test ="./a:p/a:pPr/@lvl">
        <xsl:for-each select ="./a:p">
			<xsl:variable name="buSize">
				<xsl:value-of  select="a:pPr/a:buSzPct/@val"/>
			</xsl:variable>
          <xsl:variable name ="position" select ="position()"/>
          <xsl:if test ="not(a:pPr/a:buNone)">
            <!--Condition if levels are present,and bullets are default-->
            <xsl:choose>              
							<xsl:when test ="./child::node()[1]= a:pPr">
								<xsl:if test ="./a:pPr/@lvl and ./a:pPr/@lvl !='0'">
									<xsl:variable name ="textLevel" select ="./a:pPr/@lvl"/>
									<!--<xsl:if test ="not(./a:pPr/a:buNone)">-->
									<xsl:variable name ="levelStyle">
										<xsl:value-of select ="concat($listStyleName,$position,'lvl',$textLevel)"/>
									</xsl:variable>
									<xsl:variable name ="newTextLvl" select ="$textLevel+1"/>
									<xsl:variable name ="textColor">
										<xsl:for-each select ="a:r">
											<xsl:if test ="position()= '1'">
												<xsl:if test ="a:rPr">
													<xsl:if test ="./a:rPr/a:solidFill">
														<xsl:if test ="./a:rPr/a:solidFill/a:srgbClr">
															<xsl:value-of select ="concat('#',./a:rPr/a:solidFill/a:srgbClr/@val)"/>
														</xsl:if>
														<xsl:if test ="./a:rPr/a:solidFill/a:schemeClr">
															<xsl:call-template name ="getColorCode">
																<xsl:with-param name ="color">
																	<xsl:value-of select="./a:rPr/a:solidFill/a:schemeClr/@val"/>
																</xsl:with-param>
															</xsl:call-template >
														</xsl:if>
													</xsl:if>
													<xsl:if test ="not(./a:rPr/a:solidFill)">
														<xsl:value-of select ="'0'"/>
													</xsl:if>
												</xsl:if>
												<xsl:if test ="not(./a:rPr)">
													<xsl:value-of select ="'0'"/>
												</xsl:if>
											</xsl:if >
										</xsl:for-each>
									</xsl:variable>
									<!--variable added textFont : by yeswanth-->
									<xsl:variable name="textFont">
										<xsl:if test ="./a:r/a:rPr">
											<xsl:choose>
												<xsl:when test="./a:r[1]/a:rPr/a:latin/@typeface">
													<xsl:value-of select="./a:r[1]/a:rPr/a:latin/@typeface"/>
												</xsl:when>
												<xsl:when test="./a:r[1]/a:rPr/a:ea/@typeface">
													<xsl:value-of select="./a:r[1]/a:rPr/a:ea/@typeface"/>
												</xsl:when>
												<xsl:when test="./a:r[1]/a:rPr/a:cs/@typeface">
													<xsl:value-of select="./a:r[1]/a:rPr/a:cs/@typeface"/>
												</xsl:when>
												<xsl:otherwise>
													<!--<xsl:value-of select="$slideLayout"/>-->
													<xsl:call-template name="textFontLayout">
															<xsl:with-param name="slideLayout" select="$slideLayout"/>
															<xsl:with-param name="idx" select="./parent::node()/parent::node()/p:nvSpPr/p:nvPr/p:ph/@idx"/>
															<xsl:with-param name="slideMaster" select="$slideMaster"/>
														    <xsl:with-param name="level" select="$textLevel"/>
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
									</xsl:variable>
									<!--end of code : by yeswanth-->
									<!-- Check if layout define bullets-->
									<xsl:variable name ="nodeName">
										<xsl:value-of select ="concat('a:lvl',$newTextLvl,'pPr')"/>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="../a:lstStyle/child::node()[name()=$nodeName][a:buChar | a:buAutoNum | a:buBlip]">
											<xsl:for-each select ="../a:lstStyle/child::node()[name()=$nodeName]">
												<xsl:if test ="a:buChar">
													<text:list-style>
														<xsl:attribute name ="style:name">
															<xsl:value-of select ="$levelStyle"/>
														</xsl:attribute >
														<text:list-level-style-bullet>
															<xsl:attribute name ="text:level">
																<xsl:value-of select ="$newTextLvl"/>
															</xsl:attribute >
															<xsl:attribute name ="text:bullet-char">
																<xsl:call-template name ="insertBulletCharacter">
																	<xsl:with-param name ="character" select ="a:buChar/@char" />
																</xsl:call-template>
															</xsl:attribute >
															<style:list-level-properties>
																<xsl:if test ="./@indent">
																	<xsl:choose>
																		<xsl:when test="./@indent &lt; 0">
																			<xsl:attribute name ="text:min-label-width">
																				<xsl:value-of select="concat(format-number((0 - ./@indent) div 360000, '#.##'), 'cm')"/>
																			</xsl:attribute>
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:attribute name ="text:min-label-width">
																				<xsl:value-of select="concat(format-number(./@indent div 360000, '#.##'), 'cm')"/>
																			</xsl:attribute>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:if >
																<xsl:if test ="./@marL">
																	<xsl:attribute name ="text:space-before">
																		<xsl:value-of select="concat((./@marL + ./@indent) div 360000, 'cm')"/>
																	</xsl:attribute>
																</xsl:if>
															</style:list-level-properties>
															<style:text-properties style:font-charset="x-symbol">
																<!--code added by yeswanth.s for bug#2019519 , 17 July 2008-->
																<xsl:attribute name="fo:font-family">
																	<xsl:choose>
																		<xsl:when test="./a:buFont/@typeface">
																			<xsl:value-of select="./a:buFont/@typeface"/>
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:value-of select="$textFont"/>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:attribute>
																<!--end of code added by yeswanth.s-->

																<xsl:choose>
																	<xsl:when test="$buSize !=''">
																		<xsl:attribute name ="fo:font-size">
																			<xsl:value-of select ="concat(( $buSize div 1000),'%')"/>
																		</xsl:attribute>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:if test ="a:buSzPct">
																			<xsl:attribute name ="fo:font-size">
																				<xsl:value-of select ="concat((a:buSzPct/@val div 1000),'%')"/>
																			</xsl:attribute>
																		</xsl:if>
																		<xsl:if test ="not(a:buSzPct)">
																			<xsl:attribute name ="fo:font-size">
																				<xsl:value-of select ="'100%'"/>
																			</xsl:attribute>
																		</xsl:if>
																	</xsl:otherwise>
																</xsl:choose>

																<xsl:if test ="a:buClr">
																	<xsl:if test ="a:buClr/a:srgbClr">
																		<xsl:variable name ="color" select ="a:buClr/a:srgbClr/@val"/>
																		<xsl:attribute name ="fo:color">
																			<xsl:value-of select ="concat('#',$color)"/>
																		</xsl:attribute>
																	</xsl:if>
																	<xsl:if test ="a:buClr/a:schemeClr">
																		<xsl:variable name ="clrMap">
																			<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:clrMap">
																				<xsl:call-template name ="getColorMapSM">
																					<xsl:with-param name ="schemeClr" select="./a:buClr/a:schemeClr/@val"/>
																				</xsl:call-template>
																			</xsl:if>
																			<xsl:if test ="not(./parent::node()/parent::node()/parent::node()/p:clrMap)">
																				<xsl:value-of select="./a:buClr/a:schemeClr/@val"/>
																			</xsl:if>
																		</xsl:variable>
																		<xsl:attribute name ="fo:color">
																			<xsl:call-template name ="getColorCode">
																				<xsl:with-param name ="color">
																					<xsl:value-of select="$clrMap"/>
																				</xsl:with-param>
																			</xsl:call-template >
																		</xsl:attribute>
																	</xsl:if>
																</xsl:if>
																<xsl:if test ="not(a:buClr)">
																	<xsl:if test ="$textColor != '0'">
																		<xsl:attribute name ="fo:color">
																			<xsl:value-of select ="$textColor"/>
																		</xsl:attribute>
																	</xsl:if>
																	<xsl:if test ="$textColor = '0'">
																		<xsl:if test ="./a:defRPr/a:solidFill">
																			<xsl:if test ="./a:defRPr/a:solidFill/a:srgbClr">
																				<xsl:attribute name ="fo:color">
																					<xsl:value-of select ="concat('#',./a:defRPr/a:solidFill/a:srgbClr/@val)"/>
																				</xsl:attribute>
																			</xsl:if>
																			<xsl:if test ="./a:defRPr/a:solidFill/a:schemeClr">
																				<xsl:variable name ="clrMap">
																					<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:clrMap">
																						<xsl:call-template name ="getColorMapSM">
																							<xsl:with-param name ="schemeClr" select="./a:defRPr/a:solidFill/a:schemeClr/@val"/>
																						</xsl:call-template>
																					</xsl:if>
																					<xsl:if test ="not(./parent::node()/parent::node()/parent::node()/p:clrMap)">
																						<xsl:value-of select="./a:defRPr/a:solidFill/a:schemeClr/@val"/>
																					</xsl:if>
																				</xsl:variable>
																				<xsl:attribute name ="fo:color">
																					<xsl:call-template name ="getColorCode">
																						<xsl:with-param name ="color">
																							<xsl:value-of select="$clrMap"/>
																						</xsl:with-param>
																					</xsl:call-template >
																				</xsl:attribute>
																			</xsl:if>
																		</xsl:if>
																	</xsl:if>
																</xsl:if>
															</style:text-properties >
														</text:list-level-style-bullet>
													</text:list-style>
												</xsl:if>
												<xsl:if test ="a:buAutoNum">
													<text:list-style>
														<xsl:attribute name ="style:name">
															<xsl:value-of select ="$levelStyle"/>
														</xsl:attribute >
														<text:list-level-style-number>
															<xsl:attribute name ="text:level">
																<xsl:value-of select ="$newTextLvl"/>
															</xsl:attribute >
															<xsl:variable name ="startAt">
																<xsl:if test ="a:buAutoNum/@startAt">
																	<xsl:value-of select ="a:buAutoNum/@startAt" />
																</xsl:if>
																<xsl:if test ="not(a:buAutoNum/@startAt)">
																	<xsl:value-of select ="'1'" />
																</xsl:if>
															</xsl:variable>
															<xsl:call-template name ="insertNumber">
																<xsl:with-param name ="number" select ="a:buAutoNum/@type"/>
																<xsl:with-param name ="startAt" select ="$startAt"/>
															</xsl:call-template>
															<style:list-level-properties>
																<xsl:if test ="./@indent">
																	<xsl:choose>
																		<xsl:when test="./@indent &lt; 0">
																			<xsl:attribute name ="text:min-label-width">
																				<xsl:value-of select="concat(format-number((0 - ./@indent) div 360000, '#.##'), 'cm')"/>
																			</xsl:attribute>
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:attribute name ="text:min-label-width">
																				<xsl:value-of select="concat(format-number(./@indent div 360000, '#.##'), 'cm')"/>
																			</xsl:attribute>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:if >
																<xsl:if test ="./@marL">
																	<xsl:attribute name ="text:space-before">
																		<xsl:value-of select="concat(format-number( (./@marL + ./@indent) div 360000, '#.##'), 'cm')"/>
																	</xsl:attribute>
																</xsl:if>
															</style:list-level-properties>
															<style:text-properties style:font-family-generic="swiss" style:font-pitch="variable" fo:font-size="100%">
																<xsl:if test ="a:buFont/@typeface">
																	<xsl:attribute name ="fo:font-family">
																		<xsl:value-of select ="a:buFont/@typeface"/>
																	</xsl:attribute>
																</xsl:if>
																<xsl:if test ="not(a:buFont/@typeface)">
																	<xsl:attribute name ="fo:font-family">
																		<xsl:value-of select ="'Arial'"/>
																	</xsl:attribute>
																</xsl:if>
																<xsl:if test ="a:buSzPct">
																	<xsl:attribute name ="fo:font-size">
																		<xsl:value-of select ="concat((a:buSzPct/@val div 1000),'%')"/>
																	</xsl:attribute>
																</xsl:if>
																<xsl:if test ="not(a:buSzPct)">
																	<xsl:attribute name ="fo:font-size">
																		<xsl:value-of select ="'100%'"/>
																	</xsl:attribute>
																</xsl:if>
																<xsl:if test ="a:buClr">
																	<xsl:if test ="a:buClr/a:srgbClr">
																		<xsl:variable name ="color" select ="a:buClr/a:srgbClr/@val"/>
																		<xsl:attribute name ="fo:color">
																			<xsl:value-of select ="concat('#',$color)"/>
																		</xsl:attribute>
																	</xsl:if>
																	<xsl:if test ="a:buClr/a:schemeClr">
																		<xsl:variable name ="clrMap">
																			<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:clrMap">
																				<xsl:call-template name ="getColorMapSM">
																					<xsl:with-param name ="schemeClr" select="./a:buClr/a:schemeClr/@val"/>
																				</xsl:call-template>
																			</xsl:if>
																			<xsl:if test ="not(./parent::node()/parent::node()/parent::node()/p:clrMap)">
																				<xsl:value-of select="./a:buClr/a:schemeClr/@val"/>
																			</xsl:if>
																		</xsl:variable>
																		<xsl:attribute name ="fo:color">
																			<xsl:call-template name ="getColorCode">
																				<xsl:with-param name ="color">
																					<xsl:value-of select="$clrMap"/>
																				</xsl:with-param>
																			</xsl:call-template >
																		</xsl:attribute>
																	</xsl:if>
																</xsl:if>
																<xsl:if test ="not(a:buClr)">
																	<xsl:if test ="$textColor != '0'">
																		<xsl:attribute name ="fo:color">
																			<xsl:value-of select ="$textColor"/>
																		</xsl:attribute>
																	</xsl:if>
																	<xsl:if test ="$textColor = '0'">
																		<xsl:if test ="./a:defRPr/a:solidFill">
																			<xsl:if test ="./a:defRPr/a:solidFill/a:srgbClr">
																				<xsl:attribute name ="fo:color">
																					<xsl:value-of select ="concat('#',./a:defRPr/a:solidFill/a:srgbClr/@val)"/>
																				</xsl:attribute>
																			</xsl:if>
																			<xsl:if test ="./a:defRPr/a:solidFill/a:schemeClr">
																				<xsl:variable name ="clrMap">
																					<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:clrMap">
																						<xsl:call-template name ="getColorMapSM">
																							<xsl:with-param name ="schemeClr" select="./a:defRPr/a:solidFill/a:schemeClr/@val"/>
																						</xsl:call-template>
																					</xsl:if>
																					<xsl:if test ="not(./parent::node()/parent::node()/parent::node()/p:clrMap)">
																						<xsl:value-of select="./a:defRPr/a:solidFill/a:schemeClr/@val"/>
																					</xsl:if>
																				</xsl:variable>
																				<xsl:attribute name ="fo:color">
																					<xsl:call-template name ="getColorCode">
																						<xsl:with-param name ="color">
																							<xsl:value-of select="$clrMap"/>
																						</xsl:with-param>
																					</xsl:call-template >
																				</xsl:attribute>
																			</xsl:if>
																		</xsl:if>
																	</xsl:if>
																</xsl:if>
															</style:text-properties>
														</text:list-level-style-number>
													</text:list-style>
												</xsl:if>
												<xsl:if test ="a:buBlip">
													<xsl:variable name ="rId" select ="a:buBlip/a:blip/@r:embed"/>
													<xsl:variable name="XlinkHref">
														<xsl:variable name="pzipsource">
															<xsl:value-of select="key('Part', concat('ppt/slideMasters/_rels/',$slideMaster,'.rels'))//rels:Relationships/rels:Relationship[@Id=$rId]/@Target"/>
														</xsl:variable>
														<xsl:value-of select="concat('Pictures/', substring-after($pzipsource,'../media/'))"/>
													</xsl:variable>
													<xsl:call-template name="copyPictures">
														<xsl:with-param name="document">
															<xsl:value-of select="concat('ppt/slideMasters/_rels/',$slideMaster,'.rels')"/>
														</xsl:with-param>
														<xsl:with-param name="rId">
															<xsl:value-of select ="$rId"/>
														</xsl:with-param>
													</xsl:call-template>
													<text:list-style>
														<xsl:attribute name ="style:name">
															<xsl:value-of select ="$levelStyle"/>
														</xsl:attribute >
														<text:list-level-style-image xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad">
															<xsl:attribute name="text:level">
																<xsl:value-of select="$newTextLvl"/>
															</xsl:attribute>
															<xsl:attribute name="xlink:href">
																<xsl:value-of select="$XlinkHref"/>
															</xsl:attribute>
															<style:list-level-properties style:vertical-pos="middle" style:vertical-rel="line" fo:width="0.636cm" fo:height="0.636cm"/>
														</text:list-level-style-image>
													</text:list-style>
												</xsl:if>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
                  <xsl:variable name ="loop">
                    <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$slideLayout))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph">
                      <xsl:if test ="./@idx">
                        <xsl:value-of select ="'1'"/>                        
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:variable>
                  <xsl:if test ="contains($loop,'1')">
									<xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$slideLayout))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph">
										<xsl:if test ="./@idx=$var_index">
											<!--<xsl:if test="not(./@type) or ./@type='body'">-->
												<!--<xsl:value-of select ="'1'"/>-->
												<xsl:call-template name ="getBulletForLevelsLayout">
													<xsl:with-param name ="slideMaster" select ="$slideMaster"/>
                          <xsl:with-param name ="slideLayout" select ="$slideLayout"/>
													<xsl:with-param name ="newTextLvl" select ="$newTextLvl"/>
													<xsl:with-param name ="levelStyle" select ="$levelStyle"/>
													<xsl:with-param name ="textColor" select ="$textColor"/>
										<xsl:with-param name ="buSize" select ="$buSize"/>
										<xsl:with-param name ="textFont" select ="$textFont"/>
												</xsl:call-template>
											<!--</xsl:if>-->
										</xsl:if>
									</xsl:for-each>
                  </xsl:if>
                  <xsl:if test ="not(contains($loop,'1'))">
                    <xsl:call-template name ="getBulletsFromSlideMaster">
                      <xsl:with-param name ="slideMaster" select ="$slideMaster"/>
                      <xsl:with-param name ="newTextLvl" select ="$newTextLvl" />
                      <xsl:with-param name ="levelStyle" select ="$levelStyle"/>
                      <xsl:with-param name ="textColor" select ="$textColor"/>
					        <xsl:with-param name ="buSize" select ="$buSize"/>
							<xsl:with-param name ="textFont" select ="$textFont"/>
                    </xsl:call-template>
                  </xsl:if>
										</xsl:otherwise>
									</xsl:choose> 
                  <!-- Check if layout define bullets-->
									<!--</xsl:if>-->
								</xsl:if>
								<!-- Fix by vijayeta,on 22nd june,bug number1739817,also test if explicit lvl=0-->
								<xsl:if test ="not(./a:pPr/@lvl) or ./a:pPr/@lvl='0'">
									<xsl:if test ="not(./a:pPr/a:buNone)">
										<xsl:variable name ="textColor">
											<xsl:for-each select ="a:r">
												<xsl:if test ="position()= '1'">
													<xsl:if test ="a:rPr">
														<xsl:if test ="./a:rPr/a:solidFill">
															<xsl:if test ="./a:rPr/a:solidFill/a:srgbClr">
																<xsl:value-of select ="concat('#',./a:rPr/a:solidFill/a:srgbClr/@val)"/>
															</xsl:if>
															<xsl:if test ="./a:rPr/a:solidFill/a:schemeClr">
																<xsl:call-template name ="getColorCode">
																	<xsl:with-param name ="color">
																		<xsl:value-of select="./a:rPr/a:solidFill/a:schemeClr/@val"/>
																	</xsl:with-param>
																</xsl:call-template >
															</xsl:if>
														</xsl:if>
														<xsl:if test ="not(./a:rPr/a:solidFill)">
															<xsl:value-of select ="'0'"/>
														</xsl:if>
													</xsl:if>
													<xsl:if test ="not(./a:rPr)">
														<xsl:value-of select ="'0'"/>
													</xsl:if>
												</xsl:if >
											</xsl:for-each>
										</xsl:variable>
										<!--code added by  yeswanth : variable textFont-->
										<xsl:variable name="textFont">
											<xsl:if test ="./a:r/a:rPr">
												<xsl:choose>
													<xsl:when test="./a:r[1]/a:rPr/a:latin/@typeface">
														<xsl:value-of select="./a:r[1]/a:rPr/a:latin/@typeface"/>
													</xsl:when>
													<xsl:when test="./a:r[1]/a:rPr/a:ea/@typeface">
														<xsl:value-of select="./a:r[1]/a:rPr/a:ea/@typeface"/>
													</xsl:when>
													<xsl:when test="./a:r[1]/a:rPr/a:cs/@typeface">
														<xsl:value-of select="./a:r[1]/a:rPr/a:cs/@typeface"/>
													</xsl:when>
													<xsl:otherwise>
														<!--<xsl:value-of select="$slideLayout"/>-->
														<xsl:call-template name="textFontLayout">
															<xsl:with-param name="slideLayout" select="$slideLayout"/>
															<xsl:with-param name="idx" select="./parent::node()/parent::node()/p:nvSpPr/p:nvPr/p:ph/@idx"/>
															<xsl:with-param name="slideMaster" select="$slideMaster"/>
															<xsl:with-param name="level">
																<xsl:choose>
																	<xsl:when test="./a:r/a:rPr/@lvl and (./a:r/a:rPr/@lvl!='0')">
																		<xsl:value-of select="./a:r/a:rPr/@lvl"/>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="'0'"/>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:if>
										</xsl:variable>
										<!--end-->
										<xsl:variable name ="newTextLvl">
											<xsl:value-of select ="'1'"/>
										</xsl:variable>
										<xsl:variable name ="levelStyle">
											<xsl:value-of select ="concat($listStyleName,$position)"/>
										</xsl:variable>
                    <xsl:variable name ="loop">
                      <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$slideLayout))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph">
                        <xsl:if test ="./@idx">
                          <xsl:value-of select ="'1'"/>
                        </xsl:if>
                      </xsl:for-each>
                    </xsl:variable>
                    <xsl:if test ="contains($loop,'1')">
                      <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$slideLayout))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph">
                        <xsl:if test ="./@idx=$var_index">
                          <!--<xsl:if test="not(./@type) or ./@type='body'">-->
                          <!--<xsl:value-of select ="'1'"/>-->
                          <xsl:call-template name ="getBulletForLevelsLayout">
                            <xsl:with-param name ="slideMaster" select ="$slideMaster"/>
                            <xsl:with-param name ="slideLayout" select ="$slideLayout"/>
                            <xsl:with-param name ="newTextLvl" select ="$newTextLvl"/>
                            <xsl:with-param name ="levelStyle" select ="$levelStyle"/>
                            <xsl:with-param name ="textColor" select ="$textColor"/>
							  <xsl:with-param name ="buSize" select ="$buSize"/>
							  <xsl:with-param name ="textFont" select ="$textFont"/>
                          </xsl:call-template>
                          <!--</xsl:if>-->
                        </xsl:if>
                      </xsl:for-each>
                    </xsl:if>
                    <xsl:if test ="not(contains($loop,'1'))">
                      <xsl:call-template name ="getBulletsFromSlideMaster">
                        <xsl:with-param name ="slideMaster" select ="$slideMaster"/>
                        <xsl:with-param name ="newTextLvl" select ="$newTextLvl" />
                        <xsl:with-param name ="levelStyle" select ="$levelStyle"/>
                        <xsl:with-param name ="textColor" select ="$textColor"/>
					  <xsl:with-param name ="buSize" select ="$buSize"/>
					  <xsl:with-param name ="textFont" select ="$textFont"/>
                      </xsl:call-template>
                    </xsl:if>
									</xsl:if>
								</xsl:if>
							</xsl:when>
              <xsl:when test ="./child::node()[1] = a:r ">
                <xsl:variable name ="levelStyle" select =" concat($listStyleName,$position)"/>
                <xsl:variable name ="textColor">
                  <xsl:for-each select ="a:r">
                    <xsl:if test ="position()= '1'">
                      <xsl:if test ="a:rPr">
                        <xsl:if test ="./a:rPr/a:solidFill">
                          <xsl:if test ="./a:rPr/a:solidFill/a:srgbClr">
                            <xsl:value-of select ="concat('#',./a:rPr/a:solidFill/a:srgbClr/@val)"/>
                          </xsl:if>
                          <xsl:if test ="./a:rPr/a:solidFill/a:schemeClr">
                            <xsl:call-template name ="getColorCode">
                              <xsl:with-param name ="color">
                                <xsl:value-of select="./a:rPr/a:solidFill/a:schemeClr/@val"/>
                              </xsl:with-param>
                            </xsl:call-template >
                          </xsl:if>
                        </xsl:if>
                        <xsl:if test ="not(./a:rPr/a:solidFill)">
                          <xsl:value-of select ="'0'"/>
                        </xsl:if>
                      </xsl:if>
                      <xsl:if test ="not(./a:rPr)">
                        <xsl:value-of select ="'0'"/>
                      </xsl:if>
                    </xsl:if >
                  </xsl:for-each>
                </xsl:variable>
				  <!--code added by  yeswanth : variable textFont-->
				  <xsl:variable name="textFont">
					  <xsl:if test ="./a:r/a:rPr">
						  <xsl:choose>
							  <xsl:when test="./a:r[1]/a:rPr/a:latin/@typeface">
								  <xsl:value-of select="./a:r[1]/a:rPr/a:latin/@typeface"/>
							  </xsl:when>
							  <xsl:when test="./a:r[1]/a:rPr/a:ea/@typeface">
								  <xsl:value-of select="./a:r[1]/a:rPr/a:ea/@typeface"/>
							  </xsl:when>
							  <xsl:when test="./a:r[1]/a:rPr/a:cs/@typeface">
								  <xsl:value-of select="./a:r[1]/a:rPr/a:cs/@typeface"/>
							  </xsl:when>
							  <xsl:otherwise>
								  <!--<xsl:value-of select="$slideLayout"/>-->
								  <xsl:call-template name="textFontLayout">
									  <xsl:with-param name="slideLayout" select="$slideLayout"/>
									  <xsl:with-param name="idx" select="./parent::node()/parent::node()/p:nvSpPr/p:nvPr/p:ph/@idx"/>
									  <xsl:with-param name="slideMaster" select="$slideMaster"/>
									  <xsl:with-param name="level">
										  <xsl:choose>
											  <xsl:when test="./a:r/a:rPr/@lvl and (./a:r/a:rPr/@lvl!='0')">
												  <xsl:value-of select="./a:r/a:rPr/@lvl"/>
											  </xsl:when>
											  <xsl:otherwise>
												  <xsl:value-of select="'0'"/>
											  </xsl:otherwise>
										  </xsl:choose>
									  </xsl:with-param>
								  </xsl:call-template>
							  </xsl:otherwise>
						  </xsl:choose>
					  </xsl:if>					  
				  </xsl:variable>
				  <!--end-->
                <xsl:variable name ="loop">
                  <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$slideLayout))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph">
                    <xsl:if test ="./@idx">
                      <xsl:value-of select ="'1'"/>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:variable>
                <xsl:if test ="contains($loop,'1')">
                  <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$slideLayout))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph">
                    <xsl:if test ="./@idx=$var_index">
                      <!--<xsl:if test="not(./@type) or ./@type='body'">-->
                      <!--<xsl:value-of select ="'1'"/>-->
                      <xsl:call-template name ="getBulletForLevelsLayout">
                        <xsl:with-param name ="slideMaster" select ="$slideMaster"/>
                        <xsl:with-param name ="slideLayout" select ="$slideLayout"/>
                        <xsl:with-param name ="newTextLvl" select ="'1'"/>
                        <xsl:with-param name ="levelStyle" select ="$levelStyle"/>
                        <xsl:with-param name ="textColor" select ="$textColor"/>
						  <xsl:with-param name ="buSize" select ="$buSize"/>
						  <xsl:with-param name ="textFont" select ="$textFont"/>
                      </xsl:call-template>
                      <!--</xsl:if>-->
                    </xsl:if>
                  </xsl:for-each>
                </xsl:if>
                <xsl:if test ="not(contains($loop,'1'))">
                  <xsl:call-template name ="getBulletsFromSlideMaster">
                    <xsl:with-param name ="slideMaster" select ="$slideMaster"/>
                    <xsl:with-param name ="newTextLvl" select ="'1'" />
                    <xsl:with-param name ="levelStyle" select ="$levelStyle"/>
                    <xsl:with-param name ="textColor" select ="$textColor"/>
<xsl:with-param name ="buSize" select ="$buSize"/>
						  <xsl:with-param name ="textFont" select ="$textFont"/>
                  </xsl:call-template>
                </xsl:if>
              </xsl:when>
						</xsl:choose>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<!--Condition if levels are present,and bullets are default-->
			<!--<xsl:if test ="not(./a:pPr/@lvl)">-->
			<!-- Fix by vijayeta,on 22nd june,bug number1739817,also test if explicit lvl=0-->
			<xsl:when test ="not(./a:p/a:pPr/@lvl) or ./a:p/a:pPr/@lvl='0'">
				<xsl:for-each select ="./a:p">
					<xsl:variable name="buSize">
						<xsl:value-of  select="a:pPr/a:buSzPct/@val"/>
					</xsl:variable>
					<xsl:if test ="not(./a:pPr/a:buNone)">
						<xsl:variable name ="position" select ="position()"/>
						<xsl:variable name ="levelStyle" select =" concat($listStyleName,$position)"/>
						<xsl:variable name ="textColor">
							<xsl:for-each select ="a:r">
								<xsl:if test ="position()= '1'">
									<xsl:if test ="a:rPr">
										<xsl:if test ="./a:rPr/a:solidFill">
											<xsl:if test ="./a:rPr/a:solidFill/a:srgbClr">
												<xsl:value-of select ="concat('#',./a:rPr/a:solidFill/a:srgbClr/@val)"/>
											</xsl:if>
											<xsl:if test ="./a:rPr/a:solidFill/a:schemeClr">
												<xsl:call-template name ="getColorCode">
													<xsl:with-param name ="color">
														<xsl:value-of select="./a:rPr/a:solidFill/a:schemeClr/@val"/>
													</xsl:with-param>
												</xsl:call-template >
											</xsl:if>
										</xsl:if>
										<xsl:if test ="not(./a:rPr/a:solidFill)">
											<xsl:value-of select ="'0'"/>
										</xsl:if>
									</xsl:if>
									<xsl:if test ="not(./a:rPr)">
										<xsl:value-of select ="'0'"/>
									</xsl:if>
								</xsl:if >
							</xsl:for-each>
						</xsl:variable>
						<!--code added by  yeswanth : variable textFont-->
						<xsl:variable name="textFont">
							<xsl:if test ="./a:r/a:rPr">
								<xsl:choose>
									<xsl:when test="./a:r[1]/a:rPr/a:latin/@typeface">
										<xsl:value-of select="./a:r[1]/a:rPr/a:latin/@typeface"/>
									</xsl:when>
									<xsl:when test="./a:r[1]/a:rPr/a:ea/@typeface">
										<xsl:value-of select="./a:r[1]/a:rPr/a:ea/@typeface"/>
									</xsl:when>
									<xsl:when test="./a:r[1]/a:rPr/a:cs/@typeface">
										<xsl:value-of select="./a:r[1]/a:rPr/a:cs/@typeface"/>
									</xsl:when>
									<xsl:otherwise>
										<!--<xsl:value-of select="$slideLayout"/>-->
										<xsl:call-template name="textFontLayout">
								            <xsl:with-param name="slideLayout" select="$slideLayout"/>
								            <xsl:with-param name="idx" select="./parent::node()/parent::node()/p:nvSpPr/p:nvPr/p:ph/@idx"/>
								            <xsl:with-param name="slideMaster" select="$slideMaster"/>
											<xsl:with-param name="level">
												<xsl:choose>
													<xsl:when test="./a:r/a:rPr/@lvl and (./a:r/a:rPr/@lvl!='0')">
														<xsl:value-of select="./a:r/a:rPr/@lvl"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="'0'"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:with-param>
							            </xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</xsl:variable>
						<!--end-->
            <xsl:variable name ="loop">
              <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$slideLayout))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph[@idx and (not(@type) or @type='body')]/
			                         parent::node()/parent::node()/parent::node()/p:txBody/a:p/a:pPr/@lvl">
                  <xsl:value-of select ="'1'"/>
              </xsl:for-each>
            </xsl:variable>
            <xsl:if test ="contains($loop,'1')">
              <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$slideLayout))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph">
                <xsl:if test ="./@idx=$var_index">
                  <!--<xsl:if test="not(./@type) or ./@type='body'">-->
                  <!--<xsl:value-of select ="'1'"/>-->
                  <xsl:call-template name ="getBulletForLevelsLayout">
                    <xsl:with-param name ="slideMaster" select ="$slideMaster"/>
                    <xsl:with-param name ="slideLayout" select ="$slideLayout"/>
                    <xsl:with-param name ="newTextLvl" select ="'1'"/>
                    <xsl:with-param name ="levelStyle" select ="$levelStyle"/>
                    <xsl:with-param name ="textColor" select ="$textColor"/>
					  <xsl:with-param name ="buSize" select ="$buSize"/>
					  <xsl:with-param name ="textFont" select ="$textFont"/>
                  </xsl:call-template>
                  <!--</xsl:if>-->
                </xsl:if>
              </xsl:for-each>
            </xsl:if>
            <xsl:if test ="not(contains($loop,'1'))">
              <xsl:call-template name ="getBulletsFromSlideMaster">
                <xsl:with-param name ="slideMaster" select ="$slideMaster"/>
                <xsl:with-param name ="newTextLvl" select ="'1'" />
                <xsl:with-param name ="levelStyle" select ="$levelStyle"/>
                <xsl:with-param name ="textColor" select ="$textColor"/>
				  <xsl:with-param name ="buSize" select ="$buSize"/>
				  <xsl:with-param name ="textFont" select ="$textFont"/>
              </xsl:call-template>
            </xsl:if>
					</xsl:if>
				</xsl:for-each>
			</xsl:when >
      </xsl:choose>
		</xsl:if>
		<!--</xsl:if>-->
		<xsl:if test ="not(./a:p/a:pPr)">
			<xsl:for-each select ="./a:p">
				<xsl:variable name="buSize">
					<xsl:value-of  select="a:pPr/a:buSzPct/@val"/>
				</xsl:variable>
				<xsl:variable name ="newTextLvl">
					<xsl:if test ="a:pPr/@lvl">
						<xsl:value-of select ="a:pPr/@lvl"/>
					</xsl:if>
					<xsl:if test ="not(a:pPr)">
						<xsl:value-of select ="'0'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name ="position" select ="position()"/>
				<xsl:variable name ="levelStyle" select =" concat($listStyleName,$position)"/>
				<xsl:variable name ="textColor">
					<xsl:for-each select ="a:r">
						<xsl:if test ="position()= '1'">
							<xsl:if test ="a:rPr">
								<xsl:if test ="./a:rPr/a:solidFill">
									<xsl:if test ="./a:rPr/a:solidFill/a:srgbClr">
										<xsl:value-of select ="concat('#',./a:rPr/a:solidFill/a:srgbClr/@val)"/>
									</xsl:if>
									<xsl:if test ="./a:rPr/a:solidFill/a:schemeClr">
										<xsl:call-template name ="getColorCode">
											<xsl:with-param name ="color">
												<xsl:value-of select="./a:rPr/a:solidFill/a:schemeClr/@val"/>
											</xsl:with-param>
										</xsl:call-template >
									</xsl:if>
								</xsl:if>
								<xsl:if test ="not(./a:rPr/a:solidFill)">
									<xsl:value-of select ="'0'"/>
								</xsl:if>
							</xsl:if>
							<xsl:if test ="not(./a:rPr)">
								<xsl:value-of select ="'0'"/>
							</xsl:if>
						</xsl:if >
					</xsl:for-each>
				</xsl:variable>
				<!--code added by  yeswanth : variable textFont-->
				<xsl:variable name="textFont">
					<xsl:if test ="./a:r/a:rPr">
						<xsl:choose>
							<xsl:when test="./a:r[1]/a:rPr/a:latin/@typeface">
								<xsl:value-of select="./a:r[1]/a:rPr/a:latin/@typeface"/>
							</xsl:when>
							<xsl:when test="./a:r[1]/a:rPr/a:ea/@typeface">
								<xsl:value-of select="./a:r[1]/a:rPr/a:ea/@typeface"/>
							</xsl:when>
							<xsl:when test="./a:r[1]/a:rPr/a:cs/@typeface">
								<xsl:value-of select="./a:r[1]/a:rPr/a:cs/@typeface"/>
							</xsl:when>
							<xsl:otherwise>
								<!--<xsl:value-of select="$slideLayout"/>-->
								<xsl:call-template name="textFontLayout">
									<xsl:with-param name="slideLayout" select="$slideLayout"/>
									<xsl:with-param name="idx" select="./parent::node()/parent::node()/p:nvSpPr/p:nvPr/p:ph/@idx"/>
									<xsl:with-param name="slideMaster" select="$slideMaster"/>
									<xsl:with-param name="level">
										<xsl:choose>
											<xsl:when test="./a:r/a:rPr/@lvl and (./a:r/a:rPr/@lvl!='0')">
												<xsl:value-of select="./a:r/a:rPr/@lvl"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="'0'"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
							    </xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>					
				</xsl:variable>
				<!--end-->
        <xsl:variable name ="loop">
          <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$slideLayout))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph">
            <xsl:if test ="./@idx">
              <xsl:value-of select ="'1'"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:if test ="contains($loop,'1')">
          <xsl:for-each select ="key('Part', concat('ppt/slideLayouts/',$slideLayout))/p:sldLayout/p:cSld/p:spTree/p:sp/p:nvSpPr/p:nvPr/p:ph">
            <xsl:if test ="./@idx=$var_index">
              <!--<xsl:if test="not(./@type) or ./@type='body'">-->
              <!--<xsl:value-of select ="'1'"/>-->
              <xsl:call-template name ="getBulletForLevelsLayout">
                <xsl:with-param name ="slideMaster" select ="$slideMaster"/>
                <xsl:with-param name ="slideLayout" select ="$slideLayout"/>
                <xsl:with-param name ="newTextLvl" select ="'1'"/>
                <xsl:with-param name ="levelStyle" select ="$levelStyle"/>
                <xsl:with-param name ="textColor" select ="$textColor"/>
						   <xsl:with-param name ="buSize" select ="$buSize"/>
						   <xsl:with-param name ="textFont" select ="$textFont"/>
              </xsl:call-template>
              <!--</xsl:if>-->
            </xsl:if>
          </xsl:for-each>
        </xsl:if>
        <xsl:if test ="not(contains($loop,'1'))">
          <xsl:call-template name ="getBulletsFromSlideMaster">
            <xsl:with-param name ="slideMaster" select ="$slideMaster"/>
            <xsl:with-param name ="newTextLvl" select ="'1'" />
            <xsl:with-param name ="levelStyle" select ="$levelStyle"/>
            <xsl:with-param name ="textColor" select ="$textColor"/>
		  <xsl:with-param name ="buSize" select ="$buSize"/>
		  <xsl:with-param name ="textFont" select ="$textFont"/>
          </xsl:call-template>
        </xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<!-- Code By vijayeta,insertMultipleLevels in OdpFiles-->
	<xsl:template name ="insertMultipleLevels">
		<xsl:param name ="levelCount"/>
		<xsl:param name ="ParaId"/>
		<xsl:param name ="listStyleName"/>
		<xsl:param name ="sldRelId"/>
		<xsl:param name ="sldId"/>
		<xsl:param name ="TypeId"/>
		<xsl:param name ="textSpanNode"/>
		<xsl:choose>
			<xsl:when test ="$levelCount='1'">
				<text:list>
					<xsl:attribute name ="text:style-name">
						<xsl:value-of select ="concat($listStyleName,'lvl',$levelCount)"/>
					</xsl:attribute>
					<text:list-item>
						<text:list>
							<text:list-item>
								<xsl:copy-of select ="$textSpanNode"/>
							</text:list-item>
						</text:list>
					</text:list-item>
				</text:list>
			</xsl:when>
			<xsl:when test ="$levelCount='2'">
				<text:list>
					<xsl:attribute name ="text:style-name">
						<xsl:value-of select ="concat($listStyleName,'lvl',$levelCount)"/>
					</xsl:attribute>
					<text:list-item>
						<text:list>
							<text:list-item>
								<text:list>
									<text:list-item>
										<xsl:copy-of select ="$textSpanNode"/>
									</text:list-item>
								</text:list>
							</text:list-item>
						</text:list>
					</text:list-item>
				</text:list>
			</xsl:when>
			<xsl:when test ="$levelCount='3'">
				<text:list>
					<xsl:attribute name ="text:style-name">
						<xsl:value-of select ="concat($listStyleName,'lvl',$levelCount)"/>
					</xsl:attribute>
					<text:list-item>
						<text:list>
							<text:list-item>
								<text:list>
									<text:list-item>
										<text:list>
											<text:list-item>
												<xsl:copy-of select ="$textSpanNode"/>
											</text:list-item>
										</text:list>
									</text:list-item>
								</text:list>
							</text:list-item>
						</text:list>
					</text:list-item>
				</text:list>
			</xsl:when>
			<xsl:when test ="$levelCount='4'">
				<text:list>
					<xsl:attribute name ="text:style-name">
						<xsl:value-of select ="concat($listStyleName,'lvl',$levelCount)"/>
					</xsl:attribute>
					<text:list-item>
						<text:list>
							<text:list-item>
								<text:list>
									<text:list-item>
										<text:list>
											<text:list-item>
												<text:list>
													<text:list-item>
														<xsl:copy-of select ="$textSpanNode"/>
													</text:list-item>
												</text:list>
											</text:list-item>
										</text:list>
									</text:list-item>
								</text:list>
							</text:list-item>
						</text:list>
					</text:list-item>
				</text:list>
			</xsl:when>
			<xsl:when test ="$levelCount='5'">
				<text:list>
					<xsl:attribute name ="text:style-name">
						<xsl:value-of select ="concat($listStyleName,'lvl',$levelCount)"/>
					</xsl:attribute>
					<text:list-item>
						<text:list>
							<text:list-item>
								<text:list>
									<text:list-item>
										<text:list>
											<text:list-item>
												<text:list>
													<text:list-item>
														<text:list>
															<text:list-item>
																<xsl:copy-of select ="$textSpanNode"/>
															</text:list-item>
														</text:list>
													</text:list-item>
												</text:list>
											</text:list-item>
										</text:list>
									</text:list-item>
								</text:list>
							</text:list-item>
						</text:list>
					</text:list-item>
				</text:list>
			</xsl:when>
			<xsl:when test ="$levelCount='6'">
				<text:list>
					<xsl:attribute name ="text:style-name">
						<xsl:value-of select ="concat($listStyleName,'lvl',$levelCount)"/>
					</xsl:attribute>
					<text:list-item>
						<text:list>
							<text:list-item>
								<text:list>
									<text:list-item>
										<text:list>
											<text:list-item>
												<text:list>
													<text:list-item>
														<text:list>
															<text:list-item>
																<text:list>
																	<text:list-item>
																		<xsl:copy-of select ="$textSpanNode"/>
																	</text:list-item>
																</text:list>
															</text:list-item>
														</text:list>
													</text:list-item>
												</text:list>
											</text:list-item>
										</text:list>
									</text:list-item>
								</text:list>
							</text:list-item>
						</text:list>
					</text:list-item>
				</text:list>
			</xsl:when>
			<xsl:when test ="$levelCount='7'">
				<text:list>
					<xsl:attribute name ="text:style-name">
						<xsl:value-of select ="concat($listStyleName,'lvl',$levelCount)"/>
					</xsl:attribute>
					<text:list-item>
						<text:list>
							<text:list-item>
								<text:list>
									<text:list-item>
										<text:list>
											<text:list-item>
												<text:list>
													<text:list-item>
														<text:list>
															<text:list-item>
																<text:list>
																	<text:list-item>
																		<text:list>
																			<text:list-item>
																				<xsl:copy-of select ="$textSpanNode"/>
																			</text:list-item>
																		</text:list>
																	</text:list-item>
																</text:list>
															</text:list-item>
														</text:list>
													</text:list-item>
												</text:list>
											</text:list-item>
										</text:list>
									</text:list-item>
								</text:list>
							</text:list-item>
						</text:list>
					</text:list-item>
				</text:list>
			</xsl:when>
			<xsl:when test ="$levelCount='8'">
				<text:list>
					<xsl:attribute name ="text:style-name">
						<xsl:value-of select ="concat($listStyleName,'lvl',$levelCount)"/>
					</xsl:attribute>
					<text:list-item>
						<text:list>
							<text:list-item>
								<text:list>
									<text:list-item>
										<text:list>
											<text:list-item>
												<text:list>
													<text:list-item>
														<text:list>
															<text:list-item>
																<text:list>
																	<text:list-item>
																		<text:list>
																			<text:list-item>
																				<text:list>
																					<text:list-item>
																						<xsl:copy-of select ="$textSpanNode"/>
																					</text:list-item>
																				</text:list>
																			</text:list-item>
																		</text:list>
																	</text:list-item>
																</text:list>
															</text:list-item>
														</text:list>
													</text:list-item>
												</text:list>
											</text:list-item>
										</text:list>
									</text:list-item>
								</text:list>
							</text:list-item>
						</text:list>
					</text:list-item>
				</text:list>
			</xsl:when>
			<xsl:when test ="$levelCount='9'">
				<text:list>
					<xsl:attribute name ="text:style-name">
						<xsl:value-of select ="concat($listStyleName,'lvl',$levelCount)"/>
					</xsl:attribute>
					<text:list-item>
						<text:list>
							<text:list-item>
								<text:list>
									<text:list-item>
										<text:list>
											<text:list-item>
												<text:list>
													<text:list-item>
														<text:list>
															<text:list-item>
																<text:list>
																	<text:list-item>
																		<text:list>
																			<text:list-item>
																				<text:list>
																					<text:list-item>
																						<text:list>
																							<text:list-item>
																								<xsl:copy-of select ="$textSpanNode"/>
																							</text:list-item>
																						</text:list>
																					</text:list-item>
																				</text:list>
																			</text:list-item>
																		</text:list>
																	</text:list-item>
																</text:list>
															</text:list-item>
														</text:list>
													</text:list-item>
												</text:list>
											</text:list-item>
										</text:list>
									</text:list-item>
								</text:list>
							</text:list-item>
						</text:list>
					</text:list-item>
				</text:list>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="copyPictures">
		<xsl:param name="document"/>
		<xsl:param name="rId"/>
		<xsl:param name="targetName"/>
		<xsl:param name="destFolder" select="'Pictures'"/>
		<!--  Copy Pictures Files to the picture catalog -->
		<xsl:variable name="id">
			<xsl:choose>
				<xsl:when test="$rId != ''">
					<xsl:value-of select="$rId"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each
			  select="key('Part', $document)//rels:Relationships/rels:Relationship">
			<xsl:if test="./@Id=$id">
				<xsl:variable name="targetmode">
					<xsl:value-of select="./@TargetMode"/>
				</xsl:variable>
				<xsl:variable name="pzipsource">
					<xsl:value-of select="substring-after(./@Target,'../media/')"/>
					<!-- image1.gif-->
				</xsl:variable>
				<xsl:variable name="pziptarget">
					<xsl:choose>
						<xsl:when test="$targetName != ''">
							<xsl:value-of select="$targetName"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$pzipsource"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$targetmode='External'"/>
					<xsl:when test="$destFolder = '.'">
						<pzip:copy pzip:source="{concat('ppt/media/',$pzipsource)}" pzip:target="{$pziptarget}"/>
					</xsl:when>
					<xsl:otherwise>
						<pzip:copy pzip:source="{concat('ppt/media/',$pzipsource)}" pzip:target="{concat($destFolder,'/',$pzipsource)}"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>

	</xsl:template>
	<!-- level colour-->
	<xsl:template name ="getLevelColor">
		<xsl:param name ="levelNum"/>
		<xsl:param name ="textColor"/>
		<xsl:choose>
			<xsl:when test ="$levelNum='1'">
				<xsl:if test ="not(./a:lvl1pPr/a:buClr/a:srgbClr or a:lvl1pPr/a:buClr/a:schemeClr)">
					<xsl:if test ="$textColor != '0'">
						<xsl:value-of select ="$textColor"/>
					</xsl:if>
					<xsl:if test ="$textColor = '0'">
						<xsl:if test ="./a:lvl1pPr/a:defRPr/a:solidFill">
							<xsl:if test ="./a:lvl1pPr/a:defRPr/a:solidFill/a:srgbClr">
								<xsl:value-of select ="concat('#',./a:lvl1pPr/a:defRPr/a:solidFill/a:srgbClr/@val)"/>
							</xsl:if>
							<xsl:if test ="./a:lvl1pPr/a:defRPr/a:solidFill/a:schemeClr">
								<xsl:variable name ="clrMap">
									<xsl:if test ="./a:lvl1pPr/parent::node()/parent::node()/parent::node()/p:clrMap">
										<xsl:for-each select ="./a:lvl1pPr/parent::node()/parent::node()/parent::node()/p:clrMap">
											<xsl:call-template name ="getColorMap">
												<xsl:with-param name ="schemeClr" select="./a:lvl1pPr/a:defRPr/a:solidFill/a:schemeClr/@val"/>
											</xsl:call-template>
										</xsl:for-each>
									</xsl:if>
									<xsl:if test ="not(./a:lvl1pPr/parent::node()/parent::node()/parent::node()/p:clrMap)">
										<xsl:value-of select="./a:lvl1pPr/a:defRPr/a:solidFill/a:schemeClr/@val"/>
									</xsl:if>
								</xsl:variable>
								<xsl:call-template name ="getColorCode">
									<xsl:with-param name ="color">
										<xsl:value-of select="$clrMap"/>
									</xsl:with-param>
								</xsl:call-template >
							</xsl:if>
						</xsl:if>
					</xsl:if>
				</xsl:if>
				<xsl:if test ="./a:lvl1pPr/a:buClr/a:srgbClr">
					<xsl:value-of select ="concat('#',a:lvl1pPr/a:buClr/a:srgbClr/@val)"/>
				</xsl:if>
				<xsl:if test ="./a:lvl1pPr/a:buClr/a:schemeClr">
					<xsl:variable name ="clrMap">
						<xsl:if test ="./parent::node()/parent::node()/p:clrMap">
							<xsl:call-template name ="getColorMap">
								<xsl:with-param name ="schemeClr" select="./a:lvl1pPr/a:buClr/a:schemeClr/@val"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test ="not(./parent::node()/parent::node()/p:clrMap)">
							<xsl:value-of select="a:lvl1pPr/a:buClr/a:schemeClr/@val"/>
						</xsl:if>
					</xsl:variable>
					<xsl:call-template name ="getColorCode">
						<xsl:with-param name ="color">
							<xsl:value-of select="$clrMap"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if >
			</xsl:when>
			<xsl:when test ="$levelNum='2'">
				<xsl:if test ="not(a:lvl2pPr/a:buClr/a:srgbClr or a:lvl2pPr/a:buClr/a:schemeClr)">
					<xsl:if test ="$textColor != '0'">
						<xsl:value-of select ="$textColor"/>
					</xsl:if>
					<xsl:if test ="$textColor = '0'">
						<xsl:if test ="./a:lvl2pPr/a:defRPr/a:solidFill">
							<xsl:if test ="./a:lvl2pPr/a:defRPr/a:solidFill/a:srgbClr">
								<xsl:value-of select ="concat('#',./a:lvl2pPr/a:defRPr/a:solidFill/a:srgbClr/@val)"/>
							</xsl:if>
							<xsl:if test ="./a:lvl2pPr/a:defRPr/a:solidFill/a:schemeClr">
								<xsl:variable name ="schemeColour">
									<xsl:value-of select="./a:lvl2pPr/a:defRPr/a:solidFill/a:schemeClr/@val"/>
								</xsl:variable>
								<xsl:variable name ="clrMap">
									<xsl:if test ="./a:lvl2pPr/parent::node()/parent::node()/parent::node()/p:clrMap">
										<xsl:for-each select ="./a:lvl1pPr/parent::node()/parent::node()/parent::node()/p:clrMap">
											<xsl:call-template name ="getColorMap">
												<xsl:with-param name ="schemeClr" select="$schemeColour"/>
											</xsl:call-template>
										</xsl:for-each >
									</xsl:if>
									<xsl:if test ="not(./a:lvl2pPr/parent::node()/parent::node()/parent::node()/p:clrMap)">
										<xsl:value-of select="./a:lvl2pPr/a:defRPr/a:solidFill/a:schemeClr/@val"/>
									</xsl:if>
								</xsl:variable>
								<xsl:call-template name ="getColorCode">
									<xsl:with-param name ="color">
										<xsl:value-of select="$clrMap"/>
									</xsl:with-param>
								</xsl:call-template >
							</xsl:if>
						</xsl:if>
					</xsl:if>
				</xsl:if>
				<xsl:if test ="a:lvl2pPr/a:buClr/a:srgbClr">
					<xsl:value-of select ="concat('#',a:lvl2pPr/a:buClr/a:srgbClr/@val)"/>
				</xsl:if>
				<xsl:if test ="a:lvl2pPr/a:buClr/a:schemeClr">
					<xsl:variable name ="schemeColour">
						<xsl:value-of select="./a:lvl2pPr/a:buClr/a:schemeClr/@val"/>
					</xsl:variable>
					<xsl:variable name ="clrMap">
						<xsl:if test ="./parent::node()/parent::node()/p:clrMap">
							<xsl:call-template name ="getColorMap">
								<xsl:with-param name ="schemeClr" select="$schemeColour"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test ="not(./parent::node()/parent::node()/p:clrMap)">
							<xsl:value-of select="a:lvl2pPr/a:buClr/a:schemeClr/@val"/>
						</xsl:if>
					</xsl:variable>
					<xsl:call-template name ="getColorCode">
						<xsl:with-param name ="color">
							<xsl:value-of select="$clrMap"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if >
			</xsl:when>
			<xsl:when test ="$levelNum='3'">
				<xsl:if test ="not(a:lvl3pPr/a:buClr/a:srgbClr or a:lvl3pPr/a:buClr/a:schemeClr)">
					<xsl:if test ="$textColor != '0'">
						<xsl:value-of select ="$textColor"/>
					</xsl:if>
					<xsl:if test ="$textColor = '0'">
						<xsl:if test ="./a:lvl3pPr/a:defRPr/a:solidFill">
							<xsl:if test ="./a:lvl3pPr/a:defRPr/a:solidFill/a:srgbClr">
								<xsl:value-of select ="concat('#',./a:lvl3pPr/a:defRPr/a:solidFill/a:srgbClr/@val)"/>
							</xsl:if>
							<xsl:if test ="./a:lvl3pPr/a:defRPr/a:solidFill/a:schemeClr">
								<xsl:variable name ="schemeColour">
									<xsl:value-of select="./a:lvl3pPr/a:defRPr/a:solidFill/a:schemeClr/@val"/>
								</xsl:variable>
								<xsl:variable name ="clrMap">
									<xsl:if test ="./a:lvl3pPr/parent::node()/parent::node()/parent::node()/p:clrMap">
										<xsl:for-each select ="./a:lvl1pPr/parent::node()/parent::node()/parent::node()/p:clrMap">
											<xsl:call-template name ="getColorMap">
												<xsl:with-param name ="schemeClr" select="$schemeColour"/>
											</xsl:call-template>
										</xsl:for-each >
									</xsl:if>
									<xsl:if test ="not(./a:lvl3pPr/parent::node()/parent::node()/parent::node()/p:clrMap)">
										<xsl:value-of select="./a:lvl3pPr/a:defRPr/a:solidFill/a:schemeClr/@val"/>
									</xsl:if>
								</xsl:variable>
								<xsl:call-template name ="getColorCode">
									<xsl:with-param name ="color">
										<xsl:value-of select="$clrMap"/>
									</xsl:with-param>
								</xsl:call-template >
							</xsl:if>
						</xsl:if>
					</xsl:if>
				</xsl:if>
				<xsl:if test ="a:lvl3pPr/a:buClr/a:srgbClr">
					<xsl:value-of select ="concat('#',a:lvl3pPr/a:buClr/a:srgbClr/@val)"/>
				</xsl:if>
				<xsl:if test ="a:lvl3pPr/a:buClr/a:schemeClr">
					<xsl:variable name ="schemeColour">
						<xsl:value-of select="./a:lvl3pPr/a:buClr/a:schemeClr/@val"/>
					</xsl:variable>
					<xsl:variable name ="clrMap">
						<xsl:if test ="./parent::node()/parent::node()/p:clrMap">
							<xsl:call-template name ="getColorMap">
								<xsl:with-param name ="schemeClr" select="$schemeColour"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test ="not(./parent::node()/parent::node()/p:clrMap)">
							<xsl:value-of select="a:lvl3pPr/a:buClr/a:schemeClr/@val"/>
						</xsl:if>
					</xsl:variable>
					<xsl:call-template name ="getColorCode">
						<xsl:with-param name ="color">
							<xsl:value-of select="$clrMap"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if >
			</xsl:when>
			<xsl:when test ="$levelNum='4'">
				<xsl:if test ="not(a:lvl4pPr/a:buClr/a:srgbClr or a:lvl4pPr/a:buClr/a:schemeClr)">
					<xsl:if test ="$textColor != '0'">
						<xsl:value-of select ="$textColor"/>
					</xsl:if>
					<xsl:if test ="$textColor = '0'">
						<xsl:if test ="./a:lvl4pPr/a:defRPr/a:solidFill">
							<xsl:if test ="./a:lvl4pPr/a:defRPr/a:solidFill/a:srgbClr">
								<xsl:value-of select ="concat('#',./a:lvl4pPr/a:defRPr/a:solidFill/a:srgbClr/@val)"/>
							</xsl:if>
							<xsl:if test ="./a:lvl4pPr/a:defRPr/a:solidFill/a:schemeClr">
								<xsl:variable name ="schemeColour">
									<xsl:value-of select="./a:lvl4pPr/a:defRPr/a:solidFill/a:schemeClr/@val"/>
								</xsl:variable>
								<xsl:variable name ="clrMap">
									<xsl:if test ="./a:lvl4pPr/parent::node()/parent::node()/parent::node()/p:clrMap">
										<xsl:for-each select ="./a:lvl1pPr/parent::node()/parent::node()/parent::node()/p:clrMap">
											<xsl:call-template name ="getColorMap">
												<xsl:with-param name ="schemeClr" select="$schemeColour"/>
											</xsl:call-template>
										</xsl:for-each >
									</xsl:if>
									<xsl:if test ="not(./a:lvl4pPr/parent::node()/parent::node()/parent::node()/p:clrMap)">
										<xsl:value-of select="./a:lvl4pPr/a:defRPr/a:solidFill/a:schemeClr/@val"/>
									</xsl:if>
								</xsl:variable>
								<xsl:call-template name ="getColorCode">
									<xsl:with-param name ="color">
										<xsl:value-of select="$clrMap"/>
									</xsl:with-param>
								</xsl:call-template >
							</xsl:if>
						</xsl:if>
					</xsl:if>
				</xsl:if>
				<xsl:if test ="a:lvl4pPr/a:buClr/a:srgbClr">
					<xsl:value-of select ="concat('#',a:lvl4pPr/a:buClr/a:srgbClr/@val)"/>
				</xsl:if>
				<xsl:if test ="a:lvl4pPr/a:buClr/a:schemeClr">
					<xsl:variable name ="schemeColour">
						<xsl:value-of select="./a:lvl4pPr/a:buClr/a:schemeClr/@val"/>
					</xsl:variable>
					<xsl:variable name ="clrMap">
						<xsl:if test ="./parent::node()/parent::node()/p:clrMap">
							<xsl:call-template name ="getColorMap">
								<xsl:with-param name ="schemeClr" select="$schemeColour"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test ="not(./parent::node()/parent::node()/p:clrMap)">
							<xsl:value-of select="a:lvl4pPr/a:buClr/a:schemeClr/@val"/>
						</xsl:if>
					</xsl:variable>
					<xsl:call-template name ="getColorCode">
						<xsl:with-param name ="color">
							<xsl:value-of select="$clrMap"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if >
			</xsl:when>
			<xsl:when test ="$levelNum='5'">
				<xsl:if test ="not(a:lvl5pPr/a:buClr/a:srgbClr or a:lvl5pPr/a:buClr/a:schemeClr)">
					<xsl:if test ="$textColor != '0'">
						<xsl:value-of select ="$textColor"/>
					</xsl:if>
					<xsl:if test ="$textColor = '0'">
						<xsl:if test ="./a:lvl5pPr/a:defRPr/a:solidFill">
							<xsl:if test ="./a:lvl5pPr/a:defRPr/a:solidFill/a:srgbClr">
								<xsl:value-of select ="concat('#',./a:lvl5pPr/a:defRPr/a:solidFill/a:srgbClr/@val)"/>
							</xsl:if>
							<xsl:if test ="./a:lvl5pPr/a:defRPr/a:solidFill/a:schemeClr">
								<xsl:variable name ="schemeColour">
									<xsl:value-of select="./a:lvl5pPr/a:defRPr/a:solidFill/a:schemeClr/@val"/>
								</xsl:variable>
								<xsl:variable name ="clrMap">
									<xsl:if test ="./a:lvl5pPr/parent::node()/parent::node()/parent::node()/p:clrMap">
										<xsl:for-each select ="./a:lvl1pPr/parent::node()/parent::node()/parent::node()/p:clrMap">
											<xsl:call-template name ="getColorMap">
												<xsl:with-param name ="schemeClr" select="$schemeColour"/>
											</xsl:call-template>
										</xsl:for-each >
									</xsl:if>
									<xsl:if test ="not(./a:lvl5pPr/parent::node()/parent::node()/parent::node()/p:clrMap)">
										<xsl:value-of select="./a:lvl5pPr/a:defRPr/a:solidFill/a:schemeClr/@val"/>
									</xsl:if>
								</xsl:variable>
								<xsl:call-template name ="getColorCode">
									<xsl:with-param name ="color">
										<xsl:value-of select="$clrMap"/>
									</xsl:with-param>
								</xsl:call-template >
							</xsl:if>
						</xsl:if>
					</xsl:if>
				</xsl:if>
				<xsl:if test ="a:lvl5pPr/a:buClr/a:srgbClr">
					<xsl:value-of select ="concat('#',a:lvl45pPr/a:buClr/a:srgbClr/@val)"/>
				</xsl:if>
				<xsl:if test ="a:lvl5pPr/a:buClr/a:schemeClr">
					<xsl:variable name ="schemeColour">
						<xsl:value-of select="./a:lvl5pPr/a:buClr/a:schemeClr/@val"/>
					</xsl:variable>
					<xsl:variable name ="clrMap">
						<xsl:if test ="./parent::node()/parent::node()/p:clrMap">
							<xsl:call-template name ="getColorMap">
								<xsl:with-param name ="schemeClr" select="$schemeColour"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test ="not(./parent::node()/parent::node()/p:clrMap)">
							<xsl:value-of select="a:lvl5pPr/a:buClr/a:schemeClr/@val"/>
						</xsl:if>
					</xsl:variable>
					<xsl:call-template name ="getColorCode">
						<xsl:with-param name ="color">
							<xsl:value-of select="$clrMap"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if >
			</xsl:when>
			<xsl:when test ="$levelNum='6'">
				<xsl:if test ="not(a:lvl6pPr/a:buClr/a:srgbClr or a:lvl6pPr/a:buClr/a:schemeClr)">
					<xsl:if test ="$textColor != '0'">
						<xsl:value-of select ="$textColor"/>
					</xsl:if>
					<xsl:if test ="$textColor = '0'">
						<xsl:if test ="./a:lvl6pPr/a:defRPr/a:solidFill">
							<xsl:if test ="./a:lvl6pPr/a:defRPr/a:solidFill/a:srgbClr">
								<xsl:value-of select ="concat('#',./a:lvl6pPr/a:defRPr/a:solidFill/a:srgbClr/@val)"/>
							</xsl:if>
							<xsl:if test ="./a:lvl6pPr/a:defRPr/a:solidFill/a:schemeClr">
								<xsl:variable name ="schemeColour">
									<xsl:value-of select="./a:lvl6pPr/a:defRPr/a:solidFill/a:schemeClr/@val"/>
								</xsl:variable>
								<xsl:variable name ="clrMap">
									<xsl:if test ="./a:lvl6pPr/parent::node()/parent::node()/parent::node()/p:clrMap">
										<xsl:for-each select ="./a:lvl1pPr/parent::node()/parent::node()/parent::node()/p:clrMap">
											<xsl:call-template name ="getColorMap">
												<xsl:with-param name ="schemeClr" select="$schemeColour"/>
											</xsl:call-template>
										</xsl:for-each >
									</xsl:if>
									<xsl:if test ="not(./a:lvl6pPr/parent::node()/parent::node()/parent::node()/p:clrMap)">
										<xsl:value-of select="./a:lvl6pPr/a:defRPr/a:solidFill/a:schemeClr/@val"/>
									</xsl:if>
								</xsl:variable>
								<xsl:call-template name ="getColorCode">
									<xsl:with-param name ="color">
										<xsl:value-of select="$clrMap"/>
									</xsl:with-param>
								</xsl:call-template >
							</xsl:if>
						</xsl:if>
					</xsl:if>
				</xsl:if>
				<xsl:if test ="a:lvl6pPr/a:buClr/a:srgbClr">
					<xsl:value-of select ="concat('#',a:lvl6pPr/a:buClr/a:srgbClr/@val)"/>
				</xsl:if>
				<xsl:if test ="a:lvl6pPr/a:buClr/a:schemeClr">
					<xsl:variable name ="schemeColour">
						<xsl:value-of select="./a:lvl6pPr/a:buClr/a:schemeClr/@val"/>
					</xsl:variable>
					<xsl:variable name ="clrMap">
						<xsl:if test ="./parent::node()/parent::node()/p:clrMap">
							<xsl:call-template name ="getColorMap">
								<xsl:with-param name ="schemeClr" select="$schemeColour"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test ="not(./parent::node()/parent::node()/p:clrMap)">
							<xsl:value-of select="a:lvl6pPr/a:buClr/a:schemeClr/@val"/>
						</xsl:if>
					</xsl:variable>
					<xsl:call-template name ="getColorCode">
						<xsl:with-param name ="color">
							<xsl:value-of select="$clrMap"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if >
			</xsl:when>
			<xsl:when test ="$levelNum='7'">
				<xsl:if test ="not(a:lvl7pPr/a:buClr/a:srgbClr or a:lvl7pPr/a:buClr/a:schemeClr)">
					<xsl:if test ="$textColor != '0'">
						<xsl:value-of select ="$textColor"/>
					</xsl:if>
					<xsl:if test ="$textColor = '0'">
						<xsl:if test ="./a:lvl7pPr/a:defRPr/a:solidFill">
							<xsl:if test ="./a:lvl7pPr/a:defRPr/a:solidFill/a:srgbClr">
								<xsl:value-of select ="concat('#',./a:lvl7pPr/a:defRPr/a:solidFill/a:srgbClr/@val)"/>
							</xsl:if>
							<xsl:if test ="./a:lvl7pPr/a:defRPr/a:solidFill/a:schemeClr">
								<xsl:variable name ="schemeColour">
									<xsl:value-of select="./a:lvl7pPr/a:defRPr/a:solidFill/a:schemeClr/@val"/>
								</xsl:variable>
								<xsl:variable name ="clrMap">
									<xsl:if test ="./a:lvl7pPr/parent::node()/parent::node()/parent::node()/p:clrMap">
										<xsl:for-each select ="./a:lvl1pPr/parent::node()/parent::node()/parent::node()/p:clrMap">
											<xsl:call-template name ="getColorMap">
												<xsl:with-param name ="schemeClr" select="$schemeColour"/>
											</xsl:call-template>
										</xsl:for-each >
									</xsl:if>
									<xsl:if test ="not(./a:lvl7pPr/parent::node()/parent::node()/parent::node()/p:clrMap)">
										<xsl:value-of select="./a:lvl7pPr/a:defRPr/a:solidFill/a:schemeClr/@val"/>
									</xsl:if>
								</xsl:variable>
								<xsl:call-template name ="getColorCode">
									<xsl:with-param name ="color">
										<xsl:value-of select="$clrMap"/>
									</xsl:with-param>
								</xsl:call-template >
							</xsl:if>
						</xsl:if>
					</xsl:if>
				</xsl:if>
				<xsl:if test ="a:lvl7pPr/a:buClr/a:srgbClr">
					<xsl:value-of select ="concat('#',a:lvl7pPr/a:buClr/a:srgbClr/@val)"/>
				</xsl:if>
				<xsl:if test ="a:lvl7pPr/a:buClr/a:schemeClr">
					<xsl:variable name ="schemeColour">
						<xsl:value-of select="./a:lvl7pPr/a:buClr/a:schemeClr/@val"/>
					</xsl:variable>
					<xsl:variable name ="clrMap">
						<xsl:if test ="./parent::node()/parent::node()/p:clrMap">

							<xsl:call-template name ="getColorMap">
								<xsl:with-param name ="schemeClr" select="$schemeColour"/>
							</xsl:call-template>

						</xsl:if>
						<xsl:if test ="not(./parent::node()/parent::node()/p:clrMap)">
							<xsl:value-of select="a:lvl7pPr/a:buClr/a:schemeClr/@val"/>
						</xsl:if>
					</xsl:variable>
					<xsl:call-template name ="getColorCode">
						<xsl:with-param name ="color">
							<xsl:value-of select="$clrMap"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if >
			</xsl:when>
			<xsl:when test ="$levelNum='8'">
				<xsl:if test ="not(a:lvl8pPr/a:buClr/a:srgbClr or a:lvl8pPr/a:buClr/a:schemeClr)">
					<xsl:if test ="$textColor != '0'">
						<xsl:value-of select ="$textColor"/>
					</xsl:if>
					<xsl:if test ="$textColor = '0'">
						<xsl:if test ="./a:lvl8pPr/a:defRPr/a:solidFill">
							<xsl:if test ="./a:lvl8pPr/a:defRPr/a:solidFill/a:srgbClr">
								<xsl:value-of select ="concat('#',./a:lvl8pPr/a:defRPr/a:solidFill/a:srgbClr/@val)"/>
							</xsl:if>
							<xsl:if test ="./a:lvl8pPr/a:defRPr/a:solidFill/a:schemeClr">
								<xsl:variable name ="schemeColour">
									<xsl:value-of select="./a:lvl8pPr/a:defRPr/a:solidFill/a:schemeClr/@val"/>
								</xsl:variable>
								<xsl:variable name ="clrMap">
									<xsl:if test ="./a:lvl8pPr/parent::node()/parent::node()/parent::node()/p:clrMap">
										<xsl:for-each select ="./a:lvl1pPr/parent::node()/parent::node()/parent::node()/p:clrMap">
											<xsl:call-template name ="getColorMap">
												<xsl:with-param name ="schemeClr" select="$schemeColour"/>
											</xsl:call-template>
										</xsl:for-each >
									</xsl:if>
									<xsl:if test ="not(./a:lvl8pPr/parent::node()/parent::node()/parent::node()/p:clrMap)">
										<xsl:value-of select="./a:lvl8pPr/a:defRPr/a:solidFill/a:schemeClr/@val"/>
									</xsl:if>
								</xsl:variable>
								<xsl:call-template name ="getColorCode">
									<xsl:with-param name ="color">
										<xsl:value-of select="$clrMap"/>
									</xsl:with-param>
								</xsl:call-template >
							</xsl:if>
						</xsl:if>
					</xsl:if>
				</xsl:if>
				<xsl:if test ="a:lvl8pPr/a:buClr/a:srgbClr">
					<xsl:value-of select ="concat('#',a:lvl8pPr/a:buClr/a:srgbClr/@val)"/>
				</xsl:if>
				<xsl:if test ="a:lvl8pPr/a:buClr/a:schemeClr">
					<xsl:variable name ="schemeColour">
						<xsl:value-of select="./a:lvl8pPr/a:buClr/a:schemeClr/@val"/>
					</xsl:variable>
					<xsl:variable name ="clrMap">
						<xsl:if test ="./parent::node()/parent::node()/p:clrMap">

							<xsl:call-template name ="getColorMap">
								<xsl:with-param name ="schemeClr" select="$schemeColour"/>
							</xsl:call-template>

						</xsl:if>
						<xsl:if test ="not(./parent::node()/parent::node()/p:clrMap)">
							<xsl:value-of select="a:lvl8pPr/a:buClr/a:schemeClr/@val"/>
						</xsl:if>
					</xsl:variable>
					<xsl:call-template name ="getColorCode">
						<xsl:with-param name ="color">
							<xsl:value-of select="$clrMap"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if >
			</xsl:when>
			<xsl:when test ="$levelNum='9'">
				<xsl:if test ="not(a:lvl9pPr/a:buClr/a:srgbClr or a:lvl9pPr/a:buClr/a:schemeClr)">
					<xsl:if test ="$textColor != '0'">
						<xsl:value-of select ="$textColor"/>
					</xsl:if>
					<xsl:if test ="$textColor = '0'">
						<xsl:if test ="./a:lvl9pPr/a:defRPr/a:solidFill">
							<xsl:if test ="./a:lvl9pPr/a:defRPr/a:solidFill/a:srgbClr">
								<xsl:value-of select ="concat('#',./a:lvl9pPr/a:defRPr/a:solidFill/a:srgbClr/@val)"/>
							</xsl:if>
							<xsl:if test ="./a:lvl9pPr/a:defRPr/a:solidFill/a:schemeClr">
								<xsl:variable name ="schemeColour">
									<xsl:value-of select="./a:lvl9pPr/a:defRPr/a:solidFill/a:schemeClr/@val"/>
								</xsl:variable>
								<xsl:variable name ="clrMap">
									<xsl:if test ="./a:lvl9pPr/parent::node()/parent::node()/parent::node()/p:clrMap">
										<xsl:for-each select ="./a:lvl1pPr/parent::node()/parent::node()/parent::node()/p:clrMap">
											<xsl:call-template name ="getColorMap">
												<xsl:with-param name ="schemeClr" select="$schemeColour"/>
											</xsl:call-template>
										</xsl:for-each >
									</xsl:if>
									<xsl:if test ="not(./a:lvl9pPr/parent::node()/parent::node()/parent::node()/p:clrMap)">
										<xsl:value-of select="./a:lvl9pPr/a:defRPr/a:solidFill/a:schemeClr/@val"/>
									</xsl:if>
								</xsl:variable>
								<xsl:call-template name ="getColorCode">
									<xsl:with-param name ="color">
										<xsl:value-of select="$clrMap"/>
									</xsl:with-param>
								</xsl:call-template >
							</xsl:if>
						</xsl:if>
					</xsl:if>
				</xsl:if>
				<xsl:if test ="a:lvl9pPr/a:buClr/a:srgbClr">
					<xsl:value-of select ="concat('#',a:lvl9pPr/a:buClr/a:srgbClr/@val)"/>
				</xsl:if>
				<xsl:if test ="a:lvl9pPr/a:buClr/a:schemeClr">
					<xsl:variable name ="schemeColour">
						<xsl:value-of select="./a:lvl9pPr/a:buClr/a:schemeClr/@val"/>
					</xsl:variable>
					<xsl:variable name ="clrMap">
						<xsl:if test ="./parent::node()/parent::node()/p:clrMap">

							<xsl:call-template name ="getColorMap">
								<xsl:with-param name ="schemeClr" select="$schemeColour"/>
							</xsl:call-template>

						</xsl:if>
						<xsl:if test ="not(./parent::node()/parent::node()/p:clrMap)">
							<xsl:value-of select="a:lvl9pPr/a:buClr/a:schemeClr/@val"/>
						</xsl:if>
					</xsl:variable>
					<xsl:call-template name ="getColorCode">
						<xsl:with-param name ="color">
							<xsl:value-of select="$clrMap"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if >
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- Template insertBulletCharacter-->
  
 	<xsl:template name ="insertNumber">
		<xsl:param name ="number"/>
		<xsl:param name ="startAt"/>
		<xsl:if test ="$number='arabicPeriod'">
			<xsl:attribute name ="style:num-format" >
				<xsl:value-of  select ="'1'"/>
			</xsl:attribute >
			<xsl:attribute name ="style:num-suffix">
				<xsl:value-of select ="'.'"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test ="$number='arabicParenR'">
			<xsl:attribute name ="style:num-format" >
				<xsl:value-of  select ="'1'"/>
			</xsl:attribute >
			<xsl:attribute name ="style:num-suffix">
				<xsl:value-of select ="')'"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test ="$number='arabicParenBoth'">
			<xsl:attribute name ="style:num-format" >
				<xsl:value-of  select ="'1'"/>
			</xsl:attribute >
			<xsl:attribute name ="style:num-suffix">
				<xsl:value-of select ="')'"/>
			</xsl:attribute>
			<xsl:attribute name ="style:num-prefix">
				<xsl:value-of select ="'('"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test ="$number='alphaUcPeriod'">
			<xsl:attribute name ="style:num-format" >
				<xsl:value-of  select ="'A'"/>
			</xsl:attribute >
			<xsl:attribute name ="style:num-suffix">
				<xsl:value-of select ="'.'"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test ="$number='alphaUcParenR'">
			<xsl:attribute name ="style:num-format" >
				<xsl:value-of  select ="'A'"/>
			</xsl:attribute >
			<xsl:attribute name ="style:num-suffix">
				<xsl:value-of select ="')'"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test ="$number='alphaUcParenBoth'">
			<xsl:attribute name ="style:num-format" >
				<xsl:value-of  select ="'A'"/>
			</xsl:attribute >
			<xsl:attribute name ="style:num-suffix">
				<xsl:value-of select ="')'"/>
			</xsl:attribute>
			<xsl:attribute name ="style:num-prefix">
				<xsl:value-of select ="'('"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test ="$number='alphaLcPeriod'">
			<xsl:attribute name ="style:num-format" >
				<xsl:value-of  select ="'a'"/>
			</xsl:attribute >
			<xsl:attribute name ="style:num-suffix">
				<xsl:value-of select ="'.'"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test ="$number='alphaLcParenR'">
			<xsl:attribute name ="style:num-format" >
				<xsl:value-of  select ="'a'"/>
			</xsl:attribute >
			<xsl:attribute name ="style:num-suffix">
				<xsl:value-of select ="')'"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test ="$number='alphaLcParenBoth'">
			<xsl:attribute name ="style:num-format" >
				<xsl:value-of  select ="'a'"/>
			</xsl:attribute >
			<xsl:attribute name ="style:num-suffix">
				<xsl:value-of select ="')'"/>
			</xsl:attribute>
			<xsl:attribute name ="style:num-prefix">
				<xsl:value-of select ="'('"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test ="$number='romanUcPeriod'">
			<xsl:attribute name ="style:num-format" >
				<xsl:value-of  select ="'I'"/>
			</xsl:attribute >
			<xsl:attribute name ="style:num-suffix">
				<xsl:value-of select ="'.'"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test ="$number='romanLcPeriod'">
			<xsl:attribute name ="style:num-format" >
				<xsl:value-of  select ="'i'"/>
			</xsl:attribute >
			<xsl:attribute name ="style:num-suffix">
				<xsl:value-of select ="'.'"/>
			</xsl:attribute>
		</xsl:if >
		<!-- start at value-->
		<xsl:attribute name ="text:start-value">
     
			<xsl:value-of select ="$startAt"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template name ="getBulletForLevelsLayout">
		<xsl:param name ="slideMaster"/>
    <xsl:param name ="slideLayout"/>
		<xsl:param name ="newTextLvl"/>
		<xsl:param name ="levelStyle"/>
		<xsl:param name ="textColor"/>
		<xsl:param name ="buSize"/>
		<xsl:param name ="textFont"/>

		<xsl:variable name ="nodeName">
			<xsl:value-of select ="concat('a:lvl',$newTextLvl,'pPr')"/>
		</xsl:variable>

		<xsl:variable name ="textColorLayout">
			<xsl:if test ="$textColor='0'">
				<xsl:choose>
					<xsl:when test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:p/a:pPr[@lvl=$newTextLvl]">
						<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/a:solidFill">
							<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/a:solidFill/a:srgbClr">
								<xsl:value-of select ="concat('#',./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/a:solidFill/a:srgbClr/@val)"/>
							</xsl:if>
							<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/a:solidFill/a:schemeClr">

								<xsl:call-template name ="getColorCode">
									<xsl:with-param name ="color">
										<xsl:value-of select="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/a:solidFill/a:schemeClr/@val"/>
									</xsl:with-param>
								</xsl:call-template >
							</xsl:if>
						</xsl:if>
						<xsl:if test ="not(./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/a:solidFill)">
							<xsl:value-of select ="'0'"/>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise >
						<xsl:value-of select ="$textColor"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test ="$textColor !='0'">
				<xsl:value-of select ="$textColor"/>
			</xsl:if>
		</xsl:variable>
		<xsl:call-template name ="getBullet_Level">
			<xsl:with-param name ="slideMaster"  select ="$slideMaster"/>
			<xsl:with-param name ="slideLayout" select ="$slideLayout"/>
			<xsl:with-param name ="newTextLvl" select ="$newTextLvl"  />
			<xsl:with-param name ="levelStyle" select ="$levelStyle"/>
			<xsl:with-param name ="textColor" select ="$textColorLayout"/>
			<xsl:with-param name ="buSize" select ="$buSize"/>
			<xsl:with-param name="nodeName" select="$nodeName"/>
			<xsl:with-param name="textFont" select="$textFont"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name ="getBulletsFromSlideMaster">
		<xsl:param name ="slideMaster" />
		<xsl:param name ="newTextLvl"  />
		<xsl:param name ="levelStyle"/>
		<xsl:param name ="textColor"/>
				<xsl:param name ="buSize"/>		
		        <xsl:param name="textFont"/>
		
		<xsl:variable name ="nodeName">
			<xsl:value-of select ="concat('a:lvl',$newTextLvl,'pPr')"/>
		</xsl:variable>
		<xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle/child::node()[$newTextLvl][name()=$nodeName]">
			<xsl:if test ="a:buChar">
				<text:list-style>
					<xsl:attribute name ="style:name">
						<xsl:value-of select ="$levelStyle"/>
					</xsl:attribute >
					<text:list-level-style-bullet>
						<xsl:attribute name ="text:level">
							<xsl:value-of select ="$newTextLvl"/>
						</xsl:attribute >
						<xsl:attribute name ="text:bullet-char">
							<xsl:call-template name ="insertBulletCharacter">
								<xsl:with-param name ="character" select ="a:buChar/@char" />
							</xsl:call-template>
						</xsl:attribute >
						<style:list-level-properties>
							<xsl:if test ="./@indent">
								<xsl:choose>
									<xsl:when test="./@indent &lt; 0">
										<xsl:attribute name ="text:min-label-width">
											<xsl:value-of select="concat(format-number((0 - ./@indent) div 360000, '#.##'), 'cm')"/>
										</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name ="text:min-label-width">
											<xsl:value-of select="concat(format-number(./@indent div 360000, '#.##'), 'cm')"/>
										</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if >
							<xsl:if test ="./@marL">
								<xsl:attribute name ="text:space-before">
									<xsl:value-of select="concat((./@marL + ./@indent) div 360000, 'cm')"/>
								</xsl:attribute>
							</xsl:if>
						</style:list-level-properties>
						<style:text-properties style:font-charset="x-symbol">
							<!--code added by yeswanth.s for bug#2019519 , 17 July 2008-->
							<xsl:attribute name="fo:font-family">
								<xsl:choose>
									<xsl:when test="./a:buFont/@typeface">
										<xsl:value-of select="./a:buFont/@typeface"/>										
								    </xsl:when>
									<xsl:otherwise>
								<xsl:value-of select="$textFont"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<!--end of code added by yeswanth.s-->
							
							<xsl:choose>
								<xsl:when test="$buSize !=''">
									<xsl:attribute name ="fo:font-size">
										<xsl:value-of select ="concat(( $buSize div 1000),'%')"/>
									</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
							<xsl:if test ="a:buSzPct">
								<xsl:attribute name ="fo:font-size">
									<xsl:value-of select ="concat((a:buSzPct/@val div 1000),'%')"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="not(a:buSzPct)">
								<xsl:attribute name ="fo:font-size">
									<xsl:value-of select ="'100%'"/>
								</xsl:attribute>
							</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
							
							<xsl:if test ="a:buClr">
								<xsl:if test ="a:buClr/a:srgbClr">
									<xsl:variable name ="color" select ="a:buClr/a:srgbClr/@val"/>
									<xsl:attribute name ="fo:color">
										<xsl:value-of select ="concat('#',$color)"/>
									</xsl:attribute>
								</xsl:if>
								<xsl:if test ="a:buClr/a:schemeClr">
									<xsl:variable name ="clrMap">
										<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:clrMap">
											<xsl:call-template name ="getColorMapSM">
												<xsl:with-param name ="schemeClr" select="./a:buClr/a:schemeClr/@val"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test ="not(./parent::node()/parent::node()/parent::node()/p:clrMap)">
											<xsl:value-of select="./a:buClr/a:schemeClr/@val"/>
										</xsl:if>
									</xsl:variable>
									<xsl:attribute name ="fo:color">
										<xsl:call-template name ="getColorCode">
											<xsl:with-param name ="color">
												<xsl:value-of select="$clrMap"/>
											</xsl:with-param>
										</xsl:call-template >
									</xsl:attribute>
								</xsl:if>
							</xsl:if>
							<xsl:if test ="not(a:buClr)">
								<xsl:if test ="$textColor != '0'">
									<xsl:attribute name ="fo:color">
										<xsl:value-of select ="$textColor"/>
									</xsl:attribute>
								</xsl:if>
								<xsl:if test ="$textColor = '0'">
									<xsl:if test ="./a:defRPr/a:solidFill">
										<xsl:if test ="./a:defRPr/a:solidFill/a:srgbClr">
											<xsl:attribute name ="fo:color">
												<xsl:value-of select ="concat('#',./a:defRPr/a:solidFill/a:srgbClr/@val)"/>
											</xsl:attribute>
										</xsl:if>
										<xsl:if test ="./a:defRPr/a:solidFill/a:schemeClr">
											<xsl:variable name ="clrMap">
												<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:clrMap">
													<xsl:call-template name ="getColorMapSM">
														<xsl:with-param name ="schemeClr" select="./a:defRPr/a:solidFill/a:schemeClr/@val"/>
													</xsl:call-template>
												</xsl:if>
												<xsl:if test ="not(./parent::node()/parent::node()/parent::node()/p:clrMap)">
													<xsl:value-of select="./a:defRPr/a:solidFill/a:schemeClr/@val"/>
												</xsl:if>
											</xsl:variable>
											<xsl:attribute name ="fo:color">
												<xsl:call-template name ="getColorCode">
													<xsl:with-param name ="color">
														<xsl:value-of select="$clrMap"/>
													</xsl:with-param>
												</xsl:call-template >
											</xsl:attribute>
										</xsl:if>
									</xsl:if>
								</xsl:if>
							</xsl:if>
						</style:text-properties >
					</text:list-level-style-bullet>
				</text:list-style>
			</xsl:if>
			<xsl:if test ="a:buAutoNum">
				<text:list-style>
					<xsl:attribute name ="style:name">
						<xsl:value-of select ="$levelStyle"/>
					</xsl:attribute >
					<text:list-level-style-number>
						<xsl:attribute name ="text:level">
							<xsl:value-of select ="$newTextLvl"/>
						</xsl:attribute >
						<xsl:variable name ="startAt">
							<xsl:if test ="a:buAutoNum/@startAt">
								<xsl:value-of select ="a:buAutoNum/@startAt" />
							</xsl:if>
							<xsl:if test ="not(a:buAutoNum/@startAt)">
								<xsl:value-of select ="'1'" />
							</xsl:if>
						</xsl:variable>
						<xsl:call-template name ="insertNumber">
							<xsl:with-param name ="number" select ="a:buAutoNum/@type"/>
							<xsl:with-param name ="startAt" select ="$startAt"/>
						</xsl:call-template>
						<style:list-level-properties>
							<xsl:if test ="./@indent">
								<xsl:choose>
									<xsl:when test="./@indent &lt; 0">
										<xsl:attribute name ="text:min-label-width">
											<xsl:value-of select="concat(format-number((0 - ./@indent) div 360000, '#.##'), 'cm')"/>
										</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name ="text:min-label-width">
											<xsl:value-of select="concat(format-number(./@indent div 360000, '#.##'), 'cm')"/>
										</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if >
							<xsl:if test ="./@marL">
								<xsl:attribute name ="text:space-before">
									<xsl:value-of select="concat(format-number( (./@marL + ./@indent) div 360000, '#.##'), 'cm')"/>
								</xsl:attribute>
							</xsl:if>
						</style:list-level-properties>
						<style:text-properties style:font-family-generic="swiss" style:font-pitch="variable" fo:font-size="100%">
							<xsl:if test ="a:buFont/@typeface">
								<xsl:attribute name ="fo:font-family">
									<xsl:value-of select ="a:buFont/@typeface"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="not(a:buFont/@typeface)">
								<xsl:attribute name ="fo:font-family">
									<xsl:value-of select ="'Arial'"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="a:buSzPct">
								<xsl:attribute name ="fo:font-size">
									<xsl:value-of select ="concat((a:buSzPct/@val div 1000),'%')"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="not(a:buSzPct)">
								<xsl:attribute name ="fo:font-size">
									<xsl:value-of select ="'100%'"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test ="a:buClr">
								<xsl:if test ="a:buClr/a:srgbClr">
									<xsl:variable name ="color" select ="a:buClr/a:srgbClr/@val"/>
									<xsl:attribute name ="fo:color">
										<xsl:value-of select ="concat('#',$color)"/>
									</xsl:attribute>
								</xsl:if>
								<xsl:if test ="a:buClr/a:schemeClr">
									<xsl:variable name ="clrMap">
										<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:clrMap">
											<xsl:call-template name ="getColorMapSM">
												<xsl:with-param name ="schemeClr" select="./a:buClr/a:schemeClr/@val"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test ="not(./parent::node()/parent::node()/parent::node()/p:clrMap)">
											<xsl:value-of select="./a:buClr/a:schemeClr/@val"/>
										</xsl:if>
									</xsl:variable>
									<xsl:attribute name ="fo:color">
										<xsl:call-template name ="getColorCode">
											<xsl:with-param name ="color">
												<xsl:value-of select="$clrMap"/>
											</xsl:with-param>
										</xsl:call-template >
									</xsl:attribute>
								</xsl:if>
							</xsl:if>
							<xsl:if test ="not(a:buClr)">
								<xsl:if test ="$textColor != '0'">
									<xsl:attribute name ="fo:color">
										<xsl:value-of select ="$textColor"/>
									</xsl:attribute>
								</xsl:if>
								<xsl:if test ="$textColor = '0'">
									<xsl:if test ="./a:defRPr/a:solidFill">
										<xsl:if test ="./a:defRPr/a:solidFill/a:srgbClr">
											<xsl:attribute name ="fo:color">
												<xsl:value-of select ="concat('#',./a:defRPr/a:solidFill/a:srgbClr/@val)"/>
											</xsl:attribute>
										</xsl:if>
										<xsl:if test ="./a:defRPr/a:solidFill/a:schemeClr">
											<xsl:variable name ="clrMap">
												<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:clrMap">
													<xsl:call-template name ="getColorMapSM">
														<xsl:with-param name ="schemeClr" select="./a:defRPr/a:solidFill/a:schemeClr/@val"/>
													</xsl:call-template>
												</xsl:if>
												<xsl:if test ="not(./parent::node()/parent::node()/parent::node()/p:clrMap)">
													<xsl:value-of select="./a:defRPr/a:solidFill/a:schemeClr/@val"/>
												</xsl:if>
											</xsl:variable>
											<xsl:attribute name ="fo:color">
												<xsl:call-template name ="getColorCode">
													<xsl:with-param name ="color">
														<xsl:value-of select="$clrMap"/>
													</xsl:with-param>
												</xsl:call-template >
											</xsl:attribute>
										</xsl:if>
									</xsl:if>
								</xsl:if>
							</xsl:if>
						</style:text-properties>
					</text:list-level-style-number>
				</text:list-style>
			</xsl:if>
			<xsl:if test ="a:buBlip">
				<xsl:variable name ="rId" select ="a:buBlip/a:blip/@r:embed"/>
				<xsl:variable name="XlinkHref">
					<xsl:variable name="pzipsource">
						<xsl:value-of select="key('Part', concat('ppt/slideMasters/_rels/',$slideMaster,'.rels'))//rels:Relationships/rels:Relationship[@Id=$rId]/@Target"/>
					</xsl:variable>
					<xsl:value-of select="concat('Pictures/', substring-after($pzipsource,'../media/'))"/>
				</xsl:variable>
				<xsl:call-template name="copyPictures">
					<xsl:with-param name="document">
						<xsl:value-of select="concat('ppt/slideMasters/_rels/',$slideMaster,'.rels')"/>
					</xsl:with-param>
					<xsl:with-param name="rId">
						<xsl:value-of select ="$rId"/>
					</xsl:with-param>
				</xsl:call-template>
				<text:list-style>
					<xsl:attribute name ="style:name">
						<xsl:value-of select ="$levelStyle"/>
					</xsl:attribute >
					<text:list-level-style-image xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad">
						<xsl:attribute name="text:level">
							<xsl:value-of select="$newTextLvl"/>
            </xsl:attribute>
            <xsl:attribute name="xlink:href">
              <xsl:value-of select="$XlinkHref"/>
            </xsl:attribute>
            <style:list-level-properties style:vertical-pos="middle" style:vertical-rel="line" fo:width="0.636cm" fo:height="0.636cm"/>
          </text:list-level-style-image>
        </text:list-style>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name ="tmpListLevelPropFrmSM">
    <xsl:param name ="slideMaster" />
    <xsl:param name ="newTextLvl"  />
    <xsl:param name ="levelStyle"/>
    <xsl:param name ="textColor"/>
    <xsl:variable name ="nodeName">
      <xsl:value-of select ="concat('a:lvl',$newTextLvl,'pPr')"/>
    </xsl:variable>
    <xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle/child::node()[$newTextLvl][name()=$nodeName]">
      <style:list-level-properties>
        <xsl:call-template name="tmBulletListLevelProp"/>
      </style:list-level-properties>
    </xsl:for-each>
  </xsl:template>

	<xsl:template name ="getBullet_Level">
		<xsl:param name ="slideMaster" />
		<xsl:param name ="slideLayout"/>
		<xsl:param name ="newTextLvl" />
		<xsl:param name ="levelStyle"/>
		<xsl:param name ="textColor"/>
		<xsl:param name ="buSize"/>
		<xsl:param name="nodeName"/>
		<xsl:param name="textFont"/>
		<xsl:if test="not(./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buNone)">
			<xsl:choose >
				<xsl:when test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buChar">
					<text:list-style>
						<xsl:attribute name ="style:name">
							<xsl:value-of select ="$levelStyle"/>
						</xsl:attribute >
						<text:list-level-style-bullet>
							<xsl:attribute name ="text:level">
								<xsl:value-of select ="$newTextLvl"/>
							</xsl:attribute >
							<xsl:attribute name ="text:bullet-char">
								<xsl:call-template name ="insertBulletCharacter">
									<xsl:with-param name ="character" select ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buChar/@char" />
								</xsl:call-template>
							</xsl:attribute >
							<xsl:choose>
								<xsl:when test="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/@marL">
									<xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]">
										<style:list-level-properties>
											<xsl:call-template name="tmBulletListLevelProp"/>
										</style:list-level-properties>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="not(./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/@marL)">
									<xsl:call-template name ="tmpListLevelPropFrmSM">
										<xsl:with-param name ="slideMaster" select ="$slideMaster"/>
										<xsl:with-param name ="newTextLvl" select ="$newTextLvl" />
										<xsl:with-param name ="levelStyle" select ="$levelStyle"/>
										<xsl:with-param name ="textColor" select ="$textColor"/>
									</xsl:call-template>
								</xsl:when>
							</xsl:choose>
							<style:text-properties style:font-charset="x-symbol">
								<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buFont/@typeface">
									<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buFont[@typeface='Arial']">
										<xsl:attribute name ="fo:font-family">
											<xsl:value-of select ="'StarSymbol'"/>
										</xsl:attribute>
									</xsl:if>
									<xsl:if test ="not(./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buFont[@typeface='Arial'])">
										<xsl:attribute name ="fo:font-family">
											<xsl:value-of select ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buFont/@typeface"/>
										</xsl:attribute>
									</xsl:if>
								</xsl:if>
								<xsl:if test ="not(./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buFont/@typeface)">

								</xsl:if>
								<xsl:choose>
									<xsl:when test="$buSize !=''">
										<xsl:attribute name ="fo:font-size">
											<xsl:value-of select ="concat(( $buSize div 1000),'%')"/>
										</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buSzPct">
											<xsl:attribute name ="fo:font-size">
												<xsl:value-of select ="concat((./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buSzPct/@val div 1000),'%')"/>
											</xsl:attribute>
										</xsl:if>
										<xsl:if test ="not(./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buSzPct)">
											<xsl:attribute name ="fo:font-size">
												<xsl:value-of select ="'100%'"/>
											</xsl:attribute>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>

								<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buClr">
									<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buClr/a:srgbClr">
										<xsl:variable name ="color" select ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buClr/a:srgbClr/@val"/>
										<xsl:attribute name ="fo:color">
											<xsl:value-of select ="concat('#',$color)"/>
										</xsl:attribute>
									</xsl:if>
									<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buClr/a:schemeClr">
										<xsl:attribute name ="fo:color">
											<xsl:call-template name ="getColorCode">
												<xsl:with-param name ="color">
													<xsl:value-of select="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buClr/a:schemeClr/@val"/>
												</xsl:with-param>
											</xsl:call-template >
										</xsl:attribute>
									</xsl:if>
								</xsl:if>
								<!-- Code added by vijayeta, bug fix 1746350-->
								<xsl:if test ="not(./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buClr)">
									<xsl:if test ="$textColor != '0'">
										<xsl:attribute name ="fo:color">
											<xsl:value-of select ="$textColor"/>
										</xsl:attribute>
									</xsl:if>
									<xsl:if test ="$textColor = '0'">
										<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/a:solidFill">
											<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/a:solidFill/a:srgbClr">
												<xsl:attribute name ="fo:color">
													<xsl:value-of select ="concat('#',./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/a:solidFill/a:srgbClr/@val)"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/a:solidFill/a:schemeClr">
												<xsl:attribute name ="fo:color">
													<xsl:call-template name ="getColorCode">
														<xsl:with-param name ="color">
															<xsl:value-of select="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/a:solidFill/a:schemeClr/@val"/>
														</xsl:with-param>
													</xsl:call-template >
												</xsl:attribute>
											</xsl:if>
										</xsl:if>
										<xsl:if test ="not(./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/a:solidFill)">
											<xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle">
												<xsl:variable name ="levelColor" >
													<xsl:call-template name ="getLevelColor">
														<xsl:with-param name ="levelNum" select ="$newTextLvl"/>
														<xsl:with-param name ="textColor" select ="$textColor"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:attribute name ="fo:color">
													<xsl:value-of select ="$levelColor"/>
												</xsl:attribute>
											</xsl:for-each>
										</xsl:if>
									</xsl:if>
								</xsl:if>
								<!--End of Code added by vijayeta, bug fix 1746350-->
							</style:text-properties >
						</text:list-level-style-bullet>
					</text:list-style>
				</xsl:when>
				<xsl:when test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buAutoNum">
					<text:list-style>
						<xsl:attribute name ="style:name">
							<xsl:value-of select ="$levelStyle"/>
						</xsl:attribute >
						<xsl:variable name ="Number" select ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/a:lvl1pPr/a:buAutoNum/@type"/>
						<text:list-level-style-number>
							<xsl:attribute name ="text:level">
								<xsl:value-of select ="$newTextLvl"/>
							</xsl:attribute >
							<xsl:variable name ="startAt">
								<xsl:if test ="a:pPr/a:buAutoNum/@startAt">
									<xsl:value-of select ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buAutoNum/@startAt" />
								</xsl:if>
								<xsl:if test ="not(./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buAutoNum/@startAt)">
									<xsl:value-of select ="'1'" />
								</xsl:if>
							</xsl:variable>
							<xsl:call-template name ="insertNumber">
								<xsl:with-param name ="number" select ="$Number"/>
								<xsl:with-param name ="startAt" select ="$startAt"/>
							</xsl:call-template>
							<xsl:choose>
								<xsl:when test="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/@marL">
									<xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]">
										<style:list-level-properties>
											<xsl:call-template name="tmBulletListLevelProp"/>
										</style:list-level-properties>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="not(./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/@marL)">
									<xsl:call-template name ="tmpListLevelPropFrmSM">
										<xsl:with-param name ="slideMaster" select ="$slideMaster"/>
										<xsl:with-param name ="newTextLvl" select ="$newTextLvl" />
										<xsl:with-param name ="levelStyle" select ="$levelStyle"/>
										<xsl:with-param name ="textColor" select ="$textColor"/>
									</xsl:call-template>
								</xsl:when>
							</xsl:choose>
							<style:text-properties style:font-family-generic="swiss" style:font-pitch="variable">
								<xsl:if test ="a:pPr/a:buFont/@typeface">
									<xsl:attribute name ="fo:font-family">
										<xsl:value-of select ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buFont/@typeface"/>
									</xsl:attribute>
								</xsl:if>
								<xsl:if test ="not(./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buFont/@typeface)">
									<xsl:attribute name ="fo:font-family">
										<xsl:value-of select ="'Arial'"/>
									</xsl:attribute>
								</xsl:if>
								<xsl:if test ="not(./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buSzPct)">
									<xsl:attribute name ="fo:font-size">
										<xsl:value-of select ="'100%'"/>
									</xsl:attribute>
								</xsl:if>
								<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buClr">
									<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buClr/a:srgbClr">
										<xsl:attribute name ="fo:color">
											<xsl:value-of select ="concat('#',./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buClr/a:srgbClr/@val)"/>
										</xsl:attribute>
									</xsl:if>
									<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buClr/a:schemeClr">
										<xsl:attribute name ="fo:color">
											<xsl:call-template name ="getColorCode">
												<xsl:with-param name ="color">
													<xsl:value-of select="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buClr/a:schemeClr/@val"/>
												</xsl:with-param>
											</xsl:call-template >
										</xsl:attribute >
									</xsl:if>
								</xsl:if>
								<!--Code added by vijayeta, bug fix 1746350-->
								<xsl:if test ="not(./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buClr)">
									<xsl:if test ="$textColor != '0'">
										<xsl:attribute name ="fo:color">
											<xsl:value-of select ="$textColor"/>
										</xsl:attribute>
									</xsl:if>
									<xsl:if test ="$textColor = '0'">
										<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/a:solidFill">
											<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/a:solidFill/a:srgbClr">
												<xsl:attribute name ="fo:color">
													<xsl:value-of select ="concat('#',./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/a:solidFill/a:srgbClr/@val)"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/a:solidFill/a:schemeClr">
												<xsl:attribute name ="fo:color">
													<xsl:call-template name ="getColorCode">
														<xsl:with-param name ="color">
															<xsl:value-of select="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/a:solidFill/a:schemeClr/@val"/>
														</xsl:with-param>
													</xsl:call-template >
												</xsl:attribute>
											</xsl:if>
										</xsl:if>
										<xsl:if test ="not(./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:defRPr/a:solidFill)">
											<xsl:for-each select ="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:sldMaster/p:txStyles/p:bodyStyle">
												<xsl:variable name ="levelColor" >
													<xsl:call-template name ="getLevelColor">
														<xsl:with-param name ="levelNum" select ="$newTextLvl"/>
														<xsl:with-param name ="textColor" select ="$textColor"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:attribute name ="fo:color">
													<xsl:value-of select ="$levelColor"/>
												</xsl:attribute>
											</xsl:for-each>
										</xsl:if>
									</xsl:if>
								</xsl:if>
								<!--End of Code added by vijayeta, bug fix 1746350-->
							</style:text-properties>
						</text:list-level-style-number>
					</text:list-style>
				</xsl:when>
				<xsl:when test ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buBlip">
					<xsl:variable name ="rId" select ="./parent::node()/parent::node()/parent::node()/p:txBody/a:lstStyle/child::node()[name()=$nodeName]/a:buBlip/a:blip/@r:embed"/>
					<xsl:variable name="XlinkHref">
						<xsl:variable name="pzipsource">
							<xsl:value-of select="key('Part', concat('ppt/slideLayouts/_rels/',$slideLayout,'.rels'))//rels:Relationships/rels:Relationship[@Id=$rId]/@Target"/>
						</xsl:variable>
						<xsl:value-of select="concat('Pictures/', substring-after($pzipsource,'../media/'))"/>
					</xsl:variable>
					<xsl:call-template name="copyPictures">
						<xsl:with-param name="document">
							<xsl:value-of select="concat('ppt/slideLayouts/_rels/',$slideLayout,'.rels')"/>
						</xsl:with-param>
						<xsl:with-param name="rId">
							<xsl:value-of select ="$rId"/>
						</xsl:with-param>
					</xsl:call-template>
					<text:list-style>
						<xsl:attribute name ="style:name">
							<xsl:value-of select ="$levelStyle"/>
						</xsl:attribute >
						<text:list-level-style-image xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad">
							<xsl:attribute name="text:level">
								<xsl:value-of select="$newTextLvl"/>
							</xsl:attribute>
							<xsl:attribute name="xlink:href">
								<xsl:value-of select="$XlinkHref"/>
							</xsl:attribute>
							<style:list-level-properties style:vertical-pos="middle" style:vertical-rel="line" fo:width="0.318cm" fo:height="0.318cm" />
						</text:list-level-style-image>
					</text:list-style>
				</xsl:when>
				<xsl:otherwise >
					<xsl:call-template name ="getBulletsFromSlideMaster">
						<xsl:with-param name ="slideMaster" select ="$slideMaster"/>
						<xsl:with-param name ="newTextLvl" select ="$newTextLvl" />
						<xsl:with-param name ="levelStyle" select ="$levelStyle"/>
						<xsl:with-param name ="textColor" select ="$textColor"/>
						<xsl:with-param name ="buSize" select ="$buSize"/>
						<xsl:with-param name ="textFont" select ="$textFont"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template name ="getColorMap">
		<xsl:param name ="schemeClr"/>
		<xsl:for-each select="./parent::node()/parent::node()/p:clrMap">
			<xsl:choose>
				<xsl:when test="$schemeClr ='tx1'">
					<xsl:value-of select="@tx1" />
				</xsl:when>
				<xsl:when test="$schemeClr ='tx2'">
					<xsl:value-of select="@tx2" />
				</xsl:when>
				<xsl:when test="$schemeClr ='bg1'">
					<xsl:value-of select="@bg1" />
				</xsl:when>
				<xsl:when test="$schemeClr ='accent1'">
					<xsl:value-of select="@accent1" />
				</xsl:when>
				<xsl:when test="$schemeClr ='accent2'">
					<xsl:value-of select="@accent2" />
				</xsl:when>
				<xsl:when test="$schemeClr ='accent3'">
					<xsl:value-of select="@accent3" />
				</xsl:when>
				<xsl:when test="$schemeClr ='accent4'">
					<xsl:value-of select="@accent4" />
				</xsl:when>
				<xsl:when test="$schemeClr ='accent5'">
					<xsl:value-of select="@accent5" />
				</xsl:when>
				<xsl:when test="$schemeClr ='accent6'">
					<xsl:value-of select="@accent6" />
				</xsl:when>
				<xsl:when test="$schemeClr ='hlink'">
					<xsl:value-of select="@hlink" />
				</xsl:when>
				<xsl:when test="$schemeClr ='folHlink'">
					<xsl:value-of select="@folHlink" />
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name ="getColorMapSM">
		<xsl:param name ="schemeClr"/>
		<xsl:for-each select="./parent::node()/parent::node()/parent::node()/p:clrMap">
			<xsl:choose>
				<xsl:when test="$schemeClr ='tx1'">
					<xsl:value-of select="@tx1" />
				</xsl:when>
				<xsl:when test="$schemeClr ='tx2'">
					<xsl:value-of select="@tx2" />
				</xsl:when>
				<xsl:when test="$schemeClr ='bg1'">
					<xsl:value-of select="@bg1" />
				</xsl:when>
				<xsl:when test="$schemeClr ='bg2'">
					<xsl:value-of select="@bg2" />
				</xsl:when>
				<xsl:when test="$schemeClr ='accent1'">
					<xsl:value-of select="@accent1" />
				</xsl:when>
				<xsl:when test="$schemeClr ='accent2'">
					<xsl:value-of select="@accent2" />
				</xsl:when>
				<xsl:when test="$schemeClr ='accent3'">
					<xsl:value-of select="@accent3" />
				</xsl:when>
				<xsl:when test="$schemeClr ='accent4'">
					<xsl:value-of select="@accent4" />
				</xsl:when>
				<xsl:when test="$schemeClr ='accent5'">
					<xsl:value-of select="@accent5" />
				</xsl:when>
				<xsl:when test="$schemeClr ='accent6'">
					<xsl:value-of select="@accent6" />
				</xsl:when>
				<xsl:when test="$schemeClr ='hlink'">
					<xsl:value-of select="@hlink" />
				</xsl:when>
				<xsl:when test="$schemeClr ='folHlink'">
					<xsl:value-of select="@folHlink" />
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="textFontLayout">
		<xsl:param name="slideLayout"/>
		<xsl:param name="idx"/>
		<xsl:param name="slideMaster"/>
		<xsl:param name="level"/>
		<xsl:for-each select="key('Part', concat('ppt/slideLayouts/',$slideLayout))//p:sldLayout/p:cSld/p:spTree/p:sp">
			<xsl:if test="./p:nvSpPr/p:nvPr/p:ph/@idx = $idx">				
				<xsl:for-each select ="./p:txBody/a:p">
					<xsl:if test="./a:pPr/@lvl = $level">
						<xsl:variable name="var_level">
							<xsl:choose>
								<xsl:when test="a:pPr/@lvl">
									<xsl:value-of select="a:pPr/@lvl"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'0'"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name ="nodeName">
							<xsl:choose>
								<xsl:when test="a:pPr/@lvl">
									<xsl:value-of select ="concat('a:lvl',$var_level+1 ,'pPr')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select ="'a:lvl1pPr'"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:if test ="not(a:pPr/a:buNone)">
							<!--code added by yeswanth : variable textFont-->
								<xsl:if test ="./a:r/a:rPr">
									<xsl:choose>
										<xsl:when test="./a:r[1]/a:rPr/a:latin/@typeface">
											<xsl:value-of select="./a:r[1]/a:rPr/a:latin/@typeface"/>
										</xsl:when>
										<xsl:when test="./a:r[1]/a:rPr/a:ea/@typeface">
											<xsl:value-of select="./a:r[1]/a:rPr/a:ea/@typeface"/>
										</xsl:when>
										<xsl:when test="./a:r[1]/a:rPr/a:cs/@typeface">
											<xsl:value-of select="./a:r[1]/a:rPr/a:cs/@typeface"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="textFontMaster">
												<xsl:with-param name="slideMaster" select="$slideMaster"/>
												<xsl:with-param name="nodeName" select="$nodeName"/>
												<xsl:with-param name="level" select="$level + 1 "/>												
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>							
							<!--end-->
						</xsl:if >
					</xsl:if>									
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="textFontMaster">
		<xsl:param name="slideMaster"/>
		<xsl:param name="nodeName"/>
		<xsl:param name="level"/>
		<xsl:variable name ="elementName">
			<xsl:value-of select ="concat('a:lvl',$level ,'pPr')"/>
		</xsl:variable>
		<xsl:variable name="themeName">
			<xsl:value-of select="'http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme'"/>
		</xsl:variable>
		<xsl:if test="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:txStyles/p:bodyStyle/child::node()[name()=$elementName]/a:buFont/@typeface">
			<xsl:value-of select="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:txStyles/p:bodyStyle/child::node()[name()=$elementName]/a:buFont/@typeface"/>
		</xsl:if>
		<xsl:if test="not(key('Part', concat('ppt/slideMasters/',$slideMaster))//p:txStyles/p:bodyStyle/child::node()[name()=$elementName]/a:buFont/@typeface)">
			<xsl:for-each select="key('Part', concat('ppt/slideMasters/',$slideMaster))//p:txStyles/p:bodyStyle/child::node()[name()=$elementName]/a:defRPr">
			<xsl:choose>
				<xsl:when test="./a:latin">
					<xsl:variable name="typeFace">
						<xsl:value-of select="substring-after(substring-before(./a:latin/@typeface,'-'),'+')"/>
					</xsl:variable>
					<xsl:variable name="themeNameThis">						
						<xsl:for-each select="key('Part', concat('ppt/slideMasters/_rels/',$slideMaster,'.rels'))//rels:Relationships/rels:Relationship">							
							<xsl:if test="./@Type = $themeName">
								<xsl:value-of select="substring-after(./@Target,'../theme/')"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:for-each select="key('Part', concat('ppt/theme/',$themeNameThis))//a:theme/a:themeElements/a:fontScheme">
						<xsl:if test="$typeFace = 'mj'">
							<xsl:value-of select="./a:majorFont/a:latin/@typeface"/>
						</xsl:if>
						<xsl:if test="$typeFace = 'mn'">
							<xsl:value-of select="./a:minorFont/a:latin/@typeface"/>
						</xsl:if>
					</xsl:for-each>
					
				</xsl:when>
				<xsl:when test="./a:ea">
					<xsl:variable name="typeFace">
						<xsl:value-of select="substring-after(substring-before(./a:ea/@typeface,'-'),'+')"/>
					</xsl:variable>
					<xsl:variable name="themeNameThis">
						<xsl:for-each select="key('Part', concat($slideMaster,'.rels'))//Relationship">
							<xsl:if test="@Type = $themeName">
								<xsl:value-of select="substring-after(./@Target,'../theme/')"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:for-each select="key('Part', $themeNameThis)//a:fontScheme">
						<xsl:if test="$typeFace = 'mj'">
							<xsl:value-of select="./a:majorFont/a:ea/@typeface"/>
						</xsl:if>
						<xsl:if test="$typeFace = 'mn'">
							<xsl:value-of select="./a:minorFont/a:ea/@typeface"/>
						</xsl:if>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="./a:cs">
					<xsl:variable name="typeFace">
						<xsl:value-of select="substring-after(substring-before(./a:cs/@typeface,'-'),'+')"/>
					</xsl:variable>
					<xsl:variable name="themeNameThis">
						<xsl:for-each select="key('Part', concat($slideMaster,'.rels'))//Relationship">
							<xsl:if test="@Type = $themeName">
								<xsl:value-of select="substring-after(./@Target,'../theme/')"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:for-each select="key('Part', $themeNameThis)//a:fontScheme">
						<xsl:if test="$typeFace = 'mj'">
							<xsl:value-of select="./a:majorFont/a:cs/@typeface"/>
						</xsl:if>
						<xsl:if test="$typeFace = 'mn'">
							<xsl:value-of select="./a:minorFont/a:cs/@typeface"/>
						</xsl:if>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'calibri'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	
		</xsl:if>
		
	</xsl:template>
	
</xsl:stylesheet>
