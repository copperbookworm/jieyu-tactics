# Expression

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Expression` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Expression.md`

**摘要**：A class that stores an expression you can execute.

## 描述

An expression can be made of any arithmetic operation, built-in math function call, method call of a passed instance, or built-in type construction call.
		An example expression text using the built-in math functions could be `sqrt(pow(3, 2) + pow(4, 2))`.
		In the following example we use a `LineEdit` node to write our expression and show the result.
		`codeblocks`
		`gdscript`
		var expression = Expression.new()

		func _ready():
			$LineEdit.text_submitted.connect(self._on_text_submitted)

		func _on_text_submitted(command):
			var error = expression.parse(command)
			if error != OK:
				print(expression.get_error_text())
				return
			var result = expression.execute()
			if not expression.has_execute_failed():
				$LineEdit.text = str(result)
		
		`csharp`
		private Expression _expression = new Expression();

		public override void _Ready()
		{
			GetNode<LineEdit>("LineEdit").TextSubmitted += OnTextEntered;
		}

		private void OnTextEntered(string command)
		{
			Error error = _expression.Parse(command);
			if (error != Error.Ok)
			{
				GD.Print(_expression.GetErrorText());
				return;
			}
			Variant result = _expression.Execute();
			if (!_expression.HasExecuteFailed())
			{
				GetNode<LineEdit>("LineEdit").Text = result.ToString();
			}
		}

## 方法

### `execute(inputs: Array = [], base_instance: Object = null, show_error: bool = true, const_calls_only: bool = false) -> Variant`

Executes the expression that was previously parsed by `parse` and returns the result. Before you use the returned object, you should check if the method failed by calling `has_execute_failed`.
				If you defined input variables in `parse`, you can specify their values in the inputs array, in the same order.

### `get_error_text() -> String`
- 限定：qualifiers=const

Returns the error text if `parse` or `execute` has failed.

### `has_execute_failed() -> bool`
- 限定：qualifiers=const

Returns `true` if `execute` has failed.

### `parse(expression: String, input_names: PackedStringArray = PackedStringArray()) -> int`

Parses the expression and returns an `Error` code.
				You can optionally specify names of variables that may appear in the expression with `input_names`, so that you can bind them when it gets executed.

## 教程链接

- [Evaluating Expressions](None)

