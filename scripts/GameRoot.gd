
extends Node

export(NodePath) var TerrainNodePath
export(NodePath) var CameraNodePath
export(NodePath) var CharacterNodePath

var TerrainNode

func _ready():
	if AreExportVarsValid():
		InitGame()
	else:
		print("GameRoot::_ready() - Export vars are invalid")

func InitGame():
	GenerateTerrain()
	var CameraNode = get_node(CameraNodePath)
	CameraNode.set_pos(TerrainNode.GetTerrainCenter())
	var CharacterNode = get_node(CharacterNodePath)
	CharacterNode.set_pos(TerrainNode.GetTerrainCenter())

func GenerateTerrain():
	TerrainNode = get_node(TerrainNodePath)
	TerrainNode.GenerateTerrain()

func AreExportVarsValid():
	return TerrainNodePath != null \
		&& CameraNodePath != null \
		&& CharacterNodePath != null
