//
//  SerialQueueDemo.m
//  LockDemo
//
//  Created by 赵贺 on 2021/3/1.
//

#import "SerialQueueDemo.h"

@interface SerialQueueDemo ()

@property (nonatomic, strong) dispatch_queue_t moneyQueue;
@property (nonatomic, strong) dispatch_queue_t ticketQueue;

@end

@implementation SerialQueueDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.moneyQueue = dispatch_queue_create("moneyQueue", DISPATCH_QUEUE_SERIAL);
        self.ticketQueue = dispatch_queue_create("ticketQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)drawMoney {
    
    dispatch_sync(self.moneyQueue, ^{
        [super drawMoney];
    });
    
}

- (void)saveMoney {
    dispatch_sync(self.moneyQueue, ^{
        [super saveMoney];
    });
}

- (void)saleTicket {
    dispatch_sync(self.ticketQueue, ^{
        [super saleTicket];
    });
}

@end
