import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  distDir: "build",
  output: "export",
  images: {
    unoptimized: true,
  },
  assetPrefix: "http://localhost:3000",
};

export default nextConfig;
