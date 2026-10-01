# EditorVCSInterface

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorVCSInterface` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorVCSInterface.md`

**摘要**：Version Control System (VCS) interface, which reads and writes to the local VCS in use.

## 描述

Defines the API that the editor uses to extract information from the underlying VCS. The implementation of this API is included in VCS plugins, which are GDExtension plugins that inherit `EditorVCSInterface` and are attached (on demand) to the singleton instance of `EditorVCSInterface`. Instead of performing the task themselves, all the virtual functions listed below are calling the internally overridden functions in the VCS plugins to provide a plug-n-play experience. A custom VCS plugin is supposed to inherit from `EditorVCSInterface` and override each of these virtual functions.

## 方法

### `_allow_amends() -> bool`
- 限定：qualifiers=virtual

Returns whether or not the plugin allows commit amends.

### `_checkout_branch(branch_name: String) -> bool`
- 限定：qualifiers=virtual required

Checks out a `branch_name` in the VCS.

### `_commit(msg: String, amend: bool) -> void`
- 限定：qualifiers=virtual

Commits the currently staged changes and applies the commit `msg` to the resulting commit. If `amend` is `true` the commit will modify the most recent commit instead.

### `_create_branch(branch_name: String) -> void`
- 限定：qualifiers=virtual required

Creates a new branch named `branch_name` in the VCS.

### `_create_remote(remote_name: String, remote_url: String) -> void`
- 限定：qualifiers=virtual required

Creates a new remote destination with name `remote_name` and points it to `remote_url`. This can be an HTTPS remote or an SSH remote.

### `_discard_file(file_path: String) -> void`
- 限定：qualifiers=virtual required

Discards the changes made in a file present at `file_path`.

### `_fetch(remote: String) -> void`
- 限定：qualifiers=virtual required

Fetches new changes from the `remote`, but doesn't write changes to the current working directory. Equivalent to `git fetch`.

### `_get_branch_list() -> String[]`
- 限定：qualifiers=virtual required

Gets an instance of an `Array` of `String`s containing available branch names in the VCS.

### `_get_current_branch_name() -> String`
- 限定：qualifiers=virtual required

Gets the current branch name defined in the VCS.

### `_get_diff(identifier: String, area: int) -> Dictionary[]`
- 限定：qualifiers=virtual required

Returns an array of `Dictionary` items (see `create_diff_file`, `create_diff_hunk`, `create_diff_line`, `add_line_diffs_into_diff_hunk` and `add_diff_hunks_into_diff_file`), each containing information about a diff. If `identifier` is a file path, returns a file diff, and if it is a commit identifier, then returns a commit diff.

### `_get_line_diff(file_path: String, text: String) -> Dictionary[]`
- 限定：qualifiers=virtual required

Returns an `Array` of `Dictionary` items (see `create_diff_hunk`), each containing a line diff between a file at `file_path` and the `text` which is passed in.

### `_get_modified_files_data() -> Dictionary[]`
- 限定：qualifiers=virtual required

Returns an `Array` of `Dictionary` items (see `create_status_file`), each containing the status data of every modified file in the project folder.

### `_get_previous_commits(max_commits: int) -> Dictionary[]`
- 限定：qualifiers=virtual required

Returns an `Array` of `Dictionary` items (see `create_commit`), each containing the data for a past commit.

### `_get_remotes() -> String[]`
- 限定：qualifiers=virtual required

Returns an `Array` of `String`s, each containing the name of a remote configured in the VCS.

### `_get_vcs_name() -> String`
- 限定：qualifiers=virtual required

Returns the name of the underlying VCS provider.

### `_initialize(project_path: String) -> bool`
- 限定：qualifiers=virtual required

Initializes the VCS plugin when called from the editor. Returns whether or not the plugin was successfully initialized. A VCS project is initialized at `project_path`.

### `_pull(remote: String) -> void`
- 限定：qualifiers=virtual required

Pulls changes from the remote. This can give rise to merge conflicts.

### `_push(remote: String, force: bool) -> void`
- 限定：qualifiers=virtual required

