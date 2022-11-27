extends Camera2D


const camSpeed = 500
var min_zoom := 0.3
var max_zoom := 1
var zoom_factor := 0.1
var zoom_duration := 0.2
var _zoom_level := 1.0 setget _set_zoom_level
var zoom_alowed = true

onready var tween: Tween = $Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	max_zoom = round(OS.get_window_size().x / get_viewport().size.x)
	set_process_input(true)

func _set_zoom_level(value: float) -> void:
	_zoom_level = clamp(value, min_zoom, max_zoom)
	tween.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(_zoom_level, _zoom_level),
		zoom_duration,
		tween.TRANS_SINE,
		tween.EASE_OUT
	)
	tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var speed = Vector2.ZERO
	if (Input.is_action_pressed("map_down")): speed.y += 1
	if (Input.is_action_pressed("map_up")): speed.y += -1
	if (Input.is_action_pressed("map_left")): speed.x += -1
	if (Input.is_action_pressed("map_right")): speed.x += 1
	position += speed * camSpeed * delta

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if zoom_alowed:
				if event.button_index == BUTTON_WHEEL_UP:
					_set_zoom_level(_zoom_level - zoom_factor)
				if event.button_index == BUTTON_WHEEL_DOWN:
					_set_zoom_level(_zoom_level + zoom_factor)


func _on_Map_in_menu():
	zoom_alowed = !zoom_alowed
