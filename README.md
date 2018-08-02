# cidaas-sdk-ios-v2

The steps here will guide you through setting up and managing authentication and authorization in your apps using cidaas SDK.    

### Requirements

Operating System | Xcode | Swift
--- | --- | ---
iOS 10.0 or above | 9.0 or above | 3.3 or above 


### Installation

#### CocoaPods Installations

Cidaas is available through [CocoaPods](https://cocoapods.org/pods/Cidaas). To install it, simply add the following line to your Podfile:

```
pod 'Cidaas', '~> 0.0.1'
```
### Getting started

The following steps are to be followed to use this Cidaas-SDK.

Create a plist file named as <b>cidaas.plist</b> and fill all the inputs in key value pair. The inputs are below mentioned.

The plist file should become like this :

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>DomainURL</key>
        <string>Your Domain URL</string>
        <key>RedirectURL</key>
        <string>Your redirect url</string>
        <key>ClientID</key>
        <string>Your client id</string>
    </dict>
</plist>
```

### Getting App Id and urls

You will get the property file for your application from the cidaas AdminUI.

### Steps for integrate native iOS SDKs:

#### Initialisation

The first step of integrating cidaas sdk is the initialisation process.

```swift
var cidaas = Cidaas();
```
or use the shared instance

```swift
var cidaas = Cidaas.shared
```

### Usage

#### Getting Request Id

All the login and registration process done with the help of requestId. To get the requestId, call ****getRequestId()****.

```swift
cidaas.getRequestId() {
    switch $0 {
        case .success(let requestIdSuccess):
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
    "success":true,
    "status":200,
    "data": {
        "groupname":"default",
        "lang":"en-US,en;q=0.9,de-DE;q=0.8,de;q=0.7",
        "view_type":"login",
        "requestId":"45a921cf-ee26-46b0-9bf4-58636dced99f”
    }
}
```

#### Getting Tenant Info

It is more important to get the tenant information such as Tenant name and what are all the login ways ('Email', 'Mobile', 'Username') available for the particular tenant. To get the tenant information, call ****getTenantInfo()****.

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

#### Get Client Info

Once getting tenant information, next you need to get client information that contains client name, logo url specified for the client in the Admin's Apps section and what are all the social providers configured for the App. To get the client information, call ****getClientInfo()****.

```swift
cidaas.getClientInfo(requestId: "45a921cf-ee26-46b0-9bf4-58636dced99f") {
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

#### Registration
#### Getting Registration Fields

Before registration, you need to know what are all the fields must show to the user while registration. For getting the fields, call ****getRegistrationFields()****.

```swift
cidaas.getRegistrationFields(requestId: "45a921cf-ee26-46b0-9bf4-58636dced99f") {
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

Registration is the most important thing for all. To register a new user, call ****registerUser()****.

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

cidaas.registerUser(requestId: "45a921cf-ee26-46b0-9bf4-58636dced99f", registrationEntity: registrationEntity) {
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

#### Account Verification

Once registration completed, you need to verify your account either by Email or SMS or IVR verification call. First you need to initiate the account verification.

#### Initiate Email verification

To receive a verification code via Email, call **initiateEmailVerification()**.

```swift
cidaas.initiateEmailVerification(requestId:"45a921cf-ee26-46b0-9bf4-58636dced99f", sub:"7dfb2122-fa5e-4f7a-8494-dadac9b43f9d") {
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

#### Initiate SMS verification

To receive a verification code via SMS, call **initiateSMSVerification()**.

```swift
cidaas.initiateSMSVerification(requestId:"45a921cf-ee26-46b0-9bf4-58636dced99f", sub:"7dfb2122-fa5e-4f7a-8494-dadac9b43f9d") {
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

#### Initiate IVR verification

To receive a verification code via IVR verification call, call **initiateIVRVerification()**.

```swift
cidaas.initiateIVRVerification(requestId:"45a921cf-ee26-46b0-9bf4-58636dced99f", sub:"7dfb2122-fa5e-4f7a-8494-dadac9b43f9d") {
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
        "accvid":"353446"
    }
}
```

#### Verify Account

Once you received your verification code via any of the mediums like Email, SMS or IVR, you need to verify the code. For that verification, call **verifyAccount()**.

```swift
cidaas.verifyAccount(code:"658144") {
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
    "status": 200
}
```

#### Login
#### Login with credentials

To login with your username and password, call ****loginWithCredentials()****.

```swift
let loginEntity = LoginEntity()
loginEntity.username = "xxx@gmail.com"
loginEntity.password = "test#123"
loginEntity.username_type = "email" // either email or mobile or username

cidaas.loginWithCredentials(requestId: "45a921cf-ee26-46b0-9bf4-58636dced99f", loginEntity: loginEntity) {
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

#### Forgot Password

Remembering passwords all the time is impossible, if you forget your password, you have an option to reset it.

#### Initiate Reset Password

For resetting password, you will get a verification code either via Email or SMS. For that you need to call ****initateRestPassword()****.

```swift
cidaas.initateRestPassword(requestId:"45a921cf-ee26-46b0-9bf4-58636dced99f",email:"xxx@gmail.com") {
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

```swift
cidaas.initateRestPassword(requestId:"45a921cf-ee26-46b0-9bf4-58636dced99f",mobile:"+919876543210") {
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
        "rprq": "f595edfb-754e-444c-ba01-6b69b89fb42a",
        "reset_initiated": true
    }
}

```

#### Handle Reset Password

Once verification code received, verify that code by calling ****handleRestPassword()****.

```swift
cidaas.handleRestPassword(code:"65864776") {
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

Once verifying the code, reset your password with your new password. To reset your password, call ****restPassword()****.

```swift
cidaas.restPassword(password:"test#123",confirmPassword:"test#123") {
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

#### Passwordless or Multifactor Authentication

#### Email

To use your Email as a passwordless login, you need to configure your Email first and verify your Email. If you already verify your Email through account verification, by default Email will be configured. 

#### Configure Email

To receive a verification code via Email, call **configureEmail()**.

```swift
cidaas.configureEmail(sub: "7dfb2122-fa5e-4f7a-8494-dadac9b43f9d") {
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
        "statusId": "5f5cbb84-4ceb-4975-b347-4bfac61e9248"
    }
}
```

#### Verify Email by entering code

Once you received your verification code via Email, you need to verify the code. For that verification, call **enrollEmail()**.

```swift
cidaas.enrollEmail(code: "658144") {
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
        "sub": "7dfb2122-fa5e-4f7a-8494-dadac9b43f9d",
        "trackingCode":"5f5cbb84-4ceb-4975-b347-4bfac61e9248"
    }
}
```

#### Login via Email

Once you configured your Email, you can also login with your Email via Passwordless authentication. To receive a verification code via Email, call **loginWithEmail()**.

```swift
let passwordlessEntity = PasswordlessEntity()
passwordlessEntity.email = "xxx@gmail.com"
passwordlessEntity.requestId = "45a921cf-ee26-46b0-9bf4-58636dced99f"
passwordlessEntity.usageType = UsageTypes.PASSWORDLESS.rawValue

cidaas.loginWithEmail(passwordlessEntity: passwordlessEntity) {
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
        "statusId": "6f7e672c-1e69-4108-92c4-3556f13eda74"
    }
}
```

#### Verify Email by entering code

Once you received your verification code via Email, you need to verify the code. For that verification, call **verifyEmail()**.

```swift
cidaas.verifyEmail(code: "123123") {
    switch $0 {
        case .success(let verifySuccess):
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

#### SMS

To use SMS as a passwordless login, you need to configure SMS physical verification first and verify your mobile number. If you already verify your mobile number through account verification via SMS, by default SMS will be configured. 

#### Configure SMS

To receive a verification code via SMS, call **configureSMS()**.

```swift
    cidaas.configureSMS(sub: "7dfb2122-fa5e-4f7a-8494-dadac9b43f9d") {
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
        "statusId": "5f5cbb84-4ceb-4975-b347-4bfac61e9248"
    }
}
```

#### Verify SMS by entering code

Once you received your verification code via SMS, you need to verify the code. For that verification, call **enrollSMS()**.

```swift
    cidaas.enrollSMS(code: "123123") {
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
        "sub": "7dfb2122-fa5e-4f7a-8494-dadac9b43f9d",
        "trackingCode":"5f5cbb84-4ceb-4975-b347-4bfac61e9248"
    }
}
```

#### Login via SMS

Once you configured SMS, you can also login with SMS via Passwordless authentication. To receive a verification code via SMS, call **loginWithSMS()**.

```swift
let passwordlessEntity = PasswordlessEntity()
passwordlessEntity.mobile = "+919876543210" // must starts with country code
passwordlessEntity.requestId = "45a921cf-ee26-46b0-9bf4-58636dced99f"
passwordlessEntity.usageType = UsageTypes.PASSWORDLESS.rawValue

cidaas.loginWithSMS(passwordlessEntity: passwordlessEntity) {
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
        "statusId": "6f7e672c-1e69-4108-92c4-3556f13eda74"
    }
}
```

#### Verify SMS by entering code

Once you received your verification code via SMS, you need to verify the code. For that verification, call **verifySMS()**.

```swift
cidaas.verifySMS(code: "123123") {
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
        "token_type": "Bearer",
        "expires_in": 86400,
        "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTV",
        "session_state": "CNT7TF6Og-cCNq4Y68",
        "viewtype": "login",
        "grant_type": "login"
    }
}
```

#### IVR

To use IVR as a passwordless login, you need to configure IVR physical verification first and verify your mobile number. If you already verify your mobile number through account verification via IVR, by default IVR will be configured. 

#### Configure IVR

To receive a verification code via IVR, call **configureIVR()**.

```swift
cidaas.configureIVR(sub: "7dfb2122-fa5e-4f7a-8494-dadac9b43f9d") {
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
        "statusId": "5f5cbb84-4ceb-4975-b347-4bfac61e9248"
    }
}
```

#### Verify IVR by entering code

Once you received your verification code via IVR verification call, you need to verify the code. For that verification, call **enrollIVR()**.

```swift
cidaas.enrollIVR(code: "123123") {
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
        "sub": "7dfb2122-fa5e-4f7a-8494-dadac9b43f9d",
        "trackingCode":"5f5cbb84-4ceb-4975-b347-4bfac61e9248"
    }
}
```

#### Login via IVR

Once you configured IVR, you can also login with IVR via Passwordless authentication. To receive a verification code via IVR verification call, call **loginWithIVR()**.

```swift
let passwordlessEntity = PasswordlessEntity()
passwordlessEntity.mobile = "+919876543210" // must starts with country code
passwordlessEntity.requestId = "45a921cf-ee26-46b0-9bf4-58636dced99f"
passwordlessEntity.usageType = UsageTypes.PASSWORDLESS.rawValue

cidaas.loginWithIVR(passwordlessEntity: passwordlessEntity){
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
        "statusId": "6f7e672c-1e69-4108-92c4-3556f13eda74"
    }
}
```

#### Verify IVR by entering code

Once you received your verification code via IVR, you need to verify the code. For that verification, call **verifyIVR()**.

```swift
cidaas.verifyIVR(code: "123123") {
    switch $0 {
        case .success(let verifySuccess):
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

#### BackupCode

To use Backupcode as a passwordless login, you need to configure Backupcode physical verification first.

#### Configure BackupCode

To configure or view the Backupcode, call **configureBackupcode()**.

```swift
cidaas.configureBackupcode(sub: "7dfb2122-fa5e-4f7a-8494-dadac9b43f9d") {
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
        "statusId": "6f7e672c-1e69-4108-92c4-3556f13eda74",
        "backupCodes": [{
            "code": "63537876",
            "used": false,
        },
        {
            "code": "76482357",
            "used": false,        
        }]
    }
}
```

#### Login via Backupcode

Once you configured Backupcode, you can also login with Backupcode via Passwordless authentication. To login with Backupcode, call **loginWithBackupcode()**.

```swift
let passwordlessEntity = PasswordlessEntity()
passwordlessEntity.email = "xxx@gmail.com"
passwordlessEntity.requestId = "45a921cf-ee26-46b0-9bf4-58636dced99f"
passwordlessEntity.usageType = UsageTypes.PASSWORDLESS.rawValue

cidaas.loginWithBackupcode(code: "63537876", passwordlessEntity: passwordlessEntity){
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
        "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTV",
        "session_state": "CNT7TF6Og-cCNq4Y68",
        "viewtype": "login",
        "grant_type": "login"
    }
}
```

#### TOTP

To use TOTP as a passwordless login, you need to configure TOTP physical verification first.

#### Configure TOTP

To configure TOTP verification, call **configureTOTP()**.

```swift
cidaas.configureTOTP(sub: "7dfb2122-fa5e-4f7a-8494-dadac9b43f9d") {
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

```swift
{
    "success": true,
    "status": 200,
    "data": {
        "statusId": "5f5cbb84-4ceb-4975-b347-4bfac61e9248"
    }
}
```

#### Login via TOTP

Once you configured TOTP, you can also login with TOTP via Passwordless authentication. To login, call **loginWithTOTP()**.

```swift
let passwordlessEntity = PasswordlessEntity()
passwordlessEntity.email = "xxx@gmail.com"
passwordlessEntity.requestId = "45a921cf-ee26-46b0-9bf4-58636dced99f"
passwordlessEntity.usageType = UsageTypes.PASSWORDLESS.rawValue

cidaas.loginWithTOTP(passwordlessEntity: passwordlessEntity) {
    switch $0 
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
        "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTV",
        "session_state": "CNT7TF6Og-cCNq4Y68",
        "viewtype": "login",
        "grant_type": "login"
    }
}
```



#### Pattern Recognition

To use Pattern Recognition as a passwordless login, you need to configure it first.

#### Configure Pattern Recognition

To configure Pattern Recognition, call **configurePatternRecognition()**.

```swift
cidaas.configurePatternRecognition(pattern: "RED[1,2,3], sub: "7dfb2122-fa5e-4f7a-8494-dadac9b43f9d") {
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

```swift
{
    "success": true,
    "status": 200,
    "data": {
        "statusId": "5f5cbb84-4ceb-4975-b347-4bfac61e9248"
    }
}
```

#### Login via Pattern Recognition

Once you configured Pattern Recognition, you can also login with Pattern Recognition via Passwordless authentication. To login, call **loginWithPatternRecognition()**.

```swift
let passwordlessEntity = PasswordlessEntity()
passwordlessEntity.email = "xxx@gmail.com"
passwordlessEntity.requestId = "45a921cf-ee26-46b0-9bf4-58636dced99f"
passwordlessEntity.usageType = UsageTypes.PASSWORDLESS.rawValue

cidaas.loginWithPatternRecognition(pattern: "RED[1,2,3], passwordlessEntity: passwordlessEntity) {
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
        "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTV",
        "session_state": "CNT7TF6Og-cCNq4Y68",
        "viewtype": "login",
        "grant_type": "login"
    }
}
```

#### TouchId Verification

To use TouchId Verification as a passwordless login, you need to configure it first.

#### Configure TouchId Verification

To configure TouchId Verification, call **configureTouchId()**.

```swift
cidaas.configureTouchId(sub: "7dfb2122-fa5e-4f7a-8494-dadac9b43f9d") {
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

```swift
{
    "success": true,
    "status": 200,
    "data": {
        "statusId": "5f5cbb84-4ceb-4975-b347-4bfac61e9248"
    }
}
```

#### Login via Touch Id Verification

Once you configured Touch Id Verification, you can also login with Touch Id Verification via Passwordless authentication. To login, call **loginWithTouchId()**.

```swift
let passwordlessEntity = PasswordlessEntity()
passwordlessEntity.email = "xxx@gmail.com"
passwordlessEntity.requestId = "45a921cf-ee26-46b0-9bf4-58636dced99f"
passwordlessEntity.usageType = UsageTypes.PASSWORDLESS.rawValue

cidaas.loginWithTouchId(passwordlessEntity: passwordlessEntity) {
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
        "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTV",
        "session_state": "CNT7TF6Og-cCNq4Y68",
        "viewtype": "login",
        "grant_type": "login"
    }
}
```

### SmartPush Notification

To use SmartPush Notification as a passwordless login, you need to configure it first.

#### Configure SmartPush Notification

To configure SmartPush Notification, call **configureSmartPush()**.

```swift
cidaas.configureSmartPush(sub: "7dfb2122-fa5e-4f7a-8494-dadac9b43f9d") {
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

```swift
{
    "success": true,
    "status": 200,
    "data": {
        "statusId": "5f5cbb84-4ceb-4975-b347-4bfac61e9248"
    }
}
```

#### Login via SmartPush Notification

Once you configured SmartPush Notification, you can also login with SmartPush Notification via Passwordless authentication. To login, call **loginWithSmartPush()**.

```swift
let passwordlessEntity = PasswordlessEntity()
passwordlessEntity.email = "xxx@gmail.com"
passwordlessEntity.requestId = "45a921cf-ee26-46b0-9bf4-58636dced99f"
passwordlessEntity.usageType = UsageTypes.PASSWORDLESS.rawValue

cidaas.loginWithSmartPush(passwordlessEntity: passwordlessEntity) {
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
        "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTV",
        "session_state": "CNT7TF6Og-cCNq4Y68",
        "viewtype": "login",
        "grant_type": "login"
    }
}
```

#### Face Recognition

Biometric plays an important role in the modern world. cidaas authenticates you by verifying your Face. To use Face Recognition as a passwordless login, you need to configure it first.

#### Configure Face Recognition

To configure Face Recognition, call **configureFaceRecognition()**.

```swift
cidaas.configureFaceRecognition(photo: photo, sub: "7dfb2122-fa5e-4f7a-8494-dadac9b43f9d") {
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

```swift
{
    "success": true,
    "status": 200,
    "data": {
        "statusId": "5f5cbb84-4ceb-4975-b347-4bfac61e9248"
    }
}
```

#### Login via Face Recognition

Once you configured Face Recognition, you can also login with Face Recognition via Passwordless authentication. To login, call **loginWithFaceRecognition()**.

```swift
let passwordlessEntity = PasswordlessEntity()
passwordlessEntity.email = "xxx@gmail.com"
passwordlessEntity.requestId = "45a921cf-ee26-46b0-9bf4-58636dced99f"
passwordlessEntity.usageType = UsageTypes.PASSWORDLESS.rawValue

cidaas.loginWithFaceRecognition(photo: photo, passwordlessEntity: passwordlessEntity) {
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
        "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTV",
        "session_state": "CNT7TF6Og-cCNq4Y68",
        "viewtype": "login",
        "grant_type": "login"
    }
}
```

#### Voice Recognition

Biometric plays an important role in the modern world. cidaas authenticates you by verifying your voice. To use Voice Recognition as a passwordless login, you need to configure it first.
 
#### Configure Voice Recognition

To configure Voice Recognition, call **configureVoiceRecognition()**.

```swift
cidaas.configureVoiceRecognition(voice: audioData, sub: "7dfb2122-fa5e-4f7a-8494-dadac9b43f9d") {
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

```swift
{
    "success": true,
    "status": 200,
    "data": {
        "statusId": "5f5cbb84-4ceb-4975-b347-4bfac61e9248"
    }
}
```

#### Login via Voice Recognition

Once you configured Voice Recognition, you can also login with Voice Recognition via Passwordless authentication. To login, call **loginWithVoiceRecognition()**.

```swift
let passwordlessEntity = PasswordlessEntity()
passwordlessEntity.email = "xxx@gmail.com"
passwordlessEntity.requestId = "45a921cf-ee26-46b0-9bf4-58636dced99f"
passwordlessEntity.usageType = UsageTypes.PASSWORDLESS.rawValue

cidaas.loginWithVoiceRecognition(voice: audioData, passwordlessEntity: passwordlessEntity) {
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
        "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTV",
        "session_state": "CNT7TF6Og-cCNq4Y68",
        "viewtype": "login",
        "grant_type": "login"
    }
}
```

#### Consent Management

Once user successfully logged in, they need to accept the terms and conditions. 

#### Getting Consent Details 

To get the consent details call **getConsentDetails()**.

```swift
cidaas.getConsentDetails(consent_name:"default", consent_version:1, track_Id: "45a921cf-ee26-46b0-9bf4-58636dced99f") {
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
        "_id":"3543trr",
        "decription":"test consent",
        "title":"test",
        "userAgreeText":"term and condition",
        "url":"https://acb.com"
    }
}
```

#### Login After Consent

After accepting the consent you need to continue further by calling ****loginAfterConsent()****

```swift
cidaas.loginAfterConsent(sub:"7dfb2122-fa5e-4f7a-8494-dadac9b43f9d", accepted:true) {
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
        "token_type": "Bearer",
        "expires_in": 86400,
        "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTVmNDktNGZlYS04MGNlLTZmYTkzMzk2YjI4NyJ9*****",
        "session_state": "CNT7GGALeoKyTF6Og-cZHAuHUJBQ20M0jLL35oh3UGk.vcNxCNq4Y68",
        "viewtype": "login",
        "grant_type": "login"
    }
}
```

#### De-duplication

#### Get Deduplication Details

To get the list of similar users, call ****getDeduplicationDetails()****

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

If the user not exists in the similar users, call ****registerUser()****

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

If the user not exists in the similar users, call ****registerUser()****

```swift
cidaas.loginWithDeduplication(track_id:"45a921cf-ee26-46b0-9bf4-58636dced99f") {
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
        "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTVmNDktNGZlYS04MGNlLTZmYTkzMzk2YjI4NyJ9*****",
        "session_state": "CNT7GGALeoKyTF6Og-cZHAuHUJBQ20M0jLL35oh3UGk.vcNxCNq4Y68",
        "viewtype": "login",
        "grant_type": "login"
    }
}
```
```
