extends TextureRect


@onready var cover : TextureRect = $"."

@onready var button : Button = $Button


func _ready():
	pass


func set_demo_msc(msc_title : String, msc_cover : Texture2D):
	cover.texture = msc_cover
	button.text = msc_title
	
