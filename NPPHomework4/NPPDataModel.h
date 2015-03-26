//
//  NPPDataModel.h
//  NPPHomework4
//
//  Created by Nick Peters on 3/2/15.
//  Copyright (c) 2015 Nick Peters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPPDataModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *name;

- (id)initWithName: (NSString *)name andUrl:(NSString *)url;

@end