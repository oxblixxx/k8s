Ensure output directories are in place and are empty.

**Role Variables**

.. zuul:rolevar:: zuul_output_dir
   :default: {{ ansible_user_dir }}/zuul-output

   Base directory for collecting job output.
