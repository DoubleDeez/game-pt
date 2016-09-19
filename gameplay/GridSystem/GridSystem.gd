extends Node2D

export(NodePath) var TileCursorNode

var TileCursor
var Constants

func _ready():
	TileCursor = get_node(TileCursorNode)
	Constants = get_node("/root/Constants")
	set_process(true)
	
func _process(delta):
	TileCursor.set_pos(GetTilePositionFromMouse())
	if Input.is_action_pressed("select_tile"):
		pass

func GetTilePositionFromMouse():
	return (get_local_mouse_pos() / Constants.TILE_SIZE).floor() * Constants.TILE_SIZE