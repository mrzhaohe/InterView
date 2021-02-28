//
//  OSUnfairLockDemo.m
//  LockDemo
//
//  Created by 赵贺 on 2021/2/28.
//

#import "OSUnfairLockDemo.h"
#import <os/lock.h>

@interface OSUnfairLockDemo ()

@property (nonatomic, assign) os_unfair_lock lock;
@property (nonatomic, assign) os_unfair_lock t_lock;



@end

@implementation OSUnfairLockDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lock = OS_UNFAIR_LOCK_INIT;
        self.t_lock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

- (void)saveMoney {

    os_unfair_lock_lock(&_lock);
    
    [super saveMoney];
    
    os_unfair_lock_unlock(&_lock);
    
    
}

- (void)drawMoney {
    
    os_unfair_lock_lock(&_lock);
    
    [super drawMoney];
    
    os_unfair_lock_unlock(&_lock);
    
}

- (void)saleTicket {
    os_unfair_lock_lock(&_t_lock);
    
    [super saleTicket];
    
    os_unfair_lock_unlock(&_t_lock);
}


@end
