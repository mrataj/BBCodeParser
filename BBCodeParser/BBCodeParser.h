//
//  BBCodeParser.h
//  BBCodeParser
//
//  Created by Miha Rataj on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBParsingElement.h"
#import "BBCodeParserDelegate.h"

@class BBParsingElement;

@interface BBCodeParser : NSObject {
    NSString *_code;
    id<BBCodeParserDelegate> _delegate;
    
    BBParsingElement *_element;
    
    BOOL _readingTag;
    NSMutableString *_currentTag;
}

@property (nonatomic, readonly) BBParsingElement *element;
@property (nonatomic, assign) id<BBCodeParserDelegate> delegate;

- (id)initWithCode:(NSString *)source;
- (void)parse;

@end