# mysql之lock(true) 锁机制的使用

在一个系列同时操作多种表的话 最好是用事务, 这样不容易出错！！！

数据库类型要是InnoDB，

加锁必须跟事务同时使用，

查询的时候都必须带锁，

比如: $user_mod->lock(true)->where('id=1')->select();

这个地方用锁查询，如果查询这个user对象需要防止同时操作的话也要进行加锁，就是也要用lock(true)这种方式查询。

```php
M()->startTrans();//开启事务
        $map['userid']='test';//查询条件
        $user = M('User')->lock(true)->where($map)->find();//加锁查询
        if($user)
        {
            //执行你想进行的操作, 最后返回操作结果 result
            $result = true;
            if(!$result)
            {
                M()->rollback();//回滚
                $this->error('错误提示');
            }
        }
        M()->commit();//事务提交
		//加上lock(true)的实际就是在查询语句最后加上 for update
        $this->success('成功提示');
```



