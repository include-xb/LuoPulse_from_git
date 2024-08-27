extends Control

# 标题
@onready var title_label : Label = $MarginContainer/HBoxContainer/MarginContainer2/Info/HBoxContainer/Name

@onready var background : TextureRect = $TextureRect

@onready var msc_player : AudioStreamPlayer2D = $MscPlayer


func _ready():
	title_label.text = GlobalScene.selected_msc_title
	background.texture = GlobalScene.selected_msc_cover
	msc_player.stream = GlobalScene.selected_stream
	
	msc_player.play()


func _on_home_button_pressed():
	SceneChanger.change_scene("res://Scene/VisualScene/start_scene.tscn")
