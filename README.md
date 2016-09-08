# SXGithubPaints
尝试用脚本改githubcommit的个性化图案

####改变前<br>
<img src="https://github.com/dsxNiubility/SXGithubPaints/raw/master/screenshots/0001.png" alt="Drawing" width="600px" />
####改变后<br>
<img src="https://github.com/dsxNiubility/SXGithubPaints/raw/master/screenshots/0002.png" alt="Drawing" width="600px" />
####当然也可以支持自定义图案<br>
<img src="https://github.com/dsxNiubility/SXGithubPaints/raw/master/screenshots/0003.png" alt="Drawing" width="600px" />

####怎么做的？
<img src="https://github.com/dsxNiubility/SXGithubPaints/raw/master/screenshots/0004.png" alt="Drawing" width="400px" /><br>

1. 使用本项目进行简单的配置，输入你的电脑密码，github的user.email，user.name等信息。
2. 可以随机铺满，也可以自定义图案，画完之后点击生成脚本。
3. 为了发扬大家的diy能力，提供了保存画板和取出画板的功能。
4. 生成的脚本运行后实际上是造了很多假数据的commit，需要先在自己的github建个项目克隆到本地后，将生成的脚本文件移到目录中使用下列两条指令执行

如下

	chmod 0755 dsx.sh
	./dsx.sh 


####最终生成的脚本

	spawn sudo echo 请稍等3分钟不要关闭
	expect {
    	"*assword*" {
        	send "5678\n"
        	exp_continue
    	}
	}
	exec git config user.name XXX
	exec git config user.email XXX@qq.com
	exec sudo date 100109502015.55
	exec touch 100109502015_7166.txt
	exec sleep 0.1
	exec git add .
	exec sleep 0.1
	exec git commit -m "happy"
	exec sleep 0.1
	exec touch 100109502015_6432.txt
	exec sleep 0.1


####更详细的介绍请移步：
<http://www.cnblogs.com/dsxniubility/p/5816960.html>