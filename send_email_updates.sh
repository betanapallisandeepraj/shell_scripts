#!/bin/bash
email_list="sw-dev-updates@doodlelabs.com,sandeep.betanapalli@doodlelabs.com"
#while IFS= read -r line; do
#        file_line=$line
#        echo "${LINENO}:$file_line"
cat ./email_subject.txt >/tmp/abc_temp.txt
echo "Testing email list of 2" >>/tmp/abc_temp.txt
#	sendmail $file_line < /tmp/abc_temp.txt
sendmail $email_list </tmp/abc_temp.txt
#done < echo $email_list
