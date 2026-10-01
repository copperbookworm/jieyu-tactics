extends Node

signal player_died
signal enemy_killed(enemy)
signal item_collected(item)
signal quest_updated(quest_id)
signal game_paused
signal crosshair_clamped(position)      ## 准心被地形或拖拽上限钳制时广播（相机确认稿）
signal flag_state_changed(node_index, state)  ## 白旗点状态变化：蓝／红／白
signal match_finished(winner)
