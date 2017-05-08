//
//  IMConstants.h
//  InstaMed
//
//  Created by Suhail K on 14/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>

typedef enum
{
    IMLoginTypeNone       = 0,
    IMLoginTypeFacebook   = 1,
    IMLoginTypeGoogle   = 2
}
IMLoginType;



#define IMFLURRY_SCREEN_NAME_PARAM                 @"Screen Name"
#define IMFLURRY_LOGIN_TYPE_PARAM                  @"Login Type"

#define NUMBERS_ONLY @"1234567890"
#define PHONE_NUMBER_CHARACTER_LIMIT 10
#define USER_NAME_CHARACTER_LIMIT 100
#define EMAIL_CHARACTER_LIMIT 255
#define ADDRESS_TWO_CHARACTER_LIMIT 50
#define ADDRESS_ONE_CHARACTER_LIMIT 1000

#define PATIENT_DETAIL_CHARECTER_LIMIT 50


// Keys & ID's for Third party services
extern NSString *const IMFlurryAPIKey;
extern NSString *const IMRelicAPITestKey;
extern NSString *const IMRelicAPILiveKey;
extern NSString *const IMApptentiveAPILiveKey;
extern NSString *const IMApptentiveAPITestKey;

//#######  Flurry Events #######
extern NSString *const IMSearchFromHomeEvent;
extern NSString *const IMTimeSpendInHome;
extern NSString *const IMTimeSpendInProductList;
extern NSString *const IMTimeSpendInPharmacy;
extern NSString *const IMUploadPrescriptionEvent;
extern NSString *const IMFilterEvent;
extern NSString *const IMAddToCartEvent;
extern NSString *const IMPlaceOrderEvent;
extern NSString *const IMUpdateOrderEvent;
extern NSString *const IMNonPharMaVisitedEvent;
extern NSString *const IMPharMaVisitedEvent;
extern NSString *const IMDeleverySlotEvent;
extern NSString *const IMSortEvent;
extern NSString *const IMReorderfromListEvent;
extern NSString *const IMReorderfromDetailEvent;
extern NSString *const IMAddAddressEvent;
extern NSString *const IMEditAddressEvent;
extern NSString *const IMDeleteAddressEvent;
extern NSString *const IMLocationChangeEvent;
extern NSString *const IMAppLaunchedEvent;
extern NSString *const IMDirectRegistrationEvent;
extern NSString *const IMInDirectRegistrationEvent;
extern NSString *const IMOrderFromPrescription;

extern NSString *const IMOrderFromPrescription  ;
extern NSString *const IMReturnOrder ;
extern NSString *const IMCancelOrder;
extern NSString *const IMStoreLocatorVisited  ;
extern NSString *const IMSupportCall;
extern NSString *const IMCategories;

extern NSString *const IMCartTapped;                
extern NSString *const IMTimeSpendInCart;
extern NSString *const IMSearchTapped ;             
extern NSString *const IMMyAccountTapped;
extern NSString *const IMPlaceOrderFromCart ;
extern NSString *const IMUploadPrescriptionNow ;
extern NSString *const IMTimeOfDelivery  ;
extern NSString *const IMTimeSpendInDeliveryAddress;
extern NSString *const IMTimeSpendInSummary ;
extern NSString *const IMConfirmOrder  ;
extern NSString *const IMTimeSpendInSignIn ;
extern NSString *const IMForgotPasswordTapped ;
extern NSString *const IMRegistertapped;
extern NSString *const IMTimeSpendInRegistration;
extern NSString *const IMRegistrationCancelTapped;
extern NSString *const IMRegistrationNextTapped;
extern NSString *const IMTimeSpendInOTP;
extern NSString *const IMTimeSpendInMobileNumber;
extern NSString *const IMOTPSubmittapped;
extern NSString *const IMUploadPrescriptionFromHome;
extern NSString *const IMPhotoTapped;
extern NSString *const IMGalleryTapped ;
extern NSString *const IMPrescriptionSubmit;
extern NSString *const IMPrescriptionAddAnother;
extern NSString *const IMPrescriptionDone;

extern NSString *const IMPushNotificationTapped;
extern NSString *const IMHomeBannerTapped;
extern NSString *const IMHomeStoreBannerTapped;
extern NSString *const IMHomeFeaturedTapped;
extern NSString *const IMCategoryBannerTapped;
extern NSString *const IMCategoryShopByBrandTapped;
extern NSString *const IMCategoryFeaturedTapped;

