//
//  BBCodeParser.m
//  BBCodeParser
//
//  Created by Miha Rataj on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBCodeParser.h"
#import "BBParsingElement.h"

static NSString *__startTag = @"[";
static NSString *__endTag = @"]";
static NSString *__startClosingTag = @"[/";

@interface BBCodeParser (private)
- (void)parseCode:(NSString *)code;
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
        [self parseCode:_source];
    }
    
    return self;
}

- (BBParsingElement *)getLastUnparsedElementFor:(BBParsingElement *)parent
{
    for (BBParsingElement *subelement in parent.elements)
    {
        if (!subelement.parsed)
            return [self getLastUnparsedElementFor:subelement];
    }
    
    return parent;
}

- (BBParsingElement *)getLastUnparsedElement
{
    BBParsingElement *last = [_elements lastObject];
    if (last.parsed)
        return nil;
    
    return [self getLastUnparsedElementFor:last];
}

- (void)parseStartedForTag:(NSString *)tag
{
    BBParsingElement *element = [[BBParsingElement alloc] init];
    
    // Check if tag is valid BBCode tag.
    NSArray *components = [tag componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (components == nil || [components count] == 0)
        @throw [NSException exceptionWithName:@"Invalid components count!" reason:@"Element tag isn't valid." userInfo:nil];
    
    // Set element's tag.
    NSString *tagName = [components objectAtIndex:0];
    [element setTag:tagName];
    
    // Set element's attributes.
    NSMutableArray *attributes = [NSMutableArray array];
    for (int i = 1; i < [components count]; i++)
    {
        NSString *attributeString = [components objectAtIndex:i];
        
        BBAttribute *attribute = [[BBAttribute alloc] initWithString:attributeString];
        [attributes addObject:attribute];
        [attribute release];
    }
    [element setAttributes:attributes];
    
    // If this element has parent, append it him.
    BBParsingElement *parentElement = [self getLastUnparsedElement];
    if (parentElement != nil)
    {
        NSMutableArray *exitingChildren = [NSMutableArray arrayWithArray:parentElement.elements];
        [exitingChildren addObject:element];
        [parentElement setElements:exitingChildren];
    }
    
    // Otherwise create new element in root array.
    else
    {
        [_elements addObject:element];
    }
    
    // Finally, release this element.
    [element release];
}

- (void)parseFinishedForTag:(NSString *)tag withValue:(NSString *)value
{
    BBParsingElement *element = [self getLastUnparsedElement];
    [element setValue:value];
    [element setParsed:YES];
}

- (void)parseCode:(NSString *)code
{
    NSString *origin = [code copy];
    
    NSInteger startTagLocation = 0;
    NSString *temp = [code copy];
    
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
            NSString *elementTagName = [element substringWithRange:NSMakeRange(2, [element length] - 3)];
            NSString *elementTag = [elementTagName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *elementValue = nil;
            [self parseFinishedForTag:elementTag withValue:elementValue];
        }
        else if ([element hasPrefix:__startTag])
        {
            NSString *elementTagName = [element substringWithRange:NSMakeRange(1, [element length] - 2)];
            NSString *elementTag = [elementTagName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [self parseStartedForTag:elementTag];
        }
        
        temp = [rest substringFromIndex:endTagLocation + 1];
    }
}

- (void)dealloc
{
    [_source release];
    [_elements release];
    [super dealloc];
}

@end
