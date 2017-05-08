//
//  IMConstants.m
//  InstaMed
//
//  Created by Suhail K on 14/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMConstants.h"

NSString* const IMFlurryAPIKey = @"KH2XK2YZZB3GRGCWPKT8";
NSString* const IMRelicAPIOldKey = @"AA91ae7c4d3102177cb6bbcc24ad3736c9aec6525a";
NSString* const IMRelicAPITestKey = @"AA3867c072a32a7efe878965887e918cf887c2ec00";
NSString* const IMRelicAPILiveKey = @"AAbdb288b88af6ceac3510020fddb915991aade73e";
NSString *const IMApptentiveAPILiveKey = @"ab228cb644502dae8951003517c4f80c3ea62673c632ac9029570b2e630d38c5";
NSString *const IMApptentiveAPITestKey = @"fbc17292d90a7c94d3e1443094496bc4f00c413cd18c777dade1dca89de5c267";
//#######  Flurry Events #######
NSString *const IMSearchFromHomeEvent       = @"Serach_From_Home";
NSString *const IMTimeSpendInHome           = @"Home_Screen_Time_Spend";
NSString *const IMTimeSpendInProductList    = @"Product_Listing_Time_Spend";
NSString *const IMTimeSpendInPharmacy       = @"Category_Screen_Time_Spend";
NSString *const IMUploadPrescriptionEvent   = @"Upload_Prescription";
NSString *const IMFilterEvent               = @"Filter_Applied";
NSString *const IMAddToCartEvent            = @"Add_To_Cart_PDP";
NSString *const IMPlaceOrderEvent           = @"Place_Order";
NSString *const IMUpdateOrderEvent          = @"Update_Order";
NSString *const IMNonPharMaVisitedEvent     = @"Non_Pharma_PDP_Visited";
NSString *const IMPharMaVisitedEvent        = @"Pharma_PDP_Visited";
NSString *const IMDeleverySlotEvent         = @"Delivery_Slot_Selected";
NSString *const IMSortEvent                 = @"Sort_Applied";
NSString *const IMReorderfromListEvent      = @"Reorder_From_List";
NSString *const IMReorderfromDetailEvent    = @"Reorder_From_Detail";
NSString *const IMAddAddressEvent           = @"Address_Add";
NSString *const IMEditAddressEvent          = @"Address_Edit";
NSString *const IMDeleteAddressEvent        = @"Address_Delete";
NSString *const IMLocationChangeEvent       = @"Location_Changed";
NSString *const IMAppLaunchedEvent          = @"App_Launched";
NSString *const IMDirectRegistrationEvent   = @"App_Registration";
NSString *const IMInDirectRegistrationEvent = @"Through_Order_Registration";

NSString *const IMOrderFromPrescription     = @"Order_From_prescription";
NSString *const IMReturnOrder               = @"Order_Returned";
NSString *const IMCancelOrder               = @"Order_Cancelled";
NSString *const IMStoreLocatorVisited       = @"Store_Locator_Visited";
NSString *const IMSupportCall               = @"Call_Support";
NSString *const IMCategories                = @"Categories";



