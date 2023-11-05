#!/bin/bash
# Usage: ansible-template.sh -e '{var: value}' < template.j2
set -euo pipefail

playbook=$(cat <<EOD
---
- name: Test
  hosts:
    - localhost
  connection: local
  become: false
  gather_facts: false
  force_handlers: true

  tasks:
    - name: Instantiate template content to {{ tmpfile }}
      ansible.builtin.copy:
        content: "{{ lookup('template', lookup('env', 'TEMPLATE_FILE') ) }}"
        dest: "{{ tmpfile }}"
EOD
)

tmpfile=$(mktemp)
cleanup() {
    rm -f -- "$tmpfile"
}
trap cleanup QUIT TERM INT HUP EXIT
chmod og-rwx "$tmpfile"
ls -l "$tmpfile"

export ANSIBLE_STDOUT_CALLBACK=minimal
TEMPLATE_FILE=<(cat) ansible-playbook -e "tmpfile=$tmpfile" "$@" <(printf "%s" "$playbook")

cat -- "$tmpfile"
