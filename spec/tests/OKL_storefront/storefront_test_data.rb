### TEST CONSTANTS ####
ADDRESS1 = "1999 Broadway"
CITY = "Denver"
STATE = "Colorado"
STATE_ABBR = "CO"
ZIP = "80222"
PHONE = "303-555-1234"
VISA_TEST_CC = "4444444444444448"
VISA_TEST_CCV = "123"
CC_EXP_MONTH = "1"
CC_EXP_YEAR = "2020"

FACEBOOK_EMAIL = "bkitchener@prototest.com"
FACEBOOK_PASSWORD = "Proto123!"

PROTOTEST_OKL_EMAIL = "bkitchener123@prototest.com"
OKL_USER_PASSWORD = "Proto123"
OKL_USER_FIRST_NAME = "TestUser"
OKL_USER_LAST_NAME = "ProtoTest"

OKL_PROD_ENV = "prod" #we'll need the official way to connect to this environment --This is not the correct string for this.

##So here is where we should create a bunch of test accounts
#these test accounts would be checked to see if they're in the database and if not create them
#these kinds of things would be used to verify longstanding accounts or used to increment a number for creating new accounts
#no more of this random crap

CHECKOUT_NEWUSER_EMAIL_PREFIX = "PT_newU_ChkOut_"  #Used for checkout spec
INVFRIENDS_NEWUSER_EMAIL_PREFIX = "PT_newU_InvFriends_" #used for the Events spec
SESSION_NEWUSER_EMAIL_PREFIX = "PT_newU_Session_" #used for the session spec
LOGIN_NEWUSER_EMAIL_PREFIX = "PT_newU_Login_" #used for LoginUser spec
MYACCOUNT_NEWUSER_EMAIL_PREFIX = "PT_newU_MyAccount_" #used for my account spec
VMF_NEWUSER_EMAIL_PREFIX = "PT_newU_VMF_" #used for VMF spec
DEFECT_NEWUSER_ = "PT_newU_Defect_" #used for defect spec
TAXRATE_USER = "TRT_newU_TaxRate_"

#Mobile User prefixs
CHECKOUT_NU_MOBILE = "PT_NuMob_ChkOut_"
INVFRIENDS_NU_MOBILE = "PT_NuMob_InvFriends_"
SESSION_NU_MOBILE = "PT_NuMob_Session_"
LOGIN_NU_MOBILE = "PT_NuMob_Login_"
MYACCOUNT_NU_MOBILE = "PT_NuMob_MyAccount_"
VMF_NU_MOBILE = "PT_NuMob_VMF_"