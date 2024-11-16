#搜素页面
extends Button

@export var SearchInput:LineEdit   #搜索输入
@export var SearchController:Node  #搜索控制
@export var ShowArea:VBoxContainer #显示区域

#初始化
func _ready():
	connect("pressed",Callable(self,"undisplay"))

#显示
func display():
	self.visible = true
	SearchInput.connect("text_submitted",Callable(SearchController,"_on_text_submitted"))
	SearchInput.grab_focus()

#隐藏
func undisplay():
	self.visible = false
	SearchInput.disconnect("text_submitted",Callable(SearchController,"_on_text_submitted"))
	for item in ShowArea.get_children():
		ShowArea.remove_child(item)
