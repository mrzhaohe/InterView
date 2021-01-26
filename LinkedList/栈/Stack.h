//
//  Stack.h
//  栈
//
//  Created by 赵贺 on 2021/1/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Stack : NSObject

- (int)size;

- (BOOL)isEmpty;

- (void)push:(id)element;

- (void)pop;

- (id)top;

@end

NS_ASSUME_NONNULL_END
