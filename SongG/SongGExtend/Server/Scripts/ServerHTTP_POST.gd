#############################################
# de_zh  : 
# de_en  : 
# author : Song
# time   : 2023/11/26 17:07
#############################################
extends IServer
class_name ServerMoudle_HTTP_POST

var    http:HTTPRequest
var    request_completed:Callable

func connect_server(url,data,callback):
	http = HTTPRequest.new()
	Server.init.add_child(http)
	request_completed = callback
	http.connect("request_completed",Callable(self,"on_request_completed"))
	http.request(host+":%s/"%port+url,["content-type: application/json"],HTTPClient.METHOD_POST,JSON.stringify(data))

func on_request_completed(_result, _response_code,_headers, _body):
	if _result == 0 and _response_code == 200:
		Server.init.remove_child(http)
		request_completed.callv([_body.get_string_from_utf8()])