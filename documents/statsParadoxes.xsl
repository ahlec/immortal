<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="/">
        <xsl:for-each select="//chapter[count(.//paradox) > 0]">
            <h3>Chapter <xsl:value-of select="@number"/> (<xsl:value-of select="count(current()//paradox)"/>)</h3>
            <xsl:apply-templates select="current()//paradox"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="paradox">
        <div class="bullet">
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
</xsl:stylesheet>
