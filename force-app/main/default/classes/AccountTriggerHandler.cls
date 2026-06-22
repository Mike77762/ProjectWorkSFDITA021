public class AccountTriggerHandler {

    public static void handleAfterInsert(List<Account> newAccounts) {
        Set<Id> accountIds = new Set<Id>();
        
        for (Account acc : newAccounts) {
            if (acc.FirstName != null) {
                accountIds.add(acc.Id);
            }
        }
        
        if (!accountIds.isEmpty()) {
            ComplianceCalloutService.predictCustomerCountry(accountIds);
        }
    }
}