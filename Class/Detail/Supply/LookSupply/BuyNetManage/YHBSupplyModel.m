//
//  YHBSupplyModel.m
//
//  Created by  C陈政旭 on 14/12/6
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "YHBSupplyModel.h"
#import "NSDate+extensions.h"


NSString *const kYHBSupplyModelMemberid = @"memberId";
NSString *const kYHBSupplyModelProcurementid = @"procurementId";
NSString *const kYHBSupplyModelProductname = @"productName";
NSString *const kYHBSupplyModelAmount = @"amount";
NSString *const kYHBSupplyModelAmountunit = @"amountUnit";
NSString *const kYHBSupplyModelTakedeliverylastdate = @"takeDeliveryLastDate";
NSString *const kYHBSupplyModelOfferlastdate = @"offerLastDate";
NSString *const kYHBSupplyModelPhone = @"phone";
NSString *const kYHBSupplyModelCatid = @"catId";
NSString *const kYHBSupplyModelContactor = @"contactor";
NSString *const kYHBSupplyModelPhonepublic = @"phonePublic";
NSString *const kYHBSupplyModelProcurementprice = @"procurementprice";
NSString *const kYHBSupplyModelRecording = @"recording";
NSString *const kYHBSupplyModelDetails = @"details";
NSString *const kYHBSupplyModelIssamplecut = @"isSampleCut";
NSString *const kYHBSupplyModelBillingtype = @"billingType";
//NSString *const kYHBSupplyModelImageurls = @"procurementImage";
NSString *const kYHBSupplyModelProcurementstatus = @"procurementStatus";
NSString *const kYHBSupplyModelDistrict = @"district";
//NSString *const kYHBSupplyModelImageurl = @"procurementImage";

@interface YHBSupplyModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation YHBSupplyModel

@synthesize memberId =_memberId;
@synthesize procurementId = _procurementId;
@synthesize productName = _productName;
@synthesize amount = _amount;
@synthesize amountUnit = _amountUnit;
@synthesize takeDeliveryLastDate = _takeDeliveryLastDate;
@synthesize offerLastDate = _offerLastDate;
@synthesize phone = _phone;
@synthesize catId = _catId;
@synthesize contactor = _contactor;
@synthesize PhonePublic = _PhonePublic;
@synthesize ProcurementPrice = _ProcurementPrice;
@synthesize recording = _recording;
@synthesize details = _details;
@synthesize isSampleCut = _isSampleCut;
@synthesize billingType = _billingType;
@synthesize imageUrls = _imageUrls;
@synthesize procurementStatus = _procurementStatus;
@synthesize district = _district;
@synthesize imageurl = _imageUrl;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.memberId = [self objectOrNilForKey:kYHBSupplyModelMemberid fromDictionary:dict];
        self.procurementId = [self objectOrNilForKey:kYHBSupplyModelProcurementid  fromDictionary:dict];
        self.productName = [self objectOrNilForKey:kYHBSupplyModelProductname fromDictionary:dict];
        self.amount = [[self objectOrNilForKey:kYHBSupplyModelAmount fromDictionary:dict] doubleValue];
        //NSLog(@"*****%0.1f",self.amount);
        self.amountUnit = [self objectOrNilForKey:kYHBSupplyModelAmountunit fromDictionary:dict];
        self.takeDeliveryLastDate = [self objectOrNilForKey:kYHBSupplyModelTakedeliverylastdate fromDictionary:dict];
        self.offerLastDate = [self objectOrNilForKey:kYHBSupplyModelOfferlastdate fromDictionary:dict];
        self.phone = [self objectOrNilForKey:kYHBSupplyModelPhone fromDictionary:dict];
        self.catId = [self objectOrNilForKey:kYHBSupplyModelCatid fromDictionary:dict];
        self.contactor = [self objectOrNilForKey:kYHBSupplyModelContactor fromDictionary:dict];
        self.PhonePublic = [[self objectOrNilForKey:kYHBSupplyModelPhonepublic fromDictionary:dict]integerValue];
        self.ProcurementPrice = [self objectOrNilForKey:kYHBSupplyModelProcurementprice fromDictionary:dict];
        self.recording = [self objectOrNilForKey:kYHBSupplyModelRecording fromDictionary:dict];
        self.details = [self objectOrNilForKey:kYHBSupplyModelDetails fromDictionary:dict];
        self.isSampleCut = [self objectOrNilForKey:kYHBSupplyModelIssamplecut fromDictionary:dict];
        self.billingType = [[self objectOrNilForKey:kYHBSupplyModelBillingtype fromDictionary:dict]integerValue];
        //self.imageUrls = [self objectOrNilForKey:kYHBSupplyModelImageurls fromDictionary:dict];
        self.procurementStatus = [self objectOrNilForKey:kYHBSupplyModelProcurementstatus fromDictionary:dict];
        self.district = [self objectOrNilForKey:kYHBSupplyModelDistrict fromDictionary:dict];
        //self.imageurl =[self objectOrNilForKey:kYHBSupplyModelImageurl fromDictionary:dict];
        NSString *newDateStr = [NSString stringWithFormat:@"%@ 00:00:00", self.offerLastDate];
        self.date = [NSDate dateFromString:newDateStr];
    }
    return self;
}

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}



- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.memberId forKey:kYHBSupplyModelMemberid];
    [mutableDict setValue:self.procurementId forKey:kYHBSupplyModelProcurementid];
    [mutableDict setValue:self.productName forKey:kYHBSupplyModelProductname];
    [mutableDict setValue:[NSNumber numberWithDouble:self.amount] forKey:kYHBSupplyModelAmount];
    [mutableDict setValue:self.amountUnit forKey:kYHBSupplyModelAmountunit];
    [mutableDict setValue:self.takeDeliveryLastDate forKey:kYHBSupplyModelTakedeliverylastdate];
    [mutableDict setValue:self.offerLastDate forKey:kYHBSupplyModelOfferlastdate];
    [mutableDict setValue:self.phone forKey:kYHBSupplyModelPhone];
    [mutableDict setValue:self.catId forKey:kYHBSupplyModelCatid];
    [mutableDict setValue:self.contactor forKey:kYHBSupplyModelContactor];
    [mutableDict setValue:[NSNumber numberWithInteger:self.PhonePublic] forKey:kYHBSupplyModelPhonepublic];
    [mutableDict setValue:self.ProcurementPrice forKey:kYHBSupplyModelProcurementprice];
    [mutableDict setValue:self.recording forKey:kYHBSupplyModelRecording];
    [mutableDict setValue:self.details forKey:kYHBSupplyModelDetails];
    [mutableDict setValue:[NSNumber numberWithInteger:self.isSampleCut] forKey:kYHBSupplyModelIssamplecut];
    [mutableDict setValue:[NSNumber numberWithInteger:self.billingType] forKey:kYHBSupplyModelBillingtype];
  //  [mutableDict setValue:self.imageUrls forKey:kYHBSupplyModelImageurls];
    [mutableDict setValue:self.procurementStatus forKey:kYHBSupplyModelProcurementstatus];
    [mutableDict setValue:self.district forKey:kYHBSupplyModelDistrict];
  //  [mutableDict setValue:self.imageurl forKey:kYHBSupplyModelImageurl];
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.memberId = [aDecoder decodeObjectForKey:kYHBSupplyModelMemberid];
    self.procurementId = [aDecoder decodeObjectForKey:kYHBSupplyModelProcurementid];
    self.productName = [aDecoder decodeObjectForKey:kYHBSupplyModelProductname];
    self.amount = [aDecoder decodeDoubleForKey:kYHBSupplyModelAmount];
    self.amountUnit = [aDecoder decodeObjectForKey:kYHBSupplyModelAmountunit];
    self.takeDeliveryLastDate = [aDecoder decodeObjectForKey:kYHBSupplyModelTakedeliverylastdate];
    self.offerLastDate = [aDecoder decodeObjectForKey:kYHBSupplyModelOfferlastdate];
    self.phone = [aDecoder decodeObjectForKey:kYHBSupplyModelPhone];
    self.catId = [aDecoder decodeObjectForKey:kYHBSupplyModelCatid];
    self.contactor = [aDecoder decodeObjectForKey:kYHBSupplyModelContactor];
    self.PhonePublic = [aDecoder decodeIntegerForKey:kYHBSupplyModelPhonepublic];
    self.ProcurementPrice = [aDecoder decodeObjectForKey:kYHBSupplyModelProcurementprice];
    self.recording = [aDecoder decodeObjectForKey:kYHBSupplyModelRecording];
    self.details = [aDecoder decodeObjectForKey:kYHBSupplyModelDetails];
    self.isSampleCut = [aDecoder decodeIntegerForKey:kYHBSupplyModelIssamplecut];
    self.billingType = [aDecoder decodeIntegerForKey:kYHBSupplyModelBillingtype];
    self.procurementStatus = [aDecoder decodeObjectForKey:kYHBSupplyModelProcurementstatus];
    self.district = [aDecoder decodeObjectForKey:kYHBSupplyModelDistrict];
  //  self.imageUrls = [aDecoder decodeObjectForKey:kYHBSupplyModelImageurls];
  //  self.imageurl = [aDecoder decodeObjectForKey:kYHBSupplyModelImageurl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_memberId forKey:kYHBSupplyModelMemberid];
    [aCoder encodeObject:_procurementId forKey:kYHBSupplyModelProcurementid];
    [aCoder encodeObject:_productName forKey:kYHBSupplyModelProductname];
    [aCoder encodeDouble:_amount forKey:kYHBSupplyModelAmount];
    [aCoder encodeObject:_amountUnit forKey:kYHBSupplyModelAmountunit];
    [aCoder encodeObject:_takeDeliveryLastDate forKey:kYHBSupplyModelTakedeliverylastdate];
    [aCoder encodeObject:_offerLastDate forKey:kYHBSupplyModelTakedeliverylastdate];
    [aCoder encodeObject:_phone forKey:kYHBSupplyModelPhone];
    [aCoder encodeObject:_catId forKey:kYHBSupplyModelCatid];
    [aCoder encodeObject:_contactor forKey:kYHBSupplyModelContactor];
    [aCoder encodeInteger:_PhonePublic forKey:kYHBSupplyModelPhonepublic];
    [aCoder encodeObject:_ProcurementPrice forKey:kYHBSupplyModelProcurementprice];
    [aCoder encodeObject:_recording forKey:kYHBSupplyModelRecording];
    [aCoder encodeObject:_details forKey:kYHBSupplyModelDetails];
    [aCoder encodeInteger:_isSampleCut forKey:kYHBSupplyModelIssamplecut];
    [aCoder encodeInteger:_billingType forKey:kYHBSupplyModelBillingtype];
    [aCoder encodeObject:_procurementStatus forKey:kYHBSupplyModelProcurementstatus];
    [aCoder encodeObject:_district forKey:kYHBSupplyModelDistrict];
 //   [aCoder encodeObject:_imageUrls forKey:kYHBSupplyModelImageurls];
 //   [aCoder encodeObject:_imageurl forKey:kYHBSupplyModelImageurl];
}

