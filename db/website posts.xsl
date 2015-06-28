<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
  <xsl:template match="/">
    <xsl:apply-templates select="//post"/>
  </xsl:template>
  <xsl:template match="post">
    <div class="post">
      <div class="title"><xsl:apply-templates select="./title"/></div>
      <xsl:apply-templates select="body"/>
    </div>
  </xsl:template>
</xsl:stylesheet>
