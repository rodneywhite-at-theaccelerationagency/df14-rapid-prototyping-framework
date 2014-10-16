<?php
global $_SFDC_REQ;
$_SFDC_REQ = [];


//turn on reporting for all errors and display
error_reporting(E_ALL);
ini_set("display_errors", 1);

header("Cache-Control: no-cache");
header("Pragma: no-cache");



error_log(print_r($_SERVER,true));


require_once(__DIR__."/includes.php");




if (php_sapi_name() == 'cli-server') {
	$ini_array = @parse_ini_file(__DIR__."/../config.ini");

	foreach($ini_array as $key => $value){
		$_ENV[$key] = $value;
	}
}



ToroHook::add("404", function($path) {

	if (php_sapi_name() == 'cli-server') {
		return false;
	} else {
		header('Location: /');
		exit;
	}
	
});



Toro::serve(array(
    "/" => "IndexHandler",
    "/canvas/" => "CanvasHandler",
    "callback"  => "CallbackHandler",
));











