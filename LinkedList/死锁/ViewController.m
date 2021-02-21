//
//  ViewController.m
//  死锁
//
//  Created by 赵贺 on 2021/2/21.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self queue];
//    [self queue1];
//    [self queue2];
//    [self queue3];
    [self queue4];
}

// 死锁
- (void)queue {
    NSLog(@"task1");
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        [self test];
    });
    NSLog(@"task3");
}

// 不会产生死锁
- (void)queue1 {
    NSLog(@"task1");
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self test];
    });
    NSLog(@"task3");
}

- (void)test {
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"task2");
    });
}

// 死锁
- (void)queue2 {
    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{//0
        NSLog(@"task1");
        // 串行队列 需要 block_0 执行完 再执行block_1，因此产生死锁

        dispatch_sync(queue, ^{//1
            NSLog(@"task2");
        });
        NSLog(@"task3");
    });
    NSLog(@"task4");
}

- (void)queue3 {
    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{//0
        NSLog(@"task1");
        // 并发队列 不需要 block_0 执行完 再执行block_1
        dispatch_sync(queue, ^{//1
            NSLog(@"task2");
        });
        NSLog(@"task3");
    });
    NSLog(@"task4");
}

- (void)queue4 {
    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("myqueue", DISPATCH_QUEUE_SERIAL);

    dispatch_async(queue, ^{
        NSLog(@"task1");
        dispatch_sync(queue2, ^{
            NSLog(@"task2");
        });
        NSLog(@"task3");
    });
    NSLog(@"task4");
}

@end
