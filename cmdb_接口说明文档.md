# CMDB接口说明文档
## 1.资产系统从CMDB获取单个主机数据
* 1.资产系统调用CMDB接口，获取主机与耗材(CPU,磁盘，内存，网卡及其他PCI卡)的关联关系
* 2.接口调用请求说明：
  ```
  http请求方式：GET
  uri:/api/v1/platform/asset/serverdevice/{sn}
  http header添加token, token值后续约定
  完整URL示例：http://localhost/api/v1/platform/asset/serverdevice/02b889e3-79ea-4ed1-b0a0-3f00fbb31284
  curl命令示例：curl -X GET --header 'Accept: application/json' --header 'token: xxxxxx' 'http://localhost/api/v1/platform/asset/serverdevice/02b889e3-79ea-4ed1-b0a0-3f00fbb31284'
  ```
* 3.返回说明
  ```
  CMDB返回成功示例：
  {
	  "success": "SUCCESS",
	  "message": "操作成功",
	  "status": 200,
	  "data": {
		"sn": "02b889e3-79ea-4ed1-b0a0-3f00fbb31284",
		"serverDevice": {
		  "id": 36706,
		  "uid": "95fb9073-6f18-11e8-b94f-d46a6ac6ea8d",
		  "createTime": 1528901202000,
		  "updateTime": 1529394279000,
		  "name": "neo4j1",
		  "mark": "",
		  "brand": "",
		  "model": "",
		  "sn": "02b889e3-79ea-4ed1-b0a0-3f00fbb31284",
		  "status": "8",
		  "biosVersion": "Bochs",
		  "expireDate": "",
		  "unitPosition": "304K10U0102",
		  "incomingType": "1",
		  "incomingBatch": "",
		  "equipmentCabinet": null,
		  "installPercent": 0,
		  "systemType": "db",
		  "useGroup": null,
		  "hardwareGroup": null
		},
		"serverOs": {
		  "id": 36707,
		  "uid": "9603a6c6-6f18-11e8-b94f-d46a6ac6ea8d",
		  "createTime": 1528901202000,
		  "updateTime": 1529394279000,
		  "name": "CentOS release 6.5 (Final)",
		  "mark": null,
		  "hostname": "10.250.140.119",
		  "osType": "Linux",
		  "version": "CentOS release 6.5 (Final)",
		  "osBit": "x86_64",
		  "serverDevice": null
		},
		"networkAdapterList": [
		  {
			"id": 36814,
			"uid": "cf329bf9-6f74-11e8-8a63-d46a6ac6ea8d",
			"createTime": 1528940811000,
			"updateTime": 1529394279000,
			"name": "eth0",
			"mark": null,
			"brand": "",
			"model": "",
			"useType": "2",
			"physicalType": null,
			"sn": "00-00-52-54-00-be-f7-e8",
			"rate": "Mb/s",
			"ip": "10.250.140.119",
			"macAddress": "52:54:00:be:f7:e8",
			"busType": null,
			"networkInterfaceType": "",
			"flags": null,
			"serverDevice": null,
			"physicalPort": null,
			"aggregation": null,
			"broken": false
		  }
		],
		"standbyNetworkAdapterList": [
		  {
			"id": 36813,
			"uid": "cf2d1db8-6f74-11e8-8a63-d46a6ac6ea8d",
			"createTime": 1528940811000,
			"updateTime": 1529394279000,
			"name": "lo",
			"mark": null,
			"brand": null,
			"model": null,
			"useType": "3",
			"physicalType": null,
			"sn": null,
			"rate": null,
			"ip": "127.0.0.1",
			"macAddress": null,
			"busType": null,
			"networkInterfaceType": null,
			"flags": null,
			"serverDevice": null,
			"physicalPort": null,
			"aggregation": null,
			"broken": false
		  }
		],
		"iloNetworkAdapter": {
		  "id": 36708,
		  "uid": "960af9fa-6f18-11e8-b94f-d46a6ac6ea8d",
		  "createTime": 1528901202000,
		  "updateTime": 1528901202000,
		  "name": "11.250.140.119",
		  "mark": null,
		  "brand": null,
		  "model": null,
		  "useType": "1",
		  "physicalType": null,
		  "sn": null,
		  "rate": null,
		  "ip": "11.250.140.119",
		  "macAddress": null,
		  "busType": null,
		  "networkInterfaceType": null,
		  "flags": null,
		  "serverDevice": null,
		  "physicalPort": null,
		  "aggregation": null,
		  "broken": false
		},
		"diskList": [
		  {
			"id": 36812,
			"uid": "cf2a1077-6f74-11e8-8a63-d46a6ac6ea8d",
			"createTime": 1528940811000,
			"updateTime": 1529394279000,
			"name": "vdb",
			"mark": null,
			"brand": "",
			"capacity": "200G",
			"diskType": "1",
			"rpm": null,
			"interfaceType": null,
			"diskSize": null,
			"rapidType": null,
			"sn": "",
			"averageTransmissionRate": null,
			"cache": null,
			"powerSource": null,
			"serverDevice": null
		  },
		  {
			"id": 36811,
			"uid": "cf25a3a6-6f74-11e8-8a63-d46a6ac6ea8d",
			"createTime": 1528940811000,
			"updateTime": 1529394279000,
			"name": "vda",
			"mark": null,
			"brand": "",
			"capacity": "20G",
			"diskType": "1",
			"rpm": null,
			"interfaceType": null,
			"diskSize": null,
			"rapidType": null,
			"sn": "",
			"averageTransmissionRate": null,
			"cache": null,
			"powerSource": null,
			"serverDevice": null
		  }
		],
		"cpuList": [
		  {
			"id": 36900,
			"uid": "9eca9286-7394-11e8-873c-d46a6ac6ea8d",
			"createTime": 1529394279000,
			"updateTime": 1529394279000,
			"name": "CPU 1",
			"mark": null,
			"brand": "Bochs",
			"model": "Not Specified",
			"cpuSize": null,
			"coreSize": "",
			"sn": null,
			"slotType": null,
			"boostProcessorSpeed": "2000 MHz",
			"processorSpeed": "2000 MHz",
			"packageSize": null,
			"threadSize": "1",
			"l3Cache": "",
			"voltage": "Unknown",
			"serverDevice": null
		  },
		  {
			"id": 36903,
			"uid": "9ed73cb9-7394-11e8-873c-d46a6ac6ea8d",
			"createTime": 1529394279000,
			"updateTime": 1529394279000,
			"name": "CPU 4",
			"mark": null,
			"brand": "Bochs",
			"model": "Not Specified",
			"cpuSize": null,
			"coreSize": "",
			"sn": null,
			"slotType": null,
			"boostProcessorSpeed": "2000 MHz",
			"processorSpeed": "2000 MHz",
			"packageSize": null,
			"threadSize": "1",
			"l3Cache": "",
			"voltage": "Unknown",
			"serverDevice": null
		  },
		  {
			"id": 36902,
			"uid": "9ed3e158-7394-11e8-873c-d46a6ac6ea8d",
			"createTime": 1529394279000,
			"updateTime": 1529394279000,
			"name": "CPU 3",
			"mark": null,
			"brand": "Bochs",
			"model": "Not Specified",
			"cpuSize": null,
			"coreSize": "",
			"sn": null,
			"slotType": null,
			"boostProcessorSpeed": "2000 MHz",
			"processorSpeed": "2000 MHz",
			"packageSize": null,
			"threadSize": "1",
			"l3Cache": "",
			"voltage": "Unknown",
			"serverDevice": null
		  },
		  {
			"id": 36901,
			"uid": "9ed14947-7394-11e8-873c-d46a6ac6ea8d",
			"createTime": 1529394279000,
			"updateTime": 1529394279000,
			"name": "CPU 2",
			"mark": null,
			"brand": "Bochs",
			"model": "Not Specified",
			"cpuSize": null,
			"coreSize": "",
			"sn": null,
			"slotType": null,
			"boostProcessorSpeed": "2000 MHz",
			"processorSpeed": "2000 MHz",
			"packageSize": null,
			"threadSize": "1",
			"l3Cache": "",
			"voltage": "Unknown",
			"serverDevice": null
		  }
		],
		"memoryList": [
		  {
			"id": 36904,
			"uid": "9edba98a-7394-11e8-873c-d46a6ac6ea8d",
			"createTime": 1529394279000,
			"updateTime": 1529394279000,
			"name": "Memory",
			"mark": null,
			"brand": "",
			"sn": "",
			"frequency": "",
			"capacity": "8192 MB",
			"model": null,
			"memorySize": null,
			"memoryType": "RAM",
			"l3Cache": null,
			"serverDevice": null
		  }
		]
	  }
	}
  ```
  
  说明： data中返回的就是硬件详细数据:
  * serverDevice: 表示服务器信息
  * cpuList: 表示CPU列表
  * memoryList: 内存列表
  * diskList: 磁盘列表(目前只有阵列信息，没有物理磁盘信息，待采集完善)
  * networkAdapterList: 主数据网卡信息
  * standbyNetworkAdapterList: 备用网卡信息：
  * iloNetworkAdapter: ILO网卡信息
  
