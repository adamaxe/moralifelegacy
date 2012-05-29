<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:template match="/">
                <testsuites>
                        <testsuite>
                                <xsl:for-each select="plist/dict/array/dict">
                                        <xsl:if test="integer = 4 or integer = 7">
                                                <testcase>
                                                        <xsl:attribute name="classname"><xsl:value-of select="string[2]" /></xsl:attribute>
                                                        <xsl:attribute name="name"><xsl:value-of select="string[2]"/></xsl:attribute>
                                                        <xsl:if test="string[1] = 'Fail'">
                                                                <failure>
                                                                        <xsl:attribute name="type"><xsl:value-of select="integer" /></xsl:attribute><xsl:value-of select="string[2]" />                                           
                                                                </failure>
                                                        </xsl:if>
                                                </testcase>
                                        </xsl:if>
                                </xsl:for-each>
                        </testsuite>
                </testsuites>
        </xsl:template>
</xsl:stylesheet>