<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:param name="urlPath"/>
    <xsl:template match="reference|character|location|spell">
        <div class="codexTableContainer">
            <table class="codexTable">
                <tr>
                    <td class="header" colspan="2">
                        <xsl:value-of select="name"/>
                    </td>
                </tr>
                <xsl:if test="picture">
                    <tr>
                        <td class="picture" colspan="2">
                            <img>
                                <xsl:attribute name="src"><xsl:value-of select="$urlPath"
                                        />/images/references/<xsl:value-of select="picture"
                                    /></xsl:attribute>
                            </img>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="canon">
                    <tr>
                        <th>Canon:</th>
                        <td>
                            <a>
                                <xsl:attribute name="href"
                                        >http://en.wikipedia.org/wiki/<xsl:value-of
                                        select="canon/@wikipedia"/></xsl:attribute>
                                <xsl:attribute name="target">_blank</xsl:attribute>
                                <xsl:value-of select="canon"/>
                            </a>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="series">
                    <tr>
                        <th>Series:</th>
                        <td>
                            <a>
                                <xsl:attribute name="href"
                                    >http://en.wikipedia.org/wiki/<xsl:value-of
                                        select="series/@wikipedia"/></xsl:attribute>
                                <xsl:attribute name="target">_blank</xsl:attribute>
                                <xsl:value-of select="series"/>
                            </a>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="type">
                    <tr>
                        <th>Type:</th>
                        <td>
                                <xsl:value-of select="type"/>
                        </td>
                    </tr>
                </xsl:if>
                <tr>
                    <th>Total occurrences:</th>
                    <td>
                        <xsl:value-of select="totalOccurrence"/>
                    </td>
                </tr>
                <xsl:if test="count(occurs) > 0">
                    <tr>
                        <th>First occurs:</th>
                        <td>
                            <a>
                                <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                                        />/read/chapter-<xsl:value-of select="occurs[1]/@chapter"
                                    /></xsl:attribute> Chapter <xsl:value-of
                                    select="occurs[1]/@chapter"/></a>
                        </td>
                    </tr>
                </xsl:if>
            </table>
        </div>
        <xsl:if test="count(video) > 0">
            <xsl:for-each select="video">
                <div id="mediaplayer"/>
                <script type="text/javascript">
		jwplayer("mediaplayer").setup({
			flashplayer: "<xsl:value-of select="$urlPath"/>/addon-styles/player.swf",
			file: "<xsl:value-of select="$urlPath"/>/videos/<xsl:value-of select="current()"/>"
		});
	</script>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template match="char|place|ref|spell" mode="intercodexLink">
        <span>
            <xsl:attribute name="handle">
                <xsl:value-of select="@handle"/>
            </xsl:attribute>
            <xsl:attribute name="elementName">
                <xsl:value-of select="name()"/>
            </xsl:attribute>
            <xsl:attribute name="class">dialogObject <xsl:value-of select="name()"/></xsl:attribute>
            <xsl:attribute name="onmouseover">Dialog.create(this);</xsl:attribute>
            <xsl:apply-templates mode="intercodexLink"/>
        </span>
    </xsl:template>
</xsl:stylesheet>
