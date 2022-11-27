extends NinePatchRect

signal close_menu
signal transaction(buy, amount, resource, city)

const tradeTab = preload("res://ResourceTradeTab.tscn")

export (String) var city_name = "Berlin"
var tradeTabs = []


# Called when the node enters the scene tree for the first time.
func _ready():
	init(city_name, {"population": 0, "Wood": 10, "Stone": 100})


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_name(name:String):
	city_name = name
	$Name.text = name

func set_population(pop:int):
	$Label/Population.text = str(pop)

func init(name, city_resources):
	set_name(name)
	set_population(city_resources["population"])
	for i in range(tradeTabs.size()):
		tradeTabs.pop_front().queue_free()
	for res in city_resources:
		if (res == "population"): continue
		var trade = tradeTab.instance()
		tradeTabs.append(trade)
		$ScrollContainer/Trader.add_child(trade)
		yield(get_tree(), "idle_frame")
		trade.set_size(Vector2(1740,170))
		#TODO GET PLAYERCOUNT HERE
		trade.init(res, 0, city_resources[res])
		trade.connect("transaction", self, "_on_transaction")


func _on_transaction(buy, amount, resource):
	emit_signal("transaction", buy, amount, resource, city_name)

func _on_Close_pressed():
	emit_signal("close_menu")
