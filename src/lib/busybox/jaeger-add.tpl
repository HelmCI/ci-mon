Service:
  metadata:
    name: {{ .Release.Name }}
  spec:
    ports:
    - name: http-query
      protocol: TCP
      port: 16686
      targetPort: 16686
      nodePort: 30686
    selector:
      app.kubernetes.io/component: all-in-one
      app.kubernetes.io/instance: jaeger
      app.kubernetes.io/name: jaeger
    type: NodePort
raw:
- kind: PersistentVolumeClaim
  apiVersion: v1
  metadata:
    name: {{ .Release.Name }}
  spec:
    accessModes:
      - ReadWriteOnce
    resources:
      requests:
        storage: 1Gi