extern NSString *const IMSupportScreenVisited;
extern NSString *const IMMoreScreenVisited;
extern NSString *const IMSearchResultScreenVisited ;
extern NSString *const IMSearchScreenVisited;
extern NSString *const IMQuantitySelectionVisited;
extern NSString *const IMAddressSelectionVisited;
extern NSString *const IMAddAddressVisited;

extern NSString *const IMProductListVisit;

extern NSString *const IMCuoponCodeApplied ;
extern NSString *const IMDeliverySlotScreenVisit;
extern NSString *const IMUploadPrescriptionVisit ;
extern NSString *const IMCategoryHome      ;
extern NSString *const IMViewMoreCategories ;
extern NSString *const IMViewMoreFeaturedHome ;
extern NSString *const IMOrderListTimeSpend;
extern NSString *const IMPrescriptionListTimeSpend ;
extern NSString *const IMPrescriptionDetailTimeSpend;
extern NSString *const IMSignInTapped  ;
extern NSString *const IMViewMoreFeaturedCategory;


extern NSString *const IMCategoryLevel2Tapped;//Which category will send as parameter
extern NSString *const IMCategoryLevel3Tapped;//Which category will send as parameter
extern NSString *const IMSearchBarTapped;
extern NSString *const IMAddToCartProductList;
extern NSString *const IMMyOrdersTapped;
extern NSString *const IMOrderTapped;
extern NSString *const IMPDPFromOrderDetail;
extern NSString *const IMOrderDetailTimeSpent;
extern NSString *const IMMyPrescriptionTapped;
extern NSString *const IMPrescriptionTapped;
extern NSString *const IMAutoSuggestionTapped;
extern NSString *const IMQuantityDoneTapped;
extern NSString *const IMRegistrationCompleted;
extern NSString *const IMSccountScreenVisited ;


//from 1.2.1
extern NSString *const IMOrderHistoryScreenVisited;
extern NSString *const IMOrderDetailScreenVisited;
extern NSString *const IMPescriptionsScreenVisited;
extern NSString *const IMPrescriptionDetailScreenVisited;
extern NSString *const IMCartScreenVisited;
extern NSString *const IMProductListScreenVisited;
extern NSString *const IMOtpScreenVisited;
extern NSString *const IMMobileNumberScreenVisited;
extern NSString *const IMSignInScreenVisited;
extern NSString *const IMCheckOutSummaryScreenVisited;
extern NSString *const IMDeliveryAddressScreenVisited;
extern NSString *const IMRegisterScreenVisited;
extern NSString *const IMHomeScreenVisited;
extern NSString *const IMCategoriesScreenVisited;

//for v1.3

extern NSString *const IMOfferScreenVisited;
extern NSString *const IMOfferTappedEvent;
extern NSString *const IMFAQTopicScreeenVisited;
extern NSString *const IMFAQScreenVisited;
extern NSString *const IMFRwalletScreenVisited;
extern NSString *const IMPayTMTransactionSucesssEvent;
extern NSString *const IMPayTMTransactionFailedEvent;
extern NSString *const IMPayTMTransactionCancelEvent;

//for v1.4
extern NSString *const IMReferFriendScreenVisited;
extern NSString *const IMReferFriendHowItWorksTapped;
extern NSString *const IMInviteFriendsTapped;
extern NSString *const IMSocialLoginFacebookTapped;
extern NSString *const IMSocialLoginGoogleTapped;
extern NSString *const IMFacebookSignInSuccess;
extern NSString *const IMGoogleSignInSuccess;
extern NSString *const IMFacebookRegisterSuccess;
extern NSString *const IMGoogleRegisterSuccess;
extern NSString *const IMRetryContinueTapped;
extern NSString *const IMRetryCancelTapped;
extern NSString *const IMReferFriendSuccess;

//for v1.5
extern NSString *const IMNotifyMeTapped;
extern NSString *const IMNotifyMeConfirmationTapped;
extern NSString *const IMHealthArticleMenuTapped;
extern NSString *const IMPDPShareButtonTapped;
extern NSString *const IMPDPSharingMediumTapped;
extern NSString *const IMOrderSharingFBTapped;
extern NSString *const IMOrderSharingGPlusTapped;
extern NSString *const IMOrderSharingTwitterTapped;
extern NSString *const IMOrderSharingWhatsappTapped;
extern NSString *const IMOrderSharingMoreButtonTapped;
extern NSString *const IMOrderSharingMoreMediumSelected;

