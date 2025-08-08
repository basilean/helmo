{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{/*
  Pod - Base

  context = "." Root context.
  name = Unique name.
  options = Options for the object.

NOTES:
* Need selector label in metadata.
* restartPolicy: Always in Deployments/StatefulSets; OnFailure/Never for Jobs
* affinity: rules for pod scheduling (anti-affinity)
* tolerations: run on tainted nodes
* serviceAccountName: my-sa (RBAC)
* securityContext: security settings

*/}}
{{- define "pod.base" }}
{{- $d := .context.Values.global.options }}
{{- $o := .options }}
metadata:
  labels:
    app.kubernetes.io/template: {{ .name }}
{{- include "labels.all" . | indent 4 }}
  annotations:
{{- include "annotations.all" . | indent 4 }}
spec:
  {{- if .options.serviceAccountName }}
  serviceAccountName: {{ .options.serviceAccountName }}
  {{- end }}
  securityContext:
    runAsNonRoot: true
    seccompProfile:
      type: RuntimeDefault
  {{- if .options.restartPolicy }}
  restartPolicy: {{ .options.restartPolicy }}
  {{- end }}
  dnsPolicy: ClusterFirst
  {{- if .options.initContainers }}
  initContainers:
    {{- range $name, $options := .options.initContainers }}
{{ include "container.base" (dict "context" $.context "name" $name "options" $options) | indent 4 }}
    {{- end }}
  {{- end }}
  {{- if .options.containers }}
  containers:
    {{- range $name, $options := .options.containers }}
{{ include "container.base" (dict "context" $.context "name" $name "options" $options) | indent 4 }}
    {{- end }}
  {{- end }}
  {{- if .options.volumes }}
  volumes:
    {{- range $name, $options := .options.volumes }}
{{ include "volume.auto" (dict "context" $.context "name" $name "options" $options) | indent 4 }}
    {{- end }}
  {{- end }}
{{- end }}
