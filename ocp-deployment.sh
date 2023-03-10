#!/bin.bash
oc new-project povchat-ns
cat <EOF | oc apply -f -
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongodb-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
        - name: mongodb
          image: jeanchlopez/povchat-mongodb
          ports:
            - containerPort: 27017
          env:
            - name: MONGO_INITDB_ROOT_USERNAME
              value: mongoadmin
            - name: MONGO_INITDB_ROOT_PASSWORD
              value: secret
EOF
cat <EOF | oc apply -f -
---
apiVersion: v1
kind: Service
metadata:
  name: mongodb-service
spec:
  selector:
    app: mongodb
  ports:
    - name: mongodb
      port: 27017
      targetPort: 27017
  type: ClusterIP
EOF

cat <EOF | oc apply -f -
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: mongodb-app
spec:
  destination:
    namespace: povchatdb-app
    server: https://kubernetes.default.svc
  project: povchat
  source:
    repoURL: https://github.com/jeanchlopez/povchatdb.git
    targetRevision: HEAD
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
EOF

