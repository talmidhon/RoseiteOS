# RosieteOS

![logo](https://raw.githubusercontent.com/AshiVered/RoseiteOS/main/files/res/RoseiteOS_wallpaper.png)

RoseiteOS is a Linux distribution, based on Fedora SliverBlue 43.

RoseiteOS is only for Torah study:

Included in the image:

- OnlyOffice
- Gnome text editor
- Image viewer (eog)
- PDF viewer (evince)

Not installed:

- Zayit books — its installer is disabled in `recipes/recipe.yml`.
- Dopamine — its package entry is disabled in `recipes/recipe.yml`.

OnlyOffice restrictions:

- Presentation, settings, and cloud/external panels are hidden.
- The presentation editor is removed from the image.
- These restrictions are applied by `files/scripts/hermetic-lock.sh`.

"Kosher" features:

- Internet access is disabled.
- administration options are disabled (sudo, system is read-only, can't install any software)
- Without any terminal app

Easy & lightweight:

- Gnome DE for modern UI.
- OnlyOffice for MS Office style UI
- Removed many packages to keep system lightweight
- immutable OS, so also root can't modify system files


## Todo list:

- Pin OnlyOffice and Files to Dock
- Search for Gnome theme that looked as Windows (for non-techincal users)

## Customizing

As fedora SilverBlue, you can modify main file (recipes/recipe.yml). read Fedora Kinoite docs & template for more info:

https://github.com/blue-build/template


## Building

1. Push, and Github action run automatically build.yml that created docker image.
2. After step 1, go to action and run "Build-Offline-ISO"


## Todo list:


1. Replace backgorunds
2. Reanme all from Fedora to RoseiteOS
3. Create RoseiteOS wellcome app


## Donate me

https://ko-fi.com/ashivered
