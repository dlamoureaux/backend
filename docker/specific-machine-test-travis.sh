#!/bin/bash

# https://docs.travis-ci.com/user/customizing-the-build#Implementing-Complex-Build-Steps
set -ev

if [[ "X$1" = "X" ]]
then
	echo missing machine name
	echo $0 \<DB name\>
	# exit 1
else
    MACHINE=$1
fi

if [[ "X$2" = "XR" ]]
then
    # R is flag for rebuild, so force a cache bust
    CACHEBUST=$(date +%s)
else
    # 1 matches the arg in the dockerfile, this will not bust the cache
    CACHEBUST=1
	echo CACHEBUST $CACHEBUST
fi

if [[ "X$3" = "X" ]]; then
    REPO=jkbits1/backend
    echo REPO $REPO
else 
    REPO=$3
fi

if [[ "X$4" = "X" ]]
then
    BRANCH=ts-route
	echo BRANCH $BRANCH
else
    BRANCH=$4
fi

# handle travis params
if [[ "X$5" = "X" ]]
then
    EVENT=push
	echo EVENT $EVENT
else
    EVENT=$5
fi

if [[ "X$6" = "X" ]]
then
	echo PR_SLUG $PR_SLUG
else
    PR_SLUG=$6
fi

if [[ "X$7" = "X" ]]
then
	echo PR_BRANCH $PR_BRANCH
else
    PR_BRANCH=$7
fi

echo MACHINE $MACHINE
echo CACHEBUST $CACHEBUST
echo REPO $REPO
echo BRANCH $BRANCH

echo REPO_SLUG $REPO_SLUG
echo PR_SLUG $PR_SLUG
echo EVENT $EVENT

if [[ "X$PR_SLUG" = "X"]]
    # push event
    echo PUSH $REPO
then
    # pr event
    $REPO=$PR_SLUG

    echo PR $REPO
fi

if [[ "X$PR_BRANCH" = "X"]]
    # push event
    echo PUSH $BRANCH
then
    # pr event
    $BRANCH=$PR_BRANCH

    echo PR $BRANCH
fi

pwd
ls

docker-compose -f docker/compose/full-stack-test/docker-compose-test.yml build --build-arg REPO=https://github.com/$REPO --build-arg BRANCH_NAME=$BRANCH --build-arg CACHEBUST=$CACHEBUST $MACHINE

