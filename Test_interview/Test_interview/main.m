//
//  main.m
//  Test_interview
//
//  Created by 秦翌桐 on 2021/3/14.
//

#import <Foundation/Foundation.h>

#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        Person *p1 = [[Person alloc] initWithName:@"jack"];
        p1.age = 10;
        
        Person *p2 = [[Person alloc] initWithName:@"jack"];
        p2.age = 20;
        
        NSLog(@"%d", [p1 isEqual:p2]);
        
        //
        NSMutableSet *set1 = [NSMutableSet set];
        [set1 addObject:p1];
        NSMutableSet *set2 = [NSMutableSet set];
        [set2 addObject:p2];
        
    }
    return 0;
}
