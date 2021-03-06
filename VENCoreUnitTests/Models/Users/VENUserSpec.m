#import "VENUser.h"
#import "VENCore.h"
#import "VENUserPayloadKeys.h"
#import "VENTestUtilities.h"

SpecBegin(VENUser)

NSDictionary *validUserDictionary1 = @{VENUserKeyUsername: @"PeterIsAZakin",
                                       VENUserKeyInternalId: @"234234",
                                       VENUserKeyExternalId: @"JLHDSJFIOHh23ioHLH",
                                       VENUserKeyFirstName: @"Peter",
                                       VENUserKeyLastName: @"Maddern",
                                       VENUserKeyAbout: @"Happily married!"};

NSDictionary *validUserDictionary2 = @{VENUserKeyUsername: @"PetefadsrIsAZakin",
                                       VENUserKeyInternalId: @"234223434",
                                       VENUserKeyExternalId: @"JLHDSfadJfsdFIOHh23ioHLH",
                                       VENUserKeyFirstName: @"Pefadster",
                                       VENUserKeyLastName: @"Mafadsddern",
                                       VENUserKeyAbout: @"Happifasdly married!"};

NSDictionary *validUserDictionary3 = @{VENUserKeyUsername: @"PetefadsrIsAZakin",
                                       VENUserKeyInternalId: @"234223434",
                                       VENUserKeyExternalId: @"JLHDSJFIOHh23ioHLH",
                                       VENUserKeyFirstName: @"Pefadster",
                                       VENUserKeyLastName: @"Mafadsddern",
                                       VENUserKeyAbout: @"Happifasdly married!"};

NSDictionary *invalidUserDictionary1 = @{VENUserKeyInternalId: @"234234",
                                         VENUserKeyExternalId: @"JLHDSJFIOHh23ioHLH",
                                         VENUserKeyFirstName: @"Peter",
                                         VENUserKeyLastName: @"Maddern",
                                         VENUserKeyAbout: @"Happily married!"};

// This does not contain the external ID
NSDictionary *invalidUserDictionary2 = @{VENUserKeyUsername: @"PeterIsAZakin",
                                         VENUserKeyFirstName: @"Peter",
                                         VENUserKeyLastName: @"Maddern",
                                         VENUserKeyAbout: @"Happily married!"};


void(^assertUsersAreFieldwiseEqual)(VENUser *, VENUser *) = ^(VENUser *user1, VENUser *user2) {
    expect(user1.username).to.equal(user2.username);
    expect(user1.firstName).to.equal(user2.firstName);
    expect(user1.lastName).to.equal(user2.lastName);
    expect(user1.displayName).to.equal(user2.displayName);
    expect(user1.about).to.equal(user2.about);
    expect(user1.primaryPhone).to.equal(user2.primaryPhone);
    expect(user1.primaryEmail).to.equal(user2.primaryEmail);
    expect(user1.internalId).to.equal(user2.internalId);
    expect(user1.externalId).to.equal(user2.externalId);
    expect(user1.dateJoined).to.equal(user2.dateJoined);
    expect(user1.profileImageUrl).to.equal(user2.profileImageUrl);
};


beforeAll(^{
    VENCore *core = [[VENCore alloc] init];
    [VENCore setDefaultCore:core];

    [[LSNocilla sharedInstance] start];
});

afterAll(^{
    [[LSNocilla sharedInstance] stop];
});

afterEach(^{
    [[LSNocilla sharedInstance] clearStubs];
});


