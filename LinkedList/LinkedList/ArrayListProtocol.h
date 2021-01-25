//
//  ArrayListProtocol.h
//  算法
//
//  Created by 秦翌桐 on 2021/1/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ArrayListProtocol <NSObject>

- (BOOL)isEmpty;

- (BOOL)containsOf:(id)obj;

- (id)get:(int)index;

- (void)clear;

- (void)add:(id)element index:(int)index;

- (id)set:(int)index element:(id)element;

- (id)remove:(int)index;

- (int)indexOf:(id)element;

@end

NS_ASSUME_NONNULL_END
