//
//  CMDrinksDataSource.m
//  CoffeeMe
//
//  Created by min on 5/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMDrinksDataSource.h"


@implementation CMDrinksDataSource

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithDrinks:(NSArray*)drinks {
  if (self = [super init]) {
    drinks_ = [drinks retain];
    
  }
  return self;
}

- (void)dealloc {
  [drinks_ release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UITableViewDataSource

- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView {
  return [self lettersForSectionsWithSearch:YES withCount:NO];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewDataSource

- (NSString*)tableView:(UITableView*)tableView labelForObject:(id)object {
  TTTableField* field = object;
  return field.text;
}

- (void)tableView:(UITableView*)tableView prepareCell:(UITableViewCell*)cell
        forRowAtIndexPath:(NSIndexPath*)indexPath {
  cell.accessoryType = UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView*)tableView search:(NSString*)text {
    [_sections release];
    _sections = nil;
    [_items release];

    if (text.length) {
        _items = [[NSMutableArray alloc] init];
    
        text = [text lowercaseString];
        for (CMDrink* drink in drinks_) {
            NSString *name = drink.name;
            if ([[name lowercaseString] rangeOfString:text].location == 0) {
                TTTableField* field = [[[TTTableField alloc] initWithText:name url:TT_NULL_URL] autorelease];
                [_items addObject:field];
            }
        }
    } else {
        _items = nil;
    }
  
    [self dataSourceDidFinishLoad];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)rebuildItems {
    NSMutableDictionary* map = [NSMutableDictionary dictionary];
    for (CMDrink* drink in drinks_) {
        NSString *name = drink.name;

        NSString* letter = [NSString stringWithFormat:@"%c", [name characterAtIndex:0]];
        NSMutableArray* section = [map objectForKey:letter];
        if (!section) {
            section = [NSMutableArray array];
            [map setObject:section forKey:letter];
        }
    
        TTTableField* field = [[[TTTableField alloc] initWithText:name url:TT_NULL_URL] autorelease];
        [section addObject:field];
    }
  
    [_items release];
    _items = [[NSMutableArray alloc] init];
    [_sections release];
    _sections = [[NSMutableArray alloc] init];

    NSArray* letters = [map.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  
    for (NSString* letter in letters) {
        NSArray* items = [map objectForKey:letter];
        [_sections addObject:letter];
        [_items addObject:items];
    }
}

@end
