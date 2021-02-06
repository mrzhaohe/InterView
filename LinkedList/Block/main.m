//
//  main.m
//  Block
//
//  Created by 赵贺 on 2021/1/25.
//

#import <Foundation/Foundation.h>

int a = 10;
static int b = 10;

void(^block)(void);

void test() {
//
//    int a = 10;
//    static int b = 10;
    block = ^{
        NSLog(@"a is %d, b is %d", a, b);
    };
    
    a = 20;
    b = 20;
    
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        test();
        block();
        
//        ^{
//            NSLog(@"Hello, block!");
//        }();
        
//        void (^block)(void) = ^{
//            NSLog(@"Hello, block!");
//        };
//
//        block();
        
//        int age = 10;
//        void (^block)(int, int) = ^(int a, int b){
//            NSLog(@"Hello, block! -- %d", age);
//        };
//
//        block(1,1);
        
        
        
    }
    return 0;
}
