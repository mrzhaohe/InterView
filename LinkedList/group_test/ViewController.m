//
//  ViewController.m
//  group_test
//
//  Created by 秦翌桐 on 2021/3/5.
//

#import "ViewController.h"

#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
}

- (void)test {
  dispatch_group_t group = dispatch_group_create();
    
    
    {
        dispatch_group_enter(group);
        dispatch_block_t block = ^ {
            NSLog(@"11111111111");
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_group_leave(group);
                
            });
//            dispatch_group_leave(group);
        };
        
        block();
    }
    
    {
        dispatch_group_enter(group);
        NSLog(@"2222222222");
        
        dispatch_group_leave(group);
    }
    
    {
        dispatch_group_enter(group);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
            NSLog(@"3333333333");
            dispatch_group_leave(group);
        });
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        NSLog(@"end");
        
    });
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self.navigationController pushViewController:[TestViewController new] animated:YES];
    
    [self test];
    
}

@end
