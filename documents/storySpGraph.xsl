<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="1.0">
    <xsl:output indent="yes"/>
    <xsl:variable name="xStart" select="80"/>
    <xsl:variable name="xEnd" select="650"/>
    <xsl:variable name="yStart" select="50"/>
    <xsl:variable name="yEnd" select="400"/>
    <xsl:variable name="yScaleDivisor" select="80"/>
    <xsl:variable name="xDimension" select="$xEnd - $xStart"/>
    <xsl:variable name="yDimension" select="$yEnd - $yStart"/>
    <xsl:variable name="numChapters" select="count(//chapter)"/>
    <xsl:variable name="xWidth" select="$xDimension div $numChapters"/>
    <xsl:param name="urlPath"/>
    <xsl:param name="spellingTypes"/>
    <xsl:param name="spellingTypeCount"/>
    <xsl:variable name="opacity">
        <xsl:if test="$spellingTypeCount > 1">0.7</xsl:if>
        <xsl:if test="$spellingTypeCount = 1">1.0</xsl:if>
    </xsl:variable>
    <xsl:variable name="colorDoc" select="document('spellingTypes.xml')"/>
    <xsl:template match="/">
        <svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%">
            
            <line stroke="black" stroke-width="2" x1="{$xStart - 3}" x2="{$xStart - 3}" y1="{$yStart - 10}" y2="{$yEnd + 3}"/>
            <text text-anchor="middle" y="{$yDimension + $yStart + ($yStart div 2)}" x="{$xStart + ($xDimension div 2)}">Chapter</text>
            <line stroke="black" stroke-width="2" x1="{$xStart - 3}" x2="{$xEnd}" y1="{$yEnd + 3}" y2="{$yEnd + 3}"/>
            <text y="{($yDimension div 2) + $yStart + 90}" x="{($xStart div 2) - 10}" transform="rotate(-90, {($xStart div 2) - 10}, {($yDimension div 2) + $yStart + 90})">Number of Spelling Mistakes</text>
            <text y="{$yStart + $yDimension}" x="{$xStart - 10}" transform="rotate(-180, {$xStart - 10}, {$yStart + $yDimension})">- 0</text>
            <text y="{$yStart + 4}" x="{$xStart - 35}">80 -</text>
            <line stroke="black" stroke-width="1" stroke-dasharray="3 3" x1="{$xStart - 3}" x2="{$xStart + $xDimension}" y1="{$yStart}" y2="{$yStart}"/>
            <text y="{$yStart + ($yDimension div 2) + 4}" x="{$xStart - 35}">40 -</text>
            <line stroke="black" stroke-width="1" stroke-dasharray="3 3" x1="{$xStart - 3}" x2="{$xStart + $xDimension}" y1="{$yStart + ($yDimension div 2)}" y2="{$yStart + ($yDimension div 2)}"/>
            <line stroke="black" stroke-width="1" stroke-dasharray="3 3" x1="{$xStart - 3}" x2="{$xStart + $xDimension}" y1="{$yStart + ($yDimension div 4)}" y2="{$yStart + ($yDimension div 4)}"/>
            <line stroke="black" stroke-width="1" stroke-dasharray="3 3" x1="{$xStart - 3}" x2="{$xStart + $xDimension}" y1="{$yStart + ($yDimension div (4 div 3))}" y2="{$yStart + ($yDimension div (4 div 3))}"/>
            <xsl:apply-templates select="//chapter"/>
            
        </svg><!--<rect fill="{$color}" x="0" y="0" width="100" height="100"/>-->
    </xsl:template>
    <xsl:template match="chapter">
        <xsl:variable name="chapter" select="./@number"/>
        <xsl:variable name="this" select="."/>
        <xsl:for-each select="$colorDoc//type[contains($spellingTypes,text())]">
            <xsl:if test="not(chapter = 41 and current() = 'phonetic') and not(chapter = 42 and current() = 'phonetic')">
                <xsl:variable name="color" select="current()/@color"/>
                <xsl:variable name="xPosition" select="((($chapter - 1) div $numChapters)*$xDimension) + $xStart"/>
                <xsl:variable name="mistakes" select="count($this/descendant::sp[contains(@type, current())])"/>
                <xsl:variable name="height" select="($mistakes div $yScaleDivisor) * $yDimension"/>
                <xsl:variable name="yPosition" select="($yDimension - $height) + 50"/>
                <rect opacity="{$opacity}" onmouseover="this.setAttributeNS(null,'fill','black')" onmouseout="this.setAttributeNS(null,'fill','{$color}')" onclick="window.open('{$urlPath}/read/chapter-{$chapter}/', '_self')" fill="{$color}" x="{$xPosition}" y="{$yPosition}" width="{$xWidth}" height="{$height}" stroke="white" stroke-width="1">
                    <title><xsl:text>Chapter </xsl:text><xsl:value-of select="$chapter"/><xsl:text>
