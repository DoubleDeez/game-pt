
extends Node

export var TerrainSize = 5
export(Texture) var TerrainSprite

var Center = Vector2(0, 0)

func GenerateTerrain():
	if TerrainSprite != null:
		var TileSize = TerrainSprite.get_width()
		var TerrainHalfSize = TerrainSize * TileSize / 2
		Center = Vector2(TerrainHalfSize, TerrainHalfSize)

		var TilePos = Vector2(0, 0)
		for y in range(TerrainSize):
			for x in range(TerrainSize):
				var NewSprite = Sprite.new()
				NewSprite.set_texture(TerrainSprite)
				NewSprite.set_pos(TilePos)
				add_child(NewSprite)

				TilePos.x += TileSize
			TilePos.x = 0
			TilePos.y += TileSize

func GetTerrainCenter():
	return Center;
