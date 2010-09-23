<cfscript>
	form.IDEeventInfo = replace(form.IDEeventInfo, "\", "/");
	eventInfo = xmlParse(form.IDEeventInfo);
	templateLocation = replace(expandPath("./"), "\", "/", "all");

	projectPath = eventInfo.event.ide.projectview.XmlAttributes.projectlocation;
	projectName = eventInfo.event.ide.projectview.XmlAttributes.projectname;
	projectNode = xmlSearch(eventInfo, "//projectview[ position() = 1 ]/@projectname");

	input = {};
	userInput = xmlSearch(eventInfo.event.user, "/event/user/input");

	for (X=1; X LE arrayLen(userInput); ++X) {
		thisInput = userInput[X].XmlAttributes;
		structInsert(input, thisInput.name, thisInput.value);
	}

	if (isDefined("input.scriptBased") AND input.scriptBased) {
	}

	fileCopy(templateLocation & "/framework.cfc", projectPath & "/framework.cfc");
	if (isDefined("input.scriptBased") AND input.scriptBased) {
		codeType = "scriptTemplate";
		fileData = "<cfscript></cfscript>";
	} else {
		codeType = "tagTemplate";
		fileData = "";
	}

	filesToCopy = "Application.cfc";
	if (input.basicApp) {
		directoryCreate(projectPath & "/controllers");
		directoryCreate(projectPath & "/services");
		directoryCreate(projectPath & "/layouts");
		directoryCreate(projectPath & "/layouts/main");
		directoryCreate(projectPath & "/views");
		directoryCreate(projectPath & "/views/main");

		filesToCopy = listAppend(filesToCopy, "controllers/main.cfc|layouts/default.cfm|services/main.cfc|layouts/main/default.cfm|layouts/default.cfm|views/main/default.cfm", "|");
	}

	writeDump(filesToCopy);
</cfscript>

<cfloop list="#filesToCopy#" index="thisFile" delimiters="|">
	<cfset fileData = fileRead(templateLocation & codeType & "/" & thisFile)>
	<cfset fileWrite(projectPath & "/" & thisFile, fileData)>
</cfloop>

<cfsavecontent variable="responseXml">
	<cfoutput>
		<response>
			<ide>
				<commands>
					<command type="refreshproject">
						<params>
							<param key="projectname" value="#projectNode[ 1 ].xmlValue#" />
						</params>
					</command>
				</commands>
			</ide>
		</response>
	</cfoutput>
</cfsavecontent>
<cfset responseBinary = toBinary(toBase64(trim(responseXml))) />
<cfcontent type="text/xml" variable="#responseBinary#" />
