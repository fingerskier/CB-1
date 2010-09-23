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

	itemName = listFirst(listLast(selectedPath, "/"), ".");
	layout = selectedPath;
	view = selectedPath;
	controller = selectedPath;
	service = selectedPath;

	if (lcase(selectedPath) CONTAINS "layouts") {
		view = replaceNoCase(view, "layouts", "views");
		controller = replaceNoCase(controller, "layouts", "controllers");
		controller = replaceNoCase(controller, "/" & itemName & ".cfm", ".cfc");
		service = replaceNoCase(service, "layouts", "services");
		service = replaceNoCase(service, "/" & itemName & ".cfm", ".cfc");
	} else if (lcase(selectedPath) CONTAINS "views") {
		layout = replaceNoCase(layout, "views", "layouts");
		controller = replaceNoCase(controller, "views", "controllers");
		controller = replaceNoCase(controller, "/" & itemName & ".cfm", ".cfc");
		service = replaceNoCase(service, "views", "services");
		service = replaceNoCase(service, "/" & itemName & ".cfm", ".cfc");
	} else {
		writeOutput("You must select an item!<br>Right-click on one of your Layout or View CFMs...");
		abort;
	}

	newController = fileRead(controller);
	newLayout = replaceNoCase(layout, itemName & ".cfm", input.name & ".cfm");
	newService = fileRead(service);
	newView = replaceNoCase(view, itemName & ".cfm", input.name & ".cfm");

	if (fileExists(controller)) {
		if (findNoCase("function " & itemName, newController)) {
			newController = replaceNoCase(newController, "function " & itemName, "function " & input.name);
		} else if (findNoCase('function name="' & itemName & '"', newController)) {
			newController = replaceNoCase(newController, 'function name="' & itemName & '"', 'function name="' & input.name & '"');
		}
		fileWrite(controller, newController);
	}

	if (fileExists(layout)) fileMove(layout, newLayout);

	if (fileExists(service)) {
		if (findNoCase("function " & itemName, newService)) {
			newService = replaceNoCase(newService, "function " & itemName, "function " & input.name);
		} else if (findNoCase('function name="' & itemName & '"', newService)) {
			newService = replaceNoCase(newService, 'function name="' & itemName & '"', 'function name="' & input.name & '"');
		}
		fileWrite(service, newService);
	}

	if (fileExists(view)) fileMove(view, newView);
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
