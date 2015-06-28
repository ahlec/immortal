<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="1.0">
    <xsl:output indent="yes"/>
    <xsl:variable name="xStart" select="80"/>
    <xsl:variable name="xEnd" select="650"/>
    <xsl:variable name="yStart" select="50"/>
    <xsl:variable name="yEnd" select="350"/>
    <xsl:variable name="yScaleDivisor" select="20"/>
    <xsl:variable name="xDimension" select="$xEnd - $xStart"/>
    <xsl:variable name="yDimension" select="$yEnd - $yStart"/>
    <xsl:variable name="numChapters" select="count(//chapter)"/>
    <xsl:variable name="xWidth" select="$xDimension div $numChapters"/>
    <xsl:param name="urlPath"/>
    <xsl:param name="grammarTypes"/>
    <xsl:param name="grammarTypeCount"/>
    <xsl:variable name="opacity">
        <xsl:if test="$grammarTypeCount > 1">0.7</xsl:if>
        <xsl:if test="$grammarTypeCount = 1">1.0</xsl:if>
    </xsl:variable>
    <xsl:variable name="grammarDoc" select="document('grammarTypes.xml')"/>
    <xsl:template match="/">
        <svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%">
            <line stroke="black" stroke-width="2" x1="{$xStart - 3}" x2="{$xStart - 3}" y1="{$yStart - 10}" y2="{$yEnd + 3}"/>
            <text text-anchor="middle" y="{$yDimension + $yStart + ($yStart div 2)}" x="{$xStart + ($xDimension div 2)}">Chapter</text>
            <line stroke="black" stroke-width="2" x1="{$xStart - 3}" x2="{$xEnd}" y1="{$yEnd + 3}" y2="{$yEnd + 3}"/>
            <text y="{($yDimension div 2) + $yStart + 90}" x="{($xStart div 2) - 10}" transform="rotate(-90, {($xStart div 2) - 10}, {($yDimension div 2) + $yStart + 90})">Number of Grammatical Mistakes</text>
            <text y="{$yStart + $yDimension}" x="{$xStart - 10}" transform="rotate(-180, {$xStart - 10}, {$yStart + $yDimension})">- 0</text>
            <text y="{$yStart + 4}" x="{$xStart - 35}">70 -</text>
            <line stroke="black" stroke-width="1" stroke-dasharray="3 3" x1="{$xStart - 3}" x2="{$xStart + $xDimension}" y1="{$yStart}" y2="{$yStart}"/>
            <text y="{$yStart + ($yDimension div 2) + 4}" x="{$xStart - 35}">35 -</text>
            <line stroke="black" stroke-width="1" stroke-dasharray="3 3" x1="{$xStart - 3}" x2="{$xStart + $xDimension}" y1="{$yStart + ($yDimension div 2)}" y2="{$yStart + ($yDimension div 2)}"/>
            <line stroke="black" stroke-width="1" stroke-dasharray="3 3" x1="{$xStart - 3}" x2="{$xStart + $xDimension}" y1="{$yStart + ($yDimension div 4)}" y2="{$yStart + ($yDimension div 4)}"/>
            <line stroke="black" stroke-width="1" stroke-dasharray="3 3" x1="{$xStart - 3}" x2="{$xStart + $xDimension}" y1="{$yStart + ($yDimension div (4 div 3))}" y2="{$yStart + ($yDimension div (4 div 3))}"/>
            <xsl:apply-templates select="//chapter"/>
            <!--xsl:for-each select="$grammarDoc//type[contains($grammarTypes,text())]">
                <xsl:variable name="color" select="current()/@color"/>
                
                    <xsl:variable name="xPosition" select="(((position() - 1) div $numChapters)*$xDimension) + $xStart"/>
                    <xsl:variable name="mistakes" select="count(./descendant::sp[contains(@type, '{current()}')])"/>
                    <xsl:variable name="height" select="($mistakes div $yScaleDivisor) * $yDimension"/>
                    <xsl:variable name="yPosition" select="($yDimension - $height) + 50"/>
                    <xsl:variable name="chapter" select="current()/@number"/>
                    <rect opacity="{$opacity}" onmouseover="this.setAttributeNS(null,'fill','green')" onmouseout="this.setAttributeNS(null,'fill','{$color}')" onclick="window.open('{$urlPath}/read/chapter-{$chapter}/', '_self')" fill="red" x="{$xPosition}" y="{$yPosition}" width="{$xWidth}" height="{$height}" stroke="white" stroke-width="1">
                        <title><xsl:text>Chapter </xsl:text><xsl:value-of select="current()/@number"/></title>
                    </rect>
                
            </xsl:for-each>
            <text x="30" y="30"><xsl:value-of select="$grammarTypes"/></text-->
        </svg>
    </xsl:template>
    <xsl:template match="chapter">
        <xsl:variable name="chapter" select="./@number"/>
        <xsl:variable name="this" select="."/>
        <xsl:for-each select="$grammarDoc//type[contains($grammarTypes, text())]">
            <xsl:variable name="color" select="current()/@color"/>
            <xsl:variable name="xPosition" select="((($chapter - 1) div $numChapters)*$xDimension) + $xStart"/>
            <xsl:variable name="mistakes" select="count($this/descendant::grammar[contains(@type, current())])"/>
            <xsl:variable name="height" select="($mistakes div $yScaleDivisor) * $yDimension"/>
            <xsl:variable name="yPosition" select="($yDimension - $height) + 50"/>
            <rect opacity="{$opacity}" onmouseover="this.setAttributeNS(null,'fill','green')" onmouseout="this.setAttributeNS(null,'fill','{$color}')" onclick="window.open('{$urlPath}/read/chapter-{$chapter}/', '_self')" fill="{$color}" x="{$xPosition}" y="{$yPosition}" width="{$xWidth}" height="{$height}" stroke="white" stroke-width="1">
                <title><xsl:text>Chapter </xsl:text><xsl:value-of select="$chapter"/></title>
            </rect>
        </xsl:for-each>
        
    </xsl:template>
</xsl:stylesheet>