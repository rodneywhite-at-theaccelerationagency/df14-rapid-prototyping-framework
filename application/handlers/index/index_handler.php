<?php




class IndexHandler  extends AppHandler{

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




}
