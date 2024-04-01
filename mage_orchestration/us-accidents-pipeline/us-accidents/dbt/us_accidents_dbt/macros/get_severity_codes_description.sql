{#
    This macro returns the description of the payment_type 
#}

{% macro get_severity_codes_description(payment_type) -%}

    case {{ dbt.safe_cast("Severity", api.Column.translate_type("integer")) }}  
        when 1 then 'Short delay / Least impact on traffic'
        when 2 then 'Medium delay / Medium impact on traffic'
        when 3 then 'Long delay / Heavy impact on traffic'
        when 4 then 'Very long delay / Significant impact on traffic'
        else 'Data not available'
    end

{%- endmacro %}