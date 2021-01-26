//
//  Queue.m
//  队列
//
//  Created by 赵贺 on 2021/1/26.
//

#import "Queue.h"

@interface Queue ()

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

@end

@implementation Queue

- (instancetype)init {
    if (self = [super init]) {
        NSString *identifier = [NSString stringWithFormat:@"<SafeMutableArray>%p",self];
        self.concurrentQueue = dispatch_queue_create([identifier UTF8String], DISPATCH_QUEUE_CONCURRENT);
        self.data = [NSMutableArray array];
    }
    return self;
}
- (NSUInteger)size {
    return self.data.count;
}

- (BOOL)isEmpty {
    return self.data.count == 0;
}

- (void)enQueue:(id)element {
    
    dispatch_barrier_sync(self.concurrentQueue, ^{
        if (element) {
            [self.data addObject:element];
        }
    });
    
}

- (id)front {
    __block id obj;
    dispatch_barrier_sync(self.concurrentQueue, ^{
        obj = self.data.firstObject;
    });
    return obj;
}

- (id)deQueue {
    __block id obj;
    dispatch_barrier_async(self.concurrentQueue, ^{
        obj = self.data.firstObject;
        [self.data removeLastObject];
    });
    return obj;
}

- (void)clear {
    dispatch_barrier_async(self.concurrentQueue, ^{
        [self.data removeAllObjects];
    });
}


@end
