#!/bin/bash
# Copyright 2018, Oracle and/or its affliates. All rights reserved. 

# check that all of the required parameters were provided
# note that wercker does not enforce this for us, so we have to check
if [[ -z "$WERCKER_SPOTBUGS_STEP_FORMAT" || -z "$WERCKER_SPOTBUGS_STEP_OUTPUT" || -z "$WERCKER_SPOTBUGS_STEP_CLASSPATH" ]]; then
  fail "$(date +%H:%M:%S): All required parameters: format, output and target MUST be specified"
fi

# try to find Java
if [ -z "$JAVA_HOME" ] ; then
  JAVACMD=`which java`
else
  JAVACMD="$JAVA_HOME/bin/java"
fi

# find the real location of java - in case it is a symlink
if [ -z "$JAVA_HOME" ] ; then
  # resolve links - $JAVACMD may be a link
  PRG="$JAVACMD"

  # need this for relative symlinks
  while [ -h "$PRG" ] ; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then
      PRG="$link" else
      PRG="`dirname "$PRG"`/$link"
    fi
  done

  saveddir=`pwd`

  JAVA_HOME=`dirname "$PRG"`/..

  # make it fully qualified
  JAVA_HOME=`cd "$JAVA_HOME" && pwd`

  cd "$saveddir"
fi

if [[ -z "$JAVA_HOME" ]]; then
  fail "$(date +%H:%M:%S): Could not find Java in this box - please make sure you have Oracle JDK installed"
fi
echo "$(date +%H:%M:%S): Found JAVA_HOME at $JAVA_HOME"

# install gzip
yes | yum install gzip

# install tar
yes | yum install tar

# install curl
yes | yum install curl

# check that tar is installed
hash tar 2>/dev/null || { echo "$(date +%H:%M:%S):  tar is required, install tar before this step"; exit 1; }

# check that gzip is installed
hash gzip 2>/dev/null || { echo "$(date +%H:%M:%S):  gzip is required, install gzip before this step"; exit 1; }

# check that curl is installed
hash curl 2>/dev/null || { echo "$(date +%H:%M:%S):  curl is required to install maven, install curl before this step."; exit 1; }

# install SpotBugs 
# download the latest spotbugs release 
SPOTBUGS_VERSION=3.1.1 
curl -O http://repo.maven.apache.org/maven2/com/github/spotbugs/spotbugs/${SPOTBUGS_VERSION}/spotbugs-${SPOTBUGS_VERSION}.tgz
tar xvf spotbugs-${SPOTBUGS_VERSION}.tgz 
mv spotbugs-${SPOTBUGS_VERSION} /spotbugs 
rm spotbugs-${SPOTBUGS_VERSION}.tgz 
export PATH=$PATH:/spotbugs/bin

#
# Get ready to start the SpotBugs
#

if [[ -z "$WERCKER_SPOTBUGS_STEP_FORMAT" ]]; then
  FORMAT=""
else
  FORMAT="$WERCKER_SPOTBUGS_STEP_FORMAT"
fi

if [[ -z "$WERCKER_SPOTBUGS_STEP_OUTPUT" ]]; then
  OUTPUT=""
else
  OUTPUT="-output $WERCKER_SPOTBUGS_STEP_OUTPUT"
fi

if [[ -z "$WERCKER_SPOTBUGS_STEP_CLASSPATH" ]]; then
  CLASSPATH="."
else
  CLASSPATH="$WERCKER_SPOTBUGS_STEP_CLASSPATH"
fi

#
# run the SpotBugs command
#
spotbugs -textui $FORMAT $OUTPUT $CLASSPATH
