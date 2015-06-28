<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:param name="urlPath"/>
  <xsl:param name="readingOriginal"/>
  <xsl:param name="showPopups"/>
  <xsl:variable name="readingVersion">
    <xsl:if test="$readingOriginal = 'true'">original</xsl:if>
    <xsl:if test="$readingOriginal = 'false'">revised</xsl:if>
  </xsl:variable>
  <xsl:variable name="spellingTypesFile" select="document('spellingTypes.xml')"/>
  <xsl:template match="chapter">
    <a>
      <xsl:attribute name="class">editor</xsl:attribute>
      <xsl:attribute name="href"><xsl:value-of select="$urlPath"/>/about/<xsl:value-of
          select="translate(@editor, 'JE', 'je')"/>/</xsl:attribute> Edited by <img>
        <xsl:attribute name="src"><xsl:value-of select="$urlPath"/>/images/<xsl:value-of
            select="translate(@editor, 'JE', 'je')"/>.png</xsl:attribute>
      </img>
      <xsl:value-of select="@editor"/>
    </a>
    <h1>
      <container>
        <span>
          <xsl:attribute name="handle">chapter<xsl:value-of select="@number"/>
          </xsl:attribute>
          <xsl:attribute name="elementName">
            <xsl:text>chapter</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="class">
            <xsl:if test="$showPopups = 'true'">dialogObject </xsl:if>
            <xsl:value-of select="name()"/>
          </xsl:attribute>
          <xsl:if test="$showPopups = 'true'">
            <xsl:attribute name="onmouseover">Dialog.create(event, this);</xsl:attribute>
          </xsl:if>
          <xsl:text>Chapter </xsl:text>
          <xsl:value-of select="@number"/>
        </span>
      </container>
    </h1>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="title">
    <h2>
      <xsl:apply-templates/>
    </h2>
  </xsl:template>
  <xsl:template match="separation">
    <div class="separation">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:template match="paragraph">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <xsl:template match="chapter/an">
    <div class="standaloneAuthorsNote">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:template match="sentence">
    <container>
      <xsl:apply-templates/>
    </container>
  </xsl:template>
  <xsl:template match="poc"/>
  <xsl:template match="omitted">
    <xsl:if test="$readingVersion = 'revised'">
      <xsl:choose>
        <xsl:when test="@content">
          <xsl:value-of select="@content"/>
        </xsl:when>
        <xsl:when test="not(@content)">
          <xsl:apply-templates/>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <xsl:template match="char|ref|place|spell">
    <span>
      <xsl:attribute name="handle">
        <xsl:value-of select="@handle"/>
      </xsl:attribute>
      <xsl:attribute name="elementName">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:if test="$showPopups = 'true'">dialogObject </xsl:if>
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:if test="$showPopups = 'true'">
        <xsl:attribute name="onmouseover">Dialog.create(event, this);</xsl:attribute>
      </xsl:if>
      <!--<xsl:attribute name="onmouseout">if (this.dialog) this.dialog.close();</xsl:attribute>
      <xsl:attribute name="href"><xsl:value-of select="$urlPath"/>/codex/<xsl:choose>
	<xsl:when test="name() = 'char'">characters</xsl:when>
	<xsl:when test="name() = 'ref'">references</xsl:when>
        <xsl:when test="name() = 'place'">locations</xsl:when>
        <xsl:when test="name() = 'spell'">spells</xsl:when>
      </xsl:choose>/<xsl:value-of select="@handle"/>/</xsl:attribute>
      <xsl:attribute name="target">_blank</xsl:attribute>
-->
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  <xsl:template match="text()">
    <xsl:value-of select="."/>
  </xsl:template>
  <xsl:template match="grammar|sp">
    <xsl:if test="$readingVersion = 'revised'">
      <xsl:value-of select="@intended"/>
    </xsl:if>
    <xsl:if test="$readingVersion = 'original'">
      <span>
        <xsl:attribute name="elementName">
          <xsl:value-of select="name()"/>
        </xsl:attribute>
        <xsl:attribute name="type">
          <xsl:value-of select="@type"/>
        </xsl:attribute>
        <xsl:attribute name="intended">
          <xsl:value-of select="@intended"/>
        </xsl:attribute>
        <xsl:if test="child::*[@intended]">
          <xsl:attribute name="targetText">
            <xsl:value-of select="child::*[@intended]/@intended"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:attribute name="class">error <xsl:if test="$showPopups = 'true'">dialogObject
            dialogObjectAlternate </xsl:if>
          <xsl:value-of select="name()"/>
        </xsl:attribute>
        <xsl:if test="$showPopups = 'true'">
          <xsl:attribute name="onmouseover">Dialog.create(event, this);</xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
      </span>
    </xsl:if>
  </xsl:template>
  <xsl:template match="remove">
    <xsl:if test="$readingVersion = 'original'">
      <xsl:apply-templates/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="redact">
    <xsl:if test="$readingVersion = 'original'">
      <xsl:apply-templates select="original"/>
    </xsl:if>
    <xsl:if test="$readingVersion = 'revised'">
      <xsl:apply-templates select="proposed"/>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
