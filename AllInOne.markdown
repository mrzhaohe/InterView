[toc]
#### 通识基础
##### 计算机计量单位换算
1Byte = 8 Bit 
1KB    = 1,024 Bytes
1MB   = 1,024 KBww




------





#### 内存
##### 理解属性这一概念
实例变量，加上get/set方法
@dynamic告诉编译器不要自动创建set/get方法，还有实例变量
@synthesize可以指定实例变量的名字（这个最好少用，不然代码让人看不懂）
默认情况下属性是atomic，是自动加了一个同步锁(synchronized)，这个历史遗留问题iOS同步锁的开销很大，而且atomic也不一定能保证线程安全，所以大部分都是nonatomic，再用其他的锁保证线程安全

##### 类对象的能否继承，重写
可以

##### iOS中内存泄漏的场景
NSTimer
Block
代理
通知
try/catch:出现异常用@throw可能会出现内存泄漏的情况，通常不是那种致命错误，用返回nil或者NSError，如果非要用try/catch那么要注意在final里释放资源（比如数据库）

##### 如何理解NSCopying
对象想要拷贝必须实现NSCopying协议，如果是想要深拷贝是实现NSMutableCopying协议，默认的拷贝都是浅拷贝
copywithzone方法里的zone参数是历史遗留问题，不必理会

##### 用assign修饰对象会怎样
会崩溃
assign和weak修饰类似，weak对应的关键修饰符是__weak，assign是__unsafe_unretained，俩的差别就是__weak释放后会置nil，assign会出现野指针，而用他们俩修饰，简单的allocinit编译后的代码是会发送消息让对象直接释放

##### 如何检测项目中的野指针（BAD_ACCESS）
开启僵尸对象模式
开启僵尸对象调试后，原本要被系统回收的对象系统就不会将他们回收，而是转化成僵尸对象，所占用的内存也不会被复写，当他们收到消息的时候，就会抛出异常。
僵尸对象的生成类似KVO，当设置了僵尸对象，系统会在dealloc的时候swizzle，new出来的新的僵尸Object，并指向原本的Object，原本的Object不会释放，当僵尸对象收到消息，就能找到原本将收到消息的对象了并抛出异常

##### nil，Nil，Null，NSNull
nil：指向oc中对象的空指针
Nil：指向oc中类的空指针
NULL：指向其他类型的空指针，如一个c类型的内存指针
NSNull：在集合对象中，表示空值的对象

##### id的实质(联系block为什么是一个OC对象)
```
//id为一个objc_object结构体的指针类型
typedef struct objc_object {
    Class isa;
} *id;

//Class为objc_class结构体的指针类型
typedef struct objc_class *Class;
struct objc_class {
    Class isa;
};
```
而block的结构体
```
struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
}
```
一个普通对象
```
struct TestObject {
    Class isa;
    int val0;
    int val1;
}
```
对比一下，明白了吧？

##### 理解引用计数ARC
？？？
##### 用autoreleasepool降低内存峰值
？？？
##### 向一个nill对象发送消息会发生什么？
？？？
##### AutoreleasePool的实现原理
？？？




------




#### Block
##### 理解Block
Block就是带有局部变量的匿名函数(RB.P80)
匿名函数：不带名称的函数。虽然说函数指针也是可以替换掉函数的，但是函数指针在赋值的时候也是需要知道函数名的

```
int (*funcptr)(int) = &func;
int result = (*funcptr)(10); 
```

##### blcok的实质
当一个block被转换为C代码后是这样的
```
//Block
void(^blk)(void) = ^{
    printf("Block\n");
};
blk();
//转化后是这样
struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
}
//接下来是几个名叫__main_block_xxx_0的结构体和方法
//这里用impl代替原本的__main_block_impl_0
//这里用func代替原本的__main_block_func_0
//这里用desc代替原本的__main_block_desc_0
struct impl0 {
    struct __block_impl impl;
    struct desc *Desc;
    //block的一个构造方法
    impl0(void *fp ... ...) {
        impl.isa = &StackBlock;
        impl.FuncPtr = fp;
    }
}

static void func0(struct impl *__cself) {
    printf("Block\n");
}

static struct desc0 {    //这个里边就是关于版本，大小的数据
    unsigned long reserved;
    unsigned long Block_size;
}
//block的最终生成函数
void(^blk)(void) = (void (*)(void)) &imp0((void *)func0 ... ...)
//blk();转化
(*blk->imp.FuncPtr)(blk);
```
(以下分别省去__main_block_0这个前缀和后缀)
从源代码中就可以看出，其实Block内部最终的方法就是func里的内容。从这个方法的参数，又能联系到impl0这个结构体，在这个结构体里又有__block_impl这个结构体和desc这个结构体。
然后看最后的block生成函数，一个block就是调用结构体的impl0的构造函数初始化一个impl0的struct，传入代表源block内部方法的func0，impl0里的impl又有关于impl0需要的信息和函数指针。由此看出impl0结构体，实际上就是我们的block。
因为OC对象的实质就是个有isa指针的结构体，所以Block也可以看做一个OC对象(RB.P97~P99，这里有详细介绍id,即void *是什么个东西)
最后使用Block的代码blk()转换后就是简单的函数调用

##### blcok如何截获局部变量
如代码所示，block是会截取局部变量的
```
void blockFunc() {
    int val = 10;
    void (^blk)(void) = ^{
        printf("val in block = %d\n", val);
    };
    val = 20;
    printf("now the val = %d\n", val);
    blk();
}
```
最后打印的结果是
```
now the val = 20
val in block = 10
Program ended with exit code: 0
```
因为block会捕获局部变量的瞬间值，所以在block捕获之后，val的值改变成多少，都和block捕获的变量无关

