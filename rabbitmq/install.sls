{%- from "rabbitmq/map.jinja" import rabbitmq with context %}

include:
  - rabbitmq.repo

rabbitmq_packages:
  pkg.installed:
    - pkgs: {{ rabbitmq.pkgs }}
    {%- if rabbitmq.manage_repo %}
    - require:
      - sls: rabbitmq.repo
    {%- endif %}
