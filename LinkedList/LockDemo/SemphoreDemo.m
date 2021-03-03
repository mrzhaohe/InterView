//
//  SemphoreDemo.m
//  LockDemo
//
//  Created by 赵贺 on 2021/3/1.
//

#import "SemphoreDemo.h"

@interface SemphoreDemo ()

@property (nonatomic, strong) dispatch_semaphore_t sem;
@property (nonatomic, strong) dispatch_semaphore_t m_sem;
@property (nonatomic, strong) dispatch_semaphore_t t_sem;

@end

@implementation SemphoreDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sem = dispatch_semaphore_create(5);
        self.m_sem = dispatch_semaphore_create(1);
        self.t_sem = dispatch_semaphore_create(1);
        
    }
    return self;
}

- (void)drawMoney {
    dispatch_semaphore_wait(self.m_sem, DISPATCH_TIME_FOREVER);
    [super drawMoney];
    dispatch_semaphore_signal(self.m_sem);
}

- (void)saveMoney {
    dispatch_semaphore_wait(self.m_sem, DISPATCH_TIME_FOREVER);
    [super saveMoney];
    dispatch_semaphore_signal(self.m_sem);
}

- (void)saleTicket {
    dispatch_semaphore_wait(self.t_sem, DISPATCH_TIME_FOREVER);
    [super saleTicket];
    dispatch_semaphore_signal(self.t_sem);
}

- (void)otherTest {
    
    for (int i =0 ; i < 20; i++) {
        [[[NSThread alloc] initWithTarget:self selector:@selector(test) object:nil] start];
    }
    
}

- (void)test {
    
    dispatch_semaphore_wait(self.sem, DISPATCH_TIME_FOREVER);
    
    sleep(2);
    NSLog(@"%@", [NSThread currentThread]);
    dispatch_semaphore_signal(self.sem);
}

@end
