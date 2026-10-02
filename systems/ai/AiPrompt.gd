extends RefCounted

## AI 参谋 —— 提示词（纯函数，可单测）
##
## 设计口径（与解域 4.10 的 AI 参谋一致）：
##   生成式只做「解说与措辞」，逻辑归属权在规则层 —— 复盘不改任何游戏状态，
##   所以这里不需要指令白名单；将来做「建议动作」时必须只输出 CommandBook.COMMANDS 里的 id。
## 刻意不写 class_name：引用方 preload。

const AiBattleDigestScript := preload("res://systems/ai/AiBattleDigest.gd")

const SYSTEM_PROMPT := """你是《解域》的战术参谋。玩家刚打完一局 2D 俯视战术射击，现在给他做战后复盘。
规则：
1. 只依据下面给出的战报数据，不得编造战报里没有的信息（不知道就说不知道）。
2. 这是 2D 俯视 + 5 人小队 + 五节点 RAAS 的玩法，建议要具体到「做什么动作」，不要空话。
3. 严格按四段输出，每段用【】起头，不要加别的标题：
【战局判定】一句话说清输赢是怎么来的。
【关键失误】1~2 条，指出最能改的一个决策或习惯。
【下次这样做】2~3 条可执行动作（含位置 / 时机 / 武器或指令建议）。
【一句话总评】不超过 20 字的锐评。
4. 全文不超过 400 字，中文，语气像老兵带新兵：直接、不说客套话、不吹捧。
"""


static func debrief_messages(digest_text: String) -> Array:
	return [
		{"role": "system", "content": SYSTEM_PROMPT},
		{"role": "user", "content": "本局战报（唯一事实来源）：\n" + digest_text},
	]


## 发出去之前的 token 预估（system + user 全算上）
static func estimate_prompt_tokens(digest_text: String) -> int:
	return AiBattleDigestScript.estimate_tokens(SYSTEM_PROMPT + digest_text)
