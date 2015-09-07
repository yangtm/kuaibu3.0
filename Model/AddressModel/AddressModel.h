//
//  AddressModel.h
//  kuaibu
//
//  Created by zxy on 15/8/21.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property (strong, nonatomic) NSString *memberDeliveryAddressId;
@property (strong, nonatomic) NSString *memberId;
@property (strong, nonatomic) NSString *contactor;
@property (assign, nonatomic) BOOL isDefault;
@property (strong, nonatomic) NSString *contactMobileNumber;
@property (strong, nonatomic) NSString *contactTelNumber;
@property (strong, nonatomic) NSString *postCode;
@property (strong, nonatomic) NSString *provinceId;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *cityId;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *area_id;
@property (strong, nonatomic) NSString *area;
@property (strong, nonatomic) NSString *address;
@property (nonatomic, strong) NSString *truename;
@end