Pushes changes to the `remote`. If `force` is `true`, a force push will override the change history already present on the remote.

### `_remove_branch(branch_name: String) -> void`
- 限定：qualifiers=virtual required

Remove a branch from the local VCS.

### `_remove_remote(remote_name: String) -> void`
- 限定：qualifiers=virtual required

Remove a remote from the local VCS.

### `_set_credentials(username: String, password: String, ssh_public_key_path: String, ssh_private_key_path: String, ssh_passphrase: String) -> void`
- 限定：qualifiers=virtual required

Set user credentials in the underlying VCS. `username` and `password` are used only during HTTPS authentication unless not already mentioned in the remote URL. `ssh_public_key_path`, `ssh_private_key_path`, and `ssh_passphrase` are only used during SSH authentication.

### `_shut_down() -> bool`
- 限定：qualifiers=virtual required

Shuts down VCS plugin instance. Called when the user either closes the editor or shuts down the VCS plugin through the editor UI.

### `_stage_file(file_path: String) -> void`
- 限定：qualifiers=virtual required

Stages the file present at `file_path` to the staged area.

### `_unstage_file(file_path: String) -> void`
- 限定：qualifiers=virtual required

Unstages the file present at `file_path` from the staged area to the unstaged area.

### `add_diff_hunks_into_diff_file(diff_file: Dictionary, diff_hunks: Dictionary[]) -> Dictionary`

Helper function to add an array of `diff_hunks` into a `diff_file`.

### `add_line_diffs_into_diff_hunk(diff_hunk: Dictionary, line_diffs: Dictionary[]) -> Dictionary`

Helper function to add an array of `line_diffs` into a `diff_hunk`.

### `create_commit(msg: String, author: String, id: String, unix_timestamp: int, offset_minutes: int) -> Dictionary`

Helper function to create a commit `Dictionary` item. `msg` is the commit message of the commit. `author` is a single human-readable string containing all the author's details, e.g. the email and name configured in the VCS. `id` is the identifier of the commit, in whichever format your VCS may provide an identifier to commits. `unix_timestamp` is the UTC Unix timestamp of when the commit was created. `offset_minutes` is the timezone offset in minutes, recorded from the system timezone where the commit was created.

### `create_diff_file(new_file: String, old_file: String) -> Dictionary`

Helper function to create a `Dictionary` for storing old and new diff file paths.

### `create_diff_hunk(old_start: int, new_start: int, old_lines: int, new_lines: int) -> Dictionary`

Helper function to create a `Dictionary` for storing diff hunk data. `old_start` is the starting line number in old file. `new_start` is the starting line number in new file. `old_lines` is the number of lines in the old file. `new_lines` is the number of lines in the new file.

### `create_diff_line(new_line_no: int, old_line_no: int, content: String, status: String) -> Dictionary`

Helper function to create a `Dictionary` for storing a line diff. `new_line_no` is the line number in the new file (can be `-1` if the line is deleted). `old_line_no` is the line number in the old file (can be `-1` if the line is added). `content` is the diff text. `status` is a single character string which stores the line origin.

### `create_status_file(file_path: String, change_type: int, area: int) -> Dictionary`

Helper function to create a `Dictionary` used by editor to read the status of a file.

### `popup_error(msg: String) -> void`

Pops up an error message in the editor which is shown as coming from the underlying VCS. Use this to show VCS specific error messages.

## 枚举

### `ChangeType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CHANGE_TYPE_NEW` |  |
| `1` | `CHANGE_TYPE_MODIFIED` |  |
| `2` | `CHANGE_TYPE_RENAMED` |  |
| `3` | `CHANGE_TYPE_DELETED` |  |
| `4` | `CHANGE_TYPE_TYPECHANGE` |  |
| `5` | `CHANGE_TYPE_UNMERGED` |  |

### `TreeArea`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TREE_AREA_COMMIT` |  |
| `1` | `TREE_AREA_STAGED` |  |
| `2` | `TREE_AREA_UNSTAGED` |  |

## 教程链接

- [Version control systems](None)

