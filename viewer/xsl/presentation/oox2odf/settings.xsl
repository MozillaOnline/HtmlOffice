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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0"
  xmlns:p="http://schemas.openxmlformats.org/presentation/2006/main"
  xmlns:ooo="http://openoffice.org/2004/office" office:version="1.0">

  <xsl:template name="settings">
    <office:document-settings office:version="1.1">
      <office:settings>
        <config:config-item-set config:name="ooo:view-settings">
          <xsl:choose>
            <xsl:when 
            test="key('Part', 'ppt/presentation.xml')/p:document/p:body/descendant::p:ins or 
        key('Part', 'word/document.xml')/p:document/p:body/descendant::p:del or
        key('Part', 'word/document.xml')/p:document/p:body/descendant::p:pPrChange or
        key('Part', 'word/document.xml')/p:document/p:body/descendant::p:rPrChange">
            <config:config-item config:name="ShowRedlineChanges" config:type="boolean" >true</config:config-item>
            </xsl:when>
            <xsl:otherwise>
              <config:config-item config:name="ShowRedlineChanges" config:type="boolean">false</config:config-item>
            </xsl:otherwise>
            </xsl:choose>
        </config:config-item-set>
      </office:settings>
    </office:document-settings>
  </xsl:template>
</xsl:stylesheet>
