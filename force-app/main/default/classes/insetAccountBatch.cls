public class insetAccountBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    // List to hold accounts that need to be inserted
    private List<Account> accToInsert;

    // Constructor to accept the list of Account records to insert
    public insetAccountBatch(List<Account> acclist) {
        this.accToInsert = acclist;
    }

    // The start method returns the records to be processed by the batch
    public Database.QueryLocator start(Database.batchableContext Bc) {
        // Return a dummy query as the batch doesn't actually process anything from the database
        return Database.getQueryLocator('SELECT Id FROM Account WHERE Name != NULL');
    }

    // The execute method will insert the records passed in the constructor
    public void execute(Database.batchableContext Bc, List<sObject> scope) {
        // Insert the records passed into the batch
        if (!accToInsert.isEmpty()) {
            insert accToInsert;
        }
    }

    // The finish method is invoked after the batch completes
    public void finish(Database.batchableContext Bc) {
        // Perform any final actions, if necessary
    }

    // Expose a method to start the batch process from LWC
    @AuraEnabled
    public static void startBatchProcess(String csvData) {
        // Deserialize the CSV data and map it to Account records
        List<Map<String, String>> parsedData = (List<Map<String, String>>) JSON.deserialize(csvData, List<Map<String, String>>.class);
        List<Account> accountsToInsert = new List<Account>();

        for (Map<String, String> data : parsedData) {
            Account acc = new Account();
            acc.Name = data.get('Name');
            acc.Industry = data.get('Industry');
            acc.Email__c = data.get('Email');
            accountsToInsert.add(acc);
        }

        // Start the batch process
        if (!accountsToInsert.isEmpty()) {
            insetAccountBatch batch = new insetAccountBatch(accountsToInsert);
            Database.executeBatch(batch);
        }
    }
}
