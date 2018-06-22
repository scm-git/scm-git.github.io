# [王孝东的个人空间](https://scm-git.github.io/)
## Linux硬件信息采集脚本（包括服务器概要信息，CPU，内存，磁盘，网卡），采集脚本如下：
```
#!/bin/bash

#SN,SLOT接口，封装大小未采集到
getCpu(){
    CPU_LIST="["
    #获取CPU颗数
    #CPU_COUNT=`dmidecode -t processor | grep 'Processor Information' | wc -l`
    CPU_COUNT=`cat /proc/cpuinfo | grep 'physical id' | sort | uniq | wc -l`
    INDEX=1
    while [[ ${INDEX} -le ${CPU_COUNT} ]]
    do
        #品牌
        CPU_BRAND=`dmidecode -t processor | grep 'Manufacturer' | sed -n ${INDEX}p | cut -f2 -d: | sed 's/^[ \t]*//g'`
        #名称
        NAME=`dmidecode -t processor | grep 'Socket Designation' | sed -n ${INDEX}p | cut -f2 -d: | sed 's/^[ \t]*//g'`
        #型号
        CPU_MODEL=`dmidecode -t processor | grep 'Version' | sed -n ${INDEX}p | cut -f2 -d: | sed 's/^[ \t]*//g'`
        #线程数数
        #THREAD_SIZE=`dmidecode -t processor | grep 'Thread Count' | sed -n ${INDEX}p | cut -f2 -d: | sed 's/^[ \t]*//'`    #虚拟机上没取到该值
        THREAD_SIZE=`cat /proc/cpuinfo | grep 'physical id' | sort | uniq -c | sed 's/^[ \t]*//g' | cut -f1 -d\ | sed -n ${INDEX}p`
        #核心数
        #CORE_SIZE=`cat /proc/cpuinfo | grep "cpu cores" | cut -f2 -d: | uniq | sed 's/^[ \t]*//g'`
        #CPU_CORE_COUNT=`dmidecode -t processor | grep 'Core Count' | cut -f2 -d: | sed 's/^[ \t]*//'`
        CORE_SIZE=`dmidecode -t processor | grep 'Core Count' | sed -n ${INDEX}p | cut -f2 -d: | sed 's/^[ \t]*//'`
        #颗数，不取颗数，分别显示
        #CPU_SIZE=`cat /proc/cpuinfo | grep 'physical id' | cut -f2 -d: | tail -1 | sed 's/^[ \t]*//g'`
        #CPU_SIZE=$(($CPU_SIZE + 1))
        #主频
        #MHZ=`cat /proc/cpuinfo | grep name | cut -f2 -d@ | uniq | sed 's/^[ \t]*//g'`
        MHZ=`dmidecode -t processor | grep 'Current Speed' | sed -n ${INDEX}p | cut -f2 -d: | sed 's/^[ \t]*//'`
        #最大频率
        MAX_SPEED=`dmidecode -t processor | grep 'Max Speed' | sed -n ${INDEX}p | cut -f2 -d: | sed 's/^[ \t]*//'`

        #L3 缓存
        L3_CACHE=`lscpu | grep -i 'L3 cache' | cut -f2 -d: | sed 's/^[ \t]*//'`
        #电压
        VOLTAGE=`dmidecode -t processor | grep 'Voltage' | sed -n ${INDEX}p | cut -f2 -d: | sed 's/^[ \t]//'`

        CPU_LIST=${CPU_LIST}"{\"brand\":\"$CPU_BRAND\",\"model\":\"$CPU_MODEL\",\"threadSize\":\"$THREAD_SIZE\",\"coreSize\":\"$CORE_SIZE\",\"processorSpeed\":\"$MHZ\",\"boostProcessorSpeed\":\"$MAX_SPEED\",\"l3Cache\":\"${L3_CACHE}\",\"voltage\":\"${VOLTAGE}\",\"name\":\"${NAME}\"},"

        INDEX=$((INDEX+1))
    done

    CPU_LIST=${CPU_LIST}")"
    CPU_LIST=`echo ${CPU_LIST} | sed 's/,)$//'`

    echo ${CPU_LIST}"]"
}

#内存品牌，型号，L3缓存未采集到
getMemory(){
    #TOTAL_MEMORY=`cat /proc/meminfo | grep MemTotal | cut -f2 -d: | sed 's/^[ \t]*//g' | cut -f1 -d\ `
    #TOTAL_MEMORY=$(($TOTAL_MEMORY/1000/1000))
    MEMORY_LIST="["
    #内存条数量
    MEMORY_COUNT=`dmidecode -t memory | grep Size | grep -v 'No Module Installed' | grep -v 'Installed' | grep -v 'Maximum' | grep -v 'Enabled' | cut -f2 -d: | sed 's/^[ \t]*//' | cut -f1 -d\  | wc -l`

    INDEX=1
    while [[ ${INDEX} -le ${MEMORY_COUNT} ]]
    do
        #内存条大小（单个）
        MEMORY_SIZE=`dmidecode -t memory | grep 'Size' | grep -v 'No Module Installed' | grep -v 'Installed' | grep -v 'Maximum' | grep -v 'Enabled' | sed -n ${INDEX}p | cut -f2 -d: | sed 's/^[ \t]//g'`

        #内存类型
        MEMORY_TYPE=`dmidecode -t memory | grep 'Type' | grep -v 'Detail' | grep -v 'Unknown' | grep -v 'Error' | sed -n ${INDEX}p | cut -f2 -d: | sed 's/^[ \t]*//'`

        #内存频率
        MEMORY_FREQUENCY=`dmidecode -t memory | grep 'Speed' | grep -v 'Unknown' | grep -v 'Clock' | sed -n ${INDEX}p | cut -f2 -d: | sed 's/^[ \t]*//'`

        #内存条序列号，有些机器可能读取不到
        MEMORY_SN=`dmidecode -t memory | grep 'Serial' | grep -v 'Not Specified' | sed -n ${INDEX}p | cut -f2 -d: | sed 's/^[ \t]*//'`

        # 内存
        MEMORY_BRAND=`dmidecode -t memory | grep 'Manufacturer' | grep -v 'Not Specified' | sed -n ${INDEX}p | cut -f2 -d: | sed 's/^[ \t]//'`

        MEMORY_LIST=${MEMORY_LIST}"{\"capacity\":\"${MEMORY_SIZE}\",\"brand\":\"${MEMORY_BRAND}\",\"memoryType\":\"${MEMORY_TYPE}\",\"frequency\":\"${MEMORY_FREQUENCY}\",\"sn\":\"${MEMORY_SN}\",\"name\":\"Memory\"},"

        INDEX=$((INDEX+1))
    done

    MEMORY_LIST=${MEMORY_LIST}")"
    MEMORY_LIST=`echo ${MEMORY_LIST} | sed 's/,)$//'`

    echo ${MEMORY_LIST}"]"
}

# 数据网卡：物理类型，总线类型 未采集到
# 增加ethtool后，可以采集到的数据：品牌，型号，SN，网卡接口类型
# ILO网卡：无法采集任何数据
# 未采集虚拟IP， 因为虚拟IP会导致MAC地址重复，SNMP采集交换机与主机连接信息时是根据MAC地址来关联
#########################################################
#网卡采集逻辑：
# 1. 首先判断/proc/net/bonding目录下是否有绑定网卡，如果有，则循环处理bond类型网卡
# 2. bond处理完成后，通过ifconfig命令获取输出的网卡：ifconfig | grep -v '^[ \t]' | grep -v '^$'
# 3. 循环处理每个网卡：
#       3.1 排除已经通过bond绑定过物理网卡，避免mac地址重复(snmp采集交换机与服务器连接关系时需要通过mac地址关联)
#       3.2 排除docker0，docker0的默认IP 172.17.0.1，避免IP地址重复
#       3.3 排除虚拟IP，ifconfig输出没有MAC地址的IP为虚拟IP，避免MAC地址为空重复
#       3.4 排除没有分配IP地址备用网卡(em3,em4)；避免IP地址为空重复
# 4. 设置网卡的useType的规则：将取得第一个IP作为主数据IP(useType为2),后取到的全部设置为备用IP(useType为3)，
#########################################################
getNetworkAdapter(){
    ALL_NET="["
    ls /proc/net/bonding/ > /dev/null 2>&1
    BOND_EXIST="$?"

    #如果存在bond，处理bond网卡
    if [ ${BOND_EXIST} -eq "0" ]; then
        BOND_COUNT=`ls -l /proc/net/bonding/ | awk '{print $9}' | grep -v '^$' | wc -l`
        BOND_INDEX=1
        while [[ ${BOND_INDEX} -le ${BOND_COUNT} ]]
        do
            BOND=`ls -l /proc/net/bonding | awk '{print $9}' | grep -v '^$' | sed -n ${BOND_INDEX}p`

            # 查看bond是否存在，有些机器上/proc/net/bonding这个目录下有多个bond文件，但是只有一个生效，例如有bond0和bond1，但是bond0未生效(ifconfig命令查不到bond0)
            ifconfig ${BOND} > /dev/null 2>&1
            BOND_VALID="$?"
            if [ ${BOND_VALID} -eq "0" ]; then  #等于0表示bond网卡存在
                NET_NAME="${BOND}"

                #获取网卡速率
                #判断speed文件是否存在，如果存在则直接读取文件内容，不存在就通过ethtool命令获取网卡速率
                if [ -f "/sys/class/net/${BOND}/speed" ]; then
                    NET_SPEED=`cat /sys/class/net/${BOND}/speed`
                    NET_SPEED=${NET_SPEED}"Mb/s"    #文件读取的没有单位，此处直接加上
                else
                    NET_SPEED=`ethtool ${BOND} | grep 'Speed' | cut -f2 -d: | sed 's/^[ \t]//g'`
                fi

                #获取网卡MAC地址：先从/sys/class/net/${BOND}/address文件中取，如果文件不存在再使用ifconfig命令获取
                if [ -f "cat /sys/class/net/${BOND}/address" ]; then
                    NET_MAC=`cat /sys/class/net/${BOND}/address | tr 'A-Z' 'a-z'`
                else
                    NET_MAC=`ifconfig ${BOND} | egrep -o '[0-9a-fA-F]{2}(:[0-9a-fA-F]{2}){5}' | tr 'A-Z' 'a-z'`
                fi

                #获取网卡IP地址
                NET_IP=`ifconfig ${BOND} | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed -n 1p`

                #获取网卡flags,暂时不获取flags
                #NET_FLAGS=`ifconfig ${BOND} | egrep -o '<[A-Za-z0-9,]*>'`

                #判断是否已经存在useType=2的网卡，一个主机只有一个useType为2的网卡
                NET_USE_TYPE="3"
                echo ${ALL_NET} | grep "\"useType\":\"2\"" > /dev/null
                GREP_USE_TYPE_2="$?"
                if [ "${GREP_USE_TYPE_2}" -ne "0" ]; then
                    #如果没有useType为2的网卡，则设置为2
                    NET_USE_TYPE="2"
                fi

                #以下内容是物理网卡的属性，bond卡是由两个物理卡绑定的逻辑卡，不存在以下属性(网卡品牌，型号，连接类型，SN)，因此不采集
                #根据bond文件内容获取物理卡名称
                #SLAVE_INTERFACE_NAME=`cat /proc/net/bonding/bond0 | grep -i 'slave interface' | tail -1 | cut -f2 -d: | sed 's/^[ \t]//'`

                #使用ethtool获取网卡的接口类型，
                #NET_INTERFACE_TYPE=`ethtool ${SLAVE_INTERFACE_NAME} | grep 'Port:' | cut -f2 -d: | sed 's/^[ \t]//'`
                #采集网卡品牌和型号：根据bond的Slave Interface 取得物理网卡名，再根据ethtool获取bus-info(0000:01:00.1)，再根据lspci获取品牌和型号
                #BUS_INFO=`ethtool -i ${SLAVE_INTERFACE_NAME} | grep -i 'bus-info' | cut -f2 -d\  | sed 's/^[ \t]//'`
                #NET_BRAND=`lspci -vms ${BUS_INFO} | egrep '^Vendor' | cut -f2 -d: | sed 's/^[ \t]*//'`
                #NET_MODEL=`lspci -vms ${BUS_INFO} | egrep '^Device' | tail -1 | cut -f2 -d: | sed 's/^[ \t]//'`

                #网卡SN，直接将MAC地址中的：替换为-，并在前面加00-00-
                #NET_SN=`echo ${NET_MAC} | sed 's/:/-/g'`
                #NET_SN='00-00-'${NET_SN}

                #只处理分配了IP地址的网卡，IP地址长度超过6位(最短的IP地址7位)
                if [ ${#NET_IP} -gt 6 ]; then
                    ALL_NET=${ALL_NET}"{\"ip\":\"${NET_IP}\",\"macAddress\":\"${NET_MAC}\",\"rate\":\"${NET_SPEED}\",\"name\":\"${NET_NAME}\",\"useType\":\"${NET_USE_TYPE}\"},"
                fi

                #处理bond下的slave网卡， 注释掉SLAVE网卡，避免mac地址重复
                #SLAVE_COUNT=`cat /proc/net/bonding/${BOND} | grep 'Slave Interface' | wc -l`
                #for ((j=1; j<$((SLAVE_COUNT + 1)); j++)) {
                #    SLAVE_NET_NAME=`cat /proc/net/bonding/${BOND} | grep 'Slave Interface' | sed -n ${j}p | cut -f2 -d: | sed 's/^[ \t]*//'`
                #    SLAVE_NET_SPEED=`cat /sys/class/net/${SLAVE_NET_NAME}/speed`
                #    SLAVE_NET_MAC=`cat /sys/class/net/${SLAVE_NET_NAME}/address`
                #    #SLAVE_NET_PORT=`ethtool ${SLAVE_NET_NAME} | grep 'Port' | cut -f2 -d: | sed 's/^[ \t]//'`
                #    #SLAVE网卡没有IP地址

                #    ALL_NET=${ALL_NET}"{\"macAddress\":\"${SLAVE_NET_MAC}\",\"rate\":\"${SLAVE_NET_SPEED} Mbps\",\"name\":\"${SLAVE_NET_NAME}\",\"master\":\"${BOND}\",\"useType\":\"3\"},"
                #    SLAVE_NET_ARR+=(${SLAVE_NET_NAME})
                #}
            fi

            BOND_INDEX=$((BOND_INDEX+1))
        done
    fi
    ####################bond处理结束##################

    ####################开始处理非bond的网卡######################
    IFCONFIG_NET_ARR_COUNT=`ifconfig | grep -v '^[ \t]' | grep -v '^$' | wc -l`
    IFCONFIG_NET_INDEX=1
    while [[ ${IFCONFIG_NET_INDEX} -le ${IFCONFIG_NET_ARR_COUNT} ]]
    do
        #IFCONFIG_NET_NAME=`ifconfig | grep -v '^[ \t]' | grep -v '^$' | cut -f1 -d: | sed -n ${IFCONFIG_NET_INDEX}p` # CENT OS 6格式不一样
        IFCONFIG_NET_NAME=`ifconfig | grep -v '^[ \t]' | grep -v '^$' | cut -f1 -d\ | sed 's/:$//' | sed -n ${IFCONFIG_NET_INDEX}p`

        echo "${ALL_NET}" | grep "\"name\":\"${IFCONFIG_NET_NAME}\"" > /dev/null
        EXIST_NET="$?"

        #当名称不存在时才处理(跳过前面已经添加的bond卡)
        if [ ${EXIST_NET} -ne "0" ];then
            #检测是不是本地还回
            ethtool -i ${IFCONFIG_NET_NAME} > /dev/null 2>&1
            IS_PHYSICAL_NET="$?"

            #获取IP
            IFCONFIG_NET_IP=`ifconfig ${IFCONFIG_NET_NAME} | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed -n 1p`

            #以下采集项只有当不是还回卡的时候才采集
            if [ ${IS_PHYSICAL_NET} -eq "0" ]; then
                #获取mac，先根据ifcfg-xx文件获取，直接通过ifconfig可能无法获取到真实的mac，因为SLAVE卡的MAC地址是相同的，都是MASTER指定的MAC
                IFCONFIG_NET_MAC=""
                if [ -f "/etc/sysconfig/network-scripts/ifcfg-${IFCONFIG_NET_NAME}" ]; then
                    IFCONFIG_NET_MAC=`cat "/etc/sysconfig/network-scripts/ifcfg-${IFCONFIG_NET_NAME}" | egrep -o '[0-9a-fA-F]{2}(:[0-9a-fA-F]{2}){5}' | tr 'A-Z' 'a-z'`
                fi

                MAC_LEN=`echo "${IFCONFIG_NET_MAC}" | wc -c`
                if [ ${MAC_LEN} -le 17 ]; then
                    IFCONFIG_NET_MAC=`ifconfig ${IFCONFIG_NET_NAME} | egrep -o '[0-9a-fA-F]{2}(:[0-9a-fA-F]{2}){5}' | tr 'A-Z' 'a-z'`
                fi

                #获取网卡速率, 有问题 TODO
                `cat /sys/class/net/${IFCONFIG_NET_NAME}/speed > /dev/null 2>&1`
                CAT_SPEED="$?"
                if [ ${CAT_SPEED} -eq "0" ]; then
                    IFCONFIG_NET_SPEED=`cat /sys/class/net/${IFCONFIG_NET_NAME}/speed`
                    IFCONFIG_NET_SPEED=${IFCONFIG_NET_SPEED}"Mb/s"    #文件读取的没有单位，此处直接加上
                else
                    IFCONFIG_NET_SPEED=`ethtool ${IFCONFIG_NET_NAME} | grep 'Speed' | cut -f2 -d: | sed 's/^[ \t]//g'`
                fi

                #判断是否已经存在useType=2的网卡
                NET_USE_TYPE="3"
                echo ${ALL_NET} | grep "\"useType\":\"2\"" > /dev/null
                GREP_USE_TYPE_2="$?"
                if [ "${GREP_USE_TYPE_2}" -ne "0" ] && [ "${IFCONFIG_NET_NAME}" != "docker0" ] && [ "${IFCONFIG_NET_NAME}" != "lo" ]; then    #不等于0表示没找到useType为2
                    #如果没有useType为2的网卡，则设置为2
                    NET_USE_TYPE="2"
                fi

                #使用ethtool获取网卡的接口类型，
                NET_INTERFACE_TYPE=`ethtool ${IFCONFIG_NET_NAME} | grep 'Port:' | cut -f2 -d: | sed 's/^[ \t]//'`
                #采集网卡品牌和型号：根据ethtool获取bus-info(0000:01:00.1)，再根据lspci获取品牌和型号
                BUS_INFO=`ethtool -i ${IFCONFIG_NET_NAME} | grep -i 'bus-info' | cut -f2 -d\  | sed 's/^[ \t]//'`
                BUS_INFO_LEN=`echo ${BUS_INFO} | wc -c`
                if [ ${BUS_INFO_LEN} -gt 1 ]; then
                    NET_BRAND=`lspci -vms ${BUS_INFO} | egrep '^Vendor' | cut -f2 -d: | sed 's/^[ \t]*//'`
                    NET_MODEL=`lspci -vms ${BUS_INFO} | egrep '^Device' | tail -1 | cut -f2 -d: | sed 's/^[ \t]//'`
                fi
                #网卡SN，直接将MAC地址中的：替换为-，并在前面加00-00-
                NET_SN=`echo ${IFCONFIG_NET_MAC} | sed 's/:/-/g'`
                NET_SN='00-00-'${NET_SN}

                ALL_NET=${ALL_NET}"{\"ip\":\"${IFCONFIG_NET_IP}\",\"macAddress\":\"${IFCONFIG_NET_MAC}\",\"rate\":\"${IFCONFIG_NET_SPEED}\",\"name\":\"${IFCONFIG_NET_NAME}\",\"brand\":\"${NET_BRAND}\",\"model\":\"${NET_MODEL}\",\"networkInterfaceType\":\"${NET_INTERFACE_TYPE}\",\"sn\":\"${NET_SN}\",\"useType\":\"${NET_USE_TYPE}\"},"
            else
                #虚拟IP，useType直接设置为3
                NET_USE_TYPE="3"
                #虚拟IP：只上报名称和IP
                ALL_NET=${ALL_NET}"{\"ip\":\"${IFCONFIG_NET_IP}\",\"name\":\"${IFCONFIG_NET_NAME}\",\"useType\":\"${NET_USE_TYPE}\"},"
            fi


        fi

        IFCONFIG_NET_INDEX=$((IFCONFIG_NET_INDEX+1))
    done

    RESULT=${ALL_NET}")"
    RESULT=`echo ${RESULT} | sed 's/,)$//'`

    echo ${RESULT}"]"
    #return ${RESULT}
}

#获取IP的规则：
#先检查bond，如果有则取bond的IP,取到后直接退出；没有取到bond再通过ifconfig命令获取其他网卡的IP，只要取到一个ip即可
getIp(){
    NET_IP=""
    ls /proc/net/bonding/ > /dev/null 2>&1
    BOND_EXIST="$?"
    if [ ${BOND_EXIST} -eq "0" ]; then
        BOND_COUNT=`ls -l /proc/net/bonding/ | awk '{print $9}' | grep -v '^$' | wc -l`
        INDEX=1
        while [[ ${INDEX} -le ${BOND_COUNT} ]]
        do
            BOND=`ls -l /proc/net/bonding | awk '{print $9}' | grep -v '^$' | sed -n ${INDEX}p`
            #NET_IP=`ifconfig ${BOND} | grep 'inet ' | sed 's/^[ \t]*//' | cut -f2 -d\ `
            NET_IP=`ifconfig ${BOND} | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed -n 1p`
            if [ ${#NET_IP} -gt 6 ]; then
                break
            fi

            INDEX=$((INDEX+1))
        done
    fi

    if [ ${#NET_IP} -gt 6 ]; then
        echo "\"ip\":\"${NET_IP}\""
    else
        IFCONFIG_NET_ARR_COUNT=`ifconfig | grep -v '^[ \t]' | grep -v '^$' | wc -l`
        NET_INDEX=1
        while [[ ${NET_INDEX} -le ${IFCONFIG_NET_ARR_COUNT} ]]
        do
            #IFCONFIG_NET_NAME=`ifconfig | grep -v '^[ \t]' | grep -v '^$' | cut -f1 -d: | sed -n ${k}p`
            IFCONFIG_NET_NAME=`ifconfig | grep -v '^[ \t]' | grep -v '^$' | cut -f1 -d\ | sed 's/:$//' | sed -n ${NET_INDEX}p`
            echo ${IFCONFIG_NET_NAME} | grep "docker" > /dev/null
            GREP_DOCKER="$?"
            #不处理lo和docker的IP
            if [ "${IFCONFIG_NET_NAME}" != "lo" ] && [ "${GREP_DOCKER}" != "0" ] && [ "${IFCONFIG_NET_NAME}" != "idrac" ]; then
                #NET_IP=`ifconfig ${IFCONFIG_NET_NAME} | grep 'inet ' | sed 's/^[ \t]*//' | cut -f2 -d\ `
                NET_IP=`ifconfig ${IFCONFIG_NET_NAME} | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed -n 1p`
                if [ ${#NET_IP} -gt 6 ]; then
                    echo "\"ip\":\"${NET_IP}\""
                    break
                fi
            fi

            NET_INDEX=$((NET_INDEX+1))
        done
    fi
    #return ${RESULT}
}

#磁盘个数，转速，RAID类型，接口类型，平均传输率，高速缓存，电源无法采集到,需要使用第三方工具 TODO
getDisk(){
    DISK_COUNT=`fdisk -l | grep 'Disk' | grep -v 'Disk identifier' | grep -v 'label' | grep -v 'mapper' | wc -l`
    ALL_DISK="["
    DISK_INDEX=1
    while [[ ${DISK_INDEX} -le ${DISK_COUNT} ]]
    do
        DISK=`fdisk -l | grep 'Disk' | grep -v 'Disk identifier' | grep -v 'label' | grep -v 'mapper' | sed -n ${DISK_INDEX}p`
        #DISK_NAME=`echo $DISK | cut -f2 -d\ | cut -f1 -d:`
        #DISK_SIZE=`echo $DISK | cut -f3,4 -d\ | cut -f1 -d,`
        #磁盘名称
        DISK_NAME=`lsblk -o "NAME,TYPE" | grep disk | sed -n ${DISK_INDEX}p | cut -f1 -d\ `
        #磁盘容量
        DISK_CAPACITY=`lsblk -o "SIZE,TYPE" | grep disk | sed -n ${DISK_INDEX}p | sed 's/^[ \t]*//' | cut -f1 -d\ `
        #磁盘SN
        DISK_SN=""
        lsblk -o "SERIAL,TYPE" > /dev/null 2>&1
        LSBLK_SERIAL_EXIST="$?"
        if [ ${LSBLK_SERIAL_EXIST} -eq "0" ]; then
            DISK_SN=`lsblk -o "SERIAL,TYPE" | grep disk | sed -n ${DISK_INDEX}p | sed 's/^[ \t]*//' | cut -f1 -d\ `
        fi

        #磁盘类型：SSD/HDD
        DISK_TYPE=`lsblk -o "ROTA,TYPE" | grep disk | sed -n ${DISK_INDEX}p | sed 's/^[ \t]*//g' | cut -f1 -d\ `
        #品牌
        DISK_BRAND=""
        lsblk -o "VENDOR,TYPE" > /dev/null 2>&1
        LSBLK_VENDOR_EXIST="$?"
        if [ ${LSBLK_VENDOR_EXIST} -eq "0" ]; then
            DISK_BRAND=`lsblk -o "VENDOR,TYPE" | grep disk | sed -n 1p | sed 's/^[ \t]*//g' | cut -f1 -d\ `
        fi

        ALL_DISK=$ALL_DISK"{\"name\":\"${DISK_NAME}\",\"capacity\":\"${DISK_CAPACITY}\",\"brand\":\"${DISK_BRAND}\",\"diskType\":\"${DISK_TYPE}\",\"sn\":\"${DISK_SN}\"},"

        DISK_INDEX=$((DISK_INDEX+1))
    done
    ALL_DISK=$ALL_DISK")"
    ALL_DISK=`echo $ALL_DISK | sed 's/,)$//'`
    echo $ALL_DISK"]"
    #return ${RESULT}
}

getDeviceSn(){
    SN=`dmidecode -t system | grep 'Serial Number' | cut -f2 -d: | sed 's/[ \t]//'`
    echo "\"sn\":\"$SN\""
}

getDeviceInfo(){
    #设备序列号
    SN=`dmidecode -t system | grep 'Serial Number' | cut -f2 -d: | sed 's/[ \t]//'`
    #BIOS 版本
    BIOS_VERSION=`dmidecode -t bios | grep Version | cut -f2 -d: | sed 's/[ \t]//'`
    #型号
    MODEL=`dmidecode -t system | grep 'Product Name' | cut -f2 -d: | sed 's/[ \t]//'`
    #品牌
    BRAND=`dmidecode -t system | grep 'Manufacturer' | cut -f2 -d: | sed 's/[ \t]//'`
    #IFCONFIG; 以下的sed部分是将换行符替换为新的符号，避免json格式错误
    #IFCONFIG=`ifconfig | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/#LINE_SEPERATOR#/g'`

    echo "{\"sn\":\"$SN\",\"biosVersion\":\"$BIOS_VERSION\",\"model\":\"$MODEL\",\"brand\":\"$BRAND\"}"
}

