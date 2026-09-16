#!/usr/bin/env bash
set -euo pipefail

# Publish the scanned image IDs; rebuilding here would bypass the security gate.
if [[ "$GITHUB_REF" != refs/heads/master && "$GITHUB_REF" != refs/tags/* ]]; then
    exit 0
fi
IFS=',' read -ra tags <<< "$TAGS"
IFS=',' read -ra platforms <<< "$PLATFORM"
# Refuse incomplete scan output before pushing any architecture.
[[ ${#platforms[@]} -gt 0 && ${#tags[@]} -gt 0 ]]
for platform in "${platforms[@]}"; do
    case "$platform" in
        linux/amd64) test -n "${SCANNED_IMAGE_AMD64:-}" ;;
        linux/arm64) test -n "${SCANNED_IMAGE_ARM64:-}" ;;
        *) echo "Unsupported scan platform: $platform" >&2; exit 1 ;;
    esac
done
printf '%s' "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin
for tag in "${tags[@]}"; do
    if [[ "$GITHUB_REF" == refs/tags/* && "$tag" != latest ]]; then
        tag="$tag-${GITHUB_REF##*/}"
    fi
    images=()
    for platform in "${platforms[@]}"; do
        case "$platform" in
            linux/amd64) image="${SCANNED_IMAGE_AMD64:?Missing scanned amd64 image}"; arch=amd64 ;;
            linux/arm64) image="${SCANNED_IMAGE_ARM64:?Missing scanned arm64 image}"; arch=arm64 ;;
            *) echo "Unsupported scan platform: $platform" >&2; exit 1 ;;
        esac
        ref="wodby/apache:$tag-$arch"
        docker tag "$image" "$ref"
        docker push "$ref"
        images+=("$ref")
    done
    docker buildx imagetools create -t "wodby/apache:$tag" "${images[@]}"
done
