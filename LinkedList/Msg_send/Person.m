//
//  Person.m
//  Msg_send
//
//  Created by 赵贺 on 2021/1/28.
//

#import "Person.h"

#import "Dog.h"
#import <objc/runtime.h>



@implementation Person

//1.0 动态方法解析
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    if (sel == @selector(run)) {
        return NO;//返回 NO， 才会执行第二步
    }
    return [super resolveInstanceMethod:sel];
}

//2.0 快速转发
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(run)) {
//        return  [Dog new]; //替换其他消息接受者
        return nil; //返回nil 则会走到第3阶段，完全消息转发机制（慢速转发）
    }
    return  [super forwardingTargetForSelector:aSelector];
}

//3.1 方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    if (aSelector == @selector(run)) {
        Dog *dog = [Dog new];
        return [dog methodSignatureForSelector:aSelector];
    }
    return [super methodSignatureForSelector:aSelector];
}

//3.2
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    Dog *dog = [Dog new];
    if ([dog respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:dog];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

//4.0
- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"%s", __func__);
}


@end
