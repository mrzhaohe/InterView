[TOC]

# 面试

## 底层原理

### OC对象

一个NSObject对象占用多少内存？

```
系统分配了16个字节给NSObject对象（通过malloc_size函数获得） 但NSObject对象内部只使用了8个字节的空间（64bit环境下，可以通过class_getInstanceSize函数获得）
```

对象的isa指针指向哪里？

```
 instance对象的isa指向class对象 class对象的isa指向meta-class对象 meta-class对象的isa指向基类的meta-class对象
```

OC的类信息存放在哪里？ 

```
对象方法、属性、成员变量、协议信息，存放在class对象中 类方法，存放在meta-class对象中 成员变量的具体值，存放在instance对象
```

iOS用什么方式实现对一个对象的KVO？(KVO的本质是什么？) 

```
利用RuntimeAPI动态生成一个子类，并且让instance对象的isa指向这个全新的子类 当修改instance对象的属性时，会调用Foundation的_NSSetXXXValueAndNotify函数 willChangeValueForKey: 父类原来的setter didChangeValueForKey: 内部会触发监听器（Oberser）的监听方法( observeValueForKeyPath:ofObject:change:context:）
```

IMP、SEL、Method的区别

```
SEL是方法编号，也是方法名
IMP是函数实现指针，找IMP就是找函数实现的过程
Method就是具体的实现
SEL和IMP的关系就可以解释为：
SEL就相当于书本的⽬录标题
IMP就是书本的⻚码
Method就是具体页码对应的内容
SEL是在dyld加载镜像到内存时，通过_read_image方法加载到内存的表中了
```



##### 

## 其他原理

#### 单例

```
使用@synchronized虽然解决了多线程的问题，但是并不完美。因为只有在single未创建时，我们加锁才是有必要的。如果single已经创建.这时候锁不仅没有好处，而且还会影响到程序执行的性能（多个线程执行@synchronized中的代码时，只有一个线程执行，其他线程需要等待）。

当onceToken= 0时，线程执行dispatch_once的block中代码 当onceToken= -1时，线程跳过dispatch_once的block中代码不执行 当onceToken为其他值时，线程被阻塞，等待onceToken值改变
```

#### 通知 

[通知实现原理参考](https://www.jianshu.com/p/4a44b9a15fe9?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation)

```
两张表 Named Table NotificationName作为表的key， nameless table 没有传入NotificationName wildcard
```

#### AutoreleasePool的实现原理

## Block

block的原理是什么 本质是什么

```
oc对象 内部封装函数地址
```



__block的作用是什么



## 内存管理

## Runtime

## Runloop

## 组件化

## 设计模式

## 算法

## 链表

## 二叉树







