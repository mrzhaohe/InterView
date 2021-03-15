//
//  main.m
//  isequal&&Hash
//
//  Created by 秦翌桐 on 2021/3/14.
//

#import <Foundation/Foundation.h>

#import "Person.h"

void change(int start, int index, NSMutableArray *array) {
    
//    NSString *tmp = array[start];
//
//    array[index] = tmp;
//    array[start] = array[index];
//
    [array exchangeObjectAtIndex:start withObjectAtIndex:index];
    
}

void sort(int start, NSMutableArray *array) {
    
    if (start == array.count - 1) {
        NSLog(@"%@", array);
    }
    
    for (int i = start; i< array.count; i++) {
        
        change(start, i, array);
        sort(start+1, array);
        change(start, i, array);
    }
    
    
}



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSMutableArray *array = @[@"1", @"2",@"3"].mutableCopy;
        
        sort(0, array);
        
        
//        Person *p1 = [[Person alloc] initWithName:@"jack"];
//        p1.age = 10;
//
//        Person *p2 = [[Person alloc] initWithName:@"jack"];
//        p2.age = 20;
//
//        NSLog(@"%d", [p1 isEqual:p2]);
//
//        // 对象作为key  nsset  nsmutableDictionary 才会调用 hash
//        NSMutableSet *set1 = [NSMutableSet set];
//        [set1 addObject:p1];
//        NSMutableSet *set2 = [NSMutableSet set];
//        [set2 addObject:p2];
        
        
        
        
        
    }
    return 0;
}




