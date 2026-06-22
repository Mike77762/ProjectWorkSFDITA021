public class LoanRequestTriggerHandler {

    public static void handleAfterUpdate(
        List<Loan_Request__c> newLoans, 
        Map<Id, Loan_Request__c> oldLoansMap
    ) {
        List<Id> approvedLoanIds = new List<Id>();
        
        for (Loan_Request__c loan : newLoans) {
            Loan_Request__c oldLoan = oldLoansMap.get(loan.Id);
            if (loan.Status__c == 'Approved' && 
                oldLoan.Status__c != 'Approved') {
                approvedLoanIds.add(loan.Id);
            }
        }
        
        if (!approvedLoanIds.isEmpty()) {
            List<Task> tasksToUpdate = [
                SELECT Id, Status, Description 
                FROM Task 
                WHERE WhatId IN :approvedLoanIds
                AND Status != 'Completed'
            ];
            
            for (Task t : tasksToUpdate) {
                t.Status = 'Completed';
                t.Description = 'Chiuso automaticamente per approvazione pratica';
            }
            
            if (!tasksToUpdate.isEmpty()) {
                update tasksToUpdate;
            }
        }
    }
    
}