{#
What it does
This macro dynamically generates the target database name based on the deployment environment (target). 
This is a critical macro for isolating development, QA, and production environments.

How it works
It prefixes the database name specified in a model configuration with an environment-specific prefix.
- dev target: Prepends `DEV_` (e.g., `STAGING` becomes `DEV_STAGING`).
- qa target: Prepends `QA_` (e.g., `STAGING` becomes `QA_STAGING`).
- prod target: Prepends `PROD_` (e.g., `STAGING` becomes `PROD_STAGING`).
- Other targets: Uses the custom database name as-is.
- If no custom database is configured for a model, it falls back to the default database defined in `profiles.yml`.
#}

{% macro generate_database_name(custom_database_name, node) -%}
    {%- set default_database = target.database -%}
    
    {%- if custom_database_name is none -%} 
        {{ default_database }}
    {%- else -%}
        {%- set upper_custom_database_name = custom_database_name | upper -%}

        {%- if target.name == "dev" -%} 
            {%- set dev_database = "DEV_" + upper_custom_database_name -%}
            {{ dev_database }}
        {%- elif target.name[0:2].lower() == "qa" -%}
            {%- set qa_database = "QA_" + upper_custom_database_name -%}
            {{ qa_database }}
        {%- elif target.name.lower() == "prod" -%}
            {%- set prod_database = "PROD_" + upper_custom_database_name -%}
            {{ prod_database }}
        {%- else -%} 
            {{ upper_custom_database_name | trim }}
        {%- endif -%}

    {%- endif -%}

{%- endmacro %}
