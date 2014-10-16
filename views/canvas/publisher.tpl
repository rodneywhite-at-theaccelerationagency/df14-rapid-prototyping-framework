<html>
<head>
<link href="//fonts.googleapis.com/css?family=Open+Sans:300" rel="stylesheet" type="text/css">
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/semantic-ui/0.16.1/css/semantic.min.css">

<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/semantic-ui/0.16.1/javascript/semantic.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/mustache.js/0.8.1/mustache.min.js"></script>

<script type="text/javascript" src="{{sfdc.client.instanceUrl}}/canvas/sdk/js/31.0/publisher.js"></script>
<script type="text/javascript" src="{{sfdc.client.instanceUrl}}/canvas/sdk/js/31.0/canvas-all.js"></script>


<style>

* {
    margin: 0;
    padding: 0;
    font-family: "Open Sans", sans-serif;
    font-weight: 300;
  }

/* Reset the container */
.container {
}

textarea {
   resize: none !important;
}

.feed_copy {
  width:100%;
}

</style>

</head>
<body>
<script>

var signed_request = JSON.parse('{{{sr}}}');
var sr = signed_request;



var item = {
    parameters : {},
    thumbnailUrl : "https://cdn1.iconfinder.com/data/icons/hawcons/32/700422-icon-1-cloud-32.png",
    title : "template title",
    description : "template description",
    auxText : "template auxText",
}





$jq = jQuery.noConflict();

$jq( document ).ready(function() {

        function babelFishChangeFunction(){
            var input = $jq("#feed_copy").val();
            
            item.description = input;
            item.title = input;
            item.auxText = input;

            if (input != ""){
              enableChatterShare({copy:input});
            } else {
              disableChatterShare();
            }


        }       


        //or this
        $jq('#feed_copy').keyup(function(){
            babelFishChangeFunction();
        });

        //and this for good measure
        $jq('#feed_copy').change(function(){
            babelFishChangeFunction(); //or direct assignment $('#txtHere').html($(this).val());
        });




        Sfdc.canvas(function() {
            console.log("Canvas start....");
            Sfdc.canvas.client.subscribe(sr.client, subscriptions);

            var sizes = Sfdc.canvas.client.size();

            console.log("contentHeight; " + sizes.heights.contentHeight);
            console.log("pageHeight; " + sizes.heights.pageHeight);
            console.log("scrollTop; " + sizes.heights.scrollTop);
            console.log("contentWidth; " + sizes.widths.contentWidth);
            console.log("pageWidth; " + sizes.widths.pageWidth);
            console.log("scrollLeft; " + sizes.widths.scrollLeft);

            console.log("Canvas finished....");
        });

    

});

var resetPanel = function () {
  
  var sizes = Sfdc.canvas.client.size();

  console.log("contentHeight; " + sizes.heights.contentHeight);
  console.log("pageHeight; " + sizes.heights.pageHeight);
  console.log("scrollTop; " + sizes.heights.scrollTop);
  console.log("contentWidth; " + sizes.widths.contentWidth);
  console.log("pageWidth; " + sizes.widths.pageWidth);
  console.log("scrollLeft; " + sizes.widths.scrollLeft);

  $jq(".container").height(sizes.heights.pageHeight);

}






function enableChatterShare(params){
    //console.log("enableChatterShare", params);
    item.parameters = params;
    Sfdc.canvas.publisher.publish({
        name: "publisher.setValidForSubmit", 
        payload:true}
    );

}

function disableChatterShare(){
    console.log("disableChatterShare");
    Sfdc.canvas.publisher.publish({
        name: "publisher.setValidForSubmit", 
        payload:false}
    );

}





</script>

    <div class="container">

<div class="ui form">
  <div class="field">
<textarea id='feed_copy' placeholder="Words for the feed..." class="" rows="5"></textarea>
  </div>
</div>

    </div> <!-- /container -->
