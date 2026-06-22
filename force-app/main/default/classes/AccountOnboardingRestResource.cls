@RestResource(urlMapping='/NewClient/*')
global without sharing class AccountOnboardingRestResource {

    @HttpPost
    global static String createPersonAccount(
        String firstName,
        String lastName,
        String email,
        String phone
    ) {
        try {

            Id personAccTypeId = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();
            
            Account accountRecord = new Account();
            accountRecord.RecordTypeId = personAccTypeId;
            accountRecord.FirstName = firstName;
            accountRecord.LastName = lastName;
            accountRecord.PersonEmail = email;
            accountRecord.Phone = phone;
            
            insert accountRecord;
            
            return 'Success: Person Account creato con ID ' + accountRecord.Id;
            
        } catch (Exception e) {
            return 'Errore: ' + e.getMessage();
        }
    }
}