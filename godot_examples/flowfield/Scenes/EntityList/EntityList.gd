extends Control


var list_items = []
var emitter_item_scene = preload("res://Scenes/EntityList/EmitterItem.tscn")
var attractor_item_scene = preload("res://Scenes/EntityList/AttractorItem.tscn")
var item_height = 30.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func rebuild_list():
	var offset = 0.0
	for i in list_items:
		i.rect_position.y = offset
		offset += item_height

func add_emitter(emitter):
	var es = emitter_item_scene.instance()
	es.emitter = emitter
	es.rect_position.y = item_height * len(list_items)
	es.connect("removed", self, "on_emitter_item_removed")
	add_child(es)
	list_items.append(es)

func add_attractor(attractor):
	var es = attractor_item_scene.instance()
	es.attractor = attractor
	es.rect_position.y = item_height * len(list_items)
	es.connect("removed", self, "on_emitter_item_removed")
	add_child(es)
	list_items.append(es)

func on_emitter_item_removed(item):
	list_items.erase(item)
	rebuild_list()


func _on_Field_emitter_added(e):
	add_emitter(e)


func _on_Field_attractor_added(a):
	add_attractor(a)
