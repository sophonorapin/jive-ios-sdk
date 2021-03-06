//
//  JiveInboxEntryTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/6/12.
//
//    Copyright 2013 Jive Software Inc.
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
//

#import "JiveInboxEntryTests.h"
#import "JiveActivityObject.h"
#import "JiveMediaLink.h"
#import "JiveExtension.h"
#import "JiveOpenSocial.h"

@implementation JiveInboxEntryTests

- (void)setUp {
    
    self.inboxEntry = [[JiveInboxEntry alloc] init];
}

- (void)tearDown {
    
    self.inboxEntry = nil;
}

- (void)testDescription {
    
    JiveActivityObject *activity = [[JiveActivityObject alloc] init];

    [self.inboxEntry setValue:activity forKey:@"object"];
    STAssertEqualObjects(self.inboxEntry.description, @"(null) (null) -'(null)'", @"Empty description");
    
    activity.displayName = @"object";
    STAssertEqualObjects(self.inboxEntry.description, @"(null) (null) -'object'", @"Just a display name");
    
    self.inboxEntry.verb = @"walking";
    STAssertEqualObjects(self.inboxEntry.description, @"(null) walking -'object'", @"Verb and display name");
    
    [activity setValue:[NSURL URLWithString:@"http://test.com"] forKey:@"url"];
    STAssertEqualObjects(self.inboxEntry.description, @"http://test.com walking -'object'", @"URL, verb and display name");
    
    activity.displayName = @"tree";
    STAssertEqualObjects(self.inboxEntry.description, @"http://test.com walking -'tree'", @"A different display name");
    
    self.inboxEntry.verb = @"sitting";
    STAssertEqualObjects(self.inboxEntry.description, @"http://test.com sitting -'tree'", @"A different verb");
    
    [activity setValue:[NSURL URLWithString:@"http://bad.net"] forKey:@"url"];
    STAssertEqualObjects(self.inboxEntry.description, @"http://bad.net sitting -'tree'", @"A different url");
}

