<!DOCTYPE html>
<html lang="ja">
<head>
<link href="//fonts.googleapis.com/css?family=Open+Sans:300" rel="stylesheet" type="text/css">
<style>


* {
    margin: 0;
    padding: 0;
    font-family: "Open Sans", sans-serif;
    font-weight: 300;
    font-size:100%;
  }

</style>
<!-- Latest compiled and minified CSS -->

<meta name="viewport" content="minimum-scale=1.0, maximum-scale=1.0" />
<meta name="viewport" content="width=device-width" />
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
</head>
<body>
Feed item goes here. Look at Signed Request->context->Parameters to view content from the feed item post.
<script type="text/javascript" src="{{sfdc.client.instanceUrl}}/canvas/sdk/js/31.0/canvas-all.js"></script>
<script>
var signed_request = JSON.parse('{{{sr}}}');
var sr = signed_request;

$jq = jQuery.noConflict();

$jq( document ).ready(function() {

	Sfdc.canvas(function() {
	    
	    setTimeout(function(){

		    var sizes = Sfdc.canvas.client.size();

		    if (sizes.heights.pageHeight != 0){
				console.log("contentHeight; " + sizes.heights.contentHeight);
				console.log("pageHeight; " + sizes.heights.pageHeight);
				console.log("scrollTop; " + sizes.heights.scrollTop);
				console.log("contentWidth; " + sizes.widths.contentWidth);
				console.log("pageWidth; " + sizes.widths.pageWidth);
				console.log("scrollLeft; " + sizes.widths.scrollLeft);
				
				setTimeout(function(){
					//console.log("setting height ",  $jq("#copy").height()+"px");
					Sfdc.canvas.client.resize(sr.client, {height : "50px"}); // used to resize feed height
				}, 100);
		    }



	    }, 100);


	});

});

</script>
</body>
</html>