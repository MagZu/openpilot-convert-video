#!/bin/bash


find . -name dcamera.hevc |sort -t - -k3,3n  -k4,4n -k5,5n -k6,6n -k7,7n -k8,8n -k9,9n | sed 's:\ :\\\ :g'| sed 's/^/file /' > dl.txt; ffmpeg -f concat -safe 0 -i dl.txt -c copy dcamera.hevc; rm dl.txt
find . -name fcamera.hevc |sort -t - -k3,3n  -k4,4n -k5,5n -k6,6n -k7,7n -k8,8n -k9,9n | sed 's:\ :\\\ :g'| sed 's/^/file /' > fl.txt; ffmpeg -f concat -safe 0 -i fl.txt -c copy fcamera.hevc; rm fl.txt



ffmpeg -i fcamera.hevc -i dcamera.hevc -filter_complex "
		nullsrc=size=1164x874 [background];
		[0:v] setpts=PTS-STARTPTS, scale=1164x874 [left];
		[1:v] setpts=1.92*PTS, scale=400x300 [right];
		[background][left]       overlay=shortest=1       [background+left];
		[background+left][right] overlay=shortest=1:x=764:y=584 [left+right]
		" -map '[left+right]' ./output.mkv
