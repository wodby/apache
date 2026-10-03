# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := httpd
BASE_IMAGE_VERSION_SUFFIX := -alpine

BASE_IMAGE_DIGEST_2.4.69-alpine := sha256:9486962e64d4b771335e88a3e49edc7254d05df2c6916e2980688ec9c6680ede

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
