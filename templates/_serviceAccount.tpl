{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{/*
  Service Account - Base

  context = "." Root context.
  name = Unique name.
  options = Options for the object.
*/}}
{{- define "serviceAccount.base" }}
kind: ServiceAccount
apiVersion: v1
{{- include "metadata.all" . }}
{{- end }}