- (void)testToJSON {
    JiveInboxEntry *entry = [[JiveInboxEntry alloc] init];
    JiveActivityObject *actor = [[JiveActivityObject alloc] init];
    JiveActivityObject *generator = [[JiveActivityObject alloc] init];
    JiveActivityObject *object = [[JiveActivityObject alloc] init];
    JiveActivityObject *provider = [[JiveActivityObject alloc] init];
    JiveActivityObject *target = [[JiveActivityObject alloc] init];
    JiveMediaLink *icon = [[JiveMediaLink alloc] init];
    JiveExtension *jive = [[JiveExtension alloc] init];
    JiveOpenSocial *openSocial = [[JiveOpenSocial alloc] init];
    NSDictionary *JSON = [entry toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    actor.jiveId = @"2345";
    generator.jiveId = @"3456";
    object.jiveId = @"4567";
    provider.jiveId = @"5678";
    target.jiveId = @"6789";
    [icon setValue:[NSURL URLWithString:@"http://dummy.com/icon.png"] forKey:@"url"];
    jive.state = @"Colorado";
    [openSocial setValue:[NSArray arrayWithObject:@"/person/54321"] forKey:@"deliverTo"];
    entry.content = @"text";
    entry.jiveId = @"1234";
    entry.title = @"President";
    entry.verb = @"Running";
    [entry setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [entry setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [entry setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:@"url"];
    [entry setValue:actor forKey:@"actor"];
    [entry setValue:generator forKey:@"generator"];
    [entry setValue:object forKey:@"object"];
    [entry setValue:provider forKey:@"provider"];
    [entry setValue:target forKey:@"target"];
    [entry setValue:icon forKey:@"icon"];
    [entry setValue:jive forKey:@"jive"];
    [entry setValue:openSocial forKey:@"openSocial"];
    
    JSON = [entry toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)15, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"content"], entry.content, @"Wrong content.");
    STAssertEqualObjects([JSON objectForKey:@"id"], entry.jiveId, @"Wrong jive id.");
    STAssertEqualObjects([JSON objectForKey:@"title"], entry.title, @"Wrong title.");
    STAssertEqualObjects([JSON objectForKey:@"verb"], entry.verb, @"Wrong verb.");
    STAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:00:00.000+0000", @"Wrong published");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:16:40.123+0000", @"Wrong updated");
    STAssertEqualObjects([JSON objectForKey:@"url"], [entry.url absoluteString], @"Wrong url.");
    
    NSDictionary *actorJSON = [JSON objectForKey:@"actor"];
    
    STAssertTrue([[actorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([actorJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([actorJSON objectForKey:@"id"], actor.jiveId, @"Wrong value");
    
    NSDictionary *generatorJSON = [JSON objectForKey:@"generator"];
    
    STAssertTrue([[generatorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([generatorJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([generatorJSON objectForKey:@"id"], generator.jiveId, @"Wrong value");
    
    NSDictionary *objectJSON = [JSON objectForKey:@"object"];
    
    STAssertTrue([[objectJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([objectJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([objectJSON objectForKey:@"id"], object.jiveId, @"Wrong value");
    
    NSDictionary *providerJSON = [JSON objectForKey:@"provider"];
    
    STAssertTrue([[providerJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([providerJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([providerJSON objectForKey:@"id"], provider.jiveId, @"Wrong value");
    
    NSDictionary *targetJSON = [JSON objectForKey:@"target"];
    
    STAssertTrue([[targetJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([targetJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([targetJSON objectForKey:@"id"], target.jiveId, @"Wrong value");
    
    NSDictionary *iconJSON = [JSON objectForKey:@"icon"];
    
    STAssertTrue([[iconJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([iconJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([iconJSON objectForKey:@"url"], [icon.url absoluteString], @"Wrong value");
    
    NSDictionary *jiveJSON = [JSON objectForKey:@"jive"];
    
    STAssertTrue([[jiveJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([jiveJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([jiveJSON objectForKey:@"state"], jive.state, @"Wrong value");
    
    NSDictionary *openSocialJSON = [JSON objectForKey:@"openSocial"];
    NSArray *deliverToArray = [openSocialJSON objectForKey:@"deliverTo"];
    
    STAssertTrue([[openSocialJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([openSocialJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertTrue([[deliverToArray class] isSubclassOfClass:[NSArray class]], @"Sub-array not converted");
    STAssertEquals([deliverToArray count], (NSUInteger)1, @"Sub-array had the wrong number of entries");
    STAssertEqualObjects([deliverToArray objectAtIndex:0], [openSocial.deliverTo objectAtIndex:0], @"Wrong value");
}

- (void)testToJSON_alternate {
    JiveInboxEntry *entry = [[JiveInboxEntry alloc] init];
    JiveActivityObject *actor = [[JiveActivityObject alloc] init];
    JiveActivityObject *generator = [[JiveActivityObject alloc] init];
    JiveActivityObject *object = [[JiveActivityObject alloc] init];
    JiveActivityObject *provider = [[JiveActivityObject alloc] init];
    JiveActivityObject *target = [[JiveActivityObject alloc] init];
    JiveMediaLink *icon = [[JiveMediaLink alloc] init];
    JiveExtension *jive = [[JiveExtension alloc] init];
    JiveOpenSocial *openSocial = [[JiveOpenSocial alloc] init];
    NSDictionary *JSON = [entry toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    actor.jiveId = @"9876";
    generator.jiveId = @"8765";
    object.jiveId = @"7654";
    provider.jiveId = @"6543";
    target.jiveId = @"5432";
    [icon setValue:[NSURL URLWithString:@"http://super.com/icon.png"] forKey:@"url"];
    jive.state = @"Washington";
    [openSocial setValue:[NSArray arrayWithObject:@"/place/23456"] forKey:@"deliverTo"];
    entry.content = @"html";
    entry.jiveId = @"4321";
    entry.title = @"Grunt";
    entry.verb = @"Toil";
    [entry setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [entry setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [entry setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"url"];
    [entry setValue:actor forKey:@"actor"];
    [entry setValue:generator forKey:@"generator"];
    [entry setValue:object forKey:@"object"];
    [entry setValue:provider forKey:@"provider"];
    [entry setValue:target forKey:@"target"];
    [entry setValue:icon forKey:@"icon"];
    [entry setValue:jive forKey:@"jive"];
    [entry setValue:openSocial forKey:@"openSocial"];
    
    JSON = [entry toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)15, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"content"], entry.content, @"Wrong content.");
    STAssertEqualObjects([JSON objectForKey:@"id"], entry.jiveId, @"Wrong jive id.");
    STAssertEqualObjects([JSON objectForKey:@"title"], entry.title, @"Wrong title.");
    STAssertEqualObjects([JSON objectForKey:@"verb"], entry.verb, @"Wrong verb.");
    STAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:16:40.123+0000", @"Wrong published");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:00:00.000+0000", @"Wrong updated");
    STAssertEqualObjects([JSON objectForKey:@"url"], [entry.url absoluteString], @"Wrong url.");
    
    NSDictionary *actorJSON = [JSON objectForKey:@"actor"];
    
    STAssertTrue([[actorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([actorJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([actorJSON objectForKey:@"id"], actor.jiveId, @"Wrong value");
    
    NSDictionary *generatorJSON = [JSON objectForKey:@"generator"];
    
    STAssertTrue([[generatorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([generatorJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([generatorJSON objectForKey:@"id"], generator.jiveId, @"Wrong value");
    
    NSDictionary *objectJSON = [JSON objectForKey:@"object"];
    
    STAssertTrue([[objectJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([objectJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([objectJSON objectForKey:@"id"], object.jiveId, @"Wrong value");
    
    NSDictionary *providerJSON = [JSON objectForKey:@"provider"];
    
    STAssertTrue([[providerJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([providerJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([providerJSON objectForKey:@"id"], provider.jiveId, @"Wrong value");
    
    NSDictionary *targetJSON = [JSON objectForKey:@"target"];
    
    STAssertTrue([[targetJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([targetJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([targetJSON objectForKey:@"id"], target.jiveId, @"Wrong value");
    
    NSDictionary *iconJSON = [JSON objectForKey:@"icon"];
    
    STAssertTrue([[iconJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([iconJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([iconJSON objectForKey:@"url"], [icon.url absoluteString], @"Wrong value");
    
    NSDictionary *jiveJSON = [JSON objectForKey:@"jive"];
    
    STAssertTrue([[jiveJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([jiveJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([jiveJSON objectForKey:@"state"], jive.state, @"Wrong value");
    
    NSDictionary *openSocialJSON = [JSON objectForKey:@"openSocial"];
    NSArray *deliverToArray = [openSocialJSON objectForKey:@"deliverTo"];
    
    STAssertTrue([[openSocialJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([openSocialJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertTrue([[deliverToArray class] isSubclassOfClass:[NSArray class]], @"Sub-array not converted");
    STAssertEquals([deliverToArray count], (NSUInteger)1, @"Sub-array had the wrong number of entries");
    STAssertEqualObjects([deliverToArray objectAtIndex:0], [openSocial.deliverTo objectAtIndex:0], @"Wrong value");
}

- (void)testPlaceParsing {
    JiveInboxEntry *baseEntry = [[JiveInboxEntry alloc] init];
    JiveActivityObject *actor = [[JiveActivityObject alloc] init];
    JiveActivityObject *generator = [[JiveActivityObject alloc] init];
    JiveActivityObject *object = [[JiveActivityObject alloc] init];
    JiveActivityObject *provider = [[JiveActivityObject alloc] init];
    JiveActivityObject *target = [[JiveActivityObject alloc] init];
    JiveMediaLink *icon = [[JiveMediaLink alloc] init];
    JiveExtension *jive = [[JiveExtension alloc] init];
    JiveOpenSocial *openSocial = [[JiveOpenSocial alloc] init];
    
    actor.jiveId = @"2345";
    generator.jiveId = @"3456";
    object.jiveId = @"4567";
    provider.jiveId = @"5678";
    target.jiveId = @"6789";
    [icon setValue:[NSURL URLWithString:@"http://dummy.com/icon.png"] forKey:@"url"];
    jive.state = @"Colorado";
    [openSocial setValue:[NSArray arrayWithObject:@"/person/54321"] forKey:@"deliverTo"];
    baseEntry.content = @"text";
    baseEntry.jiveId = @"1234";
    baseEntry.title = @"President";
    baseEntry.verb = @"Running";
    [baseEntry setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [baseEntry setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [baseEntry setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:@"url"];
    [baseEntry setValue:actor forKey:@"actor"];
    [baseEntry setValue:generator forKey:@"generator"];
    [baseEntry setValue:object forKey:@"object"];
    [baseEntry setValue:provider forKey:@"provider"];
    [baseEntry setValue:target forKey:@"target"];
    [baseEntry setValue:icon forKey:@"icon"];
    [baseEntry setValue:jive forKey:@"jive"];
    [baseEntry setValue:openSocial forKey:@"openSocial"];
    
    id JSON = [baseEntry toJSONDictionary];
    JiveInboxEntry *entry = [JiveInboxEntry instanceFromJSON:JSON];
    
    STAssertEquals([entry class], [baseEntry class], @"Wrong item class");
    STAssertEqualObjects(entry.jiveId, baseEntry.jiveId, @"Wrong id");
    STAssertEqualObjects(entry.content, baseEntry.content, @"Wrong content");
    STAssertEqualObjects(entry.title, baseEntry.title, @"Wrong title");
    STAssertEqualObjects(entry.verb, baseEntry.verb, @"Wrong verb");
    STAssertEqualObjects(entry.published, baseEntry.published, @"Wrong published");
    STAssertEqualObjects(entry.updated, baseEntry.updated, @"Wrong updated");
    STAssertEqualObjects(entry.url, baseEntry.url, @"Wrong url");
    STAssertEqualObjects(entry.actor.jiveId, actor.jiveId, @"Wrong actor");
    STAssertEqualObjects(entry.generator.jiveId, generator.jiveId, @"Wrong generator");
    STAssertEqualObjects(entry.object.jiveId, object.jiveId, @"Wrong object");
    STAssertEqualObjects(entry.provider.jiveId, provider.jiveId, @"Wrong provider");
    STAssertEqualObjects(entry.target.jiveId, target.jiveId, @"Wrong target");
    STAssertEqualObjects(entry.icon.url, icon.url, @"Wrong icon");
    STAssertEqualObjects(entry.jive.state, jive.state, @"Wrong jive");
    STAssertEquals([entry.openSocial.deliverTo count], [openSocial.deliverTo count], @"Wrong number of deliverTo objects");
    STAssertEqualObjects([entry.openSocial.deliverTo objectAtIndex:0], [openSocial.deliverTo objectAtIndex:0], @"Wrong deliverTo object");
}

- (void)testPlaceParsingAlternate {
    JiveInboxEntry *baseEntry = [[JiveInboxEntry alloc] init];
    JiveActivityObject *actor = [[JiveActivityObject alloc] init];
    JiveActivityObject *generator = [[JiveActivityObject alloc] init];
    JiveActivityObject *object = [[JiveActivityObject alloc] init];
    JiveActivityObject *provider = [[JiveActivityObject alloc] init];
    JiveActivityObject *target = [[JiveActivityObject alloc] init];
    JiveMediaLink *icon = [[JiveMediaLink alloc] init];
    JiveExtension *jive = [[JiveExtension alloc] init];
    JiveOpenSocial *openSocial = [[JiveOpenSocial alloc] init];
    
    actor.jiveId = @"9876";
    generator.jiveId = @"8765";
    object.jiveId = @"7654";
    provider.jiveId = @"6543";
    target.jiveId = @"5432";
    [icon setValue:[NSURL URLWithString:@"http://super.com/icon.png"] forKey:@"url"];
    jive.state = @"Washington";
    [openSocial setValue:[NSArray arrayWithObject:@"/place/23456"] forKey:@"deliverTo"];
    baseEntry.content = @"html";
    baseEntry.jiveId = @"4321";
    baseEntry.title = @"Grunt";
    baseEntry.verb = @"Toil";
    [baseEntry setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [baseEntry setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [baseEntry setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"url"];
    [baseEntry setValue:actor forKey:@"actor"];
    [baseEntry setValue:generator forKey:@"generator"];
    [baseEntry setValue:object forKey:@"object"];
    [baseEntry setValue:provider forKey:@"provider"];
    [baseEntry setValue:target forKey:@"target"];
    [baseEntry setValue:icon forKey:@"icon"];
    [baseEntry setValue:jive forKey:@"jive"];
    [baseEntry setValue:openSocial forKey:@"openSocial"];
    
    id JSON = [baseEntry toJSONDictionary];
    JiveInboxEntry *entry = [JiveInboxEntry instanceFromJSON:JSON];
    
    STAssertEquals([entry class], [baseEntry class], @"Wrong item class");
    STAssertEqualObjects(entry.jiveId, baseEntry.jiveId, @"Wrong id");
    STAssertEqualObjects(entry.content, baseEntry.content, @"Wrong content");
    STAssertEqualObjects(entry.title, baseEntry.title, @"Wrong title");
    STAssertEqualObjects(entry.verb, baseEntry.verb, @"Wrong verb");
    STAssertEqualObjects(entry.published, baseEntry.published, @"Wrong published");
    STAssertEqualObjects(entry.updated, baseEntry.updated, @"Wrong updated");
    STAssertEqualObjects(entry.url, baseEntry.url, @"Wrong url");
    STAssertEqualObjects(entry.actor.jiveId, actor.jiveId, @"Wrong actor");
    STAssertEqualObjects(entry.generator.jiveId, generator.jiveId, @"Wrong generator");
    STAssertEqualObjects(entry.object.jiveId, object.jiveId, @"Wrong object");
    STAssertEqualObjects(entry.provider.jiveId, provider.jiveId, @"Wrong provider");
    STAssertEqualObjects(entry.target.jiveId, target.jiveId, @"Wrong target");
    STAssertEqualObjects(entry.icon.url, icon.url, @"Wrong icon");
    STAssertEqualObjects(entry.jive.state, jive.state, @"Wrong jive");
    STAssertEquals([entry.openSocial.deliverTo count], [openSocial.deliverTo count], @"Wrong number of deliverTo objects");
    STAssertEqualObjects([entry.openSocial.deliverTo objectAtIndex:0], [openSocial.deliverTo objectAtIndex:0], @"Wrong deliverTo object");
}

@end
