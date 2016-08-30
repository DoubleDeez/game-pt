
extends Node

export(NodePath) var TerrainNodePath
export(NodePath) var CameraNodePath
export(NodePath) var CharacterNodePath

var TerrainNode
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
	GenerateTerrain()
	CameraNode = get_node(CameraNodePath)
	CameraNode.set_pos(TerrainNode.GetTerrainCenter())
	CameraNode.set_enable_follow_smoothing(true)
	CharacterNode = get_node(CharacterNodePath)
	CharacterNode.set_pos(TerrainNode.GetTerrainCenter())
	set_process(true)

func GenerateTerrain():
	TerrainNode = get_node(TerrainNodePath)
	TerrainNode.GenerateTerrain()

func AreExportVarsValid():
	return TerrainNodePath != null \
		&& CameraNodePath != null \
		&& CharacterNodePath != null
