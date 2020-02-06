<?xml version='1.0'?>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:exsl="http://exslt.org/common"
    xmlns:date="http://exslt.org/dates-and-times"
    extension-element-prefixes="exsl date"
>
<xsl:import href="./mathbook-latex.xsl" />

<xsl:output method="text" indent="no"/>

<xsl:template match="/">
    <xsl:call-template name="banner-warning">
        <xsl:with-param name="warning">Conversion to Beamer presentations/slideshows is experimental and needs improvements&#xa;Requests for additional specific constructions welcome&#xa;Additional PreTeXt elements are subject to change</xsl:with-param>
      </xsl:call-template>
  <xsl:apply-templates select="pretext"/>
</xsl:template>

<xsl:template match="/pretext">
  <xsl:apply-templates select="slideshow" />
</xsl:template>

<xsl:template match="slideshow">
  <xsl:call-template name="preamble" />
  <xsl:call-template name="body" />
</xsl:template>

<xsl:template name="preamble">
  <xsl:text>\documentclass[11pt, compress]{beamer}&#xa;</xsl:text>
  <xsl:text>\usepackage{amsmath}&#xa;</xsl:text>

  <xsl:text>\usetheme{Boadilla}&#xa;</xsl:text>
  <xsl:text>\usefonttheme[onlymath]{serif}&#xa;</xsl:text>
  <xsl:text>%get rid of navigation:&#xa;\setbeamertemplate{navigation symbols}{}&#xa;</xsl:text>
  <xsl:text>&#xa;&#xa; %%%% Start PreTeXt generated preamble: %%%%% &#xa;&#xa;</xsl:text>
  <xsl:text>\newcommand{\tabularfont}{}&#xa;</xsl:text>
  <xsl:text>\usepackage[xparse, raster]{tcolorbox}&#xa;</xsl:text>
  <xsl:text>\tcbset{colback=white, colframe=white}&#xa;</xsl:text>
  <xsl:text>\NewTColorBox{image}{mmm}{boxrule=0.25pt, colframe=gray, left skip=#1\linewidth,width=#2\linewidth}&#xa;</xsl:text>
  <xsl:text>\RenewTColorBox{definition}{m}{colback=teal!30!white, colbacktitle=teal!30!white, coltitle=black, colframe=gray, boxrule=0.5pt, sharp corners=downhill, titlerule = 0.25pt, title={#1}}&#xa;</xsl:text>
  <xsl:text>\RenewTColorBox{theorem}{m}{colback=pink!30!white, colbacktitle=pink!30!white, coltitle=black, colframe=gray, boxrule=0.5pt, sharp corners=downhill, titlerule = 0.25pt, title={#1}}&#xa;</xsl:text>
  <xsl:text>\RenewTColorBox{proof}{}{boxrule=0.25pt, colframe=gray, colback=white, before upper={Proof:}, after upper={\qed}}&#xa;</xsl:text>
  <xsl:if test="$document-root//sidebyside">
    <!-- "minimal" is no border or spacing at all -->
    <!-- set on $sbsdebug to "tight" with some background    -->
    <!-- From the tcolorbox manual, "center" vs. "flush center":      -->
    <!-- "The differences between the flush and non-flush version     -->
    <!-- are explained in detail in the TikZ manual. The short story  -->
    <!-- is that the non-flush versions will often look more balanced -->
    <!-- but with more hyphenations."                                 -->
    <xsl:choose>
      <xsl:when test="$sbsdebug">
        <xsl:text>%% tcolorbox styles for *DEBUGGING* sidebyside layout&#xa;</xsl:text>
        <xsl:text>%% "tight" -> 0.4pt border, pink background&#xa;</xsl:text>
        <xsl:text>\tcbset{ sbsstyle/.style={raster equal height=rows,raster force size=false} }&#xa;</xsl:text>
        <xsl:text>\tcbset{ sbspanelstyle/.style={size=tight,colback=pink} }&#xa;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>%% tcolorbox styles for sidebyside layout&#xa;</xsl:text>
        <!-- "frame empty" is needed to counteract very faint outlines in some PDF viewers -->
        <!-- framecol=white is inadvisable, "frame hidden" is ineffective for default skin -->
        <xsl:text>\tcbset{ bwminimalstyle/.style={size=minimal, boxrule=-0.3pt, frame empty,&#xa;</xsl:text>
        <xsl:text>colback=white, colbacktitle=white, coltitle=black, opacityfill=0.0} }&#xa;</xsl:text>
        <xsl:text>\tcbset{ sbsstyle/.style={raster before skip=2.0ex, raster equal height=rows, raster force size=false} }&#xa;</xsl:text>
        <xsl:text>\tcbset{ sbspanelstyle/.style={bwminimalstyle} }&#xa;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>%% Enviroments for side-by-side and components&#xa;</xsl:text>
    <xsl:text>%% Necessary to use \NewTColorBox for boxes of the panels&#xa;</xsl:text>
    <xsl:text>%% "newfloat" environment to squash page-breaks within a single sidebyside&#xa;</xsl:text>
    <!-- Main side-by-side environment, given by xparse            -->
    <!-- raster equal height: boxes of same *row* have same height -->
    <!-- raster force size: false lets us control width            -->
    <!-- We do not try here to keep captions attached (when not    -->
    <!-- in a "figure"), unfortunately, this is an un-semantic     -->
    <!-- command inbetween the list of panels and the captions     -->
    <xsl:text>%% "xparse" environment for entire sidebyside&#xa;</xsl:text>
    <xsl:text>\NewDocumentEnvironment{sidebyside}{mmmm}&#xa;</xsl:text>
    <xsl:text>  {\begin{tcbraster}&#xa;</xsl:text>
    <xsl:text>    [sbsstyle,raster columns=#1,&#xa;</xsl:text>
    <xsl:text>    raster left skip=#2\linewidth,raster right skip=#3\linewidth,raster column skip=#4\linewidth]}&#xa;</xsl:text>
    <xsl:text>  {\end{tcbraster}}&#xa;</xsl:text>
    <xsl:text>%% "tcolorbox" environment for a panel of sidebyside&#xa;</xsl:text>
    <xsl:text>\NewTColorBox{sbspanel}{mO{top}}{sbspanelstyle,width=#1\linewidth,valign=#2}&#xa;</xsl:text>
  </xsl:if>

  <xsl:if test="//tabular">
    <xsl:text>%% For improved tables&#xa;</xsl:text>
    <xsl:text>\usepackage{array}&#xa;</xsl:text>
    <xsl:text>%% Some extra height on each row is desirable, especially with horizontal rules&#xa;</xsl:text>
    <xsl:text>%% Increment determined experimentally&#xa;</xsl:text>
    <xsl:text>\setlength{\extrarowheight}{0.2ex}&#xa;</xsl:text>
    <xsl:text>%% Define variable thickness horizontal rules, full and partial&#xa;</xsl:text>
    <xsl:text>%% Thicknesses are 0.03, 0.05, 0.08 in the  booktabs  package&#xa;</xsl:text>
    <!-- http://tex.stackexchange.com/questions/119153/table-with-different-rule-widths -->
    <xsl:text>\newcommand{\hrulethin}  {\noalign{\hrule height 0.04em}}&#xa;</xsl:text>
    <xsl:text>\newcommand{\hrulemedium}{\noalign{\hrule height 0.07em}}&#xa;</xsl:text>
    <xsl:text>\newcommand{\hrulethick} {\noalign{\hrule height 0.11em}}&#xa;</xsl:text>
    <!-- http://tex.stackexchange.com/questions/24549/horizontal-rule-with-adjustable-height-behaving-like-clinen-m -->
    <!-- Could preserve/restore \arrayrulewidth on entry/exit to tabular -->
    <!-- But we'll get cleaner source with this built into macros        -->
    <!-- Could condition \setlength debacle on the use of extpfeil       -->
    <!-- arrows (see discussion below)                                   -->
    <xsl:text>%% We preserve a copy of the \setlength package before other&#xa;</xsl:text>
    <xsl:text>%% packages (extpfeil) get a chance to load packages that redefine it&#xa;</xsl:text>
    <xsl:text>\let\oldsetlength\setlength&#xa;</xsl:text>
    <xsl:text>\newlength{\Oldarrayrulewidth}&#xa;</xsl:text>
    <xsl:text>\newcommand{\crulethin}[1]%&#xa;</xsl:text>
    <xsl:text>{\noalign{\global\oldsetlength{\Oldarrayrulewidth}{\arrayrulewidth}}%&#xa;</xsl:text>
    <xsl:text>\noalign{\global\oldsetlength{\arrayrulewidth}{0.04em}}\cline{#1}%&#xa;</xsl:text>
    <xsl:text>\noalign{\global\oldsetlength{\arrayrulewidth}{\Oldarrayrulewidth}}}%&#xa;</xsl:text>
    <xsl:text>\newcommand{\crulemedium}[1]%&#xa;</xsl:text>
    <xsl:text>{\noalign{\global\oldsetlength{\Oldarrayrulewidth}{\arrayrulewidth}}%&#xa;</xsl:text>
    <xsl:text>\noalign{\global\oldsetlength{\arrayrulewidth}{0.07em}}\cline{#1}%&#xa;</xsl:text>
    <xsl:text>\noalign{\global\oldsetlength{\arrayrulewidth}{\Oldarrayrulewidth}}}&#xa;</xsl:text>
    <xsl:text>\newcommand{\crulethick}[1]%&#xa;</xsl:text>
    <xsl:text>{\noalign{\global\oldsetlength{\Oldarrayrulewidth}{\arrayrulewidth}}%&#xa;</xsl:text>
    <xsl:text>\noalign{\global\oldsetlength{\arrayrulewidth}{0.11em}}\cline{#1}%&#xa;</xsl:text>
    <xsl:text>\noalign{\global\oldsetlength{\arrayrulewidth}{\Oldarrayrulewidth}}}&#xa;</xsl:text>
    <!-- http://tex.stackexchange.com/questions/119153/table-with-different-rule-widths -->
    <xsl:text>%% Single letter column specifiers defined via array package&#xa;</xsl:text>
    <xsl:text>\newcolumntype{A}{!{\vrule width 0.04em}}&#xa;</xsl:text>
    <xsl:text>\newcolumntype{B}{!{\vrule width 0.07em}}&#xa;</xsl:text>
    <xsl:text>\newcolumntype{C}{!{\vrule width 0.11em}}&#xa;</xsl:text>
  </xsl:if>
  <xsl:if test="$document-root//cell/line">
    <xsl:text>\newcommand{\tablecelllines}[3]%&#xa;</xsl:text>
    <xsl:text>{\begin{tabular}[#2]{@{}#1@{}}#3\end{tabular}}&#xa;</xsl:text>
  </xsl:if>

  <xsl:text>\newcommand{\terminology}[1]{\textbf{#1}}</xsl:text>
  <xsl:text>\newcommand{\lt}{&lt;}&#xa;</xsl:text>
  <xsl:text>\newcommand{\gt}{&gt;}&#xa;</xsl:text>
  <xsl:text>\newcommand{\amp}{&amp;}&#xa;&#xa;</xsl:text>


  <xsl:apply-templates select="/pretext/docinfo/macros"/>
  <xsl:if test="$docinfo/latex-image-preamble">
    <xsl:text>%% Graphics Preamble Entries&#xa;</xsl:text>
    <xsl:call-template name="sanitize-text">
      <xsl:with-param name="text" select="$docinfo/latex-image-preamble" />
    </xsl:call-template>
  </xsl:if>
  <xsl:text>&#xa;&#xa;%%%% End of PreTeXt generated preamble %%%%% &#xa;&#xa;</xsl:text>
</xsl:template>

<xsl:template match="pretext/docinfo/macros">
    <xsl:value-of select="."/>
    <xsl:text>&#xa;</xsl:text>
</xsl:template>

<xsl:template name="body">
  <xsl:text>\title{</xsl:text>
    <xsl:apply-templates select="." mode="title-full" />
  <xsl:text>}&#xa;</xsl:text>
  <xsl:text>\subtitle{</xsl:text>
    <xsl:apply-templates select="." mode="subtitle" />
  <xsl:text>}&#xa;</xsl:text>
  <xsl:text>\author{</xsl:text>
    <xsl:apply-templates select="author" mode="article-info"/>
  <xsl:text>}&#xa;</xsl:text>
  <xsl:text>\date{}&#xa;&#xa;</xsl:text>
  <xsl:text>\begin{document}&#xa;</xsl:text>
  <xsl:call-template name="titlepage"/>
  <xsl:call-template name="beamertoc"/>

  <xsl:apply-templates select="section"/>
  <xsl:text>\end{document}&#xa;</xsl:text>
</xsl:template>

<xsl:template name="titlepage">
  <xsl:text>\begin{frame}&#xa;</xsl:text>
  <xsl:text>\maketitle &#xa;</xsl:text>
  <xsl:text>\end{frame}&#xa; &#xa;</xsl:text>
</xsl:template>
<xsl:template name="beamertoc">
  <xsl:text>\begin{frame}&#xa;</xsl:text>
  <xsl:text>\frametitle{Overview}&#xa;</xsl:text>
  <xsl:text>\tableofcontents &#xa;</xsl:text>
  <xsl:text>\end{frame}&#xa; &#xa;</xsl:text>
</xsl:template>

<xsl:template match="section">
  <xsl:text>&#xa;\section{</xsl:text>
    <xsl:apply-templates select="." mode="title-full" />
  <xsl:text>}&#xa;</xsl:text>
  <xsl:apply-templates select="slide"/>
  <xsl:text>&#xa;</xsl:text>
</xsl:template>

<xsl:template match="slide">
  <xsl:text>\begin{frame}&#xa;</xsl:text>
    <xsl:text>\frametitle{</xsl:text>
    <xsl:apply-templates select="." mode="title-full" />
    <xsl:text>}&#xa;</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>\end{frame}&#xa; &#xa;</xsl:text>
</xsl:template>


<xsl:template match="p">
    <xsl:if test="@pause = 'yes'">
        <xsl:text>&#xa;\pause \vfill &#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:text>&#xa;</xsl:text>
</xsl:template>

<xsl:template match="ul">
  <xsl:if test="@pause = 'yes'">
    <xsl:text>&#xa;\pause &#xa;&#xa;</xsl:text>
  </xsl:if>
  <xsl:text>\begin{itemize}</xsl:text>
  <xsl:if test="@pause = 'yes'">
    <xsl:text>[&lt;+-&gt;]</xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:text>\end{itemize}&#xa;</xsl:text>
</xsl:template>

<xsl:template match="ol">
  <xsl:if test="@pause = 'yes'">
    <xsl:text>&#xa;\pause &#xa;&#xa;</xsl:text>
  </xsl:if>
  <xsl:text>\begin{enumerate}</xsl:text>
  <xsl:if test="@pause = 'yes'">
    <xsl:text>[&lt;+-&gt;]</xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:text>\end{enumerate}&#xa;</xsl:text>
</xsl:template>

<xsl:template match="li">
  <xsl:text>&#xa;\item{} </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#xa;</xsl:text>
</xsl:template>

<!-- 
<xsl:template match="sidebyside">
  <xsl:text>\begin{tcbraster}[arc=0pt, raster columns=</xsl:text>
  <xsl:value-of select="count(*)"/>
  <xsl:text>, raster equal height=rows, raster force size=false, raster column skip=0ex] &#xa;</xsl:text>

  <xsl:variable name="columnCount">
    <xsl:value-of select="count(*)"/>
  </xsl:variable>
  <xsl:variable name="widthFraction">
    <xsl:value-of select="1 div $columnCount" />
  </xsl:variable>

  <xsl:for-each select="*">
    <xsl:if test="parent::*/@pause = 'yes'">
      <xsl:text>&#xa;\pause &#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:text>\begin{tcolorbox}[valign=top, width=</xsl:text>
      <xsl:value-of select="$widthFraction" />
    <xsl:text>\textwidth]&#xa;</xsl:text>
      <xsl:apply-templates select="."/>
    <xsl:text>\end{tcolorbox}&#xa; </xsl:text>
  </xsl:for-each>
  <xsl:text>\end{tcbraster} &#xa;</xsl:text>
</xsl:template> -->

<xsl:template match="proof">
  <xsl:text>\begin{proof}</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>\end{proof}</xsl:text>
</xsl:template>

<xsl:template match="xref">
  [REF=TODO]
<!--  Look up this in some xsl files -->
<!-- <xsl:template match="*" mode="xref-link">
    <xsl:param name="target" />
    <xsl:param name="content" />

    <xsl:copy-of select="$content"/>
</xsl:template> -->
</xsl:template>



<xsl:template match="example">
  <xsl:text>\begin{example}[</xsl:text>
  <xsl:if test="@source-number">
    <xsl:value-of select="@source-number"/>
  </xsl:if>
  <xsl:apply-templates select="." mode="title-full" />
<xsl:text>]</xsl:text>
    <xsl:apply-templates/>
<xsl:text>\end{example}&#xa;</xsl:text>
</xsl:template>


<xsl:template match="definition" mode="type-name">
  <xsl:text>Definition</xsl:text>
</xsl:template>
<xsl:template match="definition">
  <xsl:text>\begin{definition}{</xsl:text>
  <xsl:apply-templates select="." mode="type-name" />
  <xsl:choose>
  <xsl:when test="@source-number">
    (<xsl:value-of select="@source-number"/>)
  </xsl:when>
</xsl:choose>
<xsl:text>: </xsl:text>
  <xsl:apply-templates select="." mode="title-full" />
<xsl:text>}</xsl:text>
    <xsl:apply-templates/>
<xsl:text>\end{definition}&#xa;</xsl:text>
</xsl:template>

<xsl:template match="theorem" mode="type-name">
  <xsl:text>Theorem</xsl:text>
</xsl:template>
<xsl:template match="corollary" mode="type-name">
  <xsl:text>Corollary</xsl:text>
</xsl:template>
<xsl:template match="theorem|corollary">
  <xsl:text>\begin{theorem}{</xsl:text>
  <xsl:apply-templates select="." mode="type-name" />
  <xsl:choose>
  <xsl:when test="@source-number">
     (<xsl:value-of select="@source-number"/>)
  </xsl:when>
</xsl:choose>
<xsl:text>: </xsl:text>
  <xsl:apply-templates select="." mode="title-full" />
<xsl:text>}</xsl:text>
    <xsl:apply-templates select="statement"/>
<xsl:text>\end{theorem}&#xa;</xsl:text>
<xsl:apply-templates select="proof"/>
</xsl:template>

</xsl:stylesheet>
