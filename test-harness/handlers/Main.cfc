component{

	/**
	* Executes before all handler actions
	*/
	any function preHandler( event, rc, prc, action, eventArguments ){
		addAsset( getInstance( "cbCodeHighlight@cbCodeHighlight" ).getCssAssets() );
	}


	function index( event, rc, prc ){
		event.setView( "main/index" );
	}

	/**
	* code
	*/
	function code( event, rc, prc ){
		return getInstance( "cbCodeHighlight@cbCodeHighlight" )
			.format(
				code = "SELECT * FROM Users where id = ?",
				syntax="sql",
				fileName="select.sql"
			);
	}


}