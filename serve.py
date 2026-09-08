#!/usr/bin/env python3
"""Tiny static server for the portfolio REVIEW phase: serves the site dir
with no-cache headers so Mick's devices always get the latest build.
Kill when the site goes live on Cloudflare Pages (take-down rule)."""
import http.server, functools

DIR = "/Users/mick/Projects/portfolio/site"

class NoCache(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *a, **kw):
        super().__init__(*a, directory=DIR, **kw)
    def end_headers(self):
        self.send_header("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        super().end_headers()

if __name__ == "__main__":
    http.server.ThreadingHTTPServer(("100.123.82.89", 8777), NoCache).serve_forever()
