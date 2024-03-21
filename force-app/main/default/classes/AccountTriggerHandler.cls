public class AccountTriggerHandler {

    public static void triggerOnInsert(List<Account> newAccounts) {
        // List to store Contacts to be inserted
        List<Contact> contactsToInsert = new List<Contact>();

        for (Account acc : newAccounts) {
            // Check if the Account is a customer and active
            if (isCustomerAccount(acc)) {
                contactsToInsert.add(createContactFromAccount(acc));
            }
        }
       
        insertContacts(contactsToInsert);
    }
    
    public static void triggerOnUpdate(Map<Id, Account> newAccountsMap) {
        // List to store Contacts to be inserted

        List<Contact> contactsToInsert = new List<Contact>();
        for (Account acc : newAccountsMap.values()) {
            // Check if the Account is a customer and active, and has no related Contacts
            if (isCustomerAccount(acc) && hasNoRelatedContacts(acc.Id)) {
                contactsToInsert.add(createContactFromAccount(acc));
            }
        }

        insertContacts(contactsToInsert);
    }
    
    // Method to check if the Account is a customer
    private static boolean isCustomerAccount(Account acc) {
        return acc.Type != null && acc.Type.contains('Customer') && acc.Active__c;
    }
    
    // Method to create Contact from Account
    private static Contact createContactFromAccount(Account acc) {
        return new Contact(
            FirstName = acc.Name,
            LastName = 'Customer Representative',
            AccountId = acc.Id,
            Email = acc.Company_Email__c,
            Phone = acc.Phone
        );
    }
    
    // Method to check if the Account has no related Contacts
    private static boolean hasNoRelatedContacts(Id accountId) {
        return [SELECT COUNT() FROM Contact WHERE AccountId = :accountId] == 0;
    }
    
    // Method to insert Contacts 
    private static void insertContacts(List<Contact> contacts) {
        if (!contacts.isEmpty()) {
            insert contacts;
        }
    }
}