public class LeadGDPRCleanupBatch implements Database.Batchable<sObject>, Schedulable {

    public void execute(SchedulableContext sc) {
        LeadGDPRCleanupBatch batchJob = new LeadGDPRCleanupBatch();
        Database.executeBatch(batchJob, 200);
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id 
            FROM Lead 
            WHERE Status = 'Dead' 
            AND CreatedDate < LAST_N_DAYS:365
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        if (scope != null && !scope.isEmpty()) {
            try {
                delete scope;
                
                DataBase.emptyRecycleBin(scope);
                
            } catch (DmlException e) {
                System.debug('Errore durante la cancellazione GDPR: ' + e.getMessage());
            }
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Operazione completata: Il Batch di pulizia GDPR ha terminato l\'elaborazione.');
    }
}