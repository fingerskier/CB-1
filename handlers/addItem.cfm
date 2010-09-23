<cfscript>
	form.IDEeventInfo = replace(form.IDEeventInfo, "\", "/", "all");
	eventInfo = xmlParse(form.IDEeventInfo);
	templateLocation = replace(expandPath("./"), "\", "/", "all");

	projectPath = eventInfo.event.ide.projectview.XmlAttributes.projectlocation;
	projectName = eventInfo.event.ide.projectview.XmlAttributes.projectname;
	projectNode = xmlSearch(eventInfo, "//projectview[ position() = 1 ]/@projectname");
	selectedPath = eventInfo.event.ide.projectview.resource.XmlAttributes.path;
	selectedPath = replace(selectedPath, "\", "/", "all");

	input = {};
	userInput = xmlSearch(eventInfo.event.user, "/event/user/input");

	for (X=1; X LE arrayLen(userInput); ++X) {
		thisInput = userInput[X].XmlAttributes;
		structInsert(input, thisInput.name, thisInput.value);
	}

	if (isDefined("input.scriptBased") AND input.scriptBased) {
		codeType = "scriptTemplate";
		controllerItem = "
	public void function #input.name#(struct rc) {
	}
}";
		serviceItem = "
	public any function #input.name#() {
	}
}";
	} else {
		codeType = "tagTemplate";
		controllerItem = '
	<cffunction name="#input.name#" returntype="void">
		<cfargument name="rc" required="true" type="struct" />
	</cffunction>
</cfcomponent';
		serviceItem = '
	<cffunction name="#input.name#" returntype="any">
	</cffunction>
</cfcomponent>';
	}

	if (lcase(listLast(selectedPath, ".")) EQ "cfc") {
		if (findNoCase("controllers", selectedPath)) {
			controller = selectedPath;
			service = replaceNoCase(selectedPath, "controllers", "services");
			layout = replaceNoCase(selectedPath, "controllers", "layouts") & "/#input.name#.cfm";
			layout = replaceNoCase(layout, ".cfc", "");
			view = replaceNoCase(selectedPath, "controllers", "views") & "/#input.name#.cfm";
			view = replaceNoCase(view, ".cfc", "");
		} else if (findNoCase("services", selectedPath)) {
			service = selectedPath;
			controller = replaceNoCase(selectedPath, "services", "controllers");
			layout = replaceNoCase(selectedPath, "services", "layouts") & "/#input.name#.cfm";
			layout = replaceNoCase(layout, ".cfc", "");
			view = replaceNoCase(selectedPath, "services", "views") & "/#input.name#.cfm";
			view = replaceNoCase(view, ".cfc", "");
		}
	} else if (findNoCase("views", selectedPath)) {
		view = selectedPath & "/#input.name#.cfm";
		layout = replaceNoCase(selectedPath, "views", "layouts") & "/#input.name#.cfm";
		service = replaceNoCase(selectedPath, "views", "services") & ".cfc";
		controller = replaceNoCase(selectedPath, "views", "controllers") & ".cfc";
	} else if (findNoCase("layouts", selectedPath)) {
		layout = selectedPath & "/#input.name#.cfm";
		view = replaceNoCase(selectedPath, "layouts", "views") & "/#input.name#.cfm";
		service = replaceNoCase(selectedPath, "layouts", "services") & ".cfc";
		controller = replaceNoCase(selectedPath, "layouts", "controllers") & ".cfc";
	} else {
		writeOutput("You must select a controller or service component; or a layout or view directory.");
		abort;
	}

	if (input.controller) {
		content = fileRead(controller);
		content = left(content, len(content)-1) & controllerItem;
		fileWrite(controller, content);
	}
	if (input.service) {
		content = fileRead(service);
		content = left(content, len(content)-1) & serviceItem;
		fileWrite(service, content);
	}
	if (input.layout) {
		fileCopy(templateLocation & codeType & "/layouts/main/default.cfm", layout);
	}
	if (input.view) {
		fileCopy(templateLocation & codeType & "/views/main/default.cfm", view);
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
