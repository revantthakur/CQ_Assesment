@isTest
public class TestAccountTriggerHandler {
    
    @isTest
    static void testInsertAccountWithCustomerTypeAndActive() {

        Account testAccount = new Account(
            Name = 'Test Customer Account',
            Type = 'Customer',
            Active__c = true,
            Company_Email__c = 'test@example.com',
            Phone = '1234567890',
            Account_Activation_Summary__c = 'abcd'
        );

        Test.startTest();
        insert testAccount;
        Test.stopTest();
        
        List<Contact> createdContacts = [SELECT Id FROM Contact WHERE AccountId = :testAccount.Id];
        System.assertEquals(1, createdContacts.size(), 'Expected 1 contact to be created.');
    }
    

    @isTest
    static void testInsertAccountWithNonCustomerType() {
        Account testAccount = new Account(
            Name = 'Test Account',
            Type = 'Partner',
            Active__c = true,
            Account_Activation_Summary__c = 'abcd'
        );
        
        Test.startTest();
        insert testAccount;
        Test.stopTest();
        
        List<Contact> createdContacts = [SELECT Id FROM Contact WHERE AccountId = :testAccount.Id];
        System.assertEquals(0, createdContacts.size(), 'No contact should be created.');
    }
    

    @isTest
    static void testUpdateAccountWithCustomerTypeAndActive() {
   
        Account testAccount = new Account(
            Name = 'Test Customer Account',
            Type = 'Client',
            Active__c = true,
            Company_Email__c = 'test@example.com',
            Phone = '1234567890',
            Account_Activation_Summary__c = 'abcd'
        );
        insert testAccount;
        

        testAccount.Type = 'Customer';

        Test.startTest();
        update testAccount;
        Test.stopTest();

        List<Contact> createdContacts = [SELECT Id FROM Contact WHERE AccountId = :testAccount.Id];
        System.assertEquals(1, createdContacts.size(), 'Expected 1 contact to be created after update.');
    }
    

    @isTest
    static void testUpdateAccountWithNonCustomerType() {
 
        Account testAccount = new Account(
            Name = 'Test Account',
            Type = 'Partner',
            Active__c = true,
            Account_Activation_Summary__c = 'abcd'
        );
        insert testAccount;
        
        testAccount.Type = 'Client';
        

        Test.startTest();
        update testAccount;
        Test.stopTest();

        List<Contact> createdContacts = [SELECT Id FROM Contact WHERE AccountId = :testAccount.Id];
        System.assertEquals(0, createdContacts.size(), 'No additional contact should be created.');
    }
}