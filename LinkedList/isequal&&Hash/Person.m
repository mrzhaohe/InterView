//
//  Person.m
//  Test_interview
//
//  Created by 秦翌桐 on 2021/3/14.
//

#import "Person.h"


@interface Person ()

@property (nonatomic, copy, readwrite ) NSString *name;

@end

@implementation Person


- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}


- (BOOL)isEqual:(Person *)object {
    
    return [object.name isEqualToString:self.name];
    
}

- (NSUInteger)hash {
    return [self.name hash];
    
//    NSUInteger hash = [super hash];
//    NSLog(@"hash = %ld", hash);
//    return hash;
    
}

@end
