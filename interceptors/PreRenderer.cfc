/**
 * I listen to renderings to process <cbcode></cbcode> tags
 *
 * <pre>
 * <cbcode syntax="" filename="">code goes here</cbcode>
 * </pre>
 */
component extends="coldbox.system.interceptor"{

	// DI
	property name="cbCodeFormat" inject="provider:@cbCodeFormat";

	/**
	 * Configure interceptor
	 */
	function configure(){
		variables.REGEX = "<pre\b[^>]*>(.*?)</pre>";
	}

	/**
	 * Listen to ColdBox renderings
	 *
	 * @event
	 * @interceptData
	 * @rc
	 * @prc
	 */
	function preRender( event, interceptData, rc, prc ){
		// TODO: Add Template Caching for translations.

		// Find the code matches
		var codeMatches = reMatchNoCase( variables.REGEX, interceptData.renderedContent );
		if( !codeMatches.len() )
			return;

		// Build out the builder
		var builder = createObject( "java", "java.lang.StringBuilder" ).init( interceptData.renderedContent );

		// match codeformatting in our incoming builder and build our targets array and len
		codeMatches
			.each( function( codeGroup ){
				// extract code
				var code 			= reReplaceNoCase( arguments.codeGroup, variables.regex, "\1" );
				// XML format it to avoid nasty parsing issues
				var codeBlockXML 	= xmlParse( replaceNoCase( codeGroup, code, xmlFormat( code ) ) );
				var tagAttributes 	= codeBlockXML.pre.XmlAttributes;

				// Process replacements
				multiStringReplace(
					builder 	= builder,
					indexOf	 	= codeGroup,
					replaceWith = variables.cbCodeFormat.format(
						code 		: trim( codeBlockXml.pre.xmlText ),
						syntax 		: tagAttributes.syntax ?: "java",
						fileName 	: tagAttributes.fileName ?: ""
					)
				);
			} );

		// Final Replacement
		interceptData.renderedContent = builder.toString();
	}

	/**
	 * Replace values of `indexOf` operations on the incoming string builder with a targeted replaceWith
	 *
	 * @builder The Java string builder
	 * @indexOf The string to search for
	 * @replaceWith The string to replace with
	 *
	 * @return The string builder.
	 */
	private function multiStringReplace( required builder, required indexOf, required replaceWith ){
		var rLocation 	= arguments.builder.indexOf( arguments.indexOf );
		var rLen 		= len( arguments.indexOf );

		// Loop findings of same instances to replace
		while( rLocation gt -1 ){
			// Replace it
			arguments.builder.replace(
				javaCast( "int", rLocation ),
				javaCast( "int", rLocation + rLen ),
				arguments.replaceWith
			);
			// look again
			rLocation = arguments.builder.indexOf( arguments.indexOf, javaCast( "int", rLocation ) );
		}

		return arguments.builder;
	}

}