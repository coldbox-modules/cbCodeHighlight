/**
 * I process <pre syntax="" filename=""></pre> tags to convert them to code formatting!
 */
component singleton{

	// DI
	property name="cbCodeHighlight" 	inject="cbCodeHighlight@cbCodeHighlight";
	property name="settings" 			inject="coldbox:moduleSettings:cbCodeHighlight";

	/**
	 * Constructor
	 */
	function init(){
		variables.TAG_REGEX = "<pre\b[^>]*>(.*?)</pre>";
		return this;
	}

	/**
	 * Process a piece of content to replace `<pre></pre>` tags according to our rules
	 *
	 * @content The HTML content to process
	 */
	function process( required content ){
		// Find the tag matches
		var codeMatches = reMatchNoCase( variables.TAG_REGEX, arguments.content );
		if( !codeMatches.len() )
			return arguments.content;

		// Build out the builder
		var builder = createObject( "java", "java.lang.StringBuilder" ).init( arguments.content );

		// match codeformatting in our incoming builder and build our targets array and len
		codeMatches
			.each( function( codeGroup ){
				// extract code
				var code 			= reReplaceNoCase( arguments.codeGroup, variables.TAG_REGEX, "\1" );
				// XML format it to avoid nasty parsing issues
				var codeBlockXML 	= xmlParse( replaceNoCase( codeGroup, code, xmlFormat( code ) ) );
				var tagAttributes 	= codeBlockXML.pre.XmlAttributes;

				// Process replacements
				multiStringReplace(
					builder 	= builder,
					indexOf	 	= codeGroup,
					replaceWith = variables.cbCodeHighlight.format(
						code 		: trim( codeBlockXml.pre.xmlText ),
						syntax 		: tagAttributes.syntax ?: variables.settings.defaultLexer,
						fileName 	: tagAttributes.fileName ?: ""
					)
				);
			} );

		// Final Replacement
		return builder.toString();
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