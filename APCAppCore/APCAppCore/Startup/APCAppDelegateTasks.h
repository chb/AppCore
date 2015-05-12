//
//  APCAppDelegateTasks.h
//  APCAppCore
//
// Copyright (c) 2015 Boston Children's Hospital. All rights reserved.
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

@class APCDataSubstrate;
@class ORKTaskViewController;


/**
 *  Protocol, typically implemented by the AppDelegate, to handle init and data management tasks.
 */
@protocol APCAppDelegateTasks <NSObject>

@required
@property (copy, nonatomic, readonly, nullable) NSDictionary *initializationOptions;

@property (strong, nonatomic, readonly, nullable) APCDataSubstrate *dataSubstrate;

@end


#pragma mark -

/**
 *  Protocol, typically implemented by the AppDelegate, to handle onboarding.
 */
@protocol APCOnboardingTasks <NSObject>

@required

/**
 *  Use this to provide custom text on the All Set screen.
 *
 *  You must return an array full of dictionaries, each with the main text keyed with `kAllSetActivitiesTextOriginal`
 *  and supplementary text keyed with `kAllSetActivitiesTextAdditional` or `kAllSetDashboardTextOriginal` and
 *  `kAllSetDashboardTextAdditional`.
 *
 *  Please don't be glutenous, don't use four words when one would suffice.
 */
- (nonnull NSArray *)allSetTextBlocks;

@optional

/**
 *  Use this as a hook to post-process anything that is needed to be processed right after the 'finishOnboarding' method
 *  is invoked.
 */
- (void)afterOnBoardProcessIsFinished;

@end


#pragma mark -

/**
 *  Protocol, typically implemented by the AppDelegate, to handle consenting.
 */
@protocol APCConsentingTasks <NSObject>

@required
@property (nonatomic, readonly) BOOL disableSignatureInConsent;

- (nonnull ORKTaskViewController *)consentViewController;

@end