describe(@"Initialization", ^{

    it(@"should succesfully create an empty object from init", ^{
        VENUser *usr = [[VENUser alloc] init];
        expect(usr).toNot.beNil();

        expect(usr.username).to.beNil();
        expect(usr.firstName).to.beNil();
        expect(usr.lastName).to.beNil();
        expect(usr.profileImageUrl).to.beNil();
    });

    it(@"should return NO to canInitWithDictionary for an invalid dictionary", ^{
        BOOL canInit = [VENUser canInitWithDictionary:invalidUserDictionary1];
        expect(canInit).to.beFalsy();

        canInit = [VENUser canInitWithDictionary:invalidUserDictionary2];
        expect(canInit).to.beFalsy();
    });

    it(@"should return NO to a nil or empty dictionary", ^{
        BOOL canInit = [VENUser canInitWithDictionary:@{}];
        expect(canInit).to.beFalsy();

        canInit = [VENUser canInitWithDictionary:nil];
        expect(canInit).to.beFalsy();
    });

    it(@"should return YES to canInitWithDictionary for a valid dictionary", ^{
        BOOL canInit = [VENUser canInitWithDictionary:validUserDictionary1];
        expect(canInit).to.beTruthy();
    });

    it(@"should create a user with minimally a username and externalId for dictionaries that return YES to canInitWithDictionary",^{
        VENUser *user1 = [[VENUser alloc] initWithDictionary:validUserDictionary1];
        expect(user1.username).to.equal(@"PeterIsAZakin");
        expect(user1.externalId).to.equal(@"JLHDSJFIOHh23ioHLH");
        VENUser *user2 = [[VENUser alloc] initWithDictionary:validUserDictionary2];
        expect(user2.username).to.equal(@"PetefadsrIsAZakin");
        expect(user2.externalId).to.equal(@"JLHDSfadJfsdFIOHh23ioHLH");
    });

});


describe(@"Copying", ^{

    it(@"should create a valid copy of any empty object", ^{
        VENUser *usr = [[VENUser alloc] init];

        VENUser *myOtherUser = [usr copy];

        expect(myOtherUser).notTo.beNil();
        expect(myOtherUser).to.beKindOf([usr class]);

    });

    it(@"should create a valid copy of a valid user", ^{
        VENUser *user = [[VENUser alloc] initWithDictionary:validUserDictionary1];
        VENUser *newUser = [user copy];

        expect(user).to.equal(newUser);
    });
});


describe(@"Equality", ^{

    it(@"should correctly validate two equal objects", ^{
        VENUser *user1 = [[VENUser alloc] initWithDictionary:validUserDictionary1];
        VENUser *user2 = [user1 copy];

        expect([user1 isEqual:user2]).to.beTruthy();

        VENUser *user3 = [[VENUser alloc] initWithDictionary:validUserDictionary3];

        expect([user1 isEqual:user3]).to.beTruthy();
    });

    it(@"should not indicate that two different users are the same", ^{
        VENUser *user1 = [[VENUser alloc] initWithDictionary:validUserDictionary1];
        VENUser *user2 = [[VENUser alloc] initWithDictionary:validUserDictionary2];

        expect([user1 isEqual:user2]).to.beFalsy();
    });

    it(@"should behave transitively", ^{
        VENUser *user1 = [[VENUser alloc] initWithDictionary:validUserDictionary1];
        VENUser *user2 = [[VENUser alloc] initWithDictionary:validUserDictionary2];

        expect([user1 isEqual:user2]).to.beFalsy();
        expect([user2 isEqual:user1]).to.beFalsy();

        user1 = [[VENUser alloc] initWithDictionary:validUserDictionary1];
        user2 = [user1 copy];

        expect([user1 isEqual:user2]).to.beTruthy();
        expect([user2 isEqual:user1]).to.beTruthy();
    });

    it(@"should follow the rule that two users are equal ONLY if their external Ids are the same", ^{
        VENUser *user = [[VENUser alloc] init];
        VENUser *myOtherUser = [user copy];

        expect(user).toNot.equal(myOtherUser);

        VENUser *invalidUser = [[VENUser alloc] initWithDictionary:invalidUserDictionary2];
        VENUser *copiedInvalidUser = [invalidUser copy];

        expect(invalidUser).toNot.equal(copiedInvalidUser);
    });

});

