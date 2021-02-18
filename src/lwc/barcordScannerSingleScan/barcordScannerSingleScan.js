import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getBarcodeScanner } from 'lightning/mobileCapabilities';
import { NavigationMixin } from 'lightning/navigation';

export default class barcordScannerSingleScan extends NavigationMixin(LightningElement) {
    flow_name = "ai_abstract_qr_reader";

    myScanner;
    scanButtonDisabled = false;
    scannedBarcode = '';

    // When component is initialized, detect whether to enable Scan button
    connectedCallback() {
        this.myScanner = getBarcodeScanner();
        if (this.myScanner == null || !this.myScanner.isAvailable()) {
            this.scanButtonDisabled = true;
        }
    }

    handleBeginScanClick(event) {
        // Reset scannedBarcode to empty string before starting new scan
        this.scannedBarcode = '';

        // Make sure BarcodeScanner is available before trying to use it
        // Note: We _also_ disable the Scan button if there's no BarcodeScanner
        if (this.myScanner != null && this.myScanner.isAvailable()) {
            const scanningOptions = {
                barcodeTypes: [this.myScanner.barcodeTypes.QR]
            };
            this.myScanner
                .beginCapture(scanningOptions)
                .then((result) => {
                    console.log(result);
                    this.scannedBarcode = decodeURIComponent(result.value);
                    this[NavigationMixin.GenerateUrl]({
                        type: 'standard__webPage',
                        attributes: {
                            //url: '/flow/guardqr?recordId='+result.value+'&retURL=/' + result.value
                            url: '/flow/' + this.flow_name + '?recordId='+result.value+'&retURL=/' + result.value
                        }
                    }).then(vfURL => {
                        window.open(vfURL);
                    });

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Successful Scan',
                            message: 'id : ' + result.value,
                            variant: 'success'
                        })
                    );

                })
                .catch((error) => {
                    console.error(error);

                    // Handle unexpected errors here
                    // Inform the user we ran into something unexpected
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Barcode Scanner Error',
                            message:
                                'There was a problem scanning the barcode: ' +
                                JSON.stringify(error) +
                                ' Please try again.',
                            variant: 'error',
                            mode: 'sticky'
                        })
                    );
                })
                .finally(() => {
                    console.log('#finally');

                    // Clean up by ending capture,
                    // whether we completed successfully or had an error
                    this.myScanner.endCapture();
                });
        } else {
            // BarcodeScanner is not available
            // Not running on hardware with a camera, or some other context issue
            console.log(
                'Scan Barcode button should be disabled and unclickable.'
            );
            console.log('Somehow it got clicked: ');
            console.log(event);

            // Let user know they need to use a mobile phone with a camera
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Barcode Scanner Is Not Available',
                    message:
                        'Try again from the Salesforce app on a mobile device.',
                    variant: 'error'
                })
            );
        }
    }
}