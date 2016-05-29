#!/usr/bin/env python
import datetime
import glob
import hashlib
import os
import re
import sys
import traceback


def tryint(s):
    try:
        return int(s)
    except:
        return s


def alphanum_key(s):
    return [tryint(c) for c in re.split('([0-9]+)', s)]


try:
    dirPath = os.path.join(os.path.dirname(os.path.realpath(__file__)), "db")
    print(dirPath)
    files = glob.glob(os.path.join(dirPath, '*'))
    files.sort(key=alphanum_key)
    lastFileName = os.path.basename(files[-1])
    lastFileIndex = int(lastFileName[0:-4])

    filePath = os.path.join(dirPath, lastFileName)
    lastFileSize = os.path.getsize(filePath)
    print("Open last file", filePath)

    with open(filePath, 'rb') as fh:
        seekPos = lastFileSize - 66
        if seekPos < 0:
            seekPos = 0
        fh.seek(seekPos)
        last = fh.readlines()[-1].decode().strip()
except:
    exc_info = sys.exc_info()
    traceback.print_exception(*exc_info)
    print("Error when opening the last line, please check")
    exit()

num_lines = sum(1 for line in open(filePath))
print("Start with:", last)
print("Num of lines already generated", num_lines)

start = datetime.datetime.now()


def openFile():
    return open(os.path.join(dirPath, str(lastFileIndex) + ".txt"), "a")


fileOpened = openFile()
while True:
    last = hashlib.sha256(last.encode("utf-8")).hexdigest()
    num_lines += 1
    fileOpened.write("\n" + last)

    if num_lines % 500000 == 0:
        timespend = datetime.datetime.now() - start
        print("Total: " + str(num_lines), "Speed: " + str(num_lines / timespend.total_seconds()) + "/seconds")

    if num_lines % 3000000 == 0:
        lastFileIndex += 1
        print("Generate next file:" + str(lastFileIndex))
        fileOpened.flush()
        fileOpened.close()
        fileOpened = openFile()
