import { LightningElement } from 'lwc';
import startBatchImport from '@salesforce/apex/DataImportController.startBatchImport';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// document.getElementsByClassName("pressButton").addEventListener("click", function () {
//     document.getElementsByClassName("showButton").innerText = "GeeksforGeeks";
// });

export default class ParentLoader extends LightningElement {
    acceptedFormats = ['.csv']; // Accept only .csv files
    contentDocumentId; // Stores the uploaded file's document ID
    
    renderedCallback() {
        const pressButton = this.template.querySelector('.pressButton');
        const showButton = this.template.querySelector('.showButton');
        const getButton = this.template.querySelector('.getButton');
        const cancleButton = this.template.querySelector('.cancleButton');
        showButton.style.display = 'none';
        getButton.style.display = 'none';
        pressButton.addEventListener('click', () => {
            if(showButton.style.display === 'none' && getButton.style.display === 'none' ){
            showButton.style.display = 'block';
            getButton.style.display = 'block';
            cancleButton.style.display = 'block';
            }
            // else{
            //     showButton.style.display = 'none';
            //     getButton.style.display = 'none';
            //     cancleButton.style.display = 'none';
            // }
        });
        cancleButton.addEventListener('click', () => {
            showButton.style.display = 'none';
            getButton.style.display = 'none';
        });
    }

    // Handle file upload
    handleUploadFinished(event) {
        const file = event.detail.files[0];
        console.log('File Size:', file.size);  // Check if the file size is within limits (5MB)
        if (file.size > 5 * 1024 * 1024) {
            this.showToast('Error', 'File size exceeds the 5MB limit.', 'error');
            return;
        }
        this.contentDocumentId = file.documentId;
        console.log('Uploaded File Document ID:', this.contentDocumentId); // Debugging
        console.log('File Name:', file.name); // Debugging
        this.showToast('Success', 'File uploaded successfully!', 'success');
    }
   


    // Trigger batch import
    importData() {
        //check that the file is present or not 
        if (!this.contentDocumentId) {
            this.showToast('Error', 'No file uploaded.', 'error');
            return;
        }

        //Data is going to backword
        startBatchImport({ documentId: this.contentDocumentId })
            .then(result => {
                this.showToast('Success', 'Batch job started successfully!', 'info');
                // this.pollBatchStatus(result); // Poll for batch job completion
            })
            .catch(error => {
                console.error('Error starting batch job:', error);
                // this.showToast('Error', 'Failed to start batch job.', 'error');
            });
    }

    // Poll batch job status
    // pollBatchStatus(batchJobId) {
    //     const interval = setInterval(() => {
    //         checkBatchStatus({ batchJobId })
    //             .then(status => {
    //                 if (status === 'Completed') {
    //                     clearInterval(interval);
    //                     this.showToast('Success', 'Batch job completed successfully!', 'success');
    //                 } else if (status === 'Failed') {
    //                     clearInterval(interval);
    //                     this.showToast('Error', 'Batch job failed.', 'error');
    //                 }
    //             })
    //             .catch(error => {
    //                 clearInterval(interval);
    //                 console.error('Error checking batch status:', error);
    //                 this.showToast('Error', 'Failed to check batch status.', 'error');
    //             });
    //     }, 5000); // Poll every 5 seconds
    // }

    // Show toast message
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}
 
// import { LightningElement, track, api } from 'lwc';
// import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// import startCSVProcessing from '@salesforce/apex/CSVFileReadLWCCntrl.startCSVProcessing';

// export default class CSVFileReadLWC extends LightningElement {
//     @api recordId;
//     @track error;

//     get acceptedCSVFormats() {
//         return ['.csv'];
//     }

   
//     uploadFileHandler(event) {
//         const uploadedFiles = event.detail.files;
//         if (uploadedFiles.length > 0) {
//             let contentDocumentId = uploadedFiles[0].documentId;
//             startCSVProcessing({ contentDocumentId })
//                 .then((result) => {
//                     this.showToast('Success', result, 'success');
//                 })
//                 .catch((error) => {
//                     this.error = error;
//                     this.showToast('Error', 'Batch execution failed!', 'error');
//                 });
//         }
//     }
    
//     showToast(title, message, variant) {
//         this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
//     }
// }