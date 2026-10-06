/**
 * 解域 · 鸿蒙呈现链路探针
 *
 * 目的：回答一个具体问题——这台鸿蒙设备/这套调度策略，到底把应用的呈现帧率钉在哪一档，
 * 以及应用"主动请求高刷"能不能生效。对应 Godot 侧结论（docs/性能预算.md 第十四/十五节）：
 * 华为按包名策略把 Android 包摁在 60 Hz、应用侧请求无效；鸿蒙侧需要单独取证。
 *
 * 三件事：
 *   1. 读出屏幕能力：分辨率 / 密度 / 系统当前 refreshRate；
 *   2. 用 displaySync 分别按 30 / 60 / 120 fps 请求帧回调，量真实到达间隔；
 *   3. 给出 p50 / p95 / 实测 fps，和"请求值 vs 实到值"的对照。
 *
 * 注意：本探针量的是 ArkUI 的 vsync 呈现节拍，不是 Godot 的渲染耗时；
 * 但"设备是否愿意给 >60 Hz"这个结论对两者是同一个。
 */
import display from '@ohos.display';
import displaySync from '@ohos.graphics.displaySync';
import { BusinessError } from '@ohos.base';

interface ProbeResult {
  requested: number;
  frames: number;
  seconds: number;
  fps: number;
  p50: number;
  p95: number;
  minMs: number;
  maxMs: number;
}

@Entry
@Component
struct Index {
  @State deviceInfo: string = '读取中…';
  @State defaultRefresh: number = 0;
  @State results: ProbeResult[] = [];
  @State running: boolean = false;
  @State note: string = '';

  private sync: displaySync.DisplaySync | undefined = undefined;
  private intervals: number[] = [];
  private lastTs: number = 0;
  private startTs: number = 0;
  private requested: number = 0;

  aboutToAppear(): void {
    this.readDevice();
  }

  aboutToDisappear(): void {
    this.stopProbe();
  }

  private readDevice(): void {
    try {
      const d: display.Display = display.getDefaultDisplaySync();
      this.defaultRefresh = d.refreshRate;
      this.deviceInfo =
        `分辨率 ${d.width}x${d.height}  可用 ${d.availableWidth}x${d.availableHeight}\n` +
        `密度 ${d.densityDPI} dpi (x${d.densityPixels})  旋转 ${d.rotation}\n` +
        `系统当前 refreshRate = ${d.refreshRate} Hz`;
    } catch (e) {
      const err = e as BusinessError;
      this.deviceInfo = `读取显示信息失败: ${err.code} ${err.message}`;
    }
  }

  private stopProbe(): void {
    if (this.sync !== undefined) {
      try {
        this.sync.stop();
        this.sync.off('frame');
      } catch (e) {
        // 停止阶段的异常不影响已有数据
      }
      this.sync = undefined;
    }
    this.running = false;
  }

  /** 按请求帧率采 4 秒，把帧间隔换算成 ms 统计 */
  private startProbe(requested: number): void {
    this.stopProbe();
    this.intervals = [];
    this.lastTs = 0;
    this.startTs = 0;
    this.requested = requested;
    this.running = true;
    this.note = `正在按 ${requested} fps 请求帧回调…`;

    const range: ExpectedFrameRateRange = {
      min: requested,
      max: requested,
      expected: requested
    };

    this.sync = displaySync.create();
    try {
      this.sync.setExpectedFrameRateRange(range);
    } catch (e) {
      const err = e as BusinessError;
      this.note = `setExpectedFrameRateRange 失败: ${err.code} ${err.message}`;
    }

    this.sync.on('frame', (info: displaySync.IntervalInfo) => {
      if (this.startTs === 0) {
        this.startTs = info.timestamp;
      }
      if (this.lastTs !== 0) {
        this.intervals.push((info.timestamp - this.lastTs) / 1e6);
      }
      this.lastTs = info.timestamp;

      const elapsedSec: number = (info.timestamp - this.startTs) / 1e9;
      if (elapsedSec >= 4) {
        this.finishProbe(elapsedSec);
      }
    });

    try {
      this.sync.start();
    } catch (e) {
      const err = e as BusinessError;
      this.note = `start 失败: ${err.code} ${err.message}`;
      this.running = false;
    }
  }

