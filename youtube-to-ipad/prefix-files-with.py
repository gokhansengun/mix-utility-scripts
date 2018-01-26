import glob
import os
import sys

folder_path = sys.argv[1]
glob_pattern = sys.argv[2]
prefix = sys.argv[3]

os.chdir(folder_path)
for file_name in glob.glob(glob_pattern):
  new_file_name = prefix + file_name
  old_file_path = os.path.join(folder_path, file_name)
  new_file_path = os.path.join(folder_path, new_file_name)

  print("Renaming file {} to {}".format(file_name, new_file_name))

  os.rename(old_file_path, new_file_path)