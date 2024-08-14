extends Control

@onready var timeLabel: Label = $AppTile/MarginContainer/HBoxContainer/TimeLabel

func _ready():
	$AppTile/MarginContainer/HBoxContainer/Label.text = "Luo Pulse " + RunningData.versionName

func _process(_delta):
	var time_dict: Dictionary = Time.get_time_dict_from_system()
	var minute: String = str(time_dict["minute"])
	var second: String = str(time_dict["second"])
	
	if minute.length() == 1:
		minute = "0" + minute
	
	if second.length() == 1:
		second = "0" + second
	
	var time: String = str(time_dict["hour"]) + ":" + minute + ":" + second
	timeLabel.text = time


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Visual/select_scene.tscn")


func _on_notice_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/Visual/notice_scene.tscn")


func _on_settings_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/Visual/Settings/settings_scene.tscn")
