//
//  main.m
//  栈
//
//  Created by 赵贺 on 2021/1/26.
//

#import <Foundation/Foundation.h>

#import "Stack.h"

#import "Queue.h"

void testStack() {
    Stack *stack = [Stack new];
    [stack push:@(10)];
    [stack push:@"1111"];
    [stack push:[NSObject new]];
    NSLog(@"%@", stack);
    [stack pop];
    NSLog(@"%@", stack);
}

void testQueue() {
    Queue *queue = [Queue new];
    [queue enQueue:@(10)];
    [queue enQueue:@(20)];
    [queue deQueue];
    [queue enQueue:@(30)];
    while (!queue.isEmpty) {
        NSLog(@"%@", [queue deQueue]);
    }
    
    
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
//        testStack();
        testQueue();

    }
    return 0;
}
