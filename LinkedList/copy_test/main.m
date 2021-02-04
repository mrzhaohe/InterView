//
//  main.m
//  copy_test
//
//  Created by 赵贺 on 2021/2/4.
//

#import <Foundation/Foundation.h>

void testString() {
    
    NSMutableString *string = [[NSMutableString alloc] initWithString:@"0"];
    
    NSString *copyString = [string mutableCopy];
    NSString *strongString = string;
    
    [string appendString:@"1"];
    
    NSLog(@"copyString = %@", copyString);
    NSLog(@"strongString = %@", strongString);

}

void testMutableArray() {
    // 以可变的NSMutableArray作为对象源
    NSMutableArray *arrayM = [NSMutableArray arrayWithObjects:@"0", nil];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",arrayM,arrayM,arrayM.class);
    
    // 将对象源copy到可变对象
    NSMutableArray *array1 = [arrayM copy];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array1,array1,array1.class);
    
    // 将对象源mutableCopy到可变对象
    NSMutableArray *array2 = [arrayM mutableCopy];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array2,array2,array2.class);
    
    // 将对象源copy到不可变对象
    NSArray *array3 = [arrayM copy];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array3,array3,array3.class);
    
    // 将对象源mutablCopy到不可变对象
    NSArray *array4 = [arrayM mutableCopy];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array4,array4,array4.class);
    
    NSLog(@"-----------------------------------------------------------------------");
    
    // 修改对象源，然后再次对这五个对象进行打印分析
    [arrayM addObject:@"1"];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",arrayM,arrayM,arrayM.class);
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array1,array1,array1.class);
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array2,array2,array2.class);
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array3,array3,array3.class);
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array4,array4,array4.class);
}

void testArray() {
    
    // 以不可变的NSArray作为对象源
    NSArray  *arrayM = [NSArray arrayWithObjects:@"0", nil];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",arrayM,arrayM,arrayM.class);
    
    // 将对象源copy到可变对象
    NSMutableArray *array1 = [arrayM copy];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array1,array1,array1.class);
    
    // 将对象源mutableCopy到可变对象
    NSMutableArray *array2 = [arrayM mutableCopy];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array2,array2,array2.class);
    
    // 将对象源copy到不可变对象
    NSArray *array3 = [arrayM copy];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array3,array3,array3.class);
    
    // 将对象源mutablCopy到不可变对象
    NSArray *array4 = [arrayM mutableCopy];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array4,array4,array4.class);

}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
//        testString();
//        testMutableArray();
        testArray();
        
        
       
        
        
    }
    return 0;
}
