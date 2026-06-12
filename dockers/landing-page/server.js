const fs = require("fs");
const http = require("http");
const path = require("path");

const rootDir = __dirname;
const port = process.env.PORT || 8080;

const mimeTypes = {
  ".css": "text/css; charset=utf-8",
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".png": "image/png",
  ".svg": "image/svg+xml; charset=utf-8",
  ".webp": "image/webp",
};

function sendFile(res, filePath) {
  fs.readFile(filePath, (error, content) => {
    if (error) {
      res.writeHead(error.code === "ENOENT" ? 404 : 500, {
        "Content-Type": "text/plain; charset=utf-8",
      });
      res.end(error.code === "ENOENT" ? "Not found" : "Server error");
      return;
    }

    const ext = path.extname(filePath).toLowerCase();
    res.writeHead(200, {
      "Content-Type": mimeTypes[ext] || "application/octet-stream",
      "Cache-Control": ext === ".html" ? "no-cache" : "public, max-age=31536000, immutable",
    });
    res.end(content);
  });
}

function sendNotFound(res) {
  res.writeHead(404, { "Content-Type": "text/plain; charset=utf-8" });
  res.end("Not found");
}

function resolveStaticPath(requestPath) {
  let staticPath = requestPath;
  if (staticPath.startsWith("/demo/")) {
    staticPath = staticPath.slice("/demo".length);
  }

  let decodedPath;
  try {
    decodedPath = decodeURIComponent(staticPath);
  } catch {
    return null;
  }

  const normalizedPath = path.normalize(decodedPath).replace(/^(\.\.[/\\])+/, "");
  const filePath = path.join(rootDir, normalizedPath);

  if (!filePath.startsWith(rootDir)) {
    return null;
  }

  return filePath;
}

const server = http.createServer((req, res) => {
  const url = new URL(req.url, `http://${req.headers.host || "localhost"}`);

  if (url.pathname === "/") {
    res.writeHead(302, { Location: "/demo" });
    res.end();
    return;
  }

  if (url.pathname === "/demo" || url.pathname === "/demo/") {
    sendFile(res, path.join(rootDir, "index.html"));
    return;
  }

  const filePath = resolveStaticPath(url.pathname);
  if (!filePath) {
    res.writeHead(400, { "Content-Type": "text/plain; charset=utf-8" });
    res.end("Bad request");
    return;
  }

  fs.stat(filePath, (error, stat) => {
    if (!error && stat.isFile()) {
      sendFile(res, filePath);
      return;
    }

    if (
      path.extname(filePath) ||
      url.pathname.startsWith("/assets/") ||
      url.pathname.startsWith("/demo/assets/")
    ) {
      sendNotFound(res);
      return;
    }

    sendFile(res, path.join(rootDir, "index.html"));
  });
});

server.listen(port, () => {
  console.log(`Healytics landing page listening on ${port}`);
});
