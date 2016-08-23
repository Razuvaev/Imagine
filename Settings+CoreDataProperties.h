//
//  Settings+CoreDataProperties.h
//  
//
//  Created by Vladimir Vishnyagov on 23.08.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Settings.h"

NS_ASSUME_NONNULL_BEGIN

@interface Settings (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *autodownload;
@property (nullable, nonatomic, retain) UserManagedObject *user;

@end

NS_ASSUME_NONNULL_END
