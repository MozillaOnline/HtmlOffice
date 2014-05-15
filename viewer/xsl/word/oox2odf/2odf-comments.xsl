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
  xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
  xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
  xmlns:pzip="urn:cleverage:xmlns:post-processings:zip"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:oox="urn:oox"
  exclude-result-prefixes="office dc meta pzip w oox">

  <xsl:template name="InsertComment">
    <xsl:param name="Id" />
    <office:annotation>
      <xsl:if test="key('Part', 'word/comments.xml')/w:comments/w:comment[@w:id = $Id]/@w:author">
        <dc:creator>
          <xsl:value-of select="key('Part', 'word/comments.xml')/w:comments/w:comment[@w:id = $Id]/@w:author" />
        </dc:creator>
      </xsl:if>
      <xsl:if test="key('Part', 'word/comments.xml')/w:comments/w:comment[@w:id = $Id]/@w:date">
        <dc:date>
          <xsl:value-of select="concat('ooc-FormatDateTime', '-oop-', key('Part', 'word/comments.xml')/w:comments/w:comment[@w:id = $Id]/@w:date, '-ooe')" />
        </dc:date>
      </xsl:if>
      <xsl:apply-templates select="key('Part', 'word/comments.xml')/w:comments/w:comment[@w:id = $Id]/w:p" />
    </office:annotation>
  </xsl:template>
</xsl:stylesheet>
