{%- from "rabbitmq/map.jinja" import rabbitmq with context %}

include:
  - rabbitmq.repo
  - rabbitmq.install
  - rabbitmq.plugins
  - rabbitmq.vhosts
  - rabbitmq.users
  - rabbitmq.config
  - rabbitmq.service
  - rabbitmq.admin