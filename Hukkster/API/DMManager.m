//
//  DMManager.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 15.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "DMManager.h"
#import "WebServiceManager.h"
#import "BaseObject.h"
#import "AppDelegate.h"

@interface DMManager()
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

static DMManager *sharedManager = NULL;

@implementation DMManager

#pragma mark - Properties

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    
    return _managedObjectContext;
}

#pragma mark - Designated Initializer

- (id)init
{
    if (self = [super init]) {}
    
    return self;
}

#pragma mark - Public API

+ (DMManager *)sharedInstance
{
	@synchronized(self) {
        if (sharedManager == nil) {
            sharedManager = [[super allocWithZone:NULL] init];
        }
    }
	
	return sharedManager;
}

- (void)parseResponseData:(NSData *)data withProcess:(WebServiceProcess)process
{
    NSError *error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSLog(@"%@", dictionary);
    
    if (process ==  PROCESS) {
        // Parsing JSON
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"" object:nil];
    }
    
    [[WebServiceManager sharedInstance] removeLoader];
}

- (void)parsePostData:(NSData *)data withProcess:(PostToWebServiceProcess)process
{
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", content);
    
    if (process == LOGIN_PROCESS) {
        NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if (dictionary) {}
    }
}

#pragma mark - Core Data

- (NSMutableArray *)fetchEntity:(NSString *)entityName
                     withFilter:(NSString *)filter
                    withSortAsc:(BOOL)sortAscending
                         forKey:(NSString *)sortKey
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entityDescription];
    
    // Sorting
    if (sortKey != nil) {
        NSSortDescriptor *ratingDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:sortAscending];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:ratingDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    // Filtering
    if (filter != nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:filter];
        [fetchRequest setPredicate:predicate];
    }
	
	NSError *error;
	NSMutableArray *resultsArray = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
	if (resultsArray == nil) NSLog(@"Error fetching %@(s).", entityName);
	
	return	resultsArray;
}

- (void)saveDatabase
{
    [self.managedObjectContext save:nil];
}

- (void)deleteObjectInDatabase:(NSManagedObject *)object
{
    [self.managedObjectContext deleteObject:object];
    
    [self saveDatabase];
}

- (BOOL)object:(NSManagedObject *)object respondsToKey:(NSString *)key
{
    BOOL hasProperty = [[object.entity propertiesByName] objectForKey:key] != nil;
    
    return hasProperty;
}

- (void)logObject:(NSManagedObject *)object
{
    // Get attributes of NSManagedObject
    NSEntityDescription *description = [object entity];
    NSDictionary *attributes = [description attributesByName];
    
    for (NSString *attribute in attributes) {
        // Get attribute type for NSManagedObject attribute
        //NSAttributeDescription *attributeDescription = [attributes objectForKey:attribute];
        //NSAttributeType attributeType = [attributeDescription attributeType];
        NSLog(@"%@ = %@", attribute, [object valueForKey:attribute]);
    }
}

@end