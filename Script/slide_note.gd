""" 弃用
我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 
我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 
我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 
我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 
我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 我不会写 

"""

extends CharacterBody2D

class_name SLIDE_NOTE

@export var sec = 2.0 # beat

var length

func _ready():
	
	length = sec_to_length(sec)
	
	print("length: ", length)
	
	var scale_y = length / 38
	
	$img.scale.y = scale_y
	
	$img.position.x = 0
	$img.position.y = - length / 2
	
	$box.global_position = $img.global_position
	$box.scale = $img.scale
	
	print($img.position)
	print($img.scale)


func _process(delta):
	pass


func sec_to_length(sec):
	return 60 * sec * 10
