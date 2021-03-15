//
//  ViewController.m
//  卡顿监测
//
//  Created by 秦翌桐 on 2021/3/13.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong)NSTimer *runLoopObServerTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRunLoopObserver];
    [self initData];
}
 
- (void)initData{
    //默认会添加到当前的runLoop中去,不做任何事情,为了让runLoop一直处理任务而不去睡眠
    _runLoopObServerTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
}
 
- (void)addRunLoopObserver{
    //获取当前的CFRunLoopRef
    CFRunLoopRef runLoopRef = CFRunLoopGetCurrent();
    //创建上下文,用于控制器数据的获取
    CFRunLoopObserverContext context =  {
        0,
        (__bridge void *)(self),//self传递过去
        &CFRetain,
        &CFRelease,
        NULL
    };
    //创建一个监听
    static CFRunLoopObserverRef observer;
    observer = CFRunLoopObserverCreate(NULL, kCFRunLoopAfterWaiting, YES, 0, &runLoopOserverCallBack, &context);
    //注册监听
    CFRunLoopAddObserver(runLoopRef, observer, kCFRunLoopCommonModes);
    //销毁
    CFRelease(observer);
}
 
//监听CFRunLoopRef回调函数
static void runLoopOserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    if (activity == kCFRunLoopBeforeSources || activity == kCFRunLoopAfterWaiting) {
        //将堆栈信息上报服务器的代码放到这里
        
    }
    
    ViewController *viewController = (__bridge ViewController *)(info);//void *info即是我们前面传递的self(ViewController)
    NSLog(@"runLoopOserverCallBack -> activity = %d",activity);

//    NSLog(@"runLoopOserverCallBack -> name = %@",NSStringFromClass([viewController class]));
}
 
- (void)timerMethod{
    //不做任何事情,为了让runLoop一直处理任务而不去睡眠
}


@end
