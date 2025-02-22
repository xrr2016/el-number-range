#!/bin/sh
if [ "$TRAVIS_TEST_RESULT" != "0" ]
then
  echo "build not success, bye"
  exit 1
fi

url=https://api.github.com/repos/FEMessage/el-number-range/releases/latest
resp_tmp_file=resp.tmp

curl -H "Authorization: token $GITHUB_TOKEN" $url > $resp_tmp_file

html_url=`cat $resp_tmp_file | sed -n 5p | sed 's/\"html_url\"://g' | awk -F '"' '{print $2}'`
body=`cat $resp_tmp_file | grep body | sed 's/\"body\"://g;s/\"//g'`

msg='{"msgtype": "markdown", "markdown": {"title": "el-number-range更新", "text": "@所有人\n# [el-number-range]('$html_url')\n'$body'"}}'

curl -X POST https://oapi.dingtalk.com/robot/send\?access_token\=$DINGTALK_ROBOT_TOKEN -H 'Content-Type: application/json' -d "$msg"

rm $resp_tmp_file
