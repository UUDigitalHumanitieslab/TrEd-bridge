<?xml version="1.0" encoding="utf-8"?>
<!-- -*- mode: xsl; coding: utf8; -*- -->
<!-- Author: pajas@ufal.mff.cuni.cz -->

<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' 
  xmlns:pml='http://ufal.mff.cuni.cz/pdt/pml/' version='1.0'>
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:namespace-alias stylesheet-prefix="pml" result-prefix="#default"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="pml:head">
  </xsl:template>

  <xsl:template match="pml:trees">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="pml:alpino_ds_pml">
    <alpino_ds version="{pml:version}">
      <xsl:apply-templates select="pml:trees"/>

      <!-- xsl:apply-templates select="pml:sentence"/> -->
      <sentence>
        <xsl:for-each select="//pml:node[@word]">
          <xsl:sort select="@wordno" data-type="number"/>
          <xsl:value-of select="@word"/>
          <xsl:if test="position() != last()">
            <xsl:text></xsl:text>
          </xsl:if>
        </xsl:for-each>
      </sentence>

      <!-- only add a comments element when there's comment data -->
      <!--    <xsl:if test="pml:comments/pml:comment"> -->
      <xsl:if test="string(pml:comments)">
        <xsl:apply-templates select="pml:comments"/>
      </xsl:if>

      <!-- only add a metadata element when there's meta data -->
      <xsl:if test="string(pml:metadata)">
        <xsl:apply-templates select="pml:metadata"/>
      </xsl:if>

    </alpino_ds>
  </xsl:template>

  <xsl:template match="*">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- only add an comment element when non-empty  -->
  <xsl:template match="pml:comment">
    <xsl:if test="string(.)">
      <xsl:element name="{name()}">
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <!-- <meta> tags -->
  <xsl:template match="pml:meta">
    <xsl:element name="meta">
      <xsl:attribute name="type">
        <xsl:value-of select="pml:type"/>
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:value-of select="pml:name"/>
      </xsl:attribute>
      <xsl:attribute name="value">
        <xsl:value-of select="pml:value"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>


  <xsl:template match="@*">
    <xsl:copy/>
  </xsl:template>


  <!-- create begin and end attributes based on @wordno 
     higher level begin/end attributes are added later
