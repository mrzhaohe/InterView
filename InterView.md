[TOC]

# InterView

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

class_rw_t 与 class_ro_t 区别

```
class_rw_t结构体内有一个指向class_ro_t结构体的指针.
class_ro_t存放的是编译期间就确定的；而class_rw_t是在runtime时才确定，它会先将class_ro_t的内容拷贝过去，然后再将当前类的分类的这些属性、方法等拷贝到其中。所以可以说class_rw_t是class_ro_t的超集

当然实际访问类的方法、属性等也都是访问的class_rw_t中的内容
属性(property)存放在class_rw_t中，实例变量(ivar)存放在class_ro_t中。
```

msg_send 消息转发

```objective-c
分为三个阶段
1、动态方法解析 

  + (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(run)) {
        return NO;//返回 NO， 才会执行第二步
    }
    return [super resolveInstanceMethod:sel];
	}
	
2、快速转发 
  
  - (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(run)) {
//        return  [Dog new]; //替换其他消息接受者
        return nil; //返回nil 则会走到第3阶段，完全消息转发机制（慢速转发）
    }
    return  [super forwardingTargetForSelector:aSelector];
	}
  
3、完全消息转发
  
  3.1方法签名
  - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(run)) {
        Dog *dog = [Dog new];
        return [dog methodSignatureForSelector:aSelector];
    }
    return [super methodSignatureForSelector:aSelector];
	}
	3.2 消息转发
    - (void)forwardInvocation:(NSInvocation *)anInvocation {
    Dog *dog = [Dog new];
    if ([dog respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:dog];
    } else {
        [super forwardInvocation:anInvocation];
    }
	}
```

