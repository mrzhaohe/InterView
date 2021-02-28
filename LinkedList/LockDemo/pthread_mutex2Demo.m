//
//  pthread_mutex2Demo.m
//  LockDemo
//
//  Created by 赵贺 on 2021/2/28.
//

#import "pthread_mutex2Demo.h"

#import "pthread.h"


@interface pthread_mutex2Demo ()

@property (nonatomic, assign) pthread_mutex_t mutex;

@end

@implementation pthread_mutex2Demo

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initWithMutex:&_mutex];
    }
    return self;
}

- (void)initWithMutex:(pthread_mutex_t *)mutex {
    
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(mutex, &attr);
    
    pthread_mutexattr_destroy(&attr);
}

- (void)otherTest {
    pthread_mutex_lock(&_mutex);
    NSLog(@"%s", __func__);
    [self otherTest2];
    pthread_mutex_unlock(&_mutex);
}

- (void)otherTest2 {
    pthread_mutex_lock(&_mutex);
    NSLog(@"%s", __func__);
    pthread_mutex_unlock(&_mutex);
}

@end
