extends Button

signal buySell


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_BuySell_pressed():
		emit_signal("buySell")