NSString *const IMCartTapped                = @"Cart_Tapped";//From which screen will be send as parameter
NSString *const IMTimeSpendInCart           = @"Cart_Screen_Time_Spend";
NSString *const IMSearchTapped              = @"Search_Icon_Tapped";
NSString *const IMMyAccountTapped           = @"MyAccount_Tapped";
NSString *const IMPlaceOrderFromCart        = @"Cart_Place_Order";
NSString *const IMUploadPrescriptionNow     = @"PresCription_Upload_Now";
NSString *const IMTimeOfDelivery            = @"PresCription_Time_Of_Delivery";
NSString *const IMTimeSpendInDeliveryAddress= @"DeliveryAddress_Screen_Time_Spend";
NSString *const IMTimeSpendInSummary        = @"Summary_Screen_Time_Spend";
NSString *const IMConfirmOrder              = @"Order_Confirm";
NSString *const IMTimeSpendInSignIn         = @"SignIn_Screen_Time_Spend";
NSString *const IMForgotPasswordTapped      = @"Forgot_Password_Tapped";
NSString *const IMRegistertapped            = @"Register_Tap";
NSString *const IMTimeSpendInRegistration   = @"Registration_Screen_Time_Spend";
NSString *const IMRegistrationCancelTapped  = @"Registration_Cancel";
NSString *const IMRegistrationNextTapped    = @"Registration_Next";
NSString *const IMTimeSpendInOTP            = @"OTP_Screen_Time_Spend";
NSString *const IMTimeSpendInMobileNumber   = @"Mobile_Number_Screen_Time_Spend";
NSString *const IMOTPSubmittapped           = @"OTP_Submit";
NSString *const IMUploadPrescriptionFromHome= @"Prescription_Upload_Home";
NSString *const IMPhotoTapped               = @"Prescription_From_Camera";
NSString *const IMGalleryTapped             = @"Prescription_From_Gallery";
NSString *const IMPrescriptionSubmit        = @"Prescription_Submit";
NSString *const IMPrescriptionAddAnother    = @"Prescription_Add_Another";
NSString *const IMPrescriptionDone          = @"Prescription_Done";


NSString *const IMPushNotificationTapped    = @"Push_Notification_Tapped";
NSString *const IMHomeBannerTapped          = @"Home_Page_Banner_Tapped";
NSString *const IMHomeStoreBannerTapped     = @"Home_Store_Banner_Tapped";
NSString *const IMHomeFeaturedTapped        = @"Home_Featured_Product_Tapped";
NSString *const IMCategoryBannerTapped      = @"Category_Page_Banner_Tapped";
NSString *const IMCategoryShopByBrandTapped = @"Category_Shopby_Brand_Tapped";
NSString *const IMCategoryFeaturedTapped    = @"Category_Featured_Product_Tapped";

NSString *const IMSupportScreenVisited      = @"Support_Screen_Visited";
NSString *const IMMoreScreenVisited         = @"More_Screen_Visited";
NSString *const IMSearchResultScreenVisited = @"Search_Result_Screen_Visited";
NSString *const IMSearchScreenVisited       = @"Search_Screen_Visited";
NSString *const IMQuantitySelectionVisited  = @"Quantity_Selection_Screen_Visited";
NSString *const IMAddressSelectionVisited   = @"Address_Selection_Screen_Visited";
NSString *const IMAddAddressVisited         = @"Add_Address_Screen_Visited";

NSString *const IMCategoryLevel2Tapped      = @"Category_Level2_Tapped";//Which category will send as parameter
NSString *const IMCategoryLevel3Tapped      = @"Category_Level3_Tapped";//Which category will send as parameter
NSString *const IMSearchBarTapped           = @"Search_Bar_Tapped";
NSString *const IMAddToCartProductList      = @"Add_To_Cart_Product_List";
NSString *const IMMyOrdersTapped            = @"My_Orders_Tapped";
NSString *const IMOrderTapped               = @"Order_Tapped";
NSString *const IMPDPFromOrderDetail        = @"PDP-From_Order_Detail";
NSString *const IMOrderDetailTimeSpent      = @"Order_Detail_Time_Spend";
NSString *const IMMyPrescriptionTapped      = @"My_Prescription_Tapped";
NSString *const IMPrescriptionTapped        = @"Prescription_Tapped";
NSString *const IMAutoSuggestionTapped      = @"Auto_Suggestion_Tapped";
NSString *const IMQuantityDoneTapped        = @"Quantity_Done_Tapped";

NSString *const IMProductListVisit          = @"Product_List_Visited";

