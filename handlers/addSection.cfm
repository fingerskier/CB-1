<cfscript>
	form.IDEeventInfo = replace(form.IDEeventInfo, "\", "/", "all");
	eventInfo = xmlParse(form.IDEeventInfo);
	templateLocation = replace(expandPath("./"), "\", "/", "all");

	projectPath = eventInfo.event.ide.projectview.XmlAttributes.projectlocation;
	projectName = eventInfo.event.ide.projectview.XmlAttributes.projectname;
	projectNode = xmlSearch(eventInfo, "//projectview[ position() = 1 ]/@projectname");

	selectedPath = eventInfo.event.ide.projectview.resource.XmlAttributes.path;
	subSystemName = listLast(selectedPath, "/");
	parentPath = replace(selectedPath, subSystemName, "");
	parentPath = left(parentPath, len(parentPath)-1);

	input = {};
	userInput = xmlSearch(eventInfo.event.user, "/event/user/input");

	for (X=1; X LE arrayLen(userInput); ++X) {
		thisInput = userInput[X].XmlAttributes;
		structInsert(input, thisInput.name, thisInput.value);
	}

	codeType = "tagTemplate";
	if (isDefined("input.scriptBased") AND input.scriptBased) {
		codeType = "scriptTemplate";
	}

	if ("controllers,layouts,services,views" CONTAINS subSystemName) {
		workPath = parentPath;
		subSystemName = listLast(parentPath, "/");
	} else {
		writeOutput("You must select a controllers, services, layouts, or views directory within your application or sub-system");
		abort;
	}

	if (input.controller) {
		fileCopy(templateLocation & codeType & "/controllers/main.cfc", workPath & "/controllers/" & input.name & ".cfc");
	}
	if (input.service) {
		fileCopy(templateLocation & codeType & "/services/main.cfc", workPath & "/services/" & input.name & ".cfc");
	}
	if (input.layout) {
		newLayoutDir = workPath & "/layouts/" & input.name & "/";
		directoryCreate(newLayoutDir);
		fileCopy(templateLocation & codeType & "/layouts/main/default.cfm", newLayoutDir & "default.cfm");
	}
	if (input.view) {
		newViewDir = workPath & "/views/" & input.name & "/";
		directoryCreate(newViewDir);
		fileCopy(templateLocation & codeType & "/views/main/default.cfm", newViewDir & "default.cfm");
	}
</cfscript>

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
