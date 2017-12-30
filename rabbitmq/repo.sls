{%- from "rabbitmq/map.jinja" import rabbitmq with context %}

{%- set osfamily   = salt['grains.get']('os_family') %}
{%- set os         = salt['grains.get']('os') %}
{%- set osrelease  = salt['grains.get']('osrelease') %}
{%- set oscodename = salt['grains.get']('oscodename') %}

{%- if rabbitmq.manage_repo %}
  {%- if osfamily == 'Debian' %}
rabbitmq_repo_pkgs:
  pkg.installed:
    - pkgs: 
      - apt-transport-https
      - debian-archive-keyring
      - gnupg
    - require_in:
      - pkgrepo: rabbitmq_repo
  {%- endif %}
  
  {%- if rabbitmq.erlang_repo is defined and rabbitmq.erlang_repo is mapping %}
rabbitmq_erlang_repo:
  pkgrepo.managed:
    {%- for k, v in rabbitmq.erlang_repo.iteritems() %}
    - {{k}}: {{v}}
    {%- endfor %}
    - require_in:
      - pkgrepo: rabbitmq_repo
  {%- endif %}

  {%- if rabbitmq.repo and rabbitmq.repo is mapping %}
rabbitmq_repo:
  pkgrepo.managed:
    {%- for k, v in rabbitmq.repo.iteritems() %}
    - {{k}}: {{v}}
    {%- endfor %}
  {%- endif %}
{%- endif %}
