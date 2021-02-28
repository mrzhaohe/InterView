//
//  ViewController.m
//  OSSpinLock
//
//  Created by 赵贺 on 2021/2/22.
//

#import "ViewController.h"
#import <libkern/OSAtomic.h>


@interface ViewController ()

@property (nonatomic, assign) int ticketsCount;

@property (nonatomic, assign) int money;

@property (nonatomic, assign) OSSpinLock lock;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.lock = OS_SPINLOCK_INIT;
    
//    [self testTicket];
    [self moneyTest];
}


/**
 存钱、取钱演示
 */
- (void)moneyTest
{
    self.money = 100;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self saveMoney];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self drawMoney];
        }
    });
}

/**
 存钱
 */
- (void)saveMoney
{
    
    OSSpinLockLock(&_lock);
    
    int oldMoney = self.money;
    sleep(.2);
    oldMoney += 50;
    self.money = oldMoney;
    
    NSLog(@"存50，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
    
    OSSpinLockUnlock(&_lock);
}

/**
 取钱
 */
- (void)drawMoney
{
    
//    OSSpinLockTry 尝试加锁 不会阻塞线程
//    if (OSSpinLockTry(&_lock)) {}
    
    OSSpinLockLock(&_lock);

    int oldMoney = self.money;
    sleep(.2);
    oldMoney -= 20;
    self.money = oldMoney;
    
    NSLog(@"取20，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
    
    OSSpinLockUnlock(&_lock);
}

- (void)saleTicket {
    
    int oldTicketCount = self.ticketsCount;
    sleep(.2);
    oldTicketCount--;

    self.ticketsCount = oldTicketCount;
    NSLog(@"还剩%d张票", oldTicketCount);
    
}


- (void)testTicket {
    self.ticketsCount = 15;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
             [self saleTicket];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self saleTicket];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self saleTicket];
        }
    });
}


@end
