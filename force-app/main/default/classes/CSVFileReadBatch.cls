global class CSVFileReadBatch implements Database.Batchable<sObject> {
    global String contentDocumentId;
    global CSVFileReadBatch(String contentDocumentId) {
        this.contentDocumentId = contentDocumentId;
    }
 
   
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId = :contentDocumentId]);
    }
 
    global void execute(Database.BatchableContext BC, List<ContentVersion> scope) {
        List<Account> accountInsertList = new List<Account>();
       
        for(ContentVersion contentVersionObj : scope) {
            String csvData = contentVersionObj.VersionData.toString();
            List<String> csvRecordsList = csvData.split('\n');
 
            for(Integer i = 1; i < csvRecordsList.size(); i++) {
                List<String> csvRowData = csvRecordsList[i].split(',');
 
                if(csvRowData.size() >= 5) {
                    Account acc = new Account();
                    acc.Name = csvRowData[0].trim();
                    acc.AccountSource = csvRowData[1].trim();
                    acc.Site = csvRowData[2].trim();
                    acc.Type = csvRowData[3].trim();
                    acc.Website = csvRowData[4].trim();
                    accountInsertList.add(acc);
                }
            }
        }
 
        if (!accountInsertList.isEmpty()) {
            insert accountInsertList;
        }
    }
 
    global void finish(Database.BatchableContext BC) {
        System.debug('Batch process completed.');
    }
}