<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:param name="urlPath"/>
    <xsl:template match="/character|/location|/reference|/spell|/chapter">
        <div class="codexTableContainer">
            <table class="codexTable">
                <tr>
                    <td class="type" colspan="2">
                        <a>
                            <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                                    />/codex/<xsl:value-of select="name()"/>s/</xsl:attribute>
                            <xsl:value-of select="name()"/>
                        </a>
                    </td>
                </tr>
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
                                        />/images/<xsl:value-of select="picture"/></xsl:attribute>
                            </img>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="name() = 'chapter'">
                    <tr>
                        <td class="readLink" colspan="2">
                            <a>
                                <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                                        />/read/chapter-<xsl:value-of select="number"
                                    />/</xsl:attribute>
                                <xsl:text>Read</xsl:text>
                            </a>
                        </td>
                    </tr>
                </xsl:if>
                <tr>
                    <td colspan="2" class="separator">
                        <span style="display:none">-</span>
                    </td>
                </tr>
                <xsl:if test="editor">
                    <tr>
                        <th>Editor:</th>
                        <td>
                            <a>
                                <xsl:attribute name="href"><xsl:value-of select="href"
                                        />/about/<xsl:value-of select="editor/@handle"
                                    />/</xsl:attribute>
                                <xsl:value-of select="editor"/>
                            </a>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="precededBy">
                    <tr>
                        <th>Preceded by:</th>
                        <td>
                            <a>
                                <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                                        />/codex/entry/<xsl:value-of select="precededBy/@handle"
                                    />/</xsl:attribute>
                                <xsl:value-of select="precededBy"/>
                            </a>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="followedBy">
                    <tr>
                        <th>Followed by:</th>
                        <td>
                            <a>
                                <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                                        />/codex/entry/<xsl:value-of select="followedBy/@handle"
                                    />/</xsl:attribute>
                                <xsl:value-of select="followedBy"/>
                            </a>
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
                            <xsl:if test="canon/@series">
                                <xsl:text>, from </xsl:text>
                                <a>
                                    <xsl:attribute name="href"
                                            >http://en.wikipedia.org/wiki/<xsl:value-of
                                            select="canon/@series"/></xsl:attribute>
                                    <xsl:attribute name="target">_blank</xsl:attribute>
                                    <xsl:value-of select="canon/@series"/>
                                </a>
                            </xsl:if>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="gender">
                    <tr>
                        <th>Gender:</th>
                        <td>
                            <xsl:value-of select="gender"/>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="role">
                    <tr>
                        <th>Role:</th>
                        <td>
                            <xsl:value-of select="role"/>
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
                <xsl:if test="parent">
                    <tr>
                        <th><xsl:value-of select="parent/@type"/>:</th>
                        <td>
                            <a>
                                <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                                        />/codex/entry/<xsl:value-of select="parent/@handle"
                                    />/</xsl:attribute>
                                <xsl:value-of select="parent"/>
                            </a>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="lexica">
                    <tr>
                        <td colspan="2" class="separator">
                            <span style="display:none">-</span>
                        </td>
                    </tr>
                    <tr>
                        <th>Word Count:</th>
                        <td>
                            <xsl:value-of select="lexica/wordCount"/>
                        </td>
                    </tr>
                    <tr>
                        <th>Spelling Mistakes:</th>
                        <td>
                            <xsl:value-of select="lexica/spellingMistakes"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="separator">
                            <span style="display:none">-</span>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="totalOccurrence">
                    <tr>
                        <td colspan="2" class="separator">
                            <span style="display:none">-</span>
                        </td>
                    </tr>
                    <tr>
                        <th>Total occurrences:</th>
                        <td>
                            <xsl:value-of select="totalOccurrence"/>
                        </td>
                    </tr>
                    <xsl:if test="count(occurs) > 0">
                        <tr>
                            <th>First appears:</th>
                            <td>
                                <a>
                                    <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                                            />/codex/entry/chapter<xsl:value-of
                                            select="occurs[1]/@chapter"/>/</xsl:attribute> Chapter
                                        <xsl:value-of select="occurs[1]/@chapter"/>
                                </a>
                            </td>
                        </tr>
                    </xsl:if>
                    <xsl:if test="relativeFrequency">
                        <tr>
                            <th><xsl:value-of select="relativeFrequency/@relative"/> frequency:</th>
                            <td>
                                <xsl:if test="relativeFrequency/@moreFrequent">
                                    <!--<xsl:call-template name="intercodexLink">
                                <xsl:with-param name="passed-handle">
                                <xsl:value-of select="relativeFrequency/@nextFrequent"/>
                                </xsl:with-param>
                                <xsl:with-param name="passed-name">char</xsl:with-param>
                                <xsl:with-param name="passed-text">
                                <xsl:value-of select="relativeFrequency/@nextFrequent-Name"
                                />
                                </xsl:with-param>
                                </xsl:call-template>-->
                                    <a>
                                        <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                                                />/codex/entry/<xsl:value-of
                                                select="relativeFrequency/@moreFrequent"
                                            />/</xsl:attribute>
                                        <xsl:text>#</xsl:text>
                                        <xsl:value-of select="number(relativeFrequency/text()) - 1"/>
                                        <xsl:text>: </xsl:text>
                                        <xsl:value-of select="relativeFrequency/@moreFrequent-Name"
                                        />
                                    </a>
                                    <br/>
                                </xsl:if>
                                <xsl:text>#</xsl:text>
                                <xsl:value-of select="relativeFrequency"/>
                                <xsl:text>: </xsl:text>
                                <xsl:value-of select="name"/>
                                <xsl:if test="relativeFrequency/@nextFrequent">
                                    <!--<xsl:call-template name="intercodexLink">
                                    <xsl:with-param name="passed-handle">
                                        <xsl:value-of select="relativeFrequency/@nextFrequent"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="passed-name">char</xsl:with-param>
                                    <xsl:with-param name="passed-text">
                                        <xsl:value-of select="relativeFrequency/@nextFrequent-Name"
                                        />
                                    </xsl:with-param>
                                    </xsl:call-template>-->
                                    <br/>
                                    <a>
                                        <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                                                />/codex/entry/<xsl:value-of
                                                select="relativeFrequency/@nextFrequent"
                                            />/</xsl:attribute>
                                        <xsl:text>#</xsl:text>
                                        <xsl:value-of select="number(relativeFrequency/text()) + 1"/>
                                        <xsl:text>: </xsl:text>
                                        <xsl:value-of select="relativeFrequency/@nextFrequent-Name"
                                        />
                                    </a>
                                </xsl:if>
                            </td>
                        </tr>
                    </xsl:if>
                    <xsl:if test="totalFrequency">
                        <tr>
                            <th>Total frequency:</th>
                            <td>
                                <xsl:if test="totalFrequency/@moreFrequent">
                                    <a>
                                        <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                                                />/codex/entry/<xsl:value-of
                                                select="totalFrequency/@moreFrequent"
                                            />/</xsl:attribute>
                                        <xsl:text>#</xsl:text>
                                        <xsl:value-of select="number(totalFrequency/text()) - 1"/>
                                        <xsl:text>: </xsl:text>
                                        <xsl:value-of select="totalFrequency/@moreFrequent-Name"/>
                                    </a>
                                    <br/>
                                </xsl:if>
                                <xsl:text>#</xsl:text>
                                <xsl:value-of select="totalFrequency"/>
                                <xsl:text>: </xsl:text>
                                <xsl:value-of select="name"/>
                                <xsl:if test="totalFrequency/@nextFrequent">
                                    <br/>
                                    <a>
                                        <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                                                />/codex/entry/<xsl:value-of
                                                select="totalFrequency/@nextFrequent"
                                            />/</xsl:attribute>
                                        <xsl:text>#</xsl:text>
                                        <xsl:value-of select="number(totalFrequency/text()) + 1"/>
                                        <xsl:text>: </xsl:text>
                                        <xsl:value-of select="totalFrequency/@nextFrequent-Name"/>
                                    </a>
                                </xsl:if>
                            </td>
                        </tr>
                    </xsl:if>
                    <tr>
                        <td colspan="2" class="separator">
                            <span style="display:none">-</span>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="dialogueList">
                    <tr>
                        <th>Times spoken:</th>
                        <td>
                            <xsl:value-of select="count(dialogueList//quote)"/>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="wardrobe">
                    <tr>
                        <th>Known outfits:</th>
                        <td>
                            <xsl:value-of select="count(wardrobe//outfit)"/>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="count(alternateNames/name) > 0">
                    <xsl:variable name="countAlternateNames" select="count(alternateNames/name)"/>
                    <xsl:for-each select="alternateNames/name">
                        <tr>
                            <xsl:if test="position() = 1">
                                <th rowspan="{$countAlternateNames}">Also known as:</th>
                            </xsl:if>
                            <td>
                                <div class="bullet">
                                    <xsl:value-of select="current()"/>
                                </div>
                            </td>
                        </tr>
                    </xsl:for-each>
                </xsl:if>
            </table>
            <div style="clear:both;display:none;">-end-</div>
        </div>
        <div class="codexTableOfContents">
            <h1>Table of Contents</h1>
            <xsl:if test="count(video) > 0">
                <a href="#video">Video</a>
            </xsl:if>
            <xsl:if test="count(characters/character) > 0">
                <a href="#characters">Characters</a>
            </xsl:if>
            <xsl:if test="lexica">
                <a href="#lexica">Lexica</a>
            </xsl:if>
            <xsl:if test="count(relationships/*) > 0">
                <a href="#relations">Relations</a>
            </xsl:if>
            <xsl:if test="count(dialogueList//quote)">
                <a href="#dialogue">Dialogue</a>
            </xsl:if>
            <xsl:if test="count(wardrobe/outfit) > 0">
                <a href="#wardrobe">Wardrobe</a>
            </xsl:if>
        </div>
        <xsl:if test="count(video) > 0">
            <h2 class="codexHeader" id="video"><a href="#top" class="top">Top</a>Video</h2>
            <div id="mediaplayer" class="codexVideo">video goes here</div>
            <script type="text/javascript">jwplayer("mediaplayer").setup({flashplayer: "<xsl:value-of select="$urlPath"/>/addon-styles/player.swf",
			file: "<xsl:value-of select="$urlPath"/>/videos/<xsl:value-of select="video[1]"/>"});</script>
        </xsl:if>
        <xsl:if test="count(characters/character) > 0">
            <h2 class="codexHeader" id="characters"><a href="#top" class="top"
                >Top</a>Characters</h2>
            <xsl:for-each select="characters/character">
                <div class="bullet">
                    <a>
                        <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                                />/codex/entry/<xsl:value-of select="@handle"/>/</xsl:attribute>
                        <xsl:value-of select="."/>
                    </a>
                    <xsl:if test="count(@*[not(name() = 'handle')]) > 0">
                        <xsl:variable name="numberAttributes"
                            select="count(@*[not(name() = 'handle')])"/>
                        <xsl:text> (</xsl:text>
                        <xsl:for-each select="@*[not(name() = 'handle')]">
                            <xsl:choose>
                                <xsl:when test="name() = 'first'">First appearance</xsl:when>
                                <xsl:when test="name() = 'joinsUs'">Rejoins story</xsl:when>
                            </xsl:choose>
                            <xsl:if test="position() &lt; $numberAttributes">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                </div>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="lexica">
            <h2 class="codexHeader" id="lexica"><a href="#top" class="top">Top</a>Lexica</h2>
        </xsl:if>
        <xsl:if test="count(relationships/*) > 0">
            <h2 class="codexHeader" id="relations"><a href="#top" class="top">Top</a>Relations</h2>
            <xsl:for-each select="relationships/relation">
                <div class="bullet">
                    <span class="caps"><xsl:value-of select="@handle"/></span>
                    <xsl:for-each select="kiss|sex">
                        <xsl:sort select="chapter" data-type="number"/>
                        <div class="bullet">
                            <b>
                                <span class="caps"><xsl:value-of select="name()"/></span>
                                <xsl:text>:</xsl:text>
                            </b>
                            <xsl:text> "</xsl:text>
                            <xsl:value-of select="text"/>
                            <xsl:text>" (</xsl:text>
                            <a>
                                <xsl:attribute name="href"><xsl:value-of select="$urlPath"
                                        />/read/chapter-<xsl:value-of select="chapter"
                                    />/</xsl:attribute>
                                <xsl:text>Chapter </xsl:text>
                                <xsl:value-of select="chapter"/>
                            </a>
                            <xsl:text>)</xsl:text>
                        </div>
                    </xsl:for-each>
                </div>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="count(dialogueList//quote)">
            <h2 class="codexHeader" id="dialogue"><a href="#top" class="top">Top</a> Dialogue</h2>
            <div class="dialogueContainer">
                <xsl:for-each select="dialogueList/dialogue">
                    <div class="dialogueSubheader">
                        <h3 class="codexHeader"><a href="{$urlPath}/read/chapter-{@chapter}">
                            <xsl:text>Chapter </xsl:text>
                            <xsl:value-of select="@chapter"/>
                        </a>
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="count(quote)"/>
                        <xsl:text> quote</xsl:text>
                        <xsl:if test="not(count(quote) = 1)">s</xsl:if>
                        <xsl:text>)</xsl:text></h3>
                    </div>
                    <div class="dialogueQuotes">
                        <xsl:for-each select="quote">
                            <div class="quote">
                                <xsl:apply-templates mode="intercodexLink"/>
                            </div>
                        </xsl:for-each>
                    </div>
                </xsl:for-each>
            </div>
        </xsl:if>
        <xsl:if test="count(wardrobe/outfit) > 0">
            <h2 class="codexHeader" id="wardrobe"><a href="#top" class="top">Top</a> Wardrobe</h2>
            <xsl:if test="wardrobe/outfit">
                <xsl:for-each select="wardrobe/outfit">
                    <!--<xsl:value-of select="name(current())"/>
                    <xsl:apply-templates select="current()"/>-->

                    <div class="bullet">
                        <xsl:if test="length">
                            <xsl:value-of select="length"/>
                        </xsl:if>
                        <xsl:if test="color">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="color"/>
                        </xsl:if>
                        <xsl:if test="descrip">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="descrip"/>
                        </xsl:if>
                        <xsl:if test="material">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="material"/>
                        </xsl:if>
                        <xsl:if test="type">
                            <xsl:if test="type = 'corsetBra'">
                                <xsl:text> corset bra</xsl:text>
                            </xsl:if>
                            <xsl:if test="not(type = 'corsetBra')">
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="type"/>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="ornamentColor">
                            <xsl:text> with </xsl:text>
                            <xsl:value-of select="ornamentColor"/>
                        </xsl:if>
                        <xsl:if test="ornament">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="ornament"/>
                        </xsl:if>
                    </div>
                </xsl:for-each>

            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="outfit[type='t-shirt']">
        <svg width="700" height="555.97498" xmlns="http://www.w3.org/2000/svg" version="1.1">
            <g>
                <path fill="{color}" stroke="#000000" stroke-width="4.82387" stroke-linecap="square"
                    stroke-linejoin="bevel" stroke-miterlimit="3.5" stroke-dashoffset="0"
                    id="rect2160"
                    d="m169.061,2.41187l-166.64907,192.46896l119.33077,80.72803l48.98881,-56.57861l0,334.53287l358.5733,0l0,-334.49655l48.95251,56.5423l119.33075,-80.72803l-166.61273,-192.46896l-1.67053,1.12575l0,-1.12575l-57.05069,0c-23.73141,48.74488 -69.58813,81.78115 -122.23596,81.78115c-52.64783,-0.00002 -98.54083,-33.03627 -122.27226,-81.78115l-57.01439,0l0,1.12575l-1.6705,-1.12575z"/>
                <path fill="none" stroke-width="5" stroke-miterlimit="4" stroke-dashoffset="0"
                    id="path4173"
                    d="m280.117,382.12338c0,-30.33591 218.54483,-30.33591 218.54483,0m0,0c0,30.33594 -48.95404,54.95639 -109.27243,54.95639c-60.31836,0 -109.2724,-24.62045 -109.2724,-54.95639"
                />
            </g>
        </svg>
    </xsl:template>
    <xsl:template match="outfit[type='miniskirt']">
        <svg width="640" height="480" xmlns="http://www.w3.org/2000/svg">
            <!-- Created with SVG-edit - http://svg-edit.googlecode.com/ -->
            <path id="svg_1" d="m185,109l-49,203l383,0l-74.75412,-205l-259.24588,2z"
                stroke-width="5" stroke="#000000" fill="{color}"/>
        </svg>
    </xsl:template>
    <xsl:template match="char|place|ref|spell" mode="intercodexLink" name="intercodexLink">
        <xsl:param name="passed-handle" select="@handle"/>
        <xsl:param name="passed-name" select="name()"/>
        <xsl:param name="passed-text">~~~</xsl:param>
        <span>
            <xsl:attribute name="handle">
                <xsl:value-of select="$passed-handle"/>
            </xsl:attribute>
            <xsl:attribute name="elementName">
                <xsl:value-of select="$passed-name"/>
            </xsl:attribute>
            <xsl:attribute name="class">dialogObject <xsl:value-of select="$passed-name"
                /></xsl:attribute>
            <xsl:attribute name="onmouseover">Dialog.create(event, this);</xsl:attribute>
            <xsl:choose>
                <xsl:when test="$passed-text = '~~~'">
                    <xsl:apply-templates mode="intercodexLink"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$passed-text"/>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
</xsl:stylesheet>
