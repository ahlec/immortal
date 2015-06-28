<!-- Generates the XML file transformed by codexStart.xml by transforming the My Immortal.xml file into an xml file of codex data:
        Specific information pertaining to the <meta> element's contents in the document. -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:variable name="urlPath">http://imm.dh.obdurodon.org</xsl:variable>
    <xsl:variable name="websiteData" select="document('website data.xml')"/>
    <xsl:output indent="yes"/>
    <xsl:variable name="occurances">
        <xsl:variable name="occurancesUnsorted">
            <xsl:for-each select="/troll/meta//*[@handle]">
                <xsl:if test="not(name() = 'editor')">
                    <item>
                        <xsl:attribute name="type">
                            <xsl:variable name="type" select="name()"/>
                            <xsl:value-of
                                select="concat(upper-case(substring($type, 1, 1)), substring($type, 2))"
                            />
                        </xsl:attribute>
                        <xsl:variable name="itemHandle" select="@handle"/>
                        <xsl:attribute name="occurances"
                            select="count(ancestor::troll/story//*[@handle and $itemHandle = tokenize(@handle, ' ')])"/>
                        <xsl:attribute name="name" select="normalize-space(.)"/>
                        <xsl:value-of select="@handle"/>
                    </item>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="$occurancesUnsorted/item">
            <xsl:sort select="number(@occurances)" order="descending"/>
            <xsl:copy-of select="current()"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:template match="/">
        <codexData>
            <characterList>
                <xsl:for-each select="distinct-values(troll/meta/characterList/character/@type)">
                    <role>
                        <xsl:attribute name="lower">
                            <xsl:value-of select="current()"/>
                        </xsl:attribute>
                        <xsl:value-of
                            select="concat(upper-case(substring(current(),1,1)), '', substring(current(),2))"
                        />
                    </role>
                </xsl:for-each>
                <xsl:apply-templates select="troll/meta/characterList/character"/>
            </characterList>
            <locationList>
                <xsl:apply-templates select="troll/meta/locationList/location"/>
            </locationList>
            <referenceList>
                <xsl:for-each select="distinct-values(troll/meta/referenceList/reference/@type)">
                    <type>
                        <xsl:attribute name="handle">
                            <xsl:value-of select="current()"/>
                        </xsl:attribute>
                        <xsl:value-of
                            select="concat(upper-case(substring(current(),1,1)), '', substring(current(), 2))"
                        />
                    </type>
                </xsl:for-each>
                <xsl:apply-templates select="troll/meta/referenceList/reference"/>
            </referenceList>
            <spellList>
                <xsl:apply-templates select="troll/meta/spellList/spellDefinition"/>
            </spellList>
            <chapters>
                <xsl:apply-templates select="troll/story/chapter"/>
            </chapters>
        </codexData>
    </xsl:template>
    <xsl:template match="character">
        <xsl:variable name="name" select="normalize-space(.)"/>
        <xsl:variable name="handle" select="@handle"/>
        <xsl:variable name="websiteDataCharacter"
            select="$websiteData//characters/character[@handle = $handle]"/>
        <character>
            <xsl:attribute name="handle">
                <xsl:value-of select="@handle"/>
            </xsl:attribute>
            <xsl:attribute name="lowerCaseHandle">
                <xsl:value-of select="lower-case(@handle)"/>
            </xsl:attribute>
            <name>
                <xsl:value-of select="$name"/>
            </name>
            <xsl:if test="$websiteDataCharacter[@hasProfilePicture]">
                <picture>
                    <xsl:text>character_profiles/</xsl:text>
                    <xsl:value-of select="$handle"/>
                    <xsl:text>.png</xsl:text>
                </picture>
            </xsl:if>
            <xsl:if test="@gender">
                <gender>
                    <xsl:if test="@gender eq 'm'">Male</xsl:if>
                    <xsl:if test="@gender eq 'f'">Female</xsl:if>
                </gender>
            </xsl:if>
            <xsl:if test="@hp|@canon">
                <canon>
                    <xsl:attribute name="wikipedia">
                        <xsl:choose>
                            <xsl:when test="$websiteDataCharacter[@wikipediaLinkOverride]">
                                <xsl:value-of select="$websiteDataCharacter/@wikipediaLinkOverride"
                                />
                            </xsl:when>
                            <xsl:when test="@hp">
                                <xsl:value-of select="@hp"/>
                            </xsl:when>
                            <xsl:when test="@canon">
                                <xsl:value-of select="@canon"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:if test="@series">
                        <xsl:attribute name="series">
                            <xsl:value-of select="@series"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="@hp">
                            <xsl:value-of select="@hp"/>
                        </xsl:when>
                        <xsl:when test="@canon">
                            <xsl:value-of select="@canon"/>
                        </xsl:when>
                    </xsl:choose>
                </canon>
            </xsl:if>
            <xsl:if test="@type">
                <role>
                    <xsl:value-of
                        select="concat(upper-case(substring(@type,1,1)), '', substring(@type,2))"/>
                </role>
            </xsl:if>
            <alternateNames>
                <xsl:for-each-group group-by="lower-case(.)"
                    select="//char[contains(@handle, $handle) and not(@type) and count(sp) > 0]">
                    <xsl:sort select="current-grouping-key()"/>
                    <!--select="//sp[ancestor-or-self::char[contains(@handle, $handle) and not(@type)] and not(parent::sp)]">-->
                    <name>
                        <xsl:value-of select="normalize-space(.)"/>
                    </name>
                </xsl:for-each-group>
            </alternateNames>
            <totalOccurrence>
                <xsl:value-of select="$occurances/item[text() = $handle]/@occurances"/>
            </totalOccurrence>
            <xsl:for-each select="$occurances/item[@type='Character']">
                <xsl:if test="text() = $handle">
                    <relativeFrequency>
                        <xsl:variable name="position" select="position()"/>
                        <xsl:if test="position() > 1">
                            <xsl:attribute name="moreFrequent"
                                select="($occurances/item[@type='Character'])[$position - 1]"/>
                            <xsl:attribute name="moreFrequent-Name"
                                select="($occurances/item[@type='Character'])[$position - 1]/@name"
                            />
                        </xsl:if>
                        <xsl:if test="position() &lt; count($occurances/item[@type='Character'])">
                            <xsl:attribute name="nextFrequent"
                                select="($occurances/item[@type='Character'])[$position + 1]"/>
                            <xsl:attribute name="nextFrequent-Name"
                                select="($occurances/item[@type='Character'])[$position + 1]/@name"
                            />
                        </xsl:if>
                        <xsl:attribute name="relative" select="@type"/>
                        <xsl:value-of select="$position"/>
                    </relativeFrequency>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$occurances/item">
                <xsl:if test="text() = $handle">
                    <totalFrequency>
                        <xsl:variable name="position" select="position()"/>
                        <xsl:if test="position() > 1">
                            <xsl:attribute name="moreFrequent"
                                select="$occurances/item[$position - 1]"/>
                            <xsl:attribute name="moreFrequent-Name"
                                select="$occurances/item[$position - 1]/@name"/>
                        </xsl:if>
                        <xsl:if test="position() &lt; count($occurances/item)">
                            <xsl:attribute name="nextFrequent"
                                select="$occurances/item[$position + 1]"/>
                            <xsl:attribute name="nextFrequent-Name"
                                select="$occurances/item[$position + 1]/@name"/>
                        </xsl:if>
                        <xsl:attribute name="relative" select="@type"/>
                        <xsl:value-of select="$position"/>
                    </totalFrequency>
                </xsl:if>
            </xsl:for-each>
            <dialogueList>
                <xsl:for-each select="//chapter">
                    <xsl:if test=".//dialogue[contains(@handle, $handle)]">
                        <dialogue chapter="{current()/@number}">
                            <occurs>
                                <xsl:value-of
                                    select="count(.//dialogue[contains(@handle, $handle)])"/>
                            </occurs>
                            <xsl:for-each select=".//dialogue[contains(@handle, $handle)]">
                                <quote>
                                    <xsl:if test="not(compare(string(current/@handle), $handle))">
                                        <xsl:attribute name="spokenWith"
                                            select="normalize-space(replace(@handle, $handle, ''))"
                                        />
                                    </xsl:if>
                                    <!--<xsl:variable name="theQuote">-->
                                    <xsl:variable name="quoteValue" xml:space="default">
                                        <xsl:for-each select="node()">
                                            <!--
                                            <xsl:value-of
                                                select="if(node()) then (name()) else ('text')"/>-->
                                            <xsl:choose>
                                                <xsl:when
                                                  test="name() = ('char', 'ref', 'spell', 'place')
                                                and string-length(normalize-space(replace(@handle, $handle, ''))) &gt; 0">
                                                  <xsl:copy>
                                                  <xsl:attribute name="handle"
                                                  select="normalize-space(replace(@handle, $handle, ''))"/>
                                                  <xsl:value-of select="normalize-space(.)"/>
                                                  </xsl:copy>
                                                </xsl:when>
                                                <xsl:when test="poc"/>
                                                <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when test="normalize-space() = ''">
                                                  <xsl:text>&#160;</xsl:text>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="replace(., '\s+', ' ')"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:variable>
                                    <xsl:for-each select="$quoteValue/node()">
                                        <xsl:choose>
                                            <xsl:when test="normalize-space(current()) = ''">
                                                <xsl:text> </xsl:text>
                                            </xsl:when>
                                            <xsl:when
                                                test="name() = ('char', 'ref', 'place', 'spell', 'omitted')">
                                                <xsl:copy>
                                                  <xsl:for-each select="@*">
                                                  <xsl:copy>
                                                  <xsl:value-of select="current()"/>
                                                  </xsl:copy>
                                                  </xsl:for-each>
                                                  <xsl:value-of
                                                  select="if(name() = 'omitted') then(.) else(normalize-space(.))"
                                                  />
                                                </xsl:copy>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="replace(., '\s+',' ')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </quote>
                            </xsl:for-each>
                        </dialogue>
                    </xsl:if>
                </xsl:for-each>
            </dialogueList>
            <xsl:for-each select="//chapter">
                <xsl:if test=".//char[contains(@handle, $handle)]">
                    <occurs>
                        <xsl:attribute name="chapter" select="@number"/>
                        <xsl:value-of select="count(.//char[@handle = $handle])"/>
                    </occurs>
                </xsl:if>
            </xsl:for-each>
            <relationships>
                <xsl:for-each select="//characterList/character[not(@handle = $handle)]">
                    <xsl:variable name="searchHandle" select="@handle"/>
                    <xsl:variable name="kisses"
                        select="//kiss[$searchHandle = tokenize(@handle, ' ') and $handle = tokenize(@handle, ' ')]"/>
                    <xsl:variable name="sexes"
                        select="//sex[($searchHandle = tokenize(@handle, ' ') or (@voyeur and $searchHandle = tokenize(@voyeur, ' '))) and
                        ($handle = tokenize(@handle, ' ') or (@voyeur and $handle = tokenize(@voyeur, ' ')))]"/>
                    <xsl:if test="count($kisses) > 0 or count($sexes) > 0">
                        <relation>
                            <xsl:attribute name="handle" select="$searchHandle"/>
                            <xsl:for-each select="$kisses">
                                <kiss>
                                    <xsl:if test="count(tokenize(@handle,' ')) > 2">
                                        <xsl:attribute name="othersInvolved"
                                            select="normalize-space(replace(replace(@handle, $searchHandle, ''), $handle, ''))"
                                        />
                                    </xsl:if>
                                    <chapter>
                                        <xsl:value-of select="ancestor-or-self::chapter/@number"/>
                                    </chapter>
                                    <text>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </text>
                                </kiss>
                            </xsl:for-each>
                            <xsl:for-each
                                select="$sexes[$searchHandle = tokenize(@handle, ' ') and $handle = tokenize(@handle, ' ')]">
                                <sex>
                                    <xsl:if test="count(tokenize(@handle,' ')) > 2">
                                        <xsl:attribute name="othersInvolved"
                                            select="normalize-space(replace(replace(@handle, $searchHandle, ''), $handle, ''))"
                                        />
                                    </xsl:if>
                                    <xsl:if test="@voyeur">
                                        <xsl:attribute name="voyeur"
                                            select="normalize-space(replace(replace(@voyeur, $searchHandle, ''), $handle, ''))"
                                        />
                                    </xsl:if>
                                    <chapter>
                                        <xsl:value-of select="ancestor-or-self::chapter/@number"/>
                                    </chapter>
                                    <xsl:if test="@type">
                                        <type>
                                            <xsl:value-of select="."/>
                                        </type>
                                    </xsl:if>
                                    <text>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </text>
                                </sex>
                            </xsl:for-each>
                            <xsl:for-each
                                select="$sexes/*[$searchHandle = tokenize(@voyeur, ' ') and $handle = tokenize(@voyeur, ' ')]">
                                <voyeur>
                                    <xsl:if test="count(tokenize(@handle,' ')) > 2">
                                        <xsl:attribute name="participants"
                                            select="normalize-space(replace(replace(@handle, $searchHandle, ''), $handle, ''))"
                                        />
                                    </xsl:if>
                                    <xsl:if test="@voyeur">
                                        <xsl:attribute name="otherVoyeur"
                                            select="normalize-space(replace(replace(@voyeur, $searchHandle, ''), $handle, ''))"
                                        />
                                    </xsl:if>
                                    <chapter>
                                        <xsl:value-of select="ancestor-or-self::chapter/@number"/>
                                    </chapter>
                                    <xsl:if test="@type">
                                        <type>
                                            <xsl:value-of select="."/>
                                        </type>
                                    </xsl:if>
                                    <text>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </text>
                                </voyeur>
                            </xsl:for-each>
                        </relation>
                    </xsl:if>
                </xsl:for-each>
            </relationships>
            <wardrobe>
                <xsl:for-each select="//story">
                    <xsl:if test=".//attire">
                        <xsl:variable name="pseudoAttire">
                            <xsl:for-each-group select=".//attire" group-by="@type">
                                <outfit>
                                    <xsl:element name="chapter">
                                        <xsl:value-of select="ancestor-or-self::chapter/@number"/>
                                    </xsl:element>
                                    <xsl:for-each select="@*[not(name()='handle')]">
                                        <xsl:sort select="name()"/>
                                        <xsl:element name="{name(current())}">
                                            <xsl:value-of select="current()"/>
                                        </xsl:element>
                                    </xsl:for-each>
                                </outfit>
                            </xsl:for-each-group>
                        </xsl:variable>

                        <xsl:variable name="pseudoAttireWithoutChapter">
                            <xsl:for-each-group select=".//attire[contains(@handle, $handle)]"
                                group-by="@type">
                                <outfit>
                                    <xsl:for-each select="@*[not(name()='handle')]">
                                        <xsl:sort select="name()"/>
                                        <xsl:element name="{name(current())}">
                                            <xsl:value-of select="current()"/>
                                        </xsl:element>
                                    </xsl:for-each>
                                </outfit>
                            </xsl:for-each-group>
                        </xsl:variable>

                        <xsl:for-each
                            select="$pseudoAttireWithoutChapter//outfit[not(deep-equal(.,preceding-sibling::outfit))]">
                            <xsl:variable name="currentOutfit" select="current()"/>
                            <outfit>
                                <xsl:for-each select="node()">
                                    <xsl:element name="{name(current())}">
                                        <xsl:value-of select="."/>
                                    </xsl:element>
                                </xsl:for-each>
                                <chapters>
                                    <xsl:for-each
                                        select="$pseudoAttireWithoutChapter//outfit[deep-equal(.,$currentOutfit)]">
                                        <xsl:variable name="index"
                                            select="count(preceding-sibling::outfit) + 1"/>
                                        <chapter>
                                            <xsl:value-of
                                                select="$pseudoAttire//outfit[$index]/chapter"/>
                                        </chapter>
                                    </xsl:for-each>
                                </chapters>
                            </outfit>
                        </xsl:for-each>

                    </xsl:if>
                </xsl:for-each>
            </wardrobe>
        </character>
    </xsl:template>

    <xsl:template match="reference">
        <xsl:variable name="name" select="normalize-space(.)"/>
        <xsl:variable name="handle" select="@handle"/>
        <xsl:variable name="websiteDataReference"
            select="$websiteData//references/reference[@handle = $handle]"/>
        <reference>
            <xsl:attribute name="handle">
                <xsl:value-of select="@handle"/>
            </xsl:attribute>
            <xsl:attribute name="lowerCaseHandle">
                <xsl:value-of select="lower-case(@handle)"/>
            </xsl:attribute>
            <name>
                <xsl:value-of select="normalize-space(.)"/>
            </name>
            <type>
                <xsl:value-of
                    select="concat(upper-case(substring(@type,1,1)), '', substring(@type, 2))"/>
            </type>
            <xsl:if test="@parent">
                <parent>
                    <xsl:variable name="parentHandle" select="@parent"/>
                    <xsl:attribute name="type">
                        <xsl:value-of
                            select="upper-case(substring(//reference[@handle and @handle = $parentHandle]/@type, 1, 1))"/>
                        <xsl:value-of
                            select="substring(//reference[@handle and @handle = $parentHandle]/@type, 2)"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="handle">
                        <xsl:value-of select="$parentHandle"/>
                    </xsl:attribute>
                    <xsl:value-of
                        select="normalize-space(//reference[@handle and @handle = $parentHandle])"/>
                </parent>
            </xsl:if>
            <totalOccurrence>
                <xsl:value-of select="$occurances/item[text() = $handle]/@occurances"/>
            </totalOccurrence>
            <xsl:for-each select="$occurances/item[@type='Reference']">
                <xsl:if test="text() = $handle">
                    <relativeFrequency>
                        <xsl:variable name="position" select="position()"/>
                        <xsl:if test="position() > 1">
                            <xsl:attribute name="moreFrequent"
                                select="($occurances/item[@type='Reference'])[$position - 1]"/>
                            <xsl:attribute name="moreFrequent-Name"
                                select="($occurances/item[@type='Reference'])[$position - 1]/@name"
                            />
                        </xsl:if>
                        <xsl:if test="position() &lt; count($occurances/item[@type='Reference'])">
                            <xsl:attribute name="nextFrequent"
                                select="($occurances/item[@type='Reference'])[$position + 1]"/>
                            <xsl:attribute name="nextFrequent-Name"
                                select="($occurances/item[@type='Reference'])[$position + 1]/@name"
                            />
                        </xsl:if>
                        <xsl:attribute name="relative" select="@type"/>
                        <xsl:value-of select="$position"/>
                    </relativeFrequency>
                </xsl:if>
            </xsl:for-each>

            <xsl:for-each select="$occurances/item">
                <xsl:if test="text() = $handle">
                    <totalFrequency>
                        <xsl:variable name="position" select="position()"/>
                        <xsl:if test="position() > 1">
                            <xsl:attribute name="moreFrequent"
                                select="$occurances/item[$position - 1]"/>
                            <xsl:attribute name="moreFrequent-Name"
                                select="$occurances/item[$position - 1]/@name"/>
                        </xsl:if>
                        <xsl:if test="position() &lt; count($occurances/item)">
                            <xsl:attribute name="nextFrequent"
                                select="$occurances/item[$position + 1]"/>
                            <xsl:attribute name="nextFrequent-Name"
                                select="$occurances/item[$position + 1]/@name"/>
                        </xsl:if>
                        <xsl:attribute name="relative" select="@type"/>
                        <xsl:value-of select="$position"/>
                    </totalFrequency>
                </xsl:if>
            </xsl:for-each>
            <xsl:if test="$websiteDataReference/@video">
                <video>
                    <xsl:value-of select="$websiteDataReference/@video"/>
                </video>
            </xsl:if>
            <xsl:if test="not($websiteDataReference and $websiteDataReference/@noPicture)">
                <picture>references/<xsl:value-of select="$handle"/>.jpg</picture>
            </xsl:if>
            <xsl:for-each select="//chapter">
                <xsl:if test=".//ref[contains(@handle, $handle)]">
                    <occurs>
                        <xsl:attribute name="chapter" select="@number"/>
                        <xsl:value-of select="count(.//ref[contains(@handle, $handle)])"/>
                    </occurs>
                </xsl:if>
            </xsl:for-each>
        </reference>
    </xsl:template>

    <xsl:template match="location">
        <xsl:variable name="name" select="normalize-space(.)"/>
        <xsl:variable name="handle" select="@handle"/>
        <location>
            <xsl:attribute name="handle">
                <xsl:value-of select="@handle"/>
            </xsl:attribute>
            <xsl:attribute name="lowerCaseHandle">
                <xsl:value-of select="lower-case(@handle)"/>
            </xsl:attribute>
            <name>
                <xsl:value-of select="normalize-space(.)"/>
            </name>
            <xsl:if test="@hp">
                <hpName>
                    <xsl:value-of select="@hp"/>
                </hpName>
            </xsl:if>
            <xsl:if test="@presentDay">
                <presentDay>
                    <xsl:attribute name="handle">
                        <xsl:value-of select="@presentDay"/>
                    </xsl:attribute>
                    <xsl:variable name="presentDayHandle">
                        <xsl:value-of select="@presentDay"/>
                    </xsl:variable>
                    <xsl:value-of select="normalize-space(//location[@handle = $presentDayHandle])"
                    />
                </presentDay>
            </xsl:if>
            <xsl:if test="count(//locationList/location[@presentDay and @presentDay = $handle]) = 1">
                <pastVersion>
                    <xsl:attribute name="handle">
                        <xsl:value-of
                            select="//locationList/location[@presentDay and @presentDay = $handle]/@handle"
                        />
                    </xsl:attribute>
                    <xsl:variable name="pastVersionHandle">
                        <xsl:value-of
                            select="//locationList/location[@presentDay and @presentDay = $handle]/@handle"
                        />
                    </xsl:variable>
                    <xsl:value-of select="normalize-space(//location[@handle = $pastVersionHandle])"
                    />
                </pastVersion>
            </xsl:if>
            <xsl:if test="@parent">
                <parent>
                    <xsl:value-of select="@parent"/>
                </parent>
            </xsl:if>
            <xsl:if test="count(//locationList/location[@parent and @parent = $handle]) > 0">
                <sublocations>
                    <xsl:for-each
                        select="//locationList/location[@parent and @parent = $handle]/@handle">
                        <location>
                            <xsl:value-of select="."/>
                        </location>
                    </xsl:for-each>
                </sublocations>
            </xsl:if>
            <totalOccurrence>
                <xsl:value-of select="count(//place[contains(@handle, $handle)])"/>
            </totalOccurrence>
            <xsl:for-each select="//chapter">
                <xsl:if test=".//place[contains(@handle, $handle)]">
                    <occurs>
                        <xsl:attribute name="chapter" select="@number"/>
                        <xsl:value-of select="count(.//place[contains(@handle, $handle)])"/>
                    </occurs>
                </xsl:if>
            </xsl:for-each>
        </location>
    </xsl:template>

    <xsl:template match="spellDefinition">
        <xsl:variable name="name" select="normalize-space(.)"/>
        <xsl:variable name="handle" select="@handle"/>
        <spell>
            <xsl:attribute name="handle">
                <xsl:value-of select="@handle"/>
            </xsl:attribute>
            <xsl:attribute name="lowerCaseHandle">
                <xsl:value-of select="lower-case(@handle)"/>
            </xsl:attribute>
            <name>
                <xsl:value-of select="normalize-space(.)"/>
            </name>
            <xsl:if test="@hp">
                <hpName>
                    <xsl:value-of select="@hp"/>
                </hpName>
            </xsl:if>
            <totalOccurrence>
                <xsl:value-of select="count(//spell[contains(@handle, $handle)])"/>
            </totalOccurrence>
            <knownBy> </knownBy>
            <xsl:for-each select="//chapter">
                <xsl:if test=".//spell[contains(@handle, $handle)]">
                    <occurs>
                        <xsl:attribute name="chapter" select="@number"/>
                        <xsl:value-of select="count(.//spell[contains(@handle, $handle)])"/>
                    </occurs>
                </xsl:if>
            </xsl:for-each>
        </spell>
    </xsl:template>

    <xsl:template match="chapter">
        <chapter>
            <xsl:attribute name="handle">
                <xsl:text>chapter</xsl:text>
                <xsl:value-of select="@number"/>
            </xsl:attribute>
            <xsl:attribute name="lowerCaseHandle">
                <xsl:text>chapter</xsl:text>
                <xsl:value-of select="@number"/>
            </xsl:attribute>
            <editor>
                <xsl:attribute name="handle">
                    <xsl:value-of select="lower-case(@editor)"/>
                </xsl:attribute>
                <xsl:value-of select="@editor"/>
            </editor>
            <number>
                <xsl:value-of select="@number"/>
            </number>
            <xsl:if test="preceding-sibling::chapter">
                <precededBy>
                    <xsl:attribute name="handle">chapter<xsl:value-of select="preceding-sibling::chapter[1]/@number"
                    /></xsl:attribute>
                    <xsl:text>Chapter </xsl:text><xsl:value-of select="preceding-sibling::chapter[1]/@number"/>
                </precededBy>
            </xsl:if>
            <xsl:if test="following-sibling::chapter">
                <followedBy>
                    <xsl:attribute name="handle">chapter<xsl:value-of select="following-sibling::chapter[1]/@number"
                        /></xsl:attribute>
                    <xsl:text>Chapter </xsl:text><xsl:value-of select="following-sibling::chapter[1]/@number"/>
                </followedBy>
            </xsl:if>
            <name>
                <xsl:text>Chapter </xsl:text>
                <xsl:value-of select="@number"/>
            </name>
            <xsl:variable name="meta" select="ancestor-or-self::troll/meta"/>
            <xsl:variable name="thisChapter" select="."/>
            <lexica>
                <xsl:variable name="words">
                    <xsl:for-each
                        select=".//*[text() and not(name() = ('poc', 'separation', 'omitted', 'proposed'))]">
                        <xsl:for-each select="text()">
                            <xsl:if test="string-length(normalize-space(current())) > 0">
                                <xsl:variable name="text">
                                    <xsl:value-of select="current()"/>
                                </xsl:variable>
                                <xsl:for-each select="tokenize(normalize-space($text), ' ')">
                                    <xsl:if test="matches(current(), '[a-zA-Z0-9]')">
                                        <word>
                                            <xsl:value-of select="current()"/>
                                        </word>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:variable>
                <wordCount>
                    <xsl:value-of select="count($words/word)"/>
                </wordCount>
                <spellingMistakes>
                    <xsl:value-of select="count(.//sp)"/>
                </spellingMistakes>
                <top25Words>
                    <xsl:for-each-group group-by="lower-case(replace(., '[^a-zA-Z0-9]', ''))"
                        select="$words/word">
                        <xsl:sort order="descending" select="count(current-group())"/>
                        <xsl:if test="position() le 25">
                            <word>
                                <xsl:attribute name="order">
                                    <xsl:value-of select="position()"/>
                                </xsl:attribute>
                                <xsl:attribute name="count">
                                    <xsl:value-of select="count(current-group())"/>
                                </xsl:attribute>
                                <xsl:value-of select="lower-case(replace(., '[^a-zA-Z0-9]', ''))"/>
                            </word>
                        </xsl:if>
                    </xsl:for-each-group>
                </top25Words>
            </lexica>
            <xsl:variable name="handles">
                <xsl:for-each select=".//*[@handle]/@handle">
                    <xsl:for-each select="tokenize(current(), ' ')">
                        <xsl:variable name="handleToken" select="current()"/>
                        <handle>
                            <xsl:attribute name="type">
                                <xsl:choose>
                                    <xsl:when
                                        test="$meta/characterList/character[@handle = $handleToken]"
                                        >character</xsl:when>
                                    <xsl:when
                                        test="$meta/referenceList/reference[@handle = $handleToken]"
                                        >reference</xsl:when>
                                    <xsl:when
                                        test="$meta/locationList/location[@handle = $handleToken]"
                                        >location</xsl:when>
                                    <xsl:when
                                        test="$meta/spellList/spellDefinition[@handle = $handleToken]"
                                        >spell</xsl:when>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:value-of select="$handleToken"/>
                        </handle>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:variable>
            <characters>
                <xsl:for-each-group group-by="." select="$handles/handle[@type = 'character']">
                    <xsl:variable name="handle" select="."/>
                    <character>
                        <xsl:attribute name="handle">
                            <xsl:value-of select="$handle"/>
                        </xsl:attribute>
                        <xsl:if
                            test="count($thisChapter/preceding-sibling::chapter//*[@handle and contains(@handle, $handle)]) = 0">
                            <xsl:attribute name="first">true</xsl:attribute>
                        </xsl:if>
                        <xsl:if
                            test="count($thisChapter/preceding-sibling::chapter[1]//*[@handle and contains(@handle, $handle)]) = 0 and
                            count($thisChapter/preceding-sibling::chapter//*[@handle and contains(@handle, $handle)]) > 0">
                            <xsl:attribute name="joinsUs">true</xsl:attribute>
                        </xsl:if>
                        <xsl:value-of
                            select="normalize-space($meta/characterList/character[@handle = $handle])"
                        />
                    </character>
                </xsl:for-each-group>
            </characters>
            <spells>
                <xsl:for-each-group group-by="." select="$handles/handle[@type = 'spell']">
                    <xsl:variable name="handle" select="."/>
                    <spell>
                        <xsl:attribute name="handle">
                            <xsl:value-of select="$handle"/>
                        </xsl:attribute>
                        <xsl:value-of
                            select="normalize-space($meta/spellList/spellDefinition[@handle = $handle])"
                        />
                    </spell>
                </xsl:for-each-group>
            </spells>
        </chapter>
    </xsl:template>
</xsl:stylesheet>
