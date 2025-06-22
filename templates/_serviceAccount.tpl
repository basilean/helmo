{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{/*
  Service Account - Base

  context = . (context)
  options = Options for the object.
*/}}

{{- define "serviceAccount.base" }}
kind: ServiceAccount
apiVersion: v1
metadata:
  name: {{ .options.name }}
  labels:
    {{- include "labels.all" . | indent 4 }}
  annotations:
    {{- include "annotations.all" . | indent 4 }}
{{- end }}
