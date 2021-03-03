//
//  ViewController.m
//  读写锁_多读单写
//
//  Created by 赵贺 on 2021/3/3.
//

#import "ViewController.h"
#import <pthread.h>


@interface ViewController ()

@property (nonatomic, assign) pthread_rwlock_t lock;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    pthread_rwlock_init(&_lock, NULL);//初始化
    pthread_rwlock_rdlock(&_lock);//读锁
    pthread_rwlock_wrlock(&_lock);//写锁
    pthread_rwlock_unlock(&_lock);//解锁

    for (int i =0; i < 10; i++) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self read];
        });
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self write];
        });
    }
}

- (void)read {
    
    pthread_rwlock_rdlock(&_lock);
    sleep(1);
    NSLog(@"%s",__func__);
    
    pthread_rwlock_unlock(&_lock);
}

- (void)write {
    
    pthread_rwlock_wrlock(&_lock);
    sleep(1);
    NSLog(@"%s",__func__);
    pthread_rwlock_unlock(&_lock);
    
}

@end
