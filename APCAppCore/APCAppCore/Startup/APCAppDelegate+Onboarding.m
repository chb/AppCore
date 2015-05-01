//
//  APCAppDelegate+Onboarding.m
//  APCAppCore
//
//  Copyright (c) 2015 Boston Children's Hospital, Inc. All rights reserved.
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

#import "APCAppDelegate+Onboarding.h"
#import "APCOnboarding.h"
#import "APCLog.h"

#import "APCEligibleViewController.h"
#import "APCInEligibleViewController.h"
#import "APCPermissionPrimingViewController.h"
#import "APCSignUpGeneralInfoViewController.h"
#import "APCSignUpMedicalInfoViewController.h"
#import "APCSignupPasscodeViewController.h"
#import "APCSignUpPermissionsViewController.h"
#import "APCThankYouViewController.h"
#import "APCSignInViewController.h"

#import "NSBundle+Helper.h"


@implementation APCAppDelegate (Onboarding)

- (void)instantiateOnboardingForType:(APCOnboardingTaskType)type
{
    if (self.onboarding) {
        self.onboarding.delegate = nil;
        self.onboarding = nil;
    }
    
    self.onboarding = [[APCOnboarding alloc] initWithDelegate:self taskType:type];
}


#pragma mark - APCOnboardingTaskDelegate methods

- (APCUser *) userForOnboardingTask: (APCOnboardingTask *) __unused task
{
    return self.dataSubstrate.currentUser;
}

- (NSInteger) numberOfServicesInPermissionsListForOnboardingTask: (APCOnboardingTask *) __unused task
{
    NSArray *servicesArray = self.initializationOptions[kAppServicesListRequiredKey];
    return servicesArray.count;
}


#pragma mark - APCOnboardingDelegate methods

- (APCScene *)onboarding:(APCOnboarding *__unused)onboarding sceneOfType:(NSString *)type
{
    NSParameterAssert([type length] > 0);
    
    if ([type isEqualToString:kAPCSignUpInclusionCriteriaStepIdentifier]) {
        NSAssert(NO, @"Cannot retun nil. Override this delegate method to return a valid signup APCScene.");
        return nil;
    }
    if ([type isEqualToString:kAPCSignUpEligibleStepIdentifier]) {
        APCScene *scene = [APCScene new];
        scene.name = NSStringFromClass([APCEligibleViewController class]);
        scene.storyboardName = kOnboardingStoryboardName;
        scene.bundle = [NSBundle appleCoreBundle];
        
        return scene;
    }
    if ([type isEqualToString:kAPCSignUpIneligibleStepIdentifier]) {
        APCScene *scene = [APCScene new];
        scene.name = NSStringFromClass([APCInEligibleViewController class]);
        scene.storyboardName = kOnboardingStoryboardName;
        scene.bundle = [NSBundle appleCoreBundle];
        
        return scene;
    }
    if ([type isEqualToString:kAPCSignUpPermissionsPrimingStepIdentifier]) {
        APCScene *scene = [APCScene new];
        scene.name = NSStringFromClass([APCPermissionPrimingViewController class]);
        scene.storyboardName = kOnboardingStoryboardName;
        scene.bundle = [NSBundle appleCoreBundle];
        
        return scene;
    }
    if ([type isEqualToString:kAPCSignUpGeneralInfoStepIdentifier]) {
        APCScene *scene = [APCScene new];
        scene.name = NSStringFromClass([APCSignUpGeneralInfoViewController class]);
        scene.storyboardName = kOnboardingStoryboardName;
        scene.bundle = [NSBundle appleCoreBundle];
        
        return scene;
    }
    if ([type isEqualToString:kAPCSignUpMedicalInfoStepIdentifier]) {
        APCScene *scene = [APCScene new];
        scene.name = NSStringFromClass([APCSignUpMedicalInfoViewController class]);
        scene.storyboardName = kOnboardingStoryboardName;
        scene.bundle = [NSBundle appleCoreBundle];
        
        return scene;
    }
    if ([type isEqualToString:kAPCSignUpCustomInfoStepIdentifier]) {
        return nil;
    }
    if ([type isEqualToString:kAPCSignUpPasscodeStepIdentifier]) {
        APCScene *scene = [APCScene new];
        scene.name = NSStringFromClass([APCSignupPasscodeViewController class]);
        scene.storyboardName = kOnboardingStoryboardName;
        scene.bundle = [NSBundle appleCoreBundle];
        
        return scene;
    }
    if ([type isEqualToString:kAPCSignUpPermissionsStepIdentifier]) {
        APCScene *scene = [APCScene new];
        scene.name = NSStringFromClass([APCSignUpPermissionsViewController class]);
        scene.storyboardName = kOnboardingStoryboardName;
        scene.bundle = [NSBundle appleCoreBundle];
        
        return scene;
    }
    if ([type isEqualToString:kAPCSignUpThankYouStepIdentifier]) {
        APCScene *scene = [APCScene new];
        scene.name = NSStringFromClass([APCThankYouViewController class]);
        scene.storyboardName = kOnboardingStoryboardName;
        scene.bundle = [NSBundle appleCoreBundle];
        
        return scene;
    }
    if ([type isEqualToString:kAPCSignInStepIdentifier]) {
        APCScene *scene = [APCScene new];
        scene.name = NSStringFromClass([APCSignInViewController class]);
        scene.storyboardName = kOnboardingStoryboardName;
        scene.bundle = [NSBundle appleCoreBundle];
        
        return scene;
    }
    
    APCLogDebug(@"Unknown onboarding scene type: \"%@\"", type);
    return nil;
}

@end