```
//Block
int dmy = 20;
int val = 10;
const char *fmt = "val = %d\n";
void(^blk)(void) = ^{
    printf(fmt, val);
};
blk();
//转化后代码合上面的block实质这部分差不多，不过下面这里不同
struct impl0 {
    struct __block_impl impl;
    struct desc *Desc;
    int val;
    const char *fmt;
    //block的一个构造方法
    impl0(void *fp , int _val, char *_fmt ... ...) {
        impl.isa = &StackBlock;
        impl.FuncPtr = fp;
    }
}
static void func0(struct impl *__cself) {
    const char *fmt = __cself->fmt;
    int val = __cself->val;
    printf(fmt, val);
}
```
从源码中可知，局部变量fmt和val会被作为impl0这个结构体的成员变量，但是dmy这个变量block没有使用，所以他是不会被追加进去的。
```
struct impl0 {
    struct __block_impl impl;
    struct desc *Desc;
    int val;
    const char *fmt;
}
```
由此我们可以看出block是如何截取变量的。即使在Block内部使用了被截取的变量，也不会对原来的对象有影响
所以所谓的截取成员变量，就是将成员变量值被保存到block的实例中（即impl0这个机构体之中）

##### __block
__block其实是和static将变量存在静态区，auto存在栈区等说明符一样，是指将变量放入某个特定的内存区域
```
__block int val = 10;
void(^blk)(void) = ^{
    val = 1;
};
```
```
__block int val = 10;
//编译后
struct __Block_byref_val_0 {
    void *__isa;
    __Block_byref_val_0 *__forwarding;
    int __flags;
    int __size;
    int val;
};
```
可以见得val加了block之后成为了一个结构体，可以将它看成一个objc对象。其中，val就是真正的int val，而__forwarding是一个指向自己的指针,他存在的原因是因为->block都有哪几种类型的Block
这个结构体可以用在几个block中。

```
struct impl0 {
    struct __block_impl impl;
    struct desc *Desc;
    __Block_byref_val_0 *val;
    //block的一个构造方法
    impl0(void *fp, __Block_byref_val_0 *_val : val(val->__forwarding) ... ...) {
        impl.isa = &StackBlock;
        impl.FuncPtr = fp;
    }
}

static void func0(struct impl *__cself) {
    __Block_byref_val_0 *val = __cself->val;
    val->__forwarding->val = 1;
}
```
在这个func0中，我们可以看到，实际上，我们可以通过拿到当前Block结构体(即impl0)中的val，然后再通过val这个结构体(即__block编译出的结构体)找到最终的那个__block int val并赋值;
##### block都有哪几种类型的Block，__block的变量存储域
有Stack,Malloc,Global(数据区)
在block初始化的时候结构体__block_impl的isa指针会指向对应的block类型

```
//NSConcreteGlobalBlock
void(^blk)(void) = ^{printf("Global Block");};
int main() {
    //
}
//注意，全局Block是不能使用局部变量的
```
```
//NSConcreteStackBlock
int main() {
    void(^blk)(void) = ^{printf("Stack Block");};
}
```
GlobalBlock，任何地方都能访问，但是全局Block是不能使用局部变量的
StackBlock在ARC下其实已经没有了，一生成就会被编译器自动copy到堆上成为堆Block。通过编译后的代码可以看出一个StackBlock会初始化后将自己copy到堆上，然后加入到autoreleasepool中。
对于堆block，来说，是为了保证Block超出了作用域还能使用而存在的。如果一个Block是栈block，但是如果他需要在超过了作用域还需要存在，编译器会自动将他从栈复制到堆中。这个也是为啥Block的属性需要用copy，当然用strong也没什么问题，strong对应retain，block的retain实际上是由copy来实现。（苹果的原文copying block里说了，需要在作用域外使用block，copying block到heap）
然鹅有时候会因为编译器在特殊情况下是无法识别Block是否需要被copy，这时候得手动调用copy方法。反正对于block来说，调用copy就行，准没错
对于__block来说，当在栈上的时候，blk0和blk1使用它，如果blk0或blk1被复制到了堆上，那么__block这个被修饰的变量(即objc的对象)则会被一同复制过去的block持有，一个block持有引用计数+1，俩就+2。（因为__block的变量是对象）
对于__block里的__forwarding正是为了解决copy到堆上的问题。当被copy到堆上之后，新的__forwarding还是指向自己，但是老的__forwarding会指向新的，这样就能永远只访问同一个变量
##### block里面使用实例变量会造成循环引用吗
看实例变量是否被是否被强引用，看block是都被其他对象强引用
```
Person *person = [[Person alloc]init];
person.age = 20;
person.block = ^{
    NSLog(@"age is %d",person.age);
};
//编译后
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  Person *__strong person; // 对 person 产生了强引用
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, Person *__strong _person, int flags=0) : person(_person) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
```
由此看出，block里使用了person，那么block会持有person这个对象。但是person对象又持有了Block，那么就会循环引用
解决的办法有三个，__weak,_unsafe_unretain,还有__block
而__block的代码是：
```
Person *person = [[Person alloc]init];
__block Person *weakPerson = person;
person.age = 20;
person.block = ^{
    NSLog(@"my age is %d",weakPerson.age);
    //在 block 内部,把 person 对象置为nil
    weakPerson = nil;
};
person.block();
```
##### block为啥要用copy
文档说想要超过作用域使用，就要copy或者retain这个block，将他copying到heap中，这个是文档原文说的。所以Block和strong都可以，这个是MRC遗留下来的问题
然鹅有时候会因为编译器在特殊情况下是无法识别Block是否需要被copy，这时候得手动调用copy方法。反正对于block来说，调用copy就行，准没错