![](https://tva1.sinaimg.cn/large/008eGmZEly1gn3kd0skfkj30lq0cb3z6.jpg)

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



AutoreleasePool 是 oc 的一种内存回收机制，正常情况下变量在超出作用域的时候 release，但是如果将变量加入到 pool 中，那么release 将延迟执行

```
AutoreleasePool 并没有单独的结构，而是由若干个 AutoreleasePoolPage 以**双向链表**形式组成

1. PAGE_MAX_SIZE ：4KB，虚拟内存每个扇区的大小，内存对齐
2. 内部 thread ，page 当前所在的线程，AutoreleasePool是按线程一一对应的
3. 本身的成员变量占用56字节，剩下的内存存储了调用 autorelease 的变量的对象的地址，同时将一个哨兵插入page中
4. pool_boundry 哨兵标记，哨兵其实就是一个空地址，用来区分每一个page 的边界
5. 当一个Page被占满后，会新建一个page，并插入哨兵标记
```

单个自动释放池的执行过程就是`objc_autoreleasePoolPush()` —> `[object autorelease]` —> `objc_autoreleasePoolPop(void *)`

具体实现如下：

```c++
void *objc_autoreleasePoolPush(void) {
    return AutoreleasePoolPage::push();
}

void objc_autoreleasePoolPop(void *ctxt) {
    AutoreleasePoolPage::pop(ctxt);
}
```

内部实际上是对 AutoreleasePoolPage 的调用

##### objc_autoreleasePoolPush

每当自动释放池调用 objc_autoreleasePoolPush 时，都会把边界对象放进栈顶，然后返回边界对象，用于释放。

`AutoreleasePoolPage::push();`  调用👇

```c++
static inline void *push() {
   return autoreleaseFast(POOL_BOUNDARY);
}
```

`autoreleaseFast`👇

```c++
static inline id *autoreleaseFast(id obj)
{
   AutoreleasePoolPage *page = hotPage();
   if (page && !page->full()) {
       return page->add(obj);
   } else if (page) {
       return autoreleaseFullPage(obj, page);
   } else {
       return autoreleaseNoPage(obj);
   }
}
```

👆上述方法分三种情况选择不同的代码执行：

```
- 有 hotPage 并且当前 page 不满，调用 page->add(obj) 方法将对象添加至 AutoreleasePoolPage 的栈中
- 有 hotPage 并且当前 page 已满，调用 autoreleaseFullPage 初始化一个新的页，调用 page->add(obj) 方法将对象添加至 AutoreleasePoolPage 的栈中
- 无 hotPage，调用 autoreleaseNoPage 创建一个 hotPage，调用 page->add(obj) 方法将对象添加至 AutoreleasePoolPage 的栈中

最后的都会调用 page->add(obj) 将对象添加到自动释放池中。 hotPage 可以理解为当前正在使用的 AutoreleasePoolPage。
```



#### AutoreleasePoolPage

```objective-c
是以栈的形式存在，并且内部对象通过进栈、出栈对应着 objc_autoreleasePoolPush 和 objc_autoreleasePoolPop
  
当我们对一个对象发送一条 autorelease 消息时，实际上是将这个对象地址加入到 autoreleasePoolPage 的栈顶 next 指针的指向的位置
```

#### copy

##### **copy 与 strong** 

使用 copy 的目的是为了让本对象的属性不受外界影响,使用 copy 无论给我传入是一个可变对象还是不可对象,我本身持有的就是一个不可变的副本.

如果我们使用 strong ,那么这个属性就有可能指向一个可变对象,如果这个可变对象在外部被修改了,那么会影响该属性.

```objective-c
		NSMutableString *string = [[NSMutableString alloc] initWithString:@"0"];
    
    NSString *copyString = [string mutableCopy];
    NSString *strongString = string;
    
    [string appendString:@"1"];
    
    NSLog(@"copyString = %@", copyString);
    NSLog(@"strongString = %@", strongString);
```



##### copy 与 mutableCopy

不可变对象 copy 指针拷贝  浅拷贝 仅此一种情况

|            |        copy         | mutableCopy |
| :--------: | :-----------------: | :---------: |
| 不可变对象 | 浅拷贝 （指针拷贝） |   深拷贝    |
|  可变对象  |       深拷贝        |   深拷贝    |

### weak的实现原理，sideTable的内部结构

weak表其实是一个hash表，key 是所指对象的地址，value 是 weak 指针的地址数组，

sideTable是一个结构体，内部主要有引用计数表和弱引用表两个成员，内存存储的其实都是对象的地址、引用计数和weak变量的地址，而不是对象本身的数据

## Block

block的原理是什么 本质是什么

```
本质是一个 oc 对象， 内部也有一个 isa 指针
内部封装了 block 执行逻辑的函数
```

### Block 的本质 

**结构体对象**

```objective-c
int age = 20;
void (^block) (void) = ^ {
	NSLog(@"age is %d", age);
};
```

变量自动捕获👇  

```c++
struct __main_block_impl_0 {
	struct __block_impl impl; //impl 结构体见👇
	struct __main_block_desc_0* Desc;
	int age;// 自动变量捕获
}
```

```c++
struct __block_impl {
	void *isa;
	int Flags;
	int Reserved;
	void *FuncPtr; //指向 block 内部实现的函数地址 (见👇)
}
```

```c++
// 封装了 block 执行逻辑的函数
static void __main_block_func_0 () {
	//TODO
}
```

### 变量捕获

auto 值传递

static 指针传递

全局变量 不捕获 直接访问

局部变量需要捕获是因为需要`跨函数`访问

### Block 类型

`继承自NSBlock类型`

 ```
 globleBlock 没有访问 auto 变量 （访问 static 和 全局变量仍让是 globelBlock）

​ stackBlock 访问了 auto 变量 (MRC 下能打印出来, ARC下会自动调动 copy ---> mallocBlock)

​ mallocBlock ----> stackBlock 调用了 copy （栈 --- > 堆上）  
 ```



### __block的作用

`编译器会将__block变量包装成一个对象` 

基本数据类型 int  `__Block_byref_age_0`

![](https://tva1.sinaimg.cn/large/008eGmZEly1gng930adqfj30ec06c0tl.jpg)

<img src="https://tva1.sinaimg.cn/large/008eGmZEly1gng939naeuj30mk07676r.jpg" style="zoom:67%;" />

<img src="https://tva1.sinaimg.cn/large/008eGmZEly1gng92mq03kj30li09smyv.jpg" style="zoom: 67%;" />

### Block 内存管理

当 block 被 copy 到堆上时，会调用block内部的 copy 函数，copy 函数会调用 `__Block_object_assign`

## 内存管理

## Runtime

## Runloop

`viewDidLoad`和`viewWillAppear`在同一个RunLoop循环中，所以在 `viewWillAppear` 方法中，

## 组件化

## 设计模式

## 算法

## 链表

## 二叉树







