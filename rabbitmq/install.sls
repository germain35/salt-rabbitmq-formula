{%- from "rabbitmq/map.jinja" import rabbitmq with context %}

include:
  - rabbitmq.repo

rabbitmq_packages:
  pkg.installed:
    - pkgs: {{ rabbitmq.pkgs }}
    - require:
      {%- if rabbitmq.manage_repo %}
      - sls: rabbitmq.repo
      {%- endif %}
