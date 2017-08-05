#!/bin/bash -eu

video_download_target_path=$1
video_list_file_path=$2

function check_video_downloaded {
    ## The video url has the format like 
    ##      https://www.youtube.com/watch?v=XYZT
    ## The locally saved file on the other hand
    ##      Coolest video ever -XYZT.mp4
    ## File extension might change in the future so we will stick
    ## in the video id, therefore parse the id first

    video_url=$1
    video_id=$(echo ${video_url} | sed 's#.*v=##')

    ## now check whether we have a file with the id or not
    ## find always return with exit code 0, therefore egrep is used
    if find "${video_download_target_path}" -name "*${video_id}.*" | egrep ".*" > /dev/null
    then
        echo 'found'
    fi
}

function asciify_video_names_after_download {
    ## Possibly the video files will be FTPed and some FTP servers
    ## still does not support non-Ascii files names, so better convert
    ## the file video names to their Ascii counterparts.

    find "${video_download_target_path}" -name '*.mp4' | while read video; do ascii=$(echo "${video}" | iconv -c -f UTF-8 -t ASCII) || true; mv "${video}" "${ascii}"; done
}

for video in $(cat ${video_list_file_path})
do
    if [[ $(check_video_downloaded ${video}) = 'found' ]]
    then
        echo "Video ${video} has already been downloaded"
        continue
    fi
    
    best_quality=$(youtube-dl -F ${video} 2> /dev/null | grep '(best)' | awk '{ print $1 }')
    echo "The best quality for the video ${video} was ${best_quality}"

    echo "Now downloading the video ${video}"
    youtube-dl -f ${best_quality} -o "${video_download_target_path}/%(title)s-%(id)s.%(ext)s" ''${video}''
    
    echo "Obtain the just downloaded video and Asciify its name"

    downloaded_video_name=$(youtube-dl --get-filename -o "${video_download_target_path}/%(title)s-%(id)s.%(ext)s" ''${video}'')
    echo "The downloaded is ${downloaded_video_name}"
done

asciify_video_names_after_download

