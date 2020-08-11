#!/bin/bash

cd /challenge/test

export GOROOT=/usr/local/go-1.14
export PATH=$GOROOT/bin:$PATH

sudo go mod init github.com/steled/challenge01

sudo go test -v kubernetes_example_app_test.go