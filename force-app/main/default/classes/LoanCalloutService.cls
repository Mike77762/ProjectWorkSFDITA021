public class LoanCalloutService {

    @future(callout=true)
    public static void updateInterestRateAsync(Set<Id> ids) {
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://data-api.ecb.europa.eu/service/data/FM/D.U2.EUR.4F.KR.MRR_RT.LEV?lastNObservations=1&format=jsondata');
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {

            Map<String, Object> results = 
                (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            
            Map<String, Object> dataSetsArray = 
                (Map<String, Object>) ((List<Object>) results.get('dataSets'))[0];
            
            Map<String, Object> series = 
                (Map<String, Object>) dataSetsArray.get('series');
            
            Map<String, Object> specificSeries = 
                (Map<String, Object>) series.get('0:0:0:0:0:0:0');
            
            Map<String, Object> observations = 
                (Map<String, Object>) specificSeries.get('observations');
            
            List<Object> obsValue = 
                (List<Object>) observations.get('0');
            
            Decimal bceRate = (Decimal) obsValue[0];
            
            List<Loan_Request__c> loans = [
                SELECT Id, Annual_Interest_Rate__c 
                FROM Loan_Request__c 
                WHERE Id IN :ids
                AND Annual_Interest_Rate__c = null
            ];
            
            for (Loan_Request__c loan : loans) {
                loan.Annual_Interest_Rate__c = bceRate + 2.0;
            }
            
            if (!loans.isEmpty()) {
                update loans;
            }
        }
    }
}