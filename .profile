export PS1="\[\`if [[ \$? = "0" ]]; then echo '\e[32m\h\e[0m'; else echo '\e[31m\h\e[0m' ; fi\`:\w\n\$ "

# in case you are running Jupyter on a remote server such as AWS
# alias jupyter="jupyter notebook --ip=`hostname -I` --no-browser"
