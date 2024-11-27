#主界面退出登陆
extends AState
class_name MainPage_ExitState

func start():
	var ac = DB.init.read_core()
	ac.logined = false
	DB.init.save_core(ac)
	Process.init.change_process(LoginPageProcess.new())

func exit():
	pass
