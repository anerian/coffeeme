//
//  CMDrink.m
//  CoffeeMe
//
//  Created by min on 5/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMDrink.h"


@implementation CMDrink

@synthesize name = name_, type = type_, nutrition = nutrition_, milk = milk_, size = size_;

- (id)initWithFMResultSet:(FMResultSet *)resultSet {
  if (self = [super init]) {
    self.pk        = [resultSet intForColumn:@"id"];
    self.name      = [[[resultSet stringForColumn:@"name"] copy] autorelease];
    self.milk      = [resultSet intForColumn:@"milk"];
    self.size      = [resultSet intForColumn:@"size"];
    self.type      = [resultSet intForColumn:@"store_type"];
    self.nutrition = (CMNutrition) {
      [resultSet intForColumn:@"serving_size"],
      [resultSet intForColumn:@"calories"],
      [resultSet intForColumn:@"total_fat"],
      [resultSet intForColumn:@"saturated_fat"],
      [resultSet intForColumn:@"trans_fat"],
      [resultSet intForColumn:@"cholesterol"],
      [resultSet intForColumn:@"sodium"],
      [resultSet intForColumn:@"total_carbohydrates"],
      [resultSet intForColumn:@"fiber"],
      [resultSet intForColumn:@"sugars"],
      [resultSet intForColumn:@"protein"],
      [resultSet intForColumn:@"caffeine"]
    };
  }
  return self;
}

+ (NSArray *)forStore:(CMStoreType)type {
  return [CMDrink query:[NSString stringWithFormat:@"select * from drinks where store_type = %d group by name order by name", type]];
}

+ (NSArray *)forName:(NSString *)name {
  return [CMDrink query:[NSString stringWithFormat:@"select * from drinks where name = '%@'   ", name]];
}

+ (NSArray *)sizesForName:(NSString *)name {
  NSMutableArray *results = [NSMutableArray arrayWithCapacity:0];

  FMResultSet *resultSet = [[CMModel connection] executeQuery:[NSString stringWithFormat:@"select distinct(size) from drinks where name = '%@'", name]];
  
  while ([resultSet next]) [results addObject:[NSNumber numberWithInt:[resultSet intForColumn:@"size"]]];
  [resultSet close];
  
  return results;
}

+ (NSArray *)milkTypesForName:(NSString *)name {
  NSMutableArray *results = [NSMutableArray arrayWithCapacity:0];

  FMResultSet *resultSet = [[CMModel connection] executeQuery:[NSString stringWithFormat:@"select distinct(milk) from drinks where name = '%@'", name]];
  
  while ([resultSet next]) [results addObject:[NSNumber numberWithInt:[resultSet intForColumn:@"milk"]]];
  [resultSet close];
  
  return results;
}

- (NSString *)formattedName {
  return [NSString stringWithFormat:@"%@ %@ %@", CMSizeType(self.size), CMMilkType(self.milk), self.name];
}

- (void)dealloc {
  [name_ release];
  [super dealloc];
}

@end