//
//  main.m
//  __block
//
//  Created by 赵贺 on 2021/2/8.
//

#import <Foundation/Foundation.h>

#import "Person.h"

typedef void(^Block)(void);

struct sss {
    int age;
};

void testAssign() {
    
    __block int age = 10;
    
    void(^block)(void) = ^ {
        NSLog(@"age is %d", age);
    };
    block();
    
}

void testObj() {
    
//    Person *person = [Person new];
//    __block __weak Person *weakPerson = person;
//
//    Block block = ^ {
//        NSLog(@"person is %@", weakPerson);
//    };
//
//    block();
    
    Block block;
    {
        Person *person = [Person new];
        // 超出作用域 weakPerson 释放
        __block __weak Person *weakPerson = person;
        block = ^ {
            NSLog(@"person is %@", weakPerson);
        };
    }
    block();
    
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        
//        testAssign();
        testObj();
        
    }
    return 0;
}


