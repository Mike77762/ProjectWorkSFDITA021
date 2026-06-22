public class BranchAnalyticsService {

    public static void generatePerformanceReport() {
        
        List<AggregateResult> results = [
            SELECT Status__c, 
                   SUM(Amount__c) totale, 
                   AVG(Amount__c) media
            FROM Loan_Request__c 
            GROUP BY Status__c
        ];
        
        for (AggregateResult ar : results) {
            String statusVal = (String) ar.get('Status__c');
            Decimal sumAmount = (Decimal) ar.get('totale');
            Decimal avgAmount = (Decimal) ar.get('media');
            
            System.debug(
                'Stato: ' + statusVal + 
                ' - Capitale Erogato: ' + sumAmount + 
                ' - Pratica Media: ' + avgAmount
            );
        }
    }
}