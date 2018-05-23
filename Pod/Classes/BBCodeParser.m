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

@synthesize element=_element, delegate=_delegate, code=_code;

#pragma mark -
#pragma mark - Init

- (id)init
{
    self = [super init];
    if (self)
    {
        _element = [[BBParsingElement alloc] init];
    }
    
    return self;
}

- (id)initWithTags:(NSArray *)tags
{
    self = [self init];
    if (self)
    {
        _tags = tags;
    }
    return self;
}

#pragma mark -
#pragma mark - Parsing

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
        
        if ([currentCharacter isEqualToString:@"="] && parsingName)
        {
            // We ended parsing name
            parsingValue = YES;
            parsingName = NO;
            currentValue = [NSMutableString string];
        }
        else if ([currentCharacter isEqualToString:@"\""] && parsingValue)
        {
            // We ended parsing value
            if ([currentValue length] != 0)
            {
                // If we didn't parse last character and next character is not space, that means that quote doesn't represent end of value.
                if (i + 1 < [attributeString length] && ![[attributeString substringWithRange:NSMakeRange(i + 1, 1)] isEqualToString:@" "])
                    break;
                
                BBAttribute *attribute = [[BBAttribute alloc] init];
                [attribute setName:[currentName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                [attribute setValue:[currentValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                [attributes addObject:attribute];
                
                parsingValue = NO;
                parsingName = YES;
                currentName = [NSMutableString string];
            }
        }
    }
    
    return attributes;
}

- (BOOL)textStartsWithAllowedTag:(NSString *)text
{
    for (NSString *tag in _tags)
    {
        NSString *validBegining1 = [NSString stringWithFormat:@"%@%@%@", __startTag, tag, __endTag]; // "[bold]"
        NSString *validBegining2 = [NSString stringWithFormat:@"%@%@%@%@", __startTag, __closingTag, tag, __endTag]; // "[/bold]"
        NSString *validBegining3 = [NSString stringWithFormat:@"%@%@ ", __startTag, tag]; // "[bold "
        NSString *validBegining4 = [NSString stringWithFormat:@"%@%@=", __startTag, tag]; // "[bold="
        
        if ([text hasPrefix:validBegining1] || [text hasPrefix:validBegining2] || [text hasPrefix:validBegining3] || [text hasPrefix:validBegining4])
            return YES;
    }
    
    return NO;
}

- (void)parseStartedForTag:(NSString *)tag
{
    BBParsingElement *element = [[BBParsingElement alloc] init];
    [element setStartIndex:_length];
    
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
    
    NSString *newFormat = [NSString stringWithFormat:@"%@%@%lu%@",
                           parentElement.format,
                           [BBCodeParser startTagCharacter],
                           (unsigned long)([parentElement.elements count] - 1),
                           [BBCodeParser endTagCharacter]];
    [parentElement setFormat:newFormat];
        
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
    NSString *newFormat = [NSString stringWithFormat:@"%@%@", element.format, character];
    [element setFormat:newFormat];
    
    if ([self.delegate respondsToSelector:@selector(parser:foundCharacters:)])
        [self.delegate parser:self foundCharacters:character];
    
    _length++;
}

- (void)parse
{
    _length = 0;
    
    if ([self.delegate respondsToSelector:@selector(parser:didStartParsingCode:)])
        [self.delegate parser:self didStartParsingCode:_code];
    
    for (int i = 0; i < [_code length]; i++)
    {
        @autoreleasepool {
            // Check if current character is announcing starting of new tag.
            NSString *currentCharacter = [_code substringWithRange:NSMakeRange(i, 1)];
            if ([currentCharacter isEqualToString:__startTag] && [self textStartsWithAllowedTag:[_code substringFromIndex:i]])
            {
                _currentTag = [[NSMutableString alloc] init];
                _readingTag = YES;
            }
            
            // Otherwise, check if we just read the tag.
            else if ([currentCharacter isEqualToString:__endTag] && _currentTag != nil)
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
                
                _currentTag = nil;
                
                _readingTag = NO;
            }
            
            // Otherwise just read.
            else
            {
                if (_readingTag)
                {
                    [_currentTag appendString:currentCharacter];
                }
                else
                {
                    [self parseFound:currentCharacter];
                }
            }
        }
    }
    
    // In the end, finish parsing root element.
    [self parseFinishedForTag:nil];
    
    if ([self.delegate respondsToSelector:@selector(parser:didFinishParsingCode:)])
        [self.delegate parser:self didFinishParsingCode:_code];
}

#pragma mark -
#pragma mark - Tags

+ (NSString *)startTagCharacter
{
    // WARNING!
    // If you change this, change also tagRegexPattern function!
    return @"{BB_";
}

+ (NSString *)endTagCharacter
{
    // WARNING!
    // If you change this, change also tagRegexPattern function!
    return @"_BB}";
}

+ (NSString *)tagRegexPattern
{
    // WARNING!
    // If you change this, you may also want to change startTagCharacter or endTagCharacter functions!
    return @"(\\{BB_[0-9]+_BB\\})";
}

#pragma mark -
#pragma mark - Dealloc

- (void)dealloc
{
    _delegate = nil;
}

@end
