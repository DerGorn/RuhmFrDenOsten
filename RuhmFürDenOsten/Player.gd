extends Node


var resources = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_resource(res:String, amount:int):
	if res in resources: resources[res] += amount
	else: resources.merge({res: amount})

func remove_resource(res:String, amount:int):
	resources[res] -= amount
	if resources[res] <= 0:
		resources.erase(res)


func _on_Map_transaction(buy, amount, resource):
	if buy: add_resource(resource, amount)
	else: remove_resource(resource, amount)
