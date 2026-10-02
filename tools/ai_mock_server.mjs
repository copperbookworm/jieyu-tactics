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
