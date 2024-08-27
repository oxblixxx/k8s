This is one of a collection of roles which are designed to work
together to build, upload, and promote docker images in a gating
context:

* :zuul:role:`build-docker-image`: Build the images.
* :zuul:role:`upload-docker-image`: Upload the images to Dockeer Hub.
* :zuul:role:`promote-docker-image`: Promote previously uploaded images.

The :zuul:role:`build-docker-image` role is designed to be used in
`check` and `gate` pipelines and simply builds the images.  It can be
used to verify that the build functions, or it can be followed by the
use of subsequent roles to upload the images to Docker Hub.

The :zuul:role:`upload-docker-image` role uploads the images to Docker
Hub.  It can be used in one of two modes: by default it will upload
with a single tag corresponding to the change ID.  In this mode, the
role role is designed to be used in a job in a `gate` pipeline so that
the build produced by the gate is staged and can later be promoted to
production if the change is successful.  The other mode allows for use
of this job in a `release` pipeline to directly upload a release build
with the final set of tags.

The :zuul:role:`promote-docker-image` role is designed to be used in a
`promote` pipeline.  It requires no nodes and runs very quickly on the
Zuul executor.  It simply re-tags a previously uploaded image for a
change with whatever tags are supplied by
:zuul:rolevar:`build-docker-image.docker_images.tags`.  It also
removes the change ID tag from the repository in Docker Hub, and
removes any similar change ID tags more than 24 hours old.  This keeps
the repository tidy in the case that gated changes fail to merge after
uploading their staged images.

They all accept the same input data, principally a list of
dictionaries representing the images to build.  YAML anchors_ can be
used to supply the same data to all three jobs.

Use the :zuul:role:`ensure-docker` role to install Docker before
using this role.

**Role Variables**

.. zuul:rolevar:: zuul_work_dir
   :default: {{ zuul.project.src_dir }}

   The project directory.  Serves as the base for
   :zuul:rolevar:`build-docker-image.docker_images.context`.

.. zuul:rolevar:: docker_dockerfile
   :default: Dockerfile

   The default Dockerfile name to use. Serves as the base for
   :zuul:rolevar:`build-docker-image.docker_images.dockerfile`.
   This allows a global overriding of Dockerfile name, for example
   when building all images from different folders with similarily
   named dockerfiles.

.. zuul:rolevar:: docker_registry
   :default: ''

   The container registry the images should be tagged for, by default
   zuul will push the image to dockerhub.

.. zuul:rolevar:: docker_credentials
   :type: dict

   This is only required for the upload and promote roles.  This is
   expected to be a Zuul Secret with two keys:

   .. zuul:rolevar:: username

      The Docker Hub username.

   .. zuul:rolevar:: password

      The Docker Hub password.

   .. zuul:rolevar:: repository

      Optional; if supplied this is a regular expression which
      restricts to what repositories the image may be uploaded.  The
      following example allows projects to upload images to
      repositories within an organization based on their own names::

        repository: "^myorgname/{{ zuul.project.short_name }}.*"

.. zuul:rolevar:: docker_use_buildkit
   :type: bool
   :default: false

   Use `BuildKit
   <https://docs.docker.com/develop/develop-images/build_enhancements/>`__
   when creating images.

.. zuul:rolevar:: docker_images
   :type: list

   A list of images to build.  Each item in the list should have:

   .. zuul:rolevar:: context

      The docker build context; this should be a directory underneath
      :zuul:rolevar:`build-docker-image.zuul_work_dir`.

   .. zuul:rolevar:: dockerfile

      The filename of the dockerfile, present in the context folder,
      used for building the image. Provide this if you are using
      a non-standard filename for a specific image.

   .. zuul:rolevar:: repository

      The name of the target repository in dockerhub for the
      image.  Supply this even if the image is not going to be
      uploaded (it will be tagged with this in the local
      registry).

   .. zuul:rolevar:: path

      Optional: the directory that should be passed to docker build.
      Useful for building images with a Dockerfile in the context
      directory but a source repository elsewhere.

   .. zuul:rolevar:: build_args
      :type: list

      Optional: a list of values to pass to the docker ``--build-arg``
      parameter.

   .. zuul:rolevar:: target

      Optional: the target for a multi-stage build.

   .. zuul:rolevar:: tags
      :type: list
      :default: ['latest']

      A list of tags to be added to the image when promoted.

   .. zuul:rolevar:: siblings
      :type: list
      :default: []

      A list of sibling projects to be copied into
      ``{{zuul_work_dir}}/.zuul-siblings``.  This can be useful to
      collect multiple projects to be installed within the same Docker
      context.  A ``-build-arg`` called ``ZUUL_SIBLINGS`` will be
      added with each sibling project.  Note that projects here must
      be listed in ``required-projects``.

   .. zuul:rolevar:: labels
      :type: list
      :default: []

      A list of labels to attach to the built image, in the form of "key=value".

   .. zuul:rolevar:: arch
      :type: list
      :default: []

      A list of architectures to build on. When enabling this on any
      image, all of them will be built with ``docker buildx``.

      Valid values are ``linux/amd64``, ``linux/arm64``, ``linux/riscv64``,
      ``linux/ppc64le``, ``linux/s390x``, ``linux/386``,
      ``linux/arm/v7``, ``linux/arm/v6``.

.. _anchors: https://yaml.org/spec/1.2/spec.html#&%20anchor//
