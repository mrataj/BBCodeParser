//
//  BBParsingElement.h
//  BBCodeParser
//
//  Created by Miha Rataj on 2.2.12.
//  Copyright (c) 2012 Marg, d.o.o. All rights reserved.
//

#import "BBElement.h"

@interface BBParsingElement : BBElement {
    BOOL _parsed;
}

@property (nonatomic, assign) BOOL parsed;

@end
