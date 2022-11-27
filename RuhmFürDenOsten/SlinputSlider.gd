extends HSlider



export (int) var maximum = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	init(maximum)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func init(max_val):
	max_value = max_val
