# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := httpd
BASE_IMAGE_VERSION_SUFFIX := -alpine

BASE_IMAGE_DIGEST_2.4.70-alpine := sha256:c465cf5b4c131dad59ea43de34036cab81e1c0517340c4f3159acbf91f0c68f0

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
