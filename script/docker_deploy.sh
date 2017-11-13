#!/bin/sh

# 清除none的docker镜像
function clear_images() {
	local tag=${TAG}
	if [ $1 ]
	then
        tag=$1
    fi
	if [ ${tag} ]
    then
        if [ ${tag} = "all" ]
        then
            local images=`docker images -a -q`
        else
            local images=`docker images --filter=reference="registry.eshop.com/*:${tag}" --format "{{.ID}}"`
        fi
    fi
    
    echo ${images}
	
    # 待清理镜像ID
    local images=${images} `sudo docker inspect -f "{{.ID}}:{{.RepoTags}}" $(sudo docker images -q) | grep "\[\]" | cut -d ":" -f 2`
    
    # 待清理镜像数量
    local images_num=`echo "${images}" | wc -l`
    
    if [[ ${images} && ${images_num} -gt 0 ]]
    then
        # 清理镜像
        sudo docker rmi ${images}
    fi
}

# 清理无效的docker挂载
function clear_volumes() {
    # 待清理镜像ID
    local volumes=`sudo docker volume ls -qf dangling=true`
    
    # 待清理镜像数量
    local volumes_num=`echo "${volumes}" | wc -l`
    
    if [[ ${volumes} && ${volumes_num} -gt 1 ]]
    then
        # 清理镜像
        sudo docker volume rm ${volumes}
    fi
}

# 清理docker环境
function clear() {
    # 清理docker镜像
    clear_images
    
    # 清理docker挂载
    clear_volumes
}

# 停止服务，重新拉取镜像，启动服务
function deploy() {
    # 指定的当前环境
    local service_name=${MODULE}
    local tag=${TAG}
    
    if [ ${service_name} ]
    then
        TAG=${tag} /usr/local/bin/docker-compose -f /usr/local/eshop/docker-compose.yml rm -s -f ${service_name}
    else
        TAG=${tag} /usr/local/bin/docker-compose -f /usr/local/eshop/docker-compose.yml down
    fi
    TAG=${tag} /usr/local/bin/docker-compose -f /usr/local/eshop/docker-compose.yml pull ${service_name}
    TAG=${tag} /usr/local/bin/docker-compose -f /usr/local/eshop/docker-compose.yml up -d ${service_name}
    clear all
}

# 重启服务
function restart() {
    # 指定的当前环境
    local service_name=${MODULE}
    local tag=${TAG}
    
    TAG=${tag} /usr/local/bin/docker-compose -f /usr/local/eshop/docker-compose.yml restart ${service_name}
}

help() {
    cat <<EOF
USAGE EXAMPLE: ./docker_deploy.sh command -m module -t tag
Commands:
    clear   clear images and volumes
    deploy  deploy compose service
    restart restart compose service
Options:
    -m      docker-compose service name
    -t      docker images tag
EOF
    exit 0  
}  

# --参数--
# 操作类型
OPT=$1;shift

while [ -n "$1" ]; do
case $1 in
    -h) help;shift 1;;
    -m) MODULE=$2;shift 2;; # 部署目标
    -t) TAG=$2;shift 2;; # 部署版本 
    -*) echo "error: no such option $1. -h for help";exit 1;;  
    *) break;;
esac
done

if [ ${OPT} ]
then
	if [ ${OPT} = "deploy" ]
	then
	    deploy
	elif [ ${OPT} = "restart" ]
	then
	    restart
	elif [ ${OPT} = "clear" ]
	then
	    clear
	else
	    echo "unknown command: ${OPT}"
    fi
else
    help
fi