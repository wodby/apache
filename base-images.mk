# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := httpd
BASE_IMAGE_VERSION_SUFFIX := -alpine

BASE_IMAGE_DIGEST_2.4.69-alpine := sha256:698a0f59374eeb59c2c3ae6385c5f346edd2c70c2b63f7b552fb3d64dbc3cf66

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
