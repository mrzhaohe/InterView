//
//  ViewController.m
//  LockDemo
//
//  Created by 赵贺 on 2021/2/22.
//

#import "ViewController.h"

#import "OSSpinLockDemo.h"
#import "OSUnfairLockDemo.h"
#import "pthread_MutexDemo.h"
#import "pthread_Mutex2Demo.h"
#import "pthread_mutex_condition_demo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BaseLockDemo *lock;
    
    // osspinlock 自旋锁
//    lock = [OSSpinLockDemo new];
    
    //un_fair_lock
//    lock = [OSUnfairLockDemo new];

    //pthread_mutex (normal)
//    lock = [pthread_MutexDemo new];
    
    // pthread_mutex 递归锁
    lock = [pthread_mutex2Demo new];
    
    //
    lock = [pthread_mutex_condition_demo new];
    [lock otherTest];
//    [lock moneyTest];
//    [lock ticketTest];
    
}


@end
