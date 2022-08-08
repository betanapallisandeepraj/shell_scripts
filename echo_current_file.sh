#var=$0
var=$(echo $0 | awk -F / '{print $2}')
echo "file=$var"
