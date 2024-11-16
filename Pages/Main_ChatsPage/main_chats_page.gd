#主界面 消息界面
extends HBoxContainer

## assets
@export var FriendAreaButtonGroup:ButtonGroup #好友列表按钮组

## Middle
@export var FriendArea:VBoxContainer   #好友界面

## Content
@export var ChatPanel:MarginContainer  #聊天区域
@export var TextInput:TextEdit         #文本输入
@export var TextArea:VBoxContainer     #文本显示区域
@export var TextView:ScrollContainer   #文本显示滚轮区域

## Search
@export var SearchPanel:Button         #搜索区域
@export var SearchButton:Button        #搜索按钮
