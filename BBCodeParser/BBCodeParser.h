//
//  BBCodeParser.h
//  BBCodeParser
//
//  Created by Miha Rataj on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBElement.h"
#import "BBCodeParserDelegate.h"

@interface BBCodeParser : NSObject {
    NSString *_code;
    id<BBCodeParserDelegate> _delegate;
    
    NSMutableArray *_elements;
    
    BOOL _readingTag;
    NSMutableString *_currentTag;
}

@property (nonatomic, readonly) NSArray *elements;
@property (nonatomic, assign) id<BBCodeParserDelegate> delegate;

- (id)initWithCode:(NSString *)source;
- (void)parse;

@end