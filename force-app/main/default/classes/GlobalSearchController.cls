public class GlobalSearchController {

    public static List<List<sObject>> searchBankRecords(String searchKey) {
        
        if (String.isBlank(searchKey) || searchKey.length() < 3) {
            return new List<List<sObject>>();
        }
        
        List<List<sObject>> searchResults = [
            FIND :searchKey IN ALL FIELDS
            RETURNING 
                Lead(Name, Email, Status),
                Account(Name, Tax_Code__c, Estimated_Country__c)
        ];
        
        return searchResults;
    }
}