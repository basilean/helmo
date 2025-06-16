{{/*
  Helmo (https://github.com/basilean/helmo)
  Andres Basile
  GNU/GPL v3
*/}}

{{/*
  RoleBinding - Base

  context = . (context)
  name = Name of the object.
  options = Options for the object.
*/}}

{{- define "roleBinding.base" }}
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: {{ .name }}
  labels:
    {{- include "labels.all" . | indent 4 }}
  annotations:
    {{- include "annotations.all" . | indent 4 }}
subjects:
  {{- range $subject := .options.subjects }}
  - kind: {{ $subject.kind }}
    name: {{ $subject.name }}
    namespace: {{ $.context.Release.Namespace }}
  {{- end }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: {{ .options.role }}
{{- end }}
