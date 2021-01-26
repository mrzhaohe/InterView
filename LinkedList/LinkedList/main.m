//
//  main.m
//  LinkedList
//
//  Created by 赵贺 on 2021/1/24.
//

#import <Foundation/Foundation.h>

#import "LinkList.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        LinkList *linkList = [[LinkList alloc] initWithData:@(10)];
        [linkList set:0 element:@(1000)];
        [linkList add:@(11) index:0];

        NSLog(@"%@", linkList);
        
        [linkList remove:0];
        NSLog(@"===============");

        NSLog(@"%@", linkList);
        
        NSLog(@"===============");
        
        NSLog(@"%@", [linkList get:0]);
        
        NSLog(@"===============");
        
        [linkList clear];
        
        NSLog(@"%@", linkList);

        
    }
    return 0;
}
