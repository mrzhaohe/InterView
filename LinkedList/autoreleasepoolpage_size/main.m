//
//  main.m
//  autoreleasepoolpage_size
//
//  Created by 秦翌桐 on 2021/3/9.
//

#import <Foundation/Foundation.h>

#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Person *p = [[Person alloc] init];
        NSLog(@"%@", p);
        NSLog(@"%p", &p);
        
    }
    return 0;
}
