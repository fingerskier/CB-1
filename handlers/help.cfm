<cfhttp method="get" redirect="true" resolveurl="true" result="helpStuff" url="http://cb1.riaforge.org/wiki/" useragent="CB/1 ColdFusion Builder Extension">

<cfoutput>#helpStuff.fileContent#</cfoutput>