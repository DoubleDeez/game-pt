
extends TileMap

func PerformAction(TileID, ActionType):
	print(get_name() + " : " + str(TileID) + " : " + str(ActionType))
	return rand_range(0, 10) >= 5