NSString *const IMCuoponCodeApplied         = @"Coupon_Code_Applied";
NSString *const IMDeliverySlotScreenVisit   = @"Delivery_Slot_Screen_Visited";
NSString *const IMUploadPrescriptionVisit   = @"Upload_Prescription_Screen_Visited";
NSString *const IMCategoryHome              = @"Categories_Tapped_From_Home";
NSString *const IMViewMoreCategories        = @"View_More_Categories";
NSString *const IMViewMoreFeaturedHome      = @"View_More_Featured_Products_From_Home";
NSString *const IMOrderListTimeSpend        = @"Order_List_Time_Spend";
NSString *const IMPrescriptionListTimeSpend = @"Prescriptions_List_Time_Spend";
NSString *const IMPrescriptionDetailTimeSpend= @"Prescription_Detail_Time_Spend";
NSString *const IMSignInTapped              = @"Sign_In_Tapped";
NSString *const IMViewMoreFeaturedCategory  = @"View_More_Featured_Products_From_Category";

NSString *const IMRegistrationCompleted     = @"Registration_Completed";
NSString *const IMSccountScreenVisited      = @"Account_Screen_Visited";


//from 1.2.1 ,
NSString *const IMOrderHistoryScreenVisited         = @"Order_History_Screen_Visited";
NSString *const IMOrderDetailScreenVisited          = @"Order_Details_Screen_Visited";
NSString *const IMPescriptionsScreenVisited         = @"Prescriptions_Screen_Visited";
NSString *const IMPrescriptionDetailScreenVisited   = @"Prescription_Details_Screen_Visited";
NSString *const IMCartScreenVisited                 = @"Cart_Screen_Visited";
NSString *const IMProductListScreenVisited          = @"Product_Listing_Screen_Visited";
NSString *const IMOtpScreenVisited                  = @"Enter_OTP_Screen_Visited";
NSString *const IMMobileNumberScreenVisited         = @"Enter_Mobile_Number_Screen_Visited";
NSString *const IMSignInScreenVisited               = @"Sign_In_Screen_Visited";
NSString *const IMCheckOutSummaryScreenVisited      = @"Checkout_Summary_Screen_Visited";
NSString *const IMDeliveryAddressScreenVisited      = @"Checkout_Delivery_Address_Screen_Visited";
NSString *const IMRegisterScreenVisited             = @"Register_Screen_Visited";
NSString *const IMHomeScreenVisited                 = @"Home_Screen_Visited";
NSString *const IMCategoriesScreenVisited           = @"Categories_Screen_Visited";

//for v1.3

NSString *const IMOfferScreenVisited                = @"Offers_Screen_Visited";
NSString *const IMOfferTappedEvent                  = @"Offer_Tapped";
NSString *const IMFAQTopicScreeenVisited            = @"FAQ_Topic_Screen_Visited";
NSString *const IMFAQScreenVisited                  = @"FAQ_Screen_Visited";
NSString *const IMFRwalletScreenVisited             = @"FR_Wallet_Screen_Visited";
NSString *const IMPayTMTransactionSucesssEvent      = @"Paytm_Transaction_Success";
NSString *const IMPayTMTransactionFailedEvent       = @"Paytm_Transaction_Fail";
NSString *const IMPayTMTransactionCancelEvent = @"Paytm_Transaction_Cancel";

//for v1.4
NSString *const IMReferFriendScreenVisited          = @"Refer_Friend_Screen_Visited";
NSString *const IMReferFriendHowItWorksTapped       = @"How_It_Works_Tapped";
NSString *const IMInviteFriendsTapped               = @"Invite_Friends_Tapped";
NSString *const IMSocialLoginFacebookTapped         = @"Social_Login_Facebook_Tapped";
NSString *const IMSocialLoginGoogleTapped           = @"Social_Login_Google_Tapped";
NSString *const IMFacebookSignInSuccess             = @"Facebook_Sign_In_Success";
NSString *const IMGoogleSignInSuccess               = @"Google_Sign_In_Success";
NSString *const IMFacebookRegisterSuccess           = @"Facebook_Register_Success";
NSString *const IMGoogleRegisterSuccess             = @"Google_Register_Success";
NSString *const IMRetryContinueTapped               = @"Retry_Continue_Tapped";
NSString *const IMRetryCancelTapped                 = @"Retry_Cancel_Tapped";
NSString *const IMReferFriendSuccess                = @"Refer_Friend_Success";

