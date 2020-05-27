# Consent Management

Once the user has successfully logged in, you may want your users to accept the terms and conditions. You can configure different consent forms during setup and present that to the user after login.

#### Installation

```
pod 'Cidaas/Consent'
```

```swift
var consent = CidaasConsent.shared
```

#### Getting Consent Details 

To get the consent details call **getConsentDetails()**.

```swift
var incomingData: ConsentDetailsRequestEntity = ConsentDetailsRequestEntity()
incomingData.consent_id = "xxx-46ygddfdfg-45456fdvfg"
incomingData.sub = "46sg4h-xxxx-xx"
incomingData.consent_version_id = "xxxx-45456fdvfg-xx"
incomingData.track_id = "xxxx-45456fdvfg-xx"
incomingData.requestId = "46ygddfdfg-xxxxx-xx"

consent.getConsentDetails(incomingData : incomingData) {
    switch $0 {
        case .success(let response):
            // your success code here
        break
        case .failure(let error):
            // your failure code here
        break
    }
} 
```
Here, **consent_id, sub, consent_version_id, track_id, requestId** is the key you would get from the error response of Login

**Response:**

```json
{
    "success": true,
    "status": 200,
    "data": {
        "consent_id": "xxx-46ygddfdfg-45456fdvfg",
        "consent_version_id": "xxxx-45456fdvfg-xx",
        "url":"https://acb.com"
    }
}
```

#### Accept Consent

To accept the consent you need to call ****acceptConsent()****

```swift
consent.acceptConsent(incomingData:incomingData) {
    switch $0 {
        case .success(let response):
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
        "consent_id": "xxx-46ygddfdfg-45456fdvfg",
        "consent_version_id": "xxxx-45456fdvfg-xx",
        "accepted": true
    }
}
```

#### Consent Continue

To continue lgin after accepting consent, call ****consentContinue()****

```swift
consent.consentContinue(incomingData:incomingData) {
    switch $0 {
        case .success(let response):
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
