import glob
import os
import requests
import sys

video_download_path = sys.argv[1]
http_server_addr = sys.argv[2]

os.chdir(video_download_path)
for file_name in glob.glob("*.mp4"):
  print("The filename is {}".format(file_name))
  file_path = os.path.join(video_download_path, file_name)
  file = {'file': open(file_path, 'rb'), 'name': 'button'}
  r = requests.post(http_server_addr, files=file)
  print(r.status_code)
