# cidaas-sdk-ios-v2

### Getting Started

The steps here will guide you through setting up and managing authentication and authorization in your apps using cidaas SDK.

#### Requirements

Operating System : iOS 10.0 or above

Xcode : 9

Swift : 4.0



#### Installation

##### CocoaPods Installations



Cidaas is available through CocoaPods. To install it, simply add the following line to your Podfile:



pod 'Cidaas', '~> 1.0'



#### Getting started

The following steps are to be followed to use this Cidaas-SDK.



Create a plist file named as <b>cidaas.plist</b>
 and fill all the inputs in key value pair. The inputs are below mentioned.



The plist file should become like this :

```

<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">



<plist version="1.0">

<dict>

<key> DomainURL </key>

<string> Your Domain URL </string>


<key> RedirectURI </key>

<string> Your redirect uri </string>



<key> ClientID </key>

<string> Your client id </string>

</dict>

</plist>

```

#### Getting app id and urls



You will get the property file for your application from the cidaas AdminUI.



image



#### Steps for integrate native iOS SDKs:



##### Initialisation



Initialise the cidaas sdk using the options.



```javascript

var cidaas = Cidaas();

or

var cidaas = Cidaas.shared

```



### Usage



#### Getting Request ID



Each and every proccesses starts with requestId, it is an entry point to login or register. For getting the requestId, call ****getRequestId()****.


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



**Response Object:**



```json

{

"success":true,

"status":200,

"data":{

"groupname":"default",

"lang":"en-US,en;q=0.9,de-DE;q=0.8,de;q=0.7",

"view_type":"login",

"requestId":"45a921cf-ee26-46b0-9bf4-58636dced99f”

}

}

```



#### Getting Tenant Info



To get the tenant basic information, call ****getTenantInfo()****. This will return the basic tenant details such as tenant name and allowed login with types (Email, Mobile, Username).



```javascript

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





**Response Object:**



```json

{

    "success": 
true,

    "status": 
200,

    "data": {

        "tenant_name": 
"Cidaas Management",

        "allowLoginWith": [

            "EMAIL",

            "MOBILE",

            "USER_NAME"

        ]

    }

}

```



#### Get Client Info



To get the client basic information, call ****getClientInfo()****. This will return the basic client details such as client name and allowed social login providers (Facebook, Google and others).



```javascript

