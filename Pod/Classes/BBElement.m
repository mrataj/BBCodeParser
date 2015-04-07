//
//  BBElement.m
//  BBCodeParser
//
//  Created by Miha Rataj on 2/2/12.
//  Copyright (c) 2012 Marg, d.o.o. All rights reserved.
//

#import "BBElement.h"
#import "BBCodeParser.h"

@implementation BBElement

@synthesize tag=_tag, format=_format, attributes=_attributes, elements=_elements, parent=_parent;

- (id)init
{
    self = [super init];
    if (self)
    {
        _tag = [[NSString alloc] init];
        _format = [[NSString alloc] init];
        _attributes = [[NSArray alloc] init];
        _elements = [[NSArray alloc] init];
        _parent = nil;
    }
    
    return self;
}

- (NSString *)text
{
    NSMutableString *format = [[NSMutableString alloc] initWithString:_format];
    
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:[BBCodeParser tagRegexPattern]
                                                                      options:NSRegularExpressionCaseInsensitive
                                                                        error:nil];
    [regex replaceMatchesInString:format options:0 range:NSMakeRange(0, [_format length]) withTemplate:@""];
    
    return format;
}

- (BBAttribute *)attributeWithName:(NSString *)name
{
    for (BBAttribute *attribute in _attributes)
        if ([attribute.name isEqualToString:name])
            return attribute;
    
    return nil;
}

- (BBElement *)elementAtIndex:(NSInteger)index
{
    NSInteger endIndex = _startIndex + [self length];
    if (index < _startIndex || index > endIndex)
        return nil;
    
    for (BBElement *element in _elements)
    {
        BBElement *found = [element elementAtIndex:index];
        if (found != nil)
            return found;
    }
    
    return self;
}

- (NSInteger)length
{
    NSInteger length = [self.text length];
    for (BBElement *element in _elements)
        length += [element length];
    return length;
}

- (void)setElements:(NSArray *)elements
{
    if (elements == _elements)
        return;
    
    _elements = elements;
    
    for (BBElement *subelement in _elements)
        [subelement setParent:self];
}

- (void)dealloc
{
    _parent = nil;
}

@end
