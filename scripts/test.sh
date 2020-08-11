#!/bin/bash

cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
chown vagrant:vagrant -R ~/.kube/

cd /challenge/test

export GOROOT=/usr/local/go-1.14
export PATH=$GOROOT/bin:$PATH

go mod init github.com/steled/challenge01

go test -v kubernetes_example_app_test.go