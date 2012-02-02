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
static NSString *__closingTag = @"/";

@interface BBCodeParser (private)
- (void)parse;
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
        [self parse];
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

- (void)parseFinishedForTag:(NSString *)tag
{
    BBParsingElement *element = [self getLastUnparsedElement];
    [element setParsed:YES];
}

- (void)parseFound:(NSString *)character
{
    BBParsingElement *element = [self getLastUnparsedElement];
    if (element != nil)
    {
        NSString *newValue = [NSString stringWithFormat:@"%@%@", element.value, character];
        [element setValue:newValue];
    }
}

- (void)parse
{
    for (int i = 0; i < [_source length]; i++)
    {
        // Check if current character is announcing starting of new tag.
        NSString *currentCharacter = [_source substringWithRange:NSMakeRange(i, 1)];
        if ([currentCharacter isEqualToString:__startTag])
        {
            _currentTag = [[NSMutableString alloc] init];
            _readingTag = YES;
        }
        
        // Otherwise, check if we just read the tag.
        else if ([currentCharacter isEqualToString:__endTag])
        {
            if ([_currentTag hasPrefix:__closingTag])
            {
                NSString *trimmedTag = [_currentTag substringFromIndex:1];
                [self parseFinishedForTag:trimmedTag];
            }
            else
            {
                [self parseStartedForTag:_currentTag];
            }
            
            [_currentTag release];
            _currentTag = nil;
            
            _readingTag = NO;
        }
        
        // Otherwise just read.
        else
        {
            if (_readingTag)
            {
                [_currentTag appendFormat:currentCharacter];
            }
            else
            {
                [self parseFound:currentCharacter];
            }
        }
    }
}

- (void)dealloc
{
    [_source release];
    [_elements release];
    [super dealloc];
}

@end
