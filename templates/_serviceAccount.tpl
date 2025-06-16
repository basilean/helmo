{{/*
  Helmo (https://github.com/basilean/helmo)
  Andres Basile
  GNU/GPL v3
*/}}

{{/*
  Service Account - Base

  context = . (context)
  name = Name of the object.
  options = Options for the object.
*/}}

{{- define "serviceAccount.base" }}
kind: ServiceAccount
apiVersion: v1
metadata:
  name: {{ .name }}
  labels:
    {{- include "labels.all" . | indent 4 }}
  annotations:
    {{- include "annotations.all" . | indent 4 }}
{{- end }}