//Notification payload keys
extern NSString *const IMNotificationIDKey;
extern NSString *const IMNotificationTypeKey;
extern NSString *const IMNotificationAPSKey;
extern NSString *const IMNotificationMessageKey;
extern NSString *const IMNotificationCouponCodeKey;
extern NSString *const IMNotificationHTMLPageURLKey;
extern NSString *const IMNotificationIsPharmaKey;

//payment methods & instruments
extern NSString *const IMFrankrossWalletPaymentMethod;
extern NSString *const IMFrankrossWalletPaymentInstrument;
extern NSString *const IMCODPaymentmethod;
extern NSString *const IMPaytmWalletPaymentmethod;
extern NSString *const IMCreditCardPaymentmethod;
extern NSString *const IMDebitCardPaymentmethod;
extern NSString *const IMNetBankingPaymentmethod;


extern NSString* const IMNameEmptyAlertTitle;
extern NSString* const IMNameEmptyAlertMessage;

extern NSString* const IMEmailAddressEmptyAlertTitle;
extern NSString* const IMEmailAddressEmptyAlertMessage;

extern NSString* const IMEmailAddressInvalidAlertTitle;
extern NSString* const IMEmailAddressInvalidAlertMessage;

extern NSString* const IMPasswordEmptyAlertTitle;
extern NSString* const IMPasswordEmptyAlertMessage;

extern NSString* const IMPasswordInvalidAlertTitle;
extern NSString* const IMPasswordInvalidAlertMessage;

extern NSString* const IMMobileNumberEmptyAlertTitle;
extern NSString* const IMMobileNumberEmptyAlertMessage;

extern NSString* const IMMobileNumberInvalidAlertTitle;
extern NSString* const IMMobileNumberInvalidAlertMessage;

extern NSString* const IMTermsNotAgreedAlertTitle;
extern NSString* const IMMTermsNotAgreedAlertMessage;

extern NSString *const IMFacebookAccountNotConfiguredAlertMessage;
extern NSString *const IMTwitterAccountNotConfiguredAlertMessage;
extern NSString *const IMWhatsAppNotInstalledAlertMessage;

extern NSString *const IMCouponCodeCopiedToClipboardMessageFormat;

extern NSString* const IMIdentifierKey;

extern NSString *const IMSearchProductName;
extern NSString *const IMSearchCatagory;
extern NSString *const IMSearchProductID;
extern NSString *const IMSearchCompanyName;
extern NSString *const IMSearchImageURL;
extern NSString *const IMIsPharma;

extern NSString *const IMSocialAccessToken;
extern NSString *const IMSocialLoginType;
extern NSString *const IMError;
extern NSString *const IMOK;
extern NSString *const IMCancel ;
extern NSString *const IMMessage ;


//String placeHolders
extern NSString *const IMProductNamePlaceHolder;
extern NSString *const IMAppLinkPlaceHolder;
extern NSString *const IMProductLinkPlaceHolder;



extern NSString *const IMNoNetworkErrorMessage;
extern NSString *const IMReferralSuccessMessage;
extern NSString *const IMReferralFailureMessage;
extern NSString* const IMGeneralRequestFailureMessage;

extern NSString* const IMCartAdditionTitle;
extern NSString* const IMCartAdditionMessage;


//Notification names
extern NSString* const IMReoladProductListNotificationName;
extern NSString* const IMDismissChildViewControllerNotification;
extern NSString* const IMLocationChangedNotification;

#pragma mark - Storyboards

extern NSString *const IMSupportSBName;
extern NSString *const IMAccountSBName;
extern NSString *const IMMainSBName;
extern NSString *const IMCartSBName;
extern NSString *const IMReturnProductsSBName;





extern NSString* const IMRupeeSymbol;

//Font

extern NSString* const IMHelveticaLight ;
extern NSString* const IMHelveticaMedium;

extern NSString* const IMEnterOrderMobileNumber ;
extern NSString* const IMEnterregistrationMobileNumber;
extern NSString* const IMWelcome;
extern NSString* const IMHaveYouPlacedBefore;
extern NSString* const IMEmptyEmail;
extern NSString* const IMPlsEnterEmail;
extern NSString* const IMInvalidUser ;

