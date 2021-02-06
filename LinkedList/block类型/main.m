//
//  main.m
//  block类型
//
//  Created by 秦翌桐 on 2021/2/6.
//

#import <Foundation/Foundation.h>
#import "Person.h"
// data 区
int a = 0;

void test() {
    //堆：动态分配内存 （alloc）
    //栈：局部变量 系统自动分配内存

    //globleBlock 没有访问 auto 变量 （访问 static 和 全局变量仍然是 globleBlock）
    void(^block1)(void) = ^{
        
    };
    
    //stackBlock 访问了 auto 变量 (MRC 下能打印出来, ARC下会自动调动 copy ---> mallocBlock)
    int age = 10;
    void(^block2)(void) = ^ {
        NSLog(@"age is %d", age);
    };
    
    //mallocBlock ----> stackBlock 调用了 copy

    NSLog(@"%@", [block1 class]);
    NSLog(@"%@", [block2 class]);
    NSLog(@"%@", [^{
        NSLog(@"age is %d", age);
    } class]);
}

void address() {
    
    // 全局变量在data区
    NSLog(@"数据段 %p", &a);
    
    //局部变量在栈
    int age = 10;
    NSLog(@"栈 %p", &age);
    
    // alloc 出来的在堆上
    NSLog(@"堆 %p", [[NSObject alloc] init]);
    
    NSLog(@"数据段 %p", [Person class]);

}



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
//        test();
        address();
        
    }
    return 0;
}



