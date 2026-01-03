#!/bin/bash
set -e

echo "Building frontend..."
cd web
pnpm install
pnpm release
cd ..

echo "Frontend build complete!"
