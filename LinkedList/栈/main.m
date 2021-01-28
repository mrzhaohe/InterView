//
//  main.m
//  栈
//
//  Created by 赵贺 on 2021/1/27.
//

#import <Foundation/Foundation.h>
#import "Stack.h"

void testStack() {
    Stack *stack = [Stack new];
    [stack push:@(10)];
    [stack push:@"1111"];
    [stack push:[NSObject new]];
    NSLog(@"%@", stack);
    [stack pop];
    NSLog(@"%@", stack);
}
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        testStack();
    }
    return 0;
}
