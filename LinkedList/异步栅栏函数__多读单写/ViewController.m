//
//  ViewController.m
//  异步栅栏函数__多读单写
//
//  Created by 秦翌桐 on 2021/3/4.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i =0; i < 10; i++) {
//        [self read];
        [self write];
    }

}

- (void)read {
    dispatch_async(self.queue, ^{
        NSLog(@"read");
        sleep(1);
    });
}

- (void)write {
    dispatch_barrier_async(self.queue, ^{
        NSLog(@"write");
        sleep(1);
    });
}


@end
