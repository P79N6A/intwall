#!/bin/bash


function check () {
    _=$(command -v docker);
    if [ "$?" != "0" ]; then
    echoError "You dont seem to have Docker installed.";
    echoError "Get it: https://www.docker.com/";
    echoError "Exiting with code 127...";
    exit 127;
    fi;
}  

function echoError () {
    return_err_string="\033[31m $1 \033[0m\n"
    printf -- "$return_err_string";
}

function echoInfo () {
    return_info_string="\033[34m $1 \033[0m\n"
    printf -- "$return_info_string";
}

function alidocker () {
    read -p "请输入您的阿里云账号全名：" docker_ali_username
    docker login --username=$docker_ali_username registry.cn-beijing.aliyuncs.com
}

function dots () {
    while true
    do
        sleep 0.5
        echo -n '.'
    done
}

function pullDev () {
    read -p "请输入项目名：" project_name
    read -p "请输入项目路径[cad/$project_name]：" project_path
    project_path=${project_path:-"cad/$project_name"}
    dots &
    BG_PID=$!
    trap "kill -9 $BG_PID" INT
    url=https://raw.githubusercontent.com/my-scripts/intwall/master
    workspace_path=workspace
    wget $url/cmd -P ${CURR_DIR} -q
    wget $url/workspace/.env -P ${CURR_DIR}/$workspace_path -q
    sed -i "s/\$YOUR_PROJECT_NAME/$project_name/g" $workspace_path/.env
    sed -i "s!\$YOUR_PROJECT_PATH!$project_path!g" $workspace_path/.env
    wget $url/workspace/bashrc -P ${CURR_DIR}/$workspace_path  -q
    wget $url/workspace/docker-compose.yml -P ${CURR_DIR}/$workspace_path  -q
    wget $url/workspace/Dockerfile -P ${CURR_DIR}/$workspace_path  -q
    wget $url/Dockerfile -P ${CURR_DIR} -q
    wget $url/Makefile -P ${CURR_DIR} -q
    sed -i "s!\$YOUR_PROJECT_NAME!$project_name!g" Makefile
    go mod init git.secok.com/$project_path
    go get ./...
    kill $BG_PID
}

echoInfo "----init project----";
check
CURR_DIR=$(cd `dirname $0`; pwd)
set -e;
echoInfo "选择您要做的";
echoInfo "0.ALL";
echoInfo "1.登录阿里云容器镜像服务";
echoInfo "2.拉取开发环境";
read -p "请输入[0]:" num
num=`${num:-0}`
echoInfo $num
case $num in
    0 )
        alidocker
        pullDev
        exit;;
    1 )
        alidocker
        exit;;
    2 )
        pullDev
        exit;;
    * )
        echoError "错误的选项";
        exit 0;
esac
printf -- '\n';
exit 0;