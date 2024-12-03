#从服务器下载文件
extends Node
class_name download_file_from_server_command

#http连接
var http_request:HTTPRequest
#存储路径
var save_path:String

#从服务器下载文件
func _init(_file_name,_save_path):
	var url = "http://60.204.140.223:17281/download/"+str(_file_name)
	save_path = _save_path
	http_request = HTTPRequest.new()
	http_request.request_completed.connect(Callable(self,"on_request_completed"),4)
	add_child(http_request)
	Core.init.add_child(self)
	http_request.request(url)

#当接收到服务器返回
func on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if result != HTTPRequest.RESULT_SUCCESS:
		print("请求失败")
		destory()
		return
		
	match response_code:
		200:
			print("文件下载成功,存储至"+save_path)
			var file = FileAccess.open(save_path,FileAccess.WRITE)
			file.store_buffer(body)
		404:
			print("文件未找到")
		500:
			print("服务器错误")
	destory()

#销毁自身
func destory():
	remove_child(http_request)
	http_request = null
	Core.init.remove_child(self)
