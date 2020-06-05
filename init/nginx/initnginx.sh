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
echo "---------------------------准备安装nginx----------------------------"
nextStep
echoread
echo "---------------------------01.导入nginx的rpm包-------------------------"
rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
nextStep
echoread
echo "---------------------------02.安装nginx-----------------------------"
yum install nginx
nextStep
echoread
echo "---------------------03.设置开机自启-------------------------------"
systemctl enable nginx
systemctl start nginx
nextStep
echoread
echo "---------------------04.查看状态------------------------------"
systemctl status nginx
echo "---------------------05.配置nginx-----------------------------"
nextStep

echo ''
echo ''
echo '复制 Nginx 配置文件：'
#配置NGINX最大句柄
mkdir -p /etc/systemd/system/nginx.service.d/
cp ./override.conf /etc/systemd/system/nginx.service.d/
systemctl daemon-reload
mv /etc/nginx/nginx.conf /etc/nginx/nginx.back
cp ./nginx.conf /etc/nginx/

echoread
echo "---------------配置nginx结束---------------------------------"

