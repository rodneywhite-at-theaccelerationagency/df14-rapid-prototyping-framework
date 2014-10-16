<?php



class AppHandler {

    public function get() {
        $this->all();
    }

    public function put() {
        $this->all();
    }

    public function post() {
        $this->all();
    }

    public function delete() {
        $this->all();
    }

    private function all(){
    	global $_SFDC_REQ;

    	$params = array();
    	$params['sfdc'] = $_SFDC_REQ;
    	$params['sr'] =  json_encode($_SFDC_REQ);
        $this->RenderTemplate("index", "all", $params );
    }



    public function RenderTemplate ($type, $method, $parameters){
    	global $rootPath;

        $template = file_get_contents($rootPath.'views/'.$type."/".$method.".tpl");
        $m = new Mustache_Engine();

        $m->addHelper('urldecode', function($text) {
            return urldecode($text); //{{one}} + {{two}}
        });

        $m->addHelper('urlencode', function($text) {
            return urlencode($text); //{{one}} + {{two}}
        });

        $output =  $m->render($template, $parameters);
        //error_log($output);
        header('Content-Type: text/html;charset=utf-8');
        echo $output;
    }

}