//for v1.5
NSString *const IMNotifyMeTapped                    = @"Notify_Me_tapped";
NSString *const IMNotifyMeConfirmationTapped        = @"Notify_Me_confirmation_tapped";
NSString *const IMHealthArticleMenuTapped           = @"Menu_Health_Article_Tapped";
NSString *const IMPDPShareButtonTapped              = @"PDP_sharing_tapped";
NSString *const IMPDPSharingMediumTapped            = @"PDP_sharing_medium_tapped";
NSString *const IMOrderSharingFBTapped              = @"Order_sharing_FB_tapped";
NSString *const IMOrderSharingGPlusTapped           = @"Order_sharing_Gplus_tapped";
NSString *const IMOrderSharingTwitterTapped         = @"Order sharing_Twitter_tapped";
NSString *const IMOrderSharingWhatsappTapped        = @"Order sharing_Whatsapp_tapped";
NSString *const IMOrderSharingMoreButtonTapped      = @"Order_sharing_more_tapped";
NSString *const IMOrderSharingMoreMediumSelected    = @"Order_sharing_more_medium_tapped";
//Extra tracked events : admin,categories.



//Notification payload keys
NSString *const IMNotificationIDKey = @"id";
NSString *const IMNotificationTypeKey = @"nt";
NSString *const IMNotificationAPSKey = @"aps";
NSString *const IMNotificationMessageKey = @"alert";
NSString *const IMNotificationCouponCodeKey = @"cid";
NSString *const IMNotificationHTMLPageURLKey = @"page_link";
NSString *const IMNotificationIsPharmaKey = @"is_pharma";



//payment methods & instruments
NSString *const IMFrankrossWalletPaymentMethod = @"wallet";
NSString *const IMFrankrossWalletPaymentInstrument = @"frankross";
NSString *const IMCODPaymentmethod = @"cod";
NSString *const IMPaytmWalletPaymentmethod= @"wallet";
NSString *const IMCreditCardPaymentmethod= @"credit_card";
NSString *const IMDebitCardPaymentmethod= @"debit_card";
NSString *const IMNetBankingPaymentmethod= @"net_banking";


NSString* const IMNameEmptyAlertTitle = @"Name is empty";
NSString* const IMNameEmptyAlertMessage = @"Please enter your name";

NSString* const IMEmailAddressEmptyAlertTitle = @"Email address is empty";
NSString* const IMEmailAddressEmptyAlertMessage = @"Please enter your email address";

NSString* const IMEmailAddressInvalidAlertTitle = @"Email address is invalid";
NSString* const IMEmailAddressInvalidAlertMessage = @"Please enter a valid email address";

NSString* const IMPasswordEmptyAlertTitle = @"Password is empty";
NSString* const IMPasswordEmptyAlertMessage = @"Please enter your password";

NSString* const IMPasswordInvalidAlertTitle = @"Password is invalid";
NSString* const IMPasswordInvalidAlertMessage = @"Please enter a password of minimum 6 characters";

NSString* const IMMobileNumberEmptyAlertTitle = @"Mobile number is empty";
NSString* const IMMobileNumberEmptyAlertMessage = @"Please enter your mobile number";;

NSString* const IMMobileNumberInvalidAlertTitle = @"Mobile number is invalid";
NSString* const IMMobileNumberInvalidAlertMessage = @"Please enter a mobile number containing 10 digits";

NSString* const IMTermsNotAgreedAlertTitle = @"Accept terms & conditions";
NSString* const IMMTermsNotAgreedAlertMessage = @"Please check the I agree to terms & conditions button";

NSString *const IMFacebookAccountNotConfiguredAlertMessage = @"Facebook is not configured for your device. Please configure the same in your device settings to share your Frank Ross experience!";

NSString *const IMTwitterAccountNotConfiguredAlertMessage = @"Twitter  is not configured for your device. Please configure the same in your device settings to share your Frank Ross experience!";

NSString *const IMWhatsAppNotInstalledAlertMessage = @"Whatsapp is not installed in your device. Please install the same to share your Frank Ross experience!";

