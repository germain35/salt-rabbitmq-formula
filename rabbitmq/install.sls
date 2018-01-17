{%- from "rabbitmq/map.jinja" import rabbitmq with context %}

include:
  - rabbitmq.repo

rabbitmq_tools_packages:
  pkg.installed:
    - pkgs: {{ rabbitmq.tools_pkgs }}

rabbitmq_packages:
  pkg.installed:
    - pkgs: {{ rabbitmq.pkgs }}
    - require:
      - pkg: rabbitmq_tools_packages
    {%- if rabbitmq.manage_repo %}
      - sls: rabbitmq.repo
    {%- endif %}
