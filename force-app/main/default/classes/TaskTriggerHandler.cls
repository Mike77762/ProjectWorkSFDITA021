public class TaskTriggerHandler {

    public static void handleAfterInsertUpdate(List<Task> newTasks) {
        Set<Id> accountIds = new Set<Id>();
        
        for (Task t : newTasks) {
            if (t.Status == 'Completed' && t.WhatId != null) {
                String prefix = String.valueOf(t.WhatId).substring(0, 3);
                if (prefix == '001') {
                    accountIds.add(t.WhatId);
                }
            }
        }
        
        if (!accountIds.isEmpty()) {
            List<Account> accountsToUpdate = new List<Account>();
            for (Id accId : accountIds) {
                accountsToUpdate.add(new Account(
                    Id = accId,
                    Last_Interaction_Date__c = Date.today()
                ));
            }
            update accountsToUpdate;
        }
    }
    
    public static void handleBeforeDelete(List<Task> oldTasks) {
        for (Task t : oldTasks) {
            if (t.Status == 'Completed') {
                t.addError('Impossibile eliminare interazioni già completate');
            }
        }
    }
}