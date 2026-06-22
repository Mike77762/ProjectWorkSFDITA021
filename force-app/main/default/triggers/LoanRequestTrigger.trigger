trigger LoanRequestTrigger on Loan_Request__c (after insert, after update) {
    
    if (Trigger.isAfter && Trigger.isInsert) {
        Set<Id> ids = new Set<Id>();
        for (Loan_Request__c loan : Trigger.new) {
            if (loan.Annual_Interest_Rate__c == null) {
                ids.add(loan.Id);
            }
        }
        if (!ids.isEmpty()) {
            LoanCalloutService.updateInterestRateAsync(ids);
        }
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        Set<Id> ids = new Set<Id>();
        for (Loan_Request__c loan : Trigger.new) {
            Loan_Request__c oldLoan = Trigger.oldMap.get(loan.Id);
            if (loan.Annual_Interest_Rate__c == null && 
                oldLoan.Annual_Interest_Rate__c == null) {
                ids.add(loan.Id);
            }
        }
        if (!ids.isEmpty()) {
            LoanCalloutService.updateInterestRateAsync(ids);
        }
        
        LoanRequestTriggerHandler.handleAfterUpdate(
            Trigger.new, 
            Trigger.oldMap
        );
    }
}