NSString *const IMCouponCodeCopiedToClipboardMessageFormat = @"Coupon code %@ is copied to clipboard";


NSString *const IMSearchProductName = @"productName";
NSString *const IMSearchCatagory = @"category";
NSString *const IMSearchProductID = @"productID";
NSString *const IMSearchCompanyName = @"companyName";
NSString *const IMSearchImageURL = @"imageURL";
NSString *const IMIsPharma = @"isPharma";


NSString *const IMSocialAccessToken = @"social_access_token";
NSString *const IMSocialLoginType = @"social_type";

//String placeHolders
NSString *const IMProductNamePlaceHolder = @"<product name>";
NSString *const IMAppLinkPlaceHolder = @"<link>";
NSString *const IMProductLinkPlaceHolder = @"<link name>";

//Alert
NSString *const IMError = @"Error";
NSString *const IMOK = @"OK";
NSString *const IMCancel  = @"Cancel";
NSString *const IMMessage = @"message";

 NSString *const IMNoNetworkErrorMessage = @"Error while connecting to server. Either server is not responding or there is some problem with your internet connection.";
NSString *const IMReferralSuccessMessage = @"Congratulations you have been successfully referred!";
NSString *const IMReferralFailureMessage = @"This device is already registered with us. Referral benefit is not applicable for this install";

NSString* const IMGeneralRequestFailureMessage = @"Something went wrong while processing your request. Please try again after some time.";

NSString* const IMCartAdditionTitle = @"Added to cart";
NSString* const IMCartAdditionMessage = @"The product has been successfully added to your cart";


//Notifications
NSString* const IMReoladProductListNotificationName = @"IMLocationChanged";
NSString* const IMLocationChangedNotification = @"IMLocationChangedNotification";
NSString* const IMDismissChildViewControllerNotification =  @"dismissChildViewControllerNotification";

#pragma mark - Storyboards

NSString *const IMSupportSBName = @"Support&More";
NSString *const IMAccountSBName = @"Account";
NSString *const IMMainSBName = @"Main";
NSString *const IMCartSBName = @"Cart";
NSString *const IMReturnProductsSBName = @"ReturnProducts";

NSString *const IMRupeeSymbol = @"₹";

NSString* const IMEnterOrderMobileNumber = @"Enter mobile number used in your previous order";
NSString* const IMEnterregistrationMobileNumber = @"Enter mobile number used during registration";


NSString* const IMWelcome = @"Welcome";
NSString* const IMHaveYouPlacedBefore = @"Have you placed an order with Frank Ross before?";

NSString* const IMEmptyEmail = @"Email Address is empty";

NSString* const IMPlsEnterEmail = @"Please enter your email address";
NSString* const IMInvalidUser = @"Invalid user";
NSString* const IMPlsEnterValidCredentiels = @"Please enter a valid email address or mobile number";

NSString* const IMCurrentlydeliveredTo = @"Frank Ross currently delivers in";

NSString* const IMMoreCtiesSoon =   @"More cities coming soon.";

NSString* const IMGotIt = @"Got it";

NSString* const IMHelveticaLight = @"HelveticaNeue-Light";
NSString* const IMNoHistory = @"No recent history";

NSString* const IMNoResultFound = @"No result found";
NSString* const IMHelveticaMedium = @"HelveticaNeue-Medium";

NSString* const IMOtherProducts = @"Other products";
NSString* const IMMedicines = @"Medicines";

NSString* const IMTopSelling = @"Top selling";
NSString* const IMOffersText = @"Offers";
NSString* const IMrecentlyOrderdtext = @"Recently ordered";
NSString* const IMproductComingSoon = @"Products coming soon...";


NSString* const IMYouMayAlsoLikeProduct =  @"You may also like";
NSString* const IMTopSellingProduct = @"Top selling products";


