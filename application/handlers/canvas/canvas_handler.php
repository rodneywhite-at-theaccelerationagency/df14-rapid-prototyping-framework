<?php




class CanvasHandler  extends AppHandler{

    public function get() {
        $this->all();
    }

    public function put() {
        $this->all();
    }

    public function post() {

         $signedRequest = @$_REQUEST['signed_request'];

         if ($signedRequest != ""){
             $req = $this->parseSignedRequest();
         } else {
            exit;
         }


        //As of Spring '13: SignedRequest has a client object which holds the pertinent authentication info
        $access_token = $req->client->oauthToken;
        $instance_url = $req->client->instanceUrl;

        $_SFDC_REQ = $req;

        error_log(json_encode($_SFDC_REQ));

        $location = @$req->context->environment->displayLocation;

        switch ($location) {
          case "ChatterFeed":
            $this->post_feed($req);
            break;
          case "Publisher":
            $this->post_publisher($req);
            break;
          case "Visualforce":
            $this->post_visualforce($req);
            break;
          default:
            $this->post_all($req);
        }


    }



    public function delete() {
        $this->all();
    }









    private function post_publisher($_sfdc_req){
        $params = array();
        $params['sfdc'] = $_sfdc_req;
        $params['sr'] =  json_encode($_sfdc_req);
        $this->RenderTemplate("canvas", "publisher", $params );

    }



    private function post_feed($_sfdc_req){



        //As of Spring '13: SignedRequest has a client object which holds the pertinent authentication info
        $access_token = $_sfdc_req->client->oauthToken;
        $instance_url = $_sfdc_req->client->instanceUrl;

        $languageStr =  $_sfdc_req->context->user->language;

        $languageObj = explode("_", $languageStr);
        $language = $languageObj[0];

        //$uri = $instance_url.$_sfdc_req->context->environment->record->attributes->url;
        $cdn = @$_ENV['aws_cdn_endpoint'];
        
        $params = array();
        $params['sfdc'] = $_sfdc_req;
        $params['sr'] =  json_encode($_sfdc_req);
        
        $this->RenderTemplate("canvas", "feed", $params );
    }


   private function post_visualforce($_sfdc_req){

        //As of Spring '13: SignedRequest has a client object which holds the pertinent authentication info
        $access_token = $_sfdc_req->client->oauthToken;
        $instance_url = $_sfdc_req->client->instanceUrl;

        $languageStr =  $_sfdc_req->context->user->language;

        $languageObj = explode("_", $languageStr);
        $language = $languageObj[0];

        //$uri = $instance_url.$_sfdc_req->context->environment->record->attributes->url;
        $cdn = @$_ENV['aws_cdn_endpoint'];
        
        $params = array();
        $params['sfdc'] = $_sfdc_req;
        $params['sr'] =  json_encode($_sfdc_req);
        
        $this->RenderTemplate("canvas", "visualforce", $params );
    }









    private function all(){
        global $_SFDC_REQ;
        
        $params = array();
        $params['consumer_key'] =  @$_ENV["consumer_key"];
        $params['oauth_callback'] =  @$_ENV["oauth_callback"];
        
        $this->RenderTemplate("canvas", "all", $params );
    }




   private function post_all($req){
        global $_SFDC_REQ;
        
        $params = array();
        $params['consumer_key'] =  @$_ENV["consumer_key"];
        $params['oauth_callback'] =  @$_ENV["oauth_callback"];
        
        $params['req'] = print_r($req->context->user,true);
        
        $this->RenderTemplate("canvas", "post_all", $params );
    }





    private function parseSignedRequest(){

        //In Canvas via SignedRequest/POST, the authentication should be passed via the signed_request header

        //You can also use OAuth/GET based flows
        $signedRequest = @$_REQUEST['signed_request'];
        $consumer_secret = @$_ENV['consumer_secret'];

        
        if ($signedRequest == null || $consumer_secret == null) {
           exit;//echo "Error: Signed Request or Consumer Secret not found";
        }

        //decode the signedRequest
        $sep = strpos($signedRequest, '.');
        $encodedSig = substr($signedRequest, 0, $sep);
        $encodedEnv = substr($signedRequest, $sep + 1);
        $calcedSig = base64_encode(hash_hmac("sha256", $encodedEnv, $consumer_secret, true));     
        if ($calcedSig != $encodedSig) {
           exit;//echo "Error: Signed Request Failed.  Is the app in Canvas?";
        }


        //decode the signedRequest
        $sep = strpos($signedRequest, '.');
        $encodedSig = substr($signedRequest, 0, $sep);
        $encodedEnv = substr($signedRequest, $sep + 1);

        //decode the signed request object
        $req = json_decode(base64_decode($encodedEnv));
        return $req;
    }


}
