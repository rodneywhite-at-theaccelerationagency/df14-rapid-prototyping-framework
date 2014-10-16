<?php




class CallbackHandler  extends AppHandler{

    public function get() {
        var_dump($_REQUEST);
        $this->all();
    }

    public function put() {
        var_dump($_REQUEST);
        $this->all();
    }

    public function post() {
        $this->all();
     }


    private function all(){
        global $_SFDC_REQ;
        
        $params = array();
        $params['consumer_key'] =  @$_ENV["consumer_key"];
        $params['oauth_callback'] =  @$_ENV["oauth_callback"];
        
        $this->RenderTemplate("callback", "all", $params );
    }




}
