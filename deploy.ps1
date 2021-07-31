$dirPath = ($PSCommandPath | Split-Path -Parent).ToString()
$dirName = ($dirPath | Split-Path -Leaf).ToString()
$to = "root@10.69.1.10"

# Note that deleting everything will also delete SECRETS
#ssh $to "rm -rf ${dirName}"

scp -r "${dirPath}/[!.]*" "${to}:"
#scp -r ${dir}\hosts ${to}:/etc/ansible/hosts
#ssh -A $to "ansible-playbook -i inventories/experimental ${dirName}/site.yml"
#ssh -A $to "cd ${dirName} && ansible-playbook -i inventories/stable site.yml"
echo "
Run remotely:
    ${to}:~/${dirName}# /usr/local/bin/ansible-playbook site.yml
"