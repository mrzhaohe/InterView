//
//  main.m
//  队列
//
//  Created by 赵贺 on 2021/1/26.
//

#import <Foundation/Foundation.h>

static inline void barrier()
{
    dispatch_queue_t queue = dispatch_queue_create("ph", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"dispatch_async1");
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"dispatch_async2");
    });
    
    //等待前面的任务执行完毕后自己才执行，后面的任务需等待它完成之后才执行
    dispatch_barrier_sync(queue, ^{
        NSLog(@"dispatch_barrier_async");
        [NSThread sleepForTimeInterval:4];
        NSLog(@"四秒后：dispatch_barrier_async");
        
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"dispatch_async3");
    });
    dispatch_async(queue, ^{
        
        NSLog(@"dispatch_async4");
    });
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        barrier();
    }
    return 0;
}
