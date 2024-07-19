extends TileMap

# This function changes the modulate of each cell in an array to show
# planned path for an action
func show_planned_path(vis_layer_id: int, img_src_id: int, atlas_pos: Vector2, path: PackedVector2Array):
	for each in path:
		set_cell(vis_layer_id, each, img_src_id, atlas_pos)