## 2.资产系统从CMDB获取所有主机数据
* 1.资产系统调用CMDB接口，获取主机与耗材(CPU,磁盘，内存，网卡及其他PCI卡)的关联关系
* 2.接口调用请求说明：
  ```
  http请求方式：GET
  uri:/api/v1/platform/asset/serverdevice
  http header添加token, token值后续约定
  完整URL示例：http://localhost/api/v1/platform/asset/serverdevice
  curl命令示例：curl -X GET --header 'Accept: application/json' --header 'token: xxxxxx' 'http://localhost/api/v1/platform/asset/serverdevice'
  ```
* 3.返回说明

  ```
  CMDB返回成功示例：
  {
	  "success": "SUCCESS",
	  "message": "操作成功",
	  "status": 200,
	  "data": [
	    {
            "sn": "02b889e3-79ea-4ed1-b0a0-3f00fbb31284",
            "serverDevice": {
              "id": 36706,
              "uid": "95fb9073-6f18-11e8-b94f-d46a6ac6ea8d",
              "createTime": 1528901202000,
              "updateTime": 1529394279000,
              "name": "neo4j1",
              "mark": "",
              "brand": "",
              "model": "",
              "sn": "02b889e3-79ea-4ed1-b0a0-3f00fbb31284",
              "status": "8",
              "biosVersion": "Bochs",
              "expireDate": "",
              "unitPosition": "304K10U0102",
              "incomingType": "1",
              "incomingBatch": "",
              "equipmentCabinet": null,
              "installPercent": 0,
              "systemType": "db",
              "useGroup": null,
              "hardwareGroup": null
            },
            "serverOs": {
              "id": 36707,
              "uid": "9603a6c6-6f18-11e8-b94f-d46a6ac6ea8d",
              "createTime": 1528901202000,
              "updateTime": 1529394279000,
              "name": "CentOS release 6.5 (Final)",
              "mark": null,
              "hostname": "10.250.140.119",
              "osType": "Linux",
              "version": "CentOS release 6.5 (Final)",
              "osBit": "x86_64",
              "serverDevice": null
            },
            "networkAdapterList": [
              {
                "id": 36814,
                "uid": "cf329bf9-6f74-11e8-8a63-d46a6ac6ea8d",
                "createTime": 1528940811000,
                "updateTime": 1529394279000,
                "name": "eth0",
                "mark": null,
                "brand": "",
                "model": "",
                "useType": "2",
                "physicalType": null,
                "sn": "00-00-52-54-00-be-f7-e8",
                "rate": "Mb/s",
                "ip": "10.250.140.119",
                "macAddress": "52:54:00:be:f7:e8",
                "busType": null,
                "networkInterfaceType": "",
                "flags": null,
                "serverDevice": null,
                "physicalPort": null,
                "aggregation": null,
                "broken": false
              }
            ],
            "standbyNetworkAdapterList": [
              {
                "id": 36813,
                "uid": "cf2d1db8-6f74-11e8-8a63-d46a6ac6ea8d",
                "createTime": 1528940811000,
                "updateTime": 1529394279000,
                "name": "lo",
                "mark": null,
                "brand": null,
                "model": null,
                "useType": "3",
                "physicalType": null,
                "sn": null,
                "rate": null,
                "ip": "127.0.0.1",
                "macAddress": null,
                "busType": null,
                "networkInterfaceType": null,
                "flags": null,
                "serverDevice": null,
                "physicalPort": null,
                "aggregation": null,
                "broken": false
              }
            ],
            "iloNetworkAdapter": {
              "id": 36708,
              "uid": "960af9fa-6f18-11e8-b94f-d46a6ac6ea8d",
              "createTime": 1528901202000,
              "updateTime": 1528901202000,
              "name": "11.250.140.119",
              "mark": null,
              "brand": null,
              "model": null,
              "useType": "1",
              "physicalType": null,
              "sn": null,
              "rate": null,
              "ip": "11.250.140.119",
              "macAddress": null,
              "busType": null,
              "networkInterfaceType": null,
              "flags": null,
              "serverDevice": null,
              "physicalPort": null,
              "aggregation": null,
              "broken": false
            },
            "diskList": [
              {
                "id": 36812,
                "uid": "cf2a1077-6f74-11e8-8a63-d46a6ac6ea8d",
                "createTime": 1528940811000,
                "updateTime": 1529394279000,
                "name": "vdb",
                "mark": null,
                "brand": "",
                "capacity": "200G",
                "diskType": "1",
                "rpm": null,
                "interfaceType": null,
                "diskSize": null,
                "rapidType": null,
                "sn": "",
                "averageTransmissionRate": null,
                "cache": null,
                "powerSource": null,
                "serverDevice": null
              },
              {
                "id": 36811,
                "uid": "cf25a3a6-6f74-11e8-8a63-d46a6ac6ea8d",
                "createTime": 1528940811000,
                "updateTime": 1529394279000,
                "name": "vda",
                "mark": null,
                "brand": "",
                "capacity": "20G",
                "diskType": "1",
                "rpm": null,
                "interfaceType": null,
                "diskSize": null,
                "rapidType": null,
                "sn": "",
                "averageTransmissionRate": null,
                "cache": null,
                "powerSource": null,
                "serverDevice": null
              }
            ],
            "cpuList": [
              {
                "id": 36900,
                "uid": "9eca9286-7394-11e8-873c-d46a6ac6ea8d",
                "createTime": 1529394279000,
                "updateTime": 1529394279000,
                "name": "CPU 1",
                "mark": null,
                "brand": "Bochs",
                "model": "Not Specified",
                "cpuSize": null,
                "coreSize": "",
                "sn": null,
                "slotType": null,
                "boostProcessorSpeed": "2000 MHz",
                "processorSpeed": "2000 MHz",
                "packageSize": null,
                "threadSize": "1",
                "l3Cache": "",
                "voltage": "Unknown",
                "serverDevice": null
              },
              {
                "id": 36903,
                "uid": "9ed73cb9-7394-11e8-873c-d46a6ac6ea8d",
                "createTime": 1529394279000,
                "updateTime": 1529394279000,
                "name": "CPU 4",
                "mark": null,
                "brand": "Bochs",
                "model": "Not Specified",
                "cpuSize": null,
                "coreSize": "",
                "sn": null,
                "slotType": null,
                "boostProcessorSpeed": "2000 MHz",
                "processorSpeed": "2000 MHz",
                "packageSize": null,
                "threadSize": "1",
                "l3Cache": "",
                "voltage": "Unknown",
                "serverDevice": null
              },
              {
                "id": 36902,
                "uid": "9ed3e158-7394-11e8-873c-d46a6ac6ea8d",
                "createTime": 1529394279000,
                "updateTime": 1529394279000,
                "name": "CPU 3",
                "mark": null,
                "brand": "Bochs",
                "model": "Not Specified",
                "cpuSize": null,
                "coreSize": "",
                "sn": null,
                "slotType": null,
                "boostProcessorSpeed": "2000 MHz",
                "processorSpeed": "2000 MHz",
                "packageSize": null,
                "threadSize": "1",
                "l3Cache": "",
                "voltage": "Unknown",
                "serverDevice": null
              },
              {
                "id": 36901,
                "uid": "9ed14947-7394-11e8-873c-d46a6ac6ea8d",
                "createTime": 1529394279000,
                "updateTime": 1529394279000,
                "name": "CPU 2",
                "mark": null,
                "brand": "Bochs",
                "model": "Not Specified",
                "cpuSize": null,
                "coreSize": "",
                "sn": null,
                "slotType": null,
                "boostProcessorSpeed": "2000 MHz",
                "processorSpeed": "2000 MHz",
                "packageSize": null,
                "threadSize": "1",
                "l3Cache": "",
                "voltage": "Unknown",
                "serverDevice": null
              }
            ],
            "memoryList": [
              {
                "id": 36904,
                "uid": "9edba98a-7394-11e8-873c-d46a6ac6ea8d",
                "createTime": 1529394279000,
                "updateTime": 1529394279000,
                "name": "Memory",
                "mark": null,
                "brand": "",
                "sn": "",
                "frequency": "",
                "capacity": "8192 MB",
                "model": null,
                "memorySize": null,
                "memoryType": "RAM",
                "l3Cache": null,
                "serverDevice": null
              }
            ]
          }
	    },
	    {...}
	   ]
  ```
  
  说明：相关字段解释与第一个接口相似，只是获取全量数据时，data是数组，其他数据项一样

## 2.CMDB从资产系统同步资产数据(待资产系统完善)
* CMDB根据设备SN获取资产系统中设备的详细（单个操作）
* CMDB从资产系统读取所有设备的SN，设备类型以及其他设备参数（批量操作）
