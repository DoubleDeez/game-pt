
extends Node

export var TileSize = 32

export(NodePath) var CameraNodePath
export(NodePath) var CharacterNodePath

export(NodePath) var TileMapCharacterNodePath
export(NodePath) var TileMapModifierNodePath
export(NodePath) var TileMapMainNodePath
export(NodePath) var TileMapBackgroundNodePath

var CameraNode
var CharacterNode
var TileMaps = []

func _ready():
	if AreExportVarsValid():
		InitGame()
	else:
		print("GameRoot::_ready() - Export vars are invalid")

func _process(delta):
	CameraNode.set_pos(CharacterNode.get_pos())

func InitGame():
	OS.set_target_fps(120)
	CameraNode = get_node(CameraNodePath)
	CameraNode.set_enable_follow_smoothing(true)
	CharacterNode = get_node(CharacterNodePath)
	CharacterNode.connect("CharacterActionSignal", self, "OnCharacterAction")
	TileMaps.append(get_node(TileMapCharacterNodePath))
	TileMaps.append(get_node(TileMapModifierNodePath))
	TileMaps.append(get_node(TileMapMainNodePath))
	TileMaps.append(get_node(TileMapBackgroundNodePath))

	set_process(true)

func AreExportVarsValid():
	return CameraNodePath != null \
		&& CharacterNodePath != null

func PerformTileMapAction(WorldPosition, ActionType):
	for TileMap in TileMaps:
		var TilePos = TileMap.world_to_map(WorldPosition)
		var TileID = TileMap.get_cellv(TilePos)
		if TileID != -1 && TileMap.has_method("PerformAction") && TileMap.PerformAction(TilePos, TileID, ActionType):
			return

func TryPerformObjectAction(ActionPos, ActionType, Actioner):
	var ActionArea = Actioner.GetActionArea()
	var CharacterTileMap = get_node(TileMapCharacterNodePath)
	for GameObject in CharacterTileMap.get_children():
		if GameObject.has_method("IsAreaOverlapping"):
			if GameObject.has_method("OnActioned"):
				if GameObject.IsAreaOverlapping(ActionArea):
					GameObject.OnActioned(ActionType, Actioner)
					return true
	return false

func OnCharacterAction(Character, ActionType, ActionPosition):
	if not TryPerformObjectAction(ActionPosition, ActionType, Character):
		PerformTileMapAction(ActionPosition, ActionType)
