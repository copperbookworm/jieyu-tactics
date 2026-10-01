# Mutex

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Mutex` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Mutex.md`

**摘要**：A binary `Semaphore` for synchronization of multiple `Thread`s.

## 描述

A synchronization mutex (mutual exclusion). This is used to synchronize multiple `Thread`s, and is equivalent to a binary `Semaphore`. It guarantees that only one thread can access a critical section at a time.
		This is a reentrant mutex, meaning that it can be locked multiple times by one thread, provided it also unlocks it as many times.
		**Warning:** To ensure proper cleanup without crashes or deadlocks, the following conditions must be met:
		- When a `Mutex`'s reference count reaches zero and it is therefore destroyed, no threads (including the one on which the destruction will happen) must have it locked.
		- When a `Thread`'s reference count reaches zero and it is therefore destroyed, it must not have any mutex locked.

## 方法

### `lock() -> void`

Locks this `Mutex`, blocks until it is unlocked by the current owner.
				**Note:** This function returns without blocking if the thread already has ownership of the mutex.

### `try_lock() -> bool`

Tries locking this `Mutex`, but does not block. Returns `true` on success, `false` otherwise.
				**Note:** This function returns `true` if the thread already has ownership of the mutex.

### `unlock() -> void`

Unlocks this `Mutex`, leaving it to other threads.
				**Note:** If a thread called `lock` or `try_lock` multiple times while already having ownership of the mutex, it must also call `unlock` the same number of times in order to unlock it correctly.
				**Warning:** Calling `unlock` more times than `lock` on a given thread, thus ending up trying to unlock a non-locked mutex, is wrong and may causes crashes or deadlocks.

## 教程链接

- [Using multiple threads](None)
- [Thread-safe APIs](None)

