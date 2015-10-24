# Timelord

Timelord is a set of predominantly [Ansible](http://www.ansible.com)-based scripts for regenerating a BBC developer workstation running OS X.

The `regenerate` bash script installs a foundation consisting of:

* [Command Line Tools](https://developer.apple.com/xcode/features/)
* [Homebrew](http://brew.sh)

and Ansible dependencies:

* [Python](https://www.python.org)
* [pip](https://www.pypa.io)
* [Jinja2](http://jinja.pocoo.org)
* [PyYAML](http://pyyaml.org)

and then leverages Ansible to provision the workstation
