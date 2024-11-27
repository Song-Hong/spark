#############################################
# de_zh  : 
# de_en  : 
# author : Song
# time   : 2023/11/26 17:07
#############################################
extends IServer
class_name ServerMoudle_HTTP_GET

var    http:HTTPRequest
var    request_completed:Callable

func connect_server(url,callback):
	http = HTTPRequest.new()
	Server.init.add_child(http)
	request_completed = callback
	http.connect("request_completed",Callable(self,"on_request_completed"))
	http.request(host+":%s/"%port+url,[], HTTPClient.METHOD_GET)

func connect_server_from_url(url,callback):
	http = HTTPRequest.new()
	Server.init.add_child(http)
	request_completed = callback
	http.connect("request_completed",Callable(self,"on_request_completed"))
	http.request(url,[], HTTPClient.METHOD_GET)

func connect_server_download_img(url,callback):
	http = HTTPRequest.new()
	Server.init.add_child(http)
	request_completed = callback
	http.connect("request_completed",Callable(self,"on_request_completed_img"))
	http.request(url,[], HTTPClient.METHOD_GET)

func on_request_completed(_result, _response_code,_headers, _body):
	if _result == 0 and _response_code == 200:
		Server.init.remove_child(http)
		request_completed.callv([_body.get_string_from_utf8()])

#获取加载到的图片
func on_request_completed_img(_result, _response_code,_headers, _body):
	var image = Image.new()
	var error = image.load_png_from_buffer(_body)
	if error != OK:
		push_error("Couldn't load the image.")

	request_completed.callv([ImageTexture.create_from_image(image)])
	
