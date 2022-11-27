extends Node2D

signal in_menu
var pause = false
signal transaction(buy, amount, resource)

# Called when the node enters the scene tree for the first time.
func _ready():
	$CityMenu.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_click_city(city):
	if city != "": $CityMenu.init(city, get_node(city).get_resources())
	pause = !pause
	if pause:
		$CityMenu.show()
		$CityMenu/MenuCam.current = true
		$CityMenu/MenuCam.zoom = $CityMenu.rect_size/OS.get_window_size()
	else: 
		$CityMenu.hide()
		$MainCam.current = true
	emit_signal("in_menu")


func _on_CityMenu_transaction(buy, amount, resource, city):
	get_node(city).trade_resource(buy, amount, resource)
	emit_signal("transaction", buy, amount, resource)
