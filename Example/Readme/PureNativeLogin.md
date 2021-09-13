# Native UI Integration

This document will guide to link the appropriate cidaas methods and services to your customized native login screen using cidaas SDK.   

## Table of Contents

<!--ts-->
* [Getting RequestId ](#getting-requestid) 
* [Getting Tenant Information](#getting-tenant-info)
* [Getting Client Information](#getting-client-info)
* [Login](#login)
    <!--ts-->
    * [Login with credentials](#login-with-credentials)
    <!--te-->
* [Registration](#registration)
    <!--ts-->
    * [Getting Registration Fields](#getting-registration-fields)
    * [Register user](#register-user)
    * [Update user info](#update-user-info)
    <!--te-->
* [Update User Info](#update-user-info)
    <!--ts-->
    <!--te-->
* [De-duplication](#de-duplication)
    <!--ts-->
    * [Get Deduplication Details](#get-deduplication-details)
    * [Register user](#register-user-1)
    * [Login With Deduplication](#login-with-deduplication)
    <!--te-->
* [Account Verification](#account-verification)
    <!--ts-->
    * [Initiate Account verification](#initiate-account-verification)
    * [Verify Account](#verify-account)
    <!--te-->
* [Forgot Password](#forgot-password)
    <!--ts-->
    * [Initiate Reset Password](#initiate-reset-password)
    * [Handle Reset Password](#handle-reset-password)
    * [Reset Password](#reset-password)
    <!--te-->
* [Change Password](#change-password-after-login)
    <!--ts-->
    * [Change Password](#change-password-after-login)
    <!--te-->
* [Passwordless or Multifactor Authentication](/Example/Readme/Passwordless.md)
<!--te-->

#### Native UI Integration

#### Installation

```
pod 'Cidaas/Native'
```

#### Getting RequestId

To get the requestId, call ****getRequestId()****.

```swift
cidaas.getRequestId() {
    switch $0 {
        case .success(let requestIdInfoSuccess):
            // your success code here
        break
        case .failure(let error):
            // your failure code here
        break
    }
} 
```

**Response:**

```json
{
    "success": true,
    "status": 200,
    "data": {
        "groupname": "default",
        "view_type": "login",
        "requestId": "3f7e8b29-xxxx-xxxx-xxxx-0b138b2f588e"
    }
}
```

#### Getting Tenant Info
Sometimes you may want to lookup different types of login available ('Email', 'Mobile', 'Username') for a particular tenant. 
To get the tenant information, call ****getTenantInfo()****.

```swift
cidaas.getTenantInfo() {
    switch $0 {
        case .success(let tenantInfoSuccess):
            // your success code here
        break
        case .failure(let error):
            // your failure code here
        break
    }
} 
```

**Response:**

```json
{
    "success": true,
    "status": 200,
    "data": {
        "tenant_name": "Cidaas Management",
        "allowLoginWith": [
            "EMAIL",
            "MOBILE",
            "USER_NAME"
        ]
    }
}
```

#### Getting Client Info

If you need to find client information you can call the following method. It contains client name, logo url specified for the client in the Admin's Apps section and details of what all social providers are configured for the App. To get the client information, call ****getClientInfo()****.

```swift
cidaas.getClientInfo() {
    switch $0 {
        case .success(let clientInfoSuccess):
            // your success code here
        break
        case .failure(let error):
            // your failure code here
        break
    }
}
```

**Response:**

```json
{
    "success": true,
    "status": 200,
    "data": {
        "passwordless_enabled": true,
        "logo_uri": "https://www.cidaas.com/wp-content/uploads/2018/02/logo-black.png",
        "login_providers": [
            "facebook",
            "linkedin"
        ],
        "policy_uri": "",
        "tos_uri": "",
        "client_name": "demo-app"
    }
}
```

#### Login
#### Login with credentials

To login with your username and password, call ****loginWithCredentials()****.

```swift
let loginEntity = LoginEntity()
loginEntity.username = "xxx@gmail.com"
loginEntity.password = "test123"
loginEntity.requestId = "82425345-435345-xxxxx"
loginEntity.username_type = "email" // either email or mobile or username

cidaas.loginWithCredentials(loginEntity: loginEntity) {
    switch $0 {
        case .success(let loginSuccess):
            // your success code here
        break
        case .failure(let error):
            // your failure code here
        break
    }
}
```

**Response:**
```json
{
    "success": true,
    "status": 200,
    "data": {
        "token_type": "Bearer",
        "expires_in": 86400,
        "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTV",
        "session_state": "CNT7TF6Og-cCNq4Y68",
        "viewtype": "login",
        "grant_type": "login"
    }
}
```

#### Registration
#### Getting Registration Fields

Before registration, you may want to know what all are the fields that you must show to your user. For getting these fields, call ****getRegistrationFields()****.

```swift
cidaas.getRegistrationFields() {
    switch $0 {
        case .failure(let error):
            // your failure code here
        break
        case .success(let registrationFieldsResponse):
            // your success code here
        break
    }
} 
```

**Response:**

```json
{
    "success": true,
    "status": 200,
    "data": [{
        "dataType": "EMAIL",
        "fieldGroup": "DEFAULT",
        "isGroupTitle": false,
        "fieldKey": "email",
        "fieldType": "SYSTEM",
        "order": 1,
        "readOnly": false,
        "required": true,
        "fieldDefinition": {},
        "localeText": {
            "locale": "en-us",
            "language": "en",
            "name": "Email",
            "verificationRequired": "Given Email is not verified.",
            "required": "Email is Required"
        }
    },
    {
        "dataType": "TEXT",
        "fieldGroup": "DEFAULT",
        "isGroupTitle": false,
        "fieldKey": "given_name",
        "fieldType": "SYSTEM",
        "order": 2,
        "readOnly": false,
        "required": true,
        "fieldDefinition": {
            "maxLength": 150
        },
        "localeText": {
            "maxLength": "Givenname cannot be more than 150 chars",
            "required": "Given Name is Required",
            "name": "Given Name",
            "language": "en",
            "locale": "en-us"
        }
    }]
}
```

#### Register user

To register a new user, call ****registerUser()****.

```swift 
let customPostalCode: RegistrationCustomFieldsEntity = RegistrationCustomFieldsEntity()
customPostalCode.key = "postal_code"
customPostalCode.dataType = "TEXT"
customPostalCode.readOnly = false
customPostalCode.value = text_postalcode.text!

let age: RegistrationCustomFieldsEntity = RegistrationCustomFieldsEntity()
age.key = "postal_code"
age.dataType = "TEXT"
age.readOnly = false
age.value = "25"

let registrationEntity : RegistrationEntity = RegistrationEntity()
registrationEntity.email = "xxx@gmail.com"
registrationEntity.given_name = "xxx"
registrationEntity.family_name = "yyy"
registrationEntity.password = "test123"
registrationEntity.password_echo = "test123"
registrationEntity.provider = "SELF" // either self or facebook or google or other login providers
registrationEntity.mobile_number = "+919876543210"
registrationEntity.username = "xxxxxxx"

cidaas.registerUser(registrationEntity: registrationEntity) {
    switch $0 {
        case .failure(let error):
            // your failure code here
        break
        case .success(let registrationResponse):
            // your success code here
        break
    }
} 
```

**Response:**

```json
{
    "success": true,
    "status": 200,
    "data": {
        "sub": "7dfb2122-fa5e-4f7a-8494-dadac9b43f9d",
        "userStatus": "VERIFIED",
        "email_verified": false,
        "suggested_action": "LOGIN"
    }
}
```

#### Update user info

To update the information for an existing user or for accepted consent call **updateUser()**.

**Note:** <i>You can also use this method to **change a user's email address**.</i>

```swift 
    let registrationEntity = RegistrationEntity()
     registrationEntity.given_name = "updatedName"
     registrationEntity.sub = sub
     registrationEntity.provider = "self" // either self or facebook or google or other login providers

  and for updating consent, add value to key field "true" or "false" in customFields of RegistrationEntity.          


cidaas.updateUser(access_token: accessToken, incomingData: registrationEntity) {
    switch $0 {
        case .failure(let error):
            // your failure code here
        break
        case .success(let updateResponse):
            // your success code here
        break
    }
} 
```
**Response:**

```json
{
    "success": true,
    "status": 200,
    "data": {
        "updated" :  "true"
    }
}
```
#### De-duplication

User de-duplication is a process that eliminates redundant user accounts thus reducing storage overhead as well as other inefficiencies. This process can be triggered during registration itself by the following steps.

When a user is being registered, the system does a de-duplication check, to verify if the user already exists. The system then shows the list of potential users whose data seem to match most of the information entered during this registration. The system then gives an option to the user to use one of the found duplicate record or reject all of them and register as a fresh user.

In order to implement the above functionality, few of the below methods have to be called.

#### Get Deduplication Details

To get the list of similar users, call ****getDeduplicationDetails()****. If this method is used, system uses some heuristic algorithms and finds out if any similar user exists in the system and returns them.

```swift
cidaas.getDeduplicationDetails(track_id:"45a921cf-ee26-46b0-9bf4-58636dced99f") {
    switch $0 {
        case .success(let configureSuccess):
            // your success code here
        break
        case .failure(let error):
            // your failure code here
        break
    }
}
```
Here, **track_id** is the key you would get from the success response of the registration 

**Response:**

```json
{
    "success": true,
    "status": 200,
    "data": {
        "email": "xxx@gmail.com",
        "deduplicationList": [
        {
            "provider": "SELF",
            "sub": "39363935-4d04-4411-8606-6805c4e673b4",
            "email": "xxx********n2716@g***l.com",
            "emailName": "xxx********n2716",
            "firstname": "xxx",
            "lastname": "yyy",
            "displayName": "xxx yyy",
            "currentLocale": "IN",
            "country": "India",
            "region": "Delhi",
            "city": "Delhi",
            "zipcode": "110008"
        },
        {
            "provider": "SELF",
            "sub": "488b8128-5584-4c25-9776-6ed34c6e7017",
            "email": "xx****n21@g***l.com",
            "emailName": "xx****n21",
            "firstname": "xxx",
            "lastname": "yyy",
            "displayName": "xxx yyy",
            "currentLocale": "IN",
            "country": "India",
            "region": "Delhi",
            "city": "Delhi",
            "zipcode": "110008"
        }]
    }
}
```

#### Register User

While registering the new user, if the system finds already registered similar users, the list of similar users is displayed. The user can decide whether to use one of the existing logins, or choose to ignore all shown user accounts. ****registerUser()**** method can be called to ignore shown result and register details in registration form as a new user.

```swift
cidaas.registerUser(track_id:"45a921cf-ee26-46b0-9bf4-58636dced99f") {
    switch $0 {
        case .success(let configureSuccess):
            // your success code here
        break
        case .failure(let error):
            // your failure code here
        break
    }
} 
```
Here, **track_id** is the key you would get from the success response of the registration

**Response:**

```swift 
{
    "success": true,
    "status": 200,
    "data": {
        "sub": "51701ec8-f2d7-4361-a727-f8df476a711a",
        "userStatus": "VERIFIED",
        "email_verified": false,
        "suggested_action": "LOGIN"
    }
} 
```

#### Login With Deduplication

While registering the new user, if the system finds already registered similar users, the list of similar users is displayed. The user can decide whether to use one of the existing logins, or choose to ignore all shown user accounts. ****loginWithDeduplication()**** method can be called to use one of those existing logins shown by the system. Note that, System will still use the secure authentication and verifications that were setup for the earlier user, before login.

```swift
cidaas.loginWithDeduplication("sub": "51701ec8-f2d7-4361-a727-f8df476a711a", "password": "123456") {
    switch $0 {
        case .success(let loginWithSuccess):
            // your success code here
        break
        case .failure(let error):
            // your failure code here
        break
    }
} 
```

**Response:**

```json
{
    "success": true,
    "status": 200,
    "data": {
        "token_type": "Bearer",
        "expires_in": 86400,
        "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMZlYS04MGNlLTZmYTkzMzk2YjI4NyJ9*****",
        "session_state": "CNT7GGALeoKyTF6Og-cZHAuHUJBQ20M0jLL35oh3UGk.vcNxCNq4Y68",
        "viewtype": "login",
        "grant_type": "login"
    }
}
```

#### Account Verification
In order to avoid misuse of user registration functions, it is a good practice to include account verification along with it.
Once registeration is done, you can verify your account either by Email, SMS or IVR verification call. To do this, first you have to initiate the account verification. You can invoke any of the following  based on your use case.

#### Initiate Account Verification

This method has to be used when you want to receive a verification code or Link via email/sms/ivr:

```swift
let incomingData: InitiateAccountVerificationEntity = InitiateAccountVerificationEntity()
incomingData.requestId = "Your request id"
incomingData.processingType = "CODE" // You can set CODE or LINK as processingType
incomingData.verificationMedium = "email" //You can set email,sms,ivr
incomingData.sub = "your received sub" // This you can get it from the registration api response
incomingData.email = "your email"
incomingData.mobile = "your mobile"

// sub, email or mobile any one is mandatory. sub - you can get it from registration api response

cidaas.initiateAccountVerification(accountVerificationEntity: incomingData) {
    switch $0 {
        case .success(let successResponse):
            // your success code here
        break
        case .failure(let errorResponse):
            // your failure code here
        break
    }
}
```

**Response:**

```json
{
    "success": true,
    "status": 200,
    "data": {
        "accvid":"353446"
    }
}
```

#### Verify Account

Once you received your verification code via any of the mediums like Email, SMS or IVR, you need to verify the code. For that verification, call **verifyAccount()**. You get the accvid in the initate account verification call

```swift
let accountVerificationEntity = VerifyAccountEntity()
accountVerificationEntity.accvid = "your accvid"
accountVerificationEntity.code = "your otp"

cidaas.verifyAccount(accountVerificationEntity: accountVerificationEntity) {
    switch $0 {
        case .success(let successResponse):
            // your success code here
        break
        case .failure(let errorResponse):
            // your failure code here
        break
    }
}
```

**Response:**

```json
{
    "success": true,
    "status": 200
}
```

#### Forgot Password

There is an option to reset password in case the password is forgotten.

#### Initiate Reset Password

For resetting password, you will get a verification code either via Email or SMS. For that you need to call ****initateRestPassword()****.

```swift
let incomingData: InitiateResetPasswordEntity = InitiateResetPasswordEntity()
incomingData.requestId = "Your request id"
incomingData.processingType = "CODE" // You can set CODE or LINK as processingType
incomingData.resetMedium = "email" //You can set email,sms,ivr
incomingData.email = "your email"
incomingData.mobile = "your mobile" // pass either email or mobile depends on resetMedium

cidaas.initateRestPassword(incomingData: initiateResetPassworEntity) {
    switch $0 {
        case .success(let configureSuccess):
            // your success code here
        break
        case .failure(let error):
            // your failure code here
        break
    }
} 
```

**Response:**

```json
{
    "success": true,
    "status": 200,
    "data": {
        "rprq": "f595edfb-754e-444c-ba01-6b69b89fb42a", // available only for code flow
        "reset_initiated": true
    }
}

```

#### Handle Reset Password

Once the verification code is received, verify that code by calling ****handleRestPassword()****.

```swift
let handleResetPasswordEntity = HandleResetPasswordEntity()
handleResetPasswordEntity.code = "123456" // code you received via email or sms
handleResetPasswordEntity.resetRequestId = "f595edfb-754e-444c-ba01-6b69b89fb42a" // rprq you received in the preivous request

cidaas.handleRestPassword(incomingData: handleResetPasswordEntity) {
    switch $0 {
        case .success(let configureSuccess):
            // your success code here
        break
        case .failure(let error):
            // your failure code here
        break
    }
} 
```

**Response:**

```json
{
    "success": true,
    "status": 200,
    "data": {
        "exchangeId": "1c4176bd-12b0-4672-b20c-9616e93457ed",
        "resetRequestId": "f595edfb-754e-444c-ba01-6b69b89fb42a"
    }
}
```

#### Reset Password

Once the code is verified, reset your password with your new password. To reset your password, call ****restPassword()****.

```swift
let resetPasswordEntity = ResetPasswordEntity()
resetPasswordEntity.password = "123456"
resetPasswordEntity.confirmPassword = "123456"
resetPasswordEntity.exchangeId = "1c4176bd-12b0-4672-b20c-9616e93457ed" // exchangeId you receive in the previous response
resetPasswordEntity.resetRequestId = "f595edfb-754e-444c-ba01-6b69b89fb42a" // resetRequestId you receive in the previous response

cidaas.restPassword(incomingData: ResetPasswordEntity) {
    switch $0 {
        case .success(let configureSuccess):
            // your success code here
        break
        case .failure(let error):
            // your failure code here
        break
    }
} 
```

**Response:**

```json
{
    "success": true,
    "status": 200,
    "data": {
        "reseted":true
    }
}
```
#### Change Password After Login

You can change your existing password after login by calling **changePassword()**. 

**Note:** <i>If you are using the **getUserInfo()** method to get the profile information and identityId, you need to use the **last_used_identity_id** passed in this method as the **identityId**.</i>

```swift
let incomingData = ChangePasswordEntity()
incomingData.new_password = "123456"
incomingData.confirm_password = "123456"
incomingData.old_password = "12345678"
incomingData.identityId = "f595edfb-754e-444c-ba01-6b69b89fb42a"
        
cidaasNative.changePassword(access_token: "eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTV", incomingData: incomingData) {
    switch $0 {
        case .success(let successResponse):
            // your success code here
        break
        case .failure(let error):
            // your failure code here
        break
    }
}
```
**Response:**

```json
{
    "success": true,
    "status": 200,
    "data": {
        "changed":true
    }
}
```