#### 底层
##### IMP、SEL、Method的区别
SEL是方法编号，也是方法名
IMP是函数实现指针，找IMP就是找函数实现的过程
Method就是具体的实现
SEL和IMP的关系就可以解释为：
SEL就相当于书本的⽬录标题
IMP就是书本的⻚码
Method就是具体页码对应的内容
SEL是在dyld加载镜像到内存时，通过_read_image方法加载到内存的表中了
##### Autoreleasepool实现原理
autoReleasepool的两个核心方法：objc_autoreleasePoolPush和objc_autoreleasePoolPop
自动释放池的释放过程大概就是objc_autoreleasePoolPush-> [objct autorelease] -> objc_autoreleasePoolPop
再往里面看，每次AutoreleasePoolPush/pop就是调用Page的push/pop
![](/images/autoreleasepool01.png)
从图片里可以看出AutoreleasePool是一个双向链表，每个节点就是栈指针，里面有对象和一个Page，大小是一页虚拟内存的大小(4KB)
```
AutoReleasePool的官方注释
/***********************************************************************
   Autorelease pool implementation

   A thread's autorelease pool is a stack of pointers. 
   Each pointer is either an object to release, or POOL_SENTINEL which is 
     an autorelease pool boundary.
   A pool token is a pointer to the POOL_SENTINEL for that pool. When 
     the pool is popped, every object hotter than the sentinel is released.
   The stack is divided into a doubly-linked list of pages. Pages are added 
     and deleted as necessary. 
   Thread-local storage points to the hot page, where newly autoreleased 
     objects are stored. 
**********************************************************************/
```
一个线程的autoreleasepool就是一个指针栈。
栈中存放的指针指向加入需要release的对象或者POOL_SENTINEL(哨兵对象，用于分隔autoreleasepool）。
栈中指向POOL_SENTINEL的指针就是autoreleasepool的一个标记。当autoreleasepool进行出栈操作，每一个比这个哨兵对象后进栈的对象都会release。
##### NSThread、NSRunLoop 和 AutoreleasePool
苹果不允许直接创建AutoreleasePool，但是可以获取Main和CurrentRunloop
线程和Runloop是一一对应的，保存在一个全局的Dictionary中。
子线程默认是没有开启runloop的，需要自己手动run。当线程结束的时候，runloop被回收，可以通过runloop线程保活。
线程会对应一个runloop
线程在RunloopPage可以得知会对应一个autoreleasepool
##### runtime的内存模型（isa、对象、类、metaclass、结构体的存储信息等）
![](/images/objc_class01.png)
```
struct objc_object {
    isa_t isa;
}
union isa_t {
    Class cls;
    uintptr_t bits;
    struct {
        uintptr_t nonpointer : 1;   //0代表普通指针，1表示优化过的
        uintptr_t has_assoc : 1;    //是否有关联对象
        uintptr_t has_cxx_dtor : 1; //是否有c++析构函数
        uintptr_t shiftcls : 33; // 内存地址信息MACH_VM_MAX_ADDRESS 0x1000000000
        uintptr_t magic : 6;    //调试
        uintptr_t weakly_referenced : 1;    //是否有鶸引用指向
        uintptr_t deallocating : 1; //是否正在释放
        uintptr_t has_sidetable_rc : 1;     //是否引用计数过大无法存在isa中
        uintptr_t extra_rc  : 8;    //有8位，2^7-1，引用计数过大这里会有值
    };
    ... //乱七八糟的信息
}
typedef struct objc_class *Class;
struct objc_class : objc_object {
    Class superclass;
    cache_t cache;             // formerly cache pointer and vtable
    class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags
    class_rw_t *data() {  
        return bits.data();
    }
    struct class_rw_t {  
        uint32_t flags;
        uint32_t version;
 
        const class_ro_t *ro;   //存储了当前类在编译期就已经确定的属性、方法以及遵循的协议
 
        method_array_t methods;
        property_array_t properties;
        protocol_array_t protocols;
 
        Class firstSubclass;
        Class nextSiblingClass;
    };
}
struct cache_t {
    struct bucket_t *_buckets;  //bucket_t则是存放着imp和key
    mask_t _mask;       //mask是缓存池的最大容量
    mask_t _occupied;   //occupied是缓存池缓存的方法数量
    struct bucket_t *buckets();
    mask_t mask();
    mask_t occupied();
    mask_t capacity();  //容量
    bool canBeFreed();
    void expand();
    ........
}

```
![](/images/rw_ro.png)

##### 为什么要设计metaclass
万物皆对象，类对象也能使用消息机制
每个类都有自己的metaclass有利于单一职责，不然就全写在NSObjct的Metaclass了，不好
##### id的本质是什么呢
```
typedef struct objc_object *id;
```
id是一个一个指向objc_object结构体的指针
##### runtime的API里class_copyIvarList & class_copyPropertyList区别
```
{
    NSString *str;
}
@property NSString *property;

//class_copyIvarList
str
_property
//class_copyPropertyList
property
```
class_copyIvarList能够获取.h和.m中的所有属性以及大括号中声明的成员变量，能获取属性的成员变量
class_copyPropertyList:只能获取由property声明的属性，包括.m中的，获取的属性名称不带下划线。
所以OC中没有真正的私有属性
##### category如何被加载的
在_objc_init->map_images->_read_images，然后将category的方法和类方法添加到对应的类里面
##### 两个category的load方法的加载顺序，两个category的同名方法的加载顺序呢，initialize,在继承关系中他们有什么区别
load在main前调用方法不管对象用不用都会调用，先调用父类，再调用子类
category的load是按照编译顺序来的，先编译的先调用，后编译的后调用
category的initialize是按照编译顺序来的，所有的initialize只调用一次，也就是最后编译的那个category中的initialize方法
##### category & extension区别，能给NSObject添加Extension吗，结果如何
category:
运行时添加分类属性/协议/方法
分类添加的方法会“覆盖”原类方法，因为方法查找的话是从头至尾，一旦查找到了就停止了
同名分类方法谁生效取决于编译顺序，读取的信息是倒叙的，所以编译越靠后的越先读入
extension:
编译时决议
只有.h文件，只以声明的形式存在，所以不能为系统类添加扩展
这东西就是用来访问自己写的类的私有方法的
##### 在方法调用的时候，方法查询-> 动态解析-> 消息转发 之前做了什么
检查selector是否需要忽略，比如retain和release这样的函数
检查target是不是为nil，如果是nil的话msg_send就会被忽略掉
之后就是在缓冲中找有没有方法，没有就去对象的method_list找，还没有就去父类中去找，还没找到就会到_objc_msgForward消息转发，还不行还有最后的一次机会包装NSInvocation给开发，还不行就崩溃了
##### weak的实现原理？SideTable的结构是什么样的
weak苹果是用的一个引用计数表进行管理
weak的管理表和引用计数表都是通过SideTables进行管理，SideTables全局的哈希表，由多个SideTable组成，一共有64个以对应的内存地址作为Key去查表
![](/images/sideTables01.jpeg)
SideTable里有有对应的自旋锁，用来加锁。这里苹果用的分离锁技术，自旋锁速度快，引用计数访问很频繁，只对单个表加锁，而不对整个SideTables一起加锁。对象通过自己的内存地址找到属于自己的SideTable。因为对象有很多很多，所以再查一次里面的RefcountMap这个Cpp的Map，查到对应的引用计数
同理，还有就是weak的管理，也是和这个类似，在SideTable的weak_table_t里找对应的对象
https://www.jianshu.com/p/ef6d9bf8fe59
##### ARC下的retain和release的优化（这个答案不确定对不对）
会对引用计数的溢出做处理，里面有一个extra_rc，如果溢出这个变量会有值
##### 简述一下Dealloc的实现机制
1.调用objc_rootdealloc()
2.rootdealloc()
3.object_dispose()  //dispose翻译是处理
4.objc_destructInstance()
    4.1:object_cxxDestruct:判断有没有关联Cpp的东西，删除掉
    4.2:_object_remove_assocations:去除和这个对象assocate的对象
    4.3:objc_clear_deallocating:清空引用计数表并清除弱引用表，将所有weak引用指nil（这也就是weak变量能安全置空的所在）
5.C的free()
##### 内存中的5大区分别是什么
栈区(stack):由编译器自动分配释放存放函数的参数值，局部变量的值等。其操作方式类似于数据结构中的栈。
堆区(heap):一般由程序员分配释放，若程序员不释放，程序结束时可能由OS回收。注意它与 数据结构中的堆是两回事，分配方式倒是类似于链表。
全局区(静态区)(static):全局变量和静态变量的存储是放在一块的，初始化的全局变量和静态变量在一块区域，未初始化的全局变量和未初始化的静态变量在相邻的另一块区域。程序结束后由系统释放。
常量区:常量就是放在这里的。程序结束后由系统释放。
程序代码区:存放函数体的二进制代码。
##### 一个NSObject对象占用多少内存
32位下，只使用了4字节
64位下一个NSObject对象都会分配16byte(字节)的内存空间。
但是实际会只使用了8字节
系统是按16的倍数来分配对象的内存大小的，比如一个对象占用40字节，系统会分配给他48字节
##### 内存管理方案
1.taggedPointer:由于NSNumber、NSDate一类的变量本身的值需要占用的内存大小常常不需要8个字节，所以将一个对象的指针拆成两部分，一部分直接保存数据，另一部分作为特殊标记，表示这是一个特别的指针，不指向任何一个地址，将值直接存储到了指针本身里。但是TaggedPointer因为并不是真正的对象，而是一个伪对象，所以你如果完全把它当成对象来使，可能会让它露马脚。所有对象都有 isa指针，而TaggedPointer其实是没有的具体的
![](/images/taggedpointer.png)
2.NONPOINTER_ISA--(非指针型的 isa) -> 感觉很像taggedPointer
3.SideTables
https://www.jianshu.com/p/c9089494fb6c
##### 访问__weak修饰的变量，是否已经被注册在了@autoreleasePool中?为什么?
会扔到autoreleasepool中，不然创建之后也就会销毁（之前做过assign的demo，生成之后就被释放），为了延长它的生命周期，必须注册到 @autoreleasePool中，以延缓释放。
##### BAD_ACCESS在什么情况下出现
就是野指针呗，访问一个已经被销毁的内存空间就会出现，调试方法用僵尸对象

#### 其他
##### 苹果如何实现远程推送的
1.应用服务提供商从服务器端把要发送的消息和设备令牌(Token啊，令牌啥的用户信息)发送给苹果的消息推送服务器 。
2.根据设备令牌在已注册的设备(iPhone、iPad、iTouch、mac 等)查找对应的设备，将消息发送给相 应的设备。 
3.客户端设备接将接收到的消息传递给相应的应用程序，应用程序根据用户设置弹出通知消息。
##### atomic是线程安全的吗
不是
首先atomic只是在get/set方法上加了@synchronized(self)
苹果开发文档已经明确指出：Atomic不能保证对象多线程的安全。它只是能保证你访问的时候给你返回一个完好无损的Value而已，线程安全需要开发者自己来保证。举个例子：
假设有一个 atomic 的属性 "name"，如果线程 A 调[self setName:@"A"]，线程 B 调[self setName:@"B"]，线程 C 调[self name]，那么所有这些不同线程上的操作都将依次顺序执行——也就是说，如果一个线程正在执行 getter/setter，其他线程就得等待。因此，属性 name 是读/写安全的。
但是，如果有另一个线程 D 同时在调[name release]，那可能就会crash，因为 release 不受 getter/setter 操作的限制。也就是说，这个属性只能说是读/写安全的，但并不是线程安全的，因为别的线程还能进行读写之外的其他操作。线程安全需要开发者自己来保证
另外，UI的atomic更没必要写，毕竟UI都是在主线程里
https://blog.csdn.net/u012903898/article/details/82984959

#### Category
##### Category能添加成员变量吗?
不能。只能通过关联对象(objc_setAssociatedObject)来模拟实现成员变量，但其实质是关联内容，所有对象的关联内容都放在同一个全局容器哈希表中:AssociationsHashMap,由 AssociationsManager统一管理。
##### 如果工程里有两个CategoryA和B，两个Category中有一个同名的方法，哪个方法最终生效?
取决于谁在后面被编译，最后编译的生效，她会覆盖之前的方法。这个覆盖并不是真正的覆盖，之前编译的方法都在只是访问不到。因为category动态编译的方法是倒叙遍历，所以最后编译的方法在最上层能被调用到


#### KVO，KVC
##### 如何手动调用KVO
手动调用willChangeValueForKey和didChangeValueForKey方法
被观察的属性会被重写，举个栗子：
```
 - (void)setNow:(NSDate *)aDate {
    [self willChangeValueForKey:@"now"];    //记录旧的值
    [super setValue:aDate forKey:@"now"];   //将新值赋值给旧值
    [self didChangeValueForKey:@"now"];     //判断willChangeValueForKey，如果有再调用observeValueForKeyPath
}
```
只调用didChangeValueForKey方法不可以触发KVO方法，因为willChangeValueForKey记录旧的值，如果不记录旧的值，那就没有改变一说了

##### KVC的的取值过程，原理是什么
EOC中有写
假如是改name值：[setValue:@"111" forKey:@"name"]
1.首先调用setName方法（就是setter)
2.如果没有找到setName方法，就去调用+(BOOL)accessInstanceVariablesDirectly，这个方法默认是返回YES。然后接着去找类似的变量_name，_isName，name，isName这样的顺序 
但是如果重写让他返回NO，就直接setValue:forUndefinedKey然后崩溃（一般没人这个做）
找的过程中就不管是公有方法还是私有方法了，所以会出现KVC被拒的情况。。。。因为用了苹果私有API
3.如果前面都没找到，就掉setValue:forUndefinedKey抛异常

