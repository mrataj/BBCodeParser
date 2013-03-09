//
//  BBCodeParser.h
//  BBCodeParser
//
//  Created by Miha Rataj on 2/2/12.
//  Copyright (c) 2012 Marg, d.o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBParsingElement.h"
#import "BBCodeParserDelegate.h"

@class BBParsingElement;

@interface BBCodeParser : NSObject {
    NSArray *_tags;
    NSString *_code;
    id<BBCodeParserDelegate> __weak _delegate;
    
    BBParsingElement *_element;
    
    BOOL _readingTag;
    NSMutableString *_currentTag;
    NSInteger _length;
}

@property (nonatomic, readonly) BBParsingElement *element;
@property (nonatomic, weak) id<BBCodeParserDelegate> delegate;
@property (nonatomic, copy) NSString *code;

- (id)initWithTags:(NSArray *)tags;
- (void)parse;

+ (NSString *)tagRegexPattern;

@end