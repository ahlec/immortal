<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:immortal="http://deitloff.com" version="2.0">
    <xsl:template match="troll">
        <html>
            <head>
                <title>
                    <xsl:value-of select="//meta/title"/>
                </title>
                <style>
                    * {
                        font-family : arial;
                    }
                    body {
                        background-color : #9AC0CD;
                    }
                    h1,
                    h2 {
                        padding : 0px;
                        margin : 0px;
                        background-color : #B0E0E6;
                        cursor : pointer;
                    }
                    h1 {
                        font-size : 18px;
                    }
                    h2 {
                        font-size : 12px;
                    }
                    div.chapter
                    {
                        border : 1px solid black;
                        padding : 3px;
                        margin : 5px 10px 5px 10px;
                        background-color : #E0EEEE;
                    }
                    div.chapterBody {
                        clear : right;
                    }
                    div.chapter.hidden div.chapterBody {
                        display : none;
                    }
                    div.chapter.hidden h1,
                    div.chapter.hidden h2,
                    div.chapter.hidden div.chapterInfo {
                        display : block;
                    }
                    div.chapter.hidden h2 span {
                        display : inline;
                    }
                    div.chapterInfo
                    {
                        display : block;
                        float : right;
                        margin-right : 20px;
                    }
                    div.chapter div.chapterInfo div.counter,
                    div.chapter.hidden div.chapterInfo div.counter
                    {
                        float : right;
                        width : auto;
                        display : block-inline;
                        padding-left : 5px;
                        padding-right : 5px;
                        height : 35px;
                        text-align : center;
                        font-weight : bold;
                        cursor : default;
                        margin-left : 5px;
                        background-color : white;
                        border-radius : 10px;
                        border : 1px dashed black;
                    }
                    div.chapter div.chapterInfo div.counter div,
                    div.chapter.hidden div.chapterInfo div.counter div
                    {
                        font-size : 80%;
                        color : #5C5C5C;
                    }
                    img.pointOfContention
                    {
                        cursor : help;
                    
                    }
                    span.spellingMistake {
                        cursor : pointer;
                        font-weight : bold;
                        color : green;
                    }
                    span.redact
                    {
                        border-bottom:1px dotted #C76114;
                        color:#C76114;
                        cursor:e-resize;
                    }
                    span.redact.shown span.proposed, span.redact span.original { display:none; }
                    span.redact.shown span.original, span.redact span.proposed { display:inline;
                </style>
                <script>
                    var currentChapter = null;
                    function toggleChapter(chapterNumber)
                    {
                      if (currentChapter != null &amp;&amp; currentChapter != chapterNumber)
                        document.getElementById('chapter' + currentChapter).className = "chapter hidden";
                      document.getElementById('chapter' + chapterNumber).className =
                        (document.getElementById('chapter' + chapterNumber).className == "chapter hidden" ?
                            "chapter" : "chapter hidden");
                      currentChapter = chapterNumber;
                      window.location.hash = (document.getElementById('chapter' + chapterNumber).className == "chapter" ?
                        chapterNumber : null);
                    }
                    function scrollPageByKeyboard(e)
                    {
                      if (!e) var e = window.event;
                    }
                    function reloadPage()
                    {
                        if (window.location.hash.length > 0)
                        {
                            toggleChapter(window.location.hash.replace("#", ""));
                        }
                    }
                    function showPointOfContention(text)
                    {
                        alert(text);
                    }
                </script>
            </head>
            <body onkeypress="scrollPageByKeyboard();" onload="reloadPage()">
                <xsl:for-each-group select="//story/chapter[count(descendant::*) &gt; 0]"
                    group-by=".">
                    <A>
                        <xsl:attribute name="name">
                            <xsl:value-of select="./@number"/>
                        </xsl:attribute>
                    </A>
                    <div id="chapter{./@number}" class="chapter hidden">
                        <div>
                            <xsl:attribute name="class">chapterInfo</xsl:attribute>
                            <xsl:variable name="chapterPlayers"
                                select="distinct-values(immortal:getCharactersByHandle(string-join(.//char/@handle, ' ')))"/>
                            <div>
                                <xsl:attribute name="onclick">alert("Chapter Characters\n-------------------------------\n<xsl:for-each
                                        select="$chapterPlayers"><xsl:value-of
                                            select="normalize-space(current())"/>\n</xsl:for-each>");</xsl:attribute>
                                <xsl:attribute name="class">counter</xsl:attribute>
                                <xsl:attribute name="title">Click to see characters in this
                                    chapter.</xsl:attribute>
                                <xsl:attribute name="style"
                                    >cursor:pointer;background-color:#7BBF6A;</xsl:attribute>
                                <div>Characters</div>
                                <xsl:value-of select="count($chapterPlayers)"/>
                            </div>
                            <xsl:if test="count(.//spell) > 0">
                                <div>
                                    <xsl:attribute name="class">counter</xsl:attribute>
                                    <div>Spells</div>
                                    <xsl:value-of select="count(.//spell)"/>
                                </div>
                            </xsl:if>
                            <xsl:if test="count(.//paradox) > 0">
                                <div>
                                    <xsl:attribute name="class">counter</xsl:attribute>
                                    <div>Paradoxes</div>
                                    <xsl:value-of select="count(.//paradox)"/>
                                </div>
                            </xsl:if>
                            <xsl:if test="count(.//separation) &lt; 1">
                                <div>
                                    <xsl:attribute name="class">counter</xsl:attribute>
                                    <div>Separations</div>
                                    <span style="color:red;">0</span>
                                </div>
                            </xsl:if>
                            <xsl:if test="count(.//poc) > 0">
                                <div>
                                    <xsl:attribute name="class">counter</xsl:attribute>
                                    <xsl:attribute name="style"
                                        >background-color:#F08080;</xsl:attribute>
                                    <div>Points of Contention</div>
                                    <xsl:value-of select="count(.//poc)"/>
                                </div>
                            </xsl:if>
                            <div style="clear:both;"/>
                        </div>
                        <h1 onclick="toggleChapter({./@number});">Chapter <xsl:value-of
                                select="./@number"/><xsl:if test="./title"> - <xsl:apply-templates
                                    select=".//title"/></xsl:if></h1>
                        <h2 onclick="toggleChapter({./@number});">Edited by <xsl:apply-templates
                                select="@editor"/></h2>
                        <div>
                            <xsl:attribute name="class">chapterBody</xsl:attribute>
                            <xsl:apply-templates select="./an | ./paragraph | ./separation"/>
                        </div>
                    </div>
                </xsl:for-each-group>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="@editor">
        <span>
            <xsl:choose>
                <xsl:when test=". eq 'Jacob'">
                    <xsl:attribute name="style">color:green;</xsl:attribute>
                </xsl:when>
                <xsl:when test=". eq 'Eric'">
                    <xsl:attribute name="style">color:#FF6600;</xsl:attribute>
                </xsl:when>
                <xsl:when test=". eq 'Janis'">
                    <xsl:attribute name="style">color:purple;</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:value-of select="."/>
        </span>
    </xsl:template>
    <xsl:template match="paragraph">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="sentence">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="an[not(ancestor::paragraph)]">
        <span>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="paragraph//an | aside">
        <i>
            <small>
                <xsl:apply-templates/>
            </small>
        </i>
    </xsl:template>
    <xsl:function name="immortal:getCharactersByHandle">
        <xsl:param name="handleIDREFS"/>
        <xsl:sequence
            select="subsequence(document('My Immortal.xml')//characterList/character[contains($handleIDREFS, @handle)], 0)"
        />
    </xsl:function>
    <xsl:key name="characterHandle" match="character" use="@handle"/>
    <xsl:template match="char">
        <span style="color:blue;cursor:help;">
            <xsl:attribute name="title">
                <xsl:for-each select="immortal:getCharactersByHandle(@handle)">
                    <xsl:if test="count(./firstName) &lt; 1">
                        <xsl:value-of select="normalize-space(.)"/>
                    </xsl:if>
                    <xsl:if test="count(./firstName) = 1">
                        <xsl:value-of select="normalize-space(./firstName)"/>
                    </xsl:if>
                    <xsl:if test="position() &lt; last()">, </xsl:if>
                </xsl:for-each>
            </xsl:attribute>
            <b>
                <xsl:apply-templates/>
            </b>
        </span>
    </xsl:template>
    <xsl:template match="ref">
        <span style="color:red;font-weight:bold;">
            <xsl:attribute name="title">
                <xsl:value-of select="//referenceList/reference[current()/@handle eq @handle]"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="sp">
        <span>
            <xsl:choose>
                <xsl:when test="@type eq 'phonetic'">
                    <xsl:attribute name="style">color:green;border:1px solid green;</xsl:attribute>
                </xsl:when>
                <xsl:when test="@type eq 'apocope'">
                    <xsl:attribute name="style">color:blue;border:1px solid blue;</xsl:attribute>
                </xsl:when>
                <xsl:when test="@type eq 'hyperbole'">
                    <xsl:attribute name="style">color:red;border:1px solid red;</xsl:attribute>
                </xsl:when>
                <xsl:when test="@type eq 'goffik'">
                    <xsl:attribute name="style">color:purple;border:1px solid
                        purple;</xsl:attribute>
                </xsl:when>
                <xsl:when test="@type eq 'metathesis'">
                    <xsl:attribute name="style">color:orange;border:1px solid
                        orange;</xsl:attribute>
                </xsl:when>
                <xsl:when test="@type eq 'chatspeak'">
                    <xsl:attribute name="style">color:brown;border:1px solid brown;</xsl:attribute>
                </xsl:when>
                <xsl:when test="@type eq 'homophone'">
                    <xsl:attribute name="style">color:gray;border:1px solid gray;</xsl:attribute>
                </xsl:when>
                <xsl:when test="@type eq 'keyboarding'">
                    <xsl:attribute name="style">color:gold;border:1px solid gold;</xsl:attribute>
                </xsl:when>
                <xsl:when test="@type eq '???' or not(@type)">
                    <xsl:attribute name="style">color:hotpink;border:1px solid
                        hotpink;</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:attribute name="class">spellingMistake <xsl:value-of select="@type"
                /></xsl:attribute>
            <xsl:attribute name="onclick">var innerText = this.innerHTML; this.innerHTML =
                this.title; this.title = innerText;</xsl:attribute>
            <xsl:attribute name="title">
                <xsl:value-of select="."/>
            </xsl:attribute>
            <xsl:if test="self::charsp">
                <u>
                    <xsl:value-of select="//characterList/character[current()/@handle eq ./@handle]"
                    />
                </u>
            </xsl:if>
            <xsl:if test="self::sp">
                <xsl:value-of select="@intended"/>
            </xsl:if>
        </span>
    </xsl:template>
    <xsl:template match="omitted">
        <span style="color:purple;font-weight:bold;background-color:#CC99CC;">
            <xsl:value-of select="@content"/>
        </span>
    </xsl:template>
    <xsl:template match="dialogue">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>
    <xsl:template match="separation">
        <div style="text-align:center;font-weight:bold;">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="poc">
        <img>
            <xsl:attribute name="src">question-box.gif</xsl:attribute>
            <xsl:attribute name="onclick">showPointOfContention("<xsl:value-of
                    select="normalize-space(.)"/>");</xsl:attribute>
            <xsl:attribute name="class">pointOfContention</xsl:attribute>
        </img>
    </xsl:template>
    <xsl:template match="spell">
        <span>
            <xsl:attribute name="style"
                >background-image:url('sparkles.png');color:black;font-weight:bold;</xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="paradox">
        <span>
            <xsl:attribute name="style">font-weight:bold;color:#FF00AA;cursor:help;</xsl:attribute>
            «<xsl:apply-templates/>» </span>
    </xsl:template>
    <xsl:template match="grammar">
        <span>
            <xsl:attribute name="style">font-weight:bold;color:#683A5E;</xsl:attribute>
            <xsl:value-of select="./@intended"/>
        </span>
    </xsl:template>
    <xsl:template match="redact">
        <span>
            <xsl:attribute name="class">redact</xsl:attribute>
            <xsl:attribute name="onclick">this.className = (this.className == "redact" ? "redact shown" : "redact");</xsl:attribute>
            <span>
                <xsl:attribute name="class">proposed</xsl:attribute>
                <xsl:apply-templates select="./proposed"/>
            </span>
            <span>
                <xsl:attribute name="class">original</xsl:attribute>
                <xsl:apply-templates select="./original"/>
            </span>
        </span>
    </xsl:template>
</xsl:stylesheet>
