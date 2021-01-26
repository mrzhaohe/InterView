//
//  Stack.m
//  栈
//
//  Created by 赵贺 on 2021/1/26.
//

#import "Stack.h"

@interface Stack ()

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

@end

@implementation Stack

- (instancetype)init {
    if (self = [super init]) {
        NSString *identifier = [NSString stringWithFormat:@"<SafeMutableArray>%p",self];
        self.concurrentQueue = dispatch_queue_create([identifier UTF8String], DISPATCH_QUEUE_CONCURRENT);
        self.data = [NSMutableArray array];
    }
    return self;
}

- (NSUInteger)size {
    __block NSUInteger count;
    dispatch_sync(self.concurrentQueue, ^{
        count = self.data.count;
    });
    return count;
}

- (BOOL)isEmpty {
    return self.data.count == 0;
}

- (void)push:(id)element {
    dispatch_barrier_sync(self.concurrentQueue, ^{
        if (element) {
            [self.data addObject:element];
        }
    });
}

- (id)pop {
    __block id obj;
    dispatch_barrier_sync(self.concurrentQueue, ^{
        if (self.data.count) {
            obj = self.data.lastObject;
            [self.data removeLastObject];
        }
    });
    return obj;
}

- (id)top {
   __block id obj;
    dispatch_barrier_sync(self.concurrentQueue, ^{
        obj = self.data.firstObject;
    });
    return obj;
}

- (void)dealloc {
    if (self.concurrentQueue) {
        self.concurrentQueue = nil;
    }
}


- (NSString *)description {
    NSString *string = [NSString stringWithFormat:@"%@", self.data];
    return string;
}

@end
