extends Node2D

var DIALOG_BOX = preload("res://gameplay/actor/player/dialog/dialog_box/DialogBox.tscn")

export var dialog_group = ""
export var pitch_scale = 1
var  dialog_box

func _ready():
	$AudioStreamPlayer.pitch_scale = pitch_scale

func spawn_dialog(bbtext):
	remove_dialog()
	
	var target = get_tree().get_nodes_in_group(dialog_group)[0]
	dialog_box = DIALOG_BOX.instance()
	if target.has_method('get_dialog_target'):
		target = target.get_dialog_target()
	dialog_box.target = target
	dialog_box.scale *= 0.3
	dialog_box.set_bbtext(bbtext)
	add_child(dialog_box)
	$AudioStreamPlayer.play()

func remove_dialog():
	if dialog_box: dialog_box.remove()
	dialog_box = null

func free_dialog():
	if dialog_box: dialog_box.queue_free()
	dialog_box = null
