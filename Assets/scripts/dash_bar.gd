extends Sprite2D

@onready var charge = $Charge
@onready var full_scale = $Charge.scale.x

@onready var left = $Charge.get_rect().position.x /2
@onready var width = $Charge.get_rect().size.x / 2

func update(val: float):
	charge.get_rect().position.x =  (width * val)
	charge.scale.x = val * full_scale
