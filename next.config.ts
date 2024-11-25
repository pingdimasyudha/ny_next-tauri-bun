import type { NextConfig } from "next";

const isProd = process.env.NODE_ENV === "production";
const internalHost = process.env.TAURI_DEV_HOST || "localhost";
const distDir = process.env.NEXT_DIST_DIR || "build";
const output = (process.env.NEXT_OUTPUT || "export") as "export" | "standalone";

const nextConfig: NextConfig = {
  distDir: distDir,
  output: output,
  images: {
    unoptimized: true,
  },
  assetPrefix: isProd ? undefined : `http://${internalHost}:3000`,
};

export default nextConfig;
