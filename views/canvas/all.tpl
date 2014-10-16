<html>
<head>
<style>

* {
  margin: 0;
  padding: 0;
}

</style>
<!-- Latest compiled and minified CSS -->
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>


<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/mustache.js/0.8.1/mustache.min.js"></script>
<script type="text/javascript" src="//login.salesforce.com/canvas/sdk/js/31.0/canvas-all.js"></script>

</head>
<body>
<script>

var loginCopy = "Authorize ";
var logoutCopy = "Please refresh page";

function loginHandler(e) {
  var uri;
  if (! Sfdc.canvas.oauth.loggedin()) {
    uri = Sfdc.canvas.oauth.loginUrl();
    Sfdc.canvas.oauth.login({
        uri : uri,
        params: {
          response_type : "token",
          client_id : "{{consumer_key}}",
          redirect_uri : encodeURIComponent("{{oauth_callback}}")
          }
      });
  } else {
    Sfdc.canvas.oauth.logout();
    Sfdc.canvas.byId("oauth").innerHTML = "";

    var login = Sfdc.canvas.byId("login");
    login.innerHTML = loginCopy;

  }

  return false;
}
// Bootstrap the page once the DOM is ready.
$jq = jQuery.noConflict();
$jq( document ).ready(function() {
  // On Ready...
  var login = Sfdc.canvas.byId("login");
  var loggedIn = Sfdc.canvas.oauth.loggedin();
  var token = Sfdc.canvas.oauth.token();
  login.innerHTML = (loggedIn) ? logoutCopy : loginCopy;
 
  if (loggedIn) {
      // Only displaying part of the OAuth token for better formatting.
      //Sfdc.canvas.byId("oauth").innerHTML = Sfdc.canvas.oauth.token().substring(1,40) + "…";
    
    // Gets a signed request on demand.
      Sfdc.canvas.client.refreshSignedRequest(function(data) {
          
          console.log("refreshSignedRequest", data);

          if (data.status === 200) {
              var signedRequest =  data.payload.response;
              var part = signedRequest.split('.')[1];
              var obj = JSON.parse(Sfdc.canvas.decode(part));
          }
          Sfdc.canvas.client.repost({refresh : true});

      });
  }      
  login.onclick=loginHandler;

});
</script>
<br><Br>
    <div class="container">
        <div class="row">
          <div class="col-lg-12 text-center">
            <div id='login' class="btn btn-lg btn-success btn-block" role="button">Authorize</div>
          </div>
      </div>
      <div class="row">
          <div class="col-lg-12 text-center">
            <div id='oauth'></div>
          </div>
      </div>

    </div> <!-- /container -->

</body>
</html>