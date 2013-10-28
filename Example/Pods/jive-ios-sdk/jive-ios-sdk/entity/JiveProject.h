//
//  JiveProject.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/15/12.
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

#import "JivePlace.h"
#import "JivePerson.h"

extern struct JiveProjectAttributes {
    __unsafe_unretained NSString *creator;
    __unsafe_unretained NSString *dueDate;
    __unsafe_unretained NSString *locale;
    __unsafe_unretained NSString *projectStatus;
    __unsafe_unretained NSString *startDate;
    __unsafe_unretained NSString *tags;
} const JiveProjectAttributes;

//! \class JiveProject
//! https://developers.jivesoftware.com/api/v3/rest/ProjectEntity.html
@interface JiveProject : JivePlace

//! Person that created this social group.
@property(nonatomic, readonly, strong) JivePerson* creator;

//! Date by which this project must be completed.
@property(nonatomic, strong) NSDate* dueDate;

//! Locale string of the space.
@property (nonatomic, copy) NSString *locale;

//! Current status of this project with respect to its schedule. TODO - enumerate values
@property(nonatomic, readonly, copy) NSString* projectStatus;

//! Date that this project was (or will be) started.
@property(nonatomic, strong) NSDate* startDate;

//! Tags associated with this object. String[]
@property(nonatomic, strong) NSArray* tags;

@end