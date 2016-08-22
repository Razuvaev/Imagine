//
//  AudioObject.h
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface AudioObject : NSObject

@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSNumber *duration;

- (void)updateWithDictionary:(NSDictionary *)dict;

@end

@interface AudioManagedObject : NSManagedObject

@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *home_url;
@property (nonatomic, strong) NSNumber *duration;

-(void)updateWithAudio:(AudioObject *)audioObject WithHomePath:(NSString*)path;

@end