##### valueForKey:@"name"的底层机制
和set类似，找getName，如果没有的话就按照_name，_isName，name，isName这样的顺序继续找，找不到就抛出异常
还会调用一些countOfName,enumaratorOfName之类的方法，记不清了

##### objectForKey和valueForKey区别
objectForKey文档上说The value associated with aKey, or nil if no value is associated with aKey
valueForKey文档上说The value for the property identified by key
也就是说
(id)valueForKey:(NSString *)key是KVC（key-value coding）的，如果没有找到对应的key会调用-(id)valueForUndefinedKey:(NSString )key从而抛出NSUndefinedKeyException异常，而objectForKey一般会返回一个nil
所以在使用NSDictionary取值时，尽量使用objectForKey

##### 通过直接赋值成员变量会触发KVO吗，KVC会触发KVO吗
不会。
因为kvo是通过isa-swizzling来实现的，被观察对象被runtimeNew一个出来，然后通过swizzling在seter方法上加上一个通知实现的
即使是用setter方法，也会触发KVO（看代码）
使用KVC也会，KVC也会调用setter方法
```
- (void)setName:(NSString *)name {
    _NSSetObjectValueAndNotify();
}
void _NSSetObjectValueAndNotify() {
    [self willChangeValue:"xxx"];
    [super setValue:value];
    [self didChangeValue:"xxx"];    //在这个didChange里面发送的通知
}
```
通过代码可以知道，其实要手动触发的话也得用willChangeValueForKey和didChangeValueForKey方法才行

