//
//  Node.h
//  算法
//
//  Created by 秦翌桐 on 2021/1/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Node : NSObject

+ (Node *)nodeWithElement:(id)element next:(Node *)next;

@property (nonatomic, strong) id element;

@property (nonatomic, strong, nullable) Node *next;

@end

NS_ASSUME_NONNULL_END
