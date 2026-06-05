#!/usr/bin/env python3

import tomllib
import zipfile

from defs import *
from language import Language
from source import Source


if __name__ == "__main__":
    with open(CONFIG_FILE, "rb") as f:
        config = tomllib.load(f)

    # Intentionally empty, meant to be filled in with a substitution
    lang = Language()

    lang.source = Source(lang.name, BUILD_DIR / lang.name)

    lang.find_queries()

    with zipfile.ZipFile(
        SRCPKG_DIR / f"{NAME_PREFIX}{lang.name}.zip",
        "w",
        compression=zipfile.ZIP_DEFLATED,
    ) as ar:
        lang.package_source(ar)

