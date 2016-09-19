
extends Node2D

signal OnGameObjectActioned

export(NodePath) var AreaNodePath

# Required to receive notification that player actioned on this object
func OnActioned(ActionType, Actioner):
	PerformAction(ActionType, Actioner)

func IsAreaOverlapping(ActionerArea):
	var ObjectArea = get_node(AreaNodePath)
	if ObjectArea != null:
		if ObjectArea.overlaps_area(ActionerArea):
			return true
	return false