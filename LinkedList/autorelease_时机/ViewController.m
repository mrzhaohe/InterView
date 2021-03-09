//
//  ViewController.m
//  autorelease_时机
//
//  Created by 秦翌桐 on 2021/3/8.
//

#import "ViewController.h"

#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
//    Person *p = [[[Person alloc] init] autorelease];
    Person *p = [[Person alloc] init];

    //    NSLog(@"%@", [NSRunLoop mainRunLoop]);
    NSLog(@"%s", __func__);

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);
}


@end
