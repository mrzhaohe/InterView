//
//  BaseLockDemo.m
//  LockDemo
//
//  Created by 赵贺 on 2021/2/22.
//

#import "BaseLockDemo.h"


@interface BaseLockDemo ()

@property (nonatomic, assign) int ticketsCount;

@property (nonatomic, assign) int money;

@end

@implementation BaseLockDemo


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
    
    int oldMoney = self.money;
    sleep(.2);
    oldMoney += 50;
    self.money = oldMoney;
    
    NSLog(@"存50，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
    
}

/**
 取钱
 */
- (void)drawMoney
{

    int oldMoney = self.money;
    sleep(.2);
    oldMoney -= 20;
    self.money = oldMoney;
    
    NSLog(@"取20，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
    
}

- (void)saleTicket {
    
    int oldTicketCount = self.ticketsCount;
    sleep(.2);
    oldTicketCount--;

    self.ticketsCount = oldTicketCount;
    NSLog(@"还剩%d张票", oldTicketCount);
    
}


- (void)ticketTest {
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

- (void)otherTest {}
@end
