# transaction_demo

打开`TransactionDemo.xcodeproj`,可以直接用模拟机跑代码。

### 页面简介
* 商品详情页面：实现最简单的购买功能，根据汇率来计算价格。每次购买会生成一条记录。
* 订单记录页面：展示订单信息，可以侧滑删除某一条，或者删除所有记录。

### 关于网络请求
用原生代码实现最简单的get请求。

### 关于数据持久化
有两种数据持久化方式：纯sql语句和CoreData。现在用的是CoreData。

### 关于单元测试
写了数据持久化相关的用例。
