Ingress:
  metadata:
    name: {{ .Release.Name }}
    annotations:
      gd/what: proxy to {{ .Release.Name }}
      gd/owner: malex
      nginx.ingress.kubernetes.io/rewrite-target: /$1
  spec:
    ingressClassName: nginx
    rules:
    - http:
        paths:
        - path: /sentry/(.*)
          pathType: Prefix
          backend:
            service:
              name: sentry-relay
              port:
                number: 3000
        - path: /sentry-web/(.*)
          pathType: Prefix
          backend:
            service:
              name: sentry-web
              port:
                number: 9000
