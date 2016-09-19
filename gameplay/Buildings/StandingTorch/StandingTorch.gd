extends "../../GameObject.gd"

export(Texture) var TorchOffTexture
export(Texture) var TorchLitTexture
export(NodePath) var TorchSpriteNode

var TorchSprite

var IsLit = false

func _ready():
	TorchSprite = get_node(TorchSpriteNode)

func PerformAction(ActionType, Actioner):
	if ActionType == "Generic":
		ToggleLit()

func ToggleLit():
	IsLit = !IsLit
	if IsLit:
		TorchSprite.set_texture(TorchLitTexture)
	else:
		TorchSprite.set_texture(TorchOffTexture)