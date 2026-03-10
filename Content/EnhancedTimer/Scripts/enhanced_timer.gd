class_name EnhancedTimer
extends Timer


func get_elapsed_timer() -> float:
	return wait_time - time_left
