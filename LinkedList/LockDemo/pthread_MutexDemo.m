//
//  MutexDemo.m
//  LockDemo
//
//  Created by 赵贺 on 2021/2/28.
//

#import "pthread_MutexDemo.h"
#import "pthread.h"


@interface pthread_MutexDemo ()

@property (nonatomic, assign) pthread_mutex_t mutex;
@property (nonatomic, assign) pthread_mutex_t t_mutex;

@end

@implementation pthread_MutexDemo


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initmutexAttrWith:&_mutex];
        [self initmutexAttrWith:&_t_mutex];
        
    }
    return self;
}

- (void)initmutexAttrWith:(pthread_mutex_t *)mutex {
    
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL);
    pthread_mutex_init(mutex, &attr);
    
    pthread_mutexattr_destroy(&attr);
}

- (void)saveMoney {
    
    pthread_mutex_lock(&_mutex);
    [super saveMoney];
    pthread_mutex_unlock(&_mutex);
    
}

- (void)drawMoney {
    pthread_mutex_lock(&_mutex);
    [super drawMoney];
    pthread_mutex_unlock(&_mutex);
}

- (void)saleTicket {
    pthread_mutex_lock(&_t_mutex);
    [super saleTicket];
    pthread_mutex_unlock(&_t_mutex);
}

@end
