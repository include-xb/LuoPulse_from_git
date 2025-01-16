extends Control

@onready var tool : VBoxContainer = $Tool

@onready var tap : MarginContainer = $Tool/tap

@onready var hold : MarginContainer = $Tool/hold

@onready var eraser : MarginContainer = $Tool/eraser

@onready var scroll_container : ScrollContainer = $Scroll


func _ready():
	scroll_to_bottom(scroll_container)


func scroll_to_bottom(scroll : ScrollContainer):
	var max_scroll = scroll.get_v_scroll_bar().get_max()
	scroll.set_v_scroll(max_scroll)
	pass


func _on_home_button_pressed():
	SceneChanger.change_scene("res://Scene/VisualScene/hub_scene.tscn")
