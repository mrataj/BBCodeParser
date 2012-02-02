//
//  BBCodeParser.m
//  BBCodeParser
//
//  Created by Miha Rataj on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBCodeParser.h"

static NSString *__startTag = @"[";
static NSString *__endTag = @"]";
static NSString *__startClosingTag = @"[/";

@interface BBCodeParser (private)
- (void)parseString:(NSString *)source;
- (void)parseString:(NSString *)source parentElement:(BBElement *)parent;
@end

@implementation BBCodeParser

@synthesize elements=_elements;

- (id)init
{
    self = [super init];
    if (self)
    {
        _elements = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)initWithString:(NSString *)source
{
    self = [self init];
    if (self)
    {
        _source = [source copy];
        [self parseString:_source];
    }
    
    return self;
}

- (void)startedParsingElement:(NSString *)tag withParentElement:(BBElement *)parent
{
    _currentElement = [[BBElement alloc] init];
    
    NSArray *components = [tag componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (components == nil || [components count] == 0)
        @throw [NSException exceptionWithName:@"Invalid components count!" reason:@"Element tag isn't valid." userInfo:nil];
    
    NSString *tagName = [components objectAtIndex:0];
    [_currentElement setTag:tagName];
    
    NSMutableArray *attributes = [NSMutableArray array];
    for (int i = 1; i < [components count]; i++)
    {
        NSString *attributeString = [components objectAtIndex:i];
        
        BBAttribute *attribute = [[BBAttribute alloc] initWithString:attributeString];
        [attributes addObject:attribute];
        [attribute release];
    }
    
    [_currentElement setAttributes:attributes];
}

- (void)finishedParsingElement:(NSString *)tag withParentElement:(BBElement *)parent
{
    [_currentElement setValue:@"VAL"];
    [_elements addObject:_currentElement];
    [_currentElement release];
    _currentElement = nil;
}

- (void)parseString:(NSString *)source parentElement:(BBElement *)parent
{
    NSString *origin = [source copy];
    
    NSInteger startTagLocation = 0;
    NSString *temp = [source copy];
    
    while (startTagLocation < [origin length])
    {
        startTagLocation = [temp rangeOfString:__startTag].location;
        if (startTagLocation > [origin length])
            return;
        
        NSString *rest = [temp substringFromIndex:startTagLocation];
        NSInteger endTagLocation = [rest rangeOfString:__endTag].location;
        
        NSString *element = [temp substringWithRange:NSMakeRange(startTagLocation, endTagLocation + 1)];
        if ([element hasPrefix:__startClosingTag])
        {
            NSString *elementName = [element substringWithRange:NSMakeRange(2, [element length] - 3)];
            NSString *trimmed = [elementName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [self finishedParsingElement:trimmed withParentElement:parent];
        }
        else if ([element hasPrefix:__startTag])
        {
            NSString *elementName = [element substringWithRange:NSMakeRange(1, [element length] - 2)];
            NSString *trimmed = [elementName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [self startedParsingElement:trimmed withParentElement:parent];
        }
        
        temp = [rest substringFromIndex:endTagLocation + 1];
    }    
}

- (void)parseString:(NSString *)source
{
    [self parseString:source parentElement:nil];
}

- (void)dealloc
{
    [_source release];
    [_currentElement release];
    [_elements release];
    [super dealloc];
}

@end