NSString* const IMUploadPrescriptionForOrderTitle = @"Upload prescription for your order";
NSString* const IMUploadPrescriptionForOrderPoint1 = @"Upload prescription for items in your order.";
NSString* const IMUploadPrescriptionForOrderPoint2 = @"Frank Ross will digitize the prescription and verify your order.";
NSString* const IMUploadPrescriptionForOrderPoint3 = @"Verified orders would be processed for dispatch.";
NSString* const IMUploadPrescriptionForOrderPoint4 = @"Successfully digitized prescription will be available in My Account section.";
NSString* const IMUploadPrescriptionForOrderPoint5 = @"We will notify you for any issues in processing your order.";

NSString* const IMUploadPrescriptionForNormalTitle = @"How to order medicines in your prescription";
NSString* const IMUploadPrescriptionForNormalPoint1 = @"Upload your prescription image here.";
NSString* const IMUploadPrescriptionForNormalPoint2 = @"Frank Ross will convert it into an easy to read digital format.";
NSString* const IMUploadPrescriptionForNormalPoint3 = @"Items in your prescription are directly added to your cart.";
NSString* const IMUploadPrescriptionForNormalPoint4 = @"You can edit the items in the cart.";
NSString* const IMUploadPrescriptionForNormalPoint5 = @"All uploaded prescriptions are in your account for easy reorder.";

NSString* const IMPhotoAlbumName = @"Frank Ross";
NSString* const IMNetworkError = @"Network Error";

NSString* const IMOTCMedicins = @"over the counter (otc) medicines";
NSString* const IMMedicalAidsAndDevices = @"medical aids & devices";
NSString* const IMNutritionalSuppliments = @"nutritional supplements";

NSString* const IMWhyPrescribe = @"Why prescribe";
NSString* const IMHowToTake = @"How to take";
NSString* const IMRecommendedDosage = @"Recommended dosage";
NSString* const IMWhenNotToTake = @"When not to take";
NSString* const IMWarningPrecations = @"Warnings & Precautions";
NSString* const IMSideEffects = @"Side effects";
NSString* const IMOtherPrecations = @"Other precautions";
NSString* const IMNone = @"None";
NSString* const IMDescriptions = @"Description";
NSString* const IMSpecifications = @"Specifications";

NSString* const IMSortText = @"Sort";
NSString* const IMBrandsText = @"Brand";
NSString* const IMCategoriesText = @"Category";

NSString* const IMDeleteConfirmationAlertMessageTitle = @"Delete address";
NSString* const IMDeleteConfirmationAlertMessageMessage = @"Are you sure you want to delete the address?";

NSString* const IMDelete = @"Delete";
NSString* const IMSetAsDefualt = @"Set as default";
NSString* const IMEdit = @"Edit";
NSString* const IMEditAddress = @"Edit address";
NSString* const IMAddAddress = @"Add address";

NSString* const IMPlsFillAddress1 = @"Please fill Address line 1 field" ;
NSString* const IMPlsFillAddress2 = @"Please fill Address line 2 field" ;
NSString* const IMPlsFillPincode = @"Please fill Pincode field" ;
NSString* const IMInvalidPincode = @"Invalid pincode" ;
NSString* const IMUnSupportedArea = @"Out of service area";

NSString* const IMPlsFillCityField = @"Please fill city field";
NSString* const IMInvalidPhoneNumber = @"Invalid Phone Number";

NSString* const IMMAximumQtyReached = @"Maximum quantity reached";
NSString* const IMMAximumQtyExeeded = @"Maximum quantity exceeded";
NSString* const IMShopNow = @"Shop now";
NSString* const IMPrescriptionPresent =  @"Prescription present";
NSString* const IMPrescriptionRequired =  @"Prescription required";
NSString* const IMNotAvaialble =  @"Out of stock"; //ka Replaced "Not available"

NSString* const IMYourOrderRquiresPrescription =  @"Your order requires a prescription";
NSString* const IMUploadNow =  @"Upload prescription now";
NSString* const IMAtDelivery =  @"At time of delivery";
NSString* const IMINsufficientInventory =  @"Insufficient inventory";
NSString* const IMPlsReduceQty = @"Few items in your cart are out of stock/unavailable. Please remove them to proceed.";// @"Please reduce quantity or remove items to proceed";
NSString* const IMInvalidCoupenCode =  @"Invalid coupon code";

