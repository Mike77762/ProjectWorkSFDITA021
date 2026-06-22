@isTest
public class TaskTriggerTest {
    
    @isTest
    static void testLastInteractionDateUpdate() {

        Account acc = new Account(
            LastName = 'Test',
            RecordTypeId = [
                SELECT Id FROM RecordType 
                WHERE SObjectType = 'Account' 
                AND Name = 'Account personale' 
                LIMIT 1
            ].Id,
            Tax_Code__c = 'TSTMRA85M01H501Z'
        );
        insert acc;
        
        Task t = new Task(
            Subject = 'Test Task',
            Status = 'Not Started',
            WhatId = acc.Id
        );
        insert t;
        
        t.Status = 'Completed';
        update t;
        
        Account updatedAcc = [
            SELECT Last_Interaction_Date__c 
            FROM Account 
            WHERE Id = :acc.Id
        ];
        
        System.assertEquals(
            Date.today(), 
            updatedAcc.Last_Interaction_Date__c,
            'LastInteractionDate deve essere aggiornato a oggi'
        );
    }
    
    @isTest
    static void testCannotDeleteCompletedTask() {

        Account acc = new Account(
            LastName = 'Test Delete',
            RecordTypeId = [
                SELECT Id FROM RecordType 
                WHERE SObjectType = 'Account' 
                AND Name = 'Account personale' 
                LIMIT 1
            ].Id,
            Tax_Code__c = 'TSTMRA85M01H502Z'
        );
        insert acc;
        
        Task t = new Task(
            Subject = 'Test Delete Task',
            Status = 'Completed',
            WhatId = acc.Id
        );
        insert t;
        
        try {
            delete t;
            System.assert(false, 'Doveva lanciare un errore');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Impossibile eliminare'),
                'Messaggio di errore corretto'
            );
        }
    }
}