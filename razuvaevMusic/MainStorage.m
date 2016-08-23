//
//  MainStorage.m
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import "MainStorage.h"
#import "Settings.h"

@interface MainStorage ()

@end

@implementation MainStorage
@synthesize currentUser = _currentUser;

MainStorage *sharedMainStorage = nil;

+ (MainStorage *)sharedMainStorage
{
    if (sharedMainStorage == nil) {
        sharedMainStorage = [[MainStorage alloc] init];
    }
    return sharedMainStorage;
}

#pragma mark core data initialisation

- (id)init {
    self = [super init];
    if (self) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ImagineModel" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        NSURL *documentPath = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        
        NSURL *storeURL = [documentPath URLByAppendingPathComponent:@"ImagineModel.sqlite"];
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        }
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    }
    return self;
}

- (void)mergeContext:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_managedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:) withObject:noti waitUntilDone:YES];
    });
}

-(void)saveContext {
    NSLog(@"saveContext");
    if ([self.managedObjectContext hasChanges]) {
        NSLog(@"hasChanges");
        NSError *error = nil;
        if(![self.managedObjectContext save:&error]) {
            NSLog(@"ERROR: %@", error);
        }
    } else {
        NSLog(@"doesn't have changes");
    }
}

#pragma mark User
- (void)createNewUser:(UserObject *)user {
    NSEntityDescription *userDescriptor = [NSEntityDescription entityForName:@"User" inManagedObjectContext:_managedObjectContext];
    UserManagedObject *userManagedObject = [[UserManagedObject alloc] initWithEntity:userDescriptor insertIntoManagedObjectContext:_managedObjectContext];
    userManagedObject.userId = user.userId;
    userManagedObject.firstName = user.firstName;
    userManagedObject.lastName = user.lastName;
    userManagedObject.avatarMediumUrl = user.avatarMediumUrl;
    
    Settings *settings = [self createUserSettings];
    settings.user = userManagedObject;
    userManagedObject.settings = settings;

    [self saveContext];
}

- (Settings*)createUserSettings {
    NSEntityDescription *settingsDescriptor = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:_managedObjectContext];
    Settings *settings = [[Settings alloc] initWithEntity:settingsDescriptor insertIntoManagedObjectContext:_managedObjectContext];
    settings.autodownload = @(NO);
    return settings;
}

-(UserObject *)returnUser {
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"User" inManagedObjectContext:_managedObjectContext];
    
    [request setEntity:description];
    
    NSError *error = nil;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"error: %@", error);
    }

    if (resultArray.count > 0) {
        if (!_currentUser) {
            _currentUser = [[UserObject alloc] init];
        }
        UserManagedObject *userManagedObject = [resultArray firstObject];
        _currentUser.userId = userManagedObject.userId;
        _currentUser.firstName = userManagedObject.firstName;
        _currentUser.lastName = userManagedObject.lastName;
        _currentUser.avatarMediumUrl = userManagedObject.avatarMediumUrl;
        _currentUser.settings = userManagedObject.settings;
        return _currentUser;
    }else {
        return nil;
    }
}

- (UserObject *)currentUser {
    return [self returnUser];
}

#pragma mark Audio Object

- (AudioManagedObject*)createNewAudioObject {
    NSEntityDescription *audioDescription = [NSEntityDescription entityForName:@"AudioManagedObject" inManagedObjectContext:_managedObjectContext];
    return [[AudioManagedObject alloc] initWithEntity:audioDescription insertIntoManagedObjectContext:_managedObjectContext];
}

#pragma mark check

- (BOOL)checkAudioCached:(NSString*)title artist:(NSString*)artist {
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"AudioManagedObject" inManagedObjectContext:_managedObjectContext];
    [request setEntity:description];
    [request setPredicate:[NSPredicate predicateWithFormat:@"title == %@ and artist == %@",title,artist]];
    NSError *error = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];
    if (error) {
        NSLog(@"error: %@", error);
        return NO;
    }
    if (count > 0) {
        return YES;
    }
    return NO;
}

- (NSInteger)nextOrderNumber {
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"AudioManagedObject" inManagedObjectContext:_managedObjectContext];
    [request setEntity:description];
    NSError *error = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];
    if (error) {
        NSLog(@"error: %@", error);
        return 0;
    }
    return count;
}

- (void)clearAudioBase {
    [self deleteAllOubjectsFor:[self requestForAllMusic]];
    [self saveContext];
}

#pragma mark - Helpers

-(NSFetchRequest*)requestForAllMusic {
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:@"order" ascending:YES];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"AudioManagedObject" inManagedObjectContext:_managedObjectContext];
    request.entity = entity;
    request.sortDescriptors = @[descriptor];
    return request;
}

-(void)deleteAllOubjectsFor:(NSFetchRequest*)request{
    NSArray* objects = [self fetchedObjectsForRequest:request];
    
    [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [_managedObjectContext deleteObject:(NSManagedObject*)obj];
        
    }];
}

-(NSArray*)fetchedObjectsForRequest:(NSFetchRequest*)request
{
    if (request && [request isKindOfClass: [NSFetchRequest class]])
    {
        NSError* error;
        NSArray* objects = [_managedObjectContext executeFetchRequest:request error:&error];
        if (!error)
        {
            return objects;
        }
        else
        {
#ifdef DEBUG
            //NSLog(@"Unresolved error %@",error.description);
#endif
        }
    }
    return nil;
}

@end