describe(@"Dictionary Representation", ^{
    it(@"should consider dictionary representations of equal users to be equal", ^{
        VENUser *user1 = [[VENUser alloc] initWithDictionary:validUserDictionary1];
        NSDictionary *user1Dictionary = [user1 dictionaryRepresentation];

        VENUser *user2 = [[VENUser alloc] initWithDictionary:user1Dictionary];
        expect([user1 isEqual:user2]).to.beTruthy();
        assertUsersAreFieldwiseEqual(user1, user2);

    });

});


describe(@"Fetching a User", ^{
    it(@"should retrieve a pre-canned Chris user and create a valid user", ^{
        NSString *externalId = @"1106387358711808333";

        NSString *baseURLString = [VENTestUtilities baseURLStringForCore:[VENCore defaultCore]];
        NSString *urlToStub = [NSString stringWithFormat:@"%@/%@/%@?", baseURLString, VENAPIPathUsers, externalId];

        [VENTestUtilities stubNetworkGET:urlToStub withStatusCode:200 andResponseFilePath:@"fetchChrisUser"];
        waitUntil(^(DoneCallback done) {
            [VENUser fetchUserWithExternalId:externalId success:^(VENUser *user) {

                expect(user.externalId).to.equal(externalId);
                done();
            } failure:^(NSError *error) {
                failure(@"Failed to return correct response.");
                done();
            }];
        });

    });

    it(@"should call failure when cannot find a user with that external Id", ^{
        NSString *externalId = @"1106387358711808339"; //invalid external id

        NSString *baseURLString = [VENTestUtilities baseURLStringForCore:[VENCore defaultCore]];
        NSString *urlToStub = [NSString stringWithFormat:@"%@/%@/%@?", baseURLString, VENAPIPathUsers, externalId];

        [VENTestUtilities stubNetworkGET:urlToStub withStatusCode:400 andResponseFilePath:@"fetchInvalidUser"];

        waitUntil(^(DoneCallback done) {
            [VENUser fetchUserWithExternalId:externalId success:^(VENUser *user) {
                failure(@"Failed to return correct response.");
                done();
            } failure:^(NSError *error) {
                expect([error localizedDescription]).to.equal(@"Resource not found.");
                done();
            }];
        });
    });

    it(@"should call failure when not passed an external id", ^{
        waitUntil(^(DoneCallback done) {
            [VENUser fetchUserWithExternalId:nil success:^(VENUser *user) {
                failure(@"Failed to return correct response.");
                done();
            } failure:^(NSError *error) {
                expect(error).notTo.beNil();
                done();
            }];
        });
    });

    it(@"should call failure when passed an empty-string external id", ^{
        waitUntil(^(DoneCallback done) {
            [VENUser fetchUserWithExternalId:@"" success:^(VENUser *user) {
                failure(@"Failed to return correct response.");
                done();
            } failure:^(NSError *error) {
                expect(error).notTo.beNil();
                done();
            }];
        });
    });

});

