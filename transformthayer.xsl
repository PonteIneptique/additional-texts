<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output omit-xml-declaration="yes"/>
    <xsl:template match="div[@type='edition']">
        <div type="edition" xml:lang="lat" n="urn:cts:latinLit:stoa0159.stoa004.thayer-lat1"><xsl:apply-templates /></div>
    </xsl:template>
    <xsl:template match="div[@class='spacious']">
        <div type="textpart" subtype="book">
            <xsl:attribute name="n"><xsl:value-of select="@name"/></xsl:attribute>
         <xsl:for-each-group select="node()" group-starting-with="div[a[@id]] | p[a[@class='chapter']]">
             <xsl:if test="count(current-group()//node()) > 0">
                 <xsl:variable name="n"><xsl:value-of select="a/@id | a[@class='chapter']/@name"/></xsl:variable>
                 <div type="textpart" subtype="chapter">
                     <xsl:attribute name="n"><xsl:value-of select="$n"/></xsl:attribute>
                     <xsl:element name="milestone">
                         <xsl:attribute name="unit">section</xsl:attribute>
                         <xsl:attribute name="n"><xsl:value-of select="concat(string($n), '.1')" /></xsl:attribute> 
                     </xsl:element>
                     <xsl:for-each select="current-group()">
                         <xsl:choose>
                             <xsl:when test="name(.) = 'p'">
                                 <xsl:apply-templates select="span[@class='smallcaps']"/>
                                 <p><xsl:apply-templates select="./node()[not(@class='smallcaps')]"/></p>
                             </xsl:when>
                             <xsl:when test="name(.) = 'div' and descendant-or-self::table[contains(@class, 'verse')]">
                                 <quote><lg><xsl:apply-templates select=".//table[contains(@class, 'verse')]//p" /></lg></quote>
                             </xsl:when>
                             <xsl:when test=".[name() = 'div' and .//table]">
                                 <xsl:apply-templates select=".//tr" />
                             </xsl:when>
                         </xsl:choose>
                     </xsl:for-each>
                 </div>
             </xsl:if>
         </xsl:for-each-group>
        </div>
    </xsl:template>
    
    <xsl:template name="lg">
        <xsl:param name="div"/>
        <lg><xsl:apply-templates select="$div"/></lg>
    </xsl:template>
    
    <xsl:template name="br">
        <lb />
    </xsl:template>
    
    <xsl:template match="p[ancestor::node()[contains(@class, 'verse')]]">
        <l><xsl:apply-templates /></l>
    </xsl:template>
    
    <xsl:template match="span[@class='small']">
        <num><xsl:apply-templates/></num>
    </xsl:template>
    
    <xsl:template match="span[@class='emend']">
        <corr><xsl:apply-templates/></corr>
    </xsl:template>
    
    <xsl:template match="tr">
        <list rend="row"><xsl:apply-templates/></list>
    </xsl:template>
    
    <xsl:template match="td">
        <item rend="cell"><xsl:apply-templates/></item>
    </xsl:template>
    
    <xsl:template match="span[@class='smallcaps']">
        <head><xsl:apply-templates /></head>
    </xsl:template>
    
    <xsl:template match="a[@class='sec']">
        <xsl:element name="milestone">
            <xsl:attribute name="unit">section</xsl:attribute>
            <xsl:attribute name="n"><xsl:value-of select="@name" /></xsl:attribute> 
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="span[@class='poor_reading']">
        <del cert="low"><xsl:apply-templates /></del>
    </xsl:template>
    
    <xsl:template match="span[@class='greek' or @class='Greek']">
        <foreign xml:lang="grc"><xsl:apply-templates/></foreign>
    </xsl:template>
    
    <xsl:template match="span[@class='lapis']">
        <xsl:variable name="cntwords" select=
            "string-length(normalize-space(.))
            -
            string-length(translate(normalize-space(.),' ','')) +1
            "/>
        <xsl:choose>
            <xsl:when test="$cntwords > 1">
                <q><xsl:apply-templates /></q>
            </xsl:when>
            <xsl:otherwise>
                <term><xsl:apply-templates /></term>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="img">
        <xsl:element name="g">
            <xsl:attribute name="type">monograph</xsl:attribute>
            <xsl:value-of select="normalize-space(@alt)" />
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="a[@class='chapter']" />
    
    <xsl:template match="p[contains(@class, 'halfstart')]" />
    
</xsl:stylesheet>
