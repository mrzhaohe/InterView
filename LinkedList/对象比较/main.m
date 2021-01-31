//
//  main.m
//  对象比较
//
//  Created by 秦翌桐 on 2021/1/31.
//

#import <Foundation/Foundation.h>
#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        BOOL re1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];//1
        BOOL re2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];//0
        BOOL re3 = [(id)[Person class] isKindOfClass:[Person class]];//0
        BOOL re4 = [(id)[Person class] isMemberOfClass:[Person class]];//0
        NSLog(@"\n re1 :%hhd\n re2 :%hhd\n re3 :%hhd\n re4 :%hhd\n",re1,re2,re3,re4);
        BOOL re5 = [(id)[NSObject alloc] isKindOfClass:[NSObject class]];//1
        BOOL re6 = [(id)[NSObject alloc] isMemberOfClass:[NSObject class]];//1
        BOOL re7 = [(id)[Person alloc] isKindOfClass:[Person class]];//1
        BOOL re8 = [(id)[Person alloc] isMemberOfClass:[Person class]];//1
        NSLog(@"\n re5 :%hhd\n re6 :%hhd\n re7 :%hhd\n re8 :%hhd\n",re5,re6,re7,re8);

    }
    return 0;
}
