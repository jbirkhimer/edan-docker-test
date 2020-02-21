<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output encoding="UTF-8" indent="yes" method="text"/>
    <xsl:template match="/">

<xsl:for-each select="/response/result/doc">
            <xsl:value-of select="str[@name='id']" disable-output-escaping="yes"/>
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>

</xsl:template>
</xsl:stylesheet>
