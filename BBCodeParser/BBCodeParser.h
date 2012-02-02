//
//  BBCodeParser.h
//  BBCodeParser
//
//  Created by Miha Rataj on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBElement.h"

@interface BBCodeParser : NSObject {
    NSString *_source;
    
    NSMutableArray *_elements;
    
    BOOL _readingTag;
    NSMutableString *_currentTag;
}

@property (nonatomic, readonly) NSArray *elements;

- (id)initWithString:(NSString *)source;

@end