- (id)copyWithZone:(NSZone *)zone
{
    YHBSupplyModel *copy = [[YHBSupplyModel alloc] init];
    
    if (copy) {

        copy.memberId =[self.memberId copyWithZone:zone];
        copy.procurementId = [self.procurementId copyWithZone:zone];
        copy.productName =[self.productName copyWithZone:zone];
        copy.amount = self.amount;
        copy.amountUnit = [self.amountUnit copyWithZone:zone];
        copy.takeDeliveryLastDate = [self.takeDeliveryLastDate copyWithZone:zone];
        copy.offerLastDate = [self.offerLastDate copyWithZone:zone];
        copy.phone = [self.phone copyWithZone:zone];
        copy.catId = [self.catId copyWithZone:zone];
        copy.contactor = [self.contactor copyWithZone:zone];
        copy.PhonePublic = self.PhonePublic;
        copy.ProcurementPrice = [self.ProcurementPrice copyWithZone:zone];
        copy.recording = [self.recording copyWithZone:zone];
        copy.details = [self.details copyWithZone:zone];
        copy.isSampleCut = self.isSampleCut;
        copy.billingType = self.billingType;
        copy.imageUrls = [self.imageUrls copyWithZone:zone];
        copy.procurementStatus = [self.procurementStatus copyWithZone:zone];
        copy.district = [self.district copyWithZone:zone];
        copy.imageurl = [self.imageurl copyWithZone:zone];
        copy.imageUrls = [self.imageUrls copyWithZone:zone];
    }
    
    return copy;
}

@end
