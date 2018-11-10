<?xml version='1.0'?>

<!-- ********************************************************************* -->
<!-- Copyright 2018                                                        -->
<!-- Robert A. Beezer, Oscar Levin                                         -->
<!--                                                                       -->
<!-- This file is part of PreTeXt.                                         -->
<!--                                                                       -->
<!-- PreTeXt is free software: you can redistribute it and/or modify       -->
<!-- it under the terms of the GNU General Public License as published by  -->
<!-- the Free Software Foundation, either version 2 or version 3 of the    -->
<!-- License (at your option).                                             -->
<!--                                                                       -->
<!-- PreTeXt is distributed in the hope that it will be useful,            -->
<!-- but WITHOUT ANY WARRANTY; without even the implied warranty of        -->
<!-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         -->
<!-- GNU General Public License for more details.                          -->
<!--                                                                       -->
<!-- You should have received a copy of the GNU General Public License     -->
<!-- along with PreTeXt.  If not, see <http://www.gnu.org/licenses/>.      -->
<!-- ********************************************************************* -->

<!-- Identify as a stylesheet -->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    exclude-result-prefixes="xsl"
>

<!-- To identify changes between editions, after an edition is declared,    -->
<!-- a script will insert permids on elements not containing ids from       -->
<!-- previous editions.  Then this xsl will build the tree structure of     -->
<!-- those elements that have permids, so that future editions can be       -->
<!-- compared to the current structure                                      -->


<!-- Import common stylesheet                        -->
<xsl:import href="./mathbook-common.xsl" />

<!-- We output a single, large .ptx file containing  -->
<!-- just the tree structure of elements with permids-->
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>


<!-- Match root, then start copying content -->
<xsl:template match="/">
  <xsl:apply-templates select="@* | node()"/>
</xsl:template>

<!-- Copy over all attributes (especially permids) -->
<xsl:template match="@*">
  <xsl:copy>
    <xsl:apply-templates select="@* | node()" />
  </xsl:copy>
</xsl:template>

<!-- Copy over any elements that contain a permid  -->
<!-- on any descendant                             -->
<xsl:template match="node()">
  <xsl:if test="*//@permid | @permid">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:if>
</xsl:template>

<!-- Strip out any attributes other than permid    -->
<xsl:template match="@*[not(name()='permid')]"/>

</xsl:stylesheet>
