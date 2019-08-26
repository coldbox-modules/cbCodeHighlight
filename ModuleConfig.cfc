/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * Code Formatter and Highlighter
 */
component {

	// Module Properties
	this.title 				= "cbCodeFormat";
	this.author 			= "Ortus Solutions";
	this.webURL 			= "https://www.ortussolutions.com";
	this.description 		= "Code Formatting and Syntax Highlighter";
	// Model Namespace
	this.modelNamespace		= "cbCodeFormat";
	// CF Mapping
	this.cfmapping			= "cbCodeFormat";
	// Dependencies
	this.dependencies 		= [ "cbjavaloader" ];

	/**
	 * Configure Module
	 */
	function configure(){

		// cbORM Settings
		settings = {
			// The code theme to activate
			// Themes: autumn,borland,bw,colorful,default,emacs,friendly,fruity,manny,monokai,murphy,native,pastie,perldoc,tango,trac,vim,vs
			theme = "default",
			// Listen to `preRender()` and convert any `<pre></pre>` tags to syntax highlighting
			preRenderer = true
		};

		// Custom Declared Interceptors
		interceptors = [
		];

	}

	/**
	 * Fired when the module is registered and activated.
	 */
	function onLoad(){
		// load jars
		wirebox.getInstance( "loader@cbjavaloader" )
			.appendPaths( variables.modulePath & "/lib" );

		// Load Tag Interceptors if active
		if( settings.preRenderer ){
			controller.getInterceptorService()
				.registerInterceptor(
					interceptorClass 	= "#moduleMapping#.interceptors.PreRenderer",
					interceptorName 	= "TagRenderer@cbCodeFormat"
				);
		}
	}

	/**
	 * Fired when the module is unregistered and unloaded
	 */
	function onUnload(){
	}

}