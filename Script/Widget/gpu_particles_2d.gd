extends GPUParticles2D


func _process(delta):
	# 你要是射完了, 我就马上把你杀了
	if self.emitting == false:
		self.free()
