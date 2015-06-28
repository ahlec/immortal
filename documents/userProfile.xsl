<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:param name="urlPath"/>
    <xsl:template match="user">
        <img>
            <xsl:attribute name="src">
                <xsl:value-of select="$urlPath"/>
                <xsl:value-of select="image"/>
            </xsl:attribute>
            <xsl:attribute name="class">profilePicture</xsl:attribute>
        </img>
        <h1>
            <xsl:value-of select="firstName"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="lastName"/>
        </h1>
        <b>E-mail:</b><xsl:text> </xsl:text>
        <a>
            <xsl:attribute name="href">mailto:<xsl:value-of select="email"/></xsl:attribute>
            <xsl:value-of select="email"/>
        </a>
        <br/>
        <b>Major<xsl:if test="not(count(majors/major) = 1)"></xsl:if>s:</b><xsl:text> </xsl:text>
        <xsl:for-each select="majors/major">
            <xsl:value-of select="current()"/>
            <xsl:choose>
                <xsl:when test="position() = count(parent::majors/major)"/>
                <xsl:when test="position() = count(parent::majors/major) - 1"><xsl:text> and </xsl:text></xsl:when>
                <xsl:otherwise><xsl:text>, </xsl:text></xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>

