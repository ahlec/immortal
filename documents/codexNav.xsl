<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:param name="urlPath"/>
    <xsl:param name="currentHandle"/>
    <xsl:param name="currentHandleType"/>
    <xsl:output indent="yes"/>
    <xsl:template match="/">
        <xsl:apply-templates select="codexData/characterList"/>
        <xsl:apply-templates select="codexData/locationList"/>
        <xsl:apply-templates select="codexData/referenceList"/>
        <xsl:apply-templates select="codexData/spellList"/>
        <xsl:apply-templates select="codexData/chapters"/>
    </xsl:template>
    <xsl:template match="characterList">
        <div id="codex-nav-character">
            <xsl:attribute name="class">codexTop<xsl:if test="$currentHandleType = 'character'">
                    highlighted</xsl:if></xsl:attribute>
            <a>
                <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                    />/codex/characters/</xsl:attribute>
                <xsl:text>Characters</xsl:text>
            </a>
            <div>
                <xsl:attribute name="class">codexMenu<xsl:if test="$currentHandleType = 'character'"
                        > highlighted</xsl:if></xsl:attribute>
                <xsl:variable name="characters" select="character"/>
                <xsl:for-each select="role">
                    <xsl:variable name="role" select="current()"/>
                    <div>
                        <xsl:attribute name="class">codexSubmenu<xsl:if
                                test="$currentHandleType = 'character' and $characters[role = $role and @lowerCaseHandle = $currentHandle]"
                                > highlighted</xsl:if></xsl:attribute>
                        <a>
                            <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                                    />/codex/characters/<xsl:value-of select="@lower"
                                />/</xsl:attribute>
                            <xsl:value-of select="$role"/>
                        </a>
                        <div>
                            <xsl:attribute name="class">codexMenu final<xsl:if
                                    test="$currentHandleType = 'character' and $characters[role = $role and @lowerCaseHandle = $currentHandle]"
                                    > highlighted</xsl:if></xsl:attribute>

                            <xsl:for-each select="$characters[role = $role]">
                                <xsl:sort select="name"/>
                                <a href="{$urlPath}/codex/entry/{./@handle}/">
                                    <xsl:attribute name="class">codexItem<xsl:if
                                            test="$currentHandle = @lowerCaseHandle"
                                            ><xsl:text> selected</xsl:text></xsl:if></xsl:attribute>
                                    <xsl:value-of select="name"/>
                                </a>

                            </xsl:for-each>

                        </div>
                    </div>
                </xsl:for-each>

            </div>
        </div>
    </xsl:template>
    <xsl:template match="locationList">
        <div id="codex-nav-location">
            <xsl:attribute name="class">codexTop<xsl:if test="$currentHandleType = 'location'">
                    highlighted</xsl:if></xsl:attribute>
            <a>
                <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                    />/codex/locations/</xsl:attribute>
                <xsl:text>Locations</xsl:text>
            </a>
            <div>
                <xsl:attribute name="class">codexMenu<xsl:if test="$currentHandleType = 'location'">
                        highlighted</xsl:if></xsl:attribute>
                <div class="codexSubmenu">
                    <a>
                        <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                            />/codex/locations/present/</xsl:attribute>
                        <xsl:text>Present</xsl:text>
                    </a>
                    <div>
                        <xsl:attribute name="class">codexMenu final<xsl:if
                                test="$currentHandleType = 'location' and location[(pastVersion or not(presentDay)) and @lowerCaseHandle = $currentHandle]"
                                > highlighted</xsl:if></xsl:attribute>
                        <xsl:for-each select="location[pastVersion or not(presentDay)]">
                            <xsl:sort select="name"/>
                            <a href="{$urlPath}/codex/entry/{./@handle}/">
                                <xsl:attribute name="class">codexItem<xsl:if
                                        test="$currentHandle = @lowerCaseHandle"
                                        ><xsl:text> selected</xsl:text></xsl:if></xsl:attribute>
                                <xsl:value-of select="name"/>
                            </a>
                        </xsl:for-each>
                    </div>
                </div>
                <div class="codexSubmenu">
                    <a>
                        <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                            />/codex/locations/past/</xsl:attribute>
                        <xsl:text>Past</xsl:text>
                    </a>
                    <div>
                        <xsl:attribute name="class">codexMenu final<xsl:if
                                test="$currentHandleType = 'location' and location[presentDay and @lowerCaseHandle = $currentHandle]"
                                > highlighted</xsl:if></xsl:attribute>
                        <xsl:for-each select="location[presentDay]">
                            <xsl:sort select="name"/>
                            <a href="{$urlPath}/codex/entry/{./@handle}/">
                                <xsl:attribute name="class">codexItem<xsl:if
                                        test="$currentHandle = @lowerCaseHandle"
                                        ><xsl:text> selected</xsl:text></xsl:if></xsl:attribute>
                                <xsl:value-of select="name"/>
                            </a>
                        </xsl:for-each>
                    </div>
                </div>

            </div>
        </div>
    </xsl:template>
    <xsl:template match="referenceList">
        <div id="codex-nav-reference">
            <xsl:attribute name="class">codexTop<xsl:if test="$currentHandleType = 'reference'">
                    highlighted</xsl:if></xsl:attribute>
            <a>
                <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                    />/codex/references/</xsl:attribute>
                <xsl:text>References</xsl:text>
            </a>
            <div>
                <xsl:attribute name="class">codexMenu<xsl:if test="$currentHandleType = 'reference'"
                        > highlighted</xsl:if></xsl:attribute>
                <xsl:variable name="references" select="reference"/>
                <xsl:for-each select="type">
                    <xsl:variable name="type" select="current()"/>

                    <div class="codexSubmenu">
                        <a>
                            <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                                    />/codex/references/<xsl:value-of select="@handle"
                                />/</xsl:attribute>
                            <xsl:value-of select="$type"/>
                        </a>
                        <div>
                            <xsl:attribute name="class">codexMenu final<xsl:if
                                    test="$currentHandleType = 'reference' and $references[type = $type and @lowerCaseHandle = $currentHandle]"
                                    > highlighted</xsl:if></xsl:attribute>
                            <xsl:for-each select="$references[type = $type]">
                                <xsl:sort select="name"/>
                                <a href="{$urlPath}/codex/entry/{./@handle}/">
                                    <xsl:attribute name="class">codexItem<xsl:if
                                            test="$currentHandle = @lowerCaseHandle"
                                            ><xsl:text> selected</xsl:text></xsl:if></xsl:attribute>
                                    <xsl:value-of select="name"/>
                                </a>

                            </xsl:for-each>
                        </div>
                    </div>
                </xsl:for-each>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="spellList">
        <div id="codex-nav-spell">
            <xsl:attribute name="class">codexTop<xsl:if test="$currentHandleType = 'spell'">
                    highlighted</xsl:if></xsl:attribute>
            <a>
                <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                    />/codex/spells/</xsl:attribute>
                <xsl:text>Spells</xsl:text>
            </a>
            <div>
                <xsl:attribute name="class">codexMenu final<xsl:if
                        test="$currentHandleType = 'spell'"> highlighted</xsl:if></xsl:attribute>
                <xsl:for-each select="spell">
                    <xsl:sort select="name"/>
                    <a href="{$urlPath}/codex/entry/{./@handle}/">
                        <xsl:attribute name="class">codexItem<xsl:if
                                test="$currentHandle = @lowerCaseHandle"
                                ><xsl:text> selected</xsl:text></xsl:if></xsl:attribute>
                        <xsl:value-of select="name"/>
                    </a>

                </xsl:for-each>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="chapters">
        <div id="codex-nav-chapters">
            <xsl:attribute name="class">codexTop<xsl:if test="$currentHandleType = 'chapter'">
                    highlighted</xsl:if></xsl:attribute>
            <a>
                <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                    />/codex/chapters/</xsl:attribute>
                <xsl:text>Chapters</xsl:text>
            </a>


            <div>
                <xsl:attribute name="class">codexMenu<xsl:if test="$currentHandleType = 'chapter'">
                        highlighted</xsl:if></xsl:attribute>
                <xsl:variable name="chapters" select="chapter"/>
                <xsl:for-each select="range">
                    <xsl:variable name="range" select="current()"/>
                    <xsl:variable name="iterateChapters"
                        select="$chapters[number(child::number/text()) >= $range/@start and number(child::number/text()) &lt;= $range/@end]"/>
                    <div class="codexSubmenu">
                        <a>
                            <xsl:attribute name="href">#</xsl:attribute>
                            <xsl:text>Chapters </xsl:text>
                            <xsl:value-of select="@start"/>
                            <xsl:text> - </xsl:text>
                            <xsl:value-of select="@end"/>
                        </a>
                        <div>
                            <xsl:attribute name="class">codexMenu final</xsl:attribute>
                            <xsl:for-each select="$iterateChapters">
                                <xsl:sort select="name"/>
                                <a href="{$urlPath}/codex/entry/{./@handle}/">
                                    <xsl:attribute name="class">codexItem<xsl:if
                                            test="$currentHandle = @lowerCaseHandle"
                                            ><xsl:text> selected</xsl:text></xsl:if></xsl:attribute>
                                    <xsl:value-of select="name"/>
                                </a>

                            </xsl:for-each>
                        </div>
                    </div>
                </xsl:for-each>

            </div>
            <!--
            <div>
                <xsl:attribute name="class">codexMenu final<xsl:if test="$currentHandleType = 'chapter'">
                    highlighted</xsl:if></xsl:attribute>
                <xsl:for-each select="chapter">
                    <xsl:sort select="current()/number" data-type="number" />
                    <a href="{$urlPath}/codex/entry/{./@handle}/">
                        <xsl:attribute name="class">codexItem<xsl:if
                            test="$currentHandle = @lowerCaseHandle"
                            ><xsl:text> selected</xsl:text></xsl:if></xsl:attribute>
                        <xsl:value-of select="name"/>
                    </a>
                </xsl:for-each>
            </div>-->
        </div>
    </xsl:template>
</xsl:stylesheet>
