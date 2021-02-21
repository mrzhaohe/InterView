//
//  main.m
//  serial__concurrent
//
//  Created by 赵贺 on 2021/2/21.
//

#import <Foundation/Foundation.h>


void test1 () {
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"task2");
    });
    
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
//        dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
//
//
//        dispatch_async(queue, ^{
//            for (int i = 0; i < 10; i++) {
//                NSLog(@"task1 -- %d", i);
//            }
//        });
        
        
//        dispatch_sync(queue, ^{
//            for (int i = 0; i < 10; i++) {
//                NSLog(@"task2 -- %d", i);
//            }
//        });
        
        
        NSLog(@"task1");
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            test1();
        });
        NSLog(@"task3");
        
    }
    return 0;
}
