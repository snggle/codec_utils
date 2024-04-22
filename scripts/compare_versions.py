#!/usr/bin/python3 -u
import sys
from distutils.version import StrictVersion

MASTER_BRANCH_VERSION=sys.argv[1]
WORKING_BRANCH_VERSION=sys.argv[2]

RESULT=StrictVersion(WORKING_BRANCH_VERSION) > StrictVersion(MASTER_BRANCH_VERSION)
print(RESULT)