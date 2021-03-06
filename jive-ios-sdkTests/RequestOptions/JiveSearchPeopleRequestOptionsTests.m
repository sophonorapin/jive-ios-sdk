//
//  JiveSearchPeopleRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
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

#import "JiveSearchPeopleRequestOptionsTests.h"

@implementation JiveSearchPeopleRequestOptionsTests

- (JiveSearchPeopleRequestOptions *)peopleOptions {
    
    return (JiveSearchPeopleRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveSearchPeopleRequestOptions alloc] init];
}

- (void)testNameOnly {
    
    self.peopleOptions.nameonly = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=nameonly", asString, @"Wrong string contents");
}

- (void)testNameOnlyWithOtherFields {
    
    [self.peopleOptions addField:@"name"];
    self.peopleOptions.nameonly = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&filter=nameonly", asString, @"Wrong string contents");
    
    [self.peopleOptions addSearchTerm:@"mention"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=nameonly", asString, @"Wrong string contents");
}

@end
