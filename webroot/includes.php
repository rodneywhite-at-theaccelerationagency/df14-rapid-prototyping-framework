<?php


global $applicationRoot;
global $rootPath;

$applicationRoot = dirname(__FILE__);
$rootPath = $applicationRoot ."/../";


function required_include($path){
	error_log($path);

	require_once($path);

}

// could autoload instead.

required_include($rootPath."application/handlers/app_handler.php");
required_include($rootPath."application/handlers/index/index_handler.php");
required_include($rootPath."application/handlers/canvas/canvas_handler.php");
required_include($rootPath."application/handlers/callback/callback_handler.php");


required_include($rootPath."vendor/mustache/mustache/src/Mustache/HelperCollection.php");
required_include($rootPath."vendor/mustache/mustache/src/Mustache/Context.php");
required_include($rootPath."vendor/mustache/mustache/src/Mustache/Template.php");
required_include($rootPath."vendor/mustache/mustache/src/Mustache/Compiler.php");
required_include($rootPath."vendor/mustache/mustache/src/Mustache/Tokenizer.php");
required_include($rootPath."vendor/mustache/mustache/src/Mustache/Parser.php");
required_include($rootPath."vendor/mustache/mustache/src/Mustache/Cache.php");
required_include($rootPath."vendor/mustache/mustache/src/Mustache/Cache/AbstractCache.php");
required_include($rootPath."vendor/mustache/mustache/src/Mustache/Cache/FilesystemCache.php");
required_include($rootPath."vendor/mustache/mustache/src/Mustache/Cache/NoopCache.php");
required_include($rootPath."vendor/mustache/mustache/src/Mustache/Loader.php");
required_include($rootPath."vendor/mustache/mustache/src/Mustache/Logger.php");
required_include($rootPath."vendor/mustache/mustache/src/Mustache/Loader/StringLoader.php");
required_include($rootPath."vendor/mustache/mustache/src/Mustache/Engine.php");

required_include($rootPath."vendor/torophp/torophp/src/Toro.php");