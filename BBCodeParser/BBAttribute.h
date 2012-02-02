//
//  BBAttribute.h
//  BBCodeParser
//
//  Created by Miha Rataj on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBAttribute : NSObject {
    NSString *_name;
    NSString *_value;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;

- (BBAttribute *)attributeFromString:(NSString *)attributeString;
- (id)initWithString:(NSString *)attributeString;

@end
