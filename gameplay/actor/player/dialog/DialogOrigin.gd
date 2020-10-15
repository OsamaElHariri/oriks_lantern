extends Node2D

var DIALOG_BOX = preload("res://gameplay/actor/player/dialog/dialog_box/DialogBox.tscn")

export var dialog_group = ""
var  dialog_box

func spawn_dialog(bbtext):
	remove_dialog()
	
	var target = get_tree().get_nodes_in_group(dialog_group)[0]
	dialog_box = DIALOG_BOX.instance()
	dialog_box.target = target
	dialog_box.scale *= 0.3
	dialog_box.set_bbtext(bbtext)
	add_child(dialog_box)

func remove_dialog():
	if dialog_box: dialog_box.remove()
	dialog_box = null

func free_dialog():
	if dialog_box: dialog_box.queue_free()
	dialog_box = null