extern NSString* const IMPlsEnterValidCredentiels;
extern NSString* const IMCurrentlydeliveredTo ;
extern NSString* const IMMoreCtiesSoon ;
extern NSString* const IMGotIt;
extern NSString* const IMNoHistory;
extern NSString* const IMNoResultFound ;
extern NSString* const IMOtherProducts;
extern NSString* const IMMedicines;
extern NSString* const IMTopSelling;
extern NSString* const IMOffersText;
extern NSString* const IMrecentlyOrderdtext;
extern NSString* const IMproductComingSoon;
extern NSString* const IMYouMayAlsoLikeProduct;
extern NSString* const IMTopSellingProduct;


extern NSString* const IMUploadPrescriptionForOrderTitle;
extern NSString* const IMUploadPrescriptionForOrderPoint1;
extern NSString* const IMUploadPrescriptionForOrderPoint2;
extern NSString* const IMUploadPrescriptionForOrderPoint3 ;
extern NSString* const IMUploadPrescriptionForOrderPoint4 ;
extern NSString* const IMUploadPrescriptionForOrderPoint5 ;

extern NSString* const IMUploadPrescriptionForNormalTitle;
extern NSString* const IMUploadPrescriptionForNormalPoint1;
extern NSString* const IMUploadPrescriptionForNormalPoint2;
extern NSString* const IMUploadPrescriptionForNormalPoint3 ;
extern NSString* const IMUploadPrescriptionForNormalPoint4 ;
extern NSString* const IMUploadPrescriptionForNormalPoint5 ;

extern NSString* const IMPhotoAlbumName;
extern NSString* const IMNetworkError;
extern NSString* const IMOTCMedicins ;
extern NSString* const IMMedicalAidsAndDevices ;
extern NSString* const IMNutritionalSuppliments;

extern NSString* const IMWhyPrescribe;
extern NSString* const IMHowToTake;
extern NSString* const IMRecommendedDosage;
extern NSString* const IMWhenNotToTake;
extern NSString* const IMWarningPrecations;
extern NSString* const IMSideEffects;
extern NSString* const IMOtherPrecations;
extern NSString* const IMNone ;
extern NSString* const IMDescriptions ;
extern NSString* const IMSpecifications;

extern NSString* const IMSortText;
extern NSString* const IMBrandsText;
extern NSString* const IMCategoriesText;
extern NSString* const IMDeleteConfirmationAlertMessageTitle;
extern NSString* const IMDeleteConfirmationAlertMessageMessage;
extern NSString* const IMDelete;
extern NSString* const IMSetAsDefualt;
extern NSString* const IMEdit;
extern NSString* const IMEditAddress ;
extern NSString* const IMAddAddress;

extern NSString* const IMPlsFillAddress1 ;
extern NSString* const IMPlsFillAddress2 ;
extern NSString* const IMPlsFillPincode ;
extern NSString* const IMInvalidPincode ;
extern NSString* const IMUnSupportedArea ;
extern NSString* const IMPlsFillCityField ;
extern NSString* const IMInvalidPhoneNumber;
extern NSString* const IMMAximumQtyReached;
extern NSString* const IMMAximumQtyExeeded;
extern NSString* const IMShopNow ;
extern NSString* const IMPrescriptionPresent;
extern NSString* const IMPrescriptionRequired;
extern NSString* const IMNotAvaialble;

extern NSString* const IMYourOrderRquiresPrescription;
extern NSString* const IMUploadNow;
extern NSString* const IMAtDelivery;
extern NSString* const IMINsufficientInventory ;
extern NSString* const IMPlsReduceQty;
extern NSString* const IMInvalidCoupenCode;

extern NSString* const IMChoosedeliveryAddress ;
extern NSString* const IMdeliverySlot ;
extern NSString* const IMChooseDeliverySlot ;
extern NSString* const IMPlsSelectADeliveryAddress ;
extern NSString* const IMPlsSelectADeliverySlot;

extern NSString* const IMNOPrescription;
extern NSString* const IMNotAvailable;

extern NSString* const IMSymptoms;
extern NSString* const IMDiagnosis;
extern NSString* const IMTestPrescribed;
extern NSString* const IMNotesAndDirections;

extern NSString* const IMInvalidCurrentPassword;
extern NSString* const IMPlsEnterValidCurrentPassword;
extern NSString* const IMInvalidNewPassword;
extern NSString* const IMPlsEnterValidNewPassword;
extern NSString* const IMPasswordMismatch;
extern NSString* const IMMismatchInPasswordConfirmation;