getServerOs(){
    #主机名
    HOSTNAME=`hostname`
    #操作系统名称
    NAME=""
    #操作系统版本
    VERSION=""
    if [ -f "/etc/os-release" ]; then
        #操作系统名称
        NAME=`cat /etc/os-release | grep PRETTY_NAME | sed 's/"//g' | cut -f2 -d=`
        #操作系统版本
        VERSION=`cat /etc/os-release | grep VERSION | head -1 | cut -f2 -d= | sed 's/"//g'`
    elif [ -f "/etc/redhat-release" ]; then
        NAME=`cat /etc/redhat-release`
        VERSION=`cat /etc/redhat-release`
    elif [ -f "/etc/system-release" ]; then
        NAME=`cat /etc/system-release`
        VERSION=`cat /etc/system-release`
    else
        NAME="Unknown"
        VERSION="Unknown"
    fi

    #32位或64位，直接使用arch命令
    OS_BIT=`arch`
    #操作系统类型，固定为Linux
    OS_TYPE="Linux"

    echo "{\"hostname\":\"${HOSTNAME}\",\"version\":\"${VERSION}\",\"osBit\":\"${OS_BIT}\",\"osType\":\"${OS_TYPE}\",\"name\":\"${NAME}\"}"
}

reportInfo(){
    #REPORT_URL="http://host:port/api/report"
    # 将数据构造成数组
    CPU=`getCpu`
    MEMORY=`getMemory`
    NETWORK_ADAPTER=`getNetworkAdapter`
    DISK=`getDisk`
    IP=`getIp`
    SN=`getDeviceSn`
    DEVICE=`getDeviceInfo`
    OS=`getServerOs`
    INFO="{$SN,$IP,\"cpuDtoList\":$CPU,\"memoryDtoList\":$MEMORY,\"networkAdapterDtoList\":$NETWORK_ADAPTER,\"diskDtoList\":$DISK,\"serverDeviceDto\":$DEVICE,\"serverOsDto\":$OS}"
    echo "$INFO"
    #curl -X POST --header "Content-Type: application/json" --header "charset: utf-8" --header "token: XXX" --data "${INFO}" ${REPORT_URL}
}

# 使用ansible callback的方式
#CPU=`getCpu`
#MEMORY=`getMemory`
#NETWORK_ADAPTER=`getNetworkAdapter`
#DISK=`getDisk`
#IP=`getIp`
#DEVICE=`getDeviceInfo`
#OS=`getServerOs`
#echo "{$IP,\"cpu\":$CPU,\"memory\":$MEMORY,\"networkAdapter\":$NETWORK_ADAPTER,\"diskList\":$DISK,\"serverDevice\":$DEVICE,\"serverOs\":$OS}"

# 使用脚本直接POST数据的方式
reportInfo


```

