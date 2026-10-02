extends Node

signal player_died
signal player_downed                      ## 4.16 被击倒（血量归零进倒地态，未必立刻阵亡）
signal player_hit(damage)                 ## 12.7.4 玩家受击（相机侧订阅它做轻微屏幕震动）
signal enemy_killed(enemy)
signal item_collected(item)
signal quest_updated(quest_id)
signal game_paused
signal crosshair_clamped(position)      ## 准心被地形或拖拽上限钳制时广播（相机确认稿）
signal flag_state_changed(node_index, state)  ## 白旗点状态变化：蓝／红／白
signal match_finished(winner)