-->

  <xsl:template match="@wordno">
    <xsl:attribute name="begin">
      <xsl:value-of select=". - 1"/>
    </xsl:attribute>
    <xsl:attribute name="end">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>


  <xsl:template match="@postag">
    <xsl:copy/>
    <xsl:choose>
      <xsl:when test='starts-with(.,"TSW")'>
        <xsl:attribute name="pt">tsw</xsl:attribute>
      </xsl:when>
      <xsl:when test='starts-with(.,"N")'>
        <xsl:attribute name="pt">n</xsl:attribute>
      </xsl:when>
      <xsl:when test='starts-with(.,"ADJ")'>
        <xsl:attribute name="pt">adj</xsl:attribute>
      </xsl:when>
      <xsl:when test='starts-with(.,"WW")'>
        <xsl:attribute name="pt">ww</xsl:attribute>
      </xsl:when>
      <xsl:when test='starts-with(.,"TW")'>
        <xsl:attribute name="pt">tw</xsl:attribute>
      </xsl:when>
      <xsl:when test='starts-with(.,"VNW")'>
        <xsl:attribute name="pt">vnw</xsl:attribute>
      </xsl:when>
      <xsl:when test='starts-with(.,"LID")'>
        <xsl:attribute name="pt">lid</xsl:attribute>
      </xsl:when>
      <xsl:when test='starts-with(.,"VZ")'>
        <xsl:attribute name="pt">vz</xsl:attribute>
      </xsl:when>
      <xsl:when test='starts-with(.,"VG")'>
        <xsl:attribute name="pt">vg</xsl:attribute>
      </xsl:when>
      <xsl:when test='starts-with(.,"BW")'>
        <xsl:attribute name="pt">bw</xsl:attribute>
      </xsl:when>
      <xsl:when test='starts-with(.,"SPEC")'>
        <xsl:attribute name="pt">spec</xsl:attribute>
      </xsl:when>
      <xsl:when test='starts-with(.,"LET")'>
        <xsl:attribute name="pt">let</xsl:attribute>
      </xsl:when>

    </xsl:choose>
    <xsl:choose>
      <xsl:when test='.="TSW(dial)"'>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>

      <xsl:when test='.="N(soort,dial)"'>
        <xsl:attribute name="ntype">soort</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="N(eigen,dial)"'>
        <xsl:attribute name="ntype">eigen</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(dial)"'>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(dial)"'>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="TW(hoofd,dial)"'>
        <xsl:attribute name="numtype">hoofd</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="TW(rang,dial)"'>
        <xsl:attribute name="numtype">rang</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,dial)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(refl,pron,dial)"'>
        <xsl:attribute name="vwtype">refl</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(recip,pron,dial)"'>
        <xsl:attribute name="vwtype">recip</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,dial)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(vrag,pron,dial)"'>
        <xsl:attribute name="vwtype">vrag</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(vrag,det,dial)"'>
        <xsl:attribute name="vwtype">vrag</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(betr,pron,dial)"'>
        <xsl:attribute name="vwtype">betr</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(betr,det,dial)"'>
        <xsl:attribute name="vwtype">betr</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(excl,pron,dial)"'>
        <xsl:attribute name="vwtype">excl</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(excl,det,dial)"'>
        <xsl:attribute name="vwtype">excl</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,pron,dial)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,det,dial)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,pron,dial)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,det,dial)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="LID(bep,dial)"'>
        <xsl:attribute name="lwtype">bep</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="LID(onbep,dial)"'>
        <xsl:attribute name="lwtype">onbep</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VZ(init,dial)"'>
        <xsl:attribute name="vztype">init</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VZ(fin,dial)"'>
        <xsl:attribute name="vztype">fin</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VG(neven,dial)"'>
        <xsl:attribute name="conjtype">neven</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VG(onder,dial)"'>
        <xsl:attribute name="conjtype">onder</xsl:attribute>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="BW(dial)"'>
        <xsl:attribute name="dial">dial</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="TSW()"'></xsl:when>
      <xsl:when test='.="SPEC(afgebr)"'>
        <xsl:attribute name="spectype">afgebr</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="SPEC(onverst)"'>
        <xsl:attribute name="spectype">onverst</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="SPEC(enof)"'>
        <xsl:attribute name="spectype">enof</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="SPEC(vreemd)"'>
        <xsl:attribute name="spectype">vreemd</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="SPEC(deeleigen)"'>
        <xsl:attribute name="spectype">deeleigen</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="SPEC(meta)"'>
        <xsl:attribute name="spectype">meta</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="LET()"'></xsl:when>
      <xsl:when test='.="SPEC(comment)"'>
        <xsl:attribute name="spectype">comment</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="SPEC(achter)"'>
        <xsl:attribute name="spectype">achter</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="SPEC(afk)"'>
        <xsl:attribute name="spectype">afk</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="SPEC(symb)"'>
        <xsl:attribute name="spectype">symb</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="N(soort,ev,basis,zijd,stan)"'>
        <xsl:attribute name="ntype">soort</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="genus">zijd</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="N(soort,ev,basis,onz,stan)"'>
        <xsl:attribute name="ntype">soort</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="genus">onz</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="N(soort,ev,dim,onz,stan)"'>
        <xsl:attribute name="ntype">soort</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="graad">dim</xsl:attribute>
        <xsl:attribute name="genus">onz</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="N(soort,ev,basis,gen)"'>
        <xsl:attribute name="ntype">soort</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="N(soort,ev,dim,gen)"'>
        <xsl:attribute name="ntype">soort</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="graad">dim</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="N(soort,ev,basis,dat)"'>
        <xsl:attribute name="ntype">soort</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="N(soort,mv,basis)"'>
        <xsl:attribute name="ntype">soort</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="N(soort,mv,dim)"'>
        <xsl:attribute name="ntype">soort</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="graad">dim</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="N(eigen,ev,basis,zijd,stan)"'>
        <xsl:attribute name="ntype">eigen</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="genus">zijd</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="N(eigen,ev,basis,onz,stan)"'>
        <xsl:attribute name="ntype">eigen</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="genus">onz</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="N(eigen,ev,dim,onz,stan)"'>
        <xsl:attribute name="ntype">eigen</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="graad">dim</xsl:attribute>
        <xsl:attribute name="genus">onz</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="N(eigen,ev,basis,gen)"'>
        <xsl:attribute name="ntype">eigen</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="N(eigen,ev,dim,gen)"'>
        <xsl:attribute name="ntype">eigen</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="graad">dim</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="N(eigen,ev,basis,dat)"'>
        <xsl:attribute name="ntype">eigen</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="N(eigen,mv,basis)"'>
        <xsl:attribute name="ntype">eigen</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="N(eigen,mv,dim)"'>
        <xsl:attribute name="ntype">eigen</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="graad">dim</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(prenom,basis,zonder)"'>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(prenom,basis,met-e,stan)"'>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(prenom,basis,met-e,bijz)"'>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="naamval">bijz</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(prenom,comp,zonder)"'>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="graad">comp</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(prenom,comp,met-e,stan)"'>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="graad">comp</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(prenom,comp,met-e,bijz)"'>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="graad">comp</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="naamval">bijz</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(prenom,sup,zonder)"'>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="graad">sup</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(prenom,sup,met-e,stan)"'>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="graad">sup</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(prenom,sup,met-e,bijz)"'>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="graad">sup</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="naamval">bijz</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(nom,basis,zonder,zonder-n)"'>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(nom,basis,zonder,mv-n)"'>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(nom,basis,met-e,zonder-n,stan)"'>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(nom,basis,met-e,zonder-n,bijz)"'>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
        <xsl:attribute name="naamval">bijz</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(nom,basis,met-e,mv-n)"'>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(nom,comp,zonder,zonder-n)"'>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="graad">comp</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(nom,comp,met-e,zonder-n,stan)"'>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="graad">comp</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(nom,comp,met-e,zonder-n,bijz)"'>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="graad">comp</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
        <xsl:attribute name="naamval">bijz</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(nom,comp,met-e,mv-n)"'>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="graad">comp</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(nom,sup,zonder,zonder-n)"'>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="graad">sup</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(nom,sup,met-e,zonder-n,stan)"'>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="graad">sup</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(nom,sup,met-e,zonder-n,bijz)"'>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="graad">sup</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
        <xsl:attribute name="naamval">bijz</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(nom,sup,met-e,mv-n)"'>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="graad">sup</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(postnom,basis,zonder)"'>
        <xsl:attribute name="positie">postnom</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(postnom,basis,met-s)"'>
        <xsl:attribute name="positie">postnom</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="buiging">met-s</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(postnom,comp,zonder)"'>
        <xsl:attribute name="positie">postnom</xsl:attribute>
        <xsl:attribute name="graad">comp</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(postnom,comp,met-s)"'>
        <xsl:attribute name="positie">postnom</xsl:attribute>
        <xsl:attribute name="graad">comp</xsl:attribute>
        <xsl:attribute name="buiging">met-s</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(vrij,basis,zonder)"'>
        <xsl:attribute name="positie">vrij</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(vrij,comp,zonder)"'>
        <xsl:attribute name="positie">vrij</xsl:attribute>
        <xsl:attribute name="graad">comp</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(vrij,sup,zonder)"'>
        <xsl:attribute name="positie">vrij</xsl:attribute>
        <xsl:attribute name="graad">sup</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="ADJ(vrij,dim,zonder)"'>
        <xsl:attribute name="positie">vrij</xsl:attribute>
        <xsl:attribute name="graad">dim</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(pv,tgw,ev)"'>
        <xsl:attribute name="wvorm">pv</xsl:attribute>
        <xsl:attribute name="pvtijd">tgw</xsl:attribute>
        <xsl:attribute name="pvagr">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(pv,tgw,mv)"'>
        <xsl:attribute name="wvorm">pv</xsl:attribute>
        <xsl:attribute name="pvtijd">tgw</xsl:attribute>
        <xsl:attribute name="pvagr">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(pv,tgw,met-t)"'>
        <xsl:attribute name="wvorm">pv</xsl:attribute>
        <xsl:attribute name="pvtijd">tgw</xsl:attribute>
        <xsl:attribute name="pvagr">met-t</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(pv,verl,ev)"'>
        <xsl:attribute name="wvorm">pv</xsl:attribute>
        <xsl:attribute name="pvtijd">verl</xsl:attribute>
        <xsl:attribute name="pvagr">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(pv,verl,mv)"'>
        <xsl:attribute name="wvorm">pv</xsl:attribute>
        <xsl:attribute name="pvtijd">verl</xsl:attribute>
        <xsl:attribute name="pvagr">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(pv,verl,met-t)"'>
        <xsl:attribute name="wvorm">pv</xsl:attribute>
        <xsl:attribute name="pvtijd">verl</xsl:attribute>
        <xsl:attribute name="pvagr">met-t</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(pv,conj,ev)"'>
        <xsl:attribute name="wvorm">pv</xsl:attribute>
        <xsl:attribute name="pvtijd">conj</xsl:attribute>
        <xsl:attribute name="pvagr">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(inf,prenom,zonder)"'>
        <xsl:attribute name="wvorm">inf</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(inf,prenom,met-e)"'>
        <xsl:attribute name="wvorm">inf</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(inf,nom,zonder,zonder-n)"'>
        <xsl:attribute name="wvorm">inf</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(inf,vrij,zonder)"'>
        <xsl:attribute name="wvorm">inf</xsl:attribute>
        <xsl:attribute name="positie">vrij</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(vd,prenom,zonder)"'>
        <xsl:attribute name="wvorm">vd</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(vd,prenom,met-e)"'>
        <xsl:attribute name="wvorm">vd</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(vd,nom,met-e,zonder-n)"'>
        <xsl:attribute name="wvorm">vd</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(vd,nom,met-e,mv-n)"'>
        <xsl:attribute name="wvorm">vd</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(vd,vrij,zonder)"'>
        <xsl:attribute name="wvorm">vd</xsl:attribute>
        <xsl:attribute name="positie">vrij</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(od,prenom,zonder)"'>
        <xsl:attribute name="wvorm">od</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(od,prenom,met-e)"'>
        <xsl:attribute name="wvorm">od</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(od,nom,met-e,zonder-n)"'>
        <xsl:attribute name="wvorm">od</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(od,nom,met-e,mv-n)"'>
        <xsl:attribute name="wvorm">od</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="WW(od,vrij,zonder)"'>
        <xsl:attribute name="wvorm">od</xsl:attribute>
        <xsl:attribute name="positie">vrij</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="TW(hoofd,prenom,stan)"'>
        <xsl:attribute name="numtype">hoofd</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="TW(hoofd,prenom,bijz)"'>
        <xsl:attribute name="numtype">hoofd</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="naamval">bijz</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="TW(hoofd,nom,zonder-n,basis)"'>
        <xsl:attribute name="numtype">hoofd</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="TW(hoofd,nom,mv-n,basis)"'>
        <xsl:attribute name="numtype">hoofd</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="TW(hoofd,nom,zonder-n,dim)"'>
        <xsl:attribute name="numtype">hoofd</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
        <xsl:attribute name="graad">dim</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="TW(hoofd,nom,mv-n,dim)"'>
        <xsl:attribute name="numtype">hoofd</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
        <xsl:attribute name="graad">dim</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="TW(hoofd,vrij)"'>
        <xsl:attribute name="numtype">hoofd</xsl:attribute>
        <xsl:attribute name="positie">vrij</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="TW(rang,prenom,stan)"'>
        <xsl:attribute name="numtype">rang</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="TW(rang,prenom,bijz)"'>
        <xsl:attribute name="numtype">rang</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="naamval">bijz</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="TW(rang,nom,zonder-n)"'>
        <xsl:attribute name="numtype">rang</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="TW(rang,nom,mv-n)"'>
        <xsl:attribute name="numtype">rang</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,vol,1,ev)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,nadr,1,ev)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">nadr</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,red,1,ev)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">red</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,vol,1,mv)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,nadr,1,mv)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">nadr</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,red,1,mv)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">red</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,vol,2v,ev)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">2v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,nadr,2v,ev)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">nadr</xsl:attribute>
        <xsl:attribute name="persoon">2v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,red,2v,ev)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">red</xsl:attribute>
        <xsl:attribute name="persoon">2v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,nadr,3m,ev,masc)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">nadr</xsl:attribute>
        <xsl:attribute name="persoon">3m</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="genus">masc</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,vol,3v,ev,fem)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="genus">fem</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,nadr,3v,ev,fem)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">nadr</xsl:attribute>
        <xsl:attribute name="persoon">3v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="genus">fem</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,obl,vol,2v,ev)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">2v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,obl,nadr,3m,ev,masc)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">nadr</xsl:attribute>
        <xsl:attribute name="persoon">3m</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="genus">masc</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,gen,vol,1,ev)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,gen,vol,1,mv)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,gen,vol,3m,ev)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3m</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,gen,vol,1,ev,prenom,zonder,evmo)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">evmo</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,gen,vol,1,mv,prenom,met-e,evmo)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">evmo</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,gen,vol,3v,ev,prenom,zonder,evmo)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">evmo</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,dat,vol,1,ev,prenom,met-e,evmo)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">evmo</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,dat,vol,1,ev,prenom,met-e,evf)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">evf</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,dat,vol,1,mv,prenom,met-e,evmo)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">evmo</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,dat,vol,1,mv,prenom,met-e,evf)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">evf</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,dat,vol,2v,ev,prenom,met-e,evf)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">2v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">evf</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,dat,vol,3v,ev,prenom,met-e,evmo)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">evmo</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,dat,vol,3v,ev,prenom,met-e,evf)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">evf</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,dat,vol,1,ev,nom,met-e,zonder-n)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,dat,vol,1,mv,nom,met-e,zonder-n)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,dat,vol,3m,ev,nom,met-e,zonder-n)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3m</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,dat,vol,3v,ev,nom,met-e,zonder-n)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(betr,pron,gen,vol,3o,ev)"'>
        <xsl:attribute name="vwtype">betr</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3o</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,pron,gen,vol,3m,ev)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3m</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,pron,gen,vol,3o,ev)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3o</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,det,dat,prenom,met-e,evmo)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">evmo</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,det,dat,prenom,met-e,evf)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">evf</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,det,gen,nom,met-e,zonder-n)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,det,dat,nom,met-e,zonder-n)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,det,gen,prenom,met-e,mv)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,det,dat,prenom,met-e,evmo)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">evmo</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,det,dat,prenom,met-e,evf)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">evf</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,det,gen,nom,met-e,mv-n)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,grad,gen,nom,met-e,mv-n,basis)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">grad</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="LID(bep,stan,evon)"'>
        <xsl:attribute name="lwtype">bep</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="npagr">evon</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="LID(bep,stan,rest)"'>
        <xsl:attribute name="lwtype">bep</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="npagr">rest</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="LID(bep,gen,evmo)"'>
        <xsl:attribute name="lwtype">bep</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="npagr">evmo</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="LID(bep,dat,evmo)"'>
        <xsl:attribute name="lwtype">bep</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="npagr">evmo</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="LID(bep,dat,evf)"'>
        <xsl:attribute name="lwtype">bep</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="npagr">evf</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="LID(bep,dat,mv)"'>
        <xsl:attribute name="lwtype">bep</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="LID(onbep,gen,evf)"'>
        <xsl:attribute name="lwtype">onbep</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="npagr">evf</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VZ(init)"'>
        <xsl:attribute name="vztype">init</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VZ(fin)"'>
        <xsl:attribute name="vztype">fin</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VZ(versm)"'>
        <xsl:attribute name="vztype">versm</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VG(neven)"'>
        <xsl:attribute name="conjtype">neven</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VG(onder)"'>
        <xsl:attribute name="conjtype">onder</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="BW()"'></xsl:when>
      <xsl:when test='.="N(soort,ev,basis,genus,stan)"'>
        <xsl:attribute name="ntype">soort</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="genus">genus</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="N(eigen,ev,basis,genus,stan)"'>
        <xsl:attribute name="ntype">eigen</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
        <xsl:attribute name="genus">genus</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,vol,2b,getal)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">2b</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,nadr,2b,getal)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">nadr</xsl:attribute>
        <xsl:attribute name="persoon">2b</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,vol,2,getal)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">2</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,nadr,2,getal)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">nadr</xsl:attribute>
        <xsl:attribute name="persoon">2</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,red,2,getal)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">red</xsl:attribute>
        <xsl:attribute name="persoon">2</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,vol,3,ev,masc)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="genus">masc</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,red,3,ev,masc)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">red</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="genus">masc</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,red,3p,ev,masc)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">red</xsl:attribute>
        <xsl:attribute name="persoon">3p</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="genus">masc</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,vol,3p,mv)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3p</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,nomin,nadr,3p,mv)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">nomin</xsl:attribute>
        <xsl:attribute name="status">nadr</xsl:attribute>
        <xsl:attribute name="persoon">3p</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,obl,vol,3,ev,masc)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="genus">masc</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,obl,red,3,ev,masc)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">red</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="genus">masc</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,obl,vol,3,getal,fem)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
        <xsl:attribute name="genus">fem</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,obl,nadr,3v,getal,fem)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">nadr</xsl:attribute>
        <xsl:attribute name="persoon">3v</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
        <xsl:attribute name="genus">fem</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,obl,red,3v,getal,fem)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">red</xsl:attribute>
        <xsl:attribute name="persoon">3v</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
        <xsl:attribute name="genus">fem</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,obl,vol,3p,mv)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3p</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,obl,nadr,3p,mv)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">nadr</xsl:attribute>
        <xsl:attribute name="persoon">3p</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,stan,nadr,2v,mv)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">nadr</xsl:attribute>
        <xsl:attribute name="persoon">2v</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,stan,red,3,ev,onz)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">red</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="genus">onz</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,stan,red,3,ev,fem)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">red</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="genus">fem</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,stan,red,3,mv)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">red</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,gen,vol,2,getal)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">2</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,gen,vol,3v,getal)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3v</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pers,pron,gen,vol,3p,mv)"'>
        <xsl:attribute name="vwtype">pers</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3p</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pr,pron,obl,vol,1,ev)"'>
        <xsl:attribute name="vwtype">pr</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pr,pron,obl,nadr,1,ev)"'>
        <xsl:attribute name="vwtype">pr</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">nadr</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pr,pron,obl,red,1,ev)"'>
        <xsl:attribute name="vwtype">pr</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">red</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pr,pron,obl,vol,1,mv)"'>
        <xsl:attribute name="vwtype">pr</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pr,pron,obl,nadr,1,mv)"'>
        <xsl:attribute name="vwtype">pr</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">nadr</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pr,pron,obl,red,2v,getal)"'>
        <xsl:attribute name="vwtype">pr</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">red</xsl:attribute>
        <xsl:attribute name="persoon">2v</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pr,pron,obl,nadr,2v,getal)"'>
        <xsl:attribute name="vwtype">pr</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">nadr</xsl:attribute>
        <xsl:attribute name="persoon">2v</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pr,pron,obl,vol,2,getal)"'>
        <xsl:attribute name="vwtype">pr</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">2</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(pr,pron,obl,nadr,2,getal)"'>
        <xsl:attribute name="vwtype">pr</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">nadr</xsl:attribute>
        <xsl:attribute name="persoon">2</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(refl,pron,obl,red,3,getal)"'>
        <xsl:attribute name="vwtype">refl</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">red</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(refl,pron,obl,nadr,3,getal)"'>
        <xsl:attribute name="vwtype">refl</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">nadr</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(recip,pron,obl,vol,persoon,mv)"'>
        <xsl:attribute name="vwtype">recip</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">persoon</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(recip,pron,gen,vol,persoon,mv)"'>
        <xsl:attribute name="vwtype">recip</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">persoon</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,1,ev,prenom,zonder,agr)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">agr</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,1,ev,prenom,met-e,rest)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">rest</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,red,1,ev,prenom,zonder,agr)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">red</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">agr</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,1,mv,prenom,zonder,evon)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">evon</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,1,mv,prenom,met-e,rest)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">rest</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,2,getal,prenom,zonder,agr)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">2</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">agr</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,2,getal,prenom,met-e,rest)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">2</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">rest</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,2v,ev,prenom,zonder,agr)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">2v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">agr</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,red,2v,ev,prenom,zonder,agr)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">red</xsl:attribute>
        <xsl:attribute name="persoon">2v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">agr</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,nadr,2v,mv,prenom,zonder,agr)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">nadr</xsl:attribute>
        <xsl:attribute name="persoon">2v</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">agr</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,3,ev,prenom,zonder,agr)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">agr</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,3m,ev,prenom,met-e,rest)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3m</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">rest</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,3v,ev,prenom,met-e,rest)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">rest</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,red,3,ev,prenom,zonder,agr)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">red</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">agr</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,3,mv,prenom,zonder,agr)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">agr</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,3p,mv,prenom,met-e,rest)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3p</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">rest</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,red,3,getal,prenom,zonder,agr)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">red</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">agr</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,gen,vol,1,ev,prenom,met-e,rest3)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">rest3</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,gen,vol,1,mv,prenom,met-e,rest3)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">rest3</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,gen,vol,2,getal,prenom,zonder,evmo)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">2</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">evmo</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,gen,vol,2,getal,prenom,met-e,rest3)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">2</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">rest3</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,gen,vol,2v,ev,prenom,met-e,rest3)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">2v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">rest3</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,gen,vol,3,ev,prenom,zonder,evmo)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">evmo</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,gen,vol,3,ev,prenom,met-e,rest3)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">rest3</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,gen,vol,3v,ev,prenom,met-e,rest3)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">rest3</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,gen,vol,3p,mv,prenom,zonder,evmo)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3p</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">evmo</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,gen,vol,3p,mv,prenom,met-e,rest3)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3p</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">rest3</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,dat,vol,2,getal,prenom,met-e,evmo)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">2</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">evmo</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,dat,vol,2,getal,prenom,met-e,evf)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">2</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">evf</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,dat,vol,3,ev,prenom,met-e,evmo)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">evmo</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,dat,vol,3,ev,prenom,met-e,evf)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">evf</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,dat,vol,3p,mv,prenom,met-e,evmo)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3p</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">evmo</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,dat,vol,3p,mv,prenom,met-e,evf)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3p</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">evf</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,1,ev,nom,met-e,zonder-n)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,1,mv,nom,met-e,zonder-n)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,2,getal,nom,met-e,zonder-n)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">2</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,2v,ev,nom,met-e,zonder-n)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">2v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,3m,ev,nom,met-e,zonder-n)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3m</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,3v,ev,nom,met-e,zonder-n)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,3p,mv,nom,met-e,zonder-n)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3p</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,1,ev,nom,met-e,mv-n)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,1,mv,nom,met-e,mv-n)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">1</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,2,getal,nom,met-e,mv-n)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">2</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,2v,ev,nom,met-e,mv-n)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">2v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,3m,ev,nom,met-e,mv-n)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3m</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,3v,ev,nom,met-e,mv-n)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,stan,vol,3p,mv,nom,met-e,mv-n)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3p</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,dat,vol,2,getal,nom,met-e,zonder-n)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">2</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(bez,det,dat,vol,3p,mv,nom,met-e,zonder-n)"'>
        <xsl:attribute name="vwtype">bez</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">dat</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3p</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(vrag,pron,stan,nadr,3o,ev)"'>
        <xsl:attribute name="vwtype">vrag</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">nadr</xsl:attribute>
        <xsl:attribute name="persoon">3o</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(betr,pron,stan,vol,persoon,getal)"'>
        <xsl:attribute name="vwtype">betr</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">persoon</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(betr,pron,stan,vol,3,ev)"'>
        <xsl:attribute name="vwtype">betr</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(betr,det,stan,nom,zonder,zonder-n)"'>
        <xsl:attribute name="vwtype">betr</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(betr,det,stan,nom,met-e,zonder-n)"'>
        <xsl:attribute name="vwtype">betr</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(betr,pron,gen,vol,3o,getal)"'>
        <xsl:attribute name="vwtype">betr</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3o</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(vb,pron,stan,vol,3p,getal)"'>
        <xsl:attribute name="vwtype">vb</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3p</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(vb,pron,stan,vol,3o,ev)"'>
        <xsl:attribute name="vwtype">vb</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3o</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(vb,pron,gen,vol,3m,ev)"'>
        <xsl:attribute name="vwtype">vb</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3m</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(vb,pron,gen,vol,3v,ev)"'>
        <xsl:attribute name="vwtype">vb</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3v</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(vb,pron,gen,vol,3p,mv)"'>
        <xsl:attribute name="vwtype">vb</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3p</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(vb,adv-pron,obl,vol,3o,getal)"'>
        <xsl:attribute name="vwtype">vb</xsl:attribute>
        <xsl:attribute name="pdtype">adv-pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3o</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(excl,pron,stan,vol,3,getal)"'>
        <xsl:attribute name="vwtype">excl</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(vb,det,stan,prenom,zonder,evon)"'>
        <xsl:attribute name="vwtype">vb</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">evon</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(vb,det,stan,prenom,met-e,rest)"'>
        <xsl:attribute name="vwtype">vb</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">rest</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(vb,det,stan,nom,met-e,zonder-n)"'>
        <xsl:attribute name="vwtype">vb</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(excl,det,stan,vrij,zonder)"'>
        <xsl:attribute name="vwtype">excl</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">vrij</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,pron,stan,vol,3o,ev)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3o</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,pron,stan,nadr,3o,ev)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">nadr</xsl:attribute>
        <xsl:attribute name="persoon">3o</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,pron,stan,vol,3,getal)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,adv-pron,obl,vol,3o,getal)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">adv-pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3o</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,adv-pron,stan,red,3,getal)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">adv-pron</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">red</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,det,stan,prenom,zonder,evon)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">evon</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,det,stan,prenom,zonder,rest)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">rest</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,det,stan,prenom,zonder,agr)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">agr</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,det,stan,prenom,met-e,rest)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">rest</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,det,gen,prenom,met-e,rest3)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">rest3</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,det,stan,nom,met-e,zonder-n)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,det,stan,nom,met-e,mv-n)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(aanw,det,stan,vrij,zonder)"'>
        <xsl:attribute name="vwtype">aanw</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">vrij</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,pron,stan,vol,3p,ev)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3p</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,pron,stan,vol,3o,ev)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3o</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,pron,gen,vol,3p,ev)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">pron</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3p</xsl:attribute>
        <xsl:attribute name="getal">ev</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,adv-pron,obl,vol,3o,getal)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">adv-pron</xsl:attribute>
        <xsl:attribute name="naamval">obl</xsl:attribute>
        <xsl:attribute name="status">vol</xsl:attribute>
        <xsl:attribute name="persoon">3o</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,adv-pron,gen,red,3,getal)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">adv-pron</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="status">red</xsl:attribute>
        <xsl:attribute name="persoon">3</xsl:attribute>
        <xsl:attribute name="getal">getal</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,det,stan,prenom,zonder,evon)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">evon</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,det,stan,prenom,zonder,agr)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">agr</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,det,stan,prenom,met-e,evz)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">evz</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,det,stan,prenom,met-e,mv)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">mv</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,det,stan,prenom,met-e,rest)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">rest</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,det,stan,prenom,met-e,agr)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">agr</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,grad,stan,prenom,zonder,agr,basis)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">grad</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">agr</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,grad,stan,prenom,met-e,agr,basis)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">grad</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">agr</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,grad,stan,prenom,met-e,mv,basis)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">grad</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal">mv</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,grad,stan,prenom,zonder,agr,comp)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">grad</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="npagr">agr</xsl:attribute>
        <xsl:attribute name="graad">comp</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,grad,stan,prenom,met-e,agr,sup)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">grad</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">agr</xsl:attribute>
        <xsl:attribute name="graad">sup</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,grad,stan,prenom,met-e,agr,comp)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">grad</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">prenom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="npagr">agr</xsl:attribute>
        <xsl:attribute name="graad">comp</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,det,stan,nom,met-e,mv-n)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,det,stan,nom,met-e,zonder-n)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,det,stan,nom,zonder,zonder-n)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,grad,stan,nom,met-e,zonder-n,basis)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">grad</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,grad,stan,nom,met-e,mv-n,basis)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">grad</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,grad,stan,nom,met-e,zonder-n,sup)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">grad</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
        <xsl:attribute name="graad">sup</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,grad,stan,nom,met-e,mv-n,sup)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">grad</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">met-e</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
        <xsl:attribute name="graad">sup</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,grad,stan,nom,zonder,mv-n,dim)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">grad</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="getal-n">mv-n</xsl:attribute>
        <xsl:attribute name="graad">dim</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,det,stan,vrij,zonder)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">det</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">vrij</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,grad,stan,vrij,zonder,basis)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">grad</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">vrij</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="graad">basis</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,grad,stan,vrij,zonder,sup)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">grad</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">vrij</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="graad">sup</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,grad,stan,vrij,zonder,comp)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">grad</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">vrij</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="graad">comp</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="LID(bep,gen,rest3)"'>
        <xsl:attribute name="lwtype">bep</xsl:attribute>
        <xsl:attribute name="naamval">gen</xsl:attribute>
        <xsl:attribute name="npagr">rest3</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="LID(onbep,stan,agr)"'>
        <xsl:attribute name="lwtype">onbep</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="npagr">agr</xsl:attribute>
      </xsl:when>
      <xsl:when test='.="VNW(onbep,grad,stan,nom,zonder,zonder-n,sup)"'>
        <xsl:attribute name="vwtype">onbep</xsl:attribute>
        <xsl:attribute name="pdtype">grad</xsl:attribute>
        <xsl:attribute name="naamval">stan</xsl:attribute>
        <xsl:attribute name="positie">nom</xsl:attribute>
        <xsl:attribute name="buiging">zonder</xsl:attribute>
        <xsl:attribute name="getal-n">zonder-n</xsl:attribute>
        <xsl:attribute name="graad">sup</xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
