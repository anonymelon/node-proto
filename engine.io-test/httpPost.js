var url = "http://localhost:8000/engine_auth";
var method = "POST";
var postData = {
  socketId: 'awefawegaw',
  channelName: 'private-myChannel'
};

var async = true;

var request = new XMLHttpRequest();
request.onload = function () {
   var status = request.status; // HTTP response status, e.g., 200 for "200 OK"
   var data = request.responseText; // Returned data, e.g., an HTML document.
}
request.open(method, url, async);

request.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
request.send(postData);
