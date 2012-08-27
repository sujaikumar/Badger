<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta name='layout' content='main'/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>${grailsApplication.config.projectID} search</title>
    <parameter name="search" value="selected"></parameter>
</head>
<body>
  <h1>Search the <i>Bicyclus anynana</i> genome data:</h1>
  <table>
  	<tr><td>
  		<g:link controller="search" action="unigene_search">UniGenes</g:link></td><td>${printf("%,d\n",bicyclus_anynana.UnigeneInfo.count())} UniGenes were generated by assemlbing the 100,595 public <i>B. anynana</i> ESTs with CAP3. Functional annotations
  		were then assigned using BLAST, annot8r and InterProScan.
  	</td></tr>
  </table>
</body>
</html>
