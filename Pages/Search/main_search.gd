#搜素页面
extends PanelContainer

@export var SearchInput:LineEdit  #搜索输入
@export var SearchController:Node #搜索控制

#显示
func display():
	self.visible = true
	SearchInput.connect("text_submitted",Callable(SearchController,"_on_text_submitted"))

#隐藏
func undisplay():
	self.visible = false
	SearchInput.disconnect("text_submitted",Callable(SearchController,"_on_text_submitted"))
