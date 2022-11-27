extends Container

const backgroundColors = {
	"Wood": Color(0.047059, 0.482353, 0.145098),
	"Stone": Color(0.541176, 0.078431, 0.015686)
}

signal transaction(buy, amount, resource)

export var city_count = 10
export (String, "Wood", "Stone") var resource_type = "Wood"
export var player_count = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	init(resource_type, player_count, city_count)


func set_resource_type(resource:String):
	resource_type = resource
	$Resource.set_texture(load("res://Assets/Bilder/Resource_%s.png" % resource))
	if (resource in backgroundColors):
		$Background.set_modulate(backgroundColors[resource]) 

func set_city_count(count:int):
	$CityCount.text = str(count)
	city_count = count

func set_player_count(count:int):
	$PlayerCount.text = str(count)
	player_count = count

func init(resource:String, player:int, city:int):
	set_resource_type(resource)
	set_player_count(player)
	set_city_count(city)
	$CitySlider.init(city)
	$PlayerSlider.init(player)


func _on_BuySell_buySell():
	var player = $PlayerSlider.value == 0
	if player and $CitySlider.value == 0: return
	emit_signal("transaction", player, $PlayerSlider.value if !player else $CitySlider.value, resource_type)
	if player:
		init(resource_type, int($PlayerCount.text) + $CitySlider.value,int($CityCount.text) - $CitySlider.value)
	else:
		init(resource_type,int($PlayerCount.text) - $PlayerSlider.value, int($CityCount.text) + $PlayerSlider.value)


func _on_Slider_to_rule_them_all(value, playerSlider:bool):
	if value == 0: return
	if playerSlider:
		$CitySlider.value = 0
	else:
		$PlayerSlider.value = 0
