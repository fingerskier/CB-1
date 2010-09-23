<cfscript>
	form.IDEeventInfo = replace(form.IDEeventInfo, "\", "/", "all");
	eventInfo = xmlParse(form.IDEeventInfo);
	templateLocation = replace(expandPath("./"), "\", "/", "all");

	projectPath = eventInfo.event.ide.projectview.XmlAttributes.projectlocation;
	projectName = eventInfo.event.ide.projectview.XmlAttributes.projectname;
	projectNode = xmlSearch(eventInfo, "//projectview[ position() = 1 ]/@projectname");

	selectedPath = eventInfo.event.ide.projectview.resource.XmlAttributes.path;

	input = {};
	userInput = xmlSearch(eventInfo.event.user, "/event/user/input");

	for (X=1; X LE arrayLen(userInput); ++X) {
		thisInput = userInput[X].XmlAttributes;
		structInsert(input, thisInput.name, thisInput.value);
	}

	codeType = "/tagTemplate";
	if (isDefined("input.scriptBased") AND input.scriptBased) {
		codeType = "/scriptTemplate";
	}

	subSystemPath = projectPath & "/" & input.name;
	if (NOT directoryExists(subSystemPath)) {
		directoryCreate(subSystemPath);
		if (input.controllers) {
			directoryCreate(subSystemPath & "/controllers");
			fileCopy(templateLocation & codeType & "/controllers/main.cfc", subSystemPath & "/controllers/main.cfc");
		}
		if (input.services) {
			directoryCreate(subSystemPath & "/services");
			fileCopy(templateLocation & codeType & "/services/main.cfc", subSystemPath & "/services/main.cfc");
		}
		if (input.layouts) {
			directoryCreate(subSystemPath & "/layouts");
			directoryCreate(subSystemPath & "/layouts/main");
			fileCopy(templateLocation & codeType & "/layouts/default.cfm", subSystemPath & "/layouts/default.cfm");
			fileCopy(templateLocation & codeType & "/layouts/default.cfm", subSystemPath & "/layouts/main/default.cfm");
		}
		if (input.views) {
			directoryCreate(subSystemPath & "/views");
			directoryCreate(subSystemPath & "/views/main");
			fileCopy(templateLocation & codeType & "/views/main/default.cfm", subSystemPath & "/views/main/default.cfm");
		}
	} else {
		writeOutput("That directory already exists!");
		abort;
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
