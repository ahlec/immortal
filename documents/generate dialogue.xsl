<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:immortal="http://deitloff.com" version="2.0">
    <xsl:output version="1.1" method="xml" indent="yes" undeclare-prefixes="no"
        exclude-result-prefixes="#all" omit-xml-declaration="yes"/>
    <xsl:template match="/">
        <xsl:element name="dialogueList">
            <xsl:for-each select="document('website data.xml')/websiteReference/characters/character[@hasProfilePicture]">
                <xsl:element name="character">
                    <xsl:attribute name="handle" select="current()/@handle"/>
                    <xsl:attribute name="profilePicture" select="concat(current()/@handle, '.png')"/>
                    <xsl:value-of select="normalize-space(document('immortal.xml')/troll/meta/characterList/character[./@handle eq current()/@handle])"/>
                </xsl:element>
            </xsl:for-each>
            <xsl:apply-templates select="//dialogue[not(.//poc) and contains(normalize-space(.),' ')]"/>
        </xsl:element>
    </xsl:template>
    <xsl:function name="immortal:getCharactersByHandle">
        <xsl:param name="handleIDREFS"/>
        <xsl:sequence
            select="subsequence(document('immortal.xml')//characterList/character[contains($handleIDREFS, @handle)], 0)"
        />
    </xsl:function>
    <xsl:template match="dialogue">
        <xsl:variable name="chapterNumber" select="ancestor-or-self::chapter/@number"/>
        <xsl:variable name="paragraphNumber"
            select="ancestor-or-self::paragraph/(count(preceding-sibling::paragraph) + 1)"/>
        <xsl:variable name="sentenceNumber"
            select="ancestor-or-self::sentence/(count(preceding-sibling::sentence) + 1)"/>
        <xsl:variable name="dialogueText" select="normalize-space(.)"/>
        <xsl:for-each select="immortal:getCharactersByHandle(@handle)">
            <xsl:if test="document('website data.xml')/websiteReference/characters/character[./@handle eq current()/@handle and @hasProfilePicture]">
                <xsl:element name="dialogue">
                    <xsl:attribute name="handle">
                        <xsl:value-of select="current()/@handle"/>
                    </xsl:attribute>
                    <xsl:attribute name="chapter" select="$chapterNumber"/>
                    <xsl:attribute name="paragraph" select="$paragraphNumber"/>
                    <xsl:attribute name="sentence" select="$sentenceNumber"/>
                    <xsl:value-of select="normalize-space($dialogueText)"/>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
