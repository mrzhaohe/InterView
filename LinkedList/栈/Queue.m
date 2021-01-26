//
//  Queue.m
//  栈
//
//  Created by 赵贺 on 2021/1/26.
//

#import "Queue.h"
#import "Stack.h"

@interface Queue ()

@property (nonatomic, strong) Stack *inStack;
@property (nonatomic, strong) Stack *outStack;

@end

@implementation Queue


- (instancetype)init {
    self = [super init];
    if (self) {
        self.inStack = [Stack new];
        self.outStack = [Stack new];
    }
    return self;
}

/// 长度
- (NSUInteger)size {
    
    return [self.inStack size] + [self.outStack size];
}


/// 队列是否为空
- (BOOL)isEmpty {
    return self.inStack.size == 0 && self.outStack.size == 0;
}


/// 入队
/// @param element obj
- (void)enQueue:(id)element {
    [self.inStack push:element];
}


/// 队头
- (id)front {
    if (self.outStack.isEmpty) {
        while (!self.inStack.isEmpty) {
            [self.outStack push:[self.inStack pop]];
        }
    }
    return self.outStack.top;
}


/// 出队
- (id)deQueue {
    if (self.outStack.isEmpty) {
        while (!self.inStack.isEmpty) {
            [self.outStack push:[self.inStack pop]];
        }
    }
    return [self.outStack pop];
}


/// 清空
- (void)clear {
    while (!self.inStack.isEmpty) {
        [self.inStack pop];
    }
    
    while (!self.outStack.isEmpty) {
        [self.outStack pop];
    }
}

@end
