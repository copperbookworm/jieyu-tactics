# Semaphore

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Semaphore` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Semaphore.md`

**摘要**：A synchronization mechanism used to control access to a shared resource by `Thread`s.

## 描述

A synchronization semaphore that can be used to synchronize multiple `Thread`s. Initialized to zero on creation. For a binary version, see `Mutex`.
		**Warning:** Semaphores must be used carefully to avoid deadlocks.
		**Warning:** To guarantee that the operating system is able to perform proper cleanup (no crashes, no deadlocks), these conditions must be met:
		- When a `Semaphore`'s reference count reaches zero and it is therefore destroyed, no threads must be waiting on it.
		- When a `Thread`'s reference count reaches zero and it is therefore destroyed, it must not be waiting on any semaphore.

## 方法

### `post(count: int = 1) -> void`

Lowers the `Semaphore`, allowing one thread in, or more if `count` is specified.

### `try_wait() -> bool`

Like `wait`, but won't block, so if the value is zero, fails immediately and returns `false`. If non-zero, it returns `true` to report success.

### `wait() -> void`

Waits for the `Semaphore`, if its value is zero, blocks until non-zero.

## 教程链接

- [Using multiple threads](None)
- [Thread-safe APIs](None)

