<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    <xsl:param name="urlPath"/>
    <xsl:param name="currentHandle"/>
    <xsl:param name="currentHandleType"/>
    <xsl:output indent="yes"/>
    <xsl:template match="/">
            <xsl:apply-templates select="codexData/characterList"/>
            <xsl:apply-templates select="codexData/locationList"/>
            <xsl:apply-templates select="codexData/referenceList"/>
            <xsl:apply-templates select="codexData/spellList"/>
    </xsl:template>
    <xsl:template match="characterList">
        <div id="codex-nav-character">
          <xsl:attribute name="class">codexNavContainer<xsl:if test="not($currentHandleType = 'character')"> collapsed</xsl:if></xsl:attribute>
          <div class="codexDropButton" onclick="codexNavToggle('character')">
            <xsl:text>Characters</xsl:text>
          </div>
            <xsl:for-each select="character">
                <xsl:sort select="name"/>
                <div><xsl:attribute name="class">codexItem<xsl:if test="$currentHandle = @lowerCaseHandle"><xsl:text> selected</xsl:text></xsl:if></xsl:attribute><a href="{$urlPath}/codex/characters/{./@handle}/"><xsl:value-of select="name"/></a></div>
            </xsl:for-each>
        </div>
    </xsl:template>
    <xsl:template match="locationList">
        <div id="codex-nav-location">
          <xsl:attribute name="class">codexNavContainer<xsl:if test="not($currentHandleType = 'location')"> collapsed</xsl:if></xsl:attribute>
          <div class="codexDropButton" onclick="codexNavToggle('location')">
            <xsl:text>Locations</xsl:text>
          </div>
            <xsl:for-each select="location">
                <div><xsl:attribute name="class">codexItem<xsl:if test="$currentHandle = @lowerCaseHandle"><xsl:text> selected</xsl:text></xsl:if></xsl:attribute><a href="{$urlPath}/codex/locations/{./@handle}/"><xsl:value-of select="name"/></a></div>
            </xsl:for-each>
        </div>
    </xsl:template>
    <xsl:template match="referenceList">
        <div id="codex-nav-reference">
          <xsl:attribute name="class">codexNavContainer<xsl:if test="not($currentHandleType = 'reference')"> collapsed</xsl:if></xsl:attribute>
          <div class="codexDropButton" onclick="codexNavToggle('reference')">
            <xsl:text>References</xsl:text>
          </div>
            <xsl:for-each select="reference">
                <div><xsl:attribute name="class">codexItem<xsl:if test="$currentHandle = @lowerCaseHandle"><xsl:text> selected</xsl:text></xsl:if></xsl:attribute><a href="{$urlPath}/codex/references/{./@handle}/"><xsl:value-of select="name"/></a></div>
            </xsl:for-each>
        </div>
    </xsl:template>
    <xsl:template match="spellList">
        <div id="codex-nav-spell">
          <xsl:attribute name="class">codexNavContainer<xsl:if test="not($currentHandleType = 'spell')"> collapsed</xsl:if></xsl:attribute>
          <div class="codexDropButton" onclick="codexNavToggle('spell')">
            <xsl:text>Spells</xsl:text>
          </div>
            <xsl:for-each select="spell">
                <div><xsl:attribute name="class">codexItem<xsl:if test="$currentHandle = @lowerCaseHandle"><xsl:text> selected</xsl:text></xsl:if></xsl:attribute><a href="{$urlPath}/codex/spells/{./@handle}/"><xsl:value-of select="name"/></a></div>
            </xsl:for-each>
        </div>
    </xsl:template>
</xsl:stylesheet>
