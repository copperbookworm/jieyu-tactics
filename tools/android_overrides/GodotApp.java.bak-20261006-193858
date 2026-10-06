/**************************************************************************/
/*  GodotApp.java                                                         */
/**************************************************************************/
/*                         This file is part of:                          */
/*                             GODOT ENGINE                               */
/*                        https://godotengine.org                         */
/**************************************************************************/
/* Copyright (c) 2014-present Godot Engine contributors (see AUTHORS.md). */
/* Copyright (c) 2007-2014 Juan Linietsky, Ariel Manzur.                  */
/*                                                                        */
/* Permission is hereby granted, free of charge, to any person obtaining  */
/* a copy of this software and associated documentation files (the        */
/* "Software"), to deal in the Software without restriction, including    */
/* without limitation the rights to use, copy, modify, merge, publish,    */
/* distribute, sublicense, and/or sell copies of the Software, and to     */
/* permit persons to whom the Software is furnished to do so, subject to  */
/* the following conditions:                                              */
/*                                                                        */
/* The above copyright notice and this permission notice shall be         */
/* included in all copies or substantial portions of the Software.        */
/*                                                                        */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,        */
/* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF     */
/* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. */
/* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY   */
/* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,   */
/* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE      */
/* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                 */
/**************************************************************************/

// ============================================================================
// jieyu-1 自定义：请求高刷新率（120 Hz）
//
// 为什么必须由应用自己请求：华为的 FrameRateManager 会把本包钉在 60 Hz
//   （adb 实测：mActiveModeId=1、SurfaceFlinger period_ns=16666666、
//    AGPService "set active config - fps 60" + "iaware strange app type: -1"），
// 而同一台机器上另一个游戏运行时是 120 Hz（mActiveModeId=2、period_ns=8333333），
// 且本机 mDisplayModeSpecs 是 primaryRefreshRateRange=[0 60] +
// appRequestRefreshRateRange=[0 Infinity] —— 系统只把超出 60 的档位给"主动请求"的应用。
// Godot 4.7 在 Android 上没有高刷开关（只有 iOS 有 allow_high_refresh_rate），
// Engine.max_fps / frame_pacing=false 都不会改显示模式（2026-10-05 三条路都试过）。
//
// 完整背景、八变体实测与验收口径见 docs/性能预算.md 第十四节。
// 本文件由 tools/android_overrides/install_build_template.ps1 覆盖进 android/build/。
// ============================================================================

package com.godot.game;

import org.godotengine.godot.Godot;
import org.godotengine.godot.GodotActivity;

import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.Display;
import android.view.Surface;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;

import androidx.activity.EdgeToEdge;
import androidx.core.splashscreen.SplashScreen;

/**
 * Template activity for Godot Android builds.
 * Feel free to extend and modify this class for your custom logic.
 */
public class GodotApp extends GodotActivity {
	/** 目标刷新率：优先取 120 Hz 档；没有才退到面板最高档（144 Hz 会让帧预算更紧，不是默认选择）。 */
	private static final float TARGET_REFRESH_HZ = 120.0f;
	/** 认定"就是 120 档"的容差（面板常报 120.00001 这种）。 */
	private static final float TARGET_TOLERANCE_HZ = 10.0f;
	private static final String TAG = "jieyu";

	static {
		// .NET libraries.
		if (BuildConfig.FLAVOR.equals("mono")) {
			try {
				Log.v("GODOT", "Loading System.Security.Cryptography.Native.Android library");
				System.loadLibrary("System.Security.Cryptography.Native.Android");
			} catch (UnsatisfiedLinkError e) {
				Log.e("GODOT", "Unable to load System.Security.Cryptography.Native.Android library");
			}
		}
	}

	private final Runnable updateWindowAppearance = () -> {
		Godot godot = getGodot();
		if (godot != null) {
			godot.enableImmersiveMode(godot.isInImmersiveMode(), true);
			godot.enableEdgeToEdge(godot.isInEdgeToEdgeMode(), true);
			godot.setSystemBarsAppearance();
		}
	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		SplashScreen splashScreen = SplashScreen.installSplashScreen(this);
		EdgeToEdge.enable(this);
		super.onCreate(savedInstanceState);

		Godot godot = getGodot();
		if (godot != null && godot.getDisableGodotSplash()) {
			splashScreen.setKeepOnScreenCondition(() -> godot.getRunStatus() != Godot.RunStatus.STARTED);
		}
	}

	@Override
	public void onResume() {
		super.onResume();
		updateWindowAppearance.run();
		requestHighRefreshRate();
	}

	@Override
	public void onGodotMainLoopStarted() {
		super.onGodotMainLoopStarted();
		runOnUiThread(updateWindowAppearance);
		// jieyu-1：请求高刷。SurfaceView 可能比主循环晚出现，所以补两次重试。
		runOnUiThread(() -> {
			requestHighRefreshRate();
			View decor = getWindow().getDecorView();
			decor.postDelayed(this::requestHighRefreshRate, 800);
			decor.postDelayed(this::requestHighRefreshRate, 2500);
		});
	}

