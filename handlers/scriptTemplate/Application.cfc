component extends="framework" {

	// application variables
	this.name = "#hash(getCurrentTemplatePath())#";
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0,0,30,0);
	this.applicationTimeout = createTimeSpan(0,1,0,0);
	this.setClientCookies = true;
	this.loginStorage = "session";
	this.scriptProtect = true;
	this.debugipaddress = "0:0:0:0:0:0:0:1,127.0.0.1";

	// orm settings
	this.ormsettings = {};

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

	// methods
	public void function setupApplication() {
	}

	public void function setupSession() {
	}

	public void function setupRequest() {
	}
}

