#!/bin/bash

cleanup() {
  echo "Killing..."
  pkill -P $$
  exit 0
}

trap cleanup SIGINT

dotnet run --project src/Boards.Api &
dotnet run --project src/Boards.WebSite &
wait
