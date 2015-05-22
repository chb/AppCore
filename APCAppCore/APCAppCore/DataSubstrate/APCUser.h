//
//  APCUser.h
//  APCAppCore
//
// Copyright (c) 2015, Apple Inc. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// 1.  Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// 2.  Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation and/or
// other materials provided with the distribution.
//
// 3.  Neither the name of the copyright holder(s) nor the names of any contributors
// may be used to endorse or promote products derived from this software without
// specific prior written permission. No license is granted to the trademarks of
// the copyright holders even if such marks are included in this software.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, APCUserConsentSharingScope) {
	APCUserConsentSharingScopeNone = 0,
	APCUserConsentSharingScopeStudy,
	APCUserConsentSharingScopeAll,
};


@protocol APCUser <NSObject>


#pragma mark Demographics

@property (copy, nonatomic, nullable) NSString *name;

@property (copy, nonatomic, nullable) NSString *email;

@property (copy, nonatomic, nullable) NSString *password;

@property (copy, nonatomic, nullable) NSString *sessionToken;

@property (strong, nonatomic, nullable) NSDate *birthDate;

@property (nonatomic) HKBiologicalSex biologicalSex;

@property (nonatomic) HKBloodType bloodType;

@property (copy, nonatomic, nullable) NSString *ethnicity;

@property (strong, nonatomic, nullable) NSData *profileImage;

@property (copy, nonatomic, nullable) NSNumber *homeLocationLong;

@property (copy, nonatomic, nullable) NSNumber *homeLocationLat;

@property (copy, nonatomic, nullable) NSString *homeLocationAddress;


#pragma mark Vitals, Conditions & Meds

@property (strong, nonatomic, nullable) HKQuantity *bodyheight;

@property (strong, nonatomic, nullable) HKQuantity *bodyweight;

@property (strong, nonatomic, nullable) NSDate *sleepTime;

@property (strong, nonatomic, nullable) NSDate *wakeUpTime;

@property (copy, nonatomic, nullable) NSString *medicalConditions;

@property (copy, nonatomic, nullable) NSString *medications;


#pragma mark Consenting

@property (nonatomic) APCUserConsentSharingScope sharingScope;      // NOT stored to CoreData, reflected in "sharedOptionSelection"

@property (nonatomic) BOOL userConsented;

@property (nonatomic) BOOL serverConsented;

@property (strong, nonatomic, nullable) NSDate *consentSignatureDate;

@property (copy, nonatomic, nullable) NSString *consentSignatureName;

@property (strong, nonatomic, nullable) NSData *consentSignatureImage;


#pragma mark Signup/Signin

@property (nonatomic) BOOL signedUp;

@property (nonatomic) BOOL signedIn;

@property (nonatomic) BOOL secondaryInfoSaved;


- (void)signUpOnCompletion:(void(^)(NSError *__nullable error))callback;

- (void)withdrawStudyOnCompletion:(void (^)(NSError *__nullable error))callback;

@end

NS_ASSUME_NONNULL_END