Mistake Count - </xsl:text><xsl:value-of select="$mistakes"/></title>
                </rect>
            </xsl:if>
                <xsl:if test="$chapter = 41 and contains(current(), 'phonetic')">
                    <xsl:variable name="color" select="current()/@color"/>
                    <defs>
                        <linearGradient id="grad1" x1="0%" y1="70%" x2="0%" y2="40%">
                            <stop offset="0%" style="stop-color:rgb(186,85,211);stop-opacity:1" />
                            <stop offset="100%" style="stop-color:rgb(0,0,0);stop-opacity:1" />
                        </linearGradient>
                    </defs>
                    <xsl:variable name="xPosition" select="((($chapter - 1) div $numChapters)*$xDimension) + $xStart"/>
                    <xsl:variable name="mistakes" select="count($this/descendant::sp[contains(@type, current())])"/>
                    <xsl:variable name="height" select="($mistakes div $yScaleDivisor) * $yDimension"/>
                    <xsl:variable name="yPosition" select="($yDimension - $height) + 50"/>
                    <rect opacity="{$opacity}" onmouseover="this.setAttributeNS(null,'fill','black')" onmouseout="this.setAttributeNS(null,'fill','url(#grad1)')" onclick="window.open('{$urlPath}/read/chapter-{$chapter}/', '_self')" fill="url(#grad1)" x="{$xPosition}" y="{$yPosition}" width="{$xWidth}" height="{$height}" stroke="white" stroke-width="1">
                        <title><xsl:text>Chapter </xsl:text><xsl:value-of select="$chapter"/><xsl:text>
Mistake Count - </xsl:text><xsl:value-of select="$mistakes"/></title>
                    </rect>
                </xsl:if>
                <xsl:if test="$chapter = 42 and contains(current(), 'phonetic')">
                    <circle cx="70" cy="447" r="4" stroke="white" stroke-dasharray="2 2" stroke-width="4" fill="white"/>
                    <text x="80" y="450" fill="rgb(211, 211, 211)">- This marker represents an extreme outlier in spelling mistakes. Chapter 41 has</text>
                    <text x="87" y="463" fill="rgb(211, 211, 211)">137 phonetic spelling mistakes, and Chapter 42 has 148 phonetic spelling mistakes.</text>
                    <xsl:variable name="color" select="current()/@color"/>
                    <defs>
                        <linearGradient id="grad1" x1="0%" y1="70%" x2="0%" y2="40%">
                            <stop offset="0%" style="stop-color:rgb(186,85,211);stop-opacity:1" />
                            <stop offset="100%" style="stop-color:rgb(0,0,0);stop-opacity:1" />
                        </linearGradient>
                    </defs>
                    <xsl:variable name="xPosition" select="((($chapter - 1) div $numChapters)*$xDimension) + $xStart"/>
                    <xsl:variable name="mistakes" select="count($this/descendant::sp[contains(@type, current())])"/>
                    <xsl:variable name="height" select="($mistakes div $yScaleDivisor) * $yDimension"/>
                    <xsl:variable name="yPosition" select="($yDimension - $height) + 50"/>
                    <rect opacity="{$opacity}" onmouseover="this.setAttributeNS(null,'fill','black')" onmouseout="this.setAttributeNS(null,'fill','url(#grad1)')" onclick="window.open('{$urlPath}/read/chapter-{$chapter}/', '_self')" fill="url(#grad1)" x="{$xPosition}" y="{$yPosition}" width="{$xWidth}" height="{$height}" stroke="white" stroke-width="1">
                        <title><xsl:text>Chapter </xsl:text><xsl:value-of select="$chapter"/><xsl:text>
Mistake Count - </xsl:text><xsl:value-of select="$mistakes"/></title>
                    </rect>
                    <circle cx="{$xPosition + $xWidth + 2}" cy="40" r="4" stroke="white" stroke-dasharray="2 2" stroke-width="4" fill="white"/>
                    <circle cx="{$xPosition}" cy="40" r="4" stroke="white" stroke-dasharray="2 2" stroke-width="4" fill="white"/>
                </xsl:if>
         </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>