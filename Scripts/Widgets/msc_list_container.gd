extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in RunningData.chartList.size():
		
		print(RunningData.chartList[i])
		
		var chartItem: Node = preload("res://Scenes/Widgets/demo_msc.tscn").instantiate()
		chartItem.get_node("MarginContainer/Label").text = RunningData.chartList[i]
		
		self.add_child(chartItem)
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
