//
//  main.m
//  Block
//
//  Created by 秦翌桐 on 2021/1/25.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {

//        ^{
//            NSLog(@"Hello, block!");
//        }();
        
//        void (^block)(void) = ^{
//            NSLog(@"Hello, block!");
//        };
//
//        block();
        
        int age = 10;
        void (^block)(int, int) = ^(int a, int b){
            NSLog(@"Hello, block! -- %d", age);
        };
        
        block(1,1);
        
        
        
    }
    return 0;
}
