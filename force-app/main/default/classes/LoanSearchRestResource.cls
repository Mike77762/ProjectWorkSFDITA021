@RestResource(urlMapping='/UserLoans/*')
global without sharing class LoanSearchRestResource {

    @HttpGet
    global static List<Loan_Request__c> getUserLoans() {
        String name = RestContext.request.params.get('name');
        
        if (String.isBlank(name)) {
            return new List<Loan_Request__c>();
        }
        
        List<Loan_Request__c> loans = [
            SELECT Id, Name, Amount__c, Status__c, 
                   Annual_Interest_Rate__c, Requested_Term_Months__c,
                   Account__r.Name
            FROM Loan_Request__c
            WHERE Account__r.Name LIKE :('%' + name + '%')
        ];
        
        return loans;
    }
}