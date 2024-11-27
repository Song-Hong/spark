##
# type   : 抽象类
# de_zh  : 组件,用于模块化逻辑功能
# author : HongSong
# time   : 2023/12/20 15:14
##
extends IState
class_name AComponent

#私有黑板数据
var data:BlackboardData
# 组件名
var component_name:String
