#1/bin/bash
# 确认函数：
confirm () {
    while true; do
        read -p "$1 " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "请输入 Y/y 或者 N/n ，其他按键无效";;
        esac
    done
}

nextStep () {
    if confirm "如果上一部分没有问题，确定继续此部分？"; then
        echo '开始下一阶段'
    else
        echo '退出'
        exit
    fi
}

echoread () {
echo ''
echo ''
echo "--------------------------------------------------------------------"
echo "--------------------------------------------------------------------"
}
echo "---------------------------准备安装mysql----------------------------"
nextStep
echoread
echo "---------------------------01.安装fMySQL-------------------------"
nextStep
echoread
echo "---------------------------02.下载rpm包，并安装MySQL-----------------------------"
nextStep
echoread
yum localinstall https://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
yum install -y mysql-community-server
echo "---------------------03.设置开机自启-------------------------------"
nextStep
echoread
systemctl start mysqld.service
systemctl enable mysqld.service
echo "---------------------04.查看状态------------------------------"
systemctl status mysqld.service
echo "---------------------05.配置mysql开启BINLOG日志-----------------------------"
nextStep
echoread

echo "---------------配置MySQL结束---------------------------------"