#### UI相关
##### 图像显示原理
- CPU提交位图
    1.Layout: UI 布局，文本计算 
    2.Display: 绘制
    3.Prepare: 图片解码 
    4.Commit:提交位图
- GPU图层渲染，纹理合成，把结果放到帧缓冲区(frame buffer)中
- 再由视频控制器根据 vsync 信号在指定时间之前去提取帧缓冲区的屏幕显示内容
- 显示到屏幕上

iOS设备的硬件时钟会发出Vsync(垂直同步信号)
然后App的CPU会去计算屏幕要显示的内容，
之后将计算好的内容提交到GPU去渲染。
随后GPU将渲染结果提交到帧缓冲区，等到下一个VSync到来时将缓冲区的帧显示到屏幕上。
也就是说，一帧的显示是由CPU和GPU共同决定的。
YY的博客里有说过这个东西

##### UI卡顿掉帧原因
一帧的显示是由CPU和GPU共同决定的。页面滑动流畅是60fps，也就是1s有60帧更新，如果CPU和GPU共同处理的时间超过了1/60秒，就会感受到卡顿

##### 滑动优化方案
CPU：
可以吧这些东西放到子线程中：
1.耗时对象的创建与销毁，耗时操作都放在子线程
2.对一些计算，排版进行预处理（tableView的缓存高度）
3.预渲染，异步绘制（文本的异步绘制，图片的异步解码，CoreGraphic是线程安全，CALayer和UIView不是）
4.用轻量级的控件，比如CALayer替换UIView

