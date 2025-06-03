{{/*

	Labels - All

*/}}
{{- define "labels.all" }}
app.kubernetes.io/name: {{ .Chart.Name | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
environment: {{ .Values.global.environment | quote }}
app.kubernetes.io/instance: {{ .Values.global.instance | quote }}
app.kubernetes.io/component: {{ .Values.component | quote }}
app.kubernetes.io/part-of: {{ .Values.global.project | quote }}
app.kubernetes.io/organization: {{ .Values.global.organization | quote }}
app.kubernetes.io/managed-by: "helm"
  {{- range $key, $val := .Values.global.labels }}
{{ $key }}: {{ $val | quote }}
  {{- end }}
  {{- range $key, $val := .Values.labels }}
{{ $key }}: {{ $val | quote }}
  {{- end }}
{{- end }}


{{/*

  Container - Limits

*/}}
{{- define "container.limits" }}
{{- if .cpu }}
cpu: {{ .cpu }}
{{- end }}
{{- if .memory }}
memory: {{ .memory }}
{{- end }}
{{- end }}

{{/*

  Container - Resources

*/}}
{{- define "container.resources" }}
{{- if (or .request .limits) -}}
resources:
  {{- if .request }}
  request:
    {{- include "container.limits" .request | indent 4 }}
  {{- end }}
  {{- if .limits }}
  limits:
    {{- include "container.limits" .limits | indent 4 }}
  {{- end }}
{{- end }}
{{- end }}


{{/*
	Keys - Val
*/}}
{{- define "keys.quote" }}
  {{- range $key, $val := . }}
{{ $key }}: {{ $val | quote }}
  {{- end }}
{{- end }}

{{/*
	Keys - B64
*/}}
{{- define "keys.b64" }}
  {{- range $key, $val := . }}
{{ $key }}: {{ $val | b64enc }}
  {{- end }}
{{- end }}







{{/*
Expand the name of the chart.
*/}}
{{- define "lgtm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "lgtm.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}




{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "lgtm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}





{{/*
Common labels
*/}}
{{- define "lgtm.labels" -}}
helm.sh/chart: {{ include "lgtm.chart" . }}
{{ include "lgtm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "lgtm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "lgtm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "lgtm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "lgtm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