  private finishProbe(elapsedSec: number): void {
    const samples: number[] = this.intervals.slice();
    const requested: number = this.requested;
    this.stopProbe();

    if (samples.length === 0) {
      this.note = `请求 ${requested} fps：4 秒内没有收到帧回调`;
      return;
    }

    samples.sort((a: number, b: number) => a - b);
    const pick = (q: number): number => samples[Math.min(samples.length - 1, Math.floor(samples.length * q))];
    const sum: number = samples.reduce((acc: number, v: number) => acc + v, 0);
    const avg: number = sum / samples.length;

    const result: ProbeResult = {
      requested: requested,
      frames: samples.length,
      seconds: Math.round(elapsedSec * 100) / 100,
      fps: Math.round((samples.length / elapsedSec) * 10) / 10,
      p50: Math.round(pick(0.5) * 100) / 100,
      p95: Math.round(pick(0.95) * 100) / 100,
      minMs: Math.round(samples[0] * 100) / 100,
      maxMs: Math.round(samples[samples.length - 1] * 100) / 100
    };

    let verdict: string = '基本吻合请求档位';
    if (result.fps > requested * 1.15) {
      verdict = '系统给了比请求更高（可能被上取整到面板档位）';
    } else if (result.fps < requested * 0.85) {
      verdict = '系统没给到请求的档位（被策略钉住）';
    }

    this.results = this.results.concat([result]);
    this.note =
      `请求 ${requested} fps：实测 ${result.fps} fps，平均间隔 ${Math.round(avg * 100) / 100} ms\n` +
      `判定：${verdict}`;
  }

  build() {
    Column({ space: 12 }) {
      Text('解域 · 呈现链路探针')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)

      Text(this.deviceInfo)
        .fontSize(14)
        .width('100%')
        .padding(10)
        .backgroundColor('#F1F3F5')
        .borderRadius(8)

      Row({ space: 8 }) {
        Button('读设备信息')
          .onClick(() => this.readDevice())
          .enabled(!this.running)
        Button('30 fps')
          .onClick(() => this.startProbe(30))
          .enabled(!this.running)
        Button('60 fps')
          .onClick(() => this.startProbe(60))
          .enabled(!this.running)
        Button('120 fps')
          .onClick(() => this.startProbe(120))
          .enabled(!this.running)
      }
      .width('100%')

      if (this.running) {
        Row({ space: 8 }) {
          LoadingProgress().width(22).height(22)
          Text(`采样中（请求 ${this.requested} fps，窗口 4 s）`).fontSize(14)
        }
      }

      if (this.note !== '') {
        Text(this.note)
          .fontSize(13)
          .width('100%')
          .padding(8)
          .backgroundColor('#FFF4E5')
          .borderRadius(8)
      }

      List({ space: 6 }) {
        ForEach(this.results, (r: ProbeResult) => {
          ListItem() {
            Column({ space: 2 }) {
              Text(`请求 ${r.requested} fps → 实测 ${r.fps} fps`)
                .fontSize(15)
                .fontWeight(FontWeight.Medium)
                .width('100%')
              Text(`帧数 ${r.frames} / ${r.seconds}s   p50 ${r.p50} ms   p95 ${r.p95} ms   min ${r.minMs} / max ${r.maxMs} ms`)
                .fontSize(12)
                .fontColor('#555555')
                .width('100%')
            }
            .padding(8)
            .backgroundColor('#FFFFFF')
            .borderRadius(6)
            .border({ width: 1, color: '#E5E7EB' })
          }
        }, (r: ProbeResult, index: number) => `${index}-${r.requested}-${r.fps}`)
      }
      .layoutWeight(1)
      .width('100%')

      Text('口径：displaySync 的帧回调间隔 = ArkUI vsync 节拍。\n它回答"设备愿不愿意给 >60 Hz"，不代表游戏渲染耗时。')
        .fontSize(11)
        .fontColor('#888888')
        .width('100%')
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .alignItems(HorizontalAlign.Start)
  }
}
