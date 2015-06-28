<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    <xsl:template match="/">
        <h1 class="statsHeader1">General Information</h1>
        <h3 class="statsHeader3">Total Spelling Mistakes: <span class="statInfo"><xsl:value-of select="count(//sp)"/></span></h3>
        <h3 class="statsHeader3">Total Grammar Mistakes: <span class="statInfo"><xsl:value-of select="count(//grammar)"/></span></h3>
        <h3 class="statsHeader3">Total Quotes: <span class="statInfo"><xsl:value-of select="count(//dialogue)"/></span></h3>
    </xsl:template>
</xsl:stylesheet>