//
//  Person.m
//  KVO
//
//  Created by 赵贺 on 2021/1/26.
//

#import "Person.h"

@implementation Person

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}



- (void)dealloc {
    [self removeObserver:self forKeyPath:@"age"];
}



@end
