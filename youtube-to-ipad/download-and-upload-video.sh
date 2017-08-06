#!/bin/bash -eu

video_list_file_path=$1
http_server_addr=$2
video_download_path=/tmp/`date +%s`

mkdir -p "${video_download_path}"
../youtube-video-download/download-best-quality.sh "${video_download_path}" "${video_list_file_path}"

## Video should have been downloaded by now
## Now post it to the HTTP server

find "${video_download_path}" -name '*.mp4' | while read video
do
    echo "Uploading ${video} to ${http_server_addr}"

    curl \
      -F ''file="@${video}"'' \
      -F "name=button" \
      "${http_server_addr}" > /dev/null
done

## As a last step remove the files from the temp folder
rm -rf "${video_download_path}"

