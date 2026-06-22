public class ComplianceCalloutService {

    @future(callout=true)
    public static void predictCustomerCountry(Set<Id> accountIds) {
        
        List<Account> accounts = [
            SELECT Id, FirstName, Estimated_Country__c
            FROM Account
            WHERE Id IN :accountIds
            AND FirstName != null
        ];
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for (Account accountRecord : accounts) {
            try {
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(
                    'https://api.nationalize.io/?name=' + 
                    EncodingUtil.urlEncode(accountRecord.FirstName, 'UTF-8')
                );
                request.setMethod('GET');
                request.setHeader('Accept', 'application/json');
                HttpResponse response = http.send(request);
                
                if (response.getStatusCode() == 200) {
                    // JSON Parsing
                    Map<String, Object> root = (Map<String, Object>)
                        JSON.deserializeUntyped(response.getBody());
                    
                    List<Object> countryList = (List<Object>) root.get('country');
                    
                    if (countryList != null && !countryList.isEmpty()) {
                        Map<String, Object> firstCountry = 
                            (Map<String, Object>) countryList[0];
                        String extractedCountryId = 
                            (String) firstCountry.get('country_id');
                        accountRecord.Estimated_Country__c = extractedCountryId;
                    } else {
                        accountRecord.Estimated_Country__c = 'N/A';
                    }
                    
                    accountsToUpdate.add(accountRecord);
                }
                
            } catch (Exception e) {
                System.debug('Errore callout per Account ' + 
                    accountRecord.Id + ': ' + e.getMessage());
            }
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}