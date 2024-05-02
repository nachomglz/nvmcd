check_jq_installed() {
    if ! command -v jq &> /dev/null; then
        echo "[INFO] ~ Installing jq..."
        
        if [ "$(uname -s)" = "Darwin" ]; then
            # Install on mac os
            brew install jq
        else
            # Install on linux
            sudo apt-get update
            sudo apt-get install -y jq
        fi
    fi
}

fetch_content() {
  url="https://github.com/nachomglz/nvmcd/nvmcd.sh"
  content=$(curl -sSL "$url")
  echo "$content"
}

write_script() {
  sudo sh -c "echo '$1' > /usr/local/bin/nvmcd"
  sudo chmod +x /usr/local/bin/nvmcd
}


init() {
  check_jq_installed

  content=$(fetch_content)
  if [ $? -ne 0 ]; then
    echo "[ERROR] ~ Something happend while fetching the content of the script, try manually"
    exit 1
  fi

  write_script $content
  if [ $? -ne 0 ]; then
    echo "[ERROR] ~ Something happend while writing the script or assigning execution permissions to it, check manually."
    exit 1
  fi

  echo "source /usr/local/bin/nvmcd" >> ~/.zshrc
  source ~/.zshrc
}

init
