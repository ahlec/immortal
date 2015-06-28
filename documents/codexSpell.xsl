<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:param name="urlPath"/>
    <xsl:template match="//location">
        <h1>
            <xsl:value-of select="name"/>
        </h1>
        <table class="codexTable">
            <tr>
                <th><i>Canon</i>:</th>
                <td>
                    <xsl:value-of select="hpName"/>
                </td>
            </tr>
            <tr>
                <th>Total Occurrences:</th>
                <td>
                    <xsl:value-of select="totalOccurrence"/>
                </td>
            </tr>
            <xsl:if test="pastVersion">
                <tr>
                    <th>Past Version:</th>
                    <td>
                        <a>
                            <xsl:attribute name="href"><xsl:value-of select="$urlPath"/>/codex/locations/<xsl:value-of select="pastVersion/@handle"/>/</xsl:attribute>
                            <xsl:value-of select="pastVersion"/>
                        </a>
                    </td>
                </tr>
            </xsl:if><xsl:if test="presentDay">
                <tr>
                    <th>Present Day:</th>
                    <td>
                        <a>
                            <xsl:attribute name="href"><xsl:value-of select="$urlPath"/>/codex/locations/<xsl:value-of select="presentDay/@handle"/>/</xsl:attribute>
                            <xsl:value-of select="presentDay"/>
                        </a>
                    </td>
                </tr>
            </xsl:if>
        </table>
    </xsl:template>
    <xsl:template match="char|place|ref|spell" mode="intercodexLink">
        <span>
            <xsl:attribute name="handle"><xsl:value-of select="@handle"/></xsl:attribute>
            <xsl:attribute name="elementName"><xsl:value-of select="name()"/></xsl:attribute>
            <xsl:attribute name="class">dialogObject <xsl:value-of select="name()"/></xsl:attribute>
            <xsl:attribute name="onmouseover">Dialog.create(this);</xsl:attribute>
            <xsl:apply-templates mode="intercodexLink"/>
        </span>
    </xsl:template>
</xsl:stylesheet>
