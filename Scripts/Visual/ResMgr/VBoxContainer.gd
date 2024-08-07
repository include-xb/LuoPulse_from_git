extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in RunningData.chartList.size():
		var chartItem: Node = preload("res://Scenes/Widgets/res_mgr_chart_item.tscn").instantiate()
		chartItem.set_up(RunningData.chartList[i], i)
		add_child(chartItem)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