	@Override
	public void onGodotForceQuit(Godot instance) {
		if (!BuildConfig.FLAVOR.equals("instrumented")) {
			// For instrumented builds, we disable force-quitting to allow the instrumented tests to complete
			// successfully, otherwise they fail when the process crashes.
			super.onGodotForceQuit(instance);
		}
	}

	@Override
	protected boolean isPiPEnabled() {
		return true;
	}

	// ========================================================================
	// jieyu-1 高刷请求（2026-10-05）
	// 两条腿都下：① 窗口层 preferredDisplayModeId（API 23+，系统给 SurfaceFlinger 投票）
	//              ② Surface 层 setFrameRate（API 30+，Android 官方推荐入口，华为 FrameRateManager 也认它）
	// 各自 try/catch，一条失败不影响另一条。
	// ========================================================================

	private void requestHighRefreshRate() {
		float targetHz = TARGET_REFRESH_HZ;
		try {
			Window window = getWindow();
			WindowManager.LayoutParams lp = window.getAttributes();
			Display display = window.getWindowManager().getDefaultDisplay();
			if (display != null) {
				Display.Mode mode = pickDisplayMode(display);
				if (mode != null) {
					lp.preferredDisplayModeId = mode.getModeId();
					lp.preferredRefreshRate = mode.getRefreshRate();
					targetHz = mode.getRefreshRate();
				}
			}
			window.setAttributes(lp);
			Log.i(TAG, "[高刷] 窗口请求 preferredDisplayModeId=" + lp.preferredDisplayModeId
					+ " preferredRefreshRate=" + lp.preferredRefreshRate);
		} catch (Throwable t) {
			Log.w(TAG, "[高刷] 窗口请求失败: " + t);
		}
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
			applySurfaceFrameRate(targetHz);
		}
	}

	/** 优先返回 120 档；没有就返回面板最高档。 */
	private Display.Mode pickDisplayMode(Display display) {
		Display.Mode exact = null;
		Display.Mode highest = null;
		try {
			for (Display.Mode mode : display.getSupportedModes()) {
				float hz = mode.getRefreshRate();
				if (Math.abs(hz - TARGET_REFRESH_HZ) <= TARGET_TOLERANCE_HZ) {
					if (exact == null || hz > exact.getRefreshRate()) {
						exact = mode;
					}
				}
				if (highest == null || hz > highest.getRefreshRate()) {
					highest = mode;
				}
			}
		} catch (Throwable t) {
			Log.w(TAG, "[高刷] 读显示档位失败: " + t);
		}
		return exact != null ? exact : highest;
	}

	private void applySurfaceFrameRate(float fps) {
		SurfaceView surfaceView;
		try {
			surfaceView = findSurfaceView(getWindow().getDecorView());
		} catch (Throwable t) {
			Log.w(TAG, "[高刷] 找不到 SurfaceView: " + t);
			return;
		}
		if (surfaceView == null) {
			Log.w(TAG, "[高刷] 还没找到 SurfaceView，等下一次重试");
			return;
		}
		// ① Surface 层（API 30+）：这是 Android 11+ 真正的"帧率投票"入口，
		//    SurfaceFlinger 的 DisplayModeDirector 就是按它决定 display mode 的。
		try {
			Surface surface = surfaceView.getHolder().getSurface();
			if (surface != null && surface.isValid()) {
				surface.setFrameRate(fps, Surface.FRAME_RATE_COMPATIBILITY_FIXED_SOURCE,
						Surface.CHANGE_FRAME_RATE_ALWAYS);
				Log.i(TAG, "[高刷] Surface.setFrameRate(" + fps + ") 已下发");
			} else {
				Log.w(TAG, "[高刷] Surface 还不可用，等下一次重试");
			}
		} catch (Throwable t) {
			Log.w(TAG, "[高刷] Surface.setFrameRate 失败: " + t);
		}
		// ② View 层：setRequestedFrameRate 是 API 34 才有的 —— 2026-10-05 真机教训：
		//    在 Android 12(API 31) 上直接调会抛 NoSuchMethodError，而且会把 ① 那条腿一起带崩。
		//    （javap 查的是 android-36 的 android.jar，只能证明编译期存在，不能证明运行期存在。）
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
			try {
				surfaceView.setRequestedFrameRate(fps);
				Log.i(TAG, "[高刷] View.setRequestedFrameRate(" + fps + ") 已下发");
			} catch (Throwable t) {
				Log.w(TAG, "[高刷] View.setRequestedFrameRate 失败: " + t);
			}
		}
	}

	private SurfaceView findSurfaceView(View view) {
		if (view instanceof SurfaceView) {
			return (SurfaceView) view;
		}
		if (view instanceof ViewGroup) {
			ViewGroup group = (ViewGroup) view;
			for (int i = 0; i < group.getChildCount(); i++) {
				SurfaceView found = findSurfaceView(group.getChildAt(i));
				if (found != null) {
					return found;
				}
			}
		}
		return null;
	}
}
