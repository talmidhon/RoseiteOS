"""Split an existing ISO into release assets and record their SHA256 digests."""
import hashlib
import json
import pathlib
import sys

source, destination, run_path = map(pathlib.Path, sys.argv[1:])
run = json.loads(run_path.read_text())
if run.get("conclusion") != "success":
    raise SystemExit("The source ISO workflow did not succeed")
destination.mkdir(parents=True, exist_ok=True)
whole = hashlib.sha256()
parts = []
with source.open("rb") as stream:
    index = 1
    while True:
        first = stream.read(1024 * 1024)
        if not first:
            break
        name = f"{source.name}.part{index:02d}"
        digest = hashlib.sha256()
        size = 0
        with (destination / name).open("wb") as output:
            block = first
            while block:
                output.write(block)
                digest.update(block)
                whole.update(block)
                size += len(block)
                if size == 1900 * 1024 * 1024:
                    break
                block = stream.read(min(1024 * 1024, 1900 * 1024 * 1024 - size))
        parts.append(dict(file=name, size=size, sha256=digest.hexdigest()))
        index += 1
manifest = dict(file=source.name, size=source.stat().st_size, sha256=whole.hexdigest(),
                source_commit=run["head_sha"], source_run=run["html_url"], parts=parts)
(destination / "iso-manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
(destination / "SHA256SUMS").write_text("".join(f'{p["sha256"]}  {p["file"]}\n' for p in parts)
                                      + f'{whole.hexdigest()}  {source.name}\n')
(destination / "README.md").write_text(f"""# RoseiteOS — גרסת בדיקה

מבוססת על Fedora 43 וכוללת את זית. טרם נבדקה באתחול במכונה וירטואלית; חסימה הרמטית טרם אומתה.

הורידו את כל קובצי `roseite-offline.iso.partNN`, את `iso-manifest.json` ואת `Join-RoseiteISO.ps1` לאותה תיקייה.
הפעילו את הסקריפט ב־PowerShell. הוא יבדוק את החלקים, יאחד אותם ל־`roseite-offline.iso` ויאמת את הקובץ המאוחד.
אפשר לאחד גם בלינוקס: `cat roseite-offline.iso.part* > roseite-offline.iso`, ואז לבדוק עם `sha256sum --ignore-missing -c SHA256SUMS`.
נדרש מקום פנוי גם לחלקים וגם לקובץ המאוחד.

ספריית הספרים של זית אינה כלולה ב־ISO. התקינו אותה בנפרד באפשרות אופליין מתוך זית.

Source commit: `{run['head_sha']}`
Source build: {run['html_url']}
ISO SHA256: `{whole.hexdigest()}`
""", encoding="utf-8")
