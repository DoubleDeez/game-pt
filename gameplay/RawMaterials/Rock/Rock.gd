
extends Sprite

export(NodePath) var ActionArea
export(Texture) var RockSprite0
export(Texture) var RockSprite1
export(Texture) var RockSprite2
export var MaxHealth = 100

var Health

func _ready():
	get_node(ActionArea).connect("area_enter", self, "TryActioning")
	Health = MaxHealth
	set_texture(RockSprite0)

func TryActioning(ColliderArea):
	var Collider = ColliderArea.get_parent()
	if not Collider.has_method("GetToolType"):
		return
	if Collider.GetToolType() != "Pickaxe":
		return
	TakeHit()
	if Health <= 0:
		var Character = Collider.GetCharacter()
		Character.GiveItem("Stone", 1)
		hide()
		queue_free()
	else:
		UpdateSprite()

func TakeHit():
	Health -= 34
	
func UpdateSprite():
	if Health < 40:
		set_texture(RockSprite2)
	elif Health < 70:
		set_texture(RockSprite1)
	else:
		set_texture(RockSprite0)