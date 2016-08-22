//
//  AudioObject.m
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import "AudioObject.h"

@implementation AudioObject

- (void)updateWithDictionary:(NSDictionary *)dict {
    if ([[dict valueForKey:@"artist"] isKindOfClass:[NSString class]]) {
        self.artist = [dict valueForKey:@"artist"];
    }
    
    if ([[dict valueForKey:@"title"] isKindOfClass:[NSString class]]) {
        self.title = [dict valueForKey:@"title"];
    }
    
    if ([[dict valueForKey:@"url"] isKindOfClass:[NSString class]]) {
        self.url = [dict valueForKey:@"url"];
    }
    
    if ([[dict valueForKey:@"duration"] isKindOfClass:[NSNumber class]]) {
        self.duration = [dict valueForKey:@"duration"];
    }
}

@end

@implementation AudioManagedObject

@dynamic artist;
@dynamic title;
@dynamic url;
@dynamic home_url;
@dynamic duration;

-(void)updateWithAudio:(AudioObject *)audioObject WithHomePath:(NSString*)path {
    self.artist = audioObject.artist;
    self.title = audioObject.title;
    self.url = audioObject.url;
    self.duration = audioObject.duration;
    self.home_url = path;
}

@end