GPU:
是否受到CPU或者GPU的限制? 
是否有不必要的CPU渲染? 
是否有太多的离屏渲染操作? 
是否有太多的图层混合操作? 
是否有奇怪的图片格式或者尺寸? 
是否涉及到昂贵的view或者效果? 
view的层次结构是否合理?
文本渲染：屏幕上能看到的所有文本内容控件，包括UIWebView，在底层都是通过CoreText排版、绘制为位图显示的。常见的文本控件，其排版与绘制都是在主线程进行的，显示大量文本是，CPU压力很大。对此解决方案唯一就是自定义文本控件，用CoreText对文本异步绘制。（很麻烦，开发成本高）
当用UIImage或CGImageSource创建图片时，图片数据并不会立刻解码。图片设置到UIImageView或CALayer.contents中去，并且CALayer被提交到GPU前，CGImage中的数据才会得到解码。这一步是发生在主线程的，并且不可避免。SD_WebImage处理方式：在后台线程先把图片绘制到CGBitmapContext中，然后从Bitmap直接创建图片。
图像绘制：图像的绘制通常是指用那些以CG开头的方法把图像绘制到画布中，然后从画布创建图片并显示的一个过程。CoreGraphics方法是线程安全的，可以异步绘制，主线程回调。
##### iOS从磁盘加载一张图片，使用UIImageVIew显示在屏幕上，需要经过步骤
1.从磁盘拷贝数据到内核缓冲区
2.从内核缓冲区复制数据到用户空间
3.生成UIImageView，把图像数据赋值给UIImageView
如果图像数据为未解码的PNG/JPG，解码为位图数据
4.CATransaction捕获到UIImageView layer树的变化
5.主线程Runloop提交CATransaction，开始进行图像渲染
6.1 如果数据没有字节对齐，Core Animation会再拷贝一份数据，进行字节对齐。
6.2 GPU处理位图数据，进行渲染。
##### UI绘制原理
1.当我们调用[UIView setNeedsDisplay]这个方法时，其实并没有立即进行绘制工作，系统会立即调用CALayer的同名方法，并且在当前layer上打上一个标记，然后会在当前runloop将要结束(beforewaiting)的时候调用[CALayer display]这个方法，然后进入视图的真正绘制过程
2.在[CALayer display]这个方法的内部实现中会判断这个layer的delegate是否响应displaylayer这个方法，如果不响应这个方法，就回到系统绘制流程中，如果响应这个方法，那么就会为我们提供异步绘制的入口
[self.layer.delegate displayLayer: ]
##### 异步绘制的实现
1、假如我们在某一时机调用了[view setNeedsDisplay]这个方法，系统会在当前runloop将要结束的时候调用[CALayer display]方法，然后如果我们这个layer代理实现了displaylayer这个方法
2、然后切换到子线程去做位图的绘制，主线程可以去做其他的操作
3、在自吸纳成中创建一个位图的上下文，然后通过CoregraphIC API可以做当前UI控件的一些绘制工作，最后再通过CGBitmapContextCreateImage()函数来生成一直CGImage图片
4、最后回到主线程来提交这个位图，设置layer的contents 属性，这样就完成了一个UI控件的异步绘制
具体做法：
先创建一个CALayer子类，重写display方法，添加displayAsync方法。这样只要外部创建添加了该layer后调用setNeedsDisplay方法，就会运行display方法。
在displayAsync方法中，我们创建了一个串行队列，添加了一个异步任务来画图片
##### 离屏渲染
当前屏幕渲染：GPU的渲染操作是在用于当前屏幕显示的缓冲区进行的
离屏渲染：在当前缓冲区外开辟一个新的缓冲区进行渲染（这个是要尽量避免的）
离屏渲染代价高昂的原因：
1.开辟新的缓冲区
2.切换渲染的上下文。因为要从当前屏和离屏之间切换，涉及到上下文切换，这一部分很消耗时间，会消耗大量GPU资源，有可能会导致CPU+GPU处理时间超过1/60秒导致掉帧
离屏渲染触发条件：
1.设置layer.cornerRadius和masksToBounds
2.设置遮罩layer.mask
3.设置layer.opacity
4.设置layer.shadow
5.shouldRasterize（光栅化）
优化方案：
使用贝塞尔曲线UIBezierPath和Core Graphics框架画出一个圆角
UI流畅和优化相关的文章看YY的文章http://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/#6
##### UIButton的继承链
UIButton -> UIControl -> UIView -> UIResponder -> NSObject

##### 图层混合
当两个不完全透明的视图叠加在一起的时候(当alpha在0和1之间的时候)，GPU会做大量的计算，这种操作越多，那么消耗的性能越大。当alpha为1的时候，GPU会直接把最上层的渲染出来，不用换下面的图层

##### opaque的坑（opaque不透明）
opaque在苹果文档里有说明，如果opaque设置为YES，绘图系统会将view看为完全不透明，这样绘图系统就可以优化一些绘制操作以提升性能。如果设置为NO，那么绘图系统结合其它内容来处理view。默认情况下，这个属性是YES。
这个东西和图层混合的道理差不多，如果为NO（他是透明），那么系统会以为他盖住的layer也要展示，会做很多计算所以可以将opaque设置为YES
UIView是默认的YES，UIButton是NO

##### 如何对代码进行性能优化
静态分析Analyze
debug->View Debuging里可以看离屏渲染，图层混合等等
还有在Instrument里找对应的需要优化的选项CoreAnimation里看CPU/GPU的使用率，帧数等等，Leak看泄露，僵尸对象

##### TableView优化
正确使用reuseIdentifier来重用cells
避免过于庞大的XIB
.....太多了。。

##### UIImage加载图片性能问题
imageNamed系统会缓存，imageWithContentsOfFile不会，所以小图可以用imageName,如果大图还用会内存长得快

不要在UIImageView使用的时候去缩放图片，你应保证图片的大小和UIImageView的大小相同，在ScrollView搞这个东西非常耗性能，如果一个图片需要缩放，最好在子线程中缩放好了再给他放到UIImageView里（绘本优化的时候遇到过）

##### 光栅化
位图：图像没有被栅格化之前任意放大，都不会失帧。而栅格化化之后如果随着放大的倍数在增加，失帧会随着倍数的增加而增加。故：栅格化本身就是生成一个固定像素的图像。

光栅化概念：将图转化为一个个栅格组成的图象（就是位图，又称栅格图或点阵图）。
shouldRasterize = YES在其他属性触发离屏渲染的同时，会将光栅化后的内容缓存起来，如果对应的layer及其sublayers没有发生改变，在下一帧的时候可以直接复用。shouldRasterize = YES，这将隐式的创建一个位图，各种阴影遮罩等效果也会保存到位图中并缓存起来，从而减少渲染的频度
比如某个页面卡，可以开启光栅化。让位图缓存复用，如果能成功复用，就会有性能提升。性能的提升取决于多少被复用了。具体的复用在xcode的debug->viewDebuging里instrument看“Color Hits Green and Misses Red”
因此栅格化仅适用于较复杂的、静态的效果，别再TableView里用，离屏渲染过多性能消耗会得不偿失，而且有时候使用光栅化经常出现未命中缓存的情况

