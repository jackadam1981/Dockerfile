快速开启GLPI+OCS进行IT资产管理
启动命令：
docker-compose -f glpi+ocs.yaml up -d

包含容器：
mariadb
Adminer
glpi(含ocs插件)
ocs(含中文语言包)

使用方法：
数据库mariadb开放3306端口到物理IP，端口3306，用户名'root'，密码'123456'，容器互通使用容器名'mariadb'。
数据库管理工具Adminer，开放8080到物理端口，直接WEB访问。登录本组数据库，可填物理IP，也可以填容器名。
IT资产管理GLPI，开放8081端口，直接WEB访问，回自动开启安装向导。
IT资产信息收集OCS，开放8082端口，直接WEB访问，但是默认目录是空，需要手动使用'http://物理IP:8082/ocsresports'访问，并且不会自动进入安装向导，需要使用'/install.php'进入安装向导。

GLPI和OCS安装向导中，服务器都填数据库容器名'mariadb',GLPI可以在安装向导中创建新的数据库，OCS需要使用Adminer提前创建数据库。

为防止密码泄露，建议修改数据库root密码并给GLPI和OCS分别设置数据库账号密码。

修改端口和密码，请修改'glpi+ocs.yaml'。