//
//  pthread_mutex_condition_demo.m
//  LockDemo
//
//  Created by 赵贺 on 2021/2/28.
//

#import "pthread_mutex_condition_demo.h"

#import "pthread.h"

@interface pthread_mutex_condition_demo ()

@property (nonatomic, assign) pthread_mutex_t mutex;
@property (nonatomic, assign) pthread_cond_t condition;
@property (nonatomic, strong) NSMutableArray *data;



@end


@implementation pthread_mutex_condition_demo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.data = [NSMutableArray array];
        
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL);
        pthread_mutex_init(&_mutex, &attr);
        
        pthread_mutexattr_destroy(&attr);
        
        //pthread_condattr_t 可为空
        pthread_cond_init(&_condition, NULL);
        
    }
    return self;
}


- (void)otherTest {
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(remove) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(add) object:nil] start];
}

- (void)remove {
    
    pthread_mutex_lock(&_mutex);
    NSLog(@"准备删除元素");

    if (self.data.count == 0) {
        pthread_cond_wait(&_condition, &_mutex);
    }
    
    [self.data removeLastObject];
    NSLog(@"删除了元素");
    pthread_mutex_unlock(&_mutex);
    
}

- (void)add {
    pthread_mutex_lock(&_mutex);
    
    [self.data addObject:@"1"];
    NSLog(@"添加了元素");
    pthread_cond_signal(&_condition);
    
    pthread_mutex_unlock(&_mutex);
}


@end
