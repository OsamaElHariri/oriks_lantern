extends Node2D

var target
var tail
var tail_height

func _ready():
	tail = $Visuals/dialog_box_tail
	tail_height = tail.texture.get_size().y

func set_bbtext(text):
	$RichTextLabel.bbcode_text = '%s%s%s' % ['[center]', text, '[/center]']

func _process(_delta):
	if not target: return
	var diff = target.global_position - global_position
	tail.rotation = Vector2.UP.angle_to(diff)
	tail.scale = Vector2(1, abs((diff / scale).length()) / tail_height)
