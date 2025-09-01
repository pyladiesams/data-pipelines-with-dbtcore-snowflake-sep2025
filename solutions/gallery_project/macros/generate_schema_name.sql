{#
What it does
This macro customizes schema names to support a multi-developer workflow and enforce environment separation. 
Its primary function is to create unique, user-specific schemas in the development environment.

How it works
- dev target: Appends the developer username to the custom schema name. For example, a model configured with `schema: intermediate` run by user `jane.doe@company.com` will be built in the schema `INTERMEDIATE_JANEDOE`. This prevents developers from overwriting objects created by other developers.
- qa & prod targets: Uses the custom schema name directly without any user suffix, creating a clean, shared schema for production and testing builds.
- If no custom schema is configured, it falls back to the default schema in `profiles.yml`.

#}

{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    
    {%- if custom_schema_name is none -%} 
        {{ default_schema }}
    {%- else -%}

        {%- set upper_custom_schema_name = custom_schema_name | upper -%}

        {%- if target.name == "dev" -%} 
            {%- set user = target.user | string -%}
            {%- if '@' in target.user | string -%}
                {%- set normalized_user = (target.user | string).split('@')[0].replace('.', '') | upper -%}
            {%- else -%}
                {%- set normalized_user = target.user | string | upper -%}
            {%- endif -%}
            {{ upper_custom_schema_name }}_{{ normalized_user }}
        {%- elif target.name[0:2].lower() == "qa" -%}
            {{ upper_custom_schema_name }}
        {%- else -%} 
            {{ upper_custom_schema_name | trim }}
        {%- endif -%}

    {%- endif -%}
{%- endmacro %}