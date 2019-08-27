# CB Code Format

This module allows you to do code formatting and syntax highlighting according to the pygments library and its gazillion of [language lexers](http://pygments.org/languages/).

## Installation

Just run a simple `box install cbCodeFormat` with CommandBox CLI!

## Settings

You can add the following settings to your `config/ColdBox.cfc` under the `moduleSettings` struct:

```js
moduleSettings = {
	cbCodeFormat = {
		// The code theme to activate
		// Themes: autumn,borland,bw,colorful,default,emacs,friendly,fruity,manny,monokai,murphy,native,pastie,perldoc,tango,trac,vim,vs
		theme = "default",
		// Default language
		defaultLexer = "java",
		// Listen to `preRender()` and convert any `<pre></pre>` tags to syntax highlighting
		preRenderer = false
	}
};
```

* `theme` : The css theme to use
* `defaultLexer` : If not `syntax` attribute is added to `<pre></pre>` tags, then use this as the default language
* `preRender` : If true, it will activate the ColdBox `preRender` interceptor and will automatically process all content and translate `<pre></pre>` tags with our awesome processor.

## Usage

This module comes with two model classes to help you with code formatting and highlighting. Below are the WireBox Id's you can use:

* `cbCodeFormat@cbCodeFormat` : Render out formatting using a code block and options.
* `preRenderer@cbCodeFormat` : Process an HTML block and replace all `<pre></pre>` tags with the appropriate syntax highlight.

### Formatting Calls

The `cbCodeFormat` model has a nice method to deal with converting code blocks to pretty ones:

```js
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
)
```

Pass in a block of `code`, choose a language `syntax` and an optional `fileName` that will be added to the output block.

### CSS

This code formatter needs CSS to visualize the goodness.  You must make sure you add these css styles to your layout.  You can call the `getCssAssets()` on the `cbCodeFormat` object and it will give you a nice list of the css files to load.

```java
function preHandler(){
	addAsset( cbCodeFormat.getCssAssets() );
}
```

That's it, this will load the css assets to the DOM and off you go.


### ColdBox View Interceptor

We have provided an interceptor that listens to all ColdBox `preRender` interceptions so it can automatically process the incoming HTML and make those `<pre></pre>` shine!  Just make sure the `preRenderer` setting is `true`.

### HTML Transformer

You can also do a-la-carte transformations by accessing the `preRenderer@cbCodeFormat` model and calling it's `process( content )` method.  You can transform ANY string content by inspecting it for `<pre></pre>` tags and replacing them inline.

```java
var content = contentService.getContent( rc.id );
return getInstance( "preRenderer@cbCodeFormat" ).process( content.render() );
```

********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************

## HONOR GOES TO GOD ABOVE ALL

Because of His grace, this project exists. If you don't like this, then don't read it, its not for you.

>"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
And patience, experience; and experience, hope:
And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the 
Holy Ghost which is given unto us. ." Romans 5:5

## THE DAILY BREAD

 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12
