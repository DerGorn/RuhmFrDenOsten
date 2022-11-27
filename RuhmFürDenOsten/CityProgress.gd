extends TextureProgress

signal population_growth
signal city_growth
signal click_city

const sizes = [100, 2000, 50000, 1000000]
var fill_time = 1.0/30.0
const item = preload("res://ItemProgress.tscn")

export var population = 1
var size = 0
var growth_factor = 1.0001
export (String) var cityName = "Berlin"
export (Array, String) var resources = []
var items = []
var pause = false


# Called when the node enters the scene tree for the first time.
func _ready():
	init(population, resources, cityName)


# Called every frame. 'delta' is the elapsed time since the previous frame.
var growth = 0.0
func _process(delta):
	if !pause: growth += delta
	if growth >= fill_time:
		growth = 0.0
		set_population(population * growth_factor)
		emit_signal("population_growth")

func set_population(pop:float):
	population = pop
	var lower = true
	for s in sizes:
		if !lower: break
		if s >= pop:
			lower = false
			var i = sizes.find(s)
			if (i>size): emit_signal("city_growth")
			size = i
	$CitySize.set_texture(load("res://Assets/Bilder/CitySize_%s.png" % size))
	value = max_value * population / (sizes[size] if size < sizes.size() else INF)

func set_name(name:String):
	cityName = name
	$Name.set_text(name)

func add_resource(res:String):
	var it =  item.instance().init(res)
	var i = items.size()
	items.append(it)
	yield(get_tree(), "idle_frame")
	it.set_scale(Vector2(0.5, 0.5))
	it.set_position(Vector2(i % 3 * 110 - 45, floor(i / 3) * 100 + 220))
	add_child(it)

func init(pop:int, res:Array, name:String):
	set_population(pop)
	for r in res:
		add_resource(str(r))
	set_name(name)
	return self

func _input(event):
	if (event.is_action_pressed("click")): 
		if pause: return
		var inside:bool = get_rect().has_point(make_canvas_position_local(event.position) + rect_global_position)
		if (inside): emit_signal("click_city")


func trade_resource(buy:bool, amount:int, resource:String):
	for it in items:
		if it.resource_type == resource:
			it.count += amount * (-1 if buy else 1)

func get_resources():
	var ret_val = {"population": round(population)}
	for it in items:
		ret_val.merge(it.get_resource())
	return ret_val

func toggle_pause():
	pause = !pause
	for it in items:
		it.toggle_pause()