<script>

            /* these are the handler responses for all of the subscriptions */
            var handlers = {
                onSetupPanel : function(payload) {
                  console.log("handler setupPanel:", payload);
                },
                onShowPanel : function(payload) {
                  console.log("handler onShowPanel:", payload);
                  resetPanel();
                },

                /* this subscription is for when you click out of the canvas app but don't refresh the page
                * and you want the canvas to go back to its original state. This is most applicable in
                * canvas in a publisher action in Aloha where you can toggle between different actions
                * on the same screen 
                */
                onClearPanelState : function(payload) {
                  console.log("handler onClearPanelState:", payload);

                },
                onSuccess : function(payload) {
                  console.log("handler onSuccess:", payload);
                },
                onFailure : function (payload) {
                    /* This logs the error to the console. Currently you only see console error in the standard (non-mobile) publisher */
                  console.log("handler onFailure:", payload);
                    console.log(JSON.stringify(payload, null, 4));
                },

                /* when you select a shipment, a type of post, and then click share, this will take that payload (selection data) 
                * and create the appopriate ype of post out of it 
                */
                onGetPayload : function () {
                  console.log("handler onGetPayload:", item);
                    var p = {};
                    
                    /* this piece creates the CanvasPost. Things to note:
                    * p.feedItemType = CanvasPost
                    * p.auxText > cannot be more than 255 chars 
                    * p.namespace/developerName > can be pulled from signed request or manually from your org/connected app
                    * p.thumbnailUrl = the icon you see in the chatter feed
                    * p.parameters > can be passed into the CanvasApp in the environment context 
                    * p.Title > cannot be more than 40 chars 
                    */
                    
                     p.feedItemType = "CanvasPost";
                     p.auxText = substr(item.auxText,0, 40);
                     p.namespace =  sr.context.application.namespace;
                     p.developerName =  sr.context.application.developerName;
                     
                     //= sr.client.instanceUrl+"/resource/1410648039000/taa_logo";  // TODO update the static resources of the app
                     p.thumbnailUrl  = "https://cdn1.iconfinder.com/data/icons/hawcons/32/700422-icon-1-cloud-128.png";
                     //p.auxText = substr(item.auxText,0, 40);
                     p.parameters = JSON.stringify(item.parameters);
                     //p.title = substr(item.title,0, 40);
                     p.description = substr(item.description,0, 255);;
                     console.log("handler setting payload:", p);

                     // Note: we can extend the payload here to include more then just value.
                     Sfdc.canvas.client.publish(sr.client, {name : 'publisher.setPayload', payload : p});

                     $jq("#feed_copy").val(""); 

                }
            };

                           // Subscriptions to callbacks from publisher...
            var subscriptions = [
                {name : 'publisher.setupPanel', onData : handlers.onSetupPanel},
                {name : 'publisher.showPanel', onData : handlers.onShowPanel},
                {name : 'publisher.clearPanelState',  onData : handlers.onClearPanelState},
                {name : 'publisher.failure', onData : handlers.onFailure},
                {name : 'publisher.success', onData : handlers.onSuccess},
                {name : 'publisher.getPayload', onData : handlers.onGetPayload}
            ]