cidaas.getClientInfo(requestId: "123456") {

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



**Response Object:**



```json

{

"success":true,

"status":200,

"data":{

"passwordless_enabled":true,

"logo_uri":"https://www.cidaas.com/wp-content/uploads/2018/02/logo-black.png",

"login_providers":[

"facebook",

"linkedin"

],

"policy_uri":"",

"tos_uri":"",

"client_name":"demo-app1”

}

}

```



#### Login with credentials



To login with your credentials, call ****loginWithCredentials()****.



```javascript

let loginEntity = LoginEntity()

loginEntity.username = "abc@gmail.com"

loginEntity.password = "123456"

loginEntity.username_type = "email"


self.cidaas.loginWithCredentials(requestId: "12345", loginEntity: loginEntity) {

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



**Request Object:**

```json

{

    "username": 
"davidjhonson@gmail.com",

    "username_type": 
"email",

    "password": 
"123456",

    "requestId": 
"744b499a-7291-4560-bce9-bda529ceb0d7"

}

```

**Response Object:**

```json

{

    "success": 
true,

    "status": 
200,

    "data": {

        "token_type": 
"Bearer",

        "expires_in": 
86400,

        "access_token": 
"eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTVmNDktNGZlYS04MGNlLTZmYTkzMzk2YjI4NyJ9*****",

        "session_state": 
"CNT7GGALeoKyTF6Og-cZHAuHUJBQ20M0jLL35oh3UGk.vcNxCNq4Y68",

        "viewtype": 
"login",

        "grant_type": 
"login"

    }

}

```



#### Getting Registration Fields



To handle registration, first you need the registration fields. To get the registration fields, call ****getRegistrationFields()****. This will return the fields that has to be needed while registration.



```javascript

cidaas.getRegistrationFields(requestId: "your_requestId") {

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



**Response Object:**



```json

{

    "success": 
true,

    "status": 
200,

    "data": [

        {

            "dataType": 
"EMAIL",

            "fieldGroup": 
"DEFAULT",

            "isGroupTitle": 
false,

            "fieldKey": 
"email",

            "fieldType": 
"SYSTEM",

            "order": 
1,

            "readOnly": 
false,

            "required": 
true,

            "fieldDefinition": {},

            "localeText": {

                "locale": 
"en-us",

                "language": 
"en",

                "name": 
"Email",

                "verificationRequired":
"Given Email is not verified.",

                "required": 
"Email is Required"

            }

        },

        {

            "dataType": 
"TEXT",

            "fieldGroup": 
"DEFAULT",

            "isGroupTitle": 
false,

            "fieldKey": 
"given_name",

            "fieldType": 
"SYSTEM",

            "order": 
2,

            "readOnly": 
false,

            "required": 
true,

            "fieldDefinition": {

                "maxLength": 
150

            },

            "localeText": {

                "maxLength": 
"Givenname cannot be more than 150 chars",

                "required": 
"Given Name is Required",

                "name": 
"Given Name",

                "language": 
"en",

                "locale": 
"en-us"

            }

        },

        {

            "dataType": 
"TEXT",

            "fieldGroup": 
"DEFAULT",

            "isGroupTitle": 
false,

            "fieldKey": 
"family_name",

            "fieldType": 
"SYSTEM",

            "order": 
3,

            "readOnly": 
false,

            "required": 
true,

            "fieldDefinition": {

                "maxLength": 
150

            }

        },

        {

            "dataType": 
"MOBILE",

            "fieldGroup": 
"DEFAULT",

            "isGroupTitle": 
false,

            "fieldKey": 
"mobile_number",

            "fieldType": 
"SYSTEM",

            "order": 
6,

            "readOnly": 
false,

            "required": 
false,

            "fieldDefinition": {

                "verificationRequired":
true

            }

        }

    ]

}

```



#### Register user



Once registration fields are getting, then design your customized UI and to register user call ****registerUser()****. This method will create a new user.



```javascript 

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

registrationEntity.email = davidjhonson@gmail.com
registrationEntity.given_name = David

registrationEntity.family_name = Jhonson

registrationEntity.password = test123

registrationEntity.password_echo = test123

registrationEntity.provider = "SELF"

registrationEntity.mobile_number = "+919826546598"

registrationEntity.username = "davidjhonson"


cidaas.registerUser(requestId: "your_requestId", registrationEntity: registrationEntity) {

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





**Request Object:**

```json

{

    "provider": 
"SELF",

    "email": 
"davidjhonson@gmail.com",

    "given_name": 
"David",

    "family_name": 
"Jhonson",

    "password": 
"test123",

    "password_echo": 
"test123",

    "username": 
"davidjhonson",

    "customfield1": 
"testcustomfields"

}

```

**Response Object:**

```json

{

    "success": 
true,

    "status": 
200,

    "data": {

        "sub": 
"7dfb2122-fa5e-4f7a-8494-dadac9b43f9d",

        "userStatus": 
"VERIFIED",

        "email_verified": 
false,

        "suggested_action": 
"LOGIN"

    }

}

```

### Physical Verification



After successful login, we can add multifactor authentications.



### EMAIL



#### Configure Email



To send a verification code to email, call 
**configureEmail()**.



##### Sample code



```js



cidaas.configureEmail(sub: "123123") {

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



##### Response



```json



{

"success": 
true,

"status": 
200,

"data": {

"statusId": 
"5f5cbb84-4ceb-4975-b347-4bfac61e9248"

}

}



```



###Configure email with code

##### Sample code



```js



cidaas.enrollEmail(code: "123123") {

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



##### Response



```json



{

"success": 
true,

"status": 
200,

"data": {

"sub": "5f5cbb84-4ceb-4975-b347-4bfac61e9248",

"trackingCode":"122343"

}

}



```



#### Authenticate Email



To verify the code, call **loginWithEmail()**.



##### Sample code



```js

cidaas.loginWithEmail(email: "abc@gmail.com",trackId:"312424",requestId:"245dsf", usageType:
"PASSWORDLESS_AUTHENTICATION") {

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



##### Response



```json



{

"success": 
true,

"status": 
200,

"data": {

"sub": "6f7e672c-1e69-4108-92c4-3556f13eda74",

"trackingCode": 
"5f5cbb84-4ceb-4975-b347-4bfac61e9248"

}

}



```



###Verify email with code

##### Sample code



```js



cidaas.verifyEmail(code: "123123") {

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

##### Response



```json



{

    "success": 
true,

    "status": 
200,

    "data": {

        "token_type": 
"Bearer",

        "expires_in": 
86400,

        "access_token": 
"eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTVmNDktNGZlYS04MGNlLTZmYTkzMzk2YjI4NyJ9*****",

        "session_state": 
"CNT7GGALeoKyTF6Og-cZHAuHUJBQ20M0jLL35oh3UGk.vcNxCNq4Y68",

        "viewtype": 
"login",

        "grant_type": 
"login"

    }

}

```



### SMS



#### Configure SMS



To send a verification code to mobile via sms, call 
**configureSMS()**.



##### Sample code



```js



cidaas.configureSMS(sub: "123123") {

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



##### Response



```json



{

"success": 
true,

"status": 
200,

"data": {

"statusId": 
"5f5cbb84-4ceb-4975-b347-4bfac61e9248"

}

}



```

###Configure SMS with code

##### Sample code



```js



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

##### Response



```json



{

"success": 
true,

"status": 
200,

"data": {

"sub": "5f5cbb84-4ceb-4975-b347-4bfac61e9248",

"trackingCode":"122343"

}

}



```



#### Authenticate SMS



To verify the code, call **loginWithSMS()**.





##### Sample code



```js

cidaas.loginWithSMS(mobile: "+919543435187",trackId:"312424",requestId:"245dsf", usageType:
"PASSWORDLESS_AUTHENTICATION") {

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



##### Response



```json



{

"success": 
true,

"status": 
200,

"data": {

"sub": "6f7e672c-1e69-4108-92c4-3556f13eda74",

"trackingCode": 
"5f5cbb84-4ceb-4975-b347-4bfac61e9248"

}

}



```



### Verify SMS with code

##### Sample code



```js



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

##### Response



```json



{

    "success": 
true,

    "status": 
200,

    "data": {

        "token_type": 
"Bearer",

        "expires_in": 
86400,

        "access_token": 
"eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTVmNDktNGZlYS04MGNlLTZmYTkzMzk2YjI4NyJ9*****",

        "session_state": 
"CNT7GGALeoKyTF6Og-cZHAuHUJBQ20M0jLL35oh3UGk.vcNxCNq4Y68",

        "viewtype": 
"login",

        "grant_type": 
"login"

    }

}

```



### IVR



#### Configure IVR



To send a verification code to mobile via IVR, call 
**configureIVR()**.



##### Sample code



```js



cidaas.configureIVR(sub: "123123") {

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



##### Response



```json



{

"success": 
true,

"status": 
200,

"data": {

"statusId": 
"5f5cbb84-4ceb-4975-b347-4bfac61e9248"

}

}



```

###Configure IVR with code

##### Sample code



```js



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

##### Response



```json



{

"success": 
true,

"status": 
200,

"data": {

"sub": "5f5cbb84-4ceb-4975-b347-4bfac61e9248",

"trackingCode":"122343"

}

}



```



#### Authenticate IVR



To verify the code, call **loginWithIVR()**.





##### Sample code



```js

cidaas.loginWithIVR(mobile: "+919543435187",trackId:"312424",requestId:"245dsf", usageType:
"PASSWORDLESS_AUTHENTICATION") {

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



##### Response



```json



{

"success": 
true,

"status": 
200,

"data": {

"sub": "6f7e672c-1e69-4108-92c4-3556f13eda74",

"trackingCode": 
"5f5cbb84-4ceb-4975-b347-4bfac61e9248"

}

}



```



### Verify IVR with code

##### Sample code



```js



cidaas.verifyIVR(code: "123123") {

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

##### Response



```json



{

    "success": 
true,

    "status": 
200,

    "data": {

        "token_type": 
"Bearer",

        "expires_in": 
86400,

        "access_token": 
"eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTVmNDktNGZlYS04MGNlLTZmYTkzMzk2YjI4NyJ9*****",

        "session_state": 
"CNT7GGALeoKyTF6Og-cZHAuHUJBQ20M0jLL35oh3UGk.vcNxCNq4Y68",

        "viewtype": 
"login",

        "grant_type": 
"login"

    }

}

```



### BackupCode



#### Configure BackupCode



To configure or view the backupcode, call 
**configureBackupcode()**.



##### Sample code



```js



cidaas.configureBackupcode(sub: "123123") {

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



##### Response



```json



{

"success": 
true,

"status": 
200,

"data": {

"statusId": 
"5f5cbb84-4ceb-4975-b347-4bfac61e9248"

}

}





```



#### Authenticate Backupcode



To verify the backupcode, call 
**loginWithBackupcode()**.



##### Sample code



```js

cidaas.loginWithBackupcode(email: "abc@gmail.com",trackId:"312424",requestId:"245dsf",code:"6543", usageType:
"PASSWORDLESS_AUTHENTICATION") {

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



##### Response



```json



{

    "success": 
true,

    "status": 
200,

    "data": {

        "token_type": 
"Bearer",

        "expires_in": 
86400,

        "access_token": 
"eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTVmNDktNGZlYS04MGNlLTZmYTkzMzk2YjI4NyJ9*****",

        "session_state": 
"CNT7GGALeoKyTF6Og-cZHAuHUJBQ20M0jLL35oh3UGk.vcNxCNq4Y68",

        "viewtype": 
"login",

        "grant_type": 
"login"

    }

}



```



#### Initiate Account Verification



To configure the initiate Account Verification, call 
**initiateAccountVerification()**.



##### Sample code



```js



cidaas.initiateAccountVerification(requestId:"2423", sub:"123123", VerificationMedium:
"email") {

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



##### Response



```json



{

"success": 
true,

"status": 
200,

"data": {

"accvid":"353446"

}

}

```



#### Verify Account



To verify the Account Verification, call 
**verifyAccount()**.



##### Sample code



```js

cidaas.verifyAccount(code:"6544") {

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



##### Response



```json



{

"success": 
true,

"status": 
200

}

```



### Forgot Password



#### Initiate Reset Password



##### Sample code



```js

cidaas.initateRestPassword(requestId:"465465",processingType:"",email:"",resetMedium:"email") {

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



##### Response



```json

{

"data": {

"rprq": "f595edfb-754e-444c-ba01-6b69b89fb42a",

"reset_initiated": 
true

},

"success": 
true,

"status": 
200

}

```



#### Handle Reset Password



##### Sample code



```js

cidaas.handleRestPassword(code:"6576") {

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



##### Response



```json

{

"data": {

"exchangeId": 
"1c4176bd-12b0-4672-b20c-9616e93457ed",

"resetRequestId": 
"f595edfb-754e-444c-ba01-6b69b89fb42a"

},

"success": 
true,

"status": 
200

}

```



#### Reset Password



##### Sample code



```js

cidaas.restPassword(password:"465465",confirmPassword:"465465") {

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



##### Response



```json

{

"data": {

"reseted":true

},

"success": 
true,

"status": 
200

}

```



### Consent Management

#### Get Consent Details 

##### Sample code



```js

cidaas.getConsentDetails(consent_name:"test", consent_version:1, track_Id:
"432523") {

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



##### Response



```json

{

"data": {

"_id":"3543trr",

"decription":"test consent",

"title":"test",

"userAgreeText":"term and condition",

"url":"https://acb.com"

},

"success": 
true,

"status": 
200

}

```



#### Login After Consent

##### Sample code



```js

cidaas.loginAfterConsent(sub:"2423", accepted:true) {

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



##### Response



```json

{

    "success": 
true,

    "status": 
200,

    "data": {

        "token_type": 
"Bearer",

        "expires_in": 
86400,

        "access_token": 
"eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTVmNDktNGZlYS04MGNlLTZmYTkzMzk2YjI4NyJ9*****",

        "session_state": 
"CNT7GGALeoKyTF6Og-cZHAuHUJBQ20M0jLL35oh3UGk.vcNxCNq4Y68",

        "viewtype": 
"login",

        "grant_type": 
"login"

    }

}

```

### De-duplication



#### Get Deduplication Details



##### Sample code



```js

cidaas.getDeduplicationDetails(track_id:"5475765") {

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



##### Response



```json

{

"success": 
true,

"status": 
200,

"data": {

"email": 
"raja@fn.com",

"deduplicationList": [

{

"provider": 
"SELF",

"sub": "39363935-4d04-4411-8606-6805c4e673b4",

"email": 
"raja********n2716@g***l.com",

"emailName": 
"raja********n2716",

"firstname": 
"Raja123",

"lastname": 
"SK1",

"displayName": 
"Raja123 SK1",

"currentLocale": 
"IN",

"country": 
"India",

"region": 
"Delhi",

"city": "Delhi",

"zipcode": 
"110008"

},

{

"provider": 
"SELF",

"sub": "488b8128-5584-4c25-9776-6ed34c6e7017",

"email": 
"ra****n21@g***l.com",

"emailName": 
"ra****n21",

"firstname": 
"RajaSK",

"lastname": 
"RsdfsdfN",

"displayName": 
"RajaSK RsdfsdfN",

"currentLocale": 
"IN",

"country": 
"India",

"region": 
"Delhi",

"city": "Delhi",

"zipcode": 
"110008"

}

]

}

}

```



#### Register Deduplication Details



##### Sample code



```js

cidaas.registerDeduplication(track_id:"5475765") {

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



##### Response



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





### TOTP



#### Configure TOTP



To configure the TOTP, call 
**configureTOTP()**.



##### Sample code



```swift



cidaas.configureTOTP(sub: "123123") {

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



##### Response



```swifton



{

"success": true,

"status": 200,

"data": {

"statusId": "5f5cbb84-4ceb-4975-b347-4bfac61e9248"

}

}

```



#### Authenticate TOTP



To verify the TOTP, call **loginWithTOTP()**.





##### Sample code



```swift

cidaas.loginWithTOTP(email: "abc@gmail.com",trackId:"312424",requestId:"245dsf", usageType: "PASSWORDLESS_AUTHENTICATION") {

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



##### Response



```json



{

    "success": 
true,

    "status": 
200,

    "data": {

        "token_type": 
"Bearer",

        "expires_in": 
86400,

        "access_token": 
"eyJhbGciOiswiftUzI1NiIsImtpZCI6IjUxNWYxMGE5LTVmNDktNGZlYS04MGNlLTZmYTkzMzk2YjI4NyJ9*****",

        "session_state": 
"CNT7GGALeoKyTF6Og-cZHAuHUJBQ20M0jLL35oh3UGk.vcNxCNq4Y68",

        "viewtype": 
"login",

        "grant_type": 
"login"

    }

}



```



### Pattern



#### Configure Pattern



To configure the pattern, call 
**configurePatternRecognition()**.



##### Sample code



```swift



cidaas.configurePatternRecognition(sub: "123123") {

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



##### Response



```json



{

"success": 
true,

"status": 
200,

"data": {

"statusId": 
"5f5cbb84-4ceb-4975-b347-4bfac61e9248"

}

}





```



#### Authenticate Pattern



To verify the pattern, call 
**loginWithPatternRecognition()**.





##### Sample code



```js

cidaas.loginWithPatternRecognition(pattern: "RED[1,2,3], email: "abc@gmail.com",trackId:"312424",requestId:"245dsf",
 usageType: "PASSWORDLESS_AUTHENTICATION") 
{

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



##### Response



```json



{

    "success": 
true,

    "status": 
200,

    "data": {

        "token_type": 
"Bearer",

        "expires_in": 
86400,

        "access_token": 
"eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTVmNDktNGZlYS04MGNlLTZmYTkzMzk2YjI4NyJ9*****",

        "session_state": 
"CNT7GGALeoKyTF6Og-cZHAuHUJBQ20M0jLL35oh3UGk.vcNxCNq4Y68",

        "viewtype": 
"login",

        "grant_type": 
"login"

    }

}



```

### TouchId



#### Configure TouchId



To configure the TouchId, call 
**configureTouchId()**.



##### Sample code



```js



cidaas.configureTouchId(sub: "123123") {

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



##### Response



```json



{

"success": 
true,

"status": 
200,

"data": {

"statusId": 
"5f5cbb84-4ceb-4975-b347-4bfac61e9248"

}

}





```



#### Authenticate TouchId



To verify the TouchId, call 
**loginWithTouchId()**.





##### Sample code



```js

cidaas.loginWithTouchId(email: "abc@gmail.com",trackId:"312424",requestId:"245dsf", usageType:
"PASSWORDLESS_AUTHENTICATION") {

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



##### Response



```json



{

    "success": 
true,

    "status": 
200,

    "data": {

        "token_type": 
"Bearer",

        "expires_in": 
86400,

        "access_token": 
"eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTVmNDktNGZlYS04MGNlLTZmYTkzMzk2YjI4NyJ9*****",

        "session_state": 
"CNT7GGALeoKyTF6Og-cZHAuHUJBQ20M0jLL35oh3UGk.vcNxCNq4Y68",

        "viewtype": 
"login",

        "grant_type": 
"login"

    }

}



```

### SmartPush Notification



#### Configure SmartPush



To configure the SmartPush, call 
**configureSmartPush()**.



##### Sample code



```js



cidaas.configureSmartPush(sub: "123123") {

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



##### Response



```json



{

"success": 
true,

"status": 
200,

"data": {

"statusId": 
"5f5cbb84-4ceb-4975-b347-4bfac61e9248"

}

}





```



#### Authenticate SmartPush



To verify the SmartPush, call 
**loginWithSmartPush()**.





##### Sample code



```js

cidaas.loginWithSmartPush(email: "abc@gmail.com",trackId:"312424",requestId:"245dsf", usageType:
"PASSWORDLESS_AUTHENTICATION") {

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



##### Response



```json



{

    "success": 
true,

    "status": 
200,

    "data": {

        "token_type": 
"Bearer",

        "expires_in": 
86400,

        "access_token": 
"eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTVmNDktNGZlYS04MGNlLTZmYTkzMzk2YjI4NyJ9*****",

        "session_state": 
"CNT7GGALeoKyTF6Og-cZHAuHUJBQ20M0jLL35oh3UGk.vcNxCNq4Y68",

        "viewtype": 
"login",

        "grant_type": 
"login"

    }

}



```



### FaceRecognition



#### Configure Face



To configure the FaceRecognition, call 
**configureFaceRecognition()**.



##### Sample code



```js



cidaas.configureFaceRecognition(photo: image,sub: 
"123123") {

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



##### Response



```json



{

"success": 
true,

"status": 
200,

"data": {

"statusId": 
"5f5cbb84-4ceb-4975-b347-4bfac61e9248"

}

}





```

#### Authenticate FaceRecognition



To verify the FaceRecognition, call 
**loginWithFaceRecognition()**.





##### Sample code



```js

cidaas.loginWithFaceRecognition(photo:image, email: 
"abc@gmail.com",trackId:"312424",requestId:"245dsf", usageType:
"PASSWORDLESS_AUTHENTICATION") {

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



##### Response



```json



{

    "success": 
true,

    "status": 
200,

    "data": {

        "token_type": 
"Bearer",

        "expires_in": 
86400,

        "access_token": 
"eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTVmNDktNGZlYS04MGNlLTZmYTkzMzk2YjI4NyJ9*****",

        "session_state": 
"CNT7GGALeoKyTF6Og-cZHAuHUJBQ20M0jLL35oh3UGk.vcNxCNq4Y68",

        "viewtype": 
"login",

        "grant_type": 
"login"

    }

}



```



### VoiceRecognition



#### Configure Voice



To configure the Voice Recognition, call 
**configureVoiceRecognition()**.



##### Sample code



```js



cidaas.configureVoiceRecognition(voice: data, sub: 
"123123") {

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



##### Response



```json



{

"success": 
true,

"status": 
200,

"data": {

"statusId": 
"5f5cbb84-4ceb-4975-b347-4bfac61e9248"

}

}





```

#### Authenticate Voice Recognition



To verify the Voice Recognition, call 
**loginWithVoiceRecognition()**.





##### Sample code



```js

cidaas.loginWithVoiceRecognition(voice:data,email: 
"abc@gmail.com",trackId:"312424",requestId:"245dsf",usageType:
"PASSWORDLESS_AUTHENTICATION") {

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



##### Response



```json



{

    "success": 
true,

    "status": 
200,

    "data": {

        "token_type": 
"Bearer",

        "expires_in": 
86400,

        "access_token": 
"eyJhbGciOiJSUzI1NiIsImtpZCI6IjUxNWYxMGE5LTVmNDktNGZlYS04MGNlLTZmYTkzMzk2YjI4NyJ9*****",

        "session_state": 
"CNT7GGALeoKyTF6Og-cZHAuHUJBQ20M0jLL35oh3UGk.vcNxCNq4Y68",

        "viewtype": 
"login",

        "grant_type": 
"login"

    }

}



```
