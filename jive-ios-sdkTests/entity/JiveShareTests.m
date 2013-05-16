//
//  JiveShareTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/26/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveShareTests.h"

@implementation JiveShareTests

- (void)setUp {
    self.typedObject = [[JiveShare alloc] init];
}

- (JiveShare *)share {
    return (JiveShare *)self.content;
}

- (void)testType {
    STAssertEqualObjects(self.share.type, @"share", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.share.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.share class], @"Share class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.share class], @"Share class not registered with JiveContent.");
}

- (void)testShareToJSON {
    JivePlace *sharedPlace = [JivePlace new];
    JiveContent *sharedContent = [JiveContent new];
    NSDictionary *JSON = [self.share toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"share", @"Wrong type");
    
    sharedPlace.description = @"Going places";
    sharedContent.subject = @"What to do when you get there.";
    [self.share setValue:sharedContent forKey:JiveShareAttributes.sharedContent];
    [self.share setValue:sharedPlace forKey:JiveShareAttributes.sharedPlace];
    
    JSON = [self.share toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.share.type, @"Wrong type");
    
    NSDictionary *itemJSON = [JSON objectForKey:JiveShareAttributes.sharedContent];
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:JiveContentAttributes.subject], sharedContent.subject, @"Wrong description");
    
    itemJSON = [JSON objectForKey:JiveShareAttributes.sharedPlace];
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:JivePlaceAttributes.description], sharedPlace.description, @"Wrong description");
}

- (void)testShareToJSON_alternate {
    JivePlace *sharedPlace = [JivePlace new];
    JiveContent *sharedContent = [JiveContent new];
    
    sharedPlace.description = @"Rock solid";
    sharedContent.subject = @"What to do in Denver when you're dead.";
    [self.share setValue:sharedContent forKey:JiveShareAttributes.sharedContent];
    [self.share setValue:sharedPlace forKey:JiveShareAttributes.sharedPlace];
    
    NSDictionary *JSON = [self.share toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.share.type, @"Wrong type");
    
    NSDictionary *itemJSON = [JSON objectForKey:JiveShareAttributes.sharedContent];
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:JiveContentAttributes.subject], sharedContent.subject, @"Wrong description");
    
    itemJSON = [JSON objectForKey:JiveShareAttributes.sharedPlace];
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:JivePlaceAttributes.description], sharedPlace.description, @"Wrong description");
}

- (void)testShareParsing {
    JivePerson *participant = [JivePerson new];
    JivePlace *sharedPlace = [JivePlace new];
    JiveContent *sharedContent = [JiveContent new];
    
    participant.status = @"Doing fine";
    sharedPlace.description = @"Going places";
    sharedContent.subject = @"What to do when you get there.";
    [self.share setValue:sharedContent forKey:JiveShareAttributes.sharedContent];
    [self.share setValue:sharedPlace forKey:JiveShareAttributes.sharedPlace];
    
    id JSON = [self.share toJSONDictionary];
    JiveShare *newContent = [JiveShare instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.share class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.share.type, @"Wrong type");
    STAssertEqualObjects(newContent.sharedContent.subject, self.share.sharedContent.subject, @"Wrong shared content");
    STAssertEqualObjects(newContent.sharedPlace.description, self.share.sharedPlace.description, @"Wrong shared place");
}

- (void)testShareParsingAlternate {
    JivePerson *participant = [JivePerson new];
    JivePlace *sharedPlace = [JivePlace new];
    JiveContent *sharedContent = [JiveContent new];
    
    participant.status = @"Twisting and Turning";
    sharedPlace.description = @"Rock solid";
    sharedContent.subject = @"What to do in Denver when you're dead.";
    [self.share setValue:sharedContent forKey:JiveShareAttributes.sharedContent];
    [self.share setValue:sharedPlace forKey:JiveShareAttributes.sharedPlace];
    
    id JSON = [self.share toJSONDictionary];
    JiveShare *newContent = [JiveShare instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.share class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.share.type, @"Wrong type");
    STAssertEqualObjects(newContent.sharedContent.subject, self.share.sharedContent.subject, @"Wrong shared content");
    STAssertEqualObjects(newContent.sharedPlace.description, self.share.sharedPlace.description, @"Wrong shared place");
}

@end
