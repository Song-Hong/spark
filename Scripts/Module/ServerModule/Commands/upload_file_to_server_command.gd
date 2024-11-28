#上传文件至服务器
extends ACommand
class_name upload_file_to_server_command

func _init(_file_path):
	var url = "http://60.204.140.223:17281/upload"
	var file = FileAccess.open(_file_path, FileAccess.READ)
	var file_data = file.get_buffer(file.get_length())
	
	# 创建 multipart form data
	var boundary = "GodotUploadBoundary"
	var body = PackedByteArray()
	
	# 添加文件数据
	var file_name = _file_path.get_file()
	body.append_array(("--" + boundary + "\r\n").to_utf8_buffer())
	body.append_array(("Content-Disposition: form-data; name=\"file\"; filename=\"" + file_name + "\"\r\n").to_utf8_buffer())
	body.append_array("Content-Type: application/octet-stream\r\n\r\n".to_utf8_buffer())
	body.append_array(file_data)
	body.append_array(("\r\n--" + boundary + "--\r\n").to_utf8_buffer())
	
	# 设置请求头
	var headers = [
		"Content-Type: multipart/form-data; boundary=" + boundary
	]
	
	#向服务器发送数据
	#SparkServer.init.server_http.request(
		#url, headers, HTTPClient.METHOD_POST, body)
	SparkServer.init.server_http.request_raw(
		url, headers, HTTPClient.METHOD_POST, body)
