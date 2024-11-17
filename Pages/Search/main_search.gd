#搜素页面
extends Button

@export var SearchInput:LineEdit   #搜索输入
@export var SearchController:Node  #搜索控制
@export var ShowArea:VBoxContainer #显示区域

var search_display_button:Button   #显示搜索按钮

var search_input_pos    
var search_input_min_si 
var search_input_size   

#初始化
func _ready():
	connect("pressed",Callable(self,"undisplay"))
	search_input_pos    = SearchInput.global_position
	search_input_size   = SearchInput.size

#显示
func display(_serch_button=null):
	self.visible = true
	SearchInput.connect("text_submitted",Callable(SearchController,"_on_text_submitted"))
	SearchInput.grab_focus()
	
	#显示动画
	if _serch_button != null:
		search_display_button = _serch_button
		search_display_button.visible = false
		
		#设置初始位置
		SearchInput.global_position = search_display_button.global_position
		SearchInput.size = search_display_button.size
		
		#播放动画
		var tween = get_tree().create_tween()
		tween.set_parallel()
		tween.tween_property(SearchInput,"size",search_input_size,0.3)
		tween.tween_property(SearchInput,"global_position",Vector2(search_input_pos.x,20),0.3)
		
		#动画结束恢复初始设置
		await tween.finished
		SearchInput.grab_focus()
		
#隐藏
func undisplay():
	self.visible = false
	SearchInput.disconnect("text_submitted",Callable(SearchController,"_on_text_submitted"))
	for item in ShowArea.get_children():
		ShowArea.remove_child(item)
	
	if search_display_button != null:
		search_display_button.visible = true
