//
//  EAPhaseModel.h
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/17.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EABaseModel.h"

@class EAPhaseApprovalModel, EAPhaseEvaluationModel;

@interface EAPhaseModel : EABaseModel

@property (strong, nonatomic) NSString *phaseNo, *status, *name, *deliveryNote, *delivery;
@property (strong, nonatomic) NSNumber *projectId, *developerId, *creatorId, *price, *actualPrice;
@property (strong, nonatomic) NSDate *planDeliveryAt, *actualDeliveryAt;
@property (strong, nonatomic) EAPhaseApprovalModel *approval;
@property (strong, nonatomic) EAPhaseEvaluationModel *evaluation;
@end

@interface EAPhaseApprovalModel : EABaseModel

@property (strong, nonatomic) NSString *type, *status;
@property (strong, nonatomic) NSNumber *creatorId, *approverId;
@property (strong, nonatomic) NSDate *submittedAt, *operatedAt;

@end

@interface EAPhaseEvaluationModel : EABaseModel

@property (strong, nonatomic) NSString *appraiserType, *content;
@property (strong, nonatomic) NSNumber *rewardId, *stageId, *appraiseeId, *appraiserId, *deliverabilityRate, *communicationRate, *responsibilityRate, *averageRate;
@property (strong, nonatomic) NSDate *createdAt;

@end

//{
//    "id": 309,
//    "projectId": 3184,
//    "developerId": 500012,
//    "creatorId": 500012,
//    "phaseNo": "P1",
//    "status": "FINISHED",
//    "name": "dddd",
//    "price": 100,
//    "actualPrice": 100,
//    "deliveryNote": "yyy",
//    "planDeliveryAt": 1508342400000,
//    "actualDeliveryAt": 1508144620000,
//    "delivery": "66666666666",
//    "approval": {
//        "creatorId": 500012,
//        "approverId": 501001,
//        "type": "PHASE_ACCEPTANCE",
//        "status": "ACCEPT",
//        "submittedAt": 1508144620000,
//        "operatedAt": 1508144630000
//    },
//    "evaluation": {
//        "rewardId": 3184,
//        "stageId": 309,
//        "appraiseeId": 500012,
//        "appraiserId": 501001,
//        "appraiserType": "Owner",
//        "deliverabilityRate": 4,
//        "communicationRate": 4,
//        "responsibilityRate": 4,
//        "averageRate": 4,
//        "createdAt": "1508206527000",
//        "id": 228
//    }
//}

