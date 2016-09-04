
extends TileMap

func PerformAction(TilePos, TileID, ActionType):
	var ActionMethodName = "TileAction" + str(TileID)
	if has_method(ActionMethodName):
		call(ActionMethodName, TilePos, ActionType)
		return true
	return false
	
# Stick Action
func TileAction22(TilePos, ActionType):
	if ActionType == "Generic":
		DeleteTile(TilePos)

# Rock Action
func TileAction23(TilePos, ActionType):
	if ActionType == "Generic":
		DeleteTile(TilePos)
		
# Helper to delete tile at position
func DeleteTile(TilePos):
	set_cellv(TilePos, -1)