//
//  SemphoreDemo.m
//  LockDemo
//
//  Created by 赵贺 on 2021/3/1.
//

#import "SemphoreDemo.h"

@interface SemphoreDemo ()

@property (nonatomic, strong) dispatch_semaphore_t sem;

@end

@implementation SemphoreDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sem = dispatch_semaphore_create(5);
    }
    return self;
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
