# Drupal 8 example setup, with docker.

## Works well with the makeup-example in reload/proref.

## Things you need to tweak manually:
- Theme name (search for THEME_NAME)
- The following settings in web/sites/default/:
- - $settings['hash_salt'] (You can generate a salt with \Drupal\Component\Utility\Crypt::randomBytesBase64(55))
- - $config['stage_file_proxy.settings']['origin']


## Using NFS with Docker for Mac
- `$ cp docker-compose.mac-nfs.yml docker-compose.override.yml`

MacOS Catalina has moved the /Users/NAME folder. This can cause some issues when using `PWD` in the override file.
If you use .zshrc or something similar, you could add the following to your ~/.zshrc / ~/.bashrc file:

```
if [[ ${PWD} == ${HOME}* ]]; then
  export HOME=/System/Volumes/Data/Users/`whoami`
  cd /System/Volumes/Data/${PWD}
fi
```
  
## Theming
This example comes with a NPM docker container, gulp/npm files and an empty,
custom Drupal 8 theme base.
