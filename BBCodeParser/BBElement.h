//
//  BBElement.h
//  BBCodeParser
//
//  Created by Miha Rataj on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBAttribute.h"

@interface BBElement : NSObject {
    NSString *_tag;
    NSString *_text;
    NSArray *_attributes;
    NSArray *_elements;
}

@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) NSArray *attributes;
@property (nonatomic, retain) NSArray *elements;

- (BBAttribute *)attributeWithName:(NSString *)name;

@end
