# 全局变量
extends Node

#region 信号
#当聊天对象改变时
signal target_id_change(id)
#endregion

#region 共用变量
var SelfID: int = 0 # 当前登陆用户ID
var TargetID: int = 0 # 当前聊天用户ID
var Name: String # 当前用户昵称
var TargetName:String #当前聊天对象昵称
var Username = "" #当前用户账号
var Heartbeat = 3 #心跳
var RightMenu:PanelContainer #右键菜单
var NowThemeName:String = "Light" #当前主题名称
#endregion

#region 公用方法
#设置当前id
func set_target_id(id):
	if id != TargetID:
		TargetID = id
		target_id_change.emit(id)
#endregion
