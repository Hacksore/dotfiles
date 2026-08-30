# dotfiles-container

This is the standalone, prebuilt runtime environment. Unlike the devcontainer,
its tools and dotfiles are installed while the image is built.

```sh
docker pull hacksore/dotfiles-container:latest
docker run --rm -it hacksore/dotfiles-container:latest
```

Mount a project into the home workspace when needed:

```sh
docker run --rm -it \
  -v "$PWD:/home/hacksore/work" \
  -w /home/hacksore/work \
  hacksore/dotfiles-container:latest
```