##### 如何高性能的画一个圆角
视图和圆角的大小对帧率并没有什么卵影响，数量才是伤害的核心输出
如果能够只用cornerRadius解决问题，就不用优化。
如果必须设置masksToBounds，可以参考圆角视图的数量，如果数量较少(一页只有几个)也可以考虑不用优化
最后可以用贝塞尔曲线画圆角CoreGraphics





------





#### 多线程与锁
##### 进程和线程
进程：
进程是一个程序执行的过程，一个程序至少有一个进程，
进程是操作系统资源分配的基本单位
进程是一个独立单位，进程有自己的内存空间，拥有独立运行所需的全部资源
线程：
程序执行流的最小单元，线程是进程中的一个实体.
一个进程要想执行任务,必须至少有一条线程.应用程序启动的时候，系统会默认开启一条线程,也就是主线程
进程和线程的关系：
线程是进程的执行单元，进程的所有任务都在线程中执行
线程是CPU分配资源和调度的最小单位
一个程序有多个进程，一个进程有多个线程
同一个进程内的线程共享进程资源

##### 任务和队列
同步任务sync:
阻塞当前线程，不具备开启新线程的能力
异步任务async:
不阻塞当前线程，具备开启新线程的能力(并不一定开启新线程)。如果不是添加到主队列上，异步会在子线程中执行任务

串行队列(Serial):FIFO，同一时间一个队列的任务只能执行一个，完事了之后才能执行下一个
并发队列(Concurrent):FIFO同时允许多个任务并发执行。(可以开启多个线程，并且同时执行任务)。并发队列的并发功能只有在异步任务(dispatch_async)函数下才有效
两者区别：执行顺序不同，以及开启线程数不同。

系统获得队列的方式有三个：
mainQueue:主线程串行队列
globalQueue:系统提供的全局并发队列，存在着高、中、低三种优先级
自定义队列:dispatch_queue_create


##### GCD对比NSOprationQueue
GCD是C语言，NSOprationQueue是GCD的OC封装
NSOperationQueue因为面向对象，所以支持KVO，可以监测正在执行(isExecuted)、是否结束(isFinished)、是否取消(isCanceld)
相比GCD，NSOperationQueue的粒度更细腻，支持更复杂的操作。但是iOS开发中大部分都只会遇到异步操作，不会有很复杂的线程管理，所以GCD更轻量便捷，但是如果考虑复杂的线程操作，那么GCD代码量会暴增，NSOperationQueue会更简便一些

##### 自旋锁与互斥锁（mutex）的区别
自旋锁和互斥锁的区别在于
1:自旋锁时候忙等，就是说上一个线程被锁后，当前线程不会休眠，而是不停的去检查锁是否可用，当上一个线程完事后当前线程立即执行
2:互斥锁是上一个线程被锁住后当前线程休眠，此时CPU会去执行其他任务。当上一个线程完成后，当前线程再被唤醒执行
优缺点：
自旋锁不会引起休眠，所以没有线程调度所以速度快，但是因为当前线程会不停检查是否解锁所以会占用CPU资源，所以自旋锁适合于那种很短时间的操作（sideTable,atomic），而不适合那种时间较长的锁。互斥锁正好反着
自旋锁：gcd信号量（semp）
互斥锁：@syncoized,pthread_mutex,NSLock,NSConditoin,NSConditionLock，NSRecursiveLock（递归锁，在调用 lock 之前，NSLock 必须先调用 unlock。但正如名字所暗示的那样， NSRecursiveLock 允许在被解锁前锁定多次。如果解锁的次数与锁定的次数相匹配，则 认为锁被释放）

##### 线程死锁的四个条件
？？？
##### 自旋锁和互斥锁的区别
？？？
##### 多进程间的通讯
？？？
##### 开启一条线程的方法
？？？
##### 线程可以取消吗
？？？
##### 那子线程中的autorelease变量什么时候释放？
？？？
##### 子线程里面，需要加autoreleasepool吗
？？？
##### GCD和NSOperation的区别？
？？？
##### 线程常驻
AFN？？？
##### 子线程与AutoreleasePool
AFN？？？





------






