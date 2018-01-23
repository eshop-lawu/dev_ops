#xtr.sh
#!/bin/sh
#on xtrabackup 2.4.9

INNOBACKUPEXFULL=/data/backup/xtrabackup/percona-xtrabackup-2.4.9-Linux-x86_64/bin/innobackupex  #INNOBACKUPEX的命令路径

#mysql目标服务器以及用户名和密码
TMPLOG="/data/backup/innobackupex.$$.log"
MY_CNF=/usr/local/eshop/mysql/conf.d/mysql.cnf #mysql的配置文件

BACKUP_DIR=/data/backup # 备份的主目录

FULLBACKUP_DIR=$BACKUP_DIR/full # 全库备份的目录

FULLBACKUP_INTERVAL=86400 # 全库备份的间隔周期，时间：秒

KEEP_FULLBACKUP=1 # 至少保留几个全库备份

logfiledate=backup.`date +%Y%m%d%H%M`.txt

#开始时间
STARTED_TIME=`date +%s`



#############################################################################

# 显示错误并退出

#############################################################################

error()
{
    echo "$1" 1>&2
    exit 1
}

 

# 检查执行环境

if [ ! -x $INNOBACKUPEXFULL ]; then
  error "$INNOBACKUPEXFULL未安装或未链接到/usr/bin."
fi

 

if [ ! -d $BACKUP_DIR ]; then
  error "备份目标文件夹:$BACKUP_DIR不存在."
fi

# 备份的头部信息

echo "----------------------------"
echo
echo "$0: MySQL备份脚本"
echo "开始于: `date +%F' '%T' '%w`"
echo

 

#新建全备和差异备份的目录

mkdir -p $FULLBACKUP_DIR

echo  "*********************************"
        echo -e "正在执行全新的完全备份...请稍等..."
        echo  "*********************************"
        $INNOBACKUPEXFULL --defaults-file=$MY_CNF --user=root --password=123456 --host=192.168.100.206  $FULLBACKUP_DIR > $TMPLOG 2>&1 
        #保留一份备份的详细日志

        cat $TMPLOG>/data/backup/$logfiledate


        if [ -z "`tail -1 $TMPLOG | grep 'innobackupex: completed OK!'`" ] ; then
         echo "$INNOBACKUPEX命令执行失败:"; echo
         echo -e "---------- $INNOBACKUPEX_PATH错误 ----------"
         cat $TMPLOG
         rm -f $TMPLOG
         exit 1
        fi

         
        THISBACKUP=`awk -- "/Backup created in directory/ { split( \\\$0, p, \"'\" ) ; print p[2] }" $TMPLOG`
        rm -f $TMPLOG

        echo -n "数据库成功备份到:$THISBACKUP"
        echo

        # 提示应该保留的备份文件起点

        LATEST_FULL_BACKUP=`find $FULLBACKUP_DIR -mindepth 1 -maxdepth 1 -type d -printf "%P\n" | sort -nr | head -1`

        RES_FULL_BACKUP=${FULLBACKUP_DIR}/${LATEST_FULL_BACKUP}

        echo
        echo -e '\e[31m NOTE:---------------------------------------------------------------------------------.\e[m' #红色
        echo -e "无增量备份,必须保留$KEEP_FULLBACKUP份全备即全备${RES_FULL_BACKUP}."
        echo -e '\e[31m NOTE:---------------------------------------------------------------------------------.\e[m' #红色
        echo



#删除过期的全备

echo -e "find expire backup file...........waiting........."
for efile in $(/usr/bin/find $FULLBACKUP_DIR/ -mtime +6)
do
        if [ -d ${efile} ]; then
        rm -rf "${efile}"
        echo -e "删除过期全备文件:${efile}"
        elif [ -f ${efile} ]; then
        rm -rf "${efile}"
        echo -e "删除过期全备文件:${efile}"
        fi;

done

if [ $? -eq "0" ];then
   echo
   echo -e "未找到可以删除的过期全备文件"
fi

echo
echo "完成于: `date +%F' '%T' '%w`"
exit 0
