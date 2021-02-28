//
//  OSSpinLockDemo.m
//  LockDemo
//
//  Created by 赵贺 on 2021/2/22.
//

#import "OSSpinLockDemo.h"
#import <libkern/OSAtomic.h>


@interface OSSpinLockDemo ()

@property (nonatomic, assign) OSSpinLock moneyLock;
@property (nonatomic, assign) OSSpinLock ticketLock;

@end

@implementation OSSpinLockDemo


- (instancetype)init {
    self = [super init];
    if (self ) {
        _moneyLock = OS_SPINLOCK_INIT;
        _ticketLock = OS_SPINLOCK_INIT;
    }
    return self;;
}

- (void)saveMoney {
    OSSpinLockLock(&_moneyLock);
    [super saveMoney];
    OSSpinLockUnlock(&_moneyLock);
}

- (void)drawMoney {
    OSSpinLockLock(&_moneyLock);
    [super drawMoney];
    OSSpinLockUnlock(&_moneyLock);
}

- (void)saleTicket {
    OSSpinLockLock(&_ticketLock);
    [super saleTicket];
    OSSpinLockUnlock(&_ticketLock);
}

 
@end
