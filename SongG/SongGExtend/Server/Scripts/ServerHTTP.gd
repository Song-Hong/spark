#############################################
# de_zh  : 
# de_en  : 
# author : Song
# time   : 2023/11/09 21:09
#############################################
extends IServer
class_name ServerMoudle_HTTP

func GET(url:String,callback:Callable):
	ServerMoudle_HTTP_GET.new(host,port).connect_server(url,callback)

func GET_URL(url:String,callback:Callable):
	ServerMoudle_HTTP_GET.new(host,port).connect_server_from_url(url,callback)

func GET_URL_IMG(url:String,callback:Callable):
	ServerMoudle_HTTP_GET.new(host,port).connect_server_download_img(url,callback)

func POST(url:String,data,callback:Callable):
	ServerMoudle_HTTP_POST.new(host,port).connect_server(url,data,callback)
