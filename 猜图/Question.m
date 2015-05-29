//
//  Question.m
//  猜图
//
//  Created by 方舟 on 15/5/28.
//  Copyright (c) 2015年 方舟. All rights reserved.
//

#import "Question.h"



@implementation Question

- (instancetype)initWithDict: (NSDictionary *)dict
{
    self = [super init];
    if (self) {
//        self.answer = dict[@"answer"];
//        self.icon = dict[@"icon"];
//        self.title = dict[@"title"];
//        self.options = dict[@"options"];
        //KVC （key value coding)键值编码， 允许间接个性对象的属性值
        //使用setValuesForKeys要求类的属性必须在字典中存在
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)questionWithDict: (NSDictionary *)dict;
{
    return [[self alloc] initWithDict:dict];
}

+ (NSArray *)questions
{
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions.plist" ofType:nil]];
    NSMutableArray *arrayM = [NSMutableArray array];
    for(NSDictionary *dict in array){
        [arrayM addObject:[Question questionWithDict:dict]];
    }
    return arrayM;
}

@end
