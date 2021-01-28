//
//  NSObject+ObserverHelper.m
//  KVO
//
//  Created by 赵贺 on 2021/1/26.
//

#import "NSObject+ObserverHelper.h"
#import <objc/runtime.h>

@implementation NSObject (ObserverHelper)

+ (void)load {
//    Method origMethod = class_getInstanceMethod(self, @selector(addObserver:forKeyPath:options:context:));
//    Method altMethod = class_getInstanceMethod(self, @selector(c_addObserver:forKeyPath:options:context:));
//
//    if (!origMethod || !altMethod) {
//        return;
//    }
//    class_addMethod(self,
//                    origSel,
//                    class_getMethodImplementation(self, origSel),
//                    method_getTypeEncoding(origMethod));
//    class_addMethod(self,
//                    altSel,
//                    class_getMethodImplementation(self, altSel),
//                    method_getTypeEncoding(altMethod));
//    method_exchangeImplementations(class_getInstanceMethod(self, origSel),
//                                   class_getInstanceMethod(self, altSel));
}

@end
