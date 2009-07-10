//
//  CMTrivia.m
//  CoffeeMe
//
//  Created by min on 5/8/09.
//  Copyright 2009 Anerian LLC. All rights reserved.
//

#import "CMTrivia.h"

@implementation CMTrivia

@synthesize fact = fact_;

- (id)initWithFMResultSet:(FMResultSet *)resultSet {
  if (self = [super init]) {
    self.pk   = [resultSet intForColumn:@"id"];
    self.fact = [[[resultSet stringForColumn:@"fact"] copy] autorelease];
  }
  return self;
}

+ (NSString *)tableName {
  return @"trivias";
}

+ (CMTrivia *)randomTrivia {
  return [self query:[NSString stringWithFormat:@"select id,fact from %@ where id >= (abs(random()) %% (select max(id) from %@)) limit 1", [self tableName], [self tableName] ]];
}

+ (NSArray *)allByRandomOrder {
  return [self query:[NSString stringWithFormat:@"select * from %@ order by random()", [self tableName] ]];
}

- (void)dealloc {
  [fact_ release];
  [super dealloc];
}

@end
