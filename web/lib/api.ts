// API configuration and utility functions

// Get API base URL from environment variable
// This is automatically set by start_web.py based on config/main.yaml
// The .env.local file is auto-generated on startup with the correct backend port
// For Cloud Run: empty string means same-origin (frontend and backend on same domain via nginx)
export const API_BASE_URL = (() => {
  const envValue = process.env.NEXT_PUBLIC_API_BASE;

  // Empty string is valid for same-origin deployments (Cloud Run)
  if (envValue !== undefined) {
    return envValue;
  }

  // Only throw error if env var is not defined at all
  if (typeof window !== "undefined") {
    console.error("NEXT_PUBLIC_API_BASE is not set.");
    console.error(
      "Please configure server ports in config/main.yaml and restart the application using: python scripts/start_web.py",
    );
    console.error(
      "The .env.local file will be automatically generated with the correct backend port.",
    );
  }
  throw new Error(
    "NEXT_PUBLIC_API_BASE is not configured. Please set server ports in config/main.yaml and restart.",
  );
})();

/**
 * Construct a full API URL from a path
 * @param path - API path (e.g., '/api/v1/knowledge/list')
 * @returns Full URL (e.g., 'http://localhost:8000/api/v1/knowledge/list')
 */
export function apiUrl(path: string): string {
  // Remove leading slash if present to avoid double slashes
  const normalizedPath = path.startsWith("/") ? path : `/${path}`;

  // Remove trailing slash from base URL if present
  const base = API_BASE_URL.endsWith("/")
    ? API_BASE_URL.slice(0, -1)
    : API_BASE_URL;

  return `${base}${normalizedPath}`;
}

/**
 * Construct a WebSocket URL from a path
 * @param path - WebSocket path (e.g., '/api/v1/solve')
 * @returns WebSocket URL (e.g., 'ws://localhost:{backend_port}/api/v1/solve')
 * Note: For same-origin deployments (Cloud Run), uses window.location
 */
export function wsUrl(path: string): string {
  // Remove leading slash if present to avoid double slashes
  const normalizedPath = path.startsWith("/") ? path : `/${path}`;

  // For empty base URL (same-origin deployment like Cloud Run),
  // construct WebSocket URL from current page location
  if (!API_BASE_URL && typeof window !== "undefined") {
    const protocol = window.location.protocol === "https:" ? "wss:" : "ws:";
    return `${protocol}//${window.location.host}${normalizedPath}`;
  }

  // For absolute base URL, convert http to ws and https to wss
  const base = API_BASE_URL.replace(/^http:/, "ws:").replace(
    /^https:/,
    "wss:",
  );

  // Remove trailing slash from base URL if present
  const normalizedBase = base.endsWith("/") ? base.slice(0, -1) : base;

  return `${normalizedBase}${normalizedPath}`;
}
