
cd() {
  builtin cd "$@"

  if [ -f "package.json" ]; then
    node_version=$(jq -r '.engines.node' package.json)
    operator=$(echo "$node_version" | sed -nE 's/^([<>]=?|=) ?(.+)$/\1/p')
    version=$(echo "$node_version" | sed -nE 's/^([<>]=?|=) ?(.+)$/\2/p')

    case "$operator" in
      "<") nvm use "$version" --lt ;;
      "<=") nvm use "$version" --lte ;;
      ">") nvm use "$version" --gt ;;
      ">=") nvm use "$version" --gte ;;
      "="|"==") nvm use "$version" ;;
      *) echo "[INFO] ~ Couldn't automatically change node version";;
    esac
    
  fi
}
