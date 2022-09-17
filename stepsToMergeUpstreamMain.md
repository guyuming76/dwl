1.从 https://github.com/guyuming76/dwl  可以看出上游 https://github.com/djpohly/dwl 有没有新的commit, 如有，可以通过 FetchUpstream 同步;

2.本地remote设置如下(remote 名称可以随意取，比如我在另一台机器上github对应的叫origin)：

```
gym@gymDeskGentoo ~/dwl $ git remote -v
github	https://github.com/guyuming76/dwl.git (fetch)
github	https://github.com/guyuming76/dwl.git (push)
origin	https://gitee.com/guyuming76/dwl.git (fetch)
origin	https://gitee.com/guyuming76/dwl.git (push)
```

3. 第1步FetchUpstream后，本地 git pull github main 获取， 再通过 git push origin main 推送到 gitee，
   也可先通过 git log origin/main..github/main 查看 gitee 和 github有啥不同;
   (https://www.cnblogs.com/wentaos/p/7567502.html)


4. 再切换到一个分支，比如 git checkout PR235_10, 可以先通过 git log main ^PR235_10 查看 PR235_10 里缺哪些commit,也就是将要merge 的commit,
   然后 git merge main 来合并上游的更新，可能会要手工解决一些冲突. 当main上需要合并的commit比较多时，一次解决冲突可能比较麻烦，可以用git merge commitId, 一次合并main上某个commitId 前的内容，分多次完成合并。

我之所以又是从github fork, 又是本地 push 到 gitee, 主要是在 github fork 上 push 的时候，说安全策略改了，用户名密码登录不能push,要access token 啥的，然后操作指南链接又打不开。相比起来，gitee在国内访问稳定迅速，用户名密码认证后push也很方便

