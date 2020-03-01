sudo apt update
sudo apt install emacs unzip bash-completion

# Install awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install 1>/dev/null 2>&1
rm awscliv2.zip
rm -rf aws
echo "aws version: $(aws --version)"

cat <<EOT > /home/ubuntu/.emacs
;; disable backup files
(setq make-backup-files nil)

;; packages
;; http://stackoverflow.com/questions/24833964/package-listed-in-melpa-but-not-found-in-package-install
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )
EOT

cat <<EOT >> /home/ubuntu/.bashrc
# User Specified Configurations

export PS1="\[\`if [[ \$? = "0" ]]; then echo '\e[32m\h\e[0m'; else echo '\e[31m\h\e[0m' ; fi\`:\w\n\$ "

# in case you are running Jupyter on a remote server such as AWS
# alias jupyter="jupyter notebook --ip=`hostname -I` --no-browser"
alias emacs='emacs -nw'

export PATH="$HOME/.local/bin:$PATH"
EOT

export PS1="\[\`if [[ \$? = "0" ]]; then echo '\e[32m\h\e[0m'; else echo '\e[31m\h\e[0m' ; fi\`:\w\n\$ "

alias emacs='emacs -nw'

export PATH="$HOME/.local/bin:$PATH"

# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/0.14.0/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

echo "eksctl version: $(eksctl version)"

# Install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

echo "kubectl version: $(kubectl version --client)"

echo "Generate ssh with no password"
ssh-keygen -b 2048 -t rsa -f /home/ubuntu/.ssh/id_rsa -q -N ""