function addslashes(str) {
  //  discuss at: http://phpjs.org/functions/addslashes/
  // original by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
  // improved by: Ates Goral (http://magnetiq.com)
  // improved by: marrtins
  // improved by: Nate
  // improved by: Onno Marsman
  // improved by: Brett Zamir (http://brett-zamir.me)
  // improved by: Oskar Larsson Högfeldt (http://oskar-lh.name/)
  //    input by: Denny Wardhana
  //   example 1: addslashes("kevin's birthday");
  //   returns 1: "kevin\\'s birthday"

  return (str + '')
    .replace(/[\\"']/g, '\\$&')
    .replace(/\u0000/g, '\\0');
}



function substr(str, start, len) {
  //  discuss at: http://phpjs.org/functions/substr/
  //     version: 909.322
  // original by: Martijn Wieringa
  // bugfixed by: T.Wild
  // improved by: Onno Marsman
  // improved by: Brett Zamir (http://brett-zamir.me)
  //  revised by: Theriault
  //        note: Handles rare Unicode characters if 'unicode.semantics' ini (PHP6) is set to 'on'
  //   example 1: substr('abcdef', 0, -1);
  //   returns 1: 'abcde'
  //   example 2: substr(2, 0, -6);
  //   returns 2: false
  //   example 3: ini_set('unicode.semantics',  'on');
  //   example 3: substr('a\uD801\uDC00', 0, -1);
  //   returns 3: 'a'
  //   example 4: ini_set('unicode.semantics',  'on');
  //   example 4: substr('a\uD801\uDC00', 0, 2);
  //   returns 4: 'a\uD801\uDC00'
  //   example 5: ini_set('unicode.semantics',  'on');
  //   example 5: substr('a\uD801\uDC00', -1, 1);
  //   returns 5: '\uD801\uDC00'
  //   example 6: ini_set('unicode.semantics',  'on');
  //   example 6: substr('a\uD801\uDC00z\uD801\uDC00', -3, 2);
  //   returns 6: '\uD801\uDC00z'
  //   example 7: ini_set('unicode.semantics',  'on');
  //   example 7: substr('a\uD801\uDC00z\uD801\uDC00', -3, -1)
  //   returns 7: '\uD801\uDC00z'

  var i = 0,
    allBMP = true,
    es = 0,
    el = 0,
    se = 0,
    ret = '';
  str += '';
  var end = str.length;

  // BEGIN REDUNDANT
  this.php_js = this.php_js || {};
  this.php_js.ini = this.php_js.ini || {};
  // END REDUNDANT
  switch ((this.php_js.ini['unicode.semantics'] && this.php_js.ini['unicode.semantics'].local_value.toLowerCase())) {
    case 'on':
      // Full-blown Unicode including non-Basic-Multilingual-Plane characters
      // strlen()
      for (i = 0; i < str.length; i++) {
        if (/[\uD800-\uDBFF]/.test(str.charAt(i)) && /[\uDC00-\uDFFF]/.test(str.charAt(i + 1))) {
          allBMP = false;
          break;
        }
      }

      if (!allBMP) {
        if (start < 0) {
          for (i = end - 1, es = (start += end); i >= es; i--) {
            if (/[\uDC00-\uDFFF]/.test(str.charAt(i)) && /[\uD800-\uDBFF]/.test(str.charAt(i - 1))) {
              start--;
              es--;
            }
          }
        } else {
          var surrogatePairs = /[\uD800-\uDBFF][\uDC00-\uDFFF]/g;
          while ((surrogatePairs.exec(str)) != null) {
            var li = surrogatePairs.lastIndex;
            if (li - 2 < start) {
              start++;
            } else {
              break;
            }
          }
        }

        if (start >= end || start < 0) {
          return false;
        }
        if (len < 0) {
          for (i = end - 1, el = (end += len); i >= el; i--) {
            if (/[\uDC00-\uDFFF]/.test(str.charAt(i)) && /[\uD800-\uDBFF]/.test(str.charAt(i - 1))) {
              end--;
              el--;
            }
          }
          if (start > end) {
            return false;
          }
          return str.slice(start, end);
        } else {
          se = start + len;
          for (i = start; i < se; i++) {
            ret += str.charAt(i);
            if (/[\uD800-\uDBFF]/.test(str.charAt(i)) && /[\uDC00-\uDFFF]/.test(str.charAt(i + 1))) {
              se++; // Go one further, since one of the "characters" is part of a surrogate pair
            }
          }
          return ret;
        }
        break;
      }
      // Fall-through
    case 'off':
      // assumes there are no non-BMP characters;
      //    if there may be such characters, then it is best to turn it on (critical in true XHTML/XML)
    default:
      if (start < 0) {
        start += end;
      }
      end = typeof len === 'undefined' ? end : (len < 0 ? len + end : len + start);
      // PHP returns false if start does not fall within the string.
      // PHP returns false if the calculated end comes before the calculated start.
      // PHP returns an empty string if start and end are the same.
      // Otherwise, PHP returns the portion of the string from start to end.
      return start >= str.length || start < 0 || start > end ? !1 : str.slice(start, end);
  }
  return undefined; // Please Netbeans
} 

</script>


<div style='display:none' data-log='change brackets to user mustache tags inside of php and javascript'>
{{=<% %>=}}
<div id=''>

</div>
<%={{ }}=%>
</div>


</body>
</html>