<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:php="http://php.net/xsl" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
  <xsl:output method="html" encoding="utf-8" indent="yes"/>
  <xsl:template match="/">
    <xsl:apply-templates/><!-- select="//post"/> -->
  </xsl:template>
  <xsl:template match="post">
    <xsl:variable name="userHandle" select="user/text()"/>
    <xsl:variable name="userDefinition" select="document('../users.xml')//user[./handle = $userHandle]"/>
    <div class="post">
      <a>
        <xsl:attribute name="class">avatar</xsl:attribute>
        <xsl:attribute name="href"><xsl:value-of select="$urlPath"/>/about/<xsl:value-of select="$userDefinition/handle/text()"/>/</xsl:attribute>
        <img>
          <xsl:attribute name="border">0</xsl:attribute>
          <xsl:attribute name="src"><xsl:value-of select="$urlPath"/><xsl:value-of select="$userDefinition/image/text()"/></xsl:attribute>
          <xsl:attribute name="title"><xsl:value-of select="$userDefinition/firstName/text()"/><xsl:text> </xsl:text><xsl:value-of select="$userDefinition/lastName/text()" /></xsl:attribute>
        </img>
      </a>
      <div class="title">
        <xsl:if test="not($userSessionHandle = 'none')"> <!-- and ($userSessionHandle = $userHandle)"> -->
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$urlPath"/>/write-post/<xsl:value-of select="datetime/text()"/>/</xsl:attribute>
            <xsl:attribute name="class">action</xsl:attribute>
            Modify
          </a>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$urlPath"/>/delete-post/<xsl:value-of select="datetime/text()"/>/</xsl:attribute>
            <xsl:attribute name="class">action</xsl:attribute>
            Delete
          </a>
        </xsl:if>
	<xsl:apply-templates select="title"/>
	<span>
	  <a>
	    <xsl:attribute name="href"><xsl:value-of select="$urlPath"/>/about/<xsl:value-of select="$userDefinition/handle/text()"/>/</xsl:attribute>
	    <xsl:value-of select="$userDefinition/firstName/text()"/><xsl:text> </xsl:text><xsl:value-of select="$userDefinition/lastName/text()"/>
          </a><xsl:text> </xsl:text><xsl:value-of select="php:function('date',$datetimeFormat,number(datetime/text()))"/>
	</span>
      </div>
      <div class="postBody">
        <xsl:apply-templates select="body"/>
      </div>
      <xsl:apply-templates select="tags"/>
    </div>
    <xsl:apply-templates select=".//comment"/>
    <xsl:if test="not($userSessionHandle = 'none')">
      <xsl:variable name="currentUserDefinition" select="document('../users.xml')//user[./handle = $userSessionHandle]"/>
      <div class="post comment">
        <a>
          <xsl:attribute name="class">avatar</xsl:attribute>
          <xsl:attribute name="href"><xsl:value-of select="$urlPath"/>/about/<xsl:value-of select="$currentUserDefinition/handle/text()"/>/</xsl:attribute>
          <img>
            <xsl:attribute name="border">0</xsl:attribute>
            <xsl:attribute name="src"><xsl:value-of select="$urlPath"/><xsl:value-of select="$currentUserDefinition/image/text()"/></xsl:attribute>
            <xsl:attribute name="title"><xsl:value-of select="$currentUserDefinition/firstName/text()"/><xsl:text> </xsl:text><xsl:value-of select="$currentUserDefinition/lastName/text()"/></xsl:attribute>
          </img>
        </a>
        <div class="postBody"><form>
          <xsl:attribute name="method">POST</xsl:attribute>
          <xsl:attribute name="action"><xsl:value-of select="$urlPath"/>/post-comment/</xsl:attribute>
          <input>
            <xsl:attribute name="type">hidden</xsl:attribute>
            <xsl:attribute name="name">postTimestamp</xsl:attribute>
            <xsl:attribute name="value"><xsl:value-of select="datetime/text()"/></xsl:attribute>
          </input>
          <textarea>
            <xsl:attribute name="name">comment</xsl:attribute>
          </textarea>
          <input type="submit" value="Post comment"/>
        </form></div>
      </div>
    </xsl:if>
  </xsl:template>
  <xsl:template match="title">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="body//@*|body/node()[not(ancestor-or-self::link) and not(ancestor-or-self::code)]">
    <xsl:copy>
      <xsl:if test="self::* and name() = 'a'">
        <xsl:attribute name="target">_blank</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="tags">
    <div class="postTags">
      <xsl:apply-templates select="tag"/>
    </div>
  </xsl:template>
  <xsl:template match="tag">
    <a class="tag">
      <xsl:attribute name="href"><xsl:value-of select="$urlPath"/>/<xsl:if test="not($selectedTag = translate(.,' ', '-'))">posts/tagged/<xsl:value-of select="translate(.,' ','-')"/>/</xsl:if></xsl:attribute>
      <xsl:attribute name="title"><xsl:text>#</xsl:text><xsl:value-of select="."/></xsl:attribute>
      <xsl:attribute name="class">tag<xsl:if test="$selectedTag = translate(., ' ', '-')"> selectedTag</xsl:if></xsl:attribute>
      <xsl:text>#</xsl:text><xsl:value-of select="."/>
    </a>
  </xsl:template>
  <xsl:template match="link">
    <a>
      <xsl:attribute name="href"><xsl:value-of select="$urlPath"/>/<xsl:value-of select="@page"/></xsl:attribute>
      <xsl:value-of select="."/>
    </a>
  </xsl:template>
  <xsl:template match="comment">
    <xsl:variable name="userHandle" select="@handle"/>
    <xsl:variable name="userDefinition" select="document('../users.xml')//user[./handle = $userHandle]"/>
     <div class="post comment">
        <a>
          <xsl:attribute name="class">avatar</xsl:attribute>
          <xsl:attribute name="href"><xsl:value-of select="$urlPath"/>/about/<xsl:value-of select="$userDefinition/handle/text()"/>/</xsl:attribute>
          <img>
            <xsl:attribute name="border">0</xsl:attribute>
            <xsl:attribute name="src"><xsl:value-of select="$urlPath"/><xsl:value-of select="$userDefinition/image/text()"/></xsl:attribute>
            <xsl:attribute name="title"><xsl:value-of select="$userDefinition/firstName/text()"/><xsl:text> </xsl:text><xsl:value-of select="$userDefinition/lastName/text()"/></xsl:attribute>
          </img>
        </a>
        <div class="title">
          <xsl:if test="not($userSessionHandle = 'none') and ($userSessionHandle = $userHandle)">
            <a>
              <xsl:attribute name="href"><xsl:value-of select="$urlPath"/>/post-comment/<xsl:value-of select="ancestor::post/datetime/text()"/>/<xsl:value-of select="@datetime"/>/</xsl:attribute>
              <xsl:attribute name="class">action</xsl:attribute>
              Modify
            </a>
            <a>
              <xsl:attribute name="href"><xsl:value-of select="$urlPath"/>/delete-comment/<xsl:value-of select="ancestor::post/datetime/text()"/>/<xsl:value-of select="@datetime"/>/</xsl:attribute>
              <xsl:attribute name="class">action</xsl:attribute>
              Delete
            </a>
          </xsl:if>
          <span>
            <a>
              <xsl:attribute name="href"><xsl:value-of select="$urlPath"/>/about/<xsl:value-of select="$userDefinition/handle/text()"/>/</xsl:attribute>
              <xsl:value-of select="$userDefinition/firstName/text()"/><xsl:text> </xsl:text><xsl:value-of select="$userDefinition/lastName/text()"/>
            </a><xsl:text> </xsl:text><xsl:value-of select="php:function('date',$datetimeFormat,number(@datetime))"/>
          </span>
        </div>
        <div class="postBody"><xsl:apply-templates/></div>
      </div>
  </xsl:template>
  <xsl:template match="code">
    <xsl:element name="code">
      <xsl:for-each select="./*">
        <xsl:if test="name()">
	  <xsl:apply-templates select="." mode="codeElement"/>
         <!-- &lt;<xsl:value-of select="name()"/>/&gt;-->
        </xsl:if>
        <xsl:if test="not(name())">
          <xsl:value-of select="."/>
        </xsl:if>
      </xsl:for-each>
      <xsl:value-of select="./text()"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="node()" mode="codeElement"><xsl:if test="not(self::text()) and not(self::br)">&lt;<xsl:value-of select="name()"/><xsl:apply-templates select="@*" mode="codeAttributes"/><xsl:if test="count(.//*) > 0 or string-length(.) > 0">&gt;<xsl:apply-templates mode="codeElement"/>&lt;/<xsl:value-of select="name()"/></xsl:if>
      <xsl:if test="count(.//*) = 0 and string-length(.) = 0">/</xsl:if>&gt;</xsl:if><xsl:if test="self::text()"><xsl:value-of select="."/></xsl:if></xsl:template>
  <xsl:template match="@*" mode="codeAttributes"><xsl:text> </xsl:text><xsl:value-of select="name()"/>=&quot;<xsl:value-of select="." />&quot;</xsl:template>
</xsl:stylesheet>