NSString* const IMChoosedeliveryAddress =  @"Choose a delivery address";
NSString* const IMdeliverySlot =  @"Delivery slot";
NSString* const IMChooseDeliverySlot =  @"Choose delivery slot";
NSString* const IMPlsSelectADeliveryAddress =  @"Please select a delivery address";
NSString* const IMPlsSelectADeliverySlot =  @"Please select a delivery slot";
NSString* const IMNOPrescription =  @"No prescriptions present";

NSString* const IMNotAvailable =  @"Not available";
NSString* const IMSymptoms =  @"Symptoms";
NSString* const IMDiagnosis =   @"Diagnosis";
NSString* const IMTestPrescribed = @"Tests prescribed";
NSString* const IMNotesAndDirections = @"Notes and directions";


NSString* const IMInvalidCurrentPassword =  @"Current password is invalid";
NSString* const IMPlsEnterValidCurrentPassword =  @"Please enter a valid current password";
NSString* const IMInvalidNewPassword =  @"Password not accepted";
NSString* const IMPlsEnterValidNewPassword = @"Please enter a valid new password";
NSString* const IMPasswordMismatch = @"Password mismatch";
NSString* const IMMismatchInPasswordConfirmation =  @"Please re-type the new password.";

NSString* const IMRemainderOff =  @"Reorder reminder turned off";
NSString* const IMRemainderHasbeenOff =  @"Reminder for this order has been turned off";
NSString* const IMreturnOrderText = @"Return order";
NSString* const IMForreturnPlsContact = @"For returning order, please contact call center";
NSString* const IMCancellSuccess = @"Cancelled";

NSString* const IMReorderReminderSet = @"Reorder reminder set";
NSString* const IMNoProduct = @"No products found";

NSString* const IMCallNotAvailableForCity = @"Call support is not available for the selected city";
NSString* const IMSendOTPtoRegisterdMobile  = @"We have sent an one-time password to your registered mobile number. Please enter it below.";
NSString* const IMPlsEnterValidOTP  = @"Please enter a valid OTP";
NSString* const IMOTPVerification = @"OTP verification";

NSString* const IMPlsEnterNewPassword = @"Please enter new password";
NSString* const IMLetComplete = @"Let's quickly complete your registration.";

NSString* const IMComments = @"Comments";

NSString* const IMCancelReasonMessage = @"Please select a reason for cancellation";

NSString* const IMProductPlaceholderName = @"ProductPlaceHolderList";
NSString* const IMProductPlaceholderPDPName = @"ProductPlaceHolderPDP";

NSString* const IMTickMarkImageName = @"CheckMark";

NSString* const IMUpgradeNow =  @"Upgrade now";
NSString* const IMUpgradeNowMessage =  @"Upgrade Frank Ross application now";
NSString* const IMUpgradeNowTitle =  @"Upgrade";

NSString* const IMUpgradeNowOrLaterMessage =  @"Upgrade Frank Ross application now or later";
NSString* const IMUpgradeNowOrLaterTitle =  @"Upgrade";
NSString* const IMUpgradeLater = @"Later";
NSString* const IMGPSError  = @"Location service is disabled. Please turn on Location Services in your device settings.";
NSString* const IMDummyUserName  = @"Frank Ross customer";
NSString* const IMNoFilteredProduct = @"No products meet the filter criteria, please reset the filters";

NSString* const IMPODExceededTitle  = @"POD limit exceeded";
NSString* const IMPODExceededMessage  = @"Please reduce quantity or remove items to proceed.";

NSString* const IMReviseOrderScreenTitle =  @"Revise order";
NSString* const IMUpdateOrderButtontitle =  @"Update order";
NSString* const IMOrderUpdateSuccessMessage =  @"Your order has been successfully updated.";
NSString* const IMUpdateButtontitle =  @"Update";
NSString* const IMPasswordRequiredtitle =  @"Password required";
NSString* const IMPasswordRequiredMessage = @"Please enter your password.";
NSString* const IMPasswordReRequiredMessage = @"Please re-enter your password.";

