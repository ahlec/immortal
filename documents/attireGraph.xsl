<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/">
       <svg height="100%" width="100%">
         <line stroke="black" stroke-width="2" x1="50" x2="750" y1="300" y2="300" />
         <text x="350" y="315" fill="black">Chapter</text>
         <line stroke="black" stroke-width="2" x1="50" x2="50" y1="0" y2="300" />
         <text x="15" y="250" fill="black" transform="rotate(-90 15 250)">Attire Description Word Count</text>
         <g id="graph" transform="translate(50,300)">
           <line stroke="black" stroke-dasharray="5 2" stroke-width="1" x1="0" x2="700" y1="-50" y2="-50"/>
           <text fill="black" x="-30" y="-45">100</text>
           <line stroke="black" stroke-dasharray="5 2" stroke-width="1" x1="0" x2="700" y1="-100" y2="-100"/>
           <text fill="black" x="-30" y="-95">200</text>
           <line stroke="black" stroke-dasharray="5 2" stroke-width="1" x1="0" x2="700" y1="-150" y2="-150"/>
           <text fill="black" x="-30" y="-145">300</text>
           <line stroke="black" stroke-dasharray="5 2" stroke-width="1" x1="0" x2="700" y1="-200" y2="-200"/>
           <text fill="black" x="-30" y="-195">400</text>
           <line stroke="black" stroke-dasharray="5 2" stroke-width="1" x1="0" x2="700" y1="-250" y2="-250"/>
           <text fill="black" x="-30" y="-245">500</text>
           <xsl:for-each select="//chapter">
             <xsl:variable name="xPos" select="position() * 15"/>
             <xsl:variable name="yPos" select="sum(descendant::attire/count(tokenize(.,'\s'))) div 2"/>
             <rect fill="purple" height="{$yPos}" stroke="white" stroke-width="1" width="15" x="{$xPos}" y="-{$yPos}">
               <title>
                 <xsl:value-of select="sum(descendant::attire/count(tokenize(.,'\s')))"/>
               </title>
             </rect>
           </xsl:for-each>
         </g>
       </svg>
  </xsl:template>
</xsl:stylesheet>
