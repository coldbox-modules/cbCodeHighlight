/**
 * I format code blocks in true box awesomeness
 */
component accessors='true' singleton {

	// Code Interpreter class
	property name='interpreter';

	// DI
	property name="wirebox" 	inject="wirebox";
	property name="jLoader" 	inject="loader@cbjavaloader";
	property name="settings" 	inject="coldbox:moduleSettings:cbCodeHighlight";
	property name="config" 		inject="coldbox:moduleConfig:cbCodeHighlight";

	/**
	 * Constructor
	 */
	function init() {
		var string = "";
		// ACF Compat
		variables.CR = chr( 13 ) & chr( 10 );
		variables.STRING_CLASS = string.getClass();
		return this;
	}

	function onDiComplete() {
		setInterpreter(
			jLoader.create( 'org.python.util.PythonInterpreter' )
		);
	}

	/**
	 * Get core + theme assets list to load
	 */
	function getCssAssets( theme=variables.settings.theme ){
		return getCoreCSSPath() & "," & getThemePath();
	}

	/**
	 * Retrieve the include path for the core css
	 */
	function getCoreCSSPath(){
		return variables.config.mapping & "/includes/cbCodeHighlight.css";
	}

	/**
	 * Retrieve the include path for the theme css
	 *
	 * @theme The theme to load, we default to the settings but this can be overriden
	 */
	function getThemePath( theme=variables.settings.theme ){
		return variables.config.mapping & "/includes/pygments/#arguments.theme#.css";
	}

	/**
	 * Take a string and format it as HTML
	 *
	 * @code The code block to format
	 * @syntax The syntax to apply, if not passed it defaults to the defaultLexer setting
	 * @fileName The filename + extension this code syntax represents
	 */
	function format(
		required string code,
		string syntax=variables.settings.defaultLexer,
		string fileName = ''
	) {
		getInterpreter().set( 'code', arguments.code );
		getInterpreter().set( 'fileName', arguments.fileName );
		getInterpreter().set( 'linenos', arguments.code.listLen( chr( 13 ) & chr( 10 ) ) > 1 ? 'inline' : False );

		var lexerResult = determimeLexer( arguments.syntax, arguments.code, arguments.fileName );

		getInterpreter().exec(
			'from pygments import highlight#CR#'
			 & 'from pygments.lexers import #lexerResult.lexer##CR#'
			 & 'from pygments.formatters import HtmlFormatter#CR#'
			 & 'Result = None#CR#'
			 & 'Result = highlight(code, #lexerResult.lexer#(), HtmlFormatter( linenos=linenos, filename=fileName ))'
		);

		return '<!--#lexerResult.lexer#: #lexerResult.source# -->' & getInterpreter().get( 'Result', variables.STRING_CLASS );
	}

	/********************************* PRIVATE ***************************/

	/**
	 * Determine code lexer
	 *
	 * @syntax The code syntax
	 * @code The actual code
	 * @fileName An optional filename+extension this code represents
	 */
	private function determimeLexer(
		required string syntax,
		string code = '',
		string fileName = ''
	) {
		// Pass out values into the Jython process
		getInterpreter().set( 'code', arguments.code );
		getInterpreter().set( 'syntax', arguments.syntax );
		getInterpreter().set( 'fileName', arguments.fileName );

		// Try to determine lexer by Gitbook syntax name if we have it
		if( len( arguments.syntax ) ) {
			try {
				getInterpreter().exec(
					'from pygments.lexers import get_lexer_by_name#CR#'
					 & 'lexResult = None#CR#'
					 & 'lexResult = get_lexer_by_name( syntax ).__class__.__name__'
				);
			} catch( any e ) {
				// Classnotfound means Pygments couldn't find anything
				if(
					!e.getPageException()
						.getRootCause()
						.type.toString() contains 'pygments.util.ClassNotFound'
				) {
					rethrow;
				}
			}

			// If we found something, return it.
			var lexResult = getInterpreter().get( 'lexResult', variables.STRING_CLASS );
			if( !isNull( lexResult ) && len( lexResult ) ) {
				return { lexer : lexResult, source : 'gb syntax' };
			}
		}

		// Try to determine lexer by filename, if we have it and it looks to have a file extension in it
		if( len( arguments.fileName ) && listLen( arguments.fileName, '.' ) > 1 ) {
			try {
				getInterpreter().exec(
					'from pygments.lexers import get_lexer_for_filename#CR#'
					 & 'lexResult = None#CR#'
					 & 'lexResult = get_lexer_for_filename( fileName ).__class__.__name__'
				);
			} catch( any e ) {
				// Classnotfound means Pygments couldn't find anything
				if(
					!e.getPageException()
						.getRootCause()
						.type.toString() contains 'pygments.util.ClassNotFound'
				) {
					rethrow;
				}
			}

			// If we found something, return it.
			var lexResult = getInterpreter().get( 'lexResult', variables.STRING_CLASS );
			if( !isNull( lexResult ) && len( lexResult ) ) {
				return { lexer : lexResult, source : 'filename' };
			}
		}

		try {
			getInterpreter().exec(
				'from pygments.lexers import guess_lexer#CR#'
				 & 'lexResult = None#CR#'
				 & 'lexResult = guess_lexer( code ).__class__.__name__'
			);
		} catch( any e ) {
			// Classnotfound means Pygments couldn't find anything
			if(
				!e.getPageException()
					.getRootCause()
					.type.toString() contains 'pygments.util.ClassNotFound'
			) {
				rethrow;
			}
		}

		// If we found something, return it.
		var lexResult = getInterpreter().get( 'lexResult', variables.STRING_CLASS );
		if( !isNull( lexResult ) && len( lexResult ) ) {
			return { lexer : lexResult, source : 'code guess' };
		} else {
			return { lexer : 'TextLexer', source : 'default' };
		}
	}

}
