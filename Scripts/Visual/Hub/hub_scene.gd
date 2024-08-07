extends Control


@onready var res_btn_ani = $ResButton/ResBtnAnimationPlayer

@onready var setting_btn_ani = $SettingButton/SettingsBtn/SettingBtnAnimationPlayer

@onready var start_btn_ani = $StartButton/StartBtn/StartBtnAnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	print(RunningData.chartList)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_start_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/Visual/select_scene.tscn")


func _on_res_mgr_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/Visual/res_mgr_scene.tscn")


func _on_settings_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/Visual/Settings/settings_scene.tscn")


func _on_res_mgr_btn_mouse_entered():
	res_btn_ani.play("on_hover")


func _on_res_mgr_btn_mouse_exited():
	res_btn_ani.play_backwards("on_hover")


func _on_settings_btn_mouse_entered():
	setting_btn_ani.play("on_hover")


func _on_settings_btn_mouse_exited():
	setting_btn_ani.play_backwards("on_hover")


func _on_start_btn_mouse_entered():
	start_btn_ani.play("on_hover")


func _on_start_btn_mouse_exited():
	start_btn_ani.play_backwards("on_hover")
