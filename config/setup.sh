#!/usr/bin/env bash

# Exit on failure
set -e

# Check required commands are in env path
check_command () {    
    if ! command -v "$1" &> /dev/null; then
        echo "Cannot find $1 in env path"
    fi
}

# Check status of minikube
if ! minikube status &> /dev/null; then
    echo "[ERROR] minikube is not started. Start minikube and rerun script."
    exit 1
else
    echo "[INFO] minikube is started."
fi

# Ensure context is set to use minikube
if kubectl config get-contexts | awk '{print $2}' | grep -e "^minikube$"; then
    kubectl config use-context minikube
else
    echo "[ERROR] Cannot find context for minikube. Ensure a context named minikube exists."
    exit 1
fi

# Check kubectl can communicate with minikube API
if ! kubectl cluster-info &> /dev/null; then
    echo "[ERROR] kubectl cannot communicate with kube-apiserver."
    exit 1
fi

# Check that vagrant is ready
if vagrant validate; then
    vagrant up
else
    exit 1
fi


# Install hello-lb-test on minikube
