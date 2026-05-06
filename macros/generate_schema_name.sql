{# Override the default schema-naming so `+schema: raw` produces `raw`
   instead of `<target>_raw`. Cleaner schema names + matches the sources.yml
   declarations one-to-one. Inspired by the dbt-labs jaffle_shop reference project. #}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is none -%}
        {{ target.schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
