#!/usr/bin/env python3
"""Exercise release aliases and scanned-artifact publication without registry access."""
import json
import os
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
IMAGE = "wodby/apache"
MULTIARCH = True
BASE = "master"
ALIASES = ['2.4', '2', 'latest']


def check(ref, platforms="linux/amd64,linux/arm64", missing=False, fail_push=False):
    """Run the real release script with a recording Docker executable."""
    with tempfile.TemporaryDirectory() as directory:
        directory = Path(directory)
        log = directory / "commands.jsonl"
        docker = directory / "docker"
        docker.write_text(r"""#!/usr/bin/env python3
import json, os, sys
args = sys.argv[1:]
with open(os.environ["COMMAND_LOG"], "a") as output:
    output.write(json.dumps(args) + "\n")
if args[0] == "login":
    sys.stdin.read()
elif args[0] == "push" and os.environ.get("FAIL_PUSH") == "1":
    sys.exit(1)
elif args[0] not in ["tag", "push"] and args[:3] != ["buildx", "imagetools", "create"]:
    sys.exit("Unexpected Docker command: " + repr(args))
""")
        docker.chmod(0o755)
        env = {key: value for key, value in os.environ.items()
               if key not in ["IMAGE_REVISION", "STABILITY_TAG", "TAG", "ARCH", "MAKEFLAGS", "MFLAGS", "REPO"]}
        env.update(PATH=str(directory) + os.pathsep + env["PATH"],
                   COMMAND_LOG=str(log), GITHUB_REF=ref, TAGS=",".join(ALIASES),
                   DOCKER_USERNAME="test", DOCKER_PASSWORD="test",
                   PLATFORM=platforms, SCANNED_IMAGE="sha256:scanned",
                   SCANNED_IMAGE_AMD64="sha256:scanned-amd64",
                   SCANNED_IMAGE_ARM64="sha256:scanned-arm64",
                   FAIL_PUSH="1" if fail_push else "0")
        if missing:
            env.pop("SCANNED_IMAGE_ARM64" if MULTIARCH else "SCANNED_IMAGE")
        result = subprocess.run(["bash", ".github/actions/release.sh"], cwd=ROOT,
                                env=env, text=True, capture_output=True)
        commands = [json.loads(line) for line in log.read_text().splitlines()] if log.exists() else []
        if ref != "refs/heads/" + BASE and not ref.startswith("refs/tags/"):
            assert result.returncode == 0 and not commands, (result, commands)
            return
        if missing or fail_push:
            assert result.returncode != 0, result
            assert not any(command[:3] == ["buildx", "imagetools", "create"] for command in commands), commands
            if missing:
                assert not any(command[0] in ["tag", "push"] for command in commands), commands
            return
        assert result.returncode == 0, result.stderr
        commands = [command for command in commands if command[0] != "login"]
        revision = ref.rsplit("/", 1)[-1]
        tags = [revision] if IMAGE.endswith("edge-alpine") and ref.startswith("refs/tags/") else ALIASES
        expected = []
        for tag in tags:
            if not IMAGE.endswith("edge-alpine") and ref.startswith("refs/tags/") and tag != "latest":
                tag += "-" + revision
            target = IMAGE + ":" + tag
            if MULTIARCH:
                refs = []
                for platform in platforms.split(","):
                    arch = platform.split("/")[1]
                    child = target + "-" + arch
                    expected += [["tag", "sha256:scanned-" + arch, child], ["push", child]]
                    refs.append(child)
                expected.append(["buildx", "imagetools", "create", "-t", target] + refs)
            else:
                expected += [["tag", "sha256:scanned", target], ["push", target]]
        assert commands == expected, (commands, expected)


check("refs/heads/" + BASE)
check("refs/tags/9.8.7")
check("refs/tags/r23")
check("refs/pull/123/merge")
check("refs/heads/feature/test")
check("refs/heads/" + BASE, missing=True)
check("refs/heads/" + BASE, fail_push=True)
if MULTIARCH:
    check("refs/heads/" + BASE, platforms="linux/amd64")
    check("refs/tags/9.8.7", platforms="linux/arm64")
    check("refs/tags/r23", platforms="linux/arm64")
print("Release checks passed for " + IMAGE)
