#!/bin/sh -l

echo "Running tests..."
# Set HOME because github actions overwrites it
HOME="/home/$(whoami)" bats "$1"
