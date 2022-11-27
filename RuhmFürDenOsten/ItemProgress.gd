extends TextureProgress

signal item_progress_full

const backgroundColors = {
	"Wood": Color(0.047059, 0.482353, 0.145098),
	"Stone": Color(0.541176, 0.078431, 0.015686)
}

const defaultTimes = {
	"Wood": 1.0,
	"Stone": 2.0
}

var fill_time = 1.0
var count = 0
export (String, "Wood", "Stone") var resource_type = "Wood"
export var time_modifier = 1.0
var pause = false

# Called when the node enters the scene tree for the first time.
func _ready():
	init(resource_type)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !pause: value += max_value / fill_time * time_modifier * delta
	if value >= (int(max_value) - 15):
		value = 0
		if (count < 999): count += 1
		$Count.text = str(count)
		emit_signal("item_progress_full")

func set_resource_type(resource:String):
	resource_type = resource
	$Resource.set_texture(load("res://Assets/Bilder/Resource_%s.png" % resource))
	if (resource in backgroundColors):
		$Background.set_modulate(backgroundColors[resource]) 
		fill_time = defaultTimes[resource]

func init(resource:String):
	set_resource_type(resource)
	return self

func get_resource():
	return {resource_type: count}

func toggle_pause():
	pause = !pause
