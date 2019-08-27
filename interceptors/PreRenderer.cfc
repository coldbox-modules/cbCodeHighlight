/**
 * I listen to renderings to process <pre></pre> tags
 */
component extends="coldbox.system.interceptor"{

	// DI
	property name="renderer" inject="PreRenderer@cbCodeFormat";

	/**
	 * Configure interceptor
	 */
	function configure(){
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

		// Process content
		interceptData.renderedContent = renderer.process( interceptData.renderedContent );

	}

}