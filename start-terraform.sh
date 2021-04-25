#! /bin/bash
docker run --rm -it --name terraform \
      -v $(pwd):/tf \
      -v ~/.aws:/root/.aws \
      --entrypoint /bin/sh \
      hashicorp/terraform:0.14.7