extern NSString* const IMRemainderOff;
extern NSString* const IMRemainderHasbeenOff;
extern NSString* const IMreturnOrderText;
extern NSString* const IMForreturnPlsContact;
extern NSString* const IMCancellSuccess;
extern NSString* const IMReorderReminderSet;
extern NSString* const IMNoProduct;
extern NSString* const IMCallNotAvailableForCity ;
extern NSString* const IMSendOTPtoRegisterdMobile;
extern NSString* const IMPlsEnterValidOTP;
extern NSString* const IMOTPVerification;
extern NSString* const IMPlsEnterNewPassword;
extern NSString* const IMLetComplete;

extern NSString* const IMComments;
extern NSString* const IMCancelReasonMessage;
extern NSString* const IMProductPlaceholderName;
extern NSString* const IMProductPlaceholderPDPName;
extern NSString* const IMTickMarkImageName;
extern NSString* const IMUpgradeNow;
extern NSString* const IMUpgradeNowMessage;
extern NSString* const IMUpgradeNowTitle;
extern NSString* const IMUpgradeNowOrLaterMessage;
extern NSString* const IMUpgradeNowOrLaterTitle;
extern NSString* const IMUpgradeLater;
extern NSString* const IMGPSError;
extern NSString* const IMDummyUserName ;
extern NSString* const IMNoFilteredProduct;
extern NSString* const IMPODExceededTitle;
extern NSString* const IMPODExceededMessage;
extern NSString* const IMReviseOrderScreenTitle;
extern NSString* const IMUpdateOrderButtontitle;
extern NSString* const IMOrderUpdateSuccessMessage;
extern NSString* const IMUpdateButtontitle;
extern NSString* const IMPasswordRequiredtitle;
extern NSString* const IMPasswordRequiredMessage;
extern NSString* const IMProductNotInCity;
extern NSString* const IMPasswordReRequiredMessage;
extern NSString* const IMPrescriptionNotCompleteMessage;

//ka Cart screen: Apply button text
extern NSString* const IMApply;
extern NSString* const IMApplied;

extern NSString* const IMCallUsOn;
extern NSString* const IMCallNotAvailableMessage;


extern NSString* const IMNoDeliverySlotsAvailable;
extern NSString* const IMCouponCodeCannotBeApplied;
extern NSString* const IMCouponCodeCannotBeRemoved;
extern NSString* const IMCouponNotAppliedTitle;
extern NSString* const IMCouponNotAppliedMessage;
extern NSString* const IMFeaturedProductScreenTitle;
extern NSString* const IMLoginToApplycouponMessage;
extern NSString* const IMDiscountTitle;

//constants used for PayTM payments

extern NSString *const IMPayTMMerchantIDKey;
extern NSString *const IMPayTMChannelIDKey;
extern NSString *const IMPayTMIndustryTypeIDKey;
extern NSString *const IMPayTMWebsiteKey;
extern NSString *const IMPayTMRequestTypeKey;
extern NSString *const IMPayTMCustomerIDKey;
extern NSString *const IMPayTMTransactionAmountKey;
extern NSString *const IMPayTMOrderIDKey;
extern NSString *const IMPaytmResponseMessageKey;
extern NSString *const IMPaytmResponseCodeKey;


//Branch SDK keys
extern NSString * const BRANCH_USER_ID_KEY ;
extern NSString * const BRANCH_USER_FULLNAME_KEY;
extern NSString * const BRANCH_USER_SHORT_NAME_KEY;
extern NSString * const BRANCH_USER_IMAGE_URL_KEY ;

//registration methods

extern NSString * const IMFacebookRegistrationMethod;
extern NSString * const IMGoogleRegistrationMethod;
extern NSString * const IMFrankrossRegistrationMethod;


//NSUserDefaults Key
extern NSString *const IMSuccessfulReferralPreferenceKey;

#pragma mark - ViewController Identifiers

extern NSString *const IMLoginVCID;
extern NSString *const IMSupportVCID;
extern NSString *const IMReturnProductsListingVCID;
extern NSString *const IMSearchViewControllerID;
extern NSString *const IMSubCategoryViewControllerID;
extern NSString *const IMCategoryProductListingViewControllerID;
extern NSString *const IMOrderListingViewControllerID;
extern NSString *const IMPrecriptionListingViewControllerID;
extern NSString *const IMPharmaDetailViewControllerID;
extern NSString *const IMNonPharmaDetailViewControllerID;
extern NSString *const IMPromotionDetailWebviewViewControllerID;
extern NSString *const IMReferAFriendViewControllerID;
extern NSString *const IMHealthArticlesViewControllerID;




