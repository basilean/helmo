{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{/*
        Service - NodePort
*/}}
{{- define "service.nodePort" }}
kind: Service
apiVersion: v1
metadata:
  name: {{ .Chart.Name }}
  labels:
    {{- include "labels.all" . | indent 4 }}
  annotations:
    service.alpha.openshift.io/serving-cert-secret-name: {{ .Chart.Name }}-tls
spec:
  ports:
    {{- toYaml .Values.nodePort | nindent 4 }}
  type: NodePort
  selector:
    app.kubernetes.io/name: {{ .Chart.Name }}
{{- end }}