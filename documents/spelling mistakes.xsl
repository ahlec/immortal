<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY larr "&#8592;"> ]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    <xsl:template match="/">
        <style>
            div.entry
            {
                position : relative;
                border-bottom : 1px solid black;
            }
            div.entry div.word
            {
                position : absolute;
                text-align : center;
                font-weight : bold;
                left : 0px;
                top : 50%;
                margin-top : -8px;
                width : 200px;
                overflow : hidden;
                max-width : 200px;
            }
            div.entry ul
            {
                margin : 0px;
                margin-left : 200px;
            }</style>
        <xsl:for-each-group
            group-by="lower-case(if(sp) then(normalize-space(string-join(sp/@intended, ' '))) else (normalize-space(string-join(text(), ''))))"
            select="//sp">
            <xsl:sort select="current-grouping-key()"/>
            <div class="entry">
                <xsl:attribute name="style">background-color:<xsl:value-of
                        select="if(position() mod 2 = 1) then('#B2DFEE') else('#C3E4ED')"
                    /></xsl:attribute>
                <div class="word">
                    <xsl:value-of select="current-grouping-key()"/>
                </div>
                <ul>
                    <xsl:if test="count(distinct-values(current-group()/@type)) > 1">
                        <xsl:attribute name="style">border:3px solid red;</xsl:attribute>
                    </xsl:if>
                    <xsl:for-each-group group-by="@type" select="current-group()">
                        <xsl:apply-templates select="current()">
                            <xsl:with-param name="instances" select="count(current-group())"/>
                        </xsl:apply-templates>
                    </xsl:for-each-group>
                </ul>
            </div>
        </xsl:for-each-group>
    </xsl:template>
    <xsl:template match="sp">
        <xsl:param name="instances"/>
        <li>
            <xsl:variable name="input"
                select="if(sp) then(normalize-space(string-join(sp/@intended, ' '))) else(normalize-space(string-join(text(), '')))"/>
            <xsl:variable name="output"
                select="normalize-space(@intended)"/>
            <xsl:if test="(contains($input, string(&quot;&apos;&quot;)) and not(contains($output, string(&quot;&apos;&quot;))))
                or (contains($output, string(&quot;&apos;&quot;)) and not(contains($input, string(&quot;&apos;&quot;))))">
                <xsl:attribute name="style">border:3px solid green;text-decoration:underline;</xsl:attribute>
            </xsl:if>
            <xsl:if test="lower-case($input) = lower-case($output)">
                <xsl:attribute name="style">border:3px solid blue;text-decoration:</xsl:attribute>
            </xsl:if>
            <b><xsl:value-of select="$input"/></b> --> <b><xsl:value-of
                    select="$output"/></b> (<xsl:value-of select="@type"/>)
            -------> <small><xsl:value-of select="$instances"/> time<xsl:if
                    test="not($instances = 1)">s</xsl:if></small>
        </li>
    </xsl:template>
</xsl:stylesheet>
