public with sharing class DataImportController {
    @AuraEnabled
    public static String startBatchImport(String documentId) {
        try {
            //check the DocumentId
            if (String.isEmpty(documentId)) {
                throw new AuraHandledException('Document ID cannot be null or empty');
            }

            // Read the CSV file
            ContentVersion contentVersionObj = [
                SELECT Id, VersionData
                FROM ContentVersion
                WHERE ContentDocumentId = :documentId
                LIMIT 1
            ];

            // Conversion From Bold To String
            String csvData = contentVersionObj.VersionData.toString();

            //seperation of the lines and store it in the list
            List<String> csvLines = csvData.split('\n');

            // Parse CSV and prepare JSON data
            List<Map<String, String>> records = new List<Map<String, String>>();
            if (csvLines.size() > 1) { // Ensure there are headers and at least one record

                //here We Store the Header
                String[] headers = csvLines[0].split(',');

                for (Integer i = 1; i < csvLines.size(); i++) {
                    String[] rowData = csvLines[i].split(',');
                    Map<String, String> record = new Map<String, String>();

                    //Here Mapping Of Values Done With The Header
                    for (Integer j = 0; j < headers.size(); j++) {
                        record.put(headers[j].trim(), rowData[j].trim());
                    }

                    records.add(record);
                }
            }

            System.debug('Parsed Records: ' + records);

            // Start batch job
            if (!records.isEmpty()) {
                String batchJobId = Database.executeBatch(new AccountBatchProcessor(JSON.serialize(records)), 1); 
                return batchJobId;
            } else {
                throw new AuraHandledException('No valid records found in the CSV file.');
            }
        } catch (Exception e) {
            throw new AuraHandledException('Error: ' + e.getMessage());
        }
    }

    // @AuraEnabled
    // public static String checkBatchStatus(String batchJobId) {
    //     AsyncApexJob job = [
    //         SELECT Id, Status
    //         FROM AsyncApexJob
    //         WHERE Id = :batchJobId
    //         LIMIT 1
    //     ];
    //     return job.Status;
    // }
}


// public with sharing class DataImportController {
//     @AuraEnabled
//     public static String startBatchImport(Map<String, String> contentVersion) {
//         try {
//             // Convert the map back to fields needed for ContentVersion
//             String title = contentVersion.get('Title');
//             String pathOnClient = contentVersion.get('PathOnClient');
//             String versionData = contentVersion.get('VersionData');

//             // Create ContentVersion record to store file in Salesforce
//             ContentVersion cv = new ContentVersion(
//                 Title = title,
//                 PathOnClient = pathOnClient,
//                 VersionData = EncodingUtil.base64Decode(versionData) // Decode the base64 file content
//             );

//             // Insert ContentVersion
//             insert cv;

//             // Get the ContentDocumentId
//             ContentDocument contentDocument = [
//                 SELECT Id FROM ContentDocument WHERE Id = :cv.ContentDocumentId
//                 LIMIT 1
//             ];

//             // Return the ContentDocumentId
//             return contentDocument.Id;
//         } catch (Exception e) {
//             throw new AuraHandledException('Error: ' + e.getMessage());
//         }
//     }
// }


