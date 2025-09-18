{#
What it does
This macro overrides dbt default alias generation logic. By default, dbt uses the filename as the table/view name. 
This macro allows for a convention where filenames can be prefixed (e.g., `int__fact_sales`), 
and the prefix will be automatically stripped to generate a cleaner database object name (e.g., `fact_sales`).

How it works
1.  If the model filename contains a double underscore (`__`), it uses the part of the name after the first `__` as the alias.
2.  If the filename does not contain `__`, it uses the original filename.
3.  If a custom `alias` is specified in the config for this model, that custom alias takes precedence.

Example
- A model file named `int__fact_daily_sales.sql` will create a table named `FACT_DAILY_SALES`.
- A model file named `dim_artist.sql` will create a table named `DIM_ARTIST`.
#}

{% macro generate_alias_name(custom_alias_name=none, node=none) -%}

    {%- set original_name = node.name -%}
    
    {# Split on first double underscore and take the part after it if it exists #}
    {%- if '__' in original_name -%}
        {%- set alias = original_name.split('__', 1)[1] -%}
    {%- else -%}
        {%- set alias = original_name -%}
    {%- endif -%}

    {%- if custom_alias_name -%}
        {{ custom_alias_name | trim }}
    {%- else -%}
        {{ alias }}
    {%- endif -%}

{%- endmacro %}