{{/*
Expand the name of the chart.
*/}}
{{- define "zHelper.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "zHelper.fullname" -}}
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
{{- define "zHelper.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "zHelper.labels" -}}
helm.sh/chart: {{ include "zHelper.chart" . }}
{{ include "zHelper.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "zHelper.selectorLabels" -}}
app: {{ include "zHelper.name" . }}
app.kubernetes.io/name: {{ include "zHelper.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "zHelper.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "zHelper.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "zHelper.volumes" -}}
{{- if .Values.volumes }}
{{- range .Values.volumes }}
- name: {{(print .name)}}
  {{- if .claim }}
  persistentVolumeClaim:
    claimName: {{(print .claim)}}
  {{- end }}
  {{- if .secret }}
  secret:
    secretName: {{(print .secret)}}
  {{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- define "zHelper.volumeMounts" -}}
{{- if .Values.volumeMounts }}
{{- range .Values.volumeMounts }}
- name: {{(print .name)}}
  mountPath: {{(print .path)}}
{{- end }}
{{- end }}
{{- end }}