{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{/*
  Job - Base

  context = "." Root context.
  name = Unique name.
  options = Options for the object.

  restartPolicy: OnFailure  # or Never
*/}}
{{- define "job.base" }}
{{- $d := .context.Values.global.options -}}
{{- $o := .options -}}
kind: Job
apiVersion: batch/v1
{{- include "metadata.all" . }}
spec:
  parallelism: 1
  completions: 1
  backoffLimit: 2
  completionMode: NonIndexed
  suspend: false
  template:
{{- include "pod.base" . | indent 4}}
{{- end }}
