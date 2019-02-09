#!/bin/sh

TRAVIS_URL="https://api.travis-ci.com/Flyy-y/util.svg?branch=master"
TRAVIS_RETURN=`curl -s $TRAVIS_URL | grep pass`

if [ -z "$TRAVIS_RETURN" ]; then exit 1;
else exit 0; fi