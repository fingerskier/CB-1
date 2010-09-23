<cfcomponent extends="framework">

	<!--- application variables --->
	<cfset this.name = "#hash(getCurrentTemplatePath())#">
	<cfset this.sessionManagement = true>
	<cfset this.sessionTimeout = createTimeSpan(0,0,30,0)>
	<cfset this.applicationTimeout = createTimeSpan(0,1,0,0)>
	<cfset this.setClientCookies = true>
	<cfset this.loginStorage = "session">
	<cfset this.scriptProtect = true>
	<cfset this.debugipaddress = "0:0:0:0:0:0:0:1,127.0.0.1">

	<cfset this.ormsettings = {}>

	<cfscript>
		defaultSubsystem = "home";
		defaultSection = "main";
		defaultItem = "default";
		variables.framework = {
			// the name of the URL variable:
			action = "action",
			// whether or not to use subsystems:
			usingSubsystems = true,
			// default subsystem name (if usingSubsystems == true):
			defaultSubsystem = "home",
			// default section name:
			defaultSection = "main",
			// default item name:
			defaultItem = "default",
			// if using subsystems, the delimiter between the subsystem and the action:
			subsystemDelimiter = ":",
			// if using subsystems, the name of the subsystem containing the global layouts:
			siteWideLayoutSubsystem = "common",
			// the default when no action is specified:
			home = defaultSubsystem & ":" & defaultSection & "." & defaultItem,
			// the default error action when an exception is thrown:
			error = defaultSubsystem & ":" & defaultSection & ".error",
			// the URL variable to reload the controller/service cache:
			reload = "reload",
			// the value of the reload variable that authorizes the reload:
			password = "true",
			// debugging flag to force reload of cache on each request:
			reloadApplicationOnEveryRequest = true,
			// flash scope magic key and how many concurrent requests are supported:
			preserveKeyURLKey = "fw1pk",
			maxNumContextsPreserved = 10,
			// either CGI.SCRIPT_NAME or a specified base URL path:
			baseURL = "useCgiScriptName",
			// change this if you need multiple FW/1 applications in a single CFML application:
			applicationKey = "com.something.else"
		};
	</cfscript>

	<cffunction name="setupApplication" returntype="void">
	</cffunction>

	<cffunction name="setupSession" returntype="void">
	</cffunction>

	<cffunction name="setupRequest" returntype="void">
	</cffunction>
</cfcomponent>

