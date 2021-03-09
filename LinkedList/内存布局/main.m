//
//  main.m
//  内存布局
//
//  Created by 秦翌桐 on 2021/3/4.
//

#import <Foundation/Foundation.h>

int b = 0;
int d;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
     /**
//        保留区
//        代码段
        编译之后的代码
//        数据段
        字符串常量
        已初始化的全局变量、静态变量
        未初始化的全局变量、静态变量
//        堆
        alloc、malloc、calloc 等动态分配的空间 分配的空间越来越大
//        栈
        函数调用开销、局部变量
//        内核区
        **/
        
        static int c = 10;
        
        static int d;
        
        
        NSObject *obj;
        NSObject *obj1 = [NSObject new];
        
        int e;
        int f = 10;
        NSString *a = @"123";
        
        NSLog(@"\n&a=%p\n&b=%p\n&c=%p\n&d=%p\n&e=%p\n&f=%p\nobj=%p\nobj1=%p", &a, &b, &c,&d,&e, &f, obj, obj1);
        
        
    }
    return 0;
}
