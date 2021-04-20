# Version 1.2.8

Support CustomField value as Any type to pass any kind of dataType values  

#### Sample Code for registration

```swift
let registrationEntity = RegistrationEntity()
registrationEntity.email = "xxx@gmail.com"
registrationEntity.given_name = "xx"
registrationEntity.family_name = "xx"
registrationEntity.password = "123456"
registrationEntity.password_echo = "123456"
registrationEntity.provider = "SELF"

registrationEntity.customFields = Dictionary<String, RegistrationCustomFieldsEntity>()

// add customField

let field: RegistrationCustomFieldsEntity = RegistrationCustomFieldsEntity()
field.value = true
field.key = "field_key"

registrationEntity.customFields["field"] = field

cidaasNative.registerUser(requestId: self.requestID, incomingData: registrationEntity) {
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
