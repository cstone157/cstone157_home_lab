{{/* Generate labels for the charts */}}
{{- define "labchart.labels" }}
  labels:
    generator: helm
    date: {{ now | htmlDate }}
    app: {{ coalesce .labels.app .name "unknown" }}
    version: {{ default "unknown" .version | quote }}
    {{- if .labels }}
    {{- range $key, $value := .labels }}
    {{ $key }}: {{ $value | toYaml | quote | trimSuffix "\n" | indent 2 }}
    {{- end }}
    {{- end }}
{{- end }}

{{/* Generate the metadata for the charts */}}
{{- define "labchart.metadata" }}
metadata:
  name: {{ .name }}
  namespace: {{ default "default" .namespace }}
  {{- include "labchart.labels" . }}
{{- end }}

