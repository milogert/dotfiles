# Link all files from this directory into the the home directory.
for f in .*; do
  # Skip the git directory.
  if [[ $f == ".git" ]]; then
    continue
  fi

  # Link the files or directories.
  echo "Linking ./$f to ../$f"
  ln -s .dotfiles/$f ../$f
done

echo ".dotfiles setup is complete."

