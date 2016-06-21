//
//  NSDictionary+QueryBuilder.h
//  YayawanIOS
//
//  Created by andsky on 14-4-12.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (QueryBuilder)

- (NSString *)buildQueryString;
+ (NSDictionary *)dictionaryWithQueryString:(NSString *)queryString;

@end
