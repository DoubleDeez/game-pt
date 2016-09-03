
extends Node

export(NodePath) var CameraNodePath
export(NodePath) var CharacterNodePath

var CameraNode
var CharacterNode

func _ready():
	if AreExportVarsValid():
		InitGame()
	else:
		print("GameRoot::_ready() - Export vars are invalid")
		
func _process(delta):
	CameraNode.set_pos(CharacterNode.get_pos())

func InitGame():
	CameraNode = get_node(CameraNodePath)
	CameraNode.set_enable_follow_smoothing(true)
	CharacterNode = get_node(CharacterNodePath)
	set_process(true)

func AreExportVarsValid():
	return CameraNodePath != null \
		&& CharacterNodePath != null
