//
//  ViewController.m
//  线程与Runloop
//
//  Created by 赵贺 on 2021/2/22.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self asyncWithRunloop];
    
}

- (void)asyncWithRunloop {
    
    // 子线程默认不开启 runloop 需手动开启
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        NSLog(@"task1");
        
        [self performSelector:@selector(test) withObject:nil afterDelay:.0];
        
        NSLog(@"task3");
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    });
}

- (void)test {
    NSLog(@"task2");
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"task1");
        //需要线程保活
//        [[NSRunLoop currentRunLoop] addPort:[NSPort new] forMode:NSDefaultRunLoopMode];
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];

    }];
    [thread start];
    // 执行 test 的时候 thread 有可能销毁了
    [self performSelector:@selector(test) onThread:thread withObject:nil waitUntilDone:YES];
    
}

@end
