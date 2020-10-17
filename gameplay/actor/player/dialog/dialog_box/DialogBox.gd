extends Node2D

export(Curve) var curve
export(Curve) var curve_back

var target
var tail
var tail_height

var current_animation = 0

var animation_direction = 1
var current_curve

func _ready():
	tail = $Visuals/dialog_box_tail
	tail_height = tail.texture.get_size().y
	$Visuals.modulate = Color(1, 1, 1, 0)
	current_curve = curve

func set_bbtext(text):
	$Visuals/RichTextLabel.bbcode_text = '%s%s%s' % ['[center]', text, '[/center]']

func _process(delta):
	if not target: return
	
	current_animation += delta * 7 * animation_direction
	current_animation = clamp(current_animation, 0, 1)
	var anim = current_curve.interpolate(current_animation)
	$Visuals.modulate = Color(1, 1, 1, current_animation)
	$Visuals.scale = Vector2.ONE * anim
	
	var diff = target.global_position - global_position
	tail.rotation = Vector2.UP.angle_to(diff)
	tail.scale = Vector2(1, abs((diff / scale).length()) / tail_height)
	
	if current_animation <= 0:
		queue_free()

func remove():
	current_curve = curve_back
	animation_direction = -1.2
