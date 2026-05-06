{# Convert an integer cent amount into a euro amount with 2-decimal rounding. #}
{% macro cents_to_euros(column_name) %}
    round(({{ column_name }})::double / 100.0, 2)
{% endmacro %}