#### runloop
##### 循环的细节
![](/images/runloop_001.png)
```
{
    /// 1. 通知Observers，即将进入RunLoop
    /// 此处有Observer会创建AutoreleasePool: _objc_autoreleasePoolPush();
    __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopEntry);
    do {

        /// 2. 通知 Observers: 即将触发 Timer 回调。
        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeTimers);
        /// 3. 通知 Observers: 即将触发 Source (非基于port的,Source0) 回调。
        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeSources);
        __CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__(block);

        /// 4. 触发 Source0 (非基于port的) 回调。
        __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__(source0);
        __CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__(block);

        /// 6. 通知Observers，即将进入休眠
        /// 此处有Observer释放并新建AutoreleasePool: _objc_autoreleasePoolPop(); _objc_autoreleasePoolPush();
        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeWaiting);

        /// 7. sleep to wait msg.
        mach_msg() -> mach_msg_trap();


        /// 8. 通知Observers，线程被唤醒
        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopAfterWaiting);

        /// 9. 如果是被Timer唤醒的，回调Timer
        __CFRUNLOOP_IS_CALLING_OUT_TO_A_TIMER_CALLBACK_FUNCTION__(timer);

        /// 9. 如果是被dispatch唤醒的，执行所有调用 dispatch_async 等方法放入main queue 的 block
        __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__(dispatched_block);

        /// 9. 如果如果Runloop是被 Source1 (基于port的) 的事件唤醒了，处理这个事件
        __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE1_PERFORM_FUNCTION__(source1);


    } while (...);

    /// 10. 通知Observers，即将退出RunLoop
    /// 此处有Observer释放AutoreleasePool: _objc_autoreleasePoolPop();
    __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopExit);
}


int32_t __CFRunLoopRun()
{
    //通知即将进入runloop
    __CFRunLoopDoObservers(KCFRunLoopEntry);
     
    do
    {
        // 通知将要处理timer和source
        __CFRunLoopDoObservers(kCFRunLoopBeforeTimers);         
        __CFRunLoopDoObservers(kCFRunLoopBeforeSources);
         
        __CFRunLoopDoBlocks();  //处理非延迟的主线程调用
        __CFRunLoopDoSource0(); //处理UIEvent事件
         
        //GCD dispatch main queue
        CheckIfExistMessagesInMainDispatchQueue();
         
        // 即将进入休眠
        __CFRunLoopDoObservers(kCFRunLoopBeforeWaiting);
         
        // 等待内核mach_msg事件
        mach_port_t wakeUpPort = SleepAndWaitForWakingUpPorts();
         
        // Zzz...
         
        // 从等待中醒来
        __CFRunLoopDoObservers(kCFRunLoopAfterWaiting);
         
        // 处理因timer的唤醒
        if (wakeUpPort == timerPort)
            __CFRunLoopDoTimers();
         
        // 处理异步方法唤醒,如dispatch_async
        else if (wakeUpPort == mainDispatchQueuePort)
            __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__()
             
        // UI刷新,动画显示
        else
            __CFRunLoopDoSource1();
         
        // 再次确保是否有同步的方法需要调用
        __CFRunLoopDoBlocks();
         
    } while (!stop && !timeout);
     
    //通知即将退出runloop
    __CFRunLoopDoObservers(CFRunLoopExit);
}
```

##### 线程保活的时候，用RunloopMode的时候能用CommonMode吗
不可以
我记得源码里有写，如果是commonMode会return掉，只能用default（7月18/19逻辑教育讲MachPort有源码，里面有说这个)

##### AutoReleasePool什么时候释放?
entry监听回调里会有_objc_autoreleasePoolPush() 创建自动释放池，且优先级最高，保证创建释放池发生在其他所有回调之前。
BeforeWaiting(准备进入休眠)时调用_objc_autoreleasePoolPop()和_objc_autoreleasePoolPush()释放旧的池并创建新池
Exit(即将退出Loop)时调用_objc_autoreleasePoolPop()来释放自动释放池。这个Observer优先级最低，保证其释放池子发生在其他所有回调之后
孙源的Runloop分享里说过，在当前runloop结束之后和下一次runloop结束之前调用drain方法
##### 解释下事件响应过程
硬件的监听器发现有硬件的事件发生后（触摸，摇晃，锁屏等等），由IOKit生成一个IOEvent事件然后由MachPort转发给对应的App进程，然后source1会接受这个事件，调用ApplicationHandleEventQueue进行内部分发，然后将IOEvent包装成UIEvent进行处理分发，比如UIButton的点击，touchBegin等等
##### 解释一下手势识别的过程
当App收到ApplicationHandleEventQueue分发的IOEvent之后，会先canle掉当前的touchesBegin/Move/End的回调，并将对应的UIGestureRecognizer标记为待处理。
当runloop为将要进入休眠的时候（Beforewaiting），会获取到所有的UIGestureRecognizer，然后执行所有的手势识别
##### 解释一下页面的渲染的过程
渲染过程，包括像动画效果，我们项目中的inMainThread（这里是因为mainThread的runloopCallOut是在Pop和Push之间，应该也是在Beforwaiting的时候），都是在beforewaiting(即将休眠的时候)的时候被系统捕获这些被打了标记的对象，然后统一作出处理。
layer会调用[CALyer display]，进入到真正的绘制过程。接下来就是通过判断看是否是异步绘制代理方法func display(_ layer: CALayer)，如果有异步绘制的代理方法，则走异步绘制func display(_ layer: CALayer)方法
如果没有的话走系统绘制方法。
系统绘制：
layer会创建backingStore获取上下文CGContextRef,
接下来判断是否有layer.delegate代理
如果有：
调用layer.delegate drawLayer:inContext:，
接着返回UIVew drawRect回调，让我们在系统绘制的基础上，再做一些其他的事情
如果没有：CALayer drawInContext
走完后，CALayer上传backingStore给GPU，结束
异步绘制：
直接走func display(_ layer: CALayer)方法，里面dispatchAsyncGlobal，然后再dispatch到Main的过程中吧异步生成的东西赋值给layer.contents，结束

##### 什么是异步绘制
layer会创建backingStore获取上下文CGContextRef,
接下来判断是否有代理
如果有：
调用layer.delegate drawLayer:inContext:，
接着返回UIVew drawRect回调，让我们在系统绘制的基础上，再做一些其他的事情
如果没有：CALayer drawInContext
走完后，CALayer上传backingStore给GPU，结束

#### 算法
##### 判断单向链表是否有环
快指针和慢指针解决，一个指针每次走1个节点，一个指针每次都2个节点，如果有交点，那么必定会相遇

#### 优化

#### 计算机基础
##### 哈希表和哈希函数
哈希表又叫散列表，是根据关键码值（Key-Value）而直接进行访问的数据结构，也就是我们常用到的map。
哈希函数：也称为是散列函数，是Hash表的映射函数，它可以把任意长度的输入变换成固定长度的输出，该输出就是哈希值（哈希算法）。哈希函数能使对一个数据序列的访问过程变得更加迅速有效，通过哈希函数数据元素能够被很快的进行定位。如果一个函数实现了哈希算法，就称这个函数为哈希函数


#### APM监控
https://juejin.im/post/5ef6930fe51d4534a361530a?utm_source=gold_browser_extension#heading-32