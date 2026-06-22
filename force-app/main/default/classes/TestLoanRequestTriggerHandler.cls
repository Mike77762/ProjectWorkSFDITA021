@isTest
private class TestLoanRequestTriggerHandler {

    @TestSetup
  
static void setupData() {
    // Crea Account
    Account acc = new Account(Name = 'Test Account');
    insert acc;

    // Crea Loan Request collegato all'Account
    Loan_Request__c loan = new Loan_Request__c(
        Status__c = 'Pending',
        Account__c = acc.Id
    );
    insert loan;

    Task t = new Task(
        WhatId = loan.Id,
        Status = 'In Progress',
        Subject = 'Task di test'
    );
    insert t;
}

    @isTest
    static void testTasksClosedOnApproval() {
        Loan_Request__c loan = [SELECT Id, Status__c FROM Loan_Request__c LIMIT 1];

        Test.startTest();
        loan.Status__c = 'Approved';
        update loan;
        Test.stopTest();

        // Verifica che il Task sia stato chiuso
        Task t = [SELECT Id, Status, Description FROM Task WHERE WhatId = :loan.Id LIMIT 1];
        System.assertEquals('Completed', t.Status, 'Il Task dovrebbe essere Completed');
        System.assertEquals(
            'Chiuso automaticamente per approvazione pratica', 
            t.Description, 
            'La descrizione non corrisponde'
        );
    }

    @isTest
    static void testNoUpdateIfAlreadyApproved() {
        // Loan già Approved → nessuna modifica ai Task
        Loan_Request__c loan = [SELECT Id, Status__c FROM Loan_Request__c LIMIT 1];
        loan.Status__c = 'Approved';
        update loan;

        // Rimetto il task in progress manualmente per simulare lo scenario
        Task t = [SELECT Id, Status FROM Task WHERE WhatId = :loan.Id LIMIT 1];
        t.Status = 'In Progress';
        update t;

        Test.startTest();
        // Aggiorno di nuovo ma era già Approved → handler non si attiva
        loan.Name = loan.Name; // update fittizio
        update loan;
        Test.stopTest();

        Task tAfter = [SELECT Status FROM Task WHERE WhatId = :loan.Id LIMIT 1];
        System.assertEquals('In Progress', tAfter.Status, 'Il Task non dovrebbe essere toccato');
    }

    @isTest
    static void testTaskAlreadyCompletedNotUpdated() {
        Loan_Request__c loan = [SELECT Id FROM Loan_Request__c LIMIT 1];

        // Task già completato prima dell'approvazione
        Task t = [SELECT Id, Status FROM Task WHERE WhatId = :loan.Id LIMIT 1];
        t.Status = 'Completed';
        update t;

        Test.startTest();
        loan.Status__c = 'Approved';
        update loan;
        Test.stopTest();

        // Deve rimanere Completed (non viene toccato dalla query perché filtra Status != 'Completed')
        Task tAfter = [SELECT Status, Description FROM Task WHERE WhatId = :loan.Id LIMIT 1];
        System.assertEquals('Completed', tAfter.Status);
        System.assertNotEquals(
            'Chiuso automaticamente per approvazione pratica', 
            tAfter.Description,
            'Il Task già completato non dovrebbe essere riscritto'
        );
    }
}