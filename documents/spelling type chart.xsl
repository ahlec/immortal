<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output indent="yes"/>
    <xsl:param name="urlPath"/>
    <xsl:param name="chapterNum"/>
    <xsl:param name="spellingTypes"/>
    <xsl:template match="/">
        <xsl:apply-templates select="//chapter[@number=$chapterNum]"/>
    </xsl:template>
    <xsl:template match="//chapter">
        <chart>
            <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" height="130%">
                <xsl:variable name="spellingTypesFile"
                    select="document('spellingTypes.xml')"/>
                <xsl:variable name="space" select="-60"/>
                <xsl:variable name="height" select="count(current()/descendant::sentence) * 10 + 15"/>
                <xsl:variable name="width"
                    select="$space*10"/>

                <g id="scale" transform="scale(.75)">
                    <g id="rotate" transform="rotate(90 50 40)">
                        <g id="chart" transform="translate(70 50)">
                            <g id="axes">
                                <line x1="0" x2="{$height}" y1="0" y2="0" stroke="black"
                                    stroke-width="2"/>
                                <text x="{$height div 2}" y="15" text-anchor="middle"
                                    transform="rotate(180 {$height div 2} 15)" fill="black"
                                    style="font-size:20pt;font-family:'trebuchet MS',sans-serif;"
                                    >Sentence</text>

                                <line x1="{$height}" x2="{$height}" y1="0" y2="{$space*10}"
                                    stroke="black" stroke-width="2"/>
                                <line x1="0" x2="0" y1="0" y2="{$space*10}" stroke="black"
                                    stroke-width="2"/>
                                <text x="-30" y="{$width div 2}" fill="black" text-anchor="middle"
                                    transform="rotate(-90 -30 {$width div 2})"
                                    style="font-size:20pt;font-family:'trebuchet MS',sans-serif;"
                                    >Number of Occurrences</text>
                                <text x="{($height)+30}" y="{$width div 2}" fill="black"
                                    text-anchor="middle"
                                    transform="rotate(-90 {($height)+30} {$width div 2})"
                                    style="font-size:20pt;font-family:'trebuchet MS',sans-serif;"
                                    >Number of Occurrences</text>
                            </g>
                            <g id="lines">
                                <line x1="0" x2="{$height}" y1="{$space}" y2="{$space}"
                                    stroke="black" stroke-width="2" stroke-dasharray="5 5"
                                    stroke-opacity=".5"/>
                                <line x1="0" x2="{$height}" y1="{$space*2}" y2="{$space*2}"
                                    stroke="black" stroke-width="2" stroke-dasharray="5 5"
                                    stroke-opacity=".5"/>
                                <line x1="0" x2="{$height}" y1="{$space*3}" y2="{$space*3}"
                                    stroke="black" stroke-width="2" stroke-dasharray="5 5"
                                    stroke-opacity=".5"/>
                                <line x1="0" x2="{$height}" y1="{$space*4}" y2="{$space*4}"
                                    stroke="black" stroke-width="2" stroke-dasharray="5 5"
                                    stroke-opacity=".5"/>
                                <line x1="0" x2="{$height}" y1="{$space*5}" y2="{$space*5}"
                                    stroke="black" stroke-width="2" stroke-dasharray="5 5"
                                    stroke-opacity=".5"/>
                                <line x1="0" x2="{$height}" y1="{$space*6}" y2="{$space*6}"
                                    stroke="black" stroke-width="2" stroke-dasharray="5 5"
                                    stroke-opacity=".5"/>
                                <line x1="0" x2="{$height}" y1="{$space*7}" y2="{$space*7}"
                                    stroke="black" stroke-width="2" stroke-dasharray="5 5"
                                    stroke-opacity=".5"/>
                                <line x1="0" x2="{$height}" y1="{$space*8}" y2="{$space*8}"
                                    stroke="black" stroke-width="2" stroke-dasharray="5 5"
                                    stroke-opacity=".5"/>
                                <line x1="0" x2="{$height}" y1="{$space*9}" y2="{$space*9}"
                                    stroke="black" stroke-width="2" stroke-dasharray="5 5"
                                    stroke-opacity=".5"/>
                                <line x1="0" x2="{$height}" y1="{$space*10}" y2="{$space*10}"
                                    stroke="black" stroke-width="2" stroke-dasharray="5 5"
                                    stroke-opacity=".5"/>
                                <!--<line x1="0" x2="{$height}" y1="{$space*11}" y2="{$space*11}"
                                    stroke="black" stroke-width="2" stroke-dasharray="5 5"
                                    stroke-opacity=".5"/>
                                <line x1="0" x2="{$height}" y1="{$space*12}" y2="{$space*12}"
                                    stroke="black" stroke-width="2" stroke-dasharray="5 5"
                                    stroke-opacity=".5"/>
                                <line x1="0" x2="{$height}" y1="{$space*13}" y2="{$space*13}"
                                    stroke="black" stroke-width="2" stroke-dasharray="5 5"
                                    stroke-opacity=".5"/>
                                <line x1="0" x2="{$height}" y1="{$space*14}" y2="{$space*14}"
                                    stroke="black" stroke-width="2" stroke-dasharray="5 5"
                                    stroke-opacity=".5"/>
                                <line x1="0" x2="{$height}" y1="{$space*15}" y2="{$space*15}"
                                    stroke="black" stroke-width="2" stroke-dasharray="5 5"
                                    stroke-opacity=".5"/>-->
                                <!--labels-->
                                <text x="{10}" y="-5" text-anchor="middle" fill="black"
                                    style="font-size:15pt;font-family:'trebuchet MS', sans-serif;"
                                    transform="rotate(-90 5 5)">0</text>
                                <text x="{-$space*1+10}" y="-5" text-anchor="middle" fill="black"
                                    style="font-size:15pt;font-family:'trebuchet MS', sans-serif;"
                                    transform="rotate(-90 5 5)">1</text>
                                <text x="{-$space*2+10}" y="-5" text-anchor="middle" fill="black"
                                    style="font-size:15pt;font-family:'trebuchet MS', sans-serif;"
                                    transform="rotate(-90 5 5)">2</text>
                                <text x="{-$space*3+10}" y="-5" text-anchor="middle" fill="black"
                                    style="font-size:15pt;font-family:'trebuchet MS', sans-serif;"
                                    transform="rotate(-90 5 5)">3</text>
                                <text x="{-$space*4+10}" y="-5" text-anchor="middle" fill="black"
                                    style="font-size:15pt;font-family:'trebuchet MS', sans-serif;"
                                    transform="rotate(-90 5 5)">4</text>
                                <text x="{-$space*5+10}" y="-5" text-anchor="middle" fill="black"
                                    style="font-size:15pt;font-family:'trebuchet MS', sans-serif;"
                                    transform="rotate(-90 5 5)">5</text>
                                <text x="{-$space*6+10}" y="-5" text-anchor="middle" fill="black"
                                    style="font-size:15pt;font-family:'trebuchet MS', sans-serif;"
                                    transform="rotate(-90 5 5)">6</text>
                                <text x="{-$space*7+10}" y="-5" text-anchor="middle" fill="black"
                                    style="font-size:15pt;font-family:'trebuchet MS', sans-serif;"
                                    transform="rotate(-90 5 5)">7</text>
                                <text x="{-$space*8+10}" y="-5" text-anchor="middle" fill="black"
                                    style="font-size:15pt;font-family:'trebuchet MS', sans-serif;"
                                    transform="rotate(-90 5 5)">8</text>
                                <text x="{-$space*9+10}" y="-5" text-anchor="middle" fill="black"
                                    style="font-size:15pt;font-family:'trebuchet MS', sans-serif;"
                                    transform="rotate(-90 5 5)">9</text>
                                <text x="{-$space*10+10}" y="-5" text-anchor="middle" fill="black"
                                    style="font-size:15pt;font-family:'trebuchet MS', sans-serif;"
                                    transform="rotate(-90 5 5)">10</text>
                                <!--<text x="{-$space*11+10}" y="-5" text-anchor="middle" fill="black"
                                    style="font-size:15pt;font-family:'trebuchet MS', sans-serif;"
                                    transform="rotate(-90 5 5)">11</text>
                                <text x="{-$space*12+10}" y="-5" text-anchor="middle" fill="black"
                                    style="font-size:15pt;font-family:'trebuchet MS', sans-serif;"
                                    transform="rotate(-90 5 5)">12</text>
                                <text x="{-$space*13+10}" y="-5" text-anchor="middle" fill="black"
                                    style="font-size:15pt;font-family:'trebuchet MS', sans-serif;"
                                    transform="rotate(-90 5 5)">13</text>
                                <text x="{-$space*14+10}" y="-5" text-anchor="middle" fill="black"
                                    style="font-size:15pt;font-family:'trebuchet MS', sans-serif;"
                                    transform="rotate(-90 5 5)">14</text>
                                <text x="{-$space*15+10}" y="-5" text-anchor="middle" fill="black"
                                    style="font-size:15pt;font-family:'trebuchet MS', sans-serif;"
                                    transform="rotate(-90 5 5)">15</text>-->
                            </g>
                            <xsl:variable name="sentences" select="descendant::sentence"/>
                            <xsl:for-each select="$spellingTypesFile//type">
                                <xsl:variable name="type" select="current()/text()"/>
                                <xsl:variable name="color" select="@color"/>
                                <xsl:if test="contains($spellingTypes, $type)">
                                    <xsl:for-each select="$sentences">
                                        <xsl:variable name="x" select="(position()*10)+2"/>
                                        <xsl:variable name="lastX" select="((position()-1)*10)+2"/>
                                        <xsl:variable name="y"
                                            select="(count(descendant-or-self::sp[@type=$type]) * $space)"/>
                                        <xsl:variable name="lastY"
                                            select="(count(current()/preceding::sentence[1]/descendant-or-self::sp[@type=$type]) * $space)"/>
                                        <!--<xsl:variable name="lastY"
                                            select="(count(preceding::sentence[1]/descendant::sp[contains($spellingTypes, @type)]) * -75)"/>-->
                                        <!--<xsl:variable name="type"
                                        select="current()/descendant::sp[contains($spellingTypes,@type)]"/>-->
                                        <circle cx="{$x}" cy="{$y}" r="4" fill="{$color}">
                                            <title>
                                                <!--<xsl:value-of select="string-join(descendant-or-self::sp/@type,', ')"/>-->
                                            </title>
                                        </circle>
                                        <!--<line x1="{$x}" x2="{((position()+1)*15)+2}" y1="{$y}" y2="{(count(descendant::sp[contains(@type,'phonetic')]/following-sibling::sp[contains(@type,'phonetic')]) * -65)}" stroke-width="2" stroke="{$color}"/>-->
                                        <xsl:if test="not(position() = 1)">
                                            <line x1="{$lastX}" y1="{$lastY}" x2="{$x}" y2="{$y}"
                                                stroke="{$color}" stroke-width="2"/>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>
                            </xsl:for-each>

                        </g>
                    </g>
                </g>

                <!--</xsl:for-each>-->

            </svg>
        </chart>
    </xsl:template>
</xsl:stylesheet>
