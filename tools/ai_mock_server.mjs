// AI 参谋 —— 本地 mock 供应商（OpenAI 兼容），在不花钱的前提下验证整条链路。
//
// 用法：node tools/ai_mock_server.mjs <port> <lastRequestPath>
//   例：node tools/ai_mock_server.mjs 8123 "D:/Godot4.7_Proj/jieyu-1/tmp_ai_mock_last.json"
//
// 行为：
//   model 以 mock-unauthorized 开头 → 401 {"error":{"message":"Invalid API key provided"}}
//   其余 → 200，带 choices/usage（含 prompt_cache_hit_tokens，用来验缓存字段归一）
// 每次请求把 {path, method, auth, model, messages} 写到 lastRequestPath，
// 让 Godot 侧能反查「发出去的 prompt 到底长什么样」—— 这是端到端断言的关键。

import http from "node:http";
import fs from "node:fs";

const port = Number(process.argv[2] || 8123);
const logPath = process.argv[3] || "";

const server = http.createServer((req, res) => {
  let raw = "";
  req.on("data", (chunk) => { raw += chunk; });
  req.on("end", () => {
    let body = {};
    try { body = JSON.parse(raw); } catch { body = {}; }
    if (logPath) {
      fs.writeFileSync(logPath, JSON.stringify({
        path: req.url,
        method: req.method,
        auth: req.headers.authorization || "",
        goog_key: req.headers["x-goog-api-key"] || "",
        model: body.model || "",
        max_tokens: body.max_tokens || 0,
        stream: body.stream === true,
        messages: body.messages || [],
      }, null, 2));
    }
    // 维护者发布的「价格清单」（静态文件）。故意把 deepseek-flash 的价改成好认的数字：
    // 空闲输入 7 元/百万 ⇒ 1M 未命中输入应算 7_000_000 微元（内置是 1 元 ⇒ 1_000_000），
    // 这样自检能断言「金额真的按在线清单算了」，而不是只断言「拉到了」。
    // peak 故意填成与 offpeak 相同：否则断言会随「跑测试的时刻是不是高峰」而变。
    if (String(req.url).includes("price_manifest")) {
      res.writeHead(200, { "Content-Type": "application/json" });
      res.end(JSON.stringify({
        schema: 1,
        version: 3,
        updated: "2026-10-05",
        source: "https://api-docs.deepseek.com/zh-cn/quick_start/pricing",
        note: "mock 清单（自检用）",
        models: {
          "deepseek-flash": {
            currency: "CNY",
            note: "mock 改过的价",
            offpeak: { in: 7000000, cached_in: 0, out: 10000000 },
            peak: { in: 7000000, cached_in: 0, out: 10000000 },
          },
        },
      }));
      return;
    }
    // 供应商官方的「列出模型」接口（OpenAI 兼容形状）。故意混一个 embedding 进去，
    // 好让自检能断言「非对话模型会被过滤」，而不是只断言「拿到列表」。
    if (req.method === "GET" && String(req.url).includes("models")) {
      res.writeHead(200, { "Content-Type": "application/json" });
      res.end(JSON.stringify({
        object: "list",
        data: [
          { id: "mock-chat", object: "model", owned_by: "mock", name: "Mock Chat",
            context_window: 100000, max_output_tokens: 8192 },
          { id: "mock-reasoner", object: "model", owned_by: "mock", name: "Mock Reasoner" },
          { id: "mock-embedding", object: "model", owned_by: "mock", name: "Mock Embedding" },
        ],
      }));
      return;
    }
    const model = String(body.model || "");
    if (model.startsWith("mock-unauthorized")) {
      res.writeHead(401, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ error: { message: "Invalid API key provided" } }));
      return;
    }
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({
      id: "mock-1",
      object: "chat.completion",
      model,
      choices: [{
        index: 0,
        message: {
          role: "assistant",
          content: "【战局判定】mock 复盘：节奏赢了。\n【关键失误】中路暴露太久。\n【下次这样做】沿侧翼通路推进。\n【一句话总评】稳。"
        },
        finish_reason: "stop"
      }],
      usage: {
        prompt_tokens: 123,
        completion_tokens: 45,
        total_tokens: 168,
        prompt_cache_hit_tokens: 100
      }
    }));
  });
});

server.listen(port, "127.0.0.1", () => console.log("ai_mock_server listening on " + port));
