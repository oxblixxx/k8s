Remove the per-build SSH key from all hosts

The complement to :zuul:role:`add-build-sshkey`.  It removes the
build's SSH key from the authorized_keys files of all remote hosts.

**Role Variables**

.. zuul:rolevar:: zuul_temp_ssh_key

   Where the per-build SSH private key was stored.

.. zuul:rolevar:: zuul_ssh_key_algorithm
   :default: rsa

   The digital signature algorithm which was used to generate the key.
