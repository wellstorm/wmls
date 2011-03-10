<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.witsml.org/schemas/131"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:output method="text"/>

    
    <xsl:template match="/logs/log/logCurveInfo/mnemonic">
        <xsl:value-of select="text()"/> 
    </xsl:template>
        
    <xsl:template match="/logs/log/logCurveInfo"><xsl:apply-templates/></xsl:template>
    
    <xsl:template match="/logs/log"><xsl:apply-templates select="logCurveInfo"/></xsl:template>
    
    <xsl:template match="/logs"><xsl:apply-templates/></xsl:template>
    
</xsl:stylesheet>
