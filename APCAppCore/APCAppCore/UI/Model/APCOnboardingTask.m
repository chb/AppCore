// 
//  APCOnboardingTask.m 
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
 
#import "APCOnboardingTask.h"

NSString *const kAPCSignUpInclusionCriteriaStepIdentifier   = @"InclusionCriteria";
NSString *const kAPCSignUpEligibleStepIdentifier            = @"Eligible";
NSString *const kAPCSignUpIneligibleStepIdentifier          = @"Ineligible";
NSString *const kAPCSignUpGeneralInfoStepIdentifier         = @"GeneralInfo";
NSString *const kAPCSignUpMedicalInfoStepIdentifier         = @"MedicalInfo";
NSString *const kAPCSignUpCustomInfoStepIdentifier          = @"CustomInfo";
NSString *const kAPCSignUpPasscodeStepIdentifier            = @"Passcode";
NSString *const kAPCSignUpPermissionsStepIdentifier         = @"Permissions";
NSString *const kAPCSignUpThankYouStepIdentifier            = @"ThankYou";
NSString *const kAPCSignInStepIdentifier                    = @"SignIn";
NSString *const kAPCSignUpPermissionsPrimingStepIdentifier  = @"PermissionsPriming";

@implementation APCOnboardingTask

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentStepNumber = 0;
    }
    
    return self;
}

#pragma mark - ORKTask methods

- (ORKStep *)stepAfterStep:(ORKStep *) __unused step withResult:(ORKTaskResult *) __unused result
{
    NSAssert(FALSE, @"Override this delegate method by using either APCSignUpTask or APCSignInTask");
    return nil;
}

- (ORKStep *)stepBeforeStep:(ORKStep *) __unused step withResult:(ORKTaskResult *) __unused result
{
    NSAssert(FALSE, @"Override this delegate method by using either APCSignUpTask or APCSignInTask");
    return nil;
}

- (NSString *)identifier
{
    return @"OnboaringTask";
}

#pragma mark - Getter methods

- (BOOL)customStepIncluded
{
	return (nil != self.customInfoStep);
}

- (BOOL)skipPermissionsStep
{
    BOOL skip = NO;
    
    if ([self.delegate respondsToSelector:@selector(numberOfServicesInPermissionsListForOnboardingTask:)]) {
        NSInteger count = [self.delegate numberOfServicesInPermissionsListForOnboardingTask:self];
        skip = (count == 0);
    }
    
    return skip;
}

- (APCUser *)user
{
    if (!_user && [self.delegate respondsToSelector:@selector(userForOnboardingTask:)]) {
        self.user = [self.delegate userForOnboardingTask:self];
    }
    return _user;
}

@end
