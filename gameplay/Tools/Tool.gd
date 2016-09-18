extends Node

export(int) var Damage
export(int) var ToolType

func _ready():
	pass

func GetDamage():
	return Damage
	
func GetToolType():
	return ToolType