//
//  SynchronizedDemo.m
//  LockDemo
//
//  Created by 赵贺 on 2021/3/3.
//

#import "SynchronizedDemo.h"

@implementation SynchronizedDemo


- (void)saveMoney {
    
    @synchronized (self) {
        [super saveMoney];
    }
    
}

- (void)drawMoney {
    @synchronized (self) {
        [super drawMoney];
    }
    
}

- (void)saleTicket {
    
    static NSObject *lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [NSObject new];
    });
    
    @synchronized (lock) {
        [super saleTicket];
    }
}


@end
