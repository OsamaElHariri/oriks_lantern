extends Node2D

# This class is set up as an autoload node.
# Everything that needs to emit and/ or connect to
# signals across the project should do it through
# this class. To connect to a signal call EMITTER.connect, where connect
# is the usual signal connecting method. To emit a signal,
# call EMITTER.emit(data), where data is whatever information you want to send
# with the signal

signal player_spirit_form_start
signal player_spirit_form_end
signal player_movement_heartbeat
signal player_entered_level
signal player_exited_level
signal request_screen_shake

func emit (signal_id, data=null):
	if data !=null:
		emit_signal(signal_id, data)
	else:
		emit_signal(signal_id)
