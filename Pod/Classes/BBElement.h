//
//  BBElement.h
//  BBCodeParser
//
//  Created by Miha Rataj on 2/2/12.
//  Copyright (c) 2012 Marg, d.o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBAttribute.h"

@interface BBElement : NSObject {
    NSString *_tag;
    NSString *_format;
    NSArray *_attributes;
    NSArray *_elements;
    BBElement *__weak _parent;
    NSInteger _startIndex;
}

@property (nonatomic, copy) NSString *tag;
@property (weak, nonatomic, readonly) NSString *text;
@property (nonatomic, copy) NSString *format;
@property (nonatomic, strong) NSArray *attributes;
@property (nonatomic, strong) NSArray *elements;
@property (nonatomic, weak) BBElement *parent;
@property (nonatomic, assign) NSInteger startIndex;

- (BBAttribute *)attributeWithName:(NSString *)name;
- (BBElement *)elementAtIndex:(NSInteger)index;

@end