describe(@"Fetching Friends", ^{
    it(@"should retrieve a pre-canned list of friends and create a valid array of friends", ^{
        NSString *externalId = @"110638735871180833";
        NSString *baseURLString = [VENTestUtilities baseURLStringForCore:[VENCore defaultCore]];
        NSString *urlToStub = [NSString stringWithFormat:@"%@/users/%@/friends?limit=1000", baseURLString, externalId];
        [VENTestUtilities stubNetworkGET:urlToStub withStatusCode:200 andResponseFilePath:@"fetchFriends"];

        waitUntil(^(DoneCallback done) {
            [VENUser fetchFriendsWithExternalId:externalId success:^(NSArray *friendsArray) {
                expect([friendsArray count]).to.equal(5);
                expect([friendsArray[0] class]).to.equal([VENUser class]);
                expect([friendsArray[2] class]).to.equal([VENUser class]);
                done();

            } failure:^(NSError *error){
                failure(@"Failed to return correct response.");
                done();
            }];
        });
    });

    it(@"should retrieve a pre-canned list of friends and deletes the NSNull key and value from the friend", ^{
        NSString *externalId = @"110638735871180833";
        NSString *baseURLString = [VENTestUtilities baseURLStringForCore:[VENCore defaultCore]];
        NSString *urlToStub = [NSString stringWithFormat:@"%@/users/%@/friends?limit=1000", baseURLString, externalId];
        [VENTestUtilities stubNetworkGET:urlToStub withStatusCode:200 andResponseFilePath:@"fetchFriends"];

        waitUntil(^(DoneCallback done) {
            [VENUser fetchFriendsWithExternalId:externalId success:^(NSArray *friendsArray) {
                for (id object in friendsArray) {
                    if ([object isKindOfClass:[VENUser class]]) {
                        VENUser *user = (VENUser *) object;
                        if ([user.username isEqualToString:@"great-friend"]) {
                            expect(user.profileImageUrl).to.beNil();
                        }
                    }
                }
                done();
            } failure:^(NSError *error) {
                failure(@"Failed to return correct response.");
                done();
            }];
        });
    });

    it(@"should retrieve a pre-canned list of friends and the users should be in the same order as the JSON and their values should be consistent with the JSON values", ^{
        NSString *externalId = @"110638735871180833";
        NSString *baseURLString = [VENTestUtilities baseURLStringForCore:[VENCore defaultCore]];
        NSString *urlToStub = [NSString stringWithFormat:@"%@/users/%@/friends?limit=1000", baseURLString, externalId];
        [VENTestUtilities stubNetworkGET:urlToStub withStatusCode:200 andResponseFilePath:@"fetchFriends"];

        waitUntil(^(DoneCallback done) {
            [VENUser fetchFriendsWithExternalId:externalId success:^(NSArray *friendsArray) {
                if ([friendsArray[0] isKindOfClass:[VENUser class]]){
                    VENUser *friend = (VENUser *) friendsArray[0];
                    expect(friend.username).to.equal(@"kortina");
                    expect(friend.about).to.equal(@"make a joyful sound, la da da da");
                }
                done();
            } failure:^(NSError *error) {
                failure(@"Failed to return correct response.");
                done();
            }];
        });
    });

    it(@"should call failure when cannot find a user with that external Id", ^{
        NSString *externalId = @"1106387358711808339"; //invalid external id
        NSString *baseURLString = [VENTestUtilities baseURLStringForCore:[VENCore defaultCore]];
        NSString *urlToStub = [NSString stringWithFormat:@"%@/users/%@/friends?limit=1000", baseURLString, externalId];
        [VENTestUtilities stubNetworkGET:urlToStub withStatusCode:400 andResponseFilePath:@"fetchInvalidFriends"];

        waitUntil(^(DoneCallback done) {
            [VENUser fetchFriendsWithExternalId:externalId success:^(NSArray *friendsArray) {
                failure(@"Failed to return correct response.");
                done();
            } failure:^(NSError *error) {
                expect([error localizedDescription]).to.equal(@"Resource not found.");
                done();
            }];
        });
    });

    it(@"should call failure when not passed an external id", ^{
        waitUntil(^(DoneCallback done) {
            [VENUser fetchFriendsWithExternalId:nil success:^(NSArray *friendsArray) {
                failure(@"Failed to return correct response.");
                done();
            } failure:^(NSError *error) {
                expect(error).notTo.beNil();
                done();
            }];
        });
    });

    it(@"should call failure when passed an empty-string external id", ^{
        waitUntil(^(DoneCallback done) {
            [VENUser fetchFriendsWithExternalId:@"" success:^(NSArray *friendsArray) {
                failure(@"Failed to return correct response.");
                done();
            } failure:^(NSError *error) {
                expect(error).notTo.beNil();
                done();
            }];
        });
    });
});

SpecEnd
