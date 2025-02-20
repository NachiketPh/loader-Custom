public with sharing class CSVFileReadLWCCntrl {
   
    @AuraEnabled
    public static String startCSVProcessing(Id contentDocumentId) {
        if (contentDocumentId == null) {
            throw new AuraHandledException('Invalid File ID.');
        }
        Database.executeBatch(new CSVFileReadBatch(contentDocumentId));
 
        return 'Batch processing started!';
    }
}