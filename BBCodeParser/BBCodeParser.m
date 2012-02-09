//
//  BBCodeParser.m
//  BBCodeParser
//
//  Created by Miha Rataj on 2/2/12.
//  Copyright (c) 2012 Marg, d.o.o. All rights reserved.
//

#import "BBCodeParser.h"

static NSString *__startTag = @"[";
static NSString *__endTag = @"]";
static NSString *__closingTag = @"/";

@implementation BBCodeParser

@synthesize element=_element, delegate=_delegate;

- (id)init
{
    self = [super init];
    if (self)
    {
        _element = [[BBParsingElement alloc] init];
    }
    
    return self;
}

- (id)initWithCode:(NSString *)code
{
    self = [self init];
    if (self)
    {
        _code = [code copy];
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
    BBParsingElement *last = [_element.elements lastObject];
    if (last.parsed || last == nil)
        return _element;
    
    return [self getLastUnparsedElementFor:last];
}

- (NSArray *)getAttributesFromTag:(NSString *)tag
{
    NSArray *components = [tag componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *tagName = [components objectAtIndex:0];
    
    NSString *attributeString = [tag substringFromIndex:[tagName length]];
    
    BOOL parsingName = YES, parsingValue = NO;
    NSMutableString *currentName = [NSMutableString string], *currentValue = nil;
    
    NSMutableArray *attributes = [NSMutableArray array];
    for (int i = 0; i < [attributeString length]; i++)
    {
        NSString *currentCharacter = [attributeString substringWithRange:NSMakeRange(i, 1)];
                
        if (parsingName && ![currentCharacter isEqualToString:@"="])
            [currentName appendString:currentCharacter];
        
        else if (parsingValue && ![currentCharacter isEqualToString:@"\""])
            [currentValue appendString:currentCharacter];
        
        if ([currentCharacter isEqualToString:@"="])
        {
            // We ended parsing name
            parsingValue = YES;
            parsingName = NO;
            currentValue = [NSMutableString string];
        }
        else if ([currentCharacter isEqualToString:@"\""])
        {
            // We ended parsing value
            if ([currentValue length] != 0)
            {
                BBAttribute *attribute = [[BBAttribute alloc] init];
                [attribute setName:[currentName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                [attribute setValue:[currentValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                [attributes addObject:attribute];
                [attribute release];
                
                parsingValue = NO;
                parsingName = YES;
                currentName = [NSMutableString string];
            }
        }
    }
    
    return attributes;
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
    NSArray *attributes = [self getAttributesFromTag:tag];
    [element setAttributes:attributes];
    
    // Append children to last unparsed element.
    BBParsingElement *parentElement = [self getLastUnparsedElement];
    NSMutableArray *exitingChildren = [NSMutableArray arrayWithArray:parentElement.elements];
    [exitingChildren addObject:element];
    [parentElement setElements:exitingChildren];
    
    NSString *newText = [NSString stringWithFormat:@"%@[%d]", parentElement.text, [parentElement.elements count] - 1];
    [parentElement setText:newText];
        
    // Finally, release this element.
    [element release];
    
    // If needed, notify delegate object.
    if ([self.delegate respondsToSelector:@selector(parser:didStartElementTag:attributes:)])
        [self.delegate parser:self didStartElementTag:tagName attributes:attributes];
}

- (void)parseFinishedForTag:(NSString *)tag
{
    BBParsingElement *element = [self getLastUnparsedElement];
    [element setParsed:YES];
    
    if ([self.delegate respondsToSelector:@selector(parser:didEndElement:)])
        [self.delegate parser:self didEndElement:element];
}

- (void)parseFound:(NSString *)character
{
    BBParsingElement *element = [self getLastUnparsedElement];
    NSString *newText = [NSString stringWithFormat:@"%@%@", element.text, character];
    [element setText:newText];
    
    if ([self.delegate respondsToSelector:@selector(parser:foundCharacters:)])
        [self.delegate parser:self foundCharacters:character];
}

- (void)parse
{
    if ([self.delegate respondsToSelector:@selector(parser:didStartParsingCode:)])
        [self.delegate parser:self didStartParsingCode:_code];
    
    for (int i = 0; i < [_code length]; i++)
    {
        // Check if current character is announcing starting of new tag.
        NSString *currentCharacter = [_code substringWithRange:NSMakeRange(i, 1)];
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
    
    // In the end, finish parsing root element.
    [self parseFinishedForTag:nil];
    
    if ([self.delegate respondsToSelector:@selector(parser:didFinishParsingCode:)])
        [self.delegate parser:self didFinishParsingCode:_code];
}

- (void)dealloc
{
    _delegate = nil;
    [_code release];
    [_element release];
    [_currentTag release];
    [super dealloc];
}

@end
