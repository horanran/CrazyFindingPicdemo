//
//  Question.h
//  猜图
//
//  Created by 方舟 on 15/5/28.
//  Copyright (c) 2015年 方舟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSArray *questions;

- (instancetype)initWithDict: (NSDictionary *)dict;
+ (instancetype)questionWithDict: (NSDictionary *)dict;
+ (NSArray *)questions;
@end
