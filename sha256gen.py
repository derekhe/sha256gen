#!/usr/bin/env python
import datetime
import hashlib
import os

import sys
import traceback

hashToSearch = raw_input("Please input the hash to search:")

dirPath = os.path.join(os.path.dirname(os.path.realpath(__file__)), "db")
statusFilePath = os.path.join(dirPath, "status.txt")
try:
    with open(statusFilePath) as status:
        last = status.readlines()[0]
except:
    exc_info = sys.exc_info()
    traceback.print_exception(*exc_info)
    print("Error when opening the last line, please check")
    exit()

print("Start with:", last)
start = datetime.datetime.now()

context = []

num_lines = 0
while True:
    last = hashlib.sha256(last.encode("utf-8")).hexdigest()
    context.append(last)

    num_lines += 1

    if num_lines % 500000 == 0:
        timespend = datetime.datetime.now() - start
        print("Total: " + str(num_lines) + " Speed: " + str(num_lines / timespend.total_seconds()) + "/seconds")
        print("Save status: " + last)

        context = context[-1000: len(context)]

        with open(statusFilePath, "w") as status:
            status.write(last)

    if hashToSearch in last:
        print("Found")
        foundFilePath = os.path.join(dirPath, "found.txt")

        context = context[-1000: len(context)]

        with open(foundFilePath, "w") as found:
            found.writelines('\n'.join(str(x) for x in context))
        exit()
