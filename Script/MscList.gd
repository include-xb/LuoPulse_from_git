extends VBoxContainer

# @onready var msc_list : VBoxContainer = $"."


var packed_demo_msc : PackedScene = preload("res://Scene/WidgetScene/demo_msc.tscn")


func _ready():
	for item in GlobalScene.msc_list + GlobalScene.individual_msc_list:
		print(GlobalScene.root_msc_path + item)
		
		var instanced_demo_msc : MarginContainer = packed_demo_msc.instantiate()
		$".".add_child(instanced_demo_msc)
		
		instanced_demo_msc.set_demo_msc(item)
	
	return
	# INFO: 两遍
	for item in GlobalScene.msc_list + GlobalScene.individual_msc_list:
		print(GlobalScene.root_msc_path + item)
		
		var instanced_demo_msc : MarginContainer = packed_demo_msc.instantiate()
		$".".add_child(instanced_demo_msc)
		
		instanced_demo_msc.set_demo_msc(item)