NSString* const IMProductNotInCity = @"This product information is not available for the selected city";
NSString* const IMPrescriptionNotCompleteMessage = @"Would you like to complete your prescription uploading?";
//ka Cart screen: Apply button text
NSString* const IMApply =  @"Apply";
NSString* const IMApplied =  @"Remove";

NSString* const IMCallUsOn =  @"Call us on";
NSString* const IMCallNotAvailableMessage =  @"Call facility is not available.";
NSString* const IMNoDeliverySlotsAvailable = @"No delivery slots available";
NSString* const IMCouponCodeCannotBeApplied =  @"Coupon could not be applied";
NSString* const IMCouponCodeCannotBeRemoved =  @"Coupon could not be removed";
NSString* const IMCouponNotAppliedTitle =  @"Coupon not applied";
NSString* const IMCouponNotAppliedMessage =  @"Please apply to proceed";
NSString* const IMFeaturedProductScreenTitle = @"Featured";
NSString* const IMLoginToApplycouponMessage =  @"Please login to apply the coupon";
NSString* const IMDiscountTitle =  @"Additional discount";


//constants used for PayTM payments

NSString *const IMPayTMMerchantIDKey = @"MID";
NSString *const IMPayTMChannelIDKey = @"CHANNEL_ID";
NSString *const IMPayTMIndustryTypeIDKey = @"INDUSTRY_TYPE_ID";
NSString *const IMPayTMWebsiteKey = @"WEBSITE";
NSString *const IMPayTMRequestTypeKey = @"REQUEST_TYPE";
NSString *const IMPayTMCustomerIDKey = @"CUST_ID";
NSString *const IMPayTMTransactionAmountKey = @"TXN_AMOUNT";
NSString *const IMPayTMOrderIDKey = @"ORDER_ID";
NSString *const IMPaytmResponseMessageKey = @"RESPMSG";
NSString *const IMPaytmResponseCodeKey = @"RESPCODE";




//Branch SDK keys

NSString * const BRANCH_USER_ID_KEY = @"BRANCH_INVITE_USER_ID_KEY";
NSString * const BRANCH_USER_FULLNAME_KEY = @"BRANCH_INVITE_USER_FULLNAME_KEY";
NSString * const BRANCH_USER_SHORT_NAME_KEY = @"BRANCH_INVITE_USER_SHORT_NAME_KEY";
NSString * const BRANCH_USER_IMAGE_URL_KEY = @"BRANCH_INVITE_USER_IMAGE_URL_KEY";

//registration methods

NSString * const IMFacebookRegistrationMethod = @"facebook";
NSString * const IMGoogleRegistrationMethod = @"google";
NSString * const IMFrankrossRegistrationMethod = @"frank ross";

//NSUserDefaults Key
NSString *const IMSuccessfulReferralPreferenceKey = @"SuccessfulReferralInstall";

#pragma mark - ViewController Identifiers

NSString *const IMLoginVCID = @"LoginViewController";
NSString *const IMSupportVCID = @"SupportViewController";
NSString *const IMReturnProductsListingVCID = @"RetunProductsListingVC";
NSString *const IMSearchViewControllerID = @"IMSearchViewController";
NSString *const IMSubCategoryViewControllerID = @"IMPharmacySubCategoryVC";
NSString *const IMCategoryProductListingViewControllerID = @"CategoryProductListVC";
NSString *const IMOrderListingViewControllerID = @"IMOrderListVC";
NSString *const IMPrecriptionListingViewControllerID = @"IMPrescriptionListVC";
NSString *const IMPharmaDetailViewControllerID = @"IMPharmaViewController";
NSString *const IMNonPharmaDetailViewControllerID = @"IMNonPharmaViewController";
NSString *const IMPromotionDetailWebviewViewControllerID = @"PromotionDetailScene";
NSString *const IMReferAFriendViewControllerID = @"IMReferAFriendViewController";
NSString *const IMHealthArticlesViewControllerID = @"IMHealthArticlesViewController";



