//
//  MainStorage.h
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UserManagedObject.h"

@interface MainStorage : NSObject

+(MainStorage *)sharedMainStorage;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readonly) UserObject *currentUser;

-(void)saveContext;

- (void)createNewUser:(UserObject *)user;

- (AudioManagedObject*)createNewAudioObject;
- (BOOL)checkAudioCached:(NSString*)title artist:(NSString*)artist;
- (NSInteger)nextOrderNumber;

@end
