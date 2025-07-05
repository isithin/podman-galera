Galera-Role for Container-Cluster-Setup
=========

This role sets up a containerised Galera-Cluster using Podman and a OVS GENEVE Overlay-Network for each instance. 


Role Variables
--------------

The needed variables are in the defaults directory of this role and the Podman-Role. 

Dependencies
------------

It needs the fitting Podman-Role to work (https://github.com/isithin/podman/)

Example Playbook
----------------


    - hosts: galera.podman
      remote_user: root
      gather_facts: yes

      roles:
         - podman-galera

