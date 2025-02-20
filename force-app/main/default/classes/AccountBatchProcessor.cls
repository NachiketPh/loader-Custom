global class AccountBatchProcessor implements Database.Batchable<sObject> {
    private List<Map<String, String>> records;

    // Constructor to receive JSON data
    public AccountBatchProcessor(String jsonData) {
        System.debug('JSON Data: ' + jsonData);
        if (!String.isEmpty(jsonData)) {
            records = (List<Map<String, String>>) JSON.(jsonData, List<Mapdeserialize<String, String>>.class);
            System.debug('Records: ' + records);
        } else {
            records = new List<Map<String, String>>();
        }
    }

    // Start method (dummy query)
    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('Starting Batch Job...');
        // Dummy query
        return Database.getQueryLocator([SELECT Id FROM Account LIMIT 1]); 
    }

    // Execute method (process records)
    global void execute(Database.BatchableContext bc, List<sObject> scope) {
        System.debug('Executing Batch Job...');
        System.debug('Records to process: ' + records);

        List<Account> accountList = new List<Account>();

        for (Map<String, String> recordData : records) {
            System.debug('Processing record: ' + recordData);

            if (String.isNotBlank(recordData.get('Name'))) { // Ensure Name is not null
                //Create the New Instance for Account
                Account acc = new Account();
                acc.Name = recordData.get('Name');
                acc.Industry = recordData.get('Industry');
                acc.Email__c = recordData.get('Email');
                accountList.add(acc);
            } else {
                System.debug('Skipping record with missing Name field.');
            }
        }

        if (!accountList.isEmpty()) {
            try {
                insert accountList;
                System.debug('Inserted ' + accountList.size() + ' accounts.');
            } catch (DmlException e) {
                System.debug('DML Exception: ' + e.getMessage());
            }
        } else {
            System.debug('No valid records found for insertion.');
        }
    }

    // Finish method
    global void finish(Database.BatchableContext bc) {
        System.debug('Batch Job Completed Successfully!');
    }
}



// global class AccountBatchProcessor implements Database.Batchable<sObject> {
//     private List<Map<String, String>> records;

//     // Constructor to accept CSV data in JSON format
//     public AccountBatchProcessor(String jsonData) {
//         if (!String.isEmpty(jsonData)) {
//             // Deserialize the JSON data to get the list of records
//             records = (List<Map<String, String>>) JSON.deserialize(jsonData, List<Map<String, String>>.class);
//         } else {
//             records = new List<Map<String, String>>();
//         }
//     }

//     // Start method to initialize batch
//     global Database.QueryLocator start(Database.BatchableContext bc) {
//         return Database.getQueryLocator([SELECT Id FROM Account LIMIT 1]);
//     }

//     // Execute method to process the records in batches
//     global void execute(Database.BatchableContext bc, List<sObject> scope) {
//         List<Account> accountList = new List<Account>();

//         for (Map<String, String> recordData : records) {
//             if (String.isNotBlank(recordData.get('Name'))) {
//                 Account acc = new Account();
//                 acc.Name = recordData.get('Name');
//                 acc.Industry = recordData.get('Industry');
//                 acc.Email__c = recordData.get('Email');
//                 accountList.add(acc);
//             }
//         }

//         // Insert the account records in Salesforce
//         if (!accountList.isEmpty()) {
//             try {
//                 insert accountList;
//             } catch (DmlException e) {
//                 System.debug('Error inserting accounts: ' + e.getMessage());
//             }
//         }
//     }

//     // Finish method to clean up after batch job
//     global void finish(Database.BatchableContext bc) {
//         System.debug('Batch Job Completed Successfully!');
//     }
// }
