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
    BBElement *_parent;
}

@property (nonatomic, copy) NSString *tag;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, copy) NSString *format;
@property (nonatomic, retain) NSArray *attributes;
@property (nonatomic, retain) NSArray *elements;
@property (nonatomic, assign) BBElement *parent;

- (BBAttribute *)attributeWithName:(NSString *)name;

@